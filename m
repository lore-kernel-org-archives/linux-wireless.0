Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58463 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2K1JnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:04 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3507315wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:03 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/20] wlcore: remove support for injected Tx
Date: Wed, 28 Nov 2012 11:42:33 +0200
Message-Id: <1354095769-8724-5-git-send-email-arik@wizery.com> (sfid-20121128_104358_517531_EDE95A31)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Require each incoming packet to have a valid vif. The injected Tx code
path was buggy (and unused), so disallow it altogether.

Cleanup a few places and add a warning so we can better discover
anomalies (corrupted skbs?) masquerading as injected Tx.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c     |   13 ++++++++-----
 drivers/net/wireless/ti/wlcore/tx.c       |    5 +----
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    1 +
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 5e070ff..6ad9fc5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1200,9 +1200,13 @@ static void wl1271_op_tx(struct ieee80211_hw *hw,
 	int q, mapping;
 	u8 hlid;
 
-	if (vif)
-		wlvif = wl12xx_vif_to_data(vif);
+	if (!vif) {
+		wl1271_debug(DEBUG_TX, "DROP skb with no vif");
+		ieee80211_free_txskb(hw, skb);
+		return;
+	}
 
+	wlvif = wl12xx_vif_to_data(vif);
 	mapping = skb_get_queue_mapping(skb);
 	q = wl1271_tx_get_queue(mapping);
 
@@ -1216,7 +1220,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw,
 	 * allow these packets through.
 	 */
 	if (hlid == WL12XX_INVALID_LINK_ID ||
-	    (wlvif && !test_bit(hlid, wlvif->links_map)) ||
+	    (!test_bit(hlid, wlvif->links_map)) ||
 	     (wlcore_is_queue_stopped(wl, q) &&
 	      !wlcore_is_queue_stopped_by_reason(wl, q,
 			WLCORE_QUEUE_STOP_REASON_WATERMARK))) {
@@ -1230,8 +1234,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw,
 	skb_queue_tail(&wl->links[hlid].tx_queue[q], skb);
 
 	wl->tx_queue_count[q]++;
-	if (wlvif)
-		wlvif->tx_queue_count[q]++;
+	wlvif->tx_queue_count[q]++;
 
 	/*
 	 * The workqueue is slow to process the tx_queue and we need stop
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index dd05fab..d34945a 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -157,9 +157,6 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 {
 	struct ieee80211_tx_info *control;
 
-	if (!wlvif || wl12xx_is_dummy_packet(wl, skb))
-		return wl->system_hlid;
-
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb, sta);
 
@@ -759,7 +756,7 @@ int wlcore_tx_work_locked(struct wl1271 *wl)
 		bool has_data = false;
 
 		wlvif = NULL;
-		if (!wl12xx_is_dummy_packet(wl, skb) && info->control.vif)
+		if (!wl12xx_is_dummy_packet(wl, skb))
 			wlvif = wl12xx_vif_to_data(info->control.vif);
 		else
 			hlid = wl->system_hlid;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index a8647bd..ba59879 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -462,6 +462,7 @@ struct wl12xx_vif {
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
 {
+	WARN_ON(!vif);
 	return (struct wl12xx_vif *)vif->drv_priv;
 }
 
-- 
1.7.9.5

