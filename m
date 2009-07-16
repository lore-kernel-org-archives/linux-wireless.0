Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZGPJjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:39:37 -0400
Subject: [PATCH] cfg80211: don't optimise wext calls too much
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 11:39:04 +0200
Message-Id: <1247737144.24433.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the wext code I tried to not reconnect all the time
when the user wasn't really sure what they were doing,
like setting the BSSID back to the same value it was.
However, this optimisation should only be done while
associated so that setting the BSSID back to the same
value that it was actually triggers a new association
if not currently associated. To achieve, that, put the
relevant code into the !IDLE case instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-sme.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

--- wireless-testing.orig/net/wireless/wext-sme.c	2009-07-16 11:29:00.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-07-16 11:31:00.000000000 +0200
@@ -72,13 +72,14 @@ int cfg80211_mgd_wext_siwfreq(struct net
 	cfg80211_lock_rdev(rdev);
 	wdev_lock(wdev);
 
-	if (wdev->wext.connect.channel == chan) {
-		err = 0;
-		goto out;
-	}
-
 	if (wdev->sme_state != CFG80211_SME_IDLE) {
 		bool event = true;
+
+		if (wdev->wext.connect.channel == chan) {
+			err = 0;
+			goto out;
+		}
+
 		/* if SSID set, we'll try right again, avoid event */
 		if (wdev->wext.connect.ssid_len)
 			event = false;
@@ -164,13 +165,14 @@ int cfg80211_mgd_wext_siwessid(struct ne
 
 	err = 0;
 
-	if (wdev->wext.connect.ssid && len &&
-	    len == wdev->wext.connect.ssid_len &&
-	    memcmp(wdev->wext.connect.ssid, ssid, len) == 0)
-		goto out;
-
 	if (wdev->sme_state != CFG80211_SME_IDLE) {
 		bool event = true;
+
+		if (wdev->wext.connect.ssid && len &&
+		    len == wdev->wext.connect.ssid_len &&
+		    memcmp(wdev->wext.connect.ssid, ssid, len) == 0)
+			goto out;
+
 		/* if SSID set now, we'll try to connect, avoid event */
 		if (len)
 			event = false;
@@ -244,17 +246,17 @@ int cfg80211_mgd_wext_siwap(struct net_d
 	cfg80211_lock_rdev(wiphy_to_dev(wdev->wiphy));
 	wdev_lock(wdev);
 
-	err = 0;
-	/* both automatic */
-	if (!bssid && !wdev->wext.connect.bssid)
-		goto out;
+	if (wdev->sme_state != CFG80211_SME_IDLE) {
+		err = 0;
+		/* both automatic */
+		if (!bssid && !wdev->wext.connect.bssid)
+			goto out;
 
-	/* fixed already - and no change */
-	if (wdev->wext.connect.bssid && bssid &&
-	    compare_ether_addr(bssid, wdev->wext.connect.bssid) == 0)
-		goto out;
+		/* fixed already - and no change */
+		if (wdev->wext.connect.bssid && bssid &&
+		    compare_ether_addr(bssid, wdev->wext.connect.bssid) == 0)
+			goto out;
 
-	if (wdev->sme_state != CFG80211_SME_IDLE) {
 		err = __cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
 					    dev, WLAN_REASON_DEAUTH_LEAVING,
 					    false);


