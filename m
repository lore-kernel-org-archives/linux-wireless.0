Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1JJIMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:47 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:46 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/29] wl12xx: support multiple vifs in the tx path
Date: Mon, 10 Oct 2011 10:12:55 +0200
Message-Id: <1318234397-21081-8-git-send-email-eliad@wizery.com> (sfid-20111010_101251_521350_C933C5DE)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass the wlvif associated with each skb as param.

Note that dummy packet doesn't belong to any
particular vif, so we pass NULL in this case.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 +-
 drivers/net/wireless/wl12xx/tx.c   |   79 ++++++++++++++++++++++--------------
 drivers/net/wireless/wl12xx/tx.h   |    2 +-
 3 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 56d5923..0623f5d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -993,7 +993,7 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 				 * In order to avoid starvation of the TX path,
 				 * call the work function directly.
 				 */
-				wl1271_tx_work_locked(wl, wl->vif);
+				wl1271_tx_work_locked(wl);
 			} else {
 				spin_unlock_irqrestore(&wl->wl_lock, flags);
 			}
@@ -1537,7 +1537,7 @@ int wl1271_tx_dummy_packet(struct wl1271 *wl)
 
 	/* The FW is low on RX memory blocks, so send the dummy packet asap */
 	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags))
-		wl1271_tx_work_locked(wl, wl->vif);
+		wl1271_tx_work_locked(wl);
 
 	/*
 	 * If the FW TX is busy, TX work will be scheduled by the threaded
@@ -2413,7 +2413,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	    ((wl->band != conf->channel->band) ||
 	     (wl->channel != channel))) {
 		/* send all pending packets */
-		wl1271_tx_work_locked(wl, vif);
+		wl1271_tx_work_locked(wl);
 		wl->band = conf->channel->band;
 		wl->channel = channel;
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 6c0135b..c7be151 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -210,17 +210,17 @@ static unsigned int wl12xx_calc_packet_alignment(struct wl1271 *wl,
 		return ALIGN(packet_length, WL1271_TX_ALIGN_TO);
 }
 
-static int wl1271_tx_allocate(struct wl1271 *wl, struct ieee80211_vif *vif,
+static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			      struct sk_buff *skb, u32 extra, u32 buf_offset,
 			      u8 hlid)
 {
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 len;
 	u32 total_blocks;
 	int id, ret = -EBUSY, ac;
 	u32 spare_blocks = wl->tx_spare_blocks;
+	bool is_dummy = false;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
 		return -EAGAIN;
@@ -235,8 +235,10 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct ieee80211_vif *vif,
 	len = wl12xx_calc_packet_alignment(wl, total_len);
 
 	/* in case of a dummy packet, use default amount of spare mem blocks */
-	if (unlikely(wl12xx_is_dummy_packet(wl, skb)))
+	if (unlikely(wl12xx_is_dummy_packet(wl, skb))) {
+		is_dummy = true;
 		spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
+	}
 
 	total_blocks = (len + TX_HW_BLOCK_SIZE - 1) / TX_HW_BLOCK_SIZE +
 		spare_blocks;
@@ -261,7 +263,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct ieee80211_vif *vif,
 		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->tx_allocated_pkts[ac]++;
 
-		if (wlvif->bss_type == BSS_TYPE_AP_BSS &&
+		if (!is_dummy && wlvif->bss_type == BSS_TYPE_AP_BSS &&
 		    test_bit(hlid, wlvif->ap.sta_hlid_map))
 			wl->links[hlid].allocated_pkts++;
 
@@ -277,16 +279,16 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct ieee80211_vif *vif,
 	return ret;
 }
 
-static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct ieee80211_vif *vif,
+static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       struct sk_buff *skb, u32 extra,
 			       struct ieee80211_tx_info *control, u8 hlid)
 {
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct timespec ts;
 	struct wl1271_tx_hw_descr *desc;
 	int aligned_len, ac, rate_idx;
 	s64 hosttime;
 	u16 tx_attr;
+	bool is_dummy;
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
 
@@ -303,7 +305,8 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct ieee80211_vif *vif,
 	hosttime = (timespec_to_ns(&ts) >> 10);
 	desc->start_time = cpu_to_le32(hosttime - wl->time_offset);
 
-	if (wlvif->bss_type != BSS_TYPE_AP_BSS)
+	is_dummy = wl12xx_is_dummy_packet(wl, skb);
+	if (is_dummy || wlvif->bss_type != BSS_TYPE_AP_BSS)
 		desc->life_time = cpu_to_le16(TX_HW_MGMT_PKT_LIFETIME_TU);
 	else
 		desc->life_time = cpu_to_le16(TX_HW_AP_MODE_PKT_LIFETIME_TU);
@@ -312,7 +315,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct ieee80211_vif *vif,
 	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 	desc->tid = skb->priority;
 
-	if (wl12xx_is_dummy_packet(wl, skb)) {
+	if (is_dummy) {
 		/*
 		 * FW expects the dummy packet to have an invalid session id -
 		 * any session id that is different than the one set in the join
@@ -329,7 +332,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct ieee80211_vif *vif,
 	}
 
 	desc->hlid = hlid;
-	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
+	if (is_dummy)
+		rate_idx = 0;
+	else if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
 		/* if the packets are destined for AP (have a STA entry)
 		   send them with AP rate policies, otherwise use default
 		   basic rates */
@@ -383,12 +388,10 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct ieee80211_vif *vif,
 }
 
 /* caller must hold wl->mutex */
-static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
-							u32 buf_offset)
+static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				   struct sk_buff *skb, u32 buf_offset)
 {
 	struct ieee80211_tx_info *info;
-	struct ieee80211_vif *vif;
-	struct wl12xx_vif *wlvif;
 	u32 extra = 0;
 	int ret = 0;
 	u32 total_len;
@@ -402,11 +405,6 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 
 	/* TODO: handle dummy packets on multi-vifs */
 	is_dummy = wl12xx_is_dummy_packet(wl, skb);
-	if (is_dummy)
-		info->control.vif = wl->vif;
-
-	vif = info->control.vif;
-	wlvif = wl12xx_vif_to_data(vif);
 
 	if (info->control.hw_key &&
 	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP)
@@ -433,13 +431,13 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	ret = wl1271_tx_allocate(wl, vif, skb, extra, buf_offset, hlid);
+	ret = wl1271_tx_allocate(wl, wlvif, skb, extra, buf_offset, hlid);
 	if (ret < 0)
 		return ret;
 
-	wl1271_tx_fill_hdr(wl, vif, skb, extra, info, hlid);
+	wl1271_tx_fill_hdr(wl, wlvif, skb, extra, info, hlid);
 
-	if (wlvif->bss_type == BSS_TYPE_AP_BSS && !is_dummy) {
+	if (!is_dummy && wlvif->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
 		wl1271_tx_regulate_link(wl, wlvif, hlid);
 	}
@@ -589,13 +587,19 @@ static struct sk_buff *wl12xx_vif_skb_dequeue(struct wl1271 *wl,
 	return skb;
 }
 
-static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl,
-					  struct wl12xx_vif *wlvif)
+static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 {
 	unsigned long flags;
+	struct wl12xx_vif *wlvif;
 	struct sk_buff *skb = NULL;
 
-	skb = wl12xx_vif_skb_dequeue(wl, wlvif);
+	/* TODO: rememeber last vif and consider it */
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		skb = wl12xx_vif_skb_dequeue(wl, wlvif);
+		if (skb)
+			break;
+	}
+
 	if (!skb &&
 	    test_and_clear_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags)) {
 		int q;
@@ -639,24 +643,35 @@ static bool wl1271_tx_is_data_present(struct sk_buff *skb)
 	return ieee80211_is_data_present(hdr->frame_control);
 }
 
-void wl1271_tx_work_locked(struct wl1271 *wl, struct ieee80211_vif *vif)
+void wl1271_tx_work_locked(struct wl1271 *wl)
 {
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl12xx_vif *wlvif;
 	struct sk_buff *skb;
 	u32 buf_offset = 0;
 	bool sent_packets = false;
 	bool had_data = false;
-	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
+	/* TODO: save bitmap of relevant stations */
+	bool is_sta = false;
 	int ret;
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		return;
 
-	while ((skb = wl1271_skb_dequeue(wl, wlvif))) {
+	while ((skb = wl1271_skb_dequeue(wl))) {
+		wlvif = NULL;
+		if (!wl12xx_is_dummy_packet(wl, skb)) {
+			struct ieee80211_tx_info *info;
+			struct ieee80211_vif *vif;
+
+			info = IEEE80211_SKB_CB(skb);
+			vif = info->control.vif;
+			wlvif = wl12xx_vif_to_data(vif);
+		}
+
 		if (wl1271_tx_is_data_present(skb))
 			had_data = true;
 
-		ret = wl1271_prepare_tx_frame(wl, skb, buf_offset);
+		ret = wl1271_prepare_tx_frame(wl, wlvif, skb, buf_offset);
 		if (ret == -EAGAIN) {
 			/*
 			 * Aggregation buffer is full.
@@ -683,6 +698,8 @@ void wl1271_tx_work_locked(struct wl1271 *wl, struct ieee80211_vif *vif)
 		}
 		buf_offset += ret;
 		wl->tx_packets_count++;
+		if (wlvif && wlvif->bss_type == BSS_TYPE_STA_BSS)
+			is_sta = true;
 	}
 
 out_ack:
@@ -702,7 +719,7 @@ out_ack:
 
 		wl1271_handle_tx_low_watermark(wl);
 	}
-	if (!is_ap && wl->conf.rx_streaming.interval && had_data &&
+	if (is_sta && wl->conf.rx_streaming.interval && had_data &&
 	    (wl->conf.rx_streaming.always ||
 	     test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags))) {
 		u32 timeout = wl->conf.rx_streaming.duration;
@@ -727,7 +744,7 @@ void wl1271_tx_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	wl1271_tx_work_locked(wl, wl->vif);
+	wl1271_tx_work_locked(wl);
 
 	wl1271_ps_elp_sleep(wl);
 out:
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 050a047..fe29ff5 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -204,7 +204,7 @@ static inline int wl1271_tx_total_queue_count(struct wl1271 *wl)
 }
 
 void wl1271_tx_work(struct work_struct *work);
-void wl1271_tx_work_locked(struct wl1271 *wl, struct ieee80211_vif *vif);
+void wl1271_tx_work_locked(struct wl1271 *wl);
 void wl1271_tx_complete(struct wl1271 *wl);
 void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues);
-- 
1.7.6.401.g6a319

