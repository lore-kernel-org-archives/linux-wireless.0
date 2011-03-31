Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38506 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab1CaIHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 04:07:23 -0400
Received: by fxm17 with SMTP id 17so1636332fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 01:07:22 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/5] wl12xx: Simplify TX blocks accounting
Date: Thu, 31 Mar 2011 10:07:00 +0200
Message-Id: <1301558821-17787-5-git-send-email-ido@wizery.com>
In-Reply-To: <1301558821-17787-1-git-send-email-ido@wizery.com>
References: <1301558821-17787-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The total number of TX memory blocks may change when the dynamic memory
option is enabled. The current implementation only tracks the available
memory blocks, which over-complicates TX blocks accounting.

By tracking the number of allocated blocks, calculation of the number of
available blocks becomes simpler and cleaner. It simply equals the total
number of TX memory blocks minus the allocated ones.

Also, remove some unnecessary castings and use union member accesses
instead.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c    |    2 -
 drivers/net/wireless/wl12xx/main.c   |   48 +++++++++++++++------------------
 drivers/net/wireless/wl12xx/tx.c     |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h |    4 +--
 4 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index e005aa4..b277947 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1081,8 +1081,6 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl)
 	wl1271_debug(DEBUG_TX, "available tx blocks: %d",
 		     wl->tx_blocks_available);
 
-	wl->tx_new_total = wl->tx_blocks_available;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dea26a9..f1c9941 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -622,7 +622,7 @@ static void wl1271_fw_status(struct wl1271 *wl,
 	struct wl1271_fw_common_status *status = &full_status->common;
 	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
-	u32 total = 0;
+	u32 freed_blocks = 0;
 	int i;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
@@ -631,15 +631,6 @@ static void wl1271_fw_status(struct wl1271 *wl,
 	} else {
 		wl1271_raw_read(wl, FW_STATUS_ADDR, status,
 				sizeof(struct wl1271_fw_sta_status), false);
-
-		/* Update tx total blocks change */
-		wl->tx_total_diff +=
-			((struct wl1271_fw_sta_status *)status)->tx_total -
-			wl->tx_new_total;
-
-		/* Update total tx blocks */
-		wl->tx_new_total =
-			((struct wl1271_fw_sta_status *)status)->tx_total;
 	}
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
@@ -651,34 +642,38 @@ static void wl1271_fw_status(struct wl1271 *wl,
 
 	/* update number of available TX blocks */
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		total += le32_to_cpu(status->tx_released_blks[i]) -
-			wl->tx_blocks_freed[i];
+		freed_blocks += le32_to_cpu(status->tx_released_blks[i]) -
+				wl->tx_blocks_freed[i];
 
 		wl->tx_blocks_freed[i] =
 			le32_to_cpu(status->tx_released_blks[i]);
-
 	}
 
-	/*
-	 * By adding the freed blocks to tx_total_diff we are actually
-	 * moving them to the RX pool.
-	 */
-	wl->tx_total_diff += total;
+	wl->tx_allocated_blocks -= freed_blocks;
+
+	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+		/* Update num of allocated TX blocks per link and ps status */
+		wl1271_irq_update_links_status(wl, &full_status->ap);
+		wl->tx_blocks_available += freed_blocks;
+	} else {
+		int avail = full_status->sta.tx_total - wl->tx_allocated_blocks;
 
-	/* if we have positive difference, add the blocks to the TX pool */
-	if (wl->tx_total_diff >= 0) {
-		wl->tx_blocks_available += wl->tx_total_diff;
-		wl->tx_total_diff = 0;
+		/*
+		 * The FW might change the total number of TX memblocks before
+		 * we get a notification about blocks being released. Thus, the
+		 * available blocks calculation might yield a temporary result
+		 * which is lower than the actual available blocks. Keeping in
+		 * mind that only blocks that were allocated can be moved from
+		 * TX to RX, tx_blocks_available should never decrease here.
+		 */
+		wl->tx_blocks_available = max((int)wl->tx_blocks_available,
+					      avail);
 	}
 
 	/* if more blocks are available now, tx work can be scheduled */
 	if (wl->tx_blocks_available > old_tx_blk_count)
 		clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 
-	/* for AP update num of allocated TX blocks per link and ps status */
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		wl1271_irq_update_links_status(wl, &full_status->ap);
-
 	/* update the host-chipset time offset */
 	getnstimeofday(&ts);
 	wl->time_offset = (timespec_to_ns(&ts) >> 10) -
@@ -1479,6 +1474,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->tx_blocks_available = 0;
+	wl->tx_allocated_blocks = 0;
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
 	wl->tx_security_last_seq = 0;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 18d9655..f0abb71 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -181,6 +181,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 		desc->id = id;
 
 		wl->tx_blocks_available -= total_blocks;
+		wl->tx_allocated_blocks += total_blocks;
 
 		if (wl->bss_type == BSS_TYPE_AP_BSS)
 			wl->links[hlid].allocated_blks += total_blocks;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 87e96ba..34b03eb 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -416,10 +416,8 @@ struct wl1271 {
 	/* Accounting for allocated / available TX blocks on HW */
 	u32 tx_blocks_freed[NUM_TX_QUEUES];
 	u32 tx_blocks_available;
+	u32 tx_allocated_blocks;
 	u32 tx_results_count;
-	/* Indicates how many memory blocks should be moved to the RX pool */
-	int tx_total_diff;
-	u32 tx_new_total;
 
 	/* Transmitted TX packets counter for chipset interface */
 	u32 tx_packets_count;
-- 
1.7.1

