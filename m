Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55381 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1HNKSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:18:06 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so4061056wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:18:05 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 33/40] wl12xx: track freed packets in FW by AC
Date: Sun, 14 Aug 2011 13:17:32 +0300
Message-Id: <1313317059-16567-34-git-send-email-eliad@wizery.com> (sfid-20110814_121810_153369_C1FB14A6)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Track the number of freed packets in each AC when receiving an interrupt
from the FW. This paves the way for tracking allocated packets per AC.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: use bitwise-and instead of modulus

 drivers/net/wireless/wl12xx/main.c   |   16 +++++++++++++++-
 drivers/net/wireless/wl12xx/tx.c     |    2 ++
 drivers/net/wireless/wl12xx/wl12xx.h |    8 ++++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0ef63b5..479977d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -811,22 +811,32 @@ static void wl1271_irq_update_links_status(struct wl1271 *wl,
 static void wl12xx_fw_status(struct wl1271 *wl,
 			     struct wl12xx_fw_status *status)
 {
 	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
 	int avail, freed_blocks;
+	int i;
 
 	wl1271_raw_read(wl, FW_STATUS_ADDR, status, sizeof(*status), false);
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
 		     status->intr,
 		     status->fw_rx_counter,
 		     status->drv_rx_counter,
 		     status->tx_results_counter);
 
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		/* prevent wrap-around in freed-packets counter */
+		wl->tx_allocated_pkts -=
+				(status->tx_released_pkts[i] -
+				wl->tx_pkts_freed[i]) & 0xff;
+
+		wl->tx_pkts_freed[i] = status->tx_released_pkts[i];
+	}
+
 	freed_blocks = le32_to_cpu(status->total_released_blks) -
 		       wl->tx_blocks_freed;
 	wl->tx_blocks_freed = le32_to_cpu(status->total_released_blks);
 
 	wl->tx_allocated_blocks -= freed_blocks;
 
@@ -1931,13 +1941,13 @@ out:
 	return ret;
 }
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues)
 {
-	int ret;
+	int ret, i;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
 	/* because of hardware recovery, we may get here twice */
 	if (wl->state != WL1271_STATE_ON)
 		return;
@@ -2047,12 +2057,16 @@ deinit:
 	 * get executed before all these vars have been reset.
 	 */
 	wl->flags = 0;
 
 	wl->tx_blocks_freed = 0;
 
+	wl->tx_allocated_pkts = 0;
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		wl->tx_pkts_freed[i] = 0;
+
 	wl1271_debugfs_reset(wl);
 
 	kfree(wl->fw_status);
 	wl->fw_status = NULL;
 	kfree(wl->tx_res_if);
 	wl->tx_res_if = NULL;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 8fdffd0..7dd6d8b 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -239,12 +239,14 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 
 		desc->id = id;
 
 		wl->tx_blocks_available -= total_blocks;
 		wl->tx_allocated_blocks += total_blocks;
 
+		wl->tx_allocated_pkts++;
+
 		if (wl->bss_type == BSS_TYPE_AP_BSS)
 			wl->links[hlid].allocated_blks += total_blocks;
 
 		ret = 0;
 
 		wl1271_debug(DEBUG_TX,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 416d68e..24b4025 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -265,14 +265,14 @@ struct wl12xx_fw_status {
 	/* Cumulative counter of total released mem blocks since FW-reset */
 	__le32 total_released_blks;
 
 	/* Size (in Memory Blocks) of TX pool */
 	__le32 tx_total;
 
-	/* Cumulative counter of released mem-blocks per AC */
-	u8 tx_released_blks[NUM_TX_QUEUES];
+	/* Cumulative counter of released packets per AC */
+	u8 tx_released_pkts[NUM_TX_QUEUES];
 
 	/* Cumulative counter of freed MBs per HLID */
 	u8 tx_lnk_free_blks[WL12XX_MAX_LINKS];
 
 	/* Cumulative counter of released Voice memory blocks */
 	u8 tx_voice_released_blks;
@@ -419,12 +419,16 @@ struct wl1271 {
 	/* Accounting for allocated / available TX blocks on HW */
 	u32 tx_blocks_freed;
 	u32 tx_blocks_available;
 	u32 tx_allocated_blocks;
 	u32 tx_results_count;
 
+	/* Accounting for allocated / available Tx packets in HW */
+	u32 tx_pkts_freed[NUM_TX_QUEUES];
+	u32 tx_allocated_pkts;
+
 	/* Transmitted TX packets counter for chipset interface */
 	u32 tx_packets_count;
 
 	/* Time-offset between host and chipset clocks */
 	s64 time_offset;
 
-- 
1.7.6.401.g6a319

