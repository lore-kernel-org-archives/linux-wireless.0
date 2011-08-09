Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1HIJOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:35 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:34 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 34/40] wl12xx: schedule TX packets according to FW packet occupancy
Date: Tue,  9 Aug 2011 12:13:47 +0300
Message-Id: <1312881233-9366-35-git-send-email-eliad@wizery.com> (sfid-20110809_111448_250557_9D33AA78)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When selecting packets for transmission, prefer the ACs that are least
occupied in the FW. When packets for multiple ACs are present in the FW,
it decides which to transmit according to WMM QoS parameters.

With these changes, lower priority ACs should not be starved when higher
priority traffic is present.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    4 ++
 drivers/net/wireless/wl12xx/main.c    |    7 ++-
 drivers/net/wireless/wl12xx/tx.c      |   67 +++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/wl12xx.h  |    2 +-
 4 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 3102652..d59354f 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -337,12 +337,16 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 #define DRIVER_STATE_PRINT_STR(x)  DRIVER_STATE_PRINT(x, "%s")
 #define DRIVER_STATE_PRINT_LHEX(x) DRIVER_STATE_PRINT(x, "0x%lx")
 #define DRIVER_STATE_PRINT_HEX(x)  DRIVER_STATE_PRINT(x, "0x%x")
 
 	DRIVER_STATE_PRINT_INT(tx_blocks_available);
 	DRIVER_STATE_PRINT_INT(tx_allocated_blocks);
+	DRIVER_STATE_PRINT_INT(tx_allocated_pkts[0]);
+	DRIVER_STATE_PRINT_INT(tx_allocated_pkts[1]);
+	DRIVER_STATE_PRINT_INT(tx_allocated_pkts[2]);
+	DRIVER_STATE_PRINT_INT(tx_allocated_pkts[3]);
 	DRIVER_STATE_PRINT_INT(tx_frames_cnt);
 	DRIVER_STATE_PRINT_LHEX(tx_frames_map[0]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[0]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[1]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[2]);
 	DRIVER_STATE_PRINT_INT(tx_queue_count[3]);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3bfd772..755415a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -823,13 +823,13 @@ static void wl1271_fw_status(struct wl1271 *wl,
 		     status->fw_rx_counter,
 		     status->drv_rx_counter,
 		     status->tx_results_counter);
 
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		/* prevent wrap-around in freed-packets counter */
-		wl->tx_allocated_pkts -=
+		wl->tx_allocated_pkts[i] -=
 				(status->tx_released_pkts[i] -
 				wl->tx_pkts_freed[i] + 256) % 256;
 
 		wl->tx_pkts_freed[i] = status->tx_released_pkts[i];
 	}
 
@@ -2037,15 +2037,16 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	 * get executed before all these vars have been reset.
 	 */
 	wl->flags = 0;
 
 	wl->tx_blocks_freed = 0;
 
-	wl->tx_allocated_pkts = 0;
-	for (i = 0; i < NUM_TX_QUEUES; i++)
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		wl->tx_pkts_freed[i] = 0;
+		wl->tx_allocated_pkts[i] = 0;
+	}
 
 	wl1271_debugfs_reset(wl);
 
 	kfree(wl->fw_status);
 	wl->fw_status = NULL;
 	kfree(wl->tx_res_if);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 4a40bc4..d184da1 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -182,13 +182,13 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 				u32 buf_offset, u8 hlid)
 {
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 len;
 	u32 total_blocks;
-	int id, ret = -EBUSY;
+	int id, ret = -EBUSY, ac;
 
 	/* we use 1 spare block */
 	u32 spare_blocks = 1;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
 		return -EAGAIN;
@@ -219,13 +219,14 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 
 		desc->id = id;
 
 		wl->tx_blocks_available -= total_blocks;
 		wl->tx_allocated_blocks += total_blocks;
 
-		wl->tx_allocated_pkts++;
+		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
+		wl->tx_allocated_pkts[ac]++;
 
 		if (wl->bss_type == BSS_TYPE_AP_BSS)
 			wl->links[hlid].allocated_blks += total_blocks;
 
 		ret = 0;
 
@@ -477,27 +478,47 @@ void wl1271_handle_tx_low_watermark(struct wl1271 *wl)
 			clear_bit(i, &wl->stopped_queues_map);
 			spin_unlock_irqrestore(&wl->wl_lock, flags);
 		}
 	}
 }
 
+static struct sk_buff_head *wl1271_select_queue(struct wl1271 *wl,
+						struct sk_buff_head *queues)
+{
+	int i, q = -1;
+	u32 min_pkts = 0xffffffff;
+
+	/*
+	 * Find a non-empty ac where:
+	 * 1. There are packets to transmit
+	 * 2. The FW has the least allocated blocks
+	 */
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		if (!skb_queue_empty(&queues[i]) &&
+		    (wl->tx_allocated_pkts[i] < min_pkts)) {
+			q = i;
+			min_pkts = wl->tx_allocated_pkts[q];
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
 		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		wl->tx_queue_count[q]--;
@@ -509,35 +530,35 @@ out:
 
 static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
 	int i, h, start_hlid;
+	struct sk_buff_head *queue;
 
 	/* start from the link after the last one */
 	start_hlid = (wl->last_tx_hlid + 1) % AP_MAX_LINKS;
 
 	/* dequeue according to AC, round robin on each link */
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
 		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->last_tx_hlid = h;
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		wl->tx_queue_count[q]--;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3e2e0b3..c3996b2 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -422,13 +422,13 @@ struct wl1271 {
 	u32 tx_blocks_available;
 	u32 tx_allocated_blocks;
 	u32 tx_results_count;
 
 	/* Accounting for allocated / available Tx packets in HW */
 	u32 tx_pkts_freed[NUM_TX_QUEUES];
-	u32 tx_allocated_pkts;
+	u32 tx_allocated_pkts[NUM_TX_QUEUES];
 
 	/* Transmitted TX packets counter for chipset interface */
 	u32 tx_packets_count;
 
 	/* Time-offset between host and chipset clocks */
 	s64 time_offset;
-- 
1.7.6.401.g6a319

