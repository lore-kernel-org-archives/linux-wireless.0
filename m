Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab1HIJOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:39 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:38 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 36/40] wl12xx: enable AP advanced functionality
Date: Tue,  9 Aug 2011 12:13:49 +0300
Message-Id: <1312881233-9366-37-git-send-email-eliad@wizery.com> (sfid-20110809_111445_707542_79754FFA)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This adjusts FW TX block allocation for connected stations in PS.
Firmware congestion is measured in allocated packets instead of blocks.

Allow a link in PS to queue up to 2 packets to the FW.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   48 +++++++++++++++++-----------------
 drivers/net/wireless/wl12xx/ps.c     |    4 +-
 drivers/net/wireless/wl12xx/tx.c     |   19 +++++--------
 drivers/net/wireless/wl12xx/wl12xx.h |   25 ++++++++++--------
 4 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c8e9ba6..9f60f0f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -751,64 +751,73 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	kfree(wl->target_mem_map);
 	wl->target_mem_map = NULL;
 
 	return ret;
 }
 
-#if 0
-static void wl1271_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_blks)
+static void wl1271_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_pkts)
 {
 	bool fw_ps;
 
 	/* only regulate station links */
 	if (hlid < WL1271_AP_STA_HLID_START)
 		return;
 
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 
 	/*
 	 * Wake up from high level PS if the STA is asleep with too little
-	 * blocks in FW or if the STA is awake.
+	 * packets in FW or if the STA is awake.
 	 */
-	if (!fw_ps || tx_blks < WL1271_PS_STA_MAX_BLOCKS)
+	if (!fw_ps || tx_pkts < WL1271_PS_STA_MAX_PACKETS)
 		wl1271_ps_link_end(wl, hlid);
 
 	/* Start high-level PS if the STA is asleep with enough blocks in FW */
-	else if (fw_ps && tx_blks >= WL1271_PS_STA_MAX_BLOCKS)
+	else if (fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl1271_ps_link_start(wl, hlid, true);
 }
 
+bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid)
+{
+	int id = hlid - WL1271_AP_STA_HLID_START;
+	return test_bit(id, wl->ap_hlid_map);
+}
+
 static void wl1271_irq_update_links_status(struct wl1271 *wl,
-				       struct wl1271_fw_ap_status *status)
+					   struct wl1271_fw_status *status)
 {
 	u32 cur_fw_ps_map;
-	u8 hlid;
+	u8 hlid, cnt;
+
+	/* TODO: also use link_fast_bitmap here */
 
 	cur_fw_ps_map = le32_to_cpu(status->link_ps_bitmap);
 	if (wl->ap_fw_ps_map != cur_fw_ps_map) {
 		wl1271_debug(DEBUG_PSM,
 			     "link ps prev 0x%x cur 0x%x changed 0x%x",
 			     wl->ap_fw_ps_map, cur_fw_ps_map,
 			     wl->ap_fw_ps_map ^ cur_fw_ps_map);
 
 		wl->ap_fw_ps_map = cur_fw_ps_map;
 	}
 
 	for (hlid = WL1271_AP_STA_HLID_START; hlid < AP_MAX_LINKS; hlid++) {
-		u8 cnt = status->tx_lnk_free_blks[hlid] -
-			wl->links[hlid].prev_freed_blks;
+		if (!wl1271_is_active_sta(wl, hlid))
+			continue;
 
-		wl->links[hlid].prev_freed_blks =
-			status->tx_lnk_free_blks[hlid];
-		wl->links[hlid].allocated_blks -= cnt;
+		cnt = status->tx_lnk_free_pkts[hlid] -
+		      wl->links[hlid].prev_freed_pkts;
+
+		wl->links[hlid].prev_freed_pkts =
+			status->tx_lnk_free_pkts[hlid];
+		wl->links[hlid].allocated_pkts -= cnt;
 
 		wl1271_irq_ps_regulate_link(wl, hlid,
-					    wl->links[hlid].allocated_blks);
+					    wl->links[hlid].allocated_pkts);
 	}
 }
-#endif
 
 static void wl1271_fw_status(struct wl1271 *wl,
 			     struct wl1271_fw_status *status)
 {
 	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
@@ -861,17 +870,14 @@ static void wl1271_fw_status(struct wl1271 *wl,
 
 	/* if more blocks are available now, tx work can be scheduled */
 	if (wl->tx_blocks_available > old_tx_blk_count)
 		clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 
 	/* for AP update num of allocated TX blocks per link and ps status */
-	if (wl->bss_type == BSS_TYPE_AP_BSS) {
-#if 0
+	if (wl->bss_type == BSS_TYPE_AP_BSS)
 		wl1271_irq_update_links_status(wl, status);
-#endif
-	}
 
 	/* update the host-chipset time offset */
 	getnstimeofday(&ts);
 	wl->time_offset = (timespec_to_ns(&ts) >> 10) -
 		(s64)le32_to_cpu(status->fw_localtime);
 }
@@ -3676,18 +3682,12 @@ static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
 	wl->links[hlid].ba_bitmap = 0;
 	wl1271_tx_reset_link_queues(wl, hlid);
 	__clear_bit(hlid, &wl->ap_ps_map);
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 }
 
-bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid)
-{
-	int id = hlid - WL1271_AP_STA_HLID_START;
-	return test_bit(id, wl->ap_hlid_map);
-}
-
 static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta)
 {
 	struct wl1271 *wl = hw->priv;
 	int ret = 0;
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 3548377..4b720b1 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -223,14 +223,14 @@ void wl1271_ps_link_start(struct wl1271 *wl, u8 hlid, bool clean_queues)
 {
 	struct ieee80211_sta *sta;
 
 	if (test_bit(hlid, &wl->ap_ps_map))
 		return;
 
-	wl1271_debug(DEBUG_PSM, "start mac80211 PSM on hlid %d blks %d "
-		     "clean_queues %d", hlid, wl->links[hlid].allocated_blks,
+	wl1271_debug(DEBUG_PSM, "start mac80211 PSM on hlid %d pkts %d "
+		     "clean_queues %d", hlid, wl->links[hlid].allocated_pkts,
 		     clean_queues);
 
 	rcu_read_lock();
 	sta = ieee80211_find_sta(wl->vif, wl->links[hlid].addr);
 	if (!sta) {
 		wl1271_error("could not find sta %pM for starting ps",
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index d184da1..a180c16 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -120,33 +120,31 @@ static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 	hdr = (struct ieee80211_hdr *)(skb->data +
 				       sizeof(struct wl1271_tx_hw_descr));
 	if (ieee80211_is_auth(hdr->frame_control))
 		wl1271_acx_set_inconnection_sta(wl, hdr->addr1);
 }
 
-#if 0
 static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
 {
 	bool fw_ps;
-	u8 tx_blks;
+	u8 tx_pkts;
 
 	/* only regulate station links */
 	if (hlid < WL1271_AP_STA_HLID_START)
 		return;
 
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
-	tx_blks = wl->links[hlid].allocated_blks;
+	tx_pkts = wl->links[hlid].allocated_pkts;
 
 	/*
 	 * if in FW PS and there is enough data in FW we can put the link
 	 * into high-level PS and clean out its TX queues.
 	 */
-	if (fw_ps && tx_blks >= WL1271_PS_STA_MAX_BLOCKS)
+	if (fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl1271_ps_link_start(wl, hlid, true);
 }
-#endif
 
 u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
 
 	if (control->control.sta) {
@@ -222,14 +220,15 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 		wl->tx_blocks_available -= total_blocks;
 		wl->tx_allocated_blocks += total_blocks;
 
 		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->tx_allocated_pkts[ac]++;
 
-		if (wl->bss_type == BSS_TYPE_AP_BSS)
-			wl->links[hlid].allocated_blks += total_blocks;
+		if (wl->bss_type == BSS_TYPE_AP_BSS &&
+		    hlid >= WL1271_AP_STA_HLID_START)
+			wl->links[hlid].allocated_pkts++;
 
 		ret = 0;
 
 		wl1271_debug(DEBUG_TX,
 			     "tx_allocate: size: %d, blocks: %d, id: %d",
 			     total_len, total_blocks, id);
@@ -406,15 +405,13 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 		return ret;
 
 	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
-#if 0
 		wl1271_tx_regulate_link(wl, hlid);
-#endif
 	} else {
 		wl1271_tx_update_filters(wl, skb);
 	}
 
 	/*
 	 * The length of each packet is stored in terms of
@@ -876,14 +873,14 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 	struct ieee80211_tx_info *info;
 
 	/* TX failure */
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		for (i = 0; i < AP_MAX_LINKS; i++) {
 			wl1271_tx_reset_link_queues(wl, i);
-			wl->links[i].allocated_blks = 0;
-			wl->links[i].prev_freed_blks = 0;
+			wl->links[i].allocated_pkts = 0;
+			wl->links[i].prev_freed_pkts = 0;
 		}
 
 		wl->last_tx_hlid = 0;
 	} else {
 		for (i = 0; i < NUM_TX_QUEUES; i++) {
 			while ((skb = skb_dequeue(&wl->tx_queue[i]))) {
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index c3996b2..2563201 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -149,21 +149,20 @@ extern u32 wl12xx_debug_level;
  * TODO: we currently don't support multirole. remove
  * this constant from the code when we do.
  */
 #define WL1271_AP_STA_HLID_START   3
 
 /*
- * When in AP-mode, we allow (at least) this number of mem-blocks
+ * When in AP-mode, we allow (at least) this number of packets
  * to be transmitted to FW for a STA in PS-mode. Only when packets are
  * present in the FW buffers it will wake the sleeping STA. We want to put
  * enough packets for the driver to transmit all of its buffered data before
- * the STA goes to sleep again. But we don't want to take too much mem-blocks
+ * the STA goes to sleep again. But we don't want to take too much memory
  * as it might hurt the throughput of active STAs.
- * The number of blocks (18) is enough for 2 large packets.
  */
-#define WL1271_PS_STA_MAX_BLOCKS  (2 * 9)
+#define WL1271_PS_STA_MAX_PACKETS  2
 
 #define WL1271_AP_BSS_INDEX        0
 #define WL1271_AP_DEF_BEACON_EXP   20
 
 #define ACX_TX_DESCRIPTORS         16
 
@@ -234,14 +233,18 @@ struct wl1271_stats {
 
 #define NUM_TX_QUEUES              4
 #define NUM_RX_PKT_DESC            8
 
 #define AP_MAX_STATIONS            5
 
-/* Broadcast and Global links + links to stations */
-#define AP_MAX_LINKS               (AP_MAX_STATIONS + 2)
+/* Broadcast and Global links + system link + links to stations */
+/*
+ * TODO: when WL1271_AP_STA_HLID_START is no longer constant, change all
+ * the places that use this.
+ */
+#define AP_MAX_LINKS               (AP_MAX_STATIONS + 3)
 
 /* FW status registers */
 struct wl1271_fw_status {
 	__le32 intr;
 	u8  fw_rx_counter;
 	u8  drv_rx_counter;
@@ -268,14 +271,14 @@ struct wl1271_fw_status {
 	/* Size (in Memory Blocks) of TX pool */
 	__le32 tx_total;
 
 	/* Cumulative counter of released packets per AC */
 	u8 tx_released_pkts[NUM_TX_QUEUES];
 
-	/* Cumulative counter of freed MBs per HLID */
-	u8 tx_lnk_free_blks[WL1271_MAX_LINKS];
+	/* Cumulative counter of freed packets per HLID */
+	u8 tx_lnk_free_pkts[WL1271_MAX_LINKS];
 
 	/* Cumulative counter of released Voice memory blocks */
 	u8 tx_voice_released_blks;
 	u8 padding_1[7];
 	__le32 log_start_addr;
 } __packed;
@@ -349,15 +352,15 @@ enum wl12xx_flags {
 };
 
 struct wl1271_link {
 	/* AP-mode - TX queue per AC in link */
 	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
 
-	/* accounting for allocated / available TX blocks in FW */
-	u8 allocated_blks;
-	u8 prev_freed_blks;
+	/* accounting for allocated / freed packets in FW */
+	u8 allocated_pkts;
+	u8 prev_freed_pkts;
 
 	u8 addr[ETH_ALEN];
 
 	/* bitmap of TIDs where RX BA sessions are active for this link */
 	u8 ba_bitmap;
 };
-- 
1.7.6.401.g6a319

