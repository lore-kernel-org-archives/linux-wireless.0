Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZGGCAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:12 -0400
Message-Id: <20090707015708.504231459@sipsolutions.net>
References: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/9] cfg80211: mlme API must be able to sleep
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the mac80211 mlme cleanup, we can require that
the MLME functions in cfg80211 can sleep. This will
simplify future work in cfg80211 a lot.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |   30 +++++++++++++---------------
 net/mac80211/mlme.c    |   26 ++++++++----------------
 net/wireless/mlme.c    |   51 +++++++++++++++++++++++++++++++------------------
 3 files changed, 56 insertions(+), 51 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-07 03:37:04.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-07 03:37:04.000000000 +0200
@@ -1721,70 +1721,68 @@ void cfg80211_unlink_bss(struct wiphy *w
  * @dev: network device
  * @buf: authentication frame (header + body)
  * @len: length of the frame data
- * @gfp: allocation flags
  *
  * This function is called whenever an authentication has been processed in
  * station mode. The driver is required to call either this function or
  * cfg80211_send_auth_timeout() to indicate the result of cfg80211_ops::auth()
- * call.
+ * call. This function may sleep.
  */
-void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp);
+void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
  * cfg80211_send_auth_timeout - notification of timed out authentication
  * @dev: network device
  * @addr: The MAC address of the device with which the authentication timed out
- * @gfp: allocation flags
+ *
+ * This function may sleep.
  */
-void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr, gfp_t gfp);
+void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr);
 
 /**
  * cfg80211_send_rx_assoc - notification of processed association
  * @dev: network device
  * @buf: (re)association response frame (header + body)
  * @len: length of the frame data
- * @gfp: allocation flags
  *
  * This function is called whenever a (re)association response has been
  * processed in station mode. The driver is required to call either this
  * function or cfg80211_send_assoc_timeout() to indicate the result of
- * cfg80211_ops::assoc() call.
+ * cfg80211_ops::assoc() call. This function may sleep.
  */
-void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp);
+void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
  * cfg80211_send_assoc_timeout - notification of timed out association
  * @dev: network device
  * @addr: The MAC address of the device with which the association timed out
- * @gfp: allocation flags
+ *
+ * This function may sleep.
  */
-void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr, gfp_t gfp);
+void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr);
 
 /**
  * cfg80211_send_deauth - notification of processed deauthentication
  * @dev: network device
  * @buf: deauthentication frame (header + body)
  * @len: length of the frame data
- * @gfp: allocation flags
  *
  * This function is called whenever deauthentication has been processed in
  * station mode. This includes both received deauthentication frames and
- * locally generated ones.
+ * locally generated ones. This function may sleep.
  */
-void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp);
+void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
  * cfg80211_send_disassoc - notification of processed disassociation
  * @dev: network device
  * @buf: disassociation response frame (header + body)
  * @len: length of the frame data
- * @gfp: allocation flags
  *
  * This function is called whenever disassociation has been processed in
  * station mode. This includes both received disassociation frames and locally
- * generated ones.
+ * generated ones. This function may sleep.
  */
-void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp);
+void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
  * cfg80211_michael_mic_failure - notification of Michael MIC failure (TKIP)
--- wireless-testing.orig/net/wireless/mlme.c	2009-07-07 03:36:58.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-07 03:37:04.000000000 +0200
@@ -12,7 +12,7 @@
 #include "core.h"
 #include "nl80211.h"
 
-void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
+void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -23,6 +23,8 @@ void cfg80211_send_rx_auth(struct net_de
 	u16 status = le16_to_cpu(mgmt->u.auth.status_code);
 	bool done = false;
 
+	might_sleep();
+
 	for (i = 0; i < MAX_AUTH_BSSES; i++) {
 		if (wdev->authtry_bsses[i] &&
 		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid,
@@ -41,12 +43,12 @@ void cfg80211_send_rx_auth(struct net_de
 
 	WARN_ON(!done);
 
-	nl80211_send_rx_auth(rdev, dev, buf, len, gfp);
+	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
 	cfg80211_sme_rx_auth(dev, buf, len);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_auth);
 
-void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
+void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len)
 {
 	u16 status_code;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -57,12 +59,14 @@ void cfg80211_send_rx_assoc(struct net_d
 	int i, ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
 	bool done;
 
+	might_sleep();
+
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 
-	nl80211_send_rx_assoc(rdev, dev, buf, len, gfp);
+	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL);
 
 	cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
-				status_code, gfp);
+				status_code, GFP_KERNEL);
 
 	if (status_code == WLAN_STATUS_SUCCESS) {
 		for (i = 0; wdev->current_bss && i < MAX_AUTH_BSSES; i++) {
@@ -80,7 +84,7 @@ void cfg80211_send_rx_assoc(struct net_d
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);
 
-void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
+void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -90,7 +94,9 @@ void cfg80211_send_deauth(struct net_dev
 	int i;
 	bool done = false;
 
-	nl80211_send_deauth(rdev, dev, buf, len, gfp);
+	might_sleep();
+
+	nl80211_send_deauth(rdev, dev, buf, len, GFP_KERNEL);
 
 	if (wdev->current_bss &&
 	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
@@ -132,16 +138,17 @@ void cfg80211_send_deauth(struct net_dev
 		reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
 		from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
-		__cfg80211_disconnected(dev, gfp, NULL, 0,
+		__cfg80211_disconnected(dev, GFP_KERNEL, NULL, 0,
 					reason_code, from_ap);
 	} else if (wdev->sme_state == CFG80211_SME_CONNECTING) {
 		cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE, gfp);
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
 	}
 }
 EXPORT_SYMBOL(cfg80211_send_deauth);
 
-void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
+void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -153,7 +160,9 @@ void cfg80211_send_disassoc(struct net_d
 	bool from_ap;
 	bool done = false;
 
-	nl80211_send_disassoc(rdev, dev, buf, len, gfp);
+	might_sleep();
+
+	nl80211_send_disassoc(rdev, dev, buf, len, GFP_KERNEL);
 
 	if (!wdev->sme_state == CFG80211_SME_CONNECTED)
 		return;
@@ -177,12 +186,12 @@ void cfg80211_send_disassoc(struct net_d
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
 	from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
-	__cfg80211_disconnected(dev, gfp, NULL, 0,
+	__cfg80211_disconnected(dev, GFP_KERNEL, NULL, 0,
 				reason_code, from_ap);
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
-void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr, gfp_t gfp)
+void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -190,10 +199,13 @@ void cfg80211_send_auth_timeout(struct n
 	int i;
 	bool done = false;
 
-	nl80211_send_auth_timeout(rdev, dev, addr, gfp);
+	might_sleep();
+
+	nl80211_send_auth_timeout(rdev, dev, addr, GFP_KERNEL);
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE, gfp);
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
 
 	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
 		if (wdev->authtry_bsses[i] &&
@@ -211,7 +223,7 @@ void cfg80211_send_auth_timeout(struct n
 }
 EXPORT_SYMBOL(cfg80211_send_auth_timeout);
 
-void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr, gfp_t gfp)
+void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -219,10 +231,13 @@ void cfg80211_send_assoc_timeout(struct 
 	int i;
 	bool done = false;
 
-	nl80211_send_assoc_timeout(rdev, dev, addr, gfp);
+	might_sleep();
+
+	nl80211_send_assoc_timeout(rdev, dev, addr, GFP_KERNEL);
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE, gfp);
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
 
 	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
 		if (wdev->auth_bsses[i] &&
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-07 03:37:03.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-07 03:37:04.000000000 +0200
@@ -412,11 +412,9 @@ static void ieee80211_send_deauth_disass
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
 	if (stype == IEEE80211_STYPE_DEAUTH)
-		cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, skb->len,
-				     GFP_KERNEL);
+		cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, skb->len);
 	else
-		cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, skb->len,
-				       GFP_KERNEL);
+		cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, skb->len);
 	ieee80211_tx_skb(sdata, skb, ifmgd->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
@@ -1839,12 +1837,10 @@ static void ieee80211_sta_rx_queued_mgmt
 			/* no action */
 			break;
 		case RX_MGMT_CFG80211_DEAUTH:
-			cfg80211_send_deauth(sdata->dev, (u8 *) mgmt,
-					     skb->len, GFP_KERNEL);
+			cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
 			break;
 		case RX_MGMT_CFG80211_DISASSOC:
-			cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt,
-					       skb->len, GFP_KERNEL);
+			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
 			break;
 		default:
 			WARN(1, "unexpected: %d", rma);
@@ -1893,12 +1889,10 @@ static void ieee80211_sta_rx_queued_mgmt
 		/* no action */
 		break;
 	case RX_MGMT_CFG80211_AUTH:
-		cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, skb->len,
-				      GFP_KERNEL);
+		cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, skb->len);
 		break;
 	case RX_MGMT_CFG80211_ASSOC:
-		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, skb->len,
-				       GFP_KERNEL);
+		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, skb->len);
 		break;
 	default:
 		WARN(1, "unexpected: %d", rma);
@@ -2026,13 +2020,11 @@ static void ieee80211_sta_work(struct wo
 		switch (wk->tries) {
 		case RX_MGMT_CFG80211_AUTH_TO:
 			cfg80211_send_auth_timeout(sdata->dev,
-						   wk->bss->cbss.bssid,
-						   GFP_KERNEL);
+						   wk->bss->cbss.bssid);
 			break;
 		case RX_MGMT_CFG80211_ASSOC_TO:
-			cfg80211_send_auth_timeout(sdata->dev,
-						   wk->bss->cbss.bssid,
-						   GFP_KERNEL);
+			cfg80211_send_assoc_timeout(sdata->dev,
+						    wk->bss->cbss.bssid);
 			break;
 		default:
 			WARN(1, "unexpected: %d", wk->tries);

-- 

