Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49147 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2K2WsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 17:48:09 -0500
Received: by mail-wg0-f42.google.com with SMTP id dr1so3939201wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2012 14:48:07 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] wlcore: use separate HW queue for each AC in each vif
Date: Fri, 30 Nov 2012 00:48:03 +0200
Message-Id: <1354229283-7934-1-git-send-email-arik@wizery.com> (sfid-20121129_234813_407371_62569E0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Start using the new hw_queue mechanism in mac80211 and give each AC in
each vif its own hw_queue number. This allows us to stop an AC in a vif
independently from other vifs.

Change the Tx watermark handling functions to count packets per AC in
vif. From now on fast links should not be able to hurt the throughput
of slow links on the same AC but on different vifs.

Change internal queue mgmt functions to operate per vif, to support the
new Tx watermark granularity. Make the global versions of the queue
stop/start functions to use the global mac80211 API for queue mgmt. This
helps in situations where the driver currently doesn't know all the vifs
that reside in mac80211. Recovery is a good example for such a case.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v2: move to new vif iterator API

 drivers/net/wireless/ti/wlcore/main.c     |  101 +++++++++++++++++++++++++--
 drivers/net/wireless/ti/wlcore/tx.c       |  107 +++++++++++++++++------------
 drivers/net/wireless/ti/wlcore/tx.h       |   15 ++--
 drivers/net/wireless/ti/wlcore/wlcore.h   |    3 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    9 +++
 5 files changed, 175 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 15631fa..c9fb441 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1223,8 +1223,8 @@ static void wl1271_op_tx(struct ieee80211_hw *hw,
 	 */
 	if (hlid == WL12XX_INVALID_LINK_ID ||
 	    (!test_bit(hlid, wlvif->links_map)) ||
-	     (wlcore_is_queue_stopped(wl, q) &&
-	      !wlcore_is_queue_stopped_by_reason(wl, q,
+	     (wlcore_is_queue_stopped(wl, wlvif, q) &&
+	      !wlcore_is_queue_stopped_by_reason(wl, wlvif, q,
 			WLCORE_QUEUE_STOP_REASON_WATERMARK))) {
 		wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d", hlid, q);
 		ieee80211_free_txskb(hw, skb);
@@ -1242,11 +1242,11 @@ static void wl1271_op_tx(struct ieee80211_hw *hw,
 	 * The workqueue is slow to process the tx_queue and we need stop
 	 * the queue here, otherwise the queue will get too long.
 	 */
-	if (wl->tx_queue_count[q] >= WL1271_TX_QUEUE_HIGH_WATERMARK &&
-	    !wlcore_is_queue_stopped_by_reason(wl, q,
+	if (wlvif->tx_queue_count[q] >= WL1271_TX_QUEUE_HIGH_WATERMARK &&
+	    !wlcore_is_queue_stopped_by_reason(wl, wlvif, q,
 					WLCORE_QUEUE_STOP_REASON_WATERMARK)) {
 		wl1271_debug(DEBUG_TX, "op_tx: stopping queues for q %d", q);
-		wlcore_stop_queue_locked(wl, q,
+		wlcore_stop_queue_locked(wl, wlvif, q,
 					 WLCORE_QUEUE_STOP_REASON_WATERMARK);
 	}
 
@@ -2313,6 +2313,81 @@ static void wl12xx_force_active_psm(struct wl1271 *wl)
 	}
 }
 
+struct wlcore_hw_queue_iter_data {
+	unsigned long hw_queue_map[BITS_TO_LONGS(WLCORE_NUM_MAC_ADDRESSES)];
+	/* current vif */
+	struct ieee80211_vif *vif;
+	/* is the current vif among those iterated */
+	bool cur_running;
+};
+
+static void wlcore_hw_queue_iter(void *data, u8 *mac,
+				 struct ieee80211_vif *vif)
+{
+	struct wlcore_hw_queue_iter_data *iter_data = data;
+
+	if (WARN_ON(vif->hw_queue[0] == IEEE80211_INVAL_HW_QUEUE))
+		return;
+
+	if (iter_data->cur_running || vif == iter_data->vif) {
+		iter_data->cur_running = true;
+		return;
+	}
+
+	__set_bit(vif->hw_queue[0] / NUM_TX_QUEUES, iter_data->hw_queue_map);
+}
+
+static int wlcore_allocate_hw_queue_base(struct wl1271 *wl,
+					 struct wl12xx_vif *wlvif)
+{
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+	struct wlcore_hw_queue_iter_data iter_data = {};
+	int i, q_base;
+
+	iter_data.vif = vif;
+
+	/* mark all bits taken by active interfaces */
+	ieee80211_iterate_active_interfaces_atomic(wl->hw,
+					IEEE80211_IFACE_ITER_RESUME_ALL,
+					wlcore_hw_queue_iter, &iter_data);
+
+	/* the current vif is already running in mac80211 (resume/recovery) */
+	if (iter_data.cur_running) {
+		wlvif->hw_queue_base = vif->hw_queue[0];
+		wl1271_debug(DEBUG_MAC80211,
+			     "using pre-allocated hw queue base %d",
+			     wlvif->hw_queue_base);
+
+		/* interface type might have changed type */
+		goto adjust_cab_queue;
+	}
+
+	q_base = find_first_zero_bit(iter_data.hw_queue_map,
+				     WLCORE_NUM_MAC_ADDRESSES);
+	if (q_base >= WLCORE_NUM_MAC_ADDRESSES)
+		return -EBUSY;
+
+	wlvif->hw_queue_base = q_base * NUM_TX_QUEUES;
+	wl1271_debug(DEBUG_MAC80211, "allocating hw queue base: %d",
+		     wlvif->hw_queue_base);
+
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		wl->queue_stop_reasons[wlvif->hw_queue_base + i] = 0;
+		/* register hw queues in mac80211 */
+		vif->hw_queue[i] = wlvif->hw_queue_base + i;
+	}
+
+adjust_cab_queue:
+	/* the last places are reserved for cab queues per interface */
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
+		vif->cab_queue = NUM_TX_QUEUES * WLCORE_NUM_MAC_ADDRESSES +
+				 wlvif->hw_queue_base / NUM_TX_QUEUES;
+	else
+		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
+
+	return 0;
+}
+
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -2364,6 +2439,10 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	ret = wlcore_allocate_hw_queue_base(wl, wlvif);
+	if (ret < 0)
+		goto out;
+
 	if (wl12xx_need_fw_change(wl, vif_count, true)) {
 		wl12xx_force_active_psm(wl);
 		set_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags);
@@ -5592,7 +5671,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_AP_LINK_PS |
 		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
-		IEEE80211_HW_SCAN_WHILE_IDLE;
+		IEEE80211_HW_SCAN_WHILE_IDLE |
+		IEEE80211_HW_QUEUE_CONTROL;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
@@ -5659,7 +5739,14 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 		&wl->bands[IEEE80211_BAND_5GHZ];
 
-	wl->hw->queues = 4;
+	/*
+	 * allow 4 queues per mac address we support +
+	 * 1 cab queue per mac + one global offchannel Tx queue
+	 */
+	wl->hw->queues = (NUM_TX_QUEUES + 1) * WLCORE_NUM_MAC_ADDRESSES + 1;
+
+	/* the last queue is the offchannel queue */
+	wl->hw->offchannel_tx_hw_queue = wl->hw->queues - 1;
 	wl->hw->max_rates = 1;
 
 	wl->hw->wiphy->reg_notifier = wl1271_reg_notify;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index d799fc9..dbc1721 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -447,14 +447,17 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl)
 {
 	int i;
+	struct wl12xx_vif *wlvif;
 
-	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		if (wlcore_is_queue_stopped_by_reason(wl, i,
-			WLCORE_QUEUE_STOP_REASON_WATERMARK) &&
-		    wl->tx_queue_count[i] <= WL1271_TX_QUEUE_LOW_WATERMARK) {
-			/* firmware buffer has space, restart queues */
-			wlcore_wake_queue(wl, i,
-					  WLCORE_QUEUE_STOP_REASON_WATERMARK);
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		for (i = 0; i < NUM_TX_QUEUES; i++) {
+			if (wlcore_is_queue_stopped_by_reason(wl, wlvif, i,
+					WLCORE_QUEUE_STOP_REASON_WATERMARK) &&
+			    wlvif->tx_queue_count[i] <=
+					WL1271_TX_QUEUE_LOW_WATERMARK)
+				/* firmware buffer has space, restart queues */
+				wlcore_wake_queue(wl, wlvif, i,
+					WLCORE_QUEUE_STOP_REASON_WATERMARK);
 		}
 	}
 }
@@ -1189,44 +1192,45 @@ u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
 }
 EXPORT_SYMBOL_GPL(wl1271_tx_min_rate_get);
 
-void wlcore_stop_queue_locked(struct wl1271 *wl, u8 queue,
-			      enum wlcore_queue_stop_reason reason)
+void wlcore_stop_queue_locked(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			      u8 queue, enum wlcore_queue_stop_reason reason)
 {
-	bool stopped = !!wl->queue_stop_reasons[queue];
+	int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
+	bool stopped = !!wl->queue_stop_reasons[hwq];
 
 	/* queue should not be stopped for this reason */
-	WARN_ON(test_and_set_bit(reason, &wl->queue_stop_reasons[queue]));
+	WARN_ON(test_and_set_bit(reason, &wl->queue_stop_reasons[hwq]));
 
 	if (stopped)
 		return;
 
-	ieee80211_stop_queue(wl->hw, wl1271_tx_get_mac80211_queue(queue));
+	ieee80211_stop_queue(wl->hw, hwq);
 }
 
-void wlcore_stop_queue(struct wl1271 *wl, u8 queue,
+void wlcore_stop_queue(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 queue,
 		       enum wlcore_queue_stop_reason reason)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
-	wlcore_stop_queue_locked(wl, queue, reason);
+	wlcore_stop_queue_locked(wl, wlvif, queue, reason);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
 
-void wlcore_wake_queue(struct wl1271 *wl, u8 queue,
+void wlcore_wake_queue(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 queue,
 		       enum wlcore_queue_stop_reason reason)
 {
 	unsigned long flags;
+	int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
-
 	/* queue should not be clear for this reason */
-	WARN_ON(!test_and_clear_bit(reason, &wl->queue_stop_reasons[queue]));
+	WARN_ON(!test_and_clear_bit(reason, &wl->queue_stop_reasons[hwq]));
 
-	if (wl->queue_stop_reasons[queue])
+	if (wl->queue_stop_reasons[hwq])
 		goto out;
 
-	ieee80211_wake_queue(wl->hw, wl1271_tx_get_mac80211_queue(queue));
+	ieee80211_wake_queue(wl->hw, hwq);
 
 out:
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
@@ -1235,49 +1239,62 @@ out:
 void wlcore_stop_queues(struct wl1271 *wl,
 			enum wlcore_queue_stop_reason reason)
 {
-	int i;
+	int i, q_base;
+	unsigned long flags;
 
-	for (i = 0; i < NUM_TX_QUEUES; i++)
-		wlcore_stop_queue(wl, i, reason);
-}
-EXPORT_SYMBOL_GPL(wlcore_stop_queues);
+	spin_lock_irqsave(&wl->wl_lock, flags);
 
-void wlcore_wake_queues(struct wl1271 *wl,
-			enum wlcore_queue_stop_reason reason)
-{
-	int i;
+	for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
+		for (i = 0; i < NUM_TX_QUEUES; i++) {
+			int h = q_base * NUM_TX_QUEUES + i;
+			WARN_ON(test_and_set_bit(reason,
+						 &wl->queue_stop_reasons[h]));
+		}
 
-	for (i = 0; i < NUM_TX_QUEUES; i++)
-		wlcore_wake_queue(wl, i, reason);
+	/*
+	 * use the global version to make sure all vifs in mac80211 we don't
+	 * know are stopped.
+	 */
+	ieee80211_stop_queues(wl->hw);
+
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
-EXPORT_SYMBOL_GPL(wlcore_wake_queues);
 
-void wlcore_reset_stopped_queues(struct wl1271 *wl)
+void wlcore_wake_queues(struct wl1271 *wl,
+			enum wlcore_queue_stop_reason reason)
 {
-	int i;
+	int i, q_base;
 	unsigned long flags;
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
-	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		if (!wl->queue_stop_reasons[i])
-			continue;
+	for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
+		for (i = 0; i < NUM_TX_QUEUES; i++) {
+			int h = q_base * NUM_TX_QUEUES + i;
+			WARN_ON(!test_and_clear_bit(reason,
+						&wl->queue_stop_reasons[h]));
+		}
 
-		wl->queue_stop_reasons[i] = 0;
-		ieee80211_wake_queue(wl->hw,
-				     wl1271_tx_get_mac80211_queue(i));
-	}
+	/*
+	 * use the global version to make sure all vifs in mac80211 we don't
+	 * know are woken up.
+	 */
+	ieee80211_wake_queues(wl->hw);
 
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
 
-bool wlcore_is_queue_stopped_by_reason(struct wl1271 *wl, u8 queue,
-			     enum wlcore_queue_stop_reason reason)
+bool wlcore_is_queue_stopped_by_reason(struct wl1271 *wl,
+				       struct wl12xx_vif *wlvif, u8 queue,
+				       enum wlcore_queue_stop_reason reason)
 {
-	return test_bit(reason, &wl->queue_stop_reasons[queue]);
+	int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
+	return test_bit(reason, &wl->queue_stop_reasons[hwq]);
 }
 
-bool wlcore_is_queue_stopped(struct wl1271 *wl, u8 queue)
+bool wlcore_is_queue_stopped(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			     u8 queue)
 {
-	return !!wl->queue_stop_reasons[queue];
+	int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
+	return !!wl->queue_stop_reasons[hwq];
 }
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 349520d..3d854e5 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -252,20 +252,21 @@ void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids);
 unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
 					  unsigned int packet_length);
 void wl1271_free_tx_id(struct wl1271 *wl, int id);
-void wlcore_stop_queue_locked(struct wl1271 *wl, u8 queue,
-			      enum wlcore_queue_stop_reason reason);
-void wlcore_stop_queue(struct wl1271 *wl, u8 queue,
+void wlcore_stop_queue_locked(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			      u8 queue, enum wlcore_queue_stop_reason reason);
+void wlcore_stop_queue(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 queue,
 		       enum wlcore_queue_stop_reason reason);
-void wlcore_wake_queue(struct wl1271 *wl, u8 queue,
+void wlcore_wake_queue(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 queue,
 		       enum wlcore_queue_stop_reason reason);
 void wlcore_stop_queues(struct wl1271 *wl,
 			enum wlcore_queue_stop_reason reason);
 void wlcore_wake_queues(struct wl1271 *wl,
 			enum wlcore_queue_stop_reason reason);
-void wlcore_reset_stopped_queues(struct wl1271 *wl);
-bool wlcore_is_queue_stopped_by_reason(struct wl1271 *wl, u8 queue,
+bool wlcore_is_queue_stopped_by_reason(struct wl1271 *wl,
+				       struct wl12xx_vif *wlvif, u8 queue,
 				       enum wlcore_queue_stop_reason reason);
-bool wlcore_is_queue_stopped(struct wl1271 *wl, u8 queue);
+bool wlcore_is_queue_stopped(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			     u8 queue);
 
 /* from main.c */
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index f838eb2..921a978 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -256,7 +256,8 @@ struct wl1271 {
 
 	/* Frames scheduled for transmission, not handled yet */
 	int tx_queue_count[NUM_TX_QUEUES];
-	unsigned long queue_stop_reasons[NUM_TX_QUEUES];
+	unsigned long queue_stop_reasons[
+				NUM_TX_QUEUES * WLCORE_NUM_MAC_ADDRESSES];
 
 	/* Frames received, not handled yet by mac80211 */
 	struct sk_buff_head deferred_rx_queue;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 69e18e5..6fe7756 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -431,6 +431,15 @@ struct wl12xx_vif {
 	int inconn_count;
 
 	/*
+	 * This vif's queues are mapped to mac80211 HW queues as:
+	 * VO - hw_queue_base
+	 * VI - hw_queue_base + 1
+	 * BE - hw_queue_base + 2
+	 * BK - hw_queue_base + 3
+	 */
+	int hw_queue_base;
+
+	/*
 	 * This struct must be last!
 	 * data that has to be saved acrossed reconfigs (e.g. recovery)
 	 * should be declared in this struct.
-- 
1.7.9.5

