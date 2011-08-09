Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52328 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1HIJNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:33 -0400
Received: by wyg24 with SMTP id 24so210690wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:32 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/40] wl12xx: Revert "wl12xx: schedule TX packets according to FW occupancy"
Date: Tue,  9 Aug 2011 12:13:14 +0300
Message-Id: <1312881233-9366-2-git-send-email-eliad@wizery.com> (sfid-20110809_111337_160183_0DDEF9B6)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This does not make sense in 7.3 firmware - we don't use Tx blocks to
measure FW occupancy anymore.

This reverts commit 9e374a37b6fa2310b71d3c5657cd0c1e693120c6.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    5 +--
 drivers/net/wireless/wl12xx/main.c    |   30 ++++-----------
 drivers/net/wireless/wl12xx/tx.c      |   68 +++++++++++----------------------
 drivers/net/wireless/wl12xx/wl12xx.h  |    2 +-
 4 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 37934b5..3b5f240 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -336,16 +336,13 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 #define DRIVER_STATE_PRINT_INT(x)  DRIVER_STATE_PRINT(x, "%d")
 #define DRIVER_STATE_PRINT_STR(x)  DRIVER_STATE_PRINT(x, "%s")
 #define DRIVER_STATE_PRINT_LHEX(x) DRIVER_STATE_PRINT(x, "0x%lx")
 #define DRIVER_STATE_PRINT_HEX(x)  DRIVER_STATE_PRINT(x, "0x%x")
 
 	DRIVER_STATE_PRINT_INT(tx_blocks_available);
-	DRIVER_STATE_PRINT_INT(tx_allocated_blocks[0]);
-	DRIVER_STATE_PRINT_INT(tx_allocated_blocks[1]);
-	DRIVER_STATE_PRINT_INT(tx_allocated_blocks[2]);
-	DRIVER_STATE_PRINT_INT(tx_allocated_blocks[3]);
+	DRIVER_STATE_PRINT_INT(tx_allocated_blocks);
 	DRIVER_STATE_PRINT_INT(tx_frames_cnt);
 	DRIVER_STATE_PRINT_LHEX(tx_frames_map[0]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[0]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[1]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[2]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[3]);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e58c22d..bf05a9f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -821,30 +821,19 @@ static void wl1271_irq_update_links_status(struct wl1271 *wl,
 
 		wl1271_irq_ps_regulate_link(wl, hlid,
 					    wl->links[hlid].allocated_blks);
 	}
 }
 
-static u32 wl1271_tx_allocated_blocks(struct wl1271 *wl)
-{
-	int i;
-	u32 total_alloc_blocks = 0;
-
-	for (i = 0; i < NUM_TX_QUEUES; i++)
-		total_alloc_blocks += wl->tx_allocated_blocks[i];
-
-	return total_alloc_blocks;
-}
-
 static void wl1271_fw_status(struct wl1271 *wl,
 			     struct wl1271_fw_full_status *full_status)
 {
 	struct wl1271_fw_common_status *status = &full_status->common;
 	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
-	u32 freed_blocks = 0, ac_freed_blocks;
+	u32 freed_blocks = 0;
 	int i;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_raw_read(wl, FW_STATUS_ADDR, status,
 				sizeof(struct wl1271_fw_ap_status), false);
 	} else {
@@ -858,29 +847,27 @@ static void wl1271_fw_status(struct wl1271 *wl,
 		     status->fw_rx_counter,
 		     status->drv_rx_counter,
 		     status->tx_results_counter);
 
 	/* update number of available TX blocks */
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		ac_freed_blocks = le32_to_cpu(status->tx_released_blks[i]) -
-				  wl->tx_blocks_freed[i];
-		freed_blocks += ac_freed_blocks;
-
-		wl->tx_allocated_blocks[i] -= ac_freed_blocks;
+		freed_blocks += le32_to_cpu(status->tx_released_blks[i]) -
+				wl->tx_blocks_freed[i];
 
 		wl->tx_blocks_freed[i] =
 			le32_to_cpu(status->tx_released_blks[i]);
 	}
 
+	wl->tx_allocated_blocks -= freed_blocks;
+
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		/* Update num of allocated TX blocks per link and ps status */
 		wl1271_irq_update_links_status(wl, &full_status->ap);
 		wl->tx_blocks_available += freed_blocks;
 	} else {
-		int avail = full_status->sta.tx_total -
-			    wl1271_tx_allocated_blocks(wl);
+		int avail = full_status->sta.tx_total - wl->tx_allocated_blocks;
 
 		/*
 		 * The FW might change the total number of TX memblocks before
 		 * we get a notification about blocks being released. Thus, the
 		 * available blocks calculation might yield a temporary result
 		 * which is lower than the actual available blocks. Keeping in
@@ -2004,12 +1991,13 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl->band = IEEE80211_BAND_2GHZ;
 
 	wl->rx_counter = 0;
 	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->tx_blocks_available = 0;
+	wl->tx_allocated_blocks = 0;
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
 	wl->time_offset = 0;
 	wl->session_counter = 0;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->vif = NULL;
@@ -2024,16 +2012,14 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	 * this is performed after the cancel_work calls and the associated
 	 * mutex_lock, so that wl1271_op_add_interface does not accidentally
 	 * get executed before all these vars have been reset.
 	 */
 	wl->flags = 0;
 
-	for (i = 0; i < NUM_TX_QUEUES; i++) {
+	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
-		wl->tx_allocated_blocks[i] = 0;
-	}
 
 	wl1271_debugfs_reset(wl);
 
 	kfree(wl->fw_status);
 	wl->fw_status = NULL;
 	kfree(wl->tx_res_if);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 48fde96..0696aed 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -165,13 +165,13 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 				u32 buf_offset, u8 hlid)
 {
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 len;
 	u32 total_blocks;
-	int id, ret = -EBUSY, ac;
+	int id, ret = -EBUSY;
 	u32 spare_blocks;
 
 	if (unlikely(wl->quirks & WL12XX_QUIRK_USE_2_SPARE_BLOCKS))
 		spare_blocks = 2;
 	else
 		spare_blocks = 1;
@@ -203,15 +203,13 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 			desc->wl127x_mem.total_mem_blocks = total_blocks;
 		}
 
 		desc->id = id;
 
 		wl->tx_blocks_available -= total_blocks;
-
-		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
-		wl->tx_allocated_blocks[ac] += total_blocks;
+		wl->tx_allocated_blocks += total_blocks;
 
 		if (wl->bss_type == BSS_TYPE_AP_BSS)
 			wl->links[hlid].allocated_blks += total_blocks;
 
 		ret = 0;
 
@@ -456,47 +454,27 @@ void wl1271_handle_tx_low_watermark(struct wl1271 *wl)
 			clear_bit(i, &wl->stopped_queues_map);
 			spin_unlock_irqrestore(&wl->wl_lock, flags);
 		}
 	}
 }
 
-static struct sk_buff_head *wl1271_select_queue(struct wl1271 *wl,
-						struct sk_buff_head *queues)
-{
-	int i, q = -1;
-	u32 min_blks = 0xffffffff;
-
-	/*
-	 * Find a non-empty ac where:
-	 * 1. There are packets to transmit
-	 * 2. The FW has the least allocated blocks
-	 */
-	for (i = 0; i < NUM_TX_QUEUES; i++)
-		if (!skb_queue_empty(&queues[i]) &&
-		    (wl->tx_allocated_blocks[i] < min_blks)) {
-			q = i;
-			min_blks = wl->tx_allocated_blocks[q];
-		}
-
-	if (q == -1)
-		return NULL;
-
-	return &queues[q];
-}
-
 static struct sk_buff *wl1271_sta_skb_dequeue(struct wl1271 *wl)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
-	struct sk_buff_head *queue;
 
-	queue = wl1271_select_queue(wl, wl->tx_queue);
-	if (!queue)
+	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_VO]);
+	if (skb)
 		goto out;
-
-	skb = skb_dequeue(queue);
+	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_VI]);
+	if (skb)
+		goto out;
+	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_BE]);
+	if (skb)
+		goto out;
+	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_BK]);
 
 out:
 	if (skb) {
 		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		wl->tx_queue_count[q]--;
@@ -508,35 +486,35 @@ out:
 
 static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
 	int i, h, start_hlid;
-	struct sk_buff_head *queue;
 
 	/* start from the link after the last one */
 	start_hlid = (wl->last_tx_hlid + 1) % AP_MAX_LINKS;
 
 	/* dequeue according to AC, round robin on each link */
 	for (i = 0; i < AP_MAX_LINKS; i++) {
 		h = (start_hlid + i) % AP_MAX_LINKS;
 
-		/* only consider connected stations */
-		if (h >= WL1271_AP_STA_HLID_START &&
-		    !test_bit(h - WL1271_AP_STA_HLID_START, wl->ap_hlid_map))
-			continue;
-
-		queue = wl1271_select_queue(wl, wl->links[h].tx_queue);
-		if (!queue)
-			continue;
-
-		skb = skb_dequeue(queue);
+		skb = skb_dequeue(&wl->links[h].tx_queue[CONF_TX_AC_VO]);
 		if (skb)
-			break;
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
 	}
 
+out:
 	if (skb) {
 		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->last_tx_hlid = h;
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		wl->tx_queue_count[q]--;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1a8751e..6c080e9 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -421,13 +421,13 @@ struct wl1271 {
 
 	struct wl1271_acx_mem_map *target_mem_map;
 
 	/* Accounting for allocated / available TX blocks on HW */
 	u32 tx_blocks_freed[NUM_TX_QUEUES];
 	u32 tx_blocks_available;
-	u32 tx_allocated_blocks[NUM_TX_QUEUES];
+	u32 tx_allocated_blocks;
 	u32 tx_results_count;
 
 	/* Transmitted TX packets counter for chipset interface */
 	u32 tx_packets_count;
 
 	/* Time-offset between host and chipset clocks */
-- 
1.7.6.401.g6a319

