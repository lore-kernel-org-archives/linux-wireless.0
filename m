Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54516 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1956646AbdDZH7I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:59:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 26 Apr 2017 10:58:49 +0300
Message-Id: <20170426075854.13546-5-luca@coelho.fi> (sfid-20170426_095918_194711_87864FA7)
In-Reply-To: <20170426075854.13546-1-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
Subject: [PATCH 4/9] cfg80211: unify cfg80211_roamed() and cfg80211_roamed_bss()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

cfg80211_roamed() and cfg80211_roamed_bss() take the same arguments
except that cfg80211_roamed() requires the BSSID and
cfg80211_roamed_bss() requires the bss entry.

Unify the two functions by using a struct for driver initiated
roaming information so that either the BSSID or the bss entry can be
passed as an argument to the unified function.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
[modified the ath6k, brcm80211, rndis and wlan-ng drivers accordingly]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         | 10 ++-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 13 +++-
 drivers/net/wireless/rndis_wlan.c                  | 19 +++--
 drivers/staging/wlan-ng/cfg80211.c                 |  7 +-
 include/net/cfg80211.h                             | 58 +++++++-------
 net/wireless/core.h                                | 12 +--
 net/wireless/nl80211.c                             | 18 +++--
 net/wireless/nl80211.h                             |  5 +-
 net/wireless/sme.c                                 | 90 +++++++++-------------
 net/wireless/util.c                                |  4 +-
 10 files changed, 115 insertions(+), 121 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0c118b7c362c..e1567a530274 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -806,9 +806,15 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 					WLAN_STATUS_SUCCESS, GFP_KERNEL);
 		cfg80211_put_bss(ar->wiphy, bss);
 	} else if (vif->sme_state == SME_CONNECTED) {
+		struct cfg80211_roam_info roam_info = {
+			.bss = bss,
+			.req_ie = assoc_req_ie,
+			.req_ie_len = assoc_req_len,
+			.resp_ie = assoc_resp_ie,
+			.resp_ie_len = assoc_resp_len,
+		};
 		/* inform roam event to cfg80211 */
-		cfg80211_roamed_bss(vif->ndev, bss, assoc_req_ie, assoc_req_len,
-				    assoc_resp_ie, assoc_resp_len, GFP_KERNEL);
+		cfg80211_roamed(vif->ndev, &roam_info, GFP_KERNEL);
 	}
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 8c7f1ef288c6..a36bccbb40e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5359,6 +5359,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	struct ieee80211_supported_band *band;
 	struct brcmf_bss_info_le *bi;
 	struct brcmu_chan ch;
+	struct cfg80211_roam_info roam_info = {};
 	u32 freq;
 	s32 err = 0;
 	u8 *buf;
@@ -5397,9 +5398,15 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 
 done:
 	kfree(buf);
-	cfg80211_roamed(ndev, notify_channel, (u8 *)profile->bssid,
-			conn_info->req_ie, conn_info->req_ie_len,
-			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
+
+	roam_info.channel = notify_channel;
+	roam_info.bssid = (u8*)profile->bssid;
+	roam_info.req_ie = conn_info->req_ie;
+	roam_info.req_ie_len = conn_info->req_ie_len;
+	roam_info.resp_ie = conn_info->resp_ie;
+	roam_info.resp_ie_len = conn_info->resp_ie_len;
+
+	cfg80211_roamed(ndev, &roam_info, GFP_KERNEL);
 	brcmf_dbg(CONN, "Report roaming result\n");
 
 	set_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index eb513628d801..37ae24cbf00e 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2830,15 +2830,22 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 	}
 
 	if (priv->infra_mode == NDIS_80211_INFRA_INFRA) {
-		if (!roamed)
+		if (!roamed) {
 			cfg80211_connect_result(usbdev->net, bssid, req_ie,
 						req_ie_len, resp_ie,
 						resp_ie_len, 0, GFP_KERNEL);
-		else
-			cfg80211_roamed(usbdev->net,
-					get_current_channel(usbdev, NULL),
-					bssid, req_ie, req_ie_len,
-					resp_ie, resp_ie_len, GFP_KERNEL);
+		} else {
+			struct cfg80211_roam_info roam_info = {
+				.channel = get_current_channel(usbdev, NULL),
+				.bssid = bssid,
+				.req_ie = req_ie,
+				.req_ie_len = req_ie_len,
+				.resp_ie = resp_ie,
+				.resp_ie_len = resp_ie_len,
+			};
+
+			cfg80211_roamed(usbdev->net, &roam_info, GFP_KERNEL);
+		}
 	} else if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
 		cfg80211_ibss_joined(usbdev->net, bssid,
 				     get_current_channel(usbdev, NULL),
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index cbb3388a9756..178f6f5d4613 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -666,8 +666,11 @@ void prism2_disconnected(struct wlandevice *wlandev)
 
 void prism2_roamed(struct wlandevice *wlandev)
 {
-	cfg80211_roamed(wlandev->netdev, NULL, wlandev->bssid,
-			NULL, 0, NULL, 0, GFP_KERNEL);
+	struct cfg80211_roam_info roam_info = {
+		.bssid = wlandev->bssid,
+	};
+
+	cfg80211_roamed(wlandev->netdev, &roam_info, GFP_KERNEL);
 }
 
 /* Structures for declaring wiphy interface */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2a200b964b7a..115f6fc5a34d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2678,8 +2678,7 @@ struct cfg80211_nan_func {
  *	indication of requesting reassociation.
  *	In both the driver-initiated and new connect() call initiated roaming
  *	cases, the result of roaming is indicated with a call to
- *	cfg80211_roamed() or cfg80211_roamed_bss().
- *	(invoked with the wireless_dev mutex held)
+ *	cfg80211_roamed(). (invoked with the wireless_dev mutex held)
  * @update_connect_params: Update the connect parameters while connected to a
  *	BSS. The updated parameters can be used by driver/firmware for
  *	subsequent BSS selection (roaming) decisions and to form the
@@ -5376,51 +5375,46 @@ cfg80211_connect_timeout(struct net_device *dev, const u8 *bssid,
 }
 
 /**
- * cfg80211_roamed - notify cfg80211 of roaming
+ * struct cfg80211_roam_info - driver initiated roaming information
  *
- * @dev: network device
  * @channel: the channel of the new AP
- * @bssid: the BSSID of the new AP
+ * @bss: entry of bss to which STA got roamed (may be %NULL if %bssid is set)
+ * @bssid: the BSSID of the new AP (may be %NULL if %bss is set)
  * @req_ie: association request IEs (maybe be %NULL)
  * @req_ie_len: association request IEs length
  * @resp_ie: association response IEs (may be %NULL)
  * @resp_ie_len: assoc response IEs length
- * @gfp: allocation flags
- *
- * It should be called by the underlying driver whenever it roamed
- * from one AP to another while connected.
  */
-void cfg80211_roamed(struct net_device *dev,
-		     struct ieee80211_channel *channel,
-		     const u8 *bssid,
-		     const u8 *req_ie, size_t req_ie_len,
-		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp);
+struct cfg80211_roam_info {
+	struct ieee80211_channel *channel;
+	struct cfg80211_bss *bss;
+	const u8 *bssid;
+	const u8 *req_ie;
+	size_t req_ie_len;
+	const u8 *resp_ie;
+	size_t resp_ie_len;
+};
 
 /**
- * cfg80211_roamed_bss - notify cfg80211 of roaming
+ * cfg80211_roamed - notify cfg80211 of roaming
  *
  * @dev: network device
- * @bss: entry of bss to which STA got roamed
- * @req_ie: association request IEs (maybe be %NULL)
- * @req_ie_len: association request IEs length
- * @resp_ie: association response IEs (may be %NULL)
- * @resp_ie_len: assoc response IEs length
+ * @info: information about the new BSS. struct &cfg80211_roam_info.
  * @gfp: allocation flags
  *
- * This is just a wrapper to notify cfg80211 of roaming event with driver
- * passing bss to avoid a race in timeout of the bss entry. It should be
- * called by the underlying driver whenever it roamed from one AP to another
- * while connected. Drivers which have roaming implemented in firmware
- * may use this function to avoid a race in bss entry timeout where the bss
- * entry of the new AP is seen in the driver, but gets timed out by the time
- * it is accessed in __cfg80211_roamed() due to delay in scheduling
+ * This function may be called with the driver passing either the BSSID of the
+ * new AP or passing the bss entry to avoid a race in timeout of the bss entry.
+ * It should be called by the underlying driver whenever it roamed from one AP
+ * to another while connected. Drivers which have roaming implemented in
+ * firmware should pass the bss entry to avoid a race in bss entry timeout where
+ * the bss entry of the new AP is seen in the driver, but gets timed out by the
+ * time it is accessed in __cfg80211_roamed() due to delay in scheduling
  * rdev->event_work. In case of any failures, the reference is released
- * either in cfg80211_roamed_bss() or in __cfg80211_romed(), Otherwise,
- * it will be released while diconneting from the current bss.
+ * either in cfg80211_roamed() or in __cfg80211_romed(), Otherwise, it will be
+ * released while diconneting from the current bss.
  */
-void cfg80211_roamed_bss(struct net_device *dev, struct cfg80211_bss *bss,
-			 const u8 *req_ie, size_t req_ie_len,
-			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp);
+void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
+		     gfp_t gfp);
 
 /**
  * cfg80211_disconnected - notify cfg80211 that connection was dropped
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5d27eca57d3b..5366aed49e5c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -227,13 +227,7 @@ struct cfg80211_event {
 
 	union {
 		struct cfg80211_connect_resp_params cr;
-		struct {
-			const u8 *req_ie;
-			const u8 *resp_ie;
-			size_t req_ie_len;
-			size_t resp_ie_len;
-			struct cfg80211_bss *bss;
-		} rm;
+		struct cfg80211_roam_info rm;
 		struct {
 			const u8 *ie;
 			size_t ie_len;
@@ -398,9 +392,7 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u16 reason,
 			bool wextev);
 void __cfg80211_roamed(struct wireless_dev *wdev,
-		       struct cfg80211_bss *bss,
-		       const u8 *req_ie, size_t req_ie_len,
-		       const u8 *resp_ie, size_t resp_ie_len);
+		       struct cfg80211_roam_info *info);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
 void cfg80211_autodisconnect_wk(struct work_struct *work);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 50c35affccad..ab9036e2d622 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13596,14 +13596,14 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 }
 
 void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
-			 struct net_device *netdev, const u8 *bssid,
-			 const u8 *req_ie, size_t req_ie_len,
-			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
+			 struct net_device *netdev,
+			 struct cfg80211_roam_info *info, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
+	const u8 *bssid = info->bss ? info->bss->bssid : info->bssid;
 
-	msg = nlmsg_new(100 + req_ie_len + resp_ie_len, gfp);
+	msg = nlmsg_new(100 + info->req_ie_len + info->resp_ie_len, gfp);
 	if (!msg)
 		return;
 
@@ -13616,10 +13616,12 @@ void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid) ||
-	    (req_ie &&
-	     nla_put(msg, NL80211_ATTR_REQ_IE, req_ie_len, req_ie)) ||
-	    (resp_ie &&
-	     nla_put(msg, NL80211_ATTR_RESP_IE, resp_ie_len, resp_ie)))
+	    (info->req_ie &&
+	     nla_put(msg, NL80211_ATTR_REQ_IE, info->req_ie_len,
+		     info->req_ie)) ||
+	    (info->resp_ie &&
+	     nla_put(msg, NL80211_ATTR_RESP_IE, info->resp_ie_len,
+		     info->resp_ie)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index d5f6860e62ab..b96933322077 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -56,9 +56,8 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 				 struct cfg80211_connect_resp_params *params,
 				 gfp_t gfp);
 void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
-			 struct net_device *netdev, const u8 *bssid,
-			 const u8 *req_ie, size_t req_ie_len,
-			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp);
+			 struct net_device *netdev,
+			 struct cfg80211_roam_info *info, gfp_t gfp);
 void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u16 reason,
 			       const u8 *ie, size_t ie_len, bool from_ap);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6459bb7c21f7..532a0007ce82 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -5,6 +5,7 @@
  *
  * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
  * Copyright (C) 2009   Intel Corporation. All rights reserved.
+ * Copyright 2017	Intel Deutschland GmbH
  */
 
 #include <linux/etherdevice.h>
@@ -870,9 +871,7 @@ EXPORT_SYMBOL(cfg80211_connect_done);
 
 /* Consumes bss object one way or another */
 void __cfg80211_roamed(struct wireless_dev *wdev,
-		       struct cfg80211_bss *bss,
-		       const u8 *req_ie, size_t req_ie_len,
-		       const u8 *resp_ie, size_t resp_ie_len)
+		       struct cfg80211_roam_info *info)
 {
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
@@ -890,97 +889,84 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
 	cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
 	wdev->current_bss = NULL;
 
-	cfg80211_hold_bss(bss_from_pub(bss));
-	wdev->current_bss = bss_from_pub(bss);
+	if (WARN_ON(!info->bss))
+		return;
+
+	cfg80211_hold_bss(bss_from_pub(info->bss));
+	wdev->current_bss = bss_from_pub(info->bss);
 
 	nl80211_send_roamed(wiphy_to_rdev(wdev->wiphy),
-			    wdev->netdev, bss->bssid,
-			    req_ie, req_ie_len, resp_ie, resp_ie_len,
-			    GFP_KERNEL);
+			    wdev->netdev, info, GFP_KERNEL);
 
 #ifdef CONFIG_CFG80211_WEXT
-	if (req_ie) {
+	if (info->req_ie) {
 		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.length = req_ie_len;
+		wrqu.data.length = info->req_ie_len;
 		wireless_send_event(wdev->netdev, IWEVASSOCREQIE,
-				    &wrqu, req_ie);
+				    &wrqu, info->req_ie);
 	}
 
-	if (resp_ie) {
+	if (info->resp_ie) {
 		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.length = resp_ie_len;
+		wrqu.data.length = info->resp_ie_len;
 		wireless_send_event(wdev->netdev, IWEVASSOCRESPIE,
-				    &wrqu, resp_ie);
+				    &wrqu, info->resp_ie);
 	}
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
-	memcpy(wdev->wext.prev_bssid, bss->bssid, ETH_ALEN);
+	memcpy(wrqu.ap_addr.sa_data, info->bss->bssid, ETH_ALEN);
+	memcpy(wdev->wext.prev_bssid, info->bss->bssid, ETH_ALEN);
 	wdev->wext.prev_bssid_valid = true;
 	wireless_send_event(wdev->netdev, SIOCGIWAP, &wrqu, NULL);
 #endif
 
 	return;
 out:
-	cfg80211_put_bss(wdev->wiphy, bss);
-}
-
-void cfg80211_roamed(struct net_device *dev,
-		     struct ieee80211_channel *channel,
-		     const u8 *bssid,
-		     const u8 *req_ie, size_t req_ie_len,
-		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_bss *bss;
-
-	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, wdev->ssid,
-			       wdev->ssid_len,
-			       wdev->conn_bss_type, IEEE80211_PRIVACY_ANY);
-	if (WARN_ON(!bss))
-		return;
-
-	cfg80211_roamed_bss(dev, bss, req_ie, req_ie_len, resp_ie,
-			    resp_ie_len, gfp);
+	cfg80211_put_bss(wdev->wiphy, info->bss);
 }
-EXPORT_SYMBOL(cfg80211_roamed);
 
-/* Consumes bss object one way or another */
-void cfg80211_roamed_bss(struct net_device *dev,
-			 struct cfg80211_bss *bss, const u8 *req_ie,
-			 size_t req_ie_len, const u8 *resp_ie,
-			 size_t resp_ie_len, gfp_t gfp)
+/* Consumes info->bss object one way or another */
+void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
+		     gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
-	if (WARN_ON(!bss))
+	if (!info->bss) {
+		info->bss = cfg80211_get_bss(wdev->wiphy, info->channel,
+					     info->bssid, wdev->ssid,
+					     wdev->ssid_len,
+					     wdev->conn_bss_type,
+					     IEEE80211_PRIVACY_ANY);
+	}
+
+	if (WARN_ON(!info->bss))
 		return;
 
-	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
+	ev = kzalloc(sizeof(*ev) + info->req_ie_len + info->resp_ie_len, gfp);
 	if (!ev) {
-		cfg80211_put_bss(wdev->wiphy, bss);
+		cfg80211_put_bss(wdev->wiphy, info->bss);
 		return;
 	}
 
 	ev->type = EVENT_ROAMED;
 	ev->rm.req_ie = ((u8 *)ev) + sizeof(*ev);
-	ev->rm.req_ie_len = req_ie_len;
-	memcpy((void *)ev->rm.req_ie, req_ie, req_ie_len);
-	ev->rm.resp_ie = ((u8 *)ev) + sizeof(*ev) + req_ie_len;
-	ev->rm.resp_ie_len = resp_ie_len;
-	memcpy((void *)ev->rm.resp_ie, resp_ie, resp_ie_len);
-	ev->rm.bss = bss;
+	ev->rm.req_ie_len = info->req_ie_len;
+	memcpy((void *)ev->rm.req_ie, info->req_ie, info->req_ie_len);
+	ev->rm.resp_ie = ((u8 *)ev) + sizeof(*ev) + info->req_ie_len;
+	ev->rm.resp_ie_len = info->resp_ie_len;
+	memcpy((void *)ev->rm.resp_ie, info->resp_ie, info->resp_ie_len);
+	ev->rm.bss = info->bss;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
 	spin_unlock_irqrestore(&wdev->event_lock, flags);
 	queue_work(cfg80211_wq, &rdev->event_work);
 }
-EXPORT_SYMBOL(cfg80211_roamed_bss);
+EXPORT_SYMBOL(cfg80211_roamed);
 
 void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 			     size_t ie_len, u16 reason, bool from_ap)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index a46bc42d0910..7198373e2920 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -946,9 +946,7 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 				ev->cr.status == WLAN_STATUS_SUCCESS);
 			break;
 		case EVENT_ROAMED:
-			__cfg80211_roamed(wdev, ev->rm.bss, ev->rm.req_ie,
-					  ev->rm.req_ie_len, ev->rm.resp_ie,
-					  ev->rm.resp_ie_len);
+			__cfg80211_roamed(wdev, &ev->rm);
 			break;
 		case EVENT_DISCONNECTED:
 			__cfg80211_disconnected(wdev->netdev,
-- 
2.11.0
