Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbZCWQca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:32:30 -0400
Message-Id: <20090323163052.298348347@sipsolutions.net> (sfid-20090323_173233_698803_69006829)
References: <20090323162834.154525349@sipsolutions.net>
Date: Mon, 23 Mar 2009 17:28:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] mac80211: rework the pending packets code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The pending packets code is quite incomprehensible, uses memory barriers
nobody really understands, etc. This patch reworks it entirely, using
the queue spinlock, proper stop bits and the skb queues themselves to
indicate whether packets are pending or not (rather than a separate
variable like before).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Tested with the later aggregation patches, I see packets going onto
the pending queue and being sent out from there.

 net/mac80211/ieee80211_i.h |    9 --
 net/mac80211/main.c        |    2 
 net/mac80211/tx.c          |  142 +++++++++++++++++++++++++--------------------
 net/mac80211/util.c        |   22 ++++--
 4 files changed, 97 insertions(+), 78 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-03-23 13:59:20.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-03-23 14:03:45.000000000 +0100
@@ -184,10 +184,6 @@ struct ieee80211_rx_data {
 	u16 tkip_iv16;
 };
 
-struct ieee80211_tx_stored_packet {
-	struct sk_buff *skb;
-};
-
 struct beacon_data {
 	u8 *head, *tail;
 	int head_len, tail_len;
@@ -581,6 +577,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_CSA,
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
+	IEEE80211_QUEUE_STOP_REASON_PENDING,
 };
 
 struct ieee80211_master_priv {
@@ -637,9 +634,7 @@ struct ieee80211_local {
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
-	unsigned long queues_pending[BITS_TO_LONGS(IEEE80211_MAX_QUEUES)];
-	unsigned long queues_pending_run[BITS_TO_LONGS(IEEE80211_MAX_QUEUES)];
-	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_QUEUES];
+	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
 	/* number of interfaces with corresponding IFF_ flags */
--- wireless-testing.orig/net/mac80211/main.c	2009-03-23 13:59:20.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-03-23 14:03:45.000000000 +0100
@@ -781,6 +781,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	sta_info_init(local);
 
+	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
+		skb_queue_head_init(&local->pending[i]);
 	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
 		     (unsigned long)local);
 	tasklet_disable(&local->tx_pending_tasklet);
--- wireless-testing.orig/net/mac80211/tx.c	2009-03-23 14:03:45.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-03-23 14:03:45.000000000 +0100
@@ -1189,12 +1189,14 @@ static int ieee80211_tx(struct net_devic
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret;
+	struct sk_buff *next;
+	unsigned long flags;
+	int ret, retries;
 	u16 queue;
 
 	queue = skb_get_queue_mapping(skb);
 
-	WARN_ON(test_bit(queue, local->queues_pending));
+	WARN_ON(!skb_queue_empty(&local->pending[queue]));
 
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
@@ -1219,40 +1221,52 @@ static int ieee80211_tx(struct net_devic
 	if (invoke_tx_handlers(&tx))
 		goto out;
 
-retry:
+	retries = 0;
+ retry:
 	ret = __ieee80211_tx(local, &tx);
-	if (ret) {
-		struct ieee80211_tx_stored_packet *store;
-
+	switch (ret) {
+	case IEEE80211_TX_OK:
+		break;
+	case IEEE80211_TX_AGAIN:
 		/*
 		 * Since there are no fragmented frames on A-MPDU
 		 * queues, there's no reason for a driver to reject
 		 * a frame there, warn and drop it.
 		 */
-		if (ret != IEEE80211_TX_PENDING)
-			if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
-				goto drop;
+		if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
+			goto drop;
+		/* fall through */
+	case IEEE80211_TX_PENDING:
+		skb = tx.skb;
+
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+
+		if (__netif_subqueue_stopped(local->mdev, queue)) {
+			do {
+				next = skb->next;
+				skb->next = NULL;
+				skb_queue_tail(&local->pending[queue], skb);
+			} while ((skb = next));
 
-		store = &local->pending_packet[queue];
+			/*
+			 * Make sure nobody will enable the queue on us
+			 * (without going through the tasklet) nor disable the
+			 * netdev queue underneath the pending handling code.
+			 */
+			__set_bit(IEEE80211_QUEUE_STOP_REASON_PENDING,
+				  &local->queue_stop_reasons[queue]);
 
-		set_bit(queue, local->queues_pending);
-		smp_mb();
-		/*
-		 * When the driver gets out of buffers during sending of
-		 * fragments and calls ieee80211_stop_queue, the netif
-		 * subqueue is stopped. There is, however, a small window
-		 * in which the PENDING bit is not yet set. If a buffer
-		 * gets available in that window (i.e. driver calls
-		 * ieee80211_wake_queue), we would end up with ieee80211_tx
-		 * called with the PENDING bit still set. Prevent this by
-		 * continuing transmitting here when that situation is
-		 * possible to have happened.
-		 */
-		if (!__netif_subqueue_stopped(local->mdev, queue)) {
-			clear_bit(queue, local->queues_pending);
+			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
+					       flags);
+		} else {
+			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
+					       flags);
+
+			retries++;
+			if (WARN(retries > 10, "tx refused but queue active"))
+				goto drop;
 			goto retry;
 		}
-		store->skb = tx.skb;
 	}
  out:
 	rcu_read_unlock();
@@ -1263,8 +1277,6 @@ retry:
 
 	skb = tx.skb;
 	while (skb) {
-		struct sk_buff *next;
-
 		next = skb->next;
 		dev_kfree_skb(skb);
 		skb = next;
@@ -1803,23 +1815,10 @@ int ieee80211_subif_start_xmit(struct sk
  */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local)
 {
-	struct sk_buff *skb;
 	int i;
 
-	for (i = 0; i < local->hw.queues; i++) {
-		if (!test_bit(i, local->queues_pending))
-			continue;
-
-		skb = local->pending_packet[i].skb;
-		while (skb) {
-			struct sk_buff *next;
-
-			next = skb->next;
-			dev_kfree_skb(skb);
-			skb = next;
-		}
-		clear_bit(i, local->queues_pending);
-	}
+	for (i = 0; i < local->hw.queues; i++)
+		skb_queue_purge(&local->pending[i]);
 }
 
 /*
@@ -1830,40 +1829,57 @@ void ieee80211_tx_pending(unsigned long 
 {
 	struct ieee80211_local *local = (struct ieee80211_local *)data;
 	struct net_device *dev = local->mdev;
-	struct ieee80211_tx_stored_packet *store;
 	struct ieee80211_hdr *hdr;
+	unsigned long flags;
 	struct ieee80211_tx_data tx;
 	int i, ret;
+	bool next;
 
 	rcu_read_lock();
 	netif_tx_lock_bh(dev);
+
 	for (i = 0; i < local->hw.queues; i++) {
-		/* Check that this queue is ok */
-		if (__netif_subqueue_stopped(local->mdev, i) &&
-		    !test_bit(i, local->queues_pending_run))
-			continue;
+		/*
+		 * If queue is stopped by something other than due to pending
+		 * frames, or we have no pending frames, proceed to next queue.
+		 */
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		next = false;
+		if (local->queue_stop_reasons[i] !=
+			BIT(IEEE80211_QUEUE_STOP_REASON_PENDING) ||
+		    skb_queue_empty(&local->pending[i]))
+			next = true;
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
-		if (!test_bit(i, local->queues_pending)) {
-			clear_bit(i, local->queues_pending_run);
-			ieee80211_wake_queue(&local->hw, i);
+		if (next)
 			continue;
-		}
 
-		clear_bit(i, local->queues_pending_run);
+		/*
+		 * start the queue now to allow processing our packets,
+		 * we're under the tx lock here anyway so nothing will
+		 * happen as a result of this
+		 */
 		netif_start_subqueue(local->mdev, i);
 
-		store = &local->pending_packet[i];
-		tx.flags = 0;
-		tx.skb = store->skb;
-		hdr = (struct ieee80211_hdr *)tx.skb->data;
-		tx.sta = sta_info_get(local, hdr->addr1);
-		ret = __ieee80211_tx(local, &tx);
-		store->skb = tx.skb;
-		if (!ret) {
-			clear_bit(i, local->queues_pending);
-			ieee80211_wake_queue(&local->hw, i);
+		while (!skb_queue_empty(&local->pending[i])) {
+			tx.flags = 0;
+			tx.skb = skb_dequeue(&local->pending[i]);
+			hdr = (struct ieee80211_hdr *)tx.skb->data;
+			tx.sta = sta_info_get(local, hdr->addr1);
+
+			ret = __ieee80211_tx(local, &tx);
+			if (ret != IEEE80211_TX_OK) {
+				skb_queue_head(&local->pending[i], tx.skb);
+				break;
+			}
 		}
+
+		/* Start regular packet processing again. */
+		if (skb_queue_empty(&local->pending[i]))
+			ieee80211_wake_queue_by_reason(&local->hw, i,
+					IEEE80211_QUEUE_STOP_REASON_PENDING);
 	}
+
 	netif_tx_unlock_bh(dev);
 	rcu_read_unlock();
 }
--- wireless-testing.orig/net/mac80211/util.c	2009-03-23 13:59:20.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-03-23 14:03:45.000000000 +0100
@@ -365,16 +365,16 @@ static void __ieee80211_wake_queue(struc
 
 	__clear_bit(reason, &local->queue_stop_reasons[queue]);
 
+	if (!skb_queue_empty(&local->pending[queue]) &&
+	    local->queue_stop_reasons[queue] ==
+	    			BIT(IEEE80211_QUEUE_STOP_REASON_PENDING))
+		tasklet_schedule(&local->tx_pending_tasklet);
+
 	if (local->queue_stop_reasons[queue] != 0)
 		/* someone still has this queue stopped */
 		return;
 
-	if (test_bit(queue, local->queues_pending)) {
-		set_bit(queue, local->queues_pending_run);
-		tasklet_schedule(&local->tx_pending_tasklet);
-	} else {
-		netif_wake_subqueue(local->mdev, queue);
-	}
+	netif_wake_subqueue(local->mdev, queue);
 }
 
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
@@ -420,9 +420,15 @@ static void __ieee80211_stop_queue(struc
 		reason = IEEE80211_QUEUE_STOP_REASON_AGGREGATION;
 	}
 
-	__set_bit(reason, &local->queue_stop_reasons[queue]);
+	/*
+	 * Only stop if it was previously running, this is necessary
+	 * for correct pending packets handling because there we may
+	 * start (but not wake) the queue and rely on that.
+	 */
+	if (!local->queue_stop_reasons[queue])
+		netif_stop_subqueue(local->mdev, queue);
 
-	netif_stop_subqueue(local->mdev, queue);
+	__set_bit(reason, &local->queue_stop_reasons[queue]);
 }
 
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,

-- 

