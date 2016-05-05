//
//  FaceView.swift
//  FaceIt
//
//  Created by Stanley Petley on 2016-05-05.
//  Copyright © 2016 Stanley Petley. All rights reserved.
//

import UIKit

class FaceView: UIView {
//Uncommented drawRect, Paul talks about making a centered smiley face. :)
    
    var scale: CGFloat = 0.90
    
    var mouthCurvature: Double = 1.0 // 1 full smile, -1 full frown , public var
    
    private var skullRadius: CGFloat //can't use class (i.e. bounds) in initialization phase. Changed to converted value.
        {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
//var skullCenter = convertPoint(center, fromView: superview) //converts center in this system to superview system OLD METHOD.
    private var skullCenter: CGPoint
        {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios { //create structs, then have type variables with the value, notice these are capitalized (always for Types) access by Ratios.whatever
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(arcCenter: midPoint, //this path is "around a circle" convert 2*M_PI to CGFloat, 0.0 is fine because it's a literal.
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: CGFloat(2*M_PI),
                    clockwise: false
            )
        
        path.lineWidth = 5.0
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint
    {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        //return UIBezierPath(rect: mouthRect)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature,1 ))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
    }
    
override func drawRect(rect: CGRect)
    {
        //let width = bounds.size.width //not rect, not frame, we want bounds.
        //let height = bounds.size.height //we move these directly to min parameters
        UIColor.blackColor().set()
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForMouth().stroke()
        //skull.stroke()
    }

}
