Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:54807 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2EHCSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 22:18:55 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [WIP v2] rtlwifi: rtl8192su subdriver
Date: Mon, 7 May 2012 22:18:32 -0400
Message-ID: <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu> (sfid-20120508_041859_445441_7ECF79A6)
In-Reply-To: <4FA212D9.5020602@gtri.gatech.edu>
References: <4FA212D9.5020602@gtri.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

A few things have changed between this and the previous version.  Larry Finger's patch for handling the race condition with mac80211 and the firmware callback is used instead (rtlwifi: fix for race condition when firmware is cached), and a new patch for disabling the LEDs in the usb core is added (mirroring rtl_pci_stop).  All patches were rebased on wireless-testing from the 3rd.  The subdriver handles shutdown much better, although there is still room for improvement.  Some differences from rtl8192se were eliminated, although all PHY/BB/RF reg commands are still commented out.  When any of those regs were accessed directly, the device would die.  When accessed through the IOCMD regs, the firmware on the device would seem to disable automatic control of some important functions causing a large drop in receive sensitivity and general performance.
I discovered the RXFILTERMAP registers were set by the firmware after download causing the firmware to handle many management frames; allowing everything but beacons through still does not allow an association/authentication against a WPA2-PSK AP to succeed.  The AP sees a probe request and sends a probe response, but the driver never sees the response.  There are firmware commands available for offloading the joining of a BSS and the authentication bits which are likely the easiest solution.  Also needing fixing are a few WARNs, for example if you happen to unload the module during a scan.  Finally, the site survey results are now properly handed off to cfg80211.

Thanks,

Josh

