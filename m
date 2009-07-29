Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZG2ILD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 04:11:03 -0400
Subject: [PATCH] cfg80211: keep track of current_bss for userspace SME
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 10:10:29 +0200
Message-Id: <1248855029.13742.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a userspace SME is active, we're currently not
keeping track of the BSS properly for reporting the
current link and for internal use. Additionally, it
looks like there is a possible BSS leak in that the
BSS never gets removed from auth_bsses[]. To fix it,
pass the BSS struct to __cfg80211_connect_result in
this case.

This patch leaves a small race condition window in
which the BSS may be recycled because it isn't held,
I'll fix that separately by making the hold info a
refcount.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |    3 ++-
 net/wireless/core.h |    3 ++-
 net/wireless/mlme.c |   29 ++++++++++++++++-------------
 net/wireless/sme.c  |   35 ++++++++++++++++++-----------------
 4 files changed, 38 insertions(+), 32 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-29 01:08:03.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-29 01:08:58.000000000 +0200
@@ -314,7 +314,8 @@ static void cfg80211_process_events(stru
 				ev->cr.req_ie, ev->cr.req_ie_len,
 				ev->cr.resp_ie, ev->cr.resp_ie_len,
 				ev->cr.status,
-				ev->cr.status == WLAN_STATUS_SUCCESS);
+				ev->cr.status == WLAN_STATUS_SUCCESS,
+				NULL);
 			break;
 		case EVENT_ROAMED:
 			__cfg80211_roamed(wdev, ev->rm.bssid,
--- wireless-testing.orig/net/wireless/core.h	2009-07-29 01:08:03.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-29 01:08:21.000000000 +0200
@@ -323,7 +323,8 @@ void cfg80211_mlme_down(struct cfg80211_
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
-			       u16 status, bool wextev);
+			       u16 status, bool wextev,
+			       struct cfg80211_bss *bss);
 
 /* SME */
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
--- wireless-testing.orig/net/wireless/mlme.c	2009-07-29 01:08:03.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-29 01:44:03.000000000 +0200
@@ -61,7 +61,7 @@ void cfg80211_send_rx_assoc(struct net_d
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	u8 *ie = mgmt->u.assoc_resp.variable;
 	int i, ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
-	bool done;
+	struct cfg80211_internal_bss *bss = NULL;
 
 	wdev_lock(wdev);
 
@@ -69,24 +69,27 @@ void cfg80211_send_rx_assoc(struct net_d
 
 	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL);
 
-	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
-				  status_code,
-				  status_code == WLAN_STATUS_SUCCESS);
-
 	if (status_code == WLAN_STATUS_SUCCESS) {
-		for (i = 0; wdev->current_bss && i < MAX_AUTH_BSSES; i++) {
-			if (wdev->auth_bsses[i] == wdev->current_bss) {
+		for (i = 0; i < MAX_AUTH_BSSES; i++) {
+			if (!wdev->auth_bsses[i])
+				continue;
+			if (memcmp(wdev->auth_bsses[i]->pub.bssid, mgmt->bssid,
+				   ETH_ALEN) == 0) {
+				bss = wdev->auth_bsses[i];
 				cfg80211_unhold_bss(wdev->auth_bsses[i]);
-				cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
 				wdev->auth_bsses[i] = NULL;
-				done = true;
 				break;
 			}
 		}
 
-		WARN_ON(!done);
+		WARN_ON(!bss);
 	}
 
+	/* this consumes the 'bss' reference, if not NULL */
+	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
+				  status_code,
+				  status_code == WLAN_STATUS_SUCCESS,
+				  bss ? &bss->pub : NULL);
 	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);
@@ -144,7 +147,7 @@ static void __cfg80211_send_deauth(struc
 	} else if (wdev->sme_state == CFG80211_SME_CONNECTING) {
 		__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, NULL, 0,
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
-					  false);
+					  false, NULL);
 	}
 }
 
@@ -241,7 +244,7 @@ void cfg80211_send_auth_timeout(struct n
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		__cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
-					  false);
+					  false, NULL);
 
 	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
 		if (wdev->authtry_bsses[i] &&
@@ -275,7 +278,7 @@ void cfg80211_send_assoc_timeout(struct 
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		__cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
-					  false);
+					  false, NULL);
 
 	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
 		if (wdev->auth_bsses[i] &&
--- wireless-testing.orig/net/wireless/sme.c	2009-07-29 01:07:07.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-29 01:10:28.000000000 +0200
@@ -182,7 +182,7 @@ void cfg80211_conn_work(struct work_stru
 					wdev->conn->params.bssid,
 					NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
-					false);
+					false, NULL);
 		wdev_unlock(wdev);
 	}
 
@@ -247,7 +247,7 @@ static void __cfg80211_sme_scan_done(str
 					wdev->conn->params.bssid,
 					NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
-					false);
+					false, NULL);
 	}
 }
 
@@ -305,7 +305,7 @@ void cfg80211_sme_rx_auth(struct net_dev
 		schedule_work(&rdev->conn_work);
 	} else if (status_code != WLAN_STATUS_SUCCESS) {
 		__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, NULL, 0,
-					  status_code, false);
+					  status_code, false, NULL);
 	} else if (wdev->sme_state == CFG80211_SME_CONNECTING &&
 		 wdev->conn->state == CFG80211_CONN_AUTHENTICATING) {
 		wdev->conn->state = CFG80211_CONN_ASSOCIATE_NEXT;
@@ -316,10 +316,10 @@ void cfg80211_sme_rx_auth(struct net_dev
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
-			       u16 status, bool wextev)
+			       u16 status, bool wextev,
+			       struct cfg80211_bss *bss)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_bss *bss;
 #ifdef CONFIG_WIRELESS_EXT
 	union iwreq_data wrqu;
 #endif
@@ -361,6 +361,12 @@ void __cfg80211_connect_result(struct ne
 	}
 #endif
 
+	if (wdev->current_bss) {
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(&wdev->current_bss->pub);
+		wdev->current_bss = NULL;
+	}
+
 	if (status == WLAN_STATUS_SUCCESS &&
 	    wdev->sme_state == CFG80211_SME_IDLE)
 		goto success;
@@ -368,12 +374,6 @@ void __cfg80211_connect_result(struct ne
 	if (wdev->sme_state != CFG80211_SME_CONNECTING)
 		return;
 
-	if (wdev->current_bss) {
-		cfg80211_unhold_bss(wdev->current_bss);
-		cfg80211_put_bss(&wdev->current_bss->pub);
-		wdev->current_bss = NULL;
-	}
-
 	if (wdev->conn)
 		wdev->conn->state = CFG80211_CONN_IDLE;
 
@@ -386,10 +386,12 @@ void __cfg80211_connect_result(struct ne
 		return;
 	}
 
-	bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
-			       wdev->ssid, wdev->ssid_len,
-			       WLAN_CAPABILITY_ESS,
-			       WLAN_CAPABILITY_ESS);
+ success:
+ 	if (!bss)
+		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+				       wdev->ssid, wdev->ssid_len,
+				       WLAN_CAPABILITY_ESS,
+				       WLAN_CAPABILITY_ESS);
 
 	if (WARN_ON(!bss))
 		return;
@@ -397,7 +399,6 @@ void __cfg80211_connect_result(struct ne
 	cfg80211_hold_bss(bss_from_pub(bss));
 	wdev->current_bss = bss_from_pub(bss);
 
- success:
 	wdev->sme_state = CFG80211_SME_CONNECTED;
 	cfg80211_upload_connect_keys(wdev);
 }
@@ -788,7 +789,7 @@ int __cfg80211_disconnect(struct cfg8021
 	else if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		__cfg80211_connect_result(dev, NULL, NULL, 0, NULL, 0,
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
-					  wextev);
+					  wextev, NULL);
 
 	return 0;
 }


