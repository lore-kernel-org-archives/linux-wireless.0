Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44415 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751321AbZAFCBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 21:01:33 -0500
Cc: johannes@sipsolutions.net
Content-Type: multipart/mixed; boundary="========GMX302751231207290650089"
Date: Tue, 06 Jan 2009 03:01:30 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090106020130.302750@gmx.net> (sfid-20090106_030136_098028_C35F57A0)
MIME-Version: 1.0
Subject: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX302751231207290650089
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

It's completely unnecessary to merge with same BSSID. Because here in our city networks we have many of the same BSSID (and SSID) with deferent timestamps, this causes problems.

See the bug report here:
http://wiki.villagetelco.org/index.php/Information_about_cell-id_splitting%2C_stuck_beacons%2C_and_failed_IBSS_merges!#The_phenomenon_of_IBSS-ID_cell_splits

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/mlme.c compat-wireless-2009-01-05.work/net/mac80211/mlme.c
--- compat-wireless-2009-01-05.orig/net/mac80211/mlme.c	2009-01-06 02:01:46.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/mlme.c	2009-01-06 02:05:22.000000000 +0100
@@ -1705,7 +1705,8 @@
 		       (unsigned long long)(rx_timestamp - beacon_timestamp),
 		       jiffies);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-		if (beacon_timestamp > rx_timestamp) {
+		if (beacon_timestamp > rx_timestamp &&
+		    memcmp(sdata->u.sta.bssid, mgmt->bssid, ETH_ALEN) != 0) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: beacon TSF higher than "
 			       "local TSF - IBSS merge with BSSID %s\n",

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

--========GMX302751231207290650089
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="step3-dont-merge-with-the-same-bssid.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="step3-dont-merge-with-the-same-bssid.patch"

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/mlme.c compat-wireless-2009-01-05.work/net/mac80211/mlme.c
--- compat-wireless-2009-01-05.orig/net/mac80211/mlme.c	2009-01-06 02:01:46.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/mlme.c	2009-01-06 02:05:22.000000000 +0100
@@ -1705,7 +1705,8 @@
 		       (unsigned long long)(rx_timestamp - beacon_timestamp),
 		       jiffies);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-		if (beacon_timestamp > rx_timestamp) {
+		if (beacon_timestamp > rx_timestamp &&
+		    memcmp(sdata->u.sta.bssid, mgmt->bssid, ETH_ALEN) != 0) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: beacon TSF higher than "
 			       "local TSF - IBSS merge with BSSID %s\n",

--========GMX302751231207290650089--
