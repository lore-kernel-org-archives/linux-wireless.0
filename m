Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62112 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab1FXKDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 06:03:46 -0400
Received: by wyb38 with SMTP id 38so1814083wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 03:03:44 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/3] wl12xx: schedule TX packets according to FW occupancy
Date: Fri, 24 Jun 2011 13:03:35 +0300
Message-Id: <1308909817-25689-1-git-send-email-arik@wizery.com> (sfid-20110624_120350_356801_3DFACD91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When selecting packets for transmission, prefer the ACs that are least
occupied in the FW. When packets for multiple ACs are present in the FW,
it decides which to transmit according to WMM QoS parameters.

With these changes, lower priority ACs should not be starved when higher
priority traffic is present.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    5 ++-
 drivers/net/wireless/wl12xx/main.c    |   30 +++++++++++----
 drivers/net/wireless/wl12xx/tx.c      |   68 ++++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/wl12xx.h  |    2 +-
 4 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index c3f19463..70c9e4c 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -338,7 +338,10 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 #define DRIVER_STATE_PRINT_HEX(x)  DRIVER_STATE_PRINT(x, "0x%x")
 
 	DRIVER_STATE_PRINT_INT(tx_blocks_available);
-	DRIVER_STATE_PRINT_INT(tx_allocated_blocks);
+	DRIVER_STATE_PRINT_INT(tx_allocated_blocks[0]);
+	DRIVER_STATE_PRINT_INT(tx_allocated_blocks[1]);
+	DRIVER_STATE_PRINT_INT(tx_allocated_blocks[2]);
+	DRIVER_STATE_PRINT_INT(tx_allocated_blocks[3]);
 	DRIVER_STATE_PRINT_INT(tx_frames_cnt);
 	DRIVER_STATE_PRINT_LHEX(tx_frames_map[0]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..d3e1eb6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -783,13 +783,24 @@ static void wl1271_irq_update_links_status(struct wl1271 *wl,
 	}
 }
 
+static u32 wl1271_tx_allocated_blocks(struct wl1271 *wl)
+{
+	int i;
+	u32 total_alloc_blocks = 0;
+
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		total_alloc_blocks += wl->tx_allocated_blocks[i];
+
+	return total_alloc_blocks;
+}
+
 static void wl1271_fw_status(struct wl1271 *wl,
 			     struct wl1271_fw_full_status *full_status)
 {
 	struct wl1271_fw_common_status *status = &full_status->common;
 	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
-	u32 freed_blocks = 0;
+	u32 freed_blocks = 0, ac_freed_blocks;
 	int i;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
@@ -809,21 +820,23 @@ static void wl1271_fw_status(struct wl1271 *wl,
 
 	/* update number of available TX blocks */
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		freed_blocks += le32_to_cpu(status->tx_released_blks[i]) -
-				wl->tx_blocks_freed[i];
+		ac_freed_blocks = le32_to_cpu(status->tx_released_blks[i]) -
+				  wl->tx_blocks_freed[i];
+		freed_blocks += ac_freed_blocks;
+
+		wl->tx_allocated_blocks[i] -= ac_freed_blocks;
 
 		wl->tx_blocks_freed[i] =
 			le32_to_cpu(status->tx_released_blks[i]);
 	}
 
-	wl->tx_allocated_blocks -= freed_blocks;
-
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		/* Update num of allocated TX blocks per link and ps status */
 		wl1271_irq_update_links_status(wl, &full_status->ap);
 		wl->tx_blocks_available += freed_blocks;
 	} else {
-		int avail = full_status->sta.tx_total - wl->tx_allocated_blocks;
+		int avail = full_status->sta.tx_total -
+			    wl1271_tx_allocated_blocks(wl);
 
 		/*
 		 * The FW might change the total number of TX memblocks before
@@ -1831,7 +1844,6 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->tx_blocks_available = 0;
-	wl->tx_allocated_blocks = 0;
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
 	wl->tx_security_last_seq = 0;
@@ -1854,8 +1866,10 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	 */
 	wl->flags = 0;
 
-	for (i = 0; i < NUM_TX_QUEUES; i++)
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		wl->tx_blocks_freed[i] = 0;
+		wl->tx_allocated_blocks[i] = 0;
+	}
 
 	wl1271_debugfs_reset(wl);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 6603e60..ce33590 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -168,7 +168,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 len;
 	u32 total_blocks;
-	int id, ret = -EBUSY;
+	int id, ret = -EBUSY, ac;
 	u32 spare_blocks;
 
 	if (unlikely(wl->quirks & WL12XX_QUIRK_USE_2_SPARE_BLOCKS))
@@ -206,7 +206,9 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 		desc->id = id;
 
 		wl->tx_blocks_available -= total_blocks;
-		wl->tx_allocated_blocks += total_blocks;
+
+		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
+		wl->tx_allocated_blocks[ac] += total_blocks;
 
 		if (wl->bss_type == BSS_TYPE_AP_BSS)
 			wl->links[hlid].allocated_blks += total_blocks;
@@ -453,21 +455,41 @@ void wl1271_handle_tx_low_watermark(struct wl1271 *wl)
 	}
 }
 
+static struct sk_buff_head *wl1271_select_queue(struct wl1271 *wl,
+						struct sk_buff_head *queues)
+{
+	int i, q = -1;
+	u32 min_blks = 0xffffffff;
+
+	/*
+	 * Find a non-empty ac where:
+	 * 1. There are packets to transmit
+	 * 2. The FW has the least allocated blocks
+	 */
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		if (!skb_queue_empty(&queues[i]) &&
+		    (wl->tx_allocated_blocks[i] < min_blks)) {
+			q = i;
+			min_blks = wl->tx_allocated_blocks[q];
+		}
+
+	if (q == -1)
+		return NULL;
+
+	return &queues[q];
+}
+
 static struct sk_buff *wl1271_sta_skb_dequeue(struct wl1271 *wl)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
+	struct sk_buff_head *queue;
 
-	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_VO]);
-	if (skb)
-		goto out;
-	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_VI]);
-	if (skb)
+	queue = wl1271_select_queue(wl, wl->tx_queue);
+	if (!queue)
 		goto out;
-	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_BE]);
-	if (skb)
-		goto out;
-	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_BK]);
+
+	skb = skb_dequeue(queue);
 
 out:
 	if (skb) {
@@ -484,6 +506,7 @@ static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl)
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
 	int i, h, start_hlid;
+	struct sk_buff_head *queue;
 
 	/* start from the link after the last one */
 	start_hlid = (wl->last_tx_hlid + 1) % AP_MAX_LINKS;
@@ -492,21 +515,20 @@ static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl)
 	for (i = 0; i < AP_MAX_LINKS; i++) {
 		h = (start_hlid + i) % AP_MAX_LINKS;
 
-		skb = skb_dequeue(&wl->links[h].tx_queue[CONF_TX_AC_VO]);
-		if (skb)
-			goto out;
-		skb = skb_dequeue(&wl->links[h].tx_queue[CONF_TX_AC_VI]);
-		if (skb)
-			goto out;
-		skb = skb_dequeue(&wl->links[h].tx_queue[CONF_TX_AC_BE]);
-		if (skb)
-			goto out;
-		skb = skb_dequeue(&wl->links[h].tx_queue[CONF_TX_AC_BK]);
+		/* only consider connected stations */
+		if (h >= WL1271_AP_STA_HLID_START &&
+		    !test_bit(h - WL1271_AP_STA_HLID_START, wl->ap_hlid_map))
+			continue;
+
+		queue = wl1271_select_queue(wl, wl->links[h].tx_queue);
+		if (!queue)
+			continue;
+
+		skb = skb_dequeue(queue);
 		if (skb)
-			goto out;
+			break;
 	}
 
-out:
 	if (skb) {
 		wl->last_tx_hlid = h;
 		spin_lock_irqsave(&wl->wl_lock, flags);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1cafb08..a476fea 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -422,7 +422,7 @@ struct wl1271 {
 	/* Accounting for allocated / available TX blocks on HW */
 	u32 tx_blocks_freed[NUM_TX_QUEUES];
 	u32 tx_blocks_available;
-	u32 tx_allocated_blocks;
+	u32 tx_allocated_blocks[NUM_TX_QUEUES];
 	u32 tx_results_count;
 
 	/* Transmitted TX packets counter for chipset interface */
-- 
1.7.4.1

