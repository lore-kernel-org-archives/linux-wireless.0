Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45297 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2EREqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 00:46:52 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn6so2490194wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 21:46:51 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/5] wlcore: add stop reason bitmap for waking/starting queues
Date: Fri, 18 May 2012 07:46:38 +0300
Message-Id: <1337316400-23875-4-git-send-email-arik@wizery.com> (sfid-20120518_064656_088915_613CA6D9)
In-Reply-To: <1337316400-23875-1-git-send-email-arik@wizery.com>
References: <1337316400-23875-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow the driver to wake/stop the queues for multiple reasons. A queue
is started when no stop-reasons exist.

Convert all wake/stop queue calls to use the new API.

Before, a stopped queue was almost synonymous a high-watermark on Tx.
Remove a bit of code in wl12xx_tx_reset() that relied on it.

Internal packets arriving from mac80211 are also discarded when a queue
is stopped. A notable exception to this is the watermark reason, which
is a "soft"-stop reason. We allow traffic to gradually come to a halt,
but we don't mind spurious packets here and there. This is merely a flow
regulation mechanism.

Based on a similar patch by Eliad Peller <eliadWizery.com>.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c   |   21 ++++--
 drivers/net/wireless/ti/wlcore/tx.c     |  109 +++++++++++++++++++++++++++----
 drivers/net/wireless/ti/wlcore/tx.h     |   21 +++++-
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 +-
 4 files changed, 132 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index efa3b55..6e6926b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -868,7 +868,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	}
 
 	/* Prevent spurious TX during FW restart */
-	ieee80211_stop_queues(wl->hw);
+	wlcore_stop_queues(wl, WLCORE_QUEUE_STOP_REASON_FW_RESTART);
 
 	if (wl->sched_scanning) {
 		ieee80211_sched_scan_stopped(wl->hw);
@@ -894,7 +894,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	 * Its safe to enable TX now - the queues are stopped after a request
 	 * to restart the HW.
 	 */
-	ieee80211_wake_queues(wl->hw);
+	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_FW_RESTART);
 	return;
 out_unlock:
         wl->watchdog_recovery = false;
@@ -1109,9 +1109,16 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
-	/* queue the packet */
+	/*
+	 * drop the packet if the link is invalid or the queue is stopped
+	 * for any reason but watermark. Watermark is a "soft"-stop so we
+	 * allow these packets through.
+	 */
 	if (hlid == WL12XX_INVALID_LINK_ID ||
-	    (wlvif && !test_bit(hlid, wlvif->links_map))) {
+	    (wlvif && !test_bit(hlid, wlvif->links_map)) ||
+	     (wlcore_is_queue_stopped(wl, q) &&
+	      !wlcore_is_queue_stopped_by_reason(wl, q,
+			WLCORE_QUEUE_STOP_REASON_WATERMARK))) {
 		wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d", hlid, q);
 		ieee80211_free_txskb(hw, skb);
 		goto out;
@@ -1129,8 +1136,8 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	if (wl->tx_queue_count[q] >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
 		wl1271_debug(DEBUG_TX, "op_tx: stopping queues for q %d", q);
-		ieee80211_stop_queue(wl->hw, mapping);
-		set_bit(q, &wl->stopped_queues_map);
+		wlcore_stop_queue_locked(wl, q,
+					 WLCORE_QUEUE_STOP_REASON_WATERMARK);
 	}
 
 	/*
@@ -1713,7 +1720,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	cancel_delayed_work_sync(&wl->connection_loss_work);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
-	wl12xx_tx_reset(wl, true);
+	wl12xx_tx_reset(wl);
 	mutex_lock(&wl->mutex);
 
 	wl1271_power_off(wl);
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 0949ab1..f68567b 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -443,18 +443,15 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
 
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl)
 {
-	unsigned long flags;
 	int i;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		if (test_bit(i, &wl->stopped_queues_map) &&
+		if (wlcore_is_queue_stopped_by_reason(wl, i,
+			WLCORE_QUEUE_STOP_REASON_WATERMARK) &&
 		    wl->tx_queue_count[i] <= WL1271_TX_QUEUE_LOW_WATERMARK) {
 			/* firmware buffer has space, restart queues */
-			spin_lock_irqsave(&wl->wl_lock, flags);
-			ieee80211_wake_queue(wl->hw,
-					     wl1271_tx_get_mac80211_queue(i));
-			clear_bit(i, &wl->stopped_queues_map);
-			spin_unlock_irqrestore(&wl->wl_lock, flags);
+			wlcore_wake_queue(wl, i,
+					  WLCORE_QUEUE_STOP_REASON_WATERMARK);
 		}
 	}
 }
@@ -963,7 +960,7 @@ void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 }
 /* caller must hold wl->mutex and TX must be stopped */
-void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
+void wl12xx_tx_reset(struct wl1271 *wl)
 {
 	int i;
 	struct sk_buff *skb;
@@ -978,15 +975,12 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 			wl->tx_queue_count[i] = 0;
 	}
 
-	wl->stopped_queues_map = 0;
-
 	/*
 	 * Make sure the driver is at a consistent state, in case this
 	 * function is called from a context other than interface removal.
 	 * This call will always wake the TX queues.
 	 */
-	if (reset_tx_queues)
-		wl1271_handle_tx_low_watermark(wl);
+	wl1271_handle_tx_low_watermark(wl);
 
 	for (i = 0; i < wl->num_tx_desc; i++) {
 		if (wl->tx_frames[i] == NULL)
@@ -1060,3 +1054,94 @@ u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
 
 	return BIT(__ffs(rate_set));
 }
+
+void wlcore_stop_queue_locked(struct wl1271 *wl, u8 queue,
+			      enum wlcore_queue_stop_reason reason)
+{
+	bool stopped = !!wl->queue_stop_reasons[queue];
+
+	/* queue should not be stopped for this reason */
+	WARN_ON(test_and_set_bit(reason, &wl->queue_stop_reasons[queue]));
+
+	if (stopped)
+		return;
+
+	ieee80211_stop_queue(wl->hw, wl1271_tx_get_mac80211_queue(queue));
+}
+
+void wlcore_stop_queue(struct wl1271 *wl, u8 queue,
+		       enum wlcore_queue_stop_reason reason)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	wlcore_stop_queue_locked(wl, queue, reason);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+}
+
+void wlcore_wake_queue(struct wl1271 *wl, u8 queue,
+		       enum wlcore_queue_stop_reason reason)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&wl->wl_lock, flags);
+
+	/* queue should not be clear for this reason */
+	WARN_ON(!test_and_clear_bit(reason, &wl->queue_stop_reasons[queue]));
+
+	if (wl->queue_stop_reasons[queue])
+		goto out;
+
+	ieee80211_wake_queue(wl->hw, wl1271_tx_get_mac80211_queue(queue));
+
+out:
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+}
+
+void wlcore_stop_queues(struct wl1271 *wl,
+			enum wlcore_queue_stop_reason reason)
+{
+	int i;
+
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		wlcore_stop_queue(wl, i, reason);
+}
+
+void wlcore_wake_queues(struct wl1271 *wl,
+			enum wlcore_queue_stop_reason reason)
+{
+	int i;
+
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		wlcore_wake_queue(wl, i, reason);
+}
+
+void wlcore_reset_stopped_queues(struct wl1271 *wl)
+{
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wl->wl_lock, flags);
+
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		if (!wl->queue_stop_reasons[i])
+			continue;
+
+		wl->queue_stop_reasons[i] = 0;
+		ieee80211_wake_queue(wl->hw,
+				     wl1271_tx_get_mac80211_queue(i));
+	}
+
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+}
+
+bool wlcore_is_queue_stopped_by_reason(struct wl1271 *wl, u8 queue,
+			     enum wlcore_queue_stop_reason reason)
+{
+	return test_bit(reason, &wl->queue_stop_reasons[queue]);
+}
+
+bool wlcore_is_queue_stopped(struct wl1271 *wl, u8 queue)
+{
+	return !!wl->queue_stop_reasons[queue];
+}
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index e24c436..6bf6956 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -184,6 +184,11 @@ struct wl1271_tx_hw_res_if {
 	struct wl1271_tx_hw_res_descr tx_results_queue[TX_HW_RESULT_QUEUE_LEN];
 } __packed;
 
+enum wlcore_queue_stop_reason {
+	WLCORE_QUEUE_STOP_REASON_WATERMARK,
+	WLCORE_QUEUE_STOP_REASON_FW_RESTART,
+};
+
 static inline int wl1271_tx_get_queue(int queue)
 {
 	switch (queue) {
@@ -230,7 +235,7 @@ void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_work_locked(struct wl1271 *wl);
 void wl1271_tx_complete(struct wl1271 *wl);
 void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues);
+void wl12xx_tx_reset(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
 u8 wlcore_rate_to_idx(struct wl1271 *wl, u8 rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
@@ -247,6 +252,20 @@ void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids);
 unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
 					  unsigned int packet_length);
 void wl1271_free_tx_id(struct wl1271 *wl, int id);
+void wlcore_stop_queue_locked(struct wl1271 *wl, u8 queue,
+			      enum wlcore_queue_stop_reason reason);
+void wlcore_stop_queue(struct wl1271 *wl, u8 queue,
+		       enum wlcore_queue_stop_reason reason);
+void wlcore_wake_queue(struct wl1271 *wl, u8 queue,
+		       enum wlcore_queue_stop_reason reason);
+void wlcore_stop_queues(struct wl1271 *wl,
+			enum wlcore_queue_stop_reason reason);
+void wlcore_wake_queues(struct wl1271 *wl,
+			enum wlcore_queue_stop_reason reason);
+void wlcore_reset_stopped_queues(struct wl1271 *wl);
+bool wlcore_is_queue_stopped_by_reason(struct wl1271 *wl, u8 queue,
+				       enum wlcore_queue_stop_reason reason);
+bool wlcore_is_queue_stopped(struct wl1271 *wl, u8 queue);
 
 /* from main.c */
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 84a1b05..94b79d5 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -209,7 +209,7 @@ struct wl1271 {
 
 	/* Frames scheduled for transmission, not handled yet */
 	int tx_queue_count[NUM_TX_QUEUES];
-	long stopped_queues_map;
+	unsigned long queue_stop_reasons[NUM_TX_QUEUES];
 
 	/* Frames received, not handled yet by mac80211 */
 	struct sk_buff_head deferred_rx_queue;
-- 
1.7.9.5

