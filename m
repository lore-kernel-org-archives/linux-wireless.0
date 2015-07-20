Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:45645 "EHLO
	avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbbGTUWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 16:22:21 -0400
From: Marc Murphy <marcmltd@marcm.co.uk>
To: "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Subject: Patch for backtrace dump WARNING: CPU: 0 PID: 668 at
 net/wireless/sme.c:655
Date: Mon, 20 Jul 2015 20:14:40 +0000
Message-ID: <BCEC8D504C0E1149AC1D24D3F78D48EC3CB64C5B@MARCM-SBS2011.marcmltd.local> (sfid-20150720_222224_502667_601D8691)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been looking at an issue with WPA/WPA2 and joining a specific Access Point SSID that also has a hidden SSID available.  This was with 3.14.47 kernel but it is also present in all 3.x kernels.
When the AP's are being scanned it there is a warning generated stating that the bssid is empty yet when you inspect what is actually happening in the code it is because there is an SSID string but its length is 0 so it fails to return when it should.

in net/wireless/scan.c there is a function is_bss that should return the cfg80211_bss struct when it finds the matching details.  When the bssid is found but the SSID is empty (valid string "" but with length of 0) it passes through when it should return as the bssid matches.

Patch is as follows:

--- net/wireless/scan.orig.c    2015-07-20 20:56:00.437994441 +0100
+++ net/wireless/scan.c 2015-07-20 20:57:45.473715000 +0100
@@ -401,7 +401,7 @@
        if (bssid && !ether_addr_equal(a->bssid, bssid))
                return false;

-       if (!ssid)
+       if ( (!ssid) || (!ssid_len) )
                return true;

        ies = rcu_access_pointer(a->ies);


Kind Regards
Marc
