Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbZKRTQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 14:16:48 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1NAq1N-0007mg-8b
	for linux-wireless@vger.kernel.org; Wed, 18 Nov 2009 20:16:53 +0100
Subject: [RFC] mac80211: move TX status processing to process context
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 20:16:11 +0100
Message-ID: <1258571772.30511.54.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see no real reason for status processing to be in
tasklet context, and moving it into process context
will make implementing some things that look at TX
status information easier.

There are 5 drivers that use ieee80211_tx_status():
ath5k, ath9k, b43, wl1251 and wl1271. Out of those,
only ath5k and ath9k call it from tasklet context,
so need to be changed, the others already call it
from process context.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Ok so this might /slightly/ impact ath5k/ath9k performance, but maybe
they shouldn't be using a tasklet anyway but also use work structs...

Any other objections? It'll make things that need to know the frame
status easier, like client-side SM PS or anything else that requires
knowing the frame was ACKed and not lost somewhere on the way.

 drivers/net/wireless/ath/ath5k/base.c |    2 -
 drivers/net/wireless/ath/ath9k/xmit.c |    2 -
 include/net/mac80211.h                |   24 +++++++--------
 net/mac80211/agg-tx.c                 |    4 +-
 net/mac80211/ieee80211_i.h            |   27 ++++++++++-------
 net/mac80211/main.c                   |   26 ++++++++--------
 net/mac80211/status.c                 |   54 ++++++++++++++++++++++------------
 7 files changed, 83 insertions(+), 56 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-11-18 19:49:06.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-11-18 19:52:03.000000000 +0100
@@ -495,7 +495,7 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
 	ra_tid->vif = vif;
 
 	skb->pkt_type = IEEE80211_ADDBA_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
+	skb_queue_tail(&local->tasklet_queue, skb);
 	tasklet_schedule(&local->tasklet);
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
@@ -632,7 +632,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
 	ra_tid->vif = vif;
 
 	skb->pkt_type = IEEE80211_DELBA_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
+	skb_queue_tail(&local->tasklet_queue, skb);
 	tasklet_schedule(&local->tasklet);
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb_irqsafe);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-18 19:40:08.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-18 19:51:13.000000000 +0100
@@ -505,9 +505,8 @@ ieee80211_sdata_set_mesh_id(struct ieee8
 
 enum {
 	IEEE80211_RX_MSG	= 1,
-	IEEE80211_TX_STATUS_MSG	= 2,
-	IEEE80211_DELBA_MSG	= 3,
-	IEEE80211_ADDBA_MSG	= 4,
+	IEEE80211_DELBA_MSG,
+	IEEE80211_ADDBA_MSG,
 };
 
 enum queue_stop_reason {
@@ -612,14 +611,21 @@ struct ieee80211_local {
 
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
-	/* Tasklet and skb queue to process calls from IRQ mode. All frames
-	 * added to skb_queue will be processed, but frames in
-	 * skb_queue_unreliable may be dropped if the total length of these
-	 * queues increases over the limit. */
-#define IEEE80211_IRQSAFE_QUEUE_LIMIT 128
+	/*
+	 * Tasklet and skb queue to process calls from IRQ mode.
+	 */
 	struct tasklet_struct tasklet;
-	struct sk_buff_head skb_queue;
-	struct sk_buff_head skb_queue_unreliable;
+	struct sk_buff_head tasklet_queue;
+
+	/*
+	 * TX status queue for calls that don't come from
+	 * process context. All items on the tx_status queue
+	 * will be processed but items on the unreliable one
+	 * may be dropped if there's too much work.
+	 */
+	struct work_struct tx_status_work;
+#define IEEE80211_TX_STATUS_QUEUE_LIMIT 128
+	struct sk_buff_head tx_status, tx_status_unreliable;
 
 	/* Station data */
 	/*
@@ -960,6 +966,7 @@ struct ieee80211_tx_status_rtap_hdr {
 	u8 data_retries;
 } __attribute__ ((packed));
 
+void ieee80211_tx_status_work(struct work_struct *work);
 
 /* HT */
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
--- wireless-testing.orig/net/mac80211/main.c	2009-11-18 19:40:08.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-18 19:51:51.000000000 +0100
@@ -243,8 +243,7 @@ static void ieee80211_tasklet_handler(un
 	struct sk_buff *skb;
 	struct ieee80211_ra_tid *ra_tid;
 
-	while ((skb = skb_dequeue(&local->skb_queue)) ||
-	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
+	while ((skb = skb_dequeue(&local->tasklet_queue))) {
 		switch (skb->pkt_type) {
 		case IEEE80211_RX_MSG:
 			/* Clear skb->pkt_type in order to not confuse kernel
@@ -252,10 +251,6 @@ static void ieee80211_tasklet_handler(un
 			skb->pkt_type = 0;
 			ieee80211_rx(local_to_hw(local), skb);
 			break;
-		case IEEE80211_TX_STATUS_MSG:
-			skb->pkt_type = 0;
-			ieee80211_tx_status(local_to_hw(local), skb);
-			break;
 		case IEEE80211_DELBA_MSG:
 			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
 			ieee80211_stop_tx_ba_cb(ra_tid->vif, ra_tid->ra,
@@ -389,8 +384,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 		     ieee80211_tasklet_handler,
 		     (unsigned long) local);
 
-	skb_queue_head_init(&local->skb_queue);
-	skb_queue_head_init(&local->skb_queue_unreliable);
+	skb_queue_head_init(&local->tasklet_queue);
+
+	INIT_WORK(&local->tx_status_work, ieee80211_tx_status_work);
+	skb_queue_head_init(&local->tx_status);
+	skb_queue_head_init(&local->tx_status_unreliable);
 
 	spin_lock_init(&local->ampdu_lock);
 
@@ -625,16 +623,20 @@ void ieee80211_unregister_hw(struct ieee
 
 	cancel_work_sync(&local->reconfig_filter);
 
+	cancel_work_sync(&local->tx_status_work);
+
 	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);
 	rate_control_deinitialize(local);
 
-	if (skb_queue_len(&local->skb_queue)
-			|| skb_queue_len(&local->skb_queue_unreliable))
+	if (skb_queue_len(&local->tasklet_queue) ||
+	    skb_queue_len(&local->tx_status) ||
+	    skb_queue_len(&local->tx_status_unreliable))
 		printk(KERN_WARNING "%s: skb_queue not empty\n",
 		       wiphy_name(local->hw.wiphy));
-	skb_queue_purge(&local->skb_queue);
-	skb_queue_purge(&local->skb_queue_unreliable);
+	skb_queue_purge(&local->tasklet_queue);
+	skb_queue_purge(&local->tx_status);
+	skb_queue_purge(&local->tx_status_unreliable);
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
--- wireless-testing.orig/net/mac80211/status.c	2009-11-18 19:40:08.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2009-11-18 20:05:55.000000000 +0100
@@ -16,25 +16,31 @@
 #include "led.h"
 
 
-void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
-				 struct sk_buff *skb)
+void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int tmp;
+	struct sk_buff_head *queue;
+	int num;
 
-	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
-	skb_queue_tail(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS ?
-		       &local->skb_queue : &local->skb_queue_unreliable, skb);
-	tmp = skb_queue_len(&local->skb_queue) +
-		skb_queue_len(&local->skb_queue_unreliable);
-	while (tmp > IEEE80211_IRQSAFE_QUEUE_LIMIT &&
-	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
+	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
+		queue = &local->tx_status;
+	else
+		queue = &local->tx_status_unreliable;
+
+	skb_queue_tail(queue, skb);
+
+	num = skb_queue_len(&local->tx_status) +
+		skb_queue_len(&local->tx_status_unreliable);
+
+	/* if we got over the limit with this frame, try to make room */
+	if (num > IEEE80211_TX_STATUS_QUEUE_LIMIT &&
+	    (skb = skb_dequeue(&local->tx_status_unreliable))) {
 		dev_kfree_skb_irq(skb);
-		tmp--;
 		I802_DEBUG_INC(local->tx_status_drop);
 	}
-	tasklet_schedule(&local->tasklet);
+
+	ieee80211_queue_work(&local->hw, &local->tx_status_work);
 }
 EXPORT_SYMBOL(ieee80211_tx_status_irqsafe);
 
@@ -304,8 +310,8 @@ void ieee80211_tx_status(struct ieee8021
 	skb->protocol = htons(ETH_P_802_2);
 	memset(skb->cb, 0, sizeof(skb->cb));
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
 			if (!netif_running(sdata->dev))
 				continue;
@@ -316,22 +322,34 @@ void ieee80211_tx_status(struct ieee8021
 				continue;
 
 			if (prev_dev) {
-				skb2 = skb_clone(skb, GFP_ATOMIC);
+				skb2 = skb_clone(skb, GFP_KERNEL);
 				if (skb2) {
 					skb2->dev = prev_dev;
-					netif_rx(skb2);
+					netif_rx_ni(skb2);
 				}
 			}
 
 			prev_dev = sdata->dev;
 		}
 	}
+	mutex_unlock(&local->iflist_mtx);
+
 	if (prev_dev) {
 		skb->dev = prev_dev;
-		netif_rx(skb);
+		netif_rx_ni(skb);
 		skb = NULL;
 	}
-	rcu_read_unlock();
 	dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_tx_status);
+
+void ieee80211_tx_status_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, tx_status_work);
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&local->tx_status)) ||
+	       (skb = skb_dequeue(&local->tx_status_unreliable)))
+		ieee80211_tx_status(&local->hw, skb);
+}
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2009-11-18 20:02:56.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2009-11-18 20:03:09.000000000 +0100
@@ -2002,7 +2002,7 @@ ath5k_tx_processq(struct ath5k_softc *sc
 			info->status.ack_signal = ts.ts_rssi;
 		}
 
-		ieee80211_tx_status(sc->hw, skb);
+		ieee80211_tx_status_irqsafe(sc->hw, skb);
 		sc->tx_stats[txq->qnum].count++;
 
 		spin_lock(&sc->txbuflock);
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/xmit.c	2009-11-18 20:02:56.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c	2009-11-18 20:03:19.000000000 +0100
@@ -1821,7 +1821,7 @@ static void ath_tx_complete(struct ath_s
 	if (unlikely(tx_info->pad[0] & ATH_TX_INFO_FRAME_TYPE_INTERNAL))
 		ath9k_tx_status(hw, skb);
 	else
-		ieee80211_tx_status(hw, skb);
+		ieee80211_tx_status_irqsafe(hw, skb);
 }
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
--- wireless-testing.orig/include/net/mac80211.h	2009-11-18 20:09:21.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-18 20:11:00.000000000 +0100
@@ -31,7 +31,7 @@
  */
 
 /**
- * DOC: Calling mac80211 from interrupts
+ * DOC: Calling mac80211 from (soft) interrupts
  *
  * Only ieee80211_tx_status_irqsafe() and ieee80211_rx_irqsafe() can be
  * called in hardware interrupt context. The low-level driver must not call any
@@ -40,6 +40,9 @@
  * IEEE 802.11 code call after this, e.g. from a scheduled workqueue or even
  * tasklet function.
  *
+ * ieee80211_tx_status() can also not be called from tasklet (softirq) context,
+ * call ieee80211_tx_status_irqsafe() instead.
+ *
  * NOTE: If the driver opts to use the _irqsafe() functions, it may not also
  *	 use the non-IRQ-safe functions!
  */
@@ -1734,31 +1737,28 @@ static inline void ieee80211_rx_ni(struc
  * transmitted. It is permissible to not call this function for
  * multicast frames but this can affect statistics.
  *
- * This function may not be called in IRQ context. Calls to this function
- * for a single hardware must be synchronized against each other. Calls
- * to this function and ieee80211_tx_status_irqsafe() may not be mixed
- * for a single hardware.
+ * This function may not be called in hard or soft IRQ context. Calls
+ * to this function for a single hardware must be synchronized against
+ * each other. Calls to this function and ieee80211_tx_status_irqsafe()
+ * may not be mixed for a single device.
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
  */
-void ieee80211_tx_status(struct ieee80211_hw *hw,
-			 struct sk_buff *skb);
+void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 /**
  * ieee80211_tx_status_irqsafe - IRQ-safe transmit status callback
  *
- * Like ieee80211_tx_status() but can be called in IRQ context
- * (internally defers to a tasklet.)
+ * Like ieee80211_tx_status() but can be called in (soft) IRQ context.
  *
  * Calls to this function and ieee80211_tx_status() may not be mixed for a
- * single hardware.
+ * single device.
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
  */
-void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
-				 struct sk_buff *skb);
+void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 /**
  * ieee80211_beacon_get_tim - beacon generation function


