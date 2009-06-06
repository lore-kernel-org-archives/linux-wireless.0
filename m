Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:52979 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZFFDHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 23:07:24 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170: xmit code revamp
Date: Sat, 6 Jun 2009 05:07:23 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200906060507.23583.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is a back-port from aggregation testing code.

In the past, we didn't limit the amount of active tx urbs.
However, ar9170 only has a limited buffer reserved for
pending data frames.

This wasn't much of a problem with the slower 802.11b/g.
We simply stopped the full queue and moved on to something different
in the mean time. But - as you guessed it -  this simple approach 
stands in way for a decent aggregation implementation.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
hopefully good enough for -testing... (e.g after 2.6.31-rc1)
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index c7cba66..bb97981 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -109,6 +109,11 @@ struct ar9170_rxstream_mpdu_merge {
 	bool has_plcp;
 };
 
+#define AR9170_QUEUE_TIMEOUT		64
+#define AR9170_TX_TIMEOUT		8
+#define AR9170_JANITOR_DELAY		128
+#define AR9170_TX_INVALID_RATE		0xffffffff
+
 struct ar9170 {
 	struct ieee80211_hw *hw;
 	struct mutex mutex;
@@ -117,10 +122,11 @@ struct ar9170 {
 
 	int (*open)(struct ar9170 *);
 	void (*stop)(struct ar9170 *);
-	int (*tx)(struct ar9170 *, struct sk_buff *, bool, unsigned int);
+	int (*tx)(struct ar9170 *, struct sk_buff *);
 	int (*exec_cmd)(struct ar9170 *, enum ar9170_cmd, u32 ,
 			void *, u32 , void *);
 	void (*callback_cmd)(struct ar9170 *, u32 , void *);
+	int (*flush)(struct ar9170 *);
 
 	/* interface mode settings */
 	struct ieee80211_vif *vif;
@@ -177,10 +183,10 @@ struct ar9170 {
 	struct ar9170_eeprom eeprom;
 	struct ath_regulatory regulatory;
 
-	/* global tx status for unregistered Stations. */
-	struct sk_buff_head global_tx_status;
-	struct sk_buff_head global_tx_status_waste;
-	struct delayed_work tx_status_janitor;
+	/* tx queues - as seen by hw - */
+	struct sk_buff_head tx_pending[__AR9170_NUM_TXQ];
+	struct sk_buff_head tx_status[__AR9170_NUM_TXQ];
+	struct delayed_work tx_janitor;
 
 	/* rxstream mpdu merge */
 	struct ar9170_rxstream_mpdu_merge rx_mpdu;
@@ -189,11 +195,19 @@ struct ar9170 {
 };
 
 struct ar9170_sta_info {
-	struct sk_buff_head tx_status[__AR9170_NUM_TXQ];
 };
 
-#define IS_STARTED(a)		(a->state >= AR9170_STARTED)
-#define IS_ACCEPTING_CMD(a)	(a->state >= AR9170_IDLE)
+#define AR9170_TX_FLAG_WAIT_FOR_ACK	BIT(0)
+#define AR9170_TX_FLAG_NO_ACK		BIT(1)
+#define AR9170_TX_FLAG_BLOCK_ACK	BIT(2)
+
+struct ar9170_tx_info {
+	unsigned long timeout;
+	unsigned int flags;
+};
+
+#define IS_STARTED(a)		(((struct ar9170 *)a)->state >= AR9170_STARTED)
+#define IS_ACCEPTING_CMD(a)	(((struct ar9170 *)a)->state >= AR9170_IDLE)
 
 #define AR9170_FILTER_CHANGED_MODE		BIT(0)
 #define AR9170_FILTER_CHANGED_MULTICAST		BIT(1)
@@ -204,9 +218,9 @@ void *ar9170_alloc(size_t priv_size);
 int ar9170_register(struct ar9170 *ar, struct device *pdev);
 void ar9170_rx(struct ar9170 *ar, struct sk_buff *skb);
 void ar9170_unregister(struct ar9170 *ar);
-void ar9170_handle_tx_status(struct ar9170 *ar, struct sk_buff *skb,
-			     bool update_statistics, u16 tx_status);
+void ar9170_tx_callback(struct ar9170 *ar, struct sk_buff *skb);
 void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len);
+int ar9170_nag_limiter(struct ar9170 *ar);
 
 /* MAC */
 int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
diff --git a/drivers/net/wireless/ath/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
index 3c8004f..6cbfb2f 100644
--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -420,4 +420,7 @@ enum ar9170_txq {
 	__AR9170_NUM_TXQ,
 };
 
+#define AR9170_TXQ_DEPTH	32
+#define AR9170_TX_MAX_PENDING	128
+
 #endif /* __AR9170_HW_H */
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index b104d7e..b0dc645 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -173,59 +173,122 @@ static struct ieee80211_supported_band ar9170_band_5GHz = {
 	.ht_cap		= AR9170_HT_CAP,
 };
 
-#ifdef AR9170_QUEUE_DEBUG
-/*
- * In case some wants works with AR9170's crazy tx_status queueing techniques.
- * He might need this rather useful probing function.
- *
- * NOTE: caller must hold the queue's spinlock!
- */
+static void ar9170_tx(struct ar9170 *ar);
 
+#ifdef AR9170_QUEUE_DEBUG
 static void ar9170_print_txheader(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ar9170_tx_control *txc = (void *) skb->data;
-	struct ieee80211_hdr *hdr = (void *)txc->frame_data;
+	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
+	struct ar9170_tx_info *arinfo = (void *) txinfo->rate_driver_data;
+	struct ieee80211_hdr *hdr = (void *) txc->frame_data;
 
-	printk(KERN_DEBUG "%s: => FRAME [skb:%p, queue:%d, DA:[%pM] "
-			  "mac_control:%04x, phy_control:%08x]\n",
+	printk(KERN_DEBUG "%s: => FRAME [skb:%p, q:%d, DA:[%pM] flags:%x "
+			  "mac_ctrl:%04x, phy_ctrl:%08x, timeout:[%d ms]]\n",
 	       wiphy_name(ar->hw->wiphy), skb, skb_get_queue_mapping(skb),
-	       ieee80211_get_DA(hdr), le16_to_cpu(txc->mac_control),
-	       le32_to_cpu(txc->phy_control));
+	       ieee80211_get_DA(hdr), arinfo->flags,
+	       le16_to_cpu(txc->mac_control), le32_to_cpu(txc->phy_control),
+	       jiffies_to_msecs(arinfo->timeout - jiffies));
 }
 
-static void ar9170_dump_station_tx_status_queue(struct ar9170 *ar,
-						struct sk_buff_head *queue)
+static void __ar9170_dump_txqueue(struct ar9170 *ar,
+				struct sk_buff_head *queue)
 {
 	struct sk_buff *skb;
 	int i = 0;
 
 	printk(KERN_DEBUG "---[ cut here ]---\n");
-	printk(KERN_DEBUG "%s: %d entries in tx_status queue.\n",
+	printk(KERN_DEBUG "%s: %d entries in queue.\n",
 	       wiphy_name(ar->hw->wiphy), skb_queue_len(queue));
 
 	skb_queue_walk(queue, skb) {
-		struct ar9170_tx_control *txc = (void *) skb->data;
-		struct ieee80211_hdr *hdr = (void *)txc->frame_data;
-
-		printk(KERN_DEBUG "index:%d => \n", i);
+		printk(KERN_DEBUG "index:%d => \n", i++);
 		ar9170_print_txheader(ar, skb);
 	}
+	if (i != skb_queue_len(queue))
+		printk(KERN_DEBUG "WARNING: queue frame counter "
+		       "mismatch %d != %d\n", skb_queue_len(queue), i);
 	printk(KERN_DEBUG "---[ end ]---\n");
 }
-#endif /* AR9170_QUEUE_DEBUG */
 
-void ar9170_handle_tx_status(struct ar9170 *ar, struct sk_buff *skb,
-			     bool valid_status, u16 tx_status)
+static void ar9170_dump_txqueue(struct ar9170 *ar,
+				struct sk_buff_head *queue)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->lock, flags);
+	__ar9170_dump_txqueue(ar, queue);
+	spin_unlock_irqrestore(&queue->lock, flags);
+}
+
+static void __ar9170_dump_txstats(struct ar9170 *ar)
+{
+	int i;
+
+	printk(KERN_DEBUG "%s: QoS queue stats\n",
+	       wiphy_name(ar->hw->wiphy));
+
+	for (i = 0; i < __AR9170_NUM_TXQ; i++)
+		printk(KERN_DEBUG "%s: queue:%d limit:%d len:%d waitack:%d\n",
+		       wiphy_name(ar->hw->wiphy), i, ar->tx_stats[i].limit,
+		       ar->tx_stats[i].len, skb_queue_len(&ar->tx_status[i]));
+}
+
+static void ar9170_dump_txstats(struct ar9170 *ar)
 {
-	struct ieee80211_tx_info *txinfo;
-	unsigned int retries = 0, queue = skb_get_queue_mapping(skb);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ar->tx_stats_lock, flags);
-	ar->tx_stats[queue].len--;
-	if (ieee80211_queue_stopped(ar->hw, queue))
-		ieee80211_wake_queue(ar->hw, queue);
+	__ar9170_dump_txstats(ar);
 	spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
+}
+#endif /* AR9170_QUEUE_DEBUG */
+
+/* caller must guarantee exclusive access for _bin_ queue. */
+static void ar9170_recycle_expired(struct ar9170 *ar,
+				   struct sk_buff_head *queue,
+				   struct sk_buff_head *bin)
+{
+	struct sk_buff *skb, *old = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->lock, flags);
+	while ((skb = skb_peek(queue))) {
+		struct ieee80211_tx_info *txinfo;
+		struct ar9170_tx_info *arinfo;
+
+		txinfo = IEEE80211_SKB_CB(skb);
+		arinfo = (void *) txinfo->rate_driver_data;
+
+		if (time_is_before_jiffies(arinfo->timeout)) {
+#ifdef AR9170_QUEUE_DEBUG
+			printk(KERN_DEBUG "%s: [%ld > %ld] frame expired => "
+			       "recycle \n", wiphy_name(ar->hw->wiphy),
+			       jiffies, arinfo->timeout);
+			ar9170_print_txheader(ar, skb);
+#endif /* AR9170_QUEUE_DEBUG */
+			__skb_unlink(skb, queue);
+			__skb_queue_tail(bin, skb);
+		} else {
+			break;
+		}
+
+		if (unlikely(old == skb)) {
+			/* bail out - queue is shot. */
+
+			WARN_ON(1);
+			break;
+		}
+		old = skb;
+	}
+	spin_unlock_irqrestore(&queue->lock, flags);
+}
+
+static void ar9170_tx_status(struct ar9170 *ar, struct sk_buff *skb,
+				    u16 tx_status)
+{
+	struct ieee80211_tx_info *txinfo;
+	unsigned int retries = 0;
 
 	txinfo = IEEE80211_SKB_CB(skb);
 	ieee80211_tx_info_clear_status(txinfo);
@@ -247,45 +310,61 @@ void ar9170_handle_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 		break;
 	}
 
-	if (valid_status)
-		txinfo->status.rates[0].count = retries + 1;
-
+	txinfo->status.rates[0].count = retries + 1;
 	skb_pull(skb, sizeof(struct ar9170_tx_control));
 	ieee80211_tx_status_irqsafe(ar->hw, skb);
 }
 
-static struct sk_buff *ar9170_find_skb_in_queue(struct ar9170 *ar,
-						const u8 *mac,
-						const u32 queue,
-						struct sk_buff_head *q)
+void ar9170_tx_callback(struct ar9170 *ar, struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ar9170_tx_info *arinfo = (void *) info->rate_driver_data;
+	unsigned int queue = skb_get_queue_mapping(skb);
 	unsigned long flags;
-	struct sk_buff *skb;
 
-	spin_lock_irqsave(&q->lock, flags);
-	skb_queue_walk(q, skb) {
-		struct ar9170_tx_control *txc = (void *) skb->data;
-		struct ieee80211_hdr *hdr = (void *) txc->frame_data;
-		u32 txc_queue = (le32_to_cpu(txc->phy_control) &
-				AR9170_TX_PHY_QOS_MASK) >>
-				AR9170_TX_PHY_QOS_SHIFT;
+	spin_lock_irqsave(&ar->tx_stats_lock, flags);
+	ar->tx_stats[queue].len--;
 
-		if  ((queue != txc_queue) ||
-		     (compare_ether_addr(ieee80211_get_DA(hdr), mac)))
-			continue;
+	if (skb_queue_empty(&ar->tx_pending[queue])) {
+#ifdef AR9170_QUEUE_STOP_DEBUG
+		printk(KERN_DEBUG "%s: wake queue %d\n",
+		       wiphy_name(ar->hw->wiphy), queue);
+		__ar9170_dump_txstats(ar);
+#endif /* AR9170_QUEUE_STOP_DEBUG */
+		ieee80211_wake_queue(ar->hw, queue);
+	}
+	spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
 
-		__skb_unlink(skb, q);
-		spin_unlock_irqrestore(&q->lock, flags);
-		return skb;
+	if (arinfo->flags & AR9170_TX_FLAG_BLOCK_ACK) {
+		dev_kfree_skb_any(skb);
+	} else if (arinfo->flags & AR9170_TX_FLAG_WAIT_FOR_ACK) {
+		arinfo->timeout = jiffies +
+				  msecs_to_jiffies(AR9170_TX_TIMEOUT);
+
+		skb_queue_tail(&ar->tx_status[queue], skb);
+	} else if (arinfo->flags & AR9170_TX_FLAG_NO_ACK) {
+		ar9170_tx_status(ar, skb, AR9170_TX_STATUS_FAILED);
+	} else {
+#ifdef AR9170_QUEUE_DEBUG
+		printk(KERN_DEBUG "%s: unsupported frame flags!\n",
+		       wiphy_name(ar->hw->wiphy));
+		ar9170_print_txheader(ar, skb);
+#endif /* AR9170_QUEUE_DEBUG */
+		dev_kfree_skb_any(skb);
+	}
+
+	if (!ar->tx_stats[queue].len &&
+	    !skb_queue_empty(&ar->tx_pending[queue])) {
+		ar9170_tx(ar);
 	}
-	spin_unlock_irqrestore(&q->lock, flags);
-	return NULL;
 }
 
-static struct sk_buff *ar9170_find_queued_skb(struct ar9170 *ar, const u8 *mac,
-					      const u32 queue)
+static struct sk_buff *ar9170_get_queued_skb(struct ar9170 *ar,
+					     const u8 *mac,
+					     struct sk_buff_head *queue,
+					     const u32 rate)
 {
-	struct ieee80211_sta *sta;
+	unsigned long flags;
 	struct sk_buff *skb;
 
 	/*
@@ -296,78 +375,91 @@ static struct sk_buff *ar9170_find_queued_skb(struct ar9170 *ar, const u8 *mac,
 	 * the firmware provided (-> destination MAC, and phy_control) -
 	 * and hope that we picked the right one...
 	 */
-	rcu_read_lock();
-	sta = ieee80211_find_sta(ar->hw, mac);
-
-	if (likely(sta)) {
-		struct ar9170_sta_info *sta_priv = (void *) sta->drv_priv;
-		skb = skb_dequeue(&sta_priv->tx_status[queue]);
-		rcu_read_unlock();
-		if (likely(skb))
-			return skb;
-	} else
-		rcu_read_unlock();
-
-	/* scan the waste queue for candidates */
-	skb = ar9170_find_skb_in_queue(ar, mac, queue,
-				       &ar->global_tx_status_waste);
-	if (!skb) {
-		/* so it still _must_ be in the global list. */
-		skb = ar9170_find_skb_in_queue(ar, mac, queue,
-					       &ar->global_tx_status);
-	}
 
+	spin_lock_irqsave(&queue->lock, flags);
+	skb_queue_walk(queue, skb) {
+		struct ar9170_tx_control *txc = (void *) skb->data;
+		struct ieee80211_hdr *hdr = (void *) txc->frame_data;
+		u32 r;
+
+		if (mac && compare_ether_addr(ieee80211_get_DA(hdr), mac)) {
 #ifdef AR9170_QUEUE_DEBUG
-	if (unlikely((!skb) && net_ratelimit())) {
-		printk(KERN_ERR "%s: ESS:[%pM] does not have any "
-				"outstanding frames in this queue (%d).\n",
-				wiphy_name(ar->hw->wiphy), mac, queue);
+			printk(KERN_DEBUG "%s: skip frame => DA %pM != %pM\n",
+			       wiphy_name(ar->hw->wiphy), mac,
+			       ieee80211_get_DA(hdr));
+			ar9170_print_txheader(ar, skb);
+#endif /* AR9170_QUEUE_DEBUG */
+			continue;
+		}
+
+		r = (le32_to_cpu(txc->phy_control) & AR9170_TX_PHY_MCS_MASK) >>
+		    AR9170_TX_PHY_MCS_SHIFT;
+
+		if ((rate != AR9170_TX_INVALID_RATE) && (r != rate)) {
+#ifdef AR9170_QUEUE_DEBUG
+			printk(KERN_DEBUG "%s: skip frame => rate %d != %d\n",
+			       wiphy_name(ar->hw->wiphy), rate, r);
+			ar9170_print_txheader(ar, skb);
+#endif /* AR9170_QUEUE_DEBUG */
+			continue;
+		}
+
+		__skb_unlink(skb, queue);
+		spin_unlock_irqrestore(&queue->lock, flags);
+		return skb;
 	}
+
+#ifdef AR9170_QUEUE_DEBUG
+	printk(KERN_ERR "%s: ESS:[%pM] does not have any "
+			"outstanding frames in queue.\n",
+			wiphy_name(ar->hw->wiphy), mac);
+	__ar9170_dump_txqueue(ar, queue);
 #endif /* AR9170_QUEUE_DEBUG */
-	return skb;
+	spin_unlock_irqrestore(&queue->lock, flags);
+
+	return NULL;
 }
 
 /*
- * This worker tries to keep the global tx_status queue empty.
- * So we can guarantee that incoming tx_status reports for
- * unregistered stations are always synced with the actual
- * frame - which we think - belongs to.
+ * This worker tries to keeps an maintain tx_status queues.
+ * So we can guarantee that incoming tx_status reports are
+ * actually for a pending frame.
  */
 
-static void ar9170_tx_status_janitor(struct work_struct *work)
+static void ar9170_tx_janitor(struct work_struct *work)
 {
 	struct ar9170 *ar = container_of(work, struct ar9170,
-					 tx_status_janitor.work);
-	struct sk_buff *skb;
+					 tx_janitor.work);
+	struct sk_buff_head waste;
+	unsigned int i;
+	bool resched = false;
 
 	if (unlikely(!IS_STARTED(ar)))
 		return ;
 
-	/* recycle the garbage back to mac80211... one by one. */
-	while ((skb = skb_dequeue(&ar->global_tx_status_waste))) {
+	skb_queue_head_init(&waste);
+
+	for (i = 0; i < __AR9170_NUM_TXQ; i++) {
 #ifdef AR9170_QUEUE_DEBUG
-		printk(KERN_DEBUG "%s: dispose queued frame =>\n",
-		       wiphy_name(ar->hw->wiphy));
-		ar9170_print_txheader(ar, skb);
+		printk(KERN_DEBUG "%s: garbage collector scans queue:%d\n",
+		       wiphy_name(ar->hw->wiphy), i);
+		ar9170_dump_txqueue(ar, &ar->tx_pending[i]);
+		ar9170_dump_txqueue(ar, &ar->tx_status[i]);
 #endif /* AR9170_QUEUE_DEBUG */
-		ar9170_handle_tx_status(ar, skb, false,
-					AR9170_TX_STATUS_FAILED);
-	}
 
-	while ((skb = skb_dequeue(&ar->global_tx_status))) {
-#ifdef AR9170_QUEUE_DEBUG
-		printk(KERN_DEBUG "%s: moving frame into waste queue =>\n",
-		       wiphy_name(ar->hw->wiphy));
+		ar9170_recycle_expired(ar, &ar->tx_status[i], &waste);
+		ar9170_recycle_expired(ar, &ar->tx_pending[i], &waste);
+		skb_queue_purge(&waste);
 
-		ar9170_print_txheader(ar, skb);
-#endif /* AR9170_QUEUE_DEBUG */
-		skb_queue_tail(&ar->global_tx_status_waste, skb);
+		if (!skb_queue_empty(&ar->tx_status[i]) ||
+		    !skb_queue_empty(&ar->tx_pending[i]))
+			resched = true;
 	}
 
-	/* recall the janitor in 100ms - if there's garbage in the can. */
-	if (skb_queue_len(&ar->global_tx_status_waste) > 0)
-		queue_delayed_work(ar->hw->workqueue, &ar->tx_status_janitor,
-				   msecs_to_jiffies(100));
+	if (resched)
+		queue_delayed_work(ar->hw->workqueue,
+				   &ar->tx_janitor,
+				   msecs_to_jiffies(AR9170_JANITOR_DELAY));
 }
 
 void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
@@ -394,15 +486,21 @@ void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 		 */
 
 		struct sk_buff *skb;
-		u32 queue = (le32_to_cpu(cmd->tx_status.rate) &
-			    AR9170_TX_PHY_QOS_MASK) >> AR9170_TX_PHY_QOS_SHIFT;
+		u32 phy = le32_to_cpu(cmd->tx_status.rate);
+		u32 q = (phy & AR9170_TX_PHY_QOS_MASK) >>
+			AR9170_TX_PHY_QOS_SHIFT;
+#ifdef AR9170_QUEUE_DEBUG
+		printk(KERN_DEBUG "%s: recv tx_status for %pM, p:%08x, q:%d\n",
+		       wiphy_name(ar->hw->wiphy), cmd->tx_status.dst, phy, q);
+#endif /* AR9170_QUEUE_DEBUG */
 
-		skb = ar9170_find_queued_skb(ar, cmd->tx_status.dst, queue);
+		skb = ar9170_get_queued_skb(ar, cmd->tx_status.dst,
+					    &ar->tx_status[q],
+					    AR9170_TX_INVALID_RATE);
 		if (unlikely(!skb))
 			return ;
 
-		ar9170_handle_tx_status(ar, skb, true,
-					le16_to_cpu(cmd->tx_status.status));
+		ar9170_tx_status(ar, skb, le16_to_cpu(cmd->tx_status.status));
 		break;
 		}
 
@@ -455,7 +553,7 @@ static void ar9170_rx_reset_rx_mpdu(struct ar9170 *ar)
 	ar->rx_mpdu.has_plcp = false;
 }
 
-static int ar9170_nag_limiter(struct ar9170 *ar)
+int ar9170_nag_limiter(struct ar9170 *ar)
 {
 	bool print_message;
 
@@ -956,8 +1054,8 @@ static int ar9170_op_start(struct ieee80211_hw *hw)
 
 	/* reinitialize queues statistics */
 	memset(&ar->tx_stats, 0, sizeof(ar->tx_stats));
-	for (i = 0; i < ARRAY_SIZE(ar->tx_stats); i++)
-		ar->tx_stats[i].limit = 8;
+	for (i = 0; i < __AR9170_NUM_TXQ; i++)
+		ar->tx_stats[i].limit = AR9170_TXQ_DEPTH;
 
 	/* reset QoS defaults */
 	AR9170_FILL_QUEUE(ar->edcf[0], 3, 15, 1023,  0); /* BEST EFFORT*/
@@ -1003,18 +1101,17 @@ out:
 static void ar9170_op_stop(struct ieee80211_hw *hw)
 {
 	struct ar9170 *ar = hw->priv;
+	unsigned int i;
 
 	if (IS_STARTED(ar))
 		ar->state = AR9170_IDLE;
 
 	flush_workqueue(ar->hw->workqueue);
 
-	cancel_delayed_work_sync(&ar->tx_status_janitor);
+	cancel_delayed_work_sync(&ar->tx_janitor);
 	cancel_work_sync(&ar->filter_config_work);
 	cancel_work_sync(&ar->beacon_work);
 	mutex_lock(&ar->mutex);
-	skb_queue_purge(&ar->global_tx_status_waste);
-	skb_queue_purge(&ar->global_tx_status);
 
 	if (IS_ACCEPTING_CMD(ar)) {
 		ar9170_set_leds_state(ar, 0);
@@ -1024,51 +1121,32 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 		ar->stop(ar);
 	}
 
+	for (i = 0; i < __AR9170_NUM_TXQ; i++) {
+		skb_queue_purge(&ar->tx_pending[i]);
+		skb_queue_purge(&ar->tx_status[i]);
+	}
 	mutex_unlock(&ar->mutex);
 }
 
-int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 {
-	struct ar9170 *ar = hw->priv;
 	struct ieee80211_hdr *hdr;
 	struct ar9170_tx_control *txc;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_rate *rate = NULL;
 	struct ieee80211_tx_rate *txrate;
+	struct ar9170_tx_info *arinfo;
 	unsigned int queue = skb_get_queue_mapping(skb);
-	unsigned long flags = 0;
-	struct ar9170_sta_info *sta_info = NULL;
-	u32 power, chains;
 	u16 keytype = 0;
 	u16 len, icv = 0;
-	int err;
-	bool tx_status;
 
-	if (unlikely(!IS_STARTED(ar)))
-		goto err_free;
+	BUILD_BUG_ON(sizeof(*arinfo) > sizeof(info->rate_driver_data));
 
 	hdr = (void *)skb->data;
 	info = IEEE80211_SKB_CB(skb);
 	len = skb->len;
 
-	spin_lock_irqsave(&ar->tx_stats_lock, flags);
-	if (ar->tx_stats[queue].limit < ar->tx_stats[queue].len) {
-		spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
-		return NETDEV_TX_OK;
-	}
-
-	ar->tx_stats[queue].len++;
-	ar->tx_stats[queue].count++;
-	if (ar->tx_stats[queue].limit == ar->tx_stats[queue].len)
-		ieee80211_stop_queue(hw, queue);
-
-	spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
-
 	txc = (void *)skb_push(skb, sizeof(*txc));
 
-	tx_status = (((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) != 0) ||
-		    ((info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) != 0));
-
 	if (info->control.hw_key) {
 		icv = info->control.hw_key->icv_len;
 
@@ -1084,7 +1162,7 @@ int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 			break;
 		default:
 			WARN_ON(1);
-			goto err_dequeue;
+			goto err_out;
 		}
 	}
 
@@ -1101,16 +1179,65 @@ int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_NO_ACK);
 
-	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
-
 	txrate = &info->control.rates[0];
-
 	if (txrate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
 		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
 	else if (txrate->flags & IEEE80211_TX_RC_USE_RTS_CTS)
 		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
 
+	arinfo = (void *)info->rate_driver_data;
+	arinfo->timeout = jiffies + msecs_to_jiffies(AR9170_QUEUE_TIMEOUT);
+
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	     (is_valid_ether_addr(ieee80211_get_DA(hdr)))) {
+		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+			if (unlikely(!info->control.sta))
+				goto err_out;
+
+			txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
+			arinfo->flags = AR9170_TX_FLAG_BLOCK_ACK;
+			goto out;
+		}
+
+		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_RATE_PROBE);
+		/*
+		 * WARNING:
+		 * Putting the QoS queue bits into an unexplored territory is
+		 * certainly not elegant.
+		 *
+		 * In my defense: This idea provides a reasonable way to
+		 * smuggle valuable information to the tx_status callback.
+		 * Also, the idea behind this bit-abuse came straight from
+		 * the original driver code.
+		 */
+
+		txc->phy_control |=
+			cpu_to_le32(queue << AR9170_TX_PHY_QOS_SHIFT);
+		arinfo->flags = AR9170_TX_FLAG_WAIT_FOR_ACK;
+	} else {
+		arinfo->flags = AR9170_TX_FLAG_NO_ACK;
+	}
+
+out:
+	return 0;
+
+err_out:
+	skb_pull(skb, sizeof(*txc));
+	return -EINVAL;
+}
+
+static void ar9170_tx_prepare_phy(struct ar9170 *ar, struct sk_buff *skb)
+{
+	struct ar9170_tx_control *txc;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_rate *rate = NULL;
+	struct ieee80211_tx_rate *txrate;
+	u32 power, chains;
+
+	txc = (void *) skb->data;
+	info = IEEE80211_SKB_CB(skb);
+	txrate = &info->control.rates[0];
+
 	if (txrate->flags & IEEE80211_TX_RC_GREEN_FIELD)
 		txc->phy_control |= cpu_to_le32(AR9170_TX_PHY_GREENFIELD);
 
@@ -1130,9 +1257,12 @@ int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		u32 r = txrate->idx;
 		u8 *txpower;
 
+		/* heavy clip control */
+		txc->phy_control |= cpu_to_le32((r & 0x7) << 7);
+
 		r <<= AR9170_TX_PHY_MCS_SHIFT;
-		if (WARN_ON(r & ~AR9170_TX_PHY_MCS_MASK))
-			goto err_dequeue;
+		BUG_ON(r & ~AR9170_TX_PHY_MCS_MASK);
+
 		txc->phy_control |= cpu_to_le32(r & AR9170_TX_PHY_MCS_MASK);
 		txc->phy_control |= cpu_to_le32(AR9170_TX_PHY_MOD_HT);
 
@@ -1194,53 +1324,154 @@ int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 			chains = AR9170_TX_PHY_TXCHAIN_1;
 	}
 	txc->phy_control |= cpu_to_le32(chains << AR9170_TX_PHY_TXCHAIN_SHIFT);
+}
 
-	if (tx_status) {
-		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_RATE_PROBE);
-		/*
-		 * WARNING:
-		 * Putting the QoS queue bits into an unexplored territory is
-		 * certainly not elegant.
-		 *
-		 * In my defense: This idea provides a reasonable way to
-		 * smuggle valuable information to the tx_status callback.
-		 * Also, the idea behind this bit-abuse came straight from
-		 * the original driver code.
-		 */
+static void ar9170_tx(struct ar9170 *ar)
+{
+	struct sk_buff *skb;
+	unsigned long flags;
+	struct ieee80211_tx_info *info;
+	struct ar9170_tx_info *arinfo;
+	unsigned int i, frames, frames_failed, remaining_space;
+	int err;
+	bool schedule_garbagecollector = false;
 
-		txc->phy_control |=
-			cpu_to_le32(queue << AR9170_TX_PHY_QOS_SHIFT);
+	BUILD_BUG_ON(sizeof(*arinfo) > sizeof(info->rate_driver_data));
 
-		if (info->control.sta) {
-			sta_info = (void *) info->control.sta->drv_priv;
-			skb_queue_tail(&sta_info->tx_status[queue], skb);
-		} else {
-			skb_queue_tail(&ar->global_tx_status, skb);
+	if (unlikely(!IS_STARTED(ar)))
+		return ;
+
+	remaining_space = AR9170_TX_MAX_PENDING;
+
+	for (i = 0; i < __AR9170_NUM_TXQ; i++) {
+		spin_lock_irqsave(&ar->tx_stats_lock, flags);
+		if (ar->tx_stats[i].len >= ar->tx_stats[i].limit) {
+#ifdef AR9170_QUEUE_DEBUG
+			printk(KERN_DEBUG "%s: queue %d full\n",
+			       wiphy_name(ar->hw->wiphy), i);
+
+			__ar9170_dump_txstats(ar);
+			printk(KERN_DEBUG "stuck frames: ===> \n");
+			ar9170_dump_txqueue(ar, &ar->tx_pending[i]);
+			ar9170_dump_txqueue(ar, &ar->tx_status[i]);
+#endif /* AR9170_QUEUE_DEBUG */
+			ieee80211_stop_queue(ar->hw, i);
+			spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
+			continue;
+		}
 
-			queue_delayed_work(ar->hw->workqueue,
-					   &ar->tx_status_janitor,
-					   msecs_to_jiffies(100));
+		frames = min(ar->tx_stats[i].limit - ar->tx_stats[i].len,
+			     skb_queue_len(&ar->tx_pending[i]));
+
+		if (remaining_space < frames) {
+#ifdef AR9170_QUEUE_DEBUG
+			printk(KERN_DEBUG "%s: tx quota reached queue:%d, "
+			       "remaining slots:%d, needed:%d\n",
+			       wiphy_name(ar->hw->wiphy), i, remaining_space,
+			       frames);
+
+			ar9170_dump_txstats(ar);
+#endif /* AR9170_QUEUE_DEBUG */
+			frames = remaining_space;
+		}
+
+		ar->tx_stats[i].len += frames;
+		ar->tx_stats[i].count += frames;
+		spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
+
+		if (!frames)
+			continue;
+
+		frames_failed = 0;
+		while (frames) {
+			skb = skb_dequeue(&ar->tx_pending[i]);
+			if (unlikely(!skb)) {
+				frames_failed += frames;
+				frames = 0;
+				break;
+			}
+
+			info = IEEE80211_SKB_CB(skb);
+			arinfo = (void *) info->rate_driver_data;
+
+			/* TODO: cancel stuck frames */
+			arinfo->timeout = jiffies +
+					  msecs_to_jiffies(AR9170_TX_TIMEOUT);
+
+#ifdef AR9170_QUEUE_DEBUG
+			printk(KERN_DEBUG "%s: send frame q:%d =>\n",
+			       wiphy_name(ar->hw->wiphy), i);
+			ar9170_print_txheader(ar, skb);
+#endif /* AR9170_QUEUE_DEBUG */
+
+			err = ar->tx(ar, skb);
+			if (unlikely(err)) {
+				frames_failed++;
+				dev_kfree_skb_any(skb);
+			} else {
+				remaining_space--;
+				schedule_garbagecollector = true;
+			}
+
+			frames--;
+		}
+
+#ifdef AR9170_QUEUE_DEBUG
+		printk(KERN_DEBUG "%s: ar9170_tx report for queue %d\n",
+		       wiphy_name(ar->hw->wiphy), i);
+
+		printk(KERN_DEBUG "%s: unprocessed pending frames left:\n",
+		       wiphy_name(ar->hw->wiphy));
+		ar9170_dump_txqueue(ar, &ar->tx_pending[i]);
+#endif /* AR9170_QUEUE_DEBUG */
+
+		if (unlikely(frames_failed)) {
+#ifdef AR9170_QUEUE_DEBUG
+			printk(KERN_DEBUG "%s: frames failed =>\n",
+			       wiphy_name(ar->hw->wiphy), frames_failed);
+#endif /* AR9170_QUEUE_DEBUG */
+
+			spin_lock_irqsave(&ar->tx_stats_lock, flags);
+			ar->tx_stats[i].len -= frames_failed;
+			ar->tx_stats[i].count -= frames_failed;
+			ieee80211_wake_queue(ar->hw, i);
+			spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
 		}
 	}
 
-	err = ar->tx(ar, skb, tx_status, 0);
-	if (unlikely(tx_status && err)) {
-		if (info->control.sta)
-			skb_unlink(skb, &sta_info->tx_status[queue]);
-		else
-			skb_unlink(skb, &ar->global_tx_status);
+	if (schedule_garbagecollector)
+		queue_delayed_work(ar->hw->workqueue,
+				   &ar->tx_janitor,
+				   msecs_to_jiffies(AR9170_JANITOR_DELAY));
+}
+
+int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct ar9170 *ar = hw->priv;
+	struct ieee80211_tx_info *info;
+
+	if (unlikely(!IS_STARTED(ar)))
+		goto err_free;
+
+	if (unlikely(ar9170_tx_prepare(ar, skb)))
+		goto err_free;
+
+	info = IEEE80211_SKB_CB(skb);
+	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		/* drop frame, we do not allow TX A-MPDU aggregation yet. */
+		goto err_free;
+	} else {
+		unsigned int queue = skb_get_queue_mapping(skb);
+
+		ar9170_tx_prepare_phy(ar, skb);
+		skb_queue_tail(&ar->tx_pending[queue], skb);
 	}
 
+	ar9170_tx(ar);
 	return NETDEV_TX_OK;
 
-err_dequeue:
-	spin_lock_irqsave(&ar->tx_stats_lock, flags);
-	ar->tx_stats[queue].len--;
-	ar->tx_stats[queue].count--;
-	spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
-
 err_free:
-	dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
@@ -1666,43 +1897,6 @@ static void ar9170_sta_notify(struct ieee80211_hw *hw,
 			      enum sta_notify_cmd cmd,
 			      struct ieee80211_sta *sta)
 {
-	struct ar9170 *ar = hw->priv;
-	struct ar9170_sta_info *info = (void *) sta->drv_priv;
-	struct sk_buff *skb;
-	unsigned int i;
-
-	switch (cmd) {
-	case STA_NOTIFY_ADD:
-		for (i = 0; i < ar->hw->queues; i++)
-			skb_queue_head_init(&info->tx_status[i]);
-		break;
-
-	case STA_NOTIFY_REMOVE:
-
-		/*
-		 * transfer all outstanding frames that need a tx_status
-		 * reports to the global tx_status queue
-		 */
-
-		for (i = 0; i < ar->hw->queues; i++) {
-			while ((skb = skb_dequeue(&info->tx_status[i]))) {
-#ifdef AR9170_QUEUE_DEBUG
-				printk(KERN_DEBUG "%s: queueing frame in "
-					  "global tx_status queue =>\n",
-				       wiphy_name(ar->hw->wiphy));
-
-				ar9170_print_txheader(ar, skb);
-#endif /* AR9170_QUEUE_DEBUG */
-				skb_queue_tail(&ar->global_tx_status, skb);
-			}
-		}
-		queue_delayed_work(ar->hw->workqueue, &ar->tx_status_janitor,
-				   msecs_to_jiffies(100));
-		break;
-
-	default:
-		break;
-	}
 }
 
 static int ar9170_get_stats(struct ieee80211_hw *hw,
@@ -1741,7 +1935,7 @@ static int ar9170_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	int ret;
 
 	mutex_lock(&ar->mutex);
-	if ((param) && !(queue > ar->hw->queues)) {
+	if ((param) && !(queue > __AR9170_NUM_TXQ)) {
 		memcpy(&ar->edcf[ar9170_qos_hwmap[queue]],
 		       param, sizeof(*param));
 
@@ -1817,12 +2011,14 @@ void *ar9170_alloc(size_t priv_size)
 	mutex_init(&ar->mutex);
 	spin_lock_init(&ar->cmdlock);
 	spin_lock_init(&ar->tx_stats_lock);
-	skb_queue_head_init(&ar->global_tx_status);
-	skb_queue_head_init(&ar->global_tx_status_waste);
+	for (i = 0; i < __AR9170_NUM_TXQ; i++) {
+		skb_queue_head_init(&ar->tx_status[i]);
+		skb_queue_head_init(&ar->tx_pending[i]);
+	}
 	ar9170_rx_reset_rx_mpdu(ar);
 	INIT_WORK(&ar->filter_config_work, ar9170_set_filters);
 	INIT_WORK(&ar->beacon_work, ar9170_new_beacon);
-	INIT_DELAYED_WORK(&ar->tx_status_janitor, ar9170_tx_status_janitor);
+	INIT_DELAYED_WORK(&ar->tx_janitor, ar9170_tx_janitor);
 
 	/* all hw supports 2.4 GHz, so set channel to 1 by default */
 	ar->channel = &ar9170_2ghz_chantable[0];
diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index f752698..754b1f8 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -96,7 +96,49 @@ static struct usb_device_id ar9170_usb_ids[] = {
 };
 MODULE_DEVICE_TABLE(usb, ar9170_usb_ids);
 
-static void ar9170_usb_tx_urb_complete_free(struct urb *urb)
+static void ar9170_usb_submit_urb(struct ar9170_usb *aru)
+{
+	struct urb *urb;
+	unsigned long flags;
+	int err;
+
+	if (unlikely(!IS_STARTED(&aru->common)))
+		return ;
+
+	spin_lock_irqsave(&aru->tx_urb_lock, flags);
+	if (aru->tx_submitted_urbs >= AR9170_NUM_TX_URBS) {
+		spin_unlock_irqrestore(&aru->tx_urb_lock, flags);
+		return ;
+	}
+	aru->tx_submitted_urbs++;
+
+	urb = usb_get_from_anchor(&aru->tx_pending);
+	if (!urb) {
+		aru->tx_submitted_urbs--;
+		spin_unlock_irqrestore(&aru->tx_urb_lock, flags);
+
+		return ;
+	}
+	spin_unlock_irqrestore(&aru->tx_urb_lock, flags);
+
+	aru->tx_pending_urbs--;
+	usb_anchor_urb(urb, &aru->tx_submitted);
+
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (unlikely(err)) {
+		if (ar9170_nag_limiter(&aru->common))
+			dev_err(&aru->udev->dev, "submit_urb failed (%d).\n",
+				err);
+
+		usb_unanchor_urb(urb);
+		aru->tx_submitted_urbs--;
+		ar9170_tx_callback(&aru->common, urb->context);
+	}
+
+	usb_free_urb(urb);
+}
+
+static void ar9170_usb_tx_urb_complete_frame(struct urb *urb)
 {
 	struct sk_buff *skb = urb->context;
 	struct ar9170_usb *aru = (struct ar9170_usb *)
@@ -107,8 +149,11 @@ static void ar9170_usb_tx_urb_complete_free(struct urb *urb)
 		return ;
 	}
 
-	ar9170_handle_tx_status(&aru->common, skb, false,
-				AR9170_TX_STATUS_COMPLETE);
+	aru->tx_submitted_urbs--;
+
+	ar9170_tx_callback(&aru->common, skb);
+
+	ar9170_usb_submit_urb(aru);
 }
 
 static void ar9170_usb_tx_urb_complete(struct urb *urb)
@@ -290,21 +335,47 @@ err_out:
 	return err;
 }
 
-static void ar9170_usb_cancel_urbs(struct ar9170_usb *aru)
+static int ar9170_usb_flush(struct ar9170 *ar)
 {
-	int ret;
+	struct ar9170_usb *aru = (void *) ar;
+	struct urb *urb;
+	int ret, err = 0;
 
-	aru->common.state = AR9170_UNKNOWN_STATE;
+	if (IS_STARTED(ar))
+		aru->common.state = AR9170_IDLE;
 
-	usb_unlink_anchored_urbs(&aru->tx_submitted);
+	usb_wait_anchor_empty_timeout(&aru->tx_pending,
+					    msecs_to_jiffies(800));
+	while ((urb = usb_get_from_anchor(&aru->tx_pending))) {
+		ar9170_tx_callback(&aru->common, (void *) urb->context);
+		usb_free_urb(urb);
+	}
 
-	/* give the LED OFF command and the deauth frame a chance to air. */
+	/* lets wait a while until the tx - queues are dried out */
 	ret = usb_wait_anchor_empty_timeout(&aru->tx_submitted,
 					    msecs_to_jiffies(100));
 	if (ret == 0)
-		dev_err(&aru->udev->dev, "kill pending tx urbs.\n");
-	usb_poison_anchored_urbs(&aru->tx_submitted);
+		err = -ETIMEDOUT;
+
+	usb_kill_anchored_urbs(&aru->tx_submitted);
+
+	if (IS_ACCEPTING_CMD(ar))
+		aru->common.state = AR9170_STARTED;
+
+	return err;
+}
+
+static void ar9170_usb_cancel_urbs(struct ar9170_usb *aru)
+{
+	int err;
 
+	aru->common.state = AR9170_UNKNOWN_STATE;
+
+	err = ar9170_usb_flush(&aru->common);
+	if (err)
+		dev_err(&aru->udev->dev, "stuck tx urbs!\n");
+
+	usb_poison_anchored_urbs(&aru->tx_submitted);
 	usb_poison_anchored_urbs(&aru->rx_submitted);
 }
 
@@ -388,12 +459,10 @@ err_free:
 	return err;
 }
 
-static int ar9170_usb_tx(struct ar9170 *ar, struct sk_buff *skb,
-			 bool txstatus_needed, unsigned int extra_len)
+static int ar9170_usb_tx(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ar9170_usb *aru = (struct ar9170_usb *) ar;
 	struct urb *urb;
-	int err;
 
 	if (unlikely(!IS_STARTED(ar))) {
 		/* Seriously, what were you drink... err... thinking!? */
@@ -406,18 +475,17 @@ static int ar9170_usb_tx(struct ar9170 *ar, struct sk_buff *skb,
 
 	usb_fill_bulk_urb(urb, aru->udev,
 			  usb_sndbulkpipe(aru->udev, AR9170_EP_TX),
-			  skb->data, skb->len + extra_len, (txstatus_needed ?
-			  ar9170_usb_tx_urb_complete :
-			  ar9170_usb_tx_urb_complete_free), skb);
+			  skb->data, skb->len,
+			  ar9170_usb_tx_urb_complete_frame, skb);
 	urb->transfer_flags |= URB_ZERO_PACKET;
 
-	usb_anchor_urb(urb, &aru->tx_submitted);
-	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (unlikely(err))
-		usb_unanchor_urb(urb);
+	usb_anchor_urb(urb, &aru->tx_pending);
+	aru->tx_pending_urbs++;
 
 	usb_free_urb(urb);
-	return err;
+
+	ar9170_usb_submit_urb(aru);
+	return 0;
 }
 
 static void ar9170_usb_callback_cmd(struct ar9170 *ar, u32 len , void *buffer)
@@ -617,10 +685,8 @@ static void ar9170_usb_stop(struct ar9170 *ar)
 	if (IS_ACCEPTING_CMD(ar))
 		aru->common.state = AR9170_STOPPED;
 
-	/* lets wait a while until the tx - queues are dried out */
-	ret = usb_wait_anchor_empty_timeout(&aru->tx_submitted,
-					    msecs_to_jiffies(1000));
-	if (ret == 0)
+	ret = ar9170_usb_flush(ar);
+	if (ret)
 		dev_err(&aru->udev->dev, "kill pending tx urbs.\n");
 
 	usb_poison_anchored_urbs(&aru->tx_submitted);
@@ -716,10 +782,16 @@ static int ar9170_usb_probe(struct usb_interface *intf,
 	SET_IEEE80211_DEV(ar->hw, &udev->dev);
 
 	init_usb_anchor(&aru->rx_submitted);
+	init_usb_anchor(&aru->tx_pending);
 	init_usb_anchor(&aru->tx_submitted);
 	init_completion(&aru->cmd_wait);
+	spin_lock_init(&aru->tx_urb_lock);
+
+	aru->tx_pending_urbs = 0;
+	aru->tx_submitted_urbs = 0;
 
 	aru->common.stop = ar9170_usb_stop;
+	aru->common.flush = ar9170_usb_flush;
 	aru->common.open = ar9170_usb_open;
 	aru->common.tx = ar9170_usb_tx;
 	aru->common.exec_cmd = ar9170_usb_exec_cmd;
diff --git a/drivers/net/wireless/ath/ar9170/usb.h b/drivers/net/wireless/ath/ar9170/usb.h
index 69f4bce..d098f4d 100644
--- a/drivers/net/wireless/ath/ar9170/usb.h
+++ b/drivers/net/wireless/ath/ar9170/usb.h
@@ -51,6 +51,7 @@
 #include "ar9170.h"
 
 #define AR9170_NUM_RX_URBS			16
+#define AR9170_NUM_TX_URBS			8
 
 struct firmware;
 
@@ -60,11 +61,15 @@ struct ar9170_usb {
 	struct usb_interface *intf;
 
 	struct usb_anchor rx_submitted;
+	struct usb_anchor tx_pending;
 	struct usb_anchor tx_submitted;
 
 	bool req_one_stage_fw;
 
-	spinlock_t cmdlock;
+	spinlock_t tx_urb_lock;
+	unsigned int tx_submitted_urbs;
+	unsigned int tx_pending_urbs;
+
 	struct completion cmd_wait;
 	int readlen;
 	u8 *readbuf;
