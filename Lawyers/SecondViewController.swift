//
//  SecondViewController.swift
//  Lawyers
//
//  Created by wesam swetat on 8/9/17.
//  Copyright © 2017 netix. All rights reserved.
//

import UIKit
import JTAppleCalendar
import GoogleAPIClientForREST
import GoogleSignIn

class SecondViewController: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthAndYear: UILabel!
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    let todayDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarView.scrollToDate( Date(),  animateScroll: false )
        calendarView.selectDates( [Date()] )
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates {dateSegment in self.setupCalendarView(dateSegment: dateSegment)}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        func setupCalendarView(dateSegment: DateSegmentInfo){
            guard let date = dateSegment.monthDates.first?.date else {return}
            
            formatter.dateFormat = "yyyy"
            monthAndYear.text = "\(formatter.string(from: date)) "
            formatter.dateFormat = "MMM"
            monthAndYear.text?.append(formatter.string(from: date))
    }
    
    func handelCellSelected(view: JTAppleCell, cellState: CellState){
        guard let validCell = view as? CustomCellView else {return}
        
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else{
            validCell.selectedView.isHidden = true
        }
    }
    
    func handelCellTextColor(view: JTAppleCell, cellState: CellState){
        guard let validCell = view as? CustomCellView else {return}
        
        formatter.dateFormat = "yyyy MM dd"
        
        if cellState.isSelected {
            validCell.dayShowLabel.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dayShowLabel.textColor = UIColor.black
            } else {
                validCell.dayShowLabel.textColor = UIColor.lightGray
            }
        }
        
        let todayDateString = formatter.string(from: todayDate);
        let monthDateString = formatter.string(from: cellState.date);
        
        if todayDateString == monthDateString{
            validCell.dayShowLabel.textColor = UIColor.orange
        }
    }

}

extension SecondViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = formatter.date(from: "2000 01 01")!
        let endDate = formatter.date(from: "2099 01 01")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters;
    }
    
    
}

extension SecondViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCellView", for: indexPath) as! CustomCellView
        myCell.dayShowLabel.text = cellState.text
        handelCellSelected(view: myCell, cellState: cellState)
        handelCellTextColor(view: myCell, cellState: cellState)
        return myCell
    }
    
    
        func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
           // configureCell(cell: cell!, cellState: cellState)
            guard let validCell = cell as? CustomCellView else {return}
            handelCellSelected(view: validCell, cellState: cellState)
            handelCellTextColor(view: validCell, cellState: cellState)
        }
    
        func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
           // configureCell(cell: cell!, cellState: cellState)
            guard let validCell = cell as? CustomCellView else {return}
            handelCellSelected(view: validCell, cellState: cellState)
            handelCellTextColor(view: validCell, cellState: cellState)
        }
    
        func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
             setupCalendarView(dateSegment: visibleDates)
        }
    
    
}
