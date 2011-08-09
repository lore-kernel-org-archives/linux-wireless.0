Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52328 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1HIJNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:42 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210690wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:42 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/40] wl12xx: wl12xx-fw-3 - Update fw status struct
Date: Tue,  9 Aug 2011 12:13:19 +0300
Message-Id: <1312881233-9366-7-git-send-email-eliad@wizery.com> (sfid-20110809_111351_207585_444FC833)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the fw status struct according to the new fw api.
All the roles use the same struct now.

The memory accounting was changed a bit according to
the struct changes.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    5 +--
 drivers/net/wireless/wl12xx/main.c    |   74 +++++++++++++--------------------
 drivers/net/wireless/wl12xx/rx.c      |    6 +-
 drivers/net/wireless/wl12xx/rx.h      |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |   55 +++++++++++--------------
 5 files changed, 58 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index fd1c301..3102652 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -346,16 +346,13 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(tx_queue_count[1]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[2]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[3]);
 	DRIVER_STATE_PRINT_INT(tx_packets_count);
 	DRIVER_STATE_PRINT_INT(tx_results_count);
 	DRIVER_STATE_PRINT_LHEX(flags);
-	DRIVER_STATE_PRINT_INT(tx_blocks_freed[0]);
-	DRIVER_STATE_PRINT_INT(tx_blocks_freed[1]);
-	DRIVER_STATE_PRINT_INT(tx_blocks_freed[2]);
-	DRIVER_STATE_PRINT_INT(tx_blocks_freed[3]);
+	DRIVER_STATE_PRINT_INT(tx_blocks_freed);
 	DRIVER_STATE_PRINT_INT(tx_security_last_seq_lsb);
 	DRIVER_STATE_PRINT_INT(rx_counter);
 	DRIVER_STATE_PRINT_INT(session_counter);
 	DRIVER_STATE_PRINT_INT(state);
 	DRIVER_STATE_PRINT_INT(bss_type);
 	DRIVER_STATE_PRINT_INT(channel);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a1608f1..1ac1762 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -824,71 +824,57 @@ static void wl1271_irq_update_links_status(struct wl1271 *wl,
 					    wl->links[hlid].allocated_blks);
 	}
 }
 #endif
 
 static void wl1271_fw_status(struct wl1271 *wl,
-			     struct wl1271_fw_full_status *full_status)
+			     struct wl1271_fw_status *status)
 {
-	struct wl1271_fw_common_status *status = &full_status->common;
 	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
-	u32 freed_blocks = 0;
-	int i;
+	int avail, freed_blocks;
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS) {
-		wl1271_raw_read(wl, FW_STATUS_ADDR, status,
-				sizeof(struct wl1271_fw_ap_status), false);
-	} else {
-		wl1271_raw_read(wl, FW_STATUS_ADDR, status,
-				sizeof(struct wl1271_fw_sta_status), false);
-	}
+	wl1271_raw_read(wl, FW_STATUS_ADDR, status, sizeof(*status), false);
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
 		     status->intr,
 		     status->fw_rx_counter,
 		     status->drv_rx_counter,
 		     status->tx_results_counter);
 
-	/* update number of available TX blocks */
-	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		freed_blocks += le32_to_cpu(status->tx_released_blks[i]) -
-				wl->tx_blocks_freed[i];
-
-		wl->tx_blocks_freed[i] =
-			le32_to_cpu(status->tx_released_blks[i]);
-	}
+	freed_blocks = le32_to_cpu(status->total_released_blks) -
+		       wl->tx_blocks_freed;
+	wl->tx_blocks_freed = le32_to_cpu(status->total_released_blks);
 
 	wl->tx_allocated_blocks -= freed_blocks;
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS) {
-		/* Update num of allocated TX blocks per link and ps status */
-#if 0
-		wl1271_irq_update_links_status(wl, &full_status->ap);
-#endif
-		wl->tx_blocks_available += freed_blocks;
-	} else {
-		int avail = full_status->sta.tx_total - wl->tx_allocated_blocks;
+	avail = le32_to_cpu(status->tx_total) - wl->tx_allocated_blocks;
 
-		/*
-		 * The FW might change the total number of TX memblocks before
-		 * we get a notification about blocks being released. Thus, the
-		 * available blocks calculation might yield a temporary result
-		 * which is lower than the actual available blocks. Keeping in
-		 * mind that only blocks that were allocated can be moved from
-		 * TX to RX, tx_blocks_available should never decrease here.
-		 */
-		wl->tx_blocks_available = max((int)wl->tx_blocks_available,
-					      avail);
-	}
+	/*
+	 * The FW might change the total number of TX memblocks before
+	 * we get a notification about blocks being released. Thus, the
+	 * available blocks calculation might yield a temporary result
+	 * which is lower than the actual available blocks. Keeping in
+	 * mind that only blocks that were allocated can be moved from
+	 * TX to RX, tx_blocks_available should never decrease here.
+	 */
+	wl->tx_blocks_available = max((int)wl->tx_blocks_available,
+				      avail);
 
 	/* if more blocks are available now, tx work can be scheduled */
 	if (wl->tx_blocks_available > old_tx_blk_count)
 		clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 
+	/* for AP update num of allocated TX blocks per link and ps status */
+	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+#if 0
+		wl1271_irq_update_links_status(wl, status);
+#endif
+	}
+
 	/* update the host-chipset time offset */
 	getnstimeofday(&ts);
 	wl->time_offset = (timespec_to_ns(&ts) >> 10) -
 		(s64)le32_to_cpu(status->fw_localtime);
 }
 
@@ -956,13 +942,13 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 		 * wl1271_ps_elp_wakeup cannot be called concurrently.
 		 */
 		clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
 		smp_mb__after_clear_bit();
 
 		wl1271_fw_status(wl, wl->fw_status);
-		intr = le32_to_cpu(wl->fw_status->common.intr);
+		intr = le32_to_cpu(wl->fw_status->intr);
 		intr &= WL1271_INTR_MASK;
 		if (!intr) {
 			done = true;
 			continue;
 		}
 
@@ -975,13 +961,13 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 			goto out;
 		}
 
 		if (likely(intr & WL1271_ACX_INTR_DATA)) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
-			wl1271_rx(wl, &wl->fw_status->common);
+			wl1271_rx(wl, wl->fw_status);
 
 			/* Check if any tx blocks were freed */
 			spin_lock_irqsave(&wl->wl_lock, flags);
 			if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
 			    wl1271_tx_total_queue_count(wl) > 0) {
 				spin_unlock_irqrestore(&wl->wl_lock, flags);
@@ -992,13 +978,13 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 				wl1271_tx_work_locked(wl);
 			} else {
 				spin_unlock_irqrestore(&wl->wl_lock, flags);
 			}
 
 			/* check for tx results */
-			if (wl->fw_status->common.tx_results_counter !=
+			if (wl->fw_status->tx_results_counter !=
 			    (wl->tx_results_count & 0xff))
 				wl1271_tx_complete(wl);
 
 			/* Make sure the deferred queues don't get too long */
 			defer_count = skb_queue_len(&wl->deferred_tx_queue) +
 				      skb_queue_len(&wl->deferred_rx_queue);
@@ -1167,13 +1153,13 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 	 */
 	if (!wl1271_ps_elp_wakeup(wl))
 		wl12xx_cmd_stop_fwlog(wl);
 
 	/* Read the first memory block address */
 	wl1271_fw_status(wl, wl->fw_status);
-	first_addr = __le32_to_cpu(wl->fw_status->sta.log_start_addr);
+	first_addr = __le32_to_cpu(wl->fw_status->log_start_addr);
 	if (!first_addr)
 		goto out;
 
 	/* Traverse the memory blocks linked list */
 	addr = first_addr;
 	do {
@@ -1914,13 +1900,12 @@ out:
 	return ret;
 }
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues)
 {
-	int i;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
 	/* because of hardware recovery, we may get here twice */
 	if (wl->state != WL1271_STATE_ON)
 		return;
@@ -1995,14 +1980,13 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	 * this is performed after the cancel_work calls and the associated
 	 * mutex_lock, so that wl1271_op_add_interface does not accidentally
 	 * get executed before all these vars have been reset.
 	 */
 	wl->flags = 0;
 
-	for (i = 0; i < NUM_TX_QUEUES; i++)
-		wl->tx_blocks_freed[i] = 0;
+	wl->tx_blocks_freed = 0;
 
 	wl1271_debugfs_reset(wl);
 
 	kfree(wl->fw_status);
 	wl->fw_status = NULL;
 	kfree(wl->tx_res_if);
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 1a957d6..4ed23a1 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -27,20 +27,20 @@
 #include "wl12xx.h"
 #include "acx.h"
 #include "reg.h"
 #include "rx.h"
 #include "io.h"
 
-static u8 wl1271_rx_get_mem_block(struct wl1271_fw_common_status *status,
+static u8 wl1271_rx_get_mem_block(struct wl1271_fw_status *status,
 				  u32 drv_rx_counter)
 {
 	return le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
 		RX_MEM_BLOCK_MASK;
 }
 
-static u32 wl1271_rx_get_buf_size(struct wl1271_fw_common_status *status,
+static u32 wl1271_rx_get_buf_size(struct wl1271_fw_status *status,
 				 u32 drv_rx_counter)
 {
 	return (le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
 		RX_BUF_SIZE_MASK) >> RX_BUF_SIZE_SHIFT_DIV;
 }
 
@@ -160,13 +160,13 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	skb_queue_tail(&wl->deferred_rx_queue, skb);
 	queue_work(wl->freezable_wq, &wl->netstack_work);
 
 	return is_data;
 }
 
-void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
+void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 {
 	struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
 	u32 buf_size;
 	u32 fw_rx_counter  = status->fw_rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
 	u32 drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
 	u32 rx_counter;
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 094fff8..5ca482b 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -124,10 +124,10 @@ struct wl1271_rx_descriptor {
 		u8  hlid; /* AP FW */
 	} __packed;
 	u8  pad_len;
 	u8  reserved;
 } __packed;
 
-void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status);
+void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 360f3d2..260b78c 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -134,12 +134,13 @@ extern u32 wl12xx_debug_level;
 #define WL1271_ELP_HW_STATE_ASLEEP 0
 #define WL1271_ELP_HW_STATE_IRQ    1
 
 #define WL1271_DEFAULT_BEACON_INT  100
 #define WL1271_DEFAULT_DTIM_PERIOD 1
 
+#define WL1271_MAX_LINKS           8
 #define WL1271_AP_GLOBAL_HLID      0
 #define WL1271_AP_BROADCAST_HLID   1
 #define WL1271_AP_STA_HLID_START   2
 
 /*
  * When in AP-mode, we allow (at least) this number of mem-blocks
@@ -227,59 +228,51 @@ struct wl1271_stats {
 
 #define AP_MAX_STATIONS            5
 
 /* Broadcast and Global links + links to stations */
 #define AP_MAX_LINKS               (AP_MAX_STATIONS + 2)
 
-/* FW status registers common for AP/STA */
-struct wl1271_fw_common_status {
+/* FW status registers */
+struct wl1271_fw_status {
 	__le32 intr;
 	u8  fw_rx_counter;
 	u8  drv_rx_counter;
 	u8  reserved;
 	u8  tx_results_counter;
 	__le32 rx_pkt_descs[NUM_RX_PKT_DESC];
-	__le32 tx_released_blks[NUM_TX_QUEUES];
 	__le32 fw_localtime;
-} __packed;
-
-/* FW status registers for AP */
-struct wl1271_fw_ap_status {
-	struct wl1271_fw_common_status common;
-
-	/* Next fields valid only in AP FW */
 
 	/*
 	 * A bitmap (where each bit represents a single HLID)
 	 * to indicate if the station is in PS mode.
 	 */
 	__le32 link_ps_bitmap;
 
-	/* Number of freed MBs per HLID */
-	u8 tx_lnk_free_blks[AP_MAX_LINKS];
-	u8 padding_1[1];
-} __packed;
+	/*
+	 * A bitmap (where each bit represents a single HLID) to indicate
+	 * if the station is in Fast mode
+	 */
+	__le32 link_fast_bitmap;
 
-/* FW status registers for STA */
-struct wl1271_fw_sta_status {
-	struct wl1271_fw_common_status common;
+	/* Cumulative counter of total released mem blocks since FW-reset */
+	__le32 total_released_blks;
 
-	u8  tx_total;
-	u8  reserved1;
-	__le16 reserved2;
-	__le32 log_start_addr;
-} __packed;
+	/* Size (in Memory Blocks) of TX pool */
+	__le32 tx_total;
 
-struct wl1271_fw_full_status {
-	union {
-		struct wl1271_fw_common_status common;
-		struct wl1271_fw_sta_status sta;
-		struct wl1271_fw_ap_status ap;
-	};
-} __packed;
+	/* Cumulative counter of released mem-blocks per AC */
+	u8 tx_released_blks[NUM_TX_QUEUES];
 
+	/* Cumulative counter of freed MBs per HLID */
+	u8 tx_lnk_free_blks[WL1271_MAX_LINKS];
+
+	/* Cumulative counter of released Voice memory blocks */
+	u8 tx_voice_released_blks;
+	u8 padding_1[7];
+	__le32 log_start_addr;
+} __packed;
 
 struct wl1271_rx_mem_pool_addr {
 	u32 addr;
 	u32 addr_extra;
 };
 
@@ -398,13 +391,13 @@ struct wl1271 {
 	u8 ssid_len;
 	int channel;
 
 	struct wl1271_acx_mem_map *target_mem_map;
 
 	/* Accounting for allocated / available TX blocks on HW */
-	u32 tx_blocks_freed[NUM_TX_QUEUES];
+	u32 tx_blocks_freed;
 	u32 tx_blocks_available;
 	u32 tx_allocated_blocks;
 	u32 tx_results_count;
 
 	/* Transmitted TX packets counter for chipset interface */
 	u32 tx_packets_count;
@@ -534,13 +527,13 @@ struct wl1271 {
 	struct wl1271_stats stats;
 
 	__le32 buffer_32;
 	u32 buffer_cmd;
 	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
 
-	struct wl1271_fw_full_status *fw_status;
+	struct wl1271_fw_status *fw_status;
 	struct wl1271_tx_hw_res_if *tx_res_if;
 
 	struct ieee80211_vif *vif;
 
 	/* Current chipset configuration */
 	struct conf_drv_settings conf;
-- 
1.7.6.401.g6a319

