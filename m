Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail37.messagelabs.com ([216.82.241.83]:19153 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0EZL6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 07:58:33 -0400
From: "Gordon, Charles" <Charles.Gordon@digi.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 May 2010 06:57:31 -0500
Subject: Is there a bug in 2.6.29-rc8 support of Ad-Hoc mode?
Message-ID: <8DCC153EAFE67A4B990A840E829F704B017C658D5E6C@mtk-sms-exch01.digi.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to get a driver I'm developing to work with Ad-Hoc mode on
Linux 2.6.29-rc8.  I am running into a problem.  I have traced it down
to the routine ieee80211_scan_work.  I use the following commands to
start Ad-Hoc mode:

ifconfig wlan0 down
iwconfig wlan0 mode Ad-Hoc essid "AdHocID"
ifconfig wlan0 up

What happens is that the iwconfig command starts a scan for other PCs
using the AdHocID before the second ifconfig command is executed
(while the interface is still down).  When ieee80211_scan_work is
executed, it bails out at this statement:

       /*
        * Avoid re-scheduling when the sdata is going away.
        */
       if (!netif_running(sdata->dev))
               return;

This aborts the scan, but leaves local->sw_scanning set.  This
prevents future scans from running.  When ieee80211_start_scan
executes it bails out at this statement:

       if (local->sw_scanning || local->hw_scanning) {
               if (local->scan_sdata == scan_sdata)
                       return 0;
               return -EBUSY;
       }

Can someone either confirm that this is a known problem with
2.6.28-rc8, or tell me what my driver could be doing to cause this
problem?

Thanks for any help you can provide.
