Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34157 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2G0HLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 03:11:43 -0400
Received: by mail-we0-f174.google.com with SMTP id x8so1876605wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 00:11:43 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] wlcore: op_tx: pass sta explicitly when inferring frame hlid
Date: Fri, 27 Jul 2012 10:11:33 +0300
Message-Id: <1343373093-10065-3-git-send-email-arik@wizery.com> (sfid-20120727_091146_814899_1C5B3352)
In-Reply-To: <1343373093-10065-1-git-send-email-arik@wizery.com>
References: <1343373093-10065-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

avoid using the skb CB for getting the appropriate sta.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    2 +-
 drivers/net/wireless/ti/wlcore/tx.c   |   15 ++++++---------
 drivers/net/wireless/ti/wlcore/tx.h   |    4 +---
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7254860..5efd591 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1197,7 +1197,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	mapping = skb_get_queue_mapping(skb);
 	q = wl1271_tx_get_queue(mapping);
 
-	hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
+	hlid = wl12xx_tx_get_hlid(wl, wlvif, skb, info->control.sta);
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index da4a329..38b4fd1 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -130,16 +130,13 @@ bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(wl12xx_is_dummy_packet);
 
-u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			 struct sk_buff *skb)
+static u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				struct sk_buff *skb, struct ieee80211_sta *sta)
 {
-	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
-
-	if (control->control.sta) {
+	if (sta) {
 		struct wl1271_station *wl_sta;
 
-		wl_sta = (struct wl1271_station *)
-				control->control.sta->drv_priv;
+		wl_sta = (struct wl1271_station *)sta->drv_priv;
 		return wl_sta->hlid;
 	} else {
 		struct ieee80211_hdr *hdr;
@@ -156,7 +153,7 @@ u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 }
 
 u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-		      struct sk_buff *skb)
+		      struct sk_buff *skb, struct ieee80211_sta *sta)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
@@ -164,7 +161,7 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		return wl->system_hlid;
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb);
+		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb, sta);
 
 	if ((test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
 	     test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags)) &&
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 1e939b0..349520d 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -243,10 +243,8 @@ u8 wlcore_rate_to_idx(struct wl1271 *wl, u8 rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
 				enum ieee80211_band rate_band);
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set);
-u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			 struct sk_buff *skb);
 u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-		      struct sk_buff *skb);
+		      struct sk_buff *skb, struct ieee80211_sta *sta);
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
 bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb);
-- 
1.7.9.5

