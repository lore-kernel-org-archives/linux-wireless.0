Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f227.google.com ([209.85.217.227]:46062 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab0EZAA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 20:00:28 -0400
Received: by gxk27 with SMTP id 27so1787230gxk.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 17:00:27 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 May 2010 20:00:27 -0400
Message-ID: <AANLkTin75H4DDeTvCRCDOrmif_He4b_TCC_dQzgdeVEz@mail.gmail.com>
Subject: Is there a bug in 2.6.29-rc8 support of Ad-Hoc mode?
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to get a driver I'm developing to work with Ad-Hoc mode on
Linux 2.6.29-rc8.  I am running into a problem.  I have traced it down
to the routine ieee80211_scan_work.  I use the following commands to
start Ad-Hoc mode:

ifconfig wlan0 down
iwconfig wlan0 mode Ad-Hoc essid "AdHocID"
ifconfig wlan0 up

What happens is that the iwconfig command starts a scan for other PCs
using the AdHocID before the second ifconfig command is executed
(while the interface is still down).  When ieee80211_scan_work is
executed, it bails out at this statement:

	/*
	 * Avoid re-scheduling when the sdata is going away.
	 */
	if (!netif_running(sdata->dev))
		return;

This aborts the scan, but leaves local->sw_scanning set.  This
prevents future scans from running.  When ieee80211_start_scan
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
