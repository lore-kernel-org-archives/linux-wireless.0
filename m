Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:33471 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0LMHws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 02:52:48 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oBD7qh9E014826
	for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 09:52:43 +0200
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Change TX queue to be per AC
Date: Mon, 13 Dec 2010 09:52:37 +0200
Message-Id: <1292226757-21614-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

With the current single-queue implementation traffic priorization is not
working correctly - when using multiple BE streams and one, say VI stream,
the VI stream will share bandwidth almost equally with the BE streams.

To fix the issue, implement per AC queues, which are emptied in priority
order to the firmware. To keep it relatively simple, maintain a global
buffer count and global queue stop/wake instead of per-AC.

With these changes, priorization appears to work just fine.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/main.c    |   12 ++++--
 drivers/net/wireless/wl12xx/tx.c      |   60 +++++++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl12xx.h  |    3 +-
 4 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 8106a6c..e18e78b 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -225,7 +225,7 @@ static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 	char buf[20];
 	int res;
 
-	queue_len = skb_queue_len(&wl->tx_queue);
+	queue_len = wl->tx_queue_count;
 
 	res = scnprintf(buf, sizeof(buf), "%u\n", queue_len);
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dc3a093..4884748 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -576,7 +576,7 @@ static void wl1271_irq_work(struct work_struct *work)
 
 			/* Check if any tx blocks were freed */
 			if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
-					!skb_queue_empty(&wl->tx_queue)) {
+			    wl->tx_queue_count) {
 				/*
 				 * In order to avoid starvation of the TX path,
 				 * call the work function directly.
@@ -897,6 +897,7 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = txinfo->control.sta;
 	unsigned long flags;
+	int q;
 
 	/*
 	 * peek into the rates configured in the STA entry.
@@ -924,10 +925,12 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
 	}
 #endif
+	wl->tx_queue_count++;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	/* queue the packet */
-	skb_queue_tail(&wl->tx_queue, skb);
+	q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
+	skb_queue_tail(&wl->tx_queue[q], skb);
 
 	/*
 	 * The chip specific setup must run before the first TX packet -
@@ -941,7 +944,7 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * The workqueue is slow to process the tx_queue and we need stop
 	 * the queue here, otherwise the queue will get too long.
 	 */
-	if (skb_queue_len(&wl->tx_queue) >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
+	if (wl->tx_queue_count >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
 		wl1271_debug(DEBUG_TX, "op_tx: stopping queues");
 
 		spin_lock_irqsave(&wl->wl_lock, flags);
@@ -2692,7 +2695,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->hw = hw;
 	wl->plat_dev = plat_dev;
 
-	skb_queue_head_init(&wl->tx_queue);
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		skb_queue_head_init(&wl->tx_queue[i]);
 
 	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
 	INIT_DELAYED_WORK(&wl->pspoll_work, wl1271_pspoll_work);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index d332b3f..b44c75c 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -125,7 +125,6 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	/* queue (we use same identifiers for tid's and ac's */
 	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 	desc->tid = ac;
-
 	desc->aid = TX_HW_DEFAULT_AID;
 	desc->reserved = 0;
 
@@ -228,7 +227,7 @@ static void handle_tx_low_watermark(struct wl1271 *wl)
 	unsigned long flags;
 
 	if (test_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags) &&
-	    skb_queue_len(&wl->tx_queue) <= WL1271_TX_QUEUE_LOW_WATERMARK) {
+	    wl->tx_queue_count <= WL1271_TX_QUEUE_LOW_WATERMARK) {
 		/* firmware buffer has space, restart queues */
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		ieee80211_wake_queues(wl->hw);
@@ -237,6 +236,43 @@ static void handle_tx_low_watermark(struct wl1271 *wl)
 	}
 }
 
+static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
+{
+	struct sk_buff *skb = NULL;
+	unsigned long flags;
+
+	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_VO]);
+	if (skb)
+		goto out;
+	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_VI]);
+	if (skb)
+		goto out;
+	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_BE]);
+	if (skb)
+		goto out;
+	skb = skb_dequeue(&wl->tx_queue[CONF_TX_AC_BK]);
+
+out:
+	if (skb) {
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		wl->tx_queue_count--;
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+	}
+
+	return skb;
+}
+
+static void wl1271_skb_queue_head(struct wl1271 *wl, struct sk_buff *skb)
+{
+	unsigned long flags;
+	int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
+
+	skb_queue_head(&wl->tx_queue[q], skb);
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	wl->tx_queue_count++;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+}
+
 void wl1271_tx_work_locked(struct wl1271 *wl)
 {
 	struct sk_buff *skb;
@@ -270,7 +306,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 		wl1271_acx_rate_policies(wl);
 	}
 
-	while ((skb = skb_dequeue(&wl->tx_queue))) {
+	while ((skb = wl1271_skb_dequeue(wl))) {
 		if (!woken_up) {
 			ret = wl1271_ps_elp_wakeup(wl, false);
 			if (ret < 0)
@@ -284,9 +320,9 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 			 * Aggregation buffer is full.
 			 * Flush buffer and try again.
 			 */
-			skb_queue_head(&wl->tx_queue, skb);
+			wl1271_skb_queue_head(wl, skb);
 			wl1271_write(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
-				buf_offset, true);
+				     buf_offset, true);
 			sent_packets = true;
 			buf_offset = 0;
 			continue;
@@ -295,7 +331,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 			 * Firmware buffer is full.
 			 * Queue back last skb, and stop aggregating.
 			 */
-			skb_queue_head(&wl->tx_queue, skb);
+			wl1271_skb_queue_head(wl, skb);
 			/* No work left, avoid scheduling redundant tx work */
 			set_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 			goto out_ack;
@@ -440,10 +476,13 @@ void wl1271_tx_reset(struct wl1271 *wl)
 	struct sk_buff *skb;
 
 	/* TX failure */
-	while ((skb = skb_dequeue(&wl->tx_queue))) {
-		wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
-		ieee80211_tx_status(wl->hw, skb);
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		while ((skb = skb_dequeue(&wl->tx_queue[i]))) {
+			wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
+			ieee80211_tx_status(wl->hw, skb);
+		}
 	}
+	wl->tx_queue_count = 0;
 
 	/*
 	 * Make sure the driver is at a consistent state, in case this
@@ -472,8 +511,7 @@ void wl1271_tx_flush(struct wl1271 *wl)
 		mutex_lock(&wl->mutex);
 		wl1271_debug(DEBUG_TX, "flushing tx buffer: %d",
 			     wl->tx_frames_cnt);
-		if ((wl->tx_frames_cnt == 0) &&
-		    skb_queue_empty(&wl->tx_queue)) {
+		if ((wl->tx_frames_cnt == 0) && (wl->tx_queue_count == 0)) {
 			mutex_unlock(&wl->mutex);
 			return;
 		}
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index e904c72..78084c3 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -291,7 +291,8 @@ struct wl1271 {
 	int session_counter;
 
 	/* Frames scheduled for transmission, not handled yet */
-	struct sk_buff_head tx_queue;
+	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
+	int tx_queue_count;
 
 	struct work_struct tx_work;
 
-- 
1.7.1

