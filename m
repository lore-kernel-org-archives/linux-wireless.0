Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33715 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab1GGLZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 07:25:29 -0400
Received: by wyg8 with SMTP id 8so566731wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jul 2011 04:25:28 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: start/stop queues according to global per-AC counters
Date: Thu,  7 Jul 2011 14:25:23 +0300
Message-Id: <1310037923-3149-1-git-send-email-arik@wizery.com> (sfid-20110707_132533_497299_8B090608)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split tx_queue_count to count per-AC skb's queued, instead of relying on
the skb-queue len. The skb queues used were only valid in STA-mode, as
AP-mode uses per-link queues.

This fixes a major regression in AP-mode, caused by the patch
"wl12xx: implement Tx watermarks per AC". With that patch applied, we
effectively had no regulation of Tx queues in AP-mode. Therefore a
sustained high rate of Tx could cause exhaustion of the skb memory pool.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    8 ++++++--
 drivers/net/wireless/wl12xx/main.c    |   13 +++++++------
 drivers/net/wireless/wl12xx/ps.c      |    9 ++++++---
 drivers/net/wireless/wl12xx/tx.c      |   33 +++++++++++++++++++++------------
 drivers/net/wireless/wl12xx/tx.h      |   10 ++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h  |    2 +-
 6 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 70c9e4c..4ba00e1 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -30,6 +30,7 @@
 #include "acx.h"
 #include "ps.h"
 #include "io.h"
+#include "tx.h"
 
 /* ms */
 #define WL1271_DEBUGFS_STATS_LIFETIME 1000
@@ -233,7 +234,7 @@ static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 	char buf[20];
 	int res;
 
-	queue_len = wl->tx_queue_count;
+	queue_len = wl1271_tx_total_queue_count(wl);
 
 	res = scnprintf(buf, sizeof(buf), "%u\n", queue_len);
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
@@ -344,7 +345,10 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(tx_allocated_blocks[3]);
 	DRIVER_STATE_PRINT_INT(tx_frames_cnt);
 	DRIVER_STATE_PRINT_LHEX(tx_frames_map[0]);
-	DRIVER_STATE_PRINT_INT(tx_queue_count);
+	DRIVER_STATE_PRINT_INT(tx_queue_count[0]);
+	DRIVER_STATE_PRINT_INT(tx_queue_count[1]);
+	DRIVER_STATE_PRINT_INT(tx_queue_count[2]);
+	DRIVER_STATE_PRINT_INT(tx_queue_count[3]);
 	DRIVER_STATE_PRINT_INT(tx_packets_count);
 	DRIVER_STATE_PRINT_INT(tx_results_count);
 	DRIVER_STATE_PRINT_LHEX(flags);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 166287f..a457615 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -951,7 +951,7 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 			/* Check if any tx blocks were freed */
 			spin_lock_irqsave(&wl->wl_lock, flags);
 			if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
-			    wl->tx_queue_count) {
+			    wl1271_tx_total_queue_count(wl) > 0) {
 				spin_unlock_irqrestore(&wl->wl_lock, flags);
 				/*
 				 * In order to avoid starvation of the TX path,
@@ -999,7 +999,7 @@ out:
 	/* In case TX was not handled here, queue TX work */
 	clear_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
 	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
-	    wl->tx_queue_count)
+	    wl1271_tx_total_queue_count(wl) > 0)
 		ieee80211_queue_work(wl->hw, &wl->tx_work);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
@@ -1382,13 +1382,13 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
-	wl->tx_queue_count++;
+	wl->tx_queue_count[q]++;
 
 	/*
 	 * The workqueue is slow to process the tx_queue and we need stop
 	 * the queue here, otherwise the queue will get too long.
 	 */
-	if (skb_queue_len(&wl->tx_queue[q]) >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
+	if (wl->tx_queue_count[q] >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
 		wl1271_debug(DEBUG_TX, "op_tx: stopping queues for q %d", q);
 		ieee80211_stop_queue(wl->hw, mapping);
 		set_bit(q, &wl->stopped_queues_map);
@@ -1417,10 +1417,11 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 int wl1271_tx_dummy_packet(struct wl1271 *wl)
 {
 	unsigned long flags;
+	int q = wl1271_tx_get_queue(skb_get_queue_mapping(wl->dummy_packet));
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	set_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags);
-	wl->tx_queue_count++;
+	wl->tx_queue_count[q]++;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	/* The FW is low on RX memory blocks, so send the dummy packet asap */
@@ -3538,7 +3539,7 @@ static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
 		goto out;
 
 	/* packets are considered pending if in the TX queue or the FW */
-	ret = (wl->tx_queue_count > 0) || (wl->tx_frames_cnt > 0);
+	ret = (wl1271_tx_total_queue_count(wl) > 0) || (wl->tx_frames_cnt > 0);
 
 	/* the above is appropriate for STA mode for PS purposes */
 	WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index d3e377d..d1dc0cc 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -193,24 +193,27 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 
 static void wl1271_ps_filter_frames(struct wl1271 *wl, u8 hlid)
 {
-	int i, filtered = 0;
+	int i;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
 	unsigned long flags;
+	int filtered[NUM_TX_QUEUES];
 
 	/* filter all frames currently the low level queus for this hlid */
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		filtered[i] = 0;
 		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
 			info = IEEE80211_SKB_CB(skb);
 			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 			info->status.rates[0].idx = -1;
 			ieee80211_tx_status(wl->hw, skb);
-			filtered++;
+			filtered[i]++;
 		}
 	}
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
-	wl->tx_queue_count -= filtered;
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		wl->tx_queue_count[i] -= filtered[i];
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	wl1271_handle_tx_low_watermark(wl);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ef54cee..6f4959d 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -448,8 +448,7 @@ void wl1271_handle_tx_low_watermark(struct wl1271 *wl)
 
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		if (test_bit(i, &wl->stopped_queues_map) &&
-		    skb_queue_len(&wl->tx_queue[i]) <=
-						WL1271_TX_QUEUE_LOW_WATERMARK) {
+		    wl->tx_queue_count[i] <= WL1271_TX_QUEUE_LOW_WATERMARK) {
 			/* firmware buffer has space, restart queues */
 			spin_lock_irqsave(&wl->wl_lock, flags);
 			ieee80211_wake_queue(wl->hw,
@@ -498,8 +497,9 @@ static struct sk_buff *wl1271_sta_skb_dequeue(struct wl1271 *wl)
 
 out:
 	if (skb) {
+		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		spin_lock_irqsave(&wl->wl_lock, flags);
-		wl->tx_queue_count--;
+		wl->tx_queue_count[q]--;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
 
@@ -535,9 +535,10 @@ static struct sk_buff *wl1271_ap_skb_dequeue(struct wl1271 *wl)
 	}
 
 	if (skb) {
+		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->last_tx_hlid = h;
 		spin_lock_irqsave(&wl->wl_lock, flags);
-		wl->tx_queue_count--;
+		wl->tx_queue_count[q]--;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	} else {
 		wl->last_tx_hlid = 0;
@@ -558,9 +559,12 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 
 	if (!skb &&
 	    test_and_clear_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags)) {
+		int q;
+
 		skb = wl->dummy_packet;
+		q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		spin_lock_irqsave(&wl->wl_lock, flags);
-		wl->tx_queue_count--;
+		wl->tx_queue_count[q]--;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
 
@@ -585,7 +589,7 @@ static void wl1271_skb_queue_head(struct wl1271 *wl, struct sk_buff *skb)
 	}
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
-	wl->tx_queue_count++;
+	wl->tx_queue_count[q]++;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
 
@@ -799,23 +803,26 @@ void wl1271_tx_complete(struct wl1271 *wl)
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 {
 	struct sk_buff *skb;
-	int i, total = 0;
+	int i;
 	unsigned long flags;
 	struct ieee80211_tx_info *info;
+	int total[NUM_TX_QUEUES];
 
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		total[i] = 0;
 		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
 			wl1271_debug(DEBUG_TX, "link freeing skb 0x%p", skb);
 			info = IEEE80211_SKB_CB(skb);
 			info->status.rates[0].idx = -1;
 			info->status.rates[0].count = 0;
 			ieee80211_tx_status(wl->hw, skb);
-			total++;
+			total[i]++;
 		}
 	}
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
-	wl->tx_queue_count -= total;
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		wl->tx_queue_count[i] -= total[i];
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	wl1271_handle_tx_low_watermark(wl);
@@ -850,10 +857,10 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 					ieee80211_tx_status(wl->hw, skb);
 				}
 			}
+			wl->tx_queue_count[i] = 0;
 		}
 	}
 
-	wl->tx_queue_count = 0;
 	wl->stopped_queues_map = 0;
 
 	/*
@@ -907,8 +914,10 @@ void wl1271_tx_flush(struct wl1271 *wl)
 	while (!time_after(jiffies, timeout)) {
 		mutex_lock(&wl->mutex);
 		wl1271_debug(DEBUG_TX, "flushing tx buffer: %d %d",
-			     wl->tx_frames_cnt, wl->tx_queue_count);
-		if ((wl->tx_frames_cnt == 0) && (wl->tx_queue_count == 0)) {
+			     wl->tx_frames_cnt,
+			     wl1271_tx_total_queue_count(wl));
+		if ((wl->tx_frames_cnt == 0) &&
+		    (wl1271_tx_total_queue_count(wl) == 0)) {
 			mutex_unlock(&wl->mutex);
 			return;
 		}
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index f79d3c0..117d737 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -198,6 +198,16 @@ static inline int wl1271_tx_get_mac80211_queue(int queue)
 	}
 }
 
+static inline int wl1271_tx_total_queue_count(struct wl1271 *wl)
+{
+	int i, count = 0;
+
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		count += wl->tx_queue_count[i];
+
+	return count;
+}
+
 void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_work_locked(struct wl1271 *wl);
 void wl1271_tx_complete(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 49aee9f..f60a9e1 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -436,7 +436,7 @@ struct wl1271 {
 
 	/* Frames scheduled for transmission, not handled yet */
 	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
-	int tx_queue_count;
+	int tx_queue_count[NUM_TX_QUEUES];
 	long stopped_queues_map;
 
 	/* Frames received, not handled yet by mac80211 */
-- 
1.7.4.1

