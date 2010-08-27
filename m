Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp202.alice.it ([82.57.200.98]:59710 "EHLO smtp202.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0H0Vsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 17:48:33 -0400
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: kvalo@adurom.com
Cc: linux-wireless@vger.kernel.org,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH] wl1251: Fix queue stopping/waking for TX path
Date: Fri, 27 Aug 2010 23:48:19 +0200
Message-Id: <1282945699-25472-1-git-send-email-GNUtoo@no-log.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch was adapted from 06f7bc7db79fabe6b2ec16eff0f59e4acc21eb72
(from linus's linux-2.6 tree of kernel.org)

here's the original message:
    The queue stopping/waking functionality was broken in a way that could
    cause huge latencies in TX transfers and even cause the TX to stall in the
    right circumstances. Correct these problems.

Signed-off-by: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
---
 drivers/net/wireless/wl12xx/wl1251.h      |    5 ++++-
 drivers/net/wireless/wl12xx/wl1251_main.c |   12 +++++-------
 drivers/net/wireless/wl12xx/wl1251_tx.c   |   20 +++++++++++++++-----
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 4f5f02a..9ab1000 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -274,6 +274,8 @@ struct wl1251 {
 	int irq;
 	bool use_eeprom;
 
+        spinlock_t wl_lock;
+
 	enum wl1251_state state;
 	struct mutex mutex;
 
@@ -398,7 +400,8 @@ void wl1251_disable_interrupts(struct wl1251 *wl);
 
 #define WL1251_DEFAULT_POWER_LEVEL 20
 
-#define WL1251_TX_QUEUE_MAX_LENGTH 20
+#define WL1251_TX_QUEUE_LOW_WATERMARK  10
+#define WL1251_TX_QUEUE_HIGH_WATERMARK 25
 
 #define WL1251_DEFAULT_BEACON_INT 100
 #define WL1251_DEFAULT_DTIM_PERIOD 1
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 3b607a0..b8c1d7b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -382,6 +382,7 @@ out:
 static int wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1251 *wl = hw->priv;
+	unsigned long flags;
 
 	skb_queue_tail(&wl->tx_queue, skb);
 
@@ -396,16 +397,13 @@ static int wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * The workqueue is slow to process the tx_queue and we need stop
 	 * the queue here, otherwise the queue will get too long.
 	 */
-	if (skb_queue_len(&wl->tx_queue) >= WL1251_TX_QUEUE_MAX_LENGTH) {
+	if (skb_queue_len(&wl->tx_queue) >= WL1251_TX_QUEUE_HIGH_WATERMARK) {
 		wl1251_debug(DEBUG_TX, "op_tx: tx_queue full, stop queues");
-		ieee80211_stop_queues(wl->hw);
 
-		/*
-		 * FIXME: this is racy, the variable is not properly
-		 * protected. Maybe fix this by removing the stupid
-		 * variable altogether and checking the real queue state?
-		 */
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		ieee80211_stop_queues(wl->hw);
 		wl->tx_queue_stopped = true;
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
 
 	return NETDEV_TX_OK;
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index c822318..bbc9ba5 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -320,11 +320,6 @@ void wl1251_tx_work(struct work_struct *work)
 
 		ret = wl1251_tx_frame(wl, skb);
 		if (ret == -EBUSY) {
-			/* firmware buffer is full, stop queues */
-			wl1251_debug(DEBUG_TX, "tx_work: fw buffer full, "
-				     "stop queues");
-			ieee80211_stop_queues(wl->hw);
-			wl->tx_queue_stopped = true;
 			skb_queue_head(&wl->tx_queue, skb);
 			goto out;
 		} else if (ret < 0) {
@@ -447,6 +442,7 @@ void wl1251_tx_complete(struct wl1251 *wl)
 {
 	int i, result_index, num_complete = 0;
 	struct tx_result result[FW_TX_CMPLT_BLOCK_SIZE], *result_ptr;
+	unsigned long flags;
 
 	if (unlikely(wl->state != WL1251_STATE_ON))
 		return;
@@ -475,6 +471,20 @@ void wl1251_tx_complete(struct wl1251 *wl)
 		}
 	}
 
+	if (wl->tx_queue_stopped
+	    &&
+	    skb_queue_len(&wl->tx_queue) <= WL1251_TX_QUEUE_LOW_WATERMARK){
+
+		/* firmware buffer has space, restart queues */
+		wl1251_debug(DEBUG_TX, "tx_complete: waking queues");
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		ieee80211_wake_queues(wl->hw);
+		wl->tx_queue_stopped = false;
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+		ieee80211_queue_work(wl->hw, &wl->tx_work);
+
+	}
+
 	/* Every completed frame needs to be acknowledged */
 	if (num_complete) {
 		/*
-- 
1.7.0.4

