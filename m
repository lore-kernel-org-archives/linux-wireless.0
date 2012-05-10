Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab2EJJQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:19 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:18 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 49/78] wlcore/wl12xx/18xx: split fw_status struct into two
Date: Thu, 10 May 2012 12:13:54 +0300
Message-Id: <1336641263-5761-50-git-send-email-arik@wizery.com> (sfid-20120510_111637_918037_85329267)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of RX packet descriptors may vary from chip to chip and
in different firmware versions.  Unfortunately, the array that
contains the actual descriptors is in the middle of the fw_status
structure.  To manage this, we split the struct into two so we can
calculate the offset of what comes after the array and access the last
elements more easily.

[Changed the STATUS_LEN macro to be placement agnostic - Arik]

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c     |    4 +-
 drivers/net/wireless/ti/wl18xx/main.c     |    1 +
 drivers/net/wireless/ti/wl18xx/tx.c       |    2 +-
 drivers/net/wireless/ti/wlcore/main.c     |   64 ++++++++++++++++-------------
 drivers/net/wireless/ti/wlcore/rx.c       |   10 ++---
 drivers/net/wireless/ti/wlcore/rx.h       |    4 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |    5 ++-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   18 ++++++--
 8 files changed, 66 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 1d097c1..82e0c6a 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1156,7 +1156,8 @@ static u32 wl12xx_get_rx_packet_len(struct wl1271 *wl, void *rx_data,
 
 static void wl12xx_tx_delayed_compl(struct wl1271 *wl)
 {
-	if (wl->fw_status->tx_results_counter == (wl->tx_results_count & 0xff))
+	if (wl->fw_status_1->tx_results_counter ==
+	    (wl->tx_results_count & 0xff))
 		return;
 
 	wl1271_tx_complete(wl);
@@ -1414,6 +1415,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->ptable = wl12xx_ptable;
 	wl->rtable = wl12xx_rtable;
 	wl->num_tx_desc = 16;
+	wl->num_rx_desc = 8;
 	wl->normal_tx_spare = WL12XX_TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->gem_tx_spare = WL12XX_TX_HW_BLOCK_GEM_SPARE;
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index b76b6ac..df407be 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1041,6 +1041,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->ptable = wl18xx_ptable;
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = 32;
+	wl->num_rx_desc = 16;
 	wl->normal_tx_spare = WL18XX_TX_HW_BLOCK_SPARE;
 	wl->gem_tx_spare = WL18XX_TX_HW_GEM_BLOCK_SPARE;
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
diff --git a/drivers/net/wireless/ti/wl18xx/tx.c b/drivers/net/wireless/ti/wl18xx/tx.c
index 4e12f56..4de00b9 100644
--- a/drivers/net/wireless/ti/wl18xx/tx.c
+++ b/drivers/net/wireless/ti/wl18xx/tx.c
@@ -94,7 +94,7 @@ static void wl18xx_tx_complete_packet(struct wl1271 *wl, u8 tx_stat_byte)
 void wl18xx_tx_immediate_complete(struct wl1271 *wl)
 {
 	struct wl18xx_fw_status_priv *status_priv =
-		(struct wl18xx_fw_status_priv *)wl->fw_status->priv;
+		(struct wl18xx_fw_status_priv *)wl->fw_status_2->priv;
 	struct wl18xx_priv *priv = wl->priv;
 	u8 i;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3aadf74..3e3dce9 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -347,7 +347,7 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
 
 static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 					   struct wl12xx_vif *wlvif,
-					   struct wl_fw_status *status)
+					   struct wl_fw_status_2 *status)
 {
 	struct wl1271_link *lnk;
 	u32 cur_fw_ps_map;
@@ -379,7 +379,8 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 }
 
 static void wl12xx_fw_status(struct wl1271 *wl,
-			     struct wl_fw_status *status)
+			     struct wl_fw_status_1 *status_1,
+			     struct wl_fw_status_2 *status_2)
 {
 	struct wl12xx_vif *wlvif;
 	struct timespec ts;
@@ -388,37 +389,38 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 	int i;
 	size_t status_len;
 
-	status_len = sizeof(*status) + wl->fw_status_priv_len;
+	status_len = WLCORE_FW_STATUS_1_LEN(wl->num_rx_desc) +
+		sizeof(*status_2) + wl->fw_status_priv_len;
 
-	wlcore_raw_read_data(wl, REG_RAW_FW_STATUS_ADDR, status,
+	wlcore_raw_read_data(wl, REG_RAW_FW_STATUS_ADDR, status_1,
 			     status_len, false);
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
-		     status->intr,
-		     status->fw_rx_counter,
-		     status->drv_rx_counter,
-		     status->tx_results_counter);
+		     status_1->intr,
+		     status_1->fw_rx_counter,
+		     status_1->drv_rx_counter,
+		     status_1->tx_results_counter);
 
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		/* prevent wrap-around in freed-packets counter */
 		wl->tx_allocated_pkts[i] -=
-				(status->counters.tx_released_pkts[i] -
+				(status_2->counters.tx_released_pkts[i] -
 				wl->tx_pkts_freed[i]) & 0xff;
 
-		wl->tx_pkts_freed[i] = status->counters.tx_released_pkts[i];
+		wl->tx_pkts_freed[i] = status_2->counters.tx_released_pkts[i];
 	}
 
 	/* prevent wrap-around in total blocks counter */
 	if (likely(wl->tx_blocks_freed <=
-		   le32_to_cpu(status->total_released_blks)))
-		freed_blocks = le32_to_cpu(status->total_released_blks) -
+		   le32_to_cpu(status_2->total_released_blks)))
+		freed_blocks = le32_to_cpu(status_2->total_released_blks) -
 			       wl->tx_blocks_freed;
 	else
 		freed_blocks = 0x100000000LL - wl->tx_blocks_freed +
-			       le32_to_cpu(status->total_released_blks);
+			       le32_to_cpu(status_2->total_released_blks);
 
-	wl->tx_blocks_freed = le32_to_cpu(status->total_released_blks);
+	wl->tx_blocks_freed = le32_to_cpu(status_2->total_released_blks);
 
 	wl->tx_allocated_blocks -= freed_blocks;
 
@@ -434,7 +436,7 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 			cancel_delayed_work(&wl->tx_watchdog_work);
 	}
 
-	avail = le32_to_cpu(status->tx_total) - wl->tx_allocated_blocks;
+	avail = le32_to_cpu(status_2->tx_total) - wl->tx_allocated_blocks;
 
 	/*
 	 * The FW might change the total number of TX memblocks before
@@ -453,13 +455,13 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 
 	/* for AP update num of allocated TX blocks per link and ps status */
 	wl12xx_for_each_wlvif_ap(wl, wlvif) {
-		wl12xx_irq_update_links_status(wl, wlvif, status);
+		wl12xx_irq_update_links_status(wl, wlvif, status_2);
 	}
 
 	/* update the host-chipset time offset */
 	getnstimeofday(&ts);
 	wl->time_offset = (timespec_to_ns(&ts) >> 10) -
-		(s64)le32_to_cpu(status->fw_localtime);
+		(s64)le32_to_cpu(status_2->fw_localtime);
 }
 
 static void wl1271_flush_deferred_work(struct wl1271 *wl)
@@ -528,11 +530,11 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
 		smp_mb__after_clear_bit();
 
-		wl12xx_fw_status(wl, wl->fw_status);
+		wl12xx_fw_status(wl, wl->fw_status_1, wl->fw_status_2);
 
 		wlcore_hw_tx_immediate_compl(wl);
 
-		intr = le32_to_cpu(wl->fw_status->intr);
+		intr = le32_to_cpu(wl->fw_status_1->intr);
 		intr &= WL1271_INTR_MASK;
 		if (!intr) {
 			done = true;
@@ -551,7 +553,7 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		if (likely(intr & WL1271_ACX_INTR_DATA)) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
-			wl12xx_rx(wl, wl->fw_status);
+			wl12xx_rx(wl, wl->fw_status_1);
 
 			/* Check if any tx blocks were freed */
 			spin_lock_irqsave(&wl->wl_lock, flags);
@@ -786,8 +788,8 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 		wl12xx_cmd_stop_fwlog(wl);
 
 	/* Read the first memory block address */
-	wl12xx_fw_status(wl, wl->fw_status);
-	first_addr = le32_to_cpu(wl->fw_status->log_start_addr);
+	wl12xx_fw_status(wl, wl->fw_status_1, wl->fw_status_2);
+	first_addr = le32_to_cpu(wl->fw_status_2->log_start_addr);
 	if (!first_addr)
 		goto out;
 
@@ -901,13 +903,18 @@ static void wl1271_fw_wakeup(struct wl1271 *wl)
 
 static int wl1271_setup(struct wl1271 *wl)
 {
-	wl->fw_status = kmalloc(sizeof(*wl->fw_status), GFP_KERNEL);
-	if (!wl->fw_status)
+	wl->fw_status_1 = kmalloc(WLCORE_FW_STATUS_1_LEN(wl->num_rx_desc) +
+				  sizeof(*wl->fw_status_2), GFP_KERNEL);
+	if (!wl->fw_status_1)
 		return -ENOMEM;
 
+	wl->fw_status_2 = (struct wl_fw_status_2 *)
+				(((u8 *) wl->fw_status_1) +
+				WLCORE_FW_STATUS_1_LEN(wl->num_rx_desc));
+
 	wl->tx_res_if = kmalloc(sizeof(*wl->tx_res_if), GFP_KERNEL);
 	if (!wl->tx_res_if) {
-		kfree(wl->fw_status);
+		kfree(wl->fw_status_1);
 		return -ENOMEM;
 	}
 
@@ -1745,8 +1752,9 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 
 	wl1271_debugfs_reset(wl);
 
-	kfree(wl->fw_status);
-	wl->fw_status = NULL;
+	kfree(wl->fw_status_1);
+	wl->fw_status_1 = NULL;
+	wl->fw_status_2 = NULL;
 	kfree(wl->tx_res_if);
 	wl->tx_res_if = NULL;
 	kfree(wl->target_mem_map);
@@ -5180,7 +5188,7 @@ int wlcore_free_hw(struct wl1271 *wl)
 	kfree(wl->nvs);
 	wl->nvs = NULL;
 
-	kfree(wl->fw_status);
+	kfree(wl->fw_status_1);
 	kfree(wl->tx_res_if);
 	destroy_workqueue(wl->freezable_wq);
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index e2c5df6..406eed2 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -200,12 +200,12 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	return is_data;
 }
 
-void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status *status)
+void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status_1 *status)
 {
 	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
 	u32 buf_size;
-	u32 fw_rx_counter  = status->fw_rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
-	u32 drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
+	u32 fw_rx_counter = status->fw_rx_counter % wl->num_rx_desc;
+	u32 drv_rx_counter = wl->rx_counter % wl->num_rx_desc;
 	u32 rx_counter;
 	u32 pkt_len, align_pkt_len;
 	u32 pkt_offset, des;
@@ -224,7 +224,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status *status)
 				break;
 			buf_size += align_pkt_len;
 			rx_counter++;
-			rx_counter &= NUM_RX_PKT_DESC_MOD_MASK;
+			rx_counter %= wl->num_rx_desc;
 		}
 
 		if (buf_size == 0) {
@@ -264,7 +264,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status *status)
 
 			wl->rx_counter++;
 			drv_rx_counter++;
-			drv_rx_counter &= NUM_RX_PKT_DESC_MOD_MASK;
+			drv_rx_counter %= wl->num_rx_desc;
 			pkt_offset += wlcore_rx_get_align_buf_size(wl, pkt_len);
 		}
 	}
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index 277936e..9be7801 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -38,8 +38,6 @@
 #define RX_DESC_PACKETID_SHIFT 11
 #define RX_MAX_PACKET_ID 3
 
-#define NUM_RX_PKT_DESC_MOD_MASK   7
-
 #define RX_DESC_VALID_FCS         0x0001
 #define RX_DESC_MATCH_RXADDR1     0x0002
 #define RX_DESC_MCAST             0x0004
@@ -139,7 +137,7 @@ struct wl1271_rx_descriptor {
 	u8  reserved;
 } __packed;
 
-void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status *status);
+void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status_1 *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 int wl1271_rx_filter_enable(struct wl1271 *wl,
 			    int index, bool enable,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 1fc3c77..9ca3829 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -269,7 +269,8 @@ struct wl1271 {
 	u32 buffer_cmd;
 	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
 
-	struct wl_fw_status *fw_status;
+	struct wl_fw_status_1 *fw_status_1;
+	struct wl_fw_status_2 *fw_status_2;
 	struct wl1271_tx_hw_res_if *tx_res_if;
 
 	/* Current chipset configuration */
@@ -337,6 +338,8 @@ struct wl1271 {
 
 	/* number of TX descriptors the HW supports. */
 	u32 num_tx_desc;
+	/* number of RX descriptors the HW supports. */
+	u32 num_rx_desc;
 
 	/* spare Tx blocks for normal/GEM operating modes */
 	u32 normal_tx_spare;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 53263a9..0422753 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -141,7 +141,6 @@ struct wl1271_stats {
 };
 
 #define NUM_TX_QUEUES              4
-#define NUM_RX_PKT_DESC            8
 
 #define AP_MAX_STATIONS            8
 
@@ -159,13 +158,26 @@ struct wl_fw_packet_counters {
 } __packed;
 
 /* FW status registers */
-struct wl_fw_status {
+struct wl_fw_status_1 {
 	__le32 intr;
 	u8  fw_rx_counter;
 	u8  drv_rx_counter;
 	u8  reserved;
 	u8  tx_results_counter;
-	__le32 rx_pkt_descs[NUM_RX_PKT_DESC];
+	__le32 rx_pkt_descs[0];
+} __packed;
+
+/*
+ * Each HW arch has a different number of Rx descriptors.
+ * The length of the status depends on it, since it holds an array
+ * of descriptors.
+ */
+#define WLCORE_FW_STATUS_1_LEN(num_rx_desc) \
+		(sizeof(struct wl_fw_status_1) + \
+		(sizeof(((struct wl_fw_status_1 *)0)->rx_pkt_descs[0])) * \
+		num_rx_desc)
+
+struct wl_fw_status_2 {
 	__le32 fw_localtime;
 
 	/*
-- 
1.7.9.5

