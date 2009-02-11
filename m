Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZBKXw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 18:52:28 -0500
Subject: [PATCH] mac80211: fix aggregation for hardware with ampdu queues
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 00:51:53 +0100
Message-Id: <1234396313.16004.65.camel@johannes.local> (sfid-20090212_005234_390656_D6E4D242)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware with AMPDU queues currently has broken aggregation.

This patch fixes it by making all A-MPDUs go over the regular AC queues,
but keeping track of the hardware queues in mac80211. As a first rough
version, it actually stops the AC queue for extended periods of time,
which can be removed by adding buffering internal to mac80211, but is
currently not a huge problem because people rarely use multiple TIDs
that are in the same AC (and iwlwifi currently doesn't operate as AP).

This is a short-term fix, my current medium-term plan, which I hope to
execute soon as well, but am not sure can finish before .30, looks like
this:
 1) rework the internal queuing layer in mac80211 that we use for
    fragments if the driver stopped queue in the middle of a fragmented
    frame to be able to queue more frames at once (rather than just a
    single frame with its fragments)
 2) instead of stopping the entire AC queue, queue up the frames in a
    per-station/per-TID queue during aggregation session initiation,
    when the session has come up take all those frames and put them
    onto the queue from 1)
 3) push the ampdu queue layer abstraction this patch introduces in
    mac80211 into the driver, and remove the virtual queue stuff from
    mac80211 again

This plan will probably also affect ath9k in that mac80211 queues the
frames instead of passing them down, even when there are no ampdu queues.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h     |    5 -
 net/mac80211/agg-tx.c      |  186 ++++++++++++++++++++++++++++++---------------
 net/mac80211/ieee80211_i.h |   20 +++-
 net/mac80211/main.c        |    9 +-
 net/mac80211/sta_info.c    |   15 +++
 net/mac80211/sta_info.h    |    4 
 net/mac80211/tx.c          |   18 +++-
 net/mac80211/util.c        |   75 +++++++++++++++---
 net/mac80211/wme.c         |  161 --------------------------------------
 net/mac80211/wme.h         |    6 -
 10 files changed, 241 insertions(+), 258 deletions(-)

--- wireless-testing.orig/net/mac80211/wme.c	2009-02-12 00:16:48.000000000 +0100
+++ wireless-testing/net/mac80211/wme.c	2009-02-12 00:17:03.000000000 +0100
@@ -114,9 +114,7 @@ u16 ieee80211_select_queue(struct net_de
 {
 	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
 	struct ieee80211_local *local = mpriv->local;
-	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct sta_info *sta;
 	u16 queue;
 	u8 tid;
 
@@ -124,29 +122,11 @@ u16 ieee80211_select_queue(struct net_de
 	if (unlikely(queue >= local->hw.queues))
 		queue = local->hw.queues - 1;
 
-	if (skb->requeue) {
-		if (!hw->ampdu_queues)
-			return queue;
-
-		rcu_read_lock();
-		sta = sta_info_get(local, hdr->addr1);
-		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
-		if (sta) {
-			int ampdu_queue = sta->tid_to_tx_q[tid];
-
-			if ((ampdu_queue < ieee80211_num_queues(hw)) &&
-			    test_bit(ampdu_queue, local->queue_pool))
-				queue = ampdu_queue;
-		}
-		rcu_read_unlock();
-
-		return queue;
-	}
-
-	/* Now we know the 1d priority, fill in the QoS header if
-	 * there is one.
+	/*
+	 * Now we know the 1d priority, fill in the QoS header if
+	 * there is one (and we haven't done this before).
 	 */
-	if (ieee80211_is_data_qos(hdr->frame_control)) {
+	if (!skb->requeue && ieee80211_is_data_qos(hdr->frame_control)) {
 		u8 *p = ieee80211_get_qos_ctl(hdr);
 		u8 ack_policy = 0;
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
@@ -156,140 +136,7 @@ u16 ieee80211_select_queue(struct net_de
 		/* qos header is 2 bytes, second reserved */
 		*p++ = ack_policy | tid;
 		*p = 0;
-
-		if (!hw->ampdu_queues)
-			return queue;
-
-		rcu_read_lock();
-
-		sta = sta_info_get(local, hdr->addr1);
-		if (sta) {
-			int ampdu_queue = sta->tid_to_tx_q[tid];
-
-			if ((ampdu_queue < ieee80211_num_queues(hw)) &&
-			    test_bit(ampdu_queue, local->queue_pool))
-				queue = ampdu_queue;
-		}
-
-		rcu_read_unlock();
 	}
 
 	return queue;
 }
-
-int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
-			       struct sta_info *sta, u16 tid)
-{
-	int i;
-
-	/* XXX: currently broken due to cb/requeue use */
-	return -EPERM;
-
-	/* prepare the filter and save it for the SW queue
-	 * matching the received HW queue */
-
-	if (!local->hw.ampdu_queues)
-		return -EPERM;
-
-	/* try to get a Qdisc from the pool */
-	for (i = local->hw.queues; i < ieee80211_num_queues(&local->hw); i++)
-		if (!test_and_set_bit(i, local->queue_pool)) {
-			ieee80211_stop_queue(local_to_hw(local), i);
-			sta->tid_to_tx_q[tid] = i;
-
-			/* IF there are already pending packets
-			 * on this tid first we need to drain them
-			 * on the previous queue
-			 * since HT is strict in order */
-#ifdef CONFIG_MAC80211_HT_DEBUG
-			if (net_ratelimit())
-				printk(KERN_DEBUG "allocated aggregation queue"
-					" %d tid %d addr %pM pool=0x%lX\n",
-					i, tid, sta->sta.addr,
-					local->queue_pool[0]);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-			return 0;
-		}
-
-	return -EAGAIN;
-}
-
-/**
- * the caller needs to hold netdev_get_tx_queue(local->mdev, X)->lock
- */
-void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
-				   struct sta_info *sta, u16 tid,
-				   u8 requeue)
-{
-	int agg_queue = sta->tid_to_tx_q[tid];
-	struct ieee80211_hw *hw = &local->hw;
-
-	/* return the qdisc to the pool */
-	clear_bit(agg_queue, local->queue_pool);
-	sta->tid_to_tx_q[tid] = ieee80211_num_queues(hw);
-
-	if (requeue) {
-		ieee80211_requeue(local, agg_queue);
-	} else {
-		struct netdev_queue *txq;
-		spinlock_t *root_lock;
-		struct Qdisc *q;
-
-		txq = netdev_get_tx_queue(local->mdev, agg_queue);
-		q = rcu_dereference(txq->qdisc);
-		root_lock = qdisc_lock(q);
-
-		spin_lock_bh(root_lock);
-		qdisc_reset(q);
-		spin_unlock_bh(root_lock);
-	}
-}
-
-void ieee80211_requeue(struct ieee80211_local *local, int queue)
-{
-	struct netdev_queue *txq = netdev_get_tx_queue(local->mdev, queue);
-	struct sk_buff_head list;
-	spinlock_t *root_lock;
-	struct Qdisc *qdisc;
-	u32 len;
-
-	rcu_read_lock_bh();
-
-	qdisc = rcu_dereference(txq->qdisc);
-	if (!qdisc || !qdisc->dequeue)
-		goto out_unlock;
-
-	skb_queue_head_init(&list);
-
-	root_lock = qdisc_root_lock(qdisc);
-	spin_lock(root_lock);
-	for (len = qdisc->q.qlen; len > 0; len--) {
-		struct sk_buff *skb = qdisc->dequeue(qdisc);
-
-		if (skb)
-			__skb_queue_tail(&list, skb);
-	}
-	spin_unlock(root_lock);
-
-	for (len = list.qlen; len > 0; len--) {
-		struct sk_buff *skb = __skb_dequeue(&list);
-		u16 new_queue;
-
-		BUG_ON(!skb);
-		new_queue = ieee80211_select_queue(local->mdev, skb);
-		skb_set_queue_mapping(skb, new_queue);
-
-		txq = netdev_get_tx_queue(local->mdev, new_queue);
-
-
-		qdisc = rcu_dereference(txq->qdisc);
-		root_lock = qdisc_root_lock(qdisc);
-
-		spin_lock(root_lock);
-		qdisc_enqueue_root(skb, qdisc);
-		spin_unlock(root_lock);
-	}
-
-out_unlock:
-	rcu_read_unlock_bh();
-}
--- wireless-testing.orig/net/mac80211/wme.h	2009-02-12 00:16:49.000000000 +0100
+++ wireless-testing/net/mac80211/wme.h	2009-02-12 00:17:03.000000000 +0100
@@ -21,11 +21,5 @@
 extern const int ieee802_1d_to_ac[8];
 
 u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb);
-int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
-			       struct sta_info *sta, u16 tid);
-void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
-				   struct sta_info *sta, u16 tid,
-				   u8 requeue);
-void ieee80211_requeue(struct ieee80211_local *local, int queue);
 
 #endif /* _WME_H */
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-02-12 00:16:49.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-02-12 00:17:03.000000000 +0100
@@ -564,12 +564,10 @@ enum {
 enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_DRIVER,
 	IEEE80211_QUEUE_STOP_REASON_PS,
-	IEEE80211_QUEUE_STOP_REASON_CSA
+	IEEE80211_QUEUE_STOP_REASON_CSA,
+	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 };
 
-/* maximum number of hardware queues we support. */
-#define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES)
-
 struct ieee80211_master_priv {
 	struct ieee80211_local *local;
 };
@@ -582,9 +580,15 @@ struct ieee80211_local {
 
 	const struct ieee80211_ops *ops;
 
-	unsigned long queue_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
-	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
+	/* AC queue corresponding to each AMPDU queue */
+	s8 ampdu_ac_queue[IEEE80211_MAX_AMPDU_QUEUES];
+	unsigned int amdpu_ac_stop_refcnt[IEEE80211_MAX_AMPDU_QUEUES];
+
+	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES +
+					 IEEE80211_MAX_AMPDU_QUEUES];
+	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
+
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors, cooked_mntrs;
@@ -1042,6 +1046,10 @@ void ieee80211_wake_queues_by_reason(str
 				     enum queue_stop_reason reason);
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason);
+void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
+				    enum queue_stop_reason reason);
+void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
+				    enum queue_stop_reason reason);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-02-12 00:16:48.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-02-12 00:25:46.000000000 +0100
@@ -132,9 +132,24 @@ static int ___ieee80211_stop_tx_ba_sessi
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
-	if (local->hw.ampdu_queues)
-		ieee80211_stop_queue(&local->hw, sta->tid_to_tx_q[tid]);
+	if (local->hw.ampdu_queues) {
+		if (initiator) {
+			/*
+			 * Stop the AC queue to avoid issues where we send
+			 * unaggregated frames already before the delba.
+			 */
+			ieee80211_stop_queue_by_reason(&local->hw,
+				local->hw.queues + sta->tid_to_tx_q[tid],
+				IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+		}
 
+		/*
+		 * Pretend the driver woke the queue, just in case
+		 * it disabled it before the session was stopped.
+		 */
+		ieee80211_wake_queue(
+			&local->hw, local->hw.queues + sta->tid_to_tx_q[tid]);
+	}
 	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
 
@@ -144,8 +159,6 @@ static int ___ieee80211_stop_tx_ba_sessi
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
 		*state = HT_AGG_STATE_OPERATIONAL;
-		if (local->hw.ampdu_queues)
-			ieee80211_wake_queue(&local->hw, sta->tid_to_tx_q[tid]);
 	}
 
 	return ret;
@@ -189,14 +202,19 @@ static void sta_addba_resp_timer_expired
 	spin_unlock_bh(&sta->lock);
 }
 
+static inline int ieee80211_ac_from_tid(int tid)
+{
+	return ieee802_1d_to_ac[tid & 7];
+}
+
 int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
-	u16 start_seq_num;
 	u8 *state;
-	int ret = 0;
+	int i, qn = -1, ret = 0;
+	u16 start_seq_num;
 
 	if (WARN_ON(!local->ops->ampdu_action))
 		return -EINVAL;
@@ -209,6 +227,13 @@ int ieee80211_start_tx_ba_session(struct
 	       ra, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
+	if (hw->ampdu_queues && ieee80211_ac_from_tid(tid) == 0) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "rejecting on voice AC\n");
+#endif
+		return -EINVAL;
+	}
+
 	rcu_read_lock();
 
 	sta = sta_info_get(local, ra);
@@ -217,7 +242,7 @@ int ieee80211_start_tx_ba_session(struct
 		printk(KERN_DEBUG "Could not find the station\n");
 #endif
 		ret = -ENOENT;
-		goto exit;
+		goto unlock;
 	}
 
 	/*
@@ -230,11 +255,13 @@ int ieee80211_start_tx_ba_session(struct
 	    sta->sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 	    sta->sdata->vif.type != NL80211_IFTYPE_AP) {
 		ret = -EINVAL;
-		goto exit;
+		goto unlock;
 	}
 
 	spin_lock_bh(&sta->lock);
 
+	sdata = sta->sdata;
+
 	/* we have tried too many times, receiver does not want A-MPDU */
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
 		ret = -EBUSY;
@@ -252,6 +279,42 @@ int ieee80211_start_tx_ba_session(struct
 		goto err_unlock_sta;
 	}
 
+	if (hw->ampdu_queues) {
+		spin_lock(&local->queue_stop_reason_lock);
+		/* reserve a new queue for this session */
+		for (i = 0; i < local->hw.ampdu_queues; i++) {
+			if (local->ampdu_ac_queue[i] < 0) {
+				qn = i;
+				local->ampdu_ac_queue[qn] =
+					ieee80211_ac_from_tid(tid);
+				break;
+			}
+		}
+		spin_unlock(&local->queue_stop_reason_lock);
+
+		if (qn < 0) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+			printk(KERN_DEBUG "BA request denied - "
+			       "queue unavailable for tid %d\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+			ret = -ENOSPC;
+			goto err_unlock_sta;
+		}
+
+		/*
+		 * If we successfully allocate the session, we can't have
+		 * anything going on on the queue this TID maps into, so
+		 * stop it for now. This is a "virtual" stop using the same
+		 * mechanism that drivers will use.
+		 *
+		 * XXX: queue up frames for this session in the sta_info
+		 *	struct instead to avoid hitting all other STAs.
+		 */
+		ieee80211_stop_queue_by_reason(
+			&local->hw, hw->queues + qn,
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	}
+
 	/* prepare A-MPDU MLME for Tx aggregation */
 	sta->ampdu_mlme.tid_tx[tid] =
 			kmalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
@@ -262,8 +325,9 @@ int ieee80211_start_tx_ba_session(struct
 					tid);
 #endif
 		ret = -ENOMEM;
-		goto err_unlock_sta;
+		goto err_return_queue;
 	}
+
 	/* Tx timer */
 	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.function =
 			sta_addba_resp_timer_expired;
@@ -271,49 +335,25 @@ int ieee80211_start_tx_ba_session(struct
 			(unsigned long)&sta->timer_to_tid[tid];
 	init_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
 
-	if (hw->ampdu_queues) {
-		/* create a new queue for this aggregation */
-		ret = ieee80211_ht_agg_queue_add(local, sta, tid);
-
-		/* case no queue is available to aggregation
-		 * don't switch to aggregation */
-		if (ret) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-			printk(KERN_DEBUG "BA request denied - "
-			       "queue unavailable for tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-			goto err_unlock_queue;
-		}
-	}
-	sdata = sta->sdata;
-
 	/* Ok, the Addba frame hasn't been sent yet, but if the driver calls the
 	 * call back right away, it must see that the flow has begun */
 	*state |= HT_ADDBA_REQUESTED_MSK;
 
-	/* This is slightly racy because the queue isn't stopped */
 	start_seq_num = sta->tid_seq[tid];
 
 	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
 				       &sta->sta, tid, &start_seq_num);
 
 	if (ret) {
-		/* No need to requeue the packets in the agg queue, since we
-		 * held the tx lock: no packet could be enqueued to the newly
-		 * allocated queue */
-		if (hw->ampdu_queues)
-			ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - HW unavailable for"
 					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 		*state = HT_AGG_STATE_IDLE;
-		goto err_unlock_queue;
+		goto err_free;
 	}
+	sta->tid_to_tx_q[tid] = qn;
 
-	/* Will put all the packets in the new SW queue */
-	if (hw->ampdu_queues)
-		ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
 	spin_unlock_bh(&sta->lock);
 
 	/* send an addBA request */
@@ -322,7 +362,6 @@ int ieee80211_start_tx_ba_session(struct
 			sta->ampdu_mlme.dialog_token_allocator;
 	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
 
-
 	ieee80211_send_addba_request(sta->sdata, ra, tid,
 			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
 			 sta->ampdu_mlme.tid_tx[tid]->ssn,
@@ -334,15 +373,24 @@ int ieee80211_start_tx_ba_session(struct
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
 #endif
-	goto exit;
+	goto unlock;
 
-err_unlock_queue:
+ err_free:
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
 	sta->ampdu_mlme.tid_tx[tid] = NULL;
-	ret = -EBUSY;
-err_unlock_sta:
+ err_return_queue:
+	if (qn >= 0) {
+		/* We failed, so start queue again right away. */
+		ieee80211_wake_queue_by_reason(hw, hw->queues + qn,
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+		/* give queue back to pool */
+		spin_lock(&local->queue_stop_reason_lock);
+		local->ampdu_ac_queue[qn] = -1;
+		spin_unlock(&local->queue_stop_reason_lock);
+	}
+ err_unlock_sta:
 	spin_unlock_bh(&sta->lock);
-exit:
+ unlock:
 	rcu_read_unlock();
 	return ret;
 }
@@ -375,7 +423,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 	spin_lock_bh(&sta->lock);
 
-	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+	if (WARN_ON(!(*state & HT_ADDBA_REQUESTED_MSK))) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "addBA was not requested yet, state is %d\n",
 				*state);
@@ -385,7 +433,8 @@ void ieee80211_start_tx_ba_cb(struct iee
 		return;
 	}
 
-	WARN_ON_ONCE(*state & HT_ADDBA_DRV_READY_MSK);
+	if (WARN_ON(*state & HT_ADDBA_DRV_READY_MSK))
+		goto out;
 
 	*state |= HT_ADDBA_DRV_READY_MSK;
 
@@ -393,9 +442,18 @@ void ieee80211_start_tx_ba_cb(struct iee
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
 #endif
-		if (hw->ampdu_queues)
-			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+		if (hw->ampdu_queues) {
+			/*
+			 * Wake up this queue, we stopped it earlier,
+			 * this will in turn wake the entire AC.
+			 */
+			ieee80211_wake_queue_by_reason(hw,
+				hw->queues + sta->tid_to_tx_q[tid],
+				IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+		}
 	}
+
+ out:
 	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
 }
@@ -485,7 +543,6 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sta_info *sta;
 	u8 *state;
-	int agg_queue;
 
 	if (tid >= STA_TID_NUM) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -527,19 +584,19 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 		ieee80211_send_delba(sta->sdata, ra, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
-	if (hw->ampdu_queues) {
-		agg_queue = sta->tid_to_tx_q[tid];
-		ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
+	spin_lock_bh(&sta->lock);
 
-		/* We just requeued the all the frames that were in the
-		 * removed queue, and since we might miss a softirq we do
-		 * netif_schedule_queue.  ieee80211_wake_queue is not used
-		 * here as this queue is not necessarily stopped
+	if (*state & HT_AGG_STATE_INITIATOR_MSK &&
+	    hw->ampdu_queues) {
+		/*
+		 * Wake up this queue, we stopped it earlier,
+		 * this will in turn wake the entire AC.
 		 */
-		netif_schedule_queue(netdev_get_tx_queue(local->mdev,
-							 agg_queue));
+		ieee80211_wake_queue_by_reason(hw,
+			hw->queues + sta->tid_to_tx_q[tid],
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
 	}
-	spin_lock_bh(&sta->lock);
+
 	*state = HT_AGG_STATE_IDLE;
 	sta->ampdu_mlme.addba_req_num[tid] = 0;
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
@@ -613,12 +670,21 @@ void ieee80211_process_addba_resp(struct
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
 			== WLAN_STATUS_SUCCESS) {
+		u8 curstate = *state;
+
 		*state |= HT_ADDBA_RECEIVED_MSK;
-		sta->ampdu_mlme.addba_req_num[tid] = 0;
 
-		if (*state == HT_AGG_STATE_OPERATIONAL &&
-		    local->hw.ampdu_queues)
-			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+		if (hw->ampdu_queues && *state != curstate &&
+		    *state == HT_AGG_STATE_OPERATIONAL) {
+			/*
+			 * Wake up this queue, we stopped it earlier,
+			 * this will in turn wake the entire AC.
+			 */
+			ieee80211_wake_queue_by_reason(hw,
+				hw->queues + sta->tid_to_tx_q[tid],
+				IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+		}
+		sta->ampdu_mlme.addba_req_num[tid] = 0;
 
 		if (local->ops->ampdu_action) {
 			(void)local->ops->ampdu_action(hw,
--- wireless-testing.orig/net/mac80211/util.c	2009-02-12 00:16:49.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-02-12 00:17:03.000000000 +0100
@@ -344,15 +344,36 @@ static void __ieee80211_wake_queue(struc
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	/* we don't need to track ampdu queues */
-	if (queue < ieee80211_num_regular_queues(hw)) {
-		__clear_bit(reason, &local->queue_stop_reasons[queue]);
+	if (queue >= hw->queues) {
+		if (local->ampdu_ac_queue[queue - hw->queues] < 0)
+			return;
+
+		/*
+		 * for virtual aggregation queues, we need to refcount the
+		 * internal mac80211 disable (multiple times!), keep track of
+		 * driver disable _and_ make sure the regular queue is
+		 * actually enabled.
+		 */
+		if (reason == IEEE80211_QUEUE_STOP_REASON_AGGREGATION)
+			local->amdpu_ac_stop_refcnt[queue - hw->queues]--;
+		else
+			__clear_bit(reason, &local->queue_stop_reasons[queue]);
 
-		if (local->queue_stop_reasons[queue] != 0)
-			/* someone still has this queue stopped */
+		if (local->queue_stop_reasons[queue] ||
+		    local->amdpu_ac_stop_refcnt[queue - hw->queues])
 			return;
+
+		/* now go on to treat the corresponding regular queue */
+		queue = local->ampdu_ac_queue[queue - hw->queues];
+		reason = IEEE80211_QUEUE_STOP_REASON_AGGREGATION;
 	}
 
+	__clear_bit(reason, &local->queue_stop_reasons[queue]);
+
+	if (local->queue_stop_reasons[queue] != 0)
+		/* someone still has this queue stopped */
+		return;
+
 	if (test_bit(queue, local->queues_pending)) {
 		set_bit(queue, local->queues_pending_run);
 		tasklet_schedule(&local->tx_pending_tasklet);
@@ -361,8 +382,8 @@ static void __ieee80211_wake_queue(struc
 	}
 }
 
-static void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
-					   enum queue_stop_reason reason)
+void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
+				    enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
@@ -384,15 +405,33 @@ static void __ieee80211_stop_queue(struc
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	/* we don't need to track ampdu queues */
-	if (queue < ieee80211_num_regular_queues(hw))
-		__set_bit(reason, &local->queue_stop_reasons[queue]);
+	if (queue >= hw->queues) {
+		if (local->ampdu_ac_queue[queue - hw->queues] < 0)
+			return;
+
+		/*
+		 * for virtual aggregation queues, we need to refcount the
+		 * internal mac80211 disable (multiple times!), keep track of
+		 * driver disable _and_ make sure the regular queue is
+		 * actually enabled.
+		 */
+		if (reason == IEEE80211_QUEUE_STOP_REASON_AGGREGATION)
+			local->amdpu_ac_stop_refcnt[queue - hw->queues]++;
+		else
+			__set_bit(reason, &local->queue_stop_reasons[queue]);
+
+		/* now go on to treat the corresponding regular queue */
+		queue = local->ampdu_ac_queue[queue - hw->queues];
+		reason = IEEE80211_QUEUE_STOP_REASON_AGGREGATION;
+	}
+
+	__set_bit(reason, &local->queue_stop_reasons[queue]);
 
 	netif_stop_subqueue(local->mdev, queue);
 }
 
-static void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
-					   enum queue_stop_reason reason)
+void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
+				    enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
@@ -418,7 +457,7 @@ void ieee80211_stop_queues_by_reason(str
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
-	for (i = 0; i < ieee80211_num_queues(hw); i++)
+	for (i = 0; i < hw->queues; i++)
 		__ieee80211_stop_queue(hw, i, reason);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
@@ -434,6 +473,16 @@ EXPORT_SYMBOL(ieee80211_stop_queues);
 int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	unsigned long flags;
+
+	if (queue >= hw->queues) {
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		queue = local->ampdu_ac_queue[queue - hw->queues];
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+		if (queue < 0)
+			return true;
+	}
+
 	return __netif_subqueue_stopped(local->mdev, queue);
 }
 EXPORT_SYMBOL(ieee80211_queue_stopped);
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-02-12 00:16:49.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-02-12 00:36:24.000000000 +0100
@@ -202,6 +202,18 @@ void sta_info_destroy(struct sta_info *s
 		/* Make sure timer won't free the tid_rx struct, see below */
 		if (tid_rx)
 			tid_rx->shutdown = true;
+
+		/*
+		 * The stop callback cannot find this station any more, but
+		 * it didn't complete its work -- start the queue if necessary
+		 */
+		if (sta->ampdu_mlme.tid_state_tx[i] & HT_AGG_STATE_INITIATOR_MSK &&
+		    sta->ampdu_mlme.tid_state_tx[i] & HT_AGG_STATE_REQ_STOP_BA_MSK &&
+		    local->hw.ampdu_queues)
+			ieee80211_wake_queue_by_reason(&local->hw,
+				local->hw.queues + sta->tid_to_tx_q[i],
+				IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+
 		spin_unlock_bh(&sta->lock);
 
 		/*
@@ -275,8 +287,7 @@ struct sta_info *sta_info_alloc(struct i
 		 * enable session_timer's data differentiation. refer to
 		 * sta_rx_agg_session_timer_expired for useage */
 		sta->timer_to_tid[i] = i;
-		/* tid to tx queue: initialize according to HW (0 is valid) */
-		sta->tid_to_tx_q[i] = ieee80211_num_queues(&local->hw);
+		sta->tid_to_tx_q[i] = -1;
 		/* rx */
 		sta->ampdu_mlme.tid_state_rx[i] = HT_AGG_STATE_IDLE;
 		sta->ampdu_mlme.tid_rx[i] = NULL;
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-02-12 00:16:48.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-02-12 00:17:03.000000000 +0100
@@ -200,7 +200,7 @@ struct sta_ampdu_mlme {
  * @tid_seq: per-TID sequence numbers for sending to this STA
  * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
- * @tid_to_tx_q: map tid to tx queue
+ * @tid_to_tx_q: map tid to tx queue (invalid == negative values)
  * @llid: Local link ID
  * @plid: Peer link ID
  * @reason: Cancel reason on PLINK_HOLDING state
@@ -275,7 +275,7 @@ struct sta_info {
 	 */
 	struct sta_ampdu_mlme ampdu_mlme;
 	u8 timer_to_tid[STA_TID_NUM];
-	u8 tid_to_tx_q[STA_TID_NUM];
+	s8 tid_to_tx_q[STA_TID_NUM];
 
 #ifdef CONFIG_MAC80211_MESH
 	/*
--- wireless-testing.orig/net/mac80211/main.c	2009-02-12 00:16:49.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-02-12 00:17:03.000000000 +0100
@@ -705,7 +705,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 					const struct ieee80211_ops *ops)
 {
 	struct ieee80211_local *local;
-	int priv_size;
+	int priv_size, i;
 	struct wiphy *wiphy;
 
 	/* Ensure 32-byte alignment of our private data and hw private data.
@@ -779,6 +779,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	setup_timer(&local->dynamic_ps_timer,
 		    ieee80211_dynamic_ps_timer, (unsigned long) local);
 
+	for (i = 0; i < IEEE80211_MAX_AMPDU_QUEUES; i++)
+		local->ampdu_ac_queue[i] = -1;
+	/* using an s8 won't work with more than that */
+	BUILD_BUG_ON(IEEE80211_MAX_AMPDU_QUEUES > 127);
+
 	sta_info_init(local);
 
 	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
@@ -872,7 +877,7 @@ int ieee80211_register_hw(struct ieee802
 
 	mdev = alloc_netdev_mq(sizeof(struct ieee80211_master_priv),
 			       "wmaster%d", ieee80211_master_setup,
-			       ieee80211_num_queues(hw));
+			       hw->queues);
 	if (!mdev)
 		goto fail_mdev_alloc;
 
--- wireless-testing.orig/net/mac80211/tx.c	2009-02-12 00:16:48.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-02-12 00:17:03.000000000 +0100
@@ -876,7 +876,6 @@ ieee80211_tx_h_stats(struct ieee80211_tx
 	return TX_CONTINUE;
 }
 
-
 /* actual transmit path */
 
 /*
@@ -1016,12 +1015,20 @@ __ieee80211_tx_prepare(struct ieee80211_
 	tx->sta = sta_info_get(local, hdr->addr1);
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control)) {
+		unsigned long flags;
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 
+		spin_lock_irqsave(&tx->sta->lock, flags);
 		state = &tx->sta->ampdu_mlme.tid_state_tx[tid];
-		if (*state == HT_AGG_STATE_OPERATIONAL)
+		if (*state == HT_AGG_STATE_OPERATIONAL) {
 			info->flags |= IEEE80211_TX_CTL_AMPDU;
+			if (local->hw.ampdu_queues)
+				skb_set_queue_mapping(
+					skb, tx->local->hw.queues +
+					     tx->sta->tid_to_tx_q[tid]);
+		}
+		spin_unlock_irqrestore(&tx->sta->lock, flags);
 	}
 
 	if (is_multicast_ether_addr(hdr->addr1)) {
@@ -1085,7 +1092,8 @@ static int __ieee80211_tx(struct ieee802
 	int ret, i;
 
 	if (skb) {
-		if (netif_subqueue_stopped(local->mdev, skb))
+		if (ieee80211_queue_stopped(&local->hw,
+					    skb_get_queue_mapping(skb)))
 			return IEEE80211_TX_PENDING;
 
 		ret = local->ops->tx(local_to_hw(local), skb);
@@ -1101,8 +1109,8 @@ static int __ieee80211_tx(struct ieee802
 			info = IEEE80211_SKB_CB(tx->extra_frag[i]);
 			info->flags &= ~(IEEE80211_TX_CTL_CLEAR_PS_FILT |
 					 IEEE80211_TX_CTL_FIRST_FRAGMENT);
-			if (netif_subqueue_stopped(local->mdev,
-						   tx->extra_frag[i]))
+			if (ieee80211_queue_stopped(&local->hw,
+					skb_get_queue_mapping(tx->extra_frag[i])))
 				return IEEE80211_TX_FRAG_AGAIN;
 
 			ret = local->ops->tx(local_to_hw(local),
--- wireless-testing.orig/include/net/mac80211.h	2009-02-12 00:16:49.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-02-12 00:17:03.000000000 +0100
@@ -1022,11 +1022,6 @@ static inline int ieee80211_num_regular_
 	return hw->queues;
 }
 
-static inline int ieee80211_num_queues(struct ieee80211_hw *hw)
-{
-	return hw->queues + hw->ampdu_queues;
-}
-
 static inline struct ieee80211_rate *
 ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
 		      const struct ieee80211_tx_info *c)


