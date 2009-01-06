Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50039 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751199AbZAFBli (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 20:41:38 -0500
Cc: johannes@sipsolutions.net
Content-Type: multipart/mixed; boundary="========GMX302731231206095224353"
Date: Tue, 06 Jan 2009 02:41:35 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090106014135.302730@gmx.net> (sfid-20090106_024144_979109_8122EFCF)
MIME-Version: 1.0
Subject: [PATCH] Fixed BSSID step 1: Disallow to set multicast BSSID
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX302731231206095224353
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Okay, here is the first of the five patches. After applying all of them you should be able to build/join huge city mesh networks (e.g. with the OLSR protocol) with the most of the mac80211 wireless drivers by setting a fixed BSSID in the ad hoc mode. (If you found no other bug/problem.) This was not specified in the original standard, but is a widely used de facto standard.

The first patch now completely disallow to set multicast MAC addresses as BSSID. The behavior before was really strange.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/mlme.c compat-wireless-2009-01-05.work/net/mac80211/mlme.c
--- compat-wireless-2009-01-05.orig/net/mac80211/mlme.c	2009-01-06 01:38:05.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/mlme.c	2009-01-06 01:47:41.000000000 +0100
@@ -2576,11 +2576,16 @@
 {
 	struct ieee80211_if_sta *ifsta;
 	int res;
+	bool valid;
 
 	ifsta = &sdata->u.sta;
+	valid = is_valid_ether_addr(bssid);
 
 	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
-		memcpy(ifsta->bssid, bssid, ETH_ALEN);
+		if(valid)
+			memcpy(ifsta->bssid, bssid, ETH_ALEN);
+		else
+			memset(ifsta->bssid, 0, ETH_ALEN);
 		res = 0;
 		/*
 		 * Hack! See also ieee80211_sta_set_ssid.
@@ -2594,7 +2599,7 @@
 		}
 	}
 
-	if (is_valid_ether_addr(bssid))
+	if (valid)
 		ifsta->flags |= IEEE80211_STA_BSSID_SET;
 	else
 		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

--========GMX302731231206095224353
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="step1-disallow-multicast-bssid.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="step1-disallow-multicast-bssid.patch"

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/mlme.c compat-wireless-2009-01-05.work/net/mac80211/mlme.c
--- compat-wireless-2009-01-05.orig/net/mac80211/mlme.c	2009-01-06 01:38:05.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/mlme.c	2009-01-06 01:47:41.000000000 +0100
@@ -2576,11 +2576,16 @@
 {
 	struct ieee80211_if_sta *ifsta;
 	int res;
+	bool valid;
 
 	ifsta = &sdata->u.sta;
+	valid = is_valid_ether_addr(bssid);
 
 	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
-		memcpy(ifsta->bssid, bssid, ETH_ALEN);
+		if(valid)
+			memcpy(ifsta->bssid, bssid, ETH_ALEN);
+		else
+			memset(ifsta->bssid, 0, ETH_ALEN);
 		res = 0;
 		/*
 		 * Hack! See also ieee80211_sta_set_ssid.
@@ -2594,7 +2599,7 @@
 		}
 	}
 
-	if (is_valid_ether_addr(bssid))
+	if (valid)
 		ifsta->flags |= IEEE80211_STA_BSSID_SET;
 	else
 		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;

--========GMX302731231206095224353--
