Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1JJIMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:39 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:38 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/29] wl12xx: unify STA and AP tx_queue mechanism
Date: Mon, 10 Oct 2011 10:12:51 +0200
Message-Id: <1318234397-21081-4-git-send-email-eliad@wizery.com> (sfid-20111010_101243_815961_89ADEF16)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sta use the global wl->links[hlid].tx_queue (by
considering its links map) instead of wl->tx_queue,
and then unify the tx and tx_reset flows for the
various vifs.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   32 ++++------
 drivers/net/wireless/wl12xx/tx.c     |  109 ++++++++++++----------------------
 drivers/net/wireless/wl12xx/tx.h     |    5 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 -
 4 files changed, 55 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0606b0d..abe5ef8 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1474,31 +1474,26 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	unsigned long flags;
 	int q, mapping;
-	u8 hlid = 0;
+	u8 hlid;
 
 	mapping = skb_get_queue_mapping(skb);
 	q = wl1271_tx_get_queue(mapping);
 
-	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		hlid = wl12xx_tx_get_hlid_ap(wl, wlvif, skb);
+	hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
 	/* queue the packet */
-	if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
-		if (!test_bit(hlid, wlvif->links_map)) {
-			wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d",
-				     hlid, q);
-			dev_kfree_skb(skb);
-			goto out;
-		}
-
-		wl1271_debug(DEBUG_TX, "queue skb hlid %d q %d", hlid, q);
-		skb_queue_tail(&wl->links[hlid].tx_queue[q], skb);
-	} else {
-		skb_queue_tail(&wl->tx_queue[q], skb);
+	if (hlid == WL12XX_INVALID_LINK_ID ||
+	    !test_bit(hlid, wlvif->links_map)) {
+		wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d", hlid, q);
+		dev_kfree_skb(skb);
+		goto out;
 	}
 
+	wl1271_debug(DEBUG_TX, "queue skb hlid %d q %d", hlid, q);
+	skb_queue_tail(&wl->links[hlid].tx_queue[q], skb);
+
 	wl->tx_queue_count[q]++;
 
 	/*
@@ -2131,7 +2126,8 @@ deinit:
 	mutex_lock(&wl->mutex);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
-	wl1271_tx_reset(wl, reset_tx_queues);
+	wl12xx_tx_reset_wlvif(wl, wlvif);
+	wl12xx_tx_reset(wl, reset_tx_queues);
 	wl1271_power_off(wl);
 
 	wl->band = IEEE80211_BAND_2GHZ;
@@ -3968,7 +3964,6 @@ static int wl1271_allocate_sta(struct wl1271 *wl,
 	return 0;
 }
 
-/* TODO: change wl1271_tx_reset(), so we can get sta as param */
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 {
 	if (!test_bit(hlid, wlvif->ap.sta_hlid_map))
@@ -4868,9 +4863,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->plat_dev = plat_dev;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
-		skb_queue_head_init(&wl->tx_queue[i]);
-
-	for (i = 0; i < NUM_TX_QUEUES; i++)
 		for (j = 0; j < WL12XX_MAX_LINKS; j++)
 			skb_queue_head_init(&wl->links[j].tx_queue[i]);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 951ff03..6c0135b 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -179,12 +179,10 @@ u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	}
 }
 
-static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct ieee80211_vif *vif,
-			     struct sk_buff *skb)
+u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		      struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-
 
 	if (wl12xx_is_dummy_packet(wl, skb))
 		return wl->system_hlid;
@@ -429,7 +427,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 			wlvif->default_key = idx;
 		}
 	}
-	hlid = wl1271_tx_get_hlid(wl, vif, skb);
+	hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
 	if (hlid == WL12XX_INVALID_LINK_ID) {
 		wl1271_error("invalid hlid. dropping skb 0x%p", skb);
 		return -EINVAL;
@@ -538,19 +536,18 @@ static struct sk_buff_head *wl1271_select_queue(struct wl1271 *wl,
 	return &queues[q];
 }
 
-static struct sk_buff *wl1271_sta_skb_dequeue(struct wl1271 *wl)
+static struct sk_buff *wl12xx_lnk_skb_dequeue(struct wl1271 *wl,
+					      struct wl1271_link *lnk)
 {
-	struct sk_buff *skb = NULL;
+	struct sk_buff *skb;
 	unsigned long flags;
 	struct sk_buff_head *queue;
 
-	queue = wl1271_select_queue(wl, wl->tx_queue);
+	queue = wl1271_select_queue(wl, lnk->tx_queue);
 	if (!queue)
-		goto out;
+		return NULL;
 
 	skb = skb_dequeue(queue);
-
-out:
 	if (skb) {
 		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		spin_lock_irqsave(&wl->wl_lock, flags);
@@ -561,13 +558,11 @@ out:
 	return skb;
 }
 
-static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl,
-					     struct wl12xx_vif *wlvif)
+static struct sk_buff *wl12xx_vif_skb_dequeue(struct wl1271 *wl,
+					      struct wl12xx_vif *wlvif)
 {
 	struct sk_buff *skb = NULL;
-	unsigned long flags;
 	int i, h, start_hlid;
-	struct sk_buff_head *queue;
 
 	/* start from the link after the last one */
 	start_hlid = (wlvif->last_tx_hlid + 1) % WL12XX_MAX_LINKS;
@@ -580,24 +575,16 @@ static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl,
 		if (!test_bit(h, wlvif->links_map))
 			continue;
 
-		queue = wl1271_select_queue(wl, wl->links[h].tx_queue);
-		if (!queue)
+		skb = wl12xx_lnk_skb_dequeue(wl, &wl->links[h]);
+		if (!skb)
 			continue;
 
-		skb = skb_dequeue(queue);
-		if (skb)
-			break;
+		wlvif->last_tx_hlid = h;
+		break;
 	}
 
-	if (skb) {
-		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
-		wlvif->last_tx_hlid = h;
-		spin_lock_irqsave(&wl->wl_lock, flags);
-		wl->tx_queue_count[q]--;
-		spin_unlock_irqrestore(&wl->wl_lock, flags);
-	} else {
+	if (!skb)
 		wlvif->last_tx_hlid = 0;
-	}
 
 	return skb;
 }
@@ -608,11 +595,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl,
 	unsigned long flags;
 	struct sk_buff *skb = NULL;
 
-	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		skb = wl1271_ap_skb_dequeue(wl, wlvif);
-	else
-		skb = wl1271_sta_skb_dequeue(wl);
-
+	skb = wl12xx_vif_skb_dequeue(wl, wlvif);
 	if (!skb &&
 	    test_and_clear_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags)) {
 		int q;
@@ -627,24 +610,21 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl,
 	return skb;
 }
 
-static void wl1271_skb_queue_head(struct wl1271 *wl, struct ieee80211_vif *vif,
+static void wl1271_skb_queue_head(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				  struct sk_buff *skb)
 {
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	unsigned long flags;
 	int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 
 	if (wl12xx_is_dummy_packet(wl, skb)) {
 		set_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags);
-	} else if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
-		u8 hlid = wl1271_tx_get_hlid(wl, vif, skb);
+	} else {
+		u8 hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
 		skb_queue_head(&wl->links[hlid].tx_queue[q], skb);
 
 		/* make sure we dequeue the same packet next time */
 		wlvif->last_tx_hlid = (hlid + WL12XX_MAX_LINKS - 1) %
-				   WL12XX_MAX_LINKS;
-	} else {
-		skb_queue_head(&wl->tx_queue[q], skb);
+				      WL12XX_MAX_LINKS;
 	}
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
@@ -682,7 +662,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl, struct ieee80211_vif *vif)
 			 * Aggregation buffer is full.
 			 * Flush buffer and try again.
 			 */
-			wl1271_skb_queue_head(wl, vif, skb);
+			wl1271_skb_queue_head(wl, wlvif, skb);
 			wl1271_write(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
 				     buf_offset, true);
 			sent_packets = true;
@@ -693,7 +673,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl, struct ieee80211_vif *vif)
 			 * Firmware buffer is full.
 			 * Queue back last skb, and stop aggregating.
 			 */
-			wl1271_skb_queue_head(wl, vif, skb);
+			wl1271_skb_queue_head(wl, wlvif, skb);
 			/* No work left, avoid scheduling redundant tx work */
 			set_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 			goto out_ack;
@@ -907,41 +887,30 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 }
 
 /* caller must hold wl->mutex and TX must be stopped */
-void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
+void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
-	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int i;
-	struct sk_buff *skb;
-	struct ieee80211_tx_info *info;
 
 	/* TX failure */
-	if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
-		for (i = 0; i < WL12XX_MAX_LINKS; i++) {
+	for_each_set_bit(i, wlvif->links_map, WL12XX_MAX_LINKS) {
+		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 			wl1271_free_sta(wl, wlvif, i);
-			wl1271_tx_reset_link_queues(wl, i);
-			wl->links[i].allocated_pkts = 0;
-			wl->links[i].prev_freed_pkts = 0;
-		}
-
-		wlvif->last_tx_hlid = 0;
-	} else {
-		for (i = 0; i < NUM_TX_QUEUES; i++) {
-			while ((skb = skb_dequeue(&wl->tx_queue[i]))) {
-				wl1271_debug(DEBUG_TX, "freeing skb 0x%p",
-					     skb);
-
-				if (!wl12xx_is_dummy_packet(wl, skb)) {
-					info = IEEE80211_SKB_CB(skb);
-					info->status.rates[0].idx = -1;
-					info->status.rates[0].count = 0;
-					ieee80211_tx_status_ni(wl->hw, skb);
-				}
-			}
-		}
+		else
+			wlvif->sta.ba_rx_bitmap = 0;
 
-		wlvif->sta.ba_rx_bitmap = 0;
+		wl1271_tx_reset_link_queues(wl, i);
+		wl->links[i].allocated_pkts = 0;
+		wl->links[i].prev_freed_pkts = 0;
 	}
+	wlvif->last_tx_hlid = 0;
+
+}
+/* caller must hold wl->mutex and TX must be stopped */
+void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
+{
+	int i;
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_queue_count[i] = 0;
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index add4402..050a047 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -206,7 +206,8 @@ static inline int wl1271_tx_total_queue_count(struct wl1271 *wl)
 void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_work_locked(struct wl1271 *wl, struct ieee80211_vif *vif);
 void wl1271_tx_complete(struct wl1271 *wl);
-void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues);
+void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues);
 void wl1271_tx_flush(struct wl1271 *wl);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
@@ -214,6 +215,8 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set);
 u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			 struct sk_buff *skb);
+u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		      struct sk_buff *skb);
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
 bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b350f0b..4802f68 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -416,7 +416,6 @@ struct wl1271 {
 	s64 time_offset;
 
 	/* Frames scheduled for transmission, not handled yet */
-	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
 	int tx_queue_count[NUM_TX_QUEUES];
 	long stopped_queues_map;
 
-- 
1.7.6.401.g6a319

