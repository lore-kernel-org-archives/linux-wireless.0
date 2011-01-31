Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46371 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab1AaLQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:16:44 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so5465134fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 03:16:43 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 03/10] wl12xx: AP-mode - TX queue per link in AC
Date: Mon, 31 Jan 2011 13:16:22 +0200
Message-Id: <1296472589-26401-4-git-send-email-arik@wizery.com>
In-Reply-To: <1296472589-26401-1-git-send-email-arik@wizery.com>
References: <1296472589-26401-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in AP-mode we require a per link tx-queue.
This allows us to implement HW assisted PS mode for links,
as well as regulate per-link FW TX blocks consumption.
Split each link into ACs to support future QoS for AP-mode.

AC queues are emptied in priority and per-link queues are
scheduled in a simple round-robin fashion.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   17 ++++-
 drivers/net/wireless/wl12xx/tx.c     |  130 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/tx.h     |    3 +
 drivers/net/wireless/wl12xx/wl12xx.h |   14 ++++
 4 files changed, 151 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index cf11bda..2c6bde9 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -966,6 +966,7 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_sta *sta = txinfo->control.sta;
 	unsigned long flags;
 	int q;
+	u8 hlid = 0;
 
 	/*
 	 * peek into the rates configured in the STA entry.
@@ -1010,7 +1011,13 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	/* queue the packet */
 	q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
-	skb_queue_tail(&wl->tx_queue[q], skb);
+	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+		hlid = wl1271_tx_get_hlid(skb);
+		wl1271_debug(DEBUG_TX, "queue skb hlid %d q %d", hlid, q);
+		skb_queue_tail(&wl->links[hlid].tx_queue[q], skb);
+	} else {
+		skb_queue_tail(&wl->tx_queue[q], skb);
+	}
 
 	/*
 	 * The chip specific setup must run before the first TX packet -
@@ -2640,6 +2647,7 @@ static void wl1271_free_hlid(struct wl1271 *wl, u8 hlid)
 	int id = hlid - WL1271_AP_STA_HLID_START;
 
 	__clear_bit(id, wl->ap_hlid_map);
+	wl1271_tx_reset_link_queues(wl, hlid);
 }
 
 static int wl1271_op_sta_add(struct ieee80211_hw *hw,
@@ -3265,7 +3273,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	struct ieee80211_hw *hw;
 	struct platform_device *plat_dev = NULL;
 	struct wl1271 *wl;
-	int i, ret;
+	int i, j, ret;
 	unsigned int order;
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
@@ -3293,6 +3301,10 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		skb_queue_head_init(&wl->tx_queue[i]);
 
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		for (j = 0; j < AP_MAX_LINKS; j++)
+			skb_queue_head_init(&wl->links[j].tx_queue[i]);
+
 	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
 	INIT_DELAYED_WORK(&wl->pspoll_work, wl1271_pspoll_work);
 	INIT_WORK(&wl->irq_work, wl1271_irq_work);
@@ -3319,6 +3331,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->bss_type = MAX_BSS_TYPE;
 	wl->set_bss_type = MAX_BSS_TYPE;
 	wl->fw_bss_type = MAX_BSS_TYPE;
+	wl->last_tx_hlid = 0;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 820f455..c658821 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -86,6 +86,27 @@ static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 		wl1271_acx_set_inconnection_sta(wl, hdr->addr1);
 }
 
+u8 wl1271_tx_get_hlid(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
+
+	if (control->control.sta) {
+		struct wl1271_station *wl_sta;
+
+		wl_sta = (struct wl1271_station *)
+				control->control.sta->drv_priv;
+		return wl_sta->hlid;
+	} else {
+		struct ieee80211_hdr *hdr;
+
+		hdr = (struct ieee80211_hdr *)skb->data;
+		if (ieee80211_is_mgmt(hdr->frame_control))
+			return WL1271_AP_GLOBAL_HLID;
+		else
+			return WL1271_AP_BROADCAST_HLID;
+	}
+}
+
 static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 				u32 buf_offset)
 {
@@ -298,7 +319,7 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
 	return enabled_rates;
 }
 
-static void handle_tx_low_watermark(struct wl1271 *wl)
+void wl1271_handle_tx_low_watermark(struct wl1271 *wl)
 {
 	unsigned long flags;
 
@@ -312,7 +333,7 @@ static void handle_tx_low_watermark(struct wl1271 *wl)
 	}
 }
 
-static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
+static struct sk_buff *wl1271_sta_skb_dequeue(struct wl1271 *wl)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
@@ -338,12 +359,69 @@ out:
 	return skb;
 }
 
+static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl)
+{
+	struct sk_buff *skb = NULL;
+	unsigned long flags;
+	int i, h, start_hlid;
+
+	/* start from the link after the last one */
+	start_hlid = (wl->last_tx_hlid + 1) % AP_MAX_LINKS;
+
+	/* dequeue according to AC, round robin on each link */
+	for (i = 0; i < AP_MAX_LINKS; i++) {
+		h = (start_hlid + i) % AP_MAX_LINKS;
+
+		skb = skb_dequeue(&wl->links[h].tx_queue[CONF_TX_AC_VO]);
+		if (skb)
+			goto out;
+		skb = skb_dequeue(&wl->links[h].tx_queue[CONF_TX_AC_VI]);
+		if (skb)
+			goto out;
+		skb = skb_dequeue(&wl->links[h].tx_queue[CONF_TX_AC_BE]);
+		if (skb)
+			goto out;
+		skb = skb_dequeue(&wl->links[h].tx_queue[CONF_TX_AC_BK]);
+		if (skb)
+			goto out;
+	}
+
+out:
+	if (skb) {
+		wl->last_tx_hlid = h;
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		wl->tx_queue_count--;
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+	} else {
+		wl->last_tx_hlid = 0;
+	}
+
+	return skb;
+}
+
+static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
+{
+	if (wl->bss_type == BSS_TYPE_AP_BSS)
+		return wl1271_ap_skb_dequeue(wl);
+
+	return wl1271_sta_skb_dequeue(wl);
+}
+
 static void wl1271_skb_queue_head(struct wl1271 *wl, struct sk_buff *skb)
 {
 	unsigned long flags;
 	int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 
-	skb_queue_head(&wl->tx_queue[q], skb);
+	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+		u8 hlid = wl1271_tx_get_hlid(skb);
+		skb_queue_head(&wl->links[hlid].tx_queue[q], skb);
+
+		/* make sure we dequeue the same packet next time */
+		wl->last_tx_hlid = (hlid + AP_MAX_LINKS - 1) % AP_MAX_LINKS;
+	} else {
+		skb_queue_head(&wl->tx_queue[q], skb);
+	}
+
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	wl->tx_queue_count++;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
@@ -428,7 +506,7 @@ out_ack:
 	if (sent_packets) {
 		/* interrupt the firmware with the new packets */
 		wl1271_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
-		handle_tx_low_watermark(wl);
+		wl1271_handle_tx_low_watermark(wl);
 	}
 
 out:
@@ -545,6 +623,27 @@ void wl1271_tx_complete(struct wl1271 *wl)
 	}
 }
 
+void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
+{
+	struct sk_buff *skb;
+	int i, total = 0;
+	unsigned long flags;
+
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
+			wl1271_debug(DEBUG_TX, "link freeing skb 0x%p", skb);
+			ieee80211_tx_status(wl->hw, skb);
+			total++;
+		}
+	}
+
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	wl->tx_queue_count -= total;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	wl1271_handle_tx_low_watermark(wl);
+}
+
 /* caller must hold wl->mutex */
 void wl1271_tx_reset(struct wl1271 *wl)
 {
@@ -552,19 +651,28 @@ void wl1271_tx_reset(struct wl1271 *wl)
 	struct sk_buff *skb;
 
 	/* TX failure */
-	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		while ((skb = skb_dequeue(&wl->tx_queue[i]))) {
-			wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
-			ieee80211_tx_status(wl->hw, skb);
+	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+		for (i = 0; i < AP_MAX_LINKS; i++)
+			wl1271_tx_reset_link_queues(wl, i);
+
+		wl->last_tx_hlid = 0;
+	} else {
+		for (i = 0; i < NUM_TX_QUEUES; i++) {
+			while ((skb = skb_dequeue(&wl->tx_queue[i]))) {
+				wl1271_debug(DEBUG_TX, "freeing skb 0x%p",
+					     skb);
+				ieee80211_tx_status(wl->hw, skb);
+			}
 		}
 	}
+
 	wl->tx_queue_count = 0;
 
 	/*
 	 * Make sure the driver is at a consistent state, in case this
 	 * function is called from a context other than interface removal.
 	 */
-	handle_tx_low_watermark(wl);
+	wl1271_handle_tx_low_watermark(wl);
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		if (wl->tx_frames[i] != NULL) {
@@ -585,8 +693,8 @@ void wl1271_tx_flush(struct wl1271 *wl)
 
 	while (!time_after(jiffies, timeout)) {
 		mutex_lock(&wl->mutex);
-		wl1271_debug(DEBUG_TX, "flushing tx buffer: %d",
-			     wl->tx_frames_cnt);
+		wl1271_debug(DEBUG_TX, "flushing tx buffer: %d %d",
+			     wl->tx_frames_cnt, wl->tx_queue_count);
 		if ((wl->tx_frames_cnt == 0) && (wl->tx_queue_count == 0)) {
 			mutex_unlock(&wl->mutex);
 			return;
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 05722a5..76df5d5 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -152,5 +152,8 @@ void wl1271_tx_flush(struct wl1271 *wl);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl);
+u8 wl1271_tx_get_hlid(struct sk_buff *skb);
+void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
+void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index d1de13f..30450e4 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -278,6 +278,11 @@ struct wl1271_ap_key {
 	u16 tx_seq_16;
 };
 
+struct wl1271_link {
+	/* AP-mode - TX queue per AC in link */
+	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
+};
+
 struct wl1271 {
 	struct platform_device *plat_dev;
 	struct ieee80211_hw *hw;
@@ -474,6 +479,15 @@ struct wl1271 {
 	/* RX BA constraint value */
 	bool ba_support;
 	u8 ba_rx_bitmap;
+
+	/*
+	 * AP-mode - links indexed by HLID. The global and broadcast links
+	 * are always active.
+	 */
+	struct wl1271_link links[AP_MAX_LINKS];
+
+	/* the hlid of the link where the last transmitted skb came from */
+	int last_tx_hlid;
 };
 
 struct wl1271_station {
-- 
1.7.1

