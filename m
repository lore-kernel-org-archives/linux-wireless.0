Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42152 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751384AbZAFBtK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 20:49:10 -0500
Cc: johannes@sipsolutions.net
Content-Type: multipart/mixed; boundary="========GMX302731231206547754528"
Date: Tue, 06 Jan 2009 02:49:07 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090106014907.302730@gmx.net> (sfid-20090106_024914_230811_F90605D3)
MIME-Version: 1.0
Subject: [PATCH] Fixed BSSID step 2: Don't scan if BSSID and channel are set
 manually
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX302731231206547754528
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

If you set a fixed BSSID and channel it's not necessary to scan for neighbors to merge, because you really don't want to merge with it. So don't do it.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/mlme.c compat-wireless-2009-01-05.work/net/mac80211/mlme.c
--- compat-wireless-2009-01-05.orig/net/mac80211/mlme.c	2009-01-06 01:55:57.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/mlme.c	2009-01-06 01:59:23.000000000 +0100
@@ -2031,6 +2031,10 @@
 	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
+	if ((sdata->u.sta.flags & IEEE80211_STA_BSSID_SET) &&
+	    (!(sdata->u.sta.flags & IEEE80211_STA_AUTO_CHANNEL_SEL)))
+		return;
+
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
 	ieee80211_request_scan(sdata, ifsta->ssid, ifsta->ssid_len);

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

--========GMX302731231206547754528
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="step2-dont-scan-if-bssid-and-channel-set.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="step2-dont-scan-if-bssid-and-channel-set.patch"

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/mlme.c compat-wireless-2009-01-05.work/net/mac80211/mlme.c
--- compat-wireless-2009-01-05.orig/net/mac80211/mlme.c	2009-01-06 01:55:57.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/mlme.c	2009-01-06 01:59:23.000000000 +0100
@@ -2031,6 +2031,10 @@
 	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
+	if ((sdata->u.sta.flags & IEEE80211_STA_BSSID_SET) &&
+	    (!(sdata->u.sta.flags & IEEE80211_STA_AUTO_CHANNEL_SEL)))
+		return;
+
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
 	ieee80211_request_scan(sdata, ifsta->ssid, ifsta->ssid_len);

--========GMX302731231206547754528--
