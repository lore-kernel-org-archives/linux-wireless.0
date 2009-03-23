Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbZCWQcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:32:42 -0400
Message-Id: <20090323163053.344441542@sipsolutions.net> (sfid-20090323_173245_353802_18A04537)
References: <20090323162834.154525349@sipsolutions.net>
Date: Mon, 23 Mar 2009 17:28:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] mac80211: fix aggregation to not require queue stop
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of stopping the entire AC queue when enabling aggregation
(which was only done for hardware with aggregation queues) buffer
the packets for each station, and release them to the pending skb
queue once aggregation is turned on successfully.

We get a little more code, but it becomes conceptually simpler and
we can remove the entire virtual queue mechanism from mac80211 in
a follow-up patch.

This changes how mac80211 behaves towards drivers that support
aggregation but have no hardware queues -- those drivers will now
not be handed packets while the aggregation session is being
established, but only after it has been fully established.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h     |    4 +
 net/mac80211/agg-tx.c      |  136 ++++++++++++++++++++++++++-----------------
 net/mac80211/ieee80211_i.h |    8 ++
 net/mac80211/main.c        |    2 
 net/mac80211/sta_info.c    |    5 +
 net/mac80211/sta_info.h    |    2 
 net/mac80211/tx.c          |  142 ++++++++++++++++++++++++++++++++++++---------
 7 files changed, 221 insertions(+), 78 deletions(-)

--- wireless-testing.orig/net/mac80211/sta_info.h	2009-03-23 13:59:18.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-03-23 14:04:30.000000000 +0100
@@ -73,11 +73,13 @@ enum ieee80211_sta_info_flags {
  * struct tid_ampdu_tx - TID aggregation information (Tx).
  *
  * @addba_resp_timer: timer for peer's response to addba request
+ * @pending: pending frames queue -- use sta's spinlock to protect
  * @ssn: Starting Sequence Number expected to be aggregated.
  * @dialog_token: dialog token for aggregation session
  */
 struct tid_ampdu_tx {
 	struct timer_list addba_resp_timer;
+	struct sk_buff_head pending;
 	u16 ssn;
 	u8 dialog_token;
 };
--- wireless-testing.orig/include/net/mac80211.h	2009-03-23 14:03:46.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-03-23 14:04:30.000000000 +0100
@@ -248,6 +248,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_RCALGO: mac80211 internal flag, do not test or
  *	set this flag in the driver; indicates that the rate control
  *	algorithm was used and should be notified of TX status
+ * @IEEE80211_TX_INTFL_NEED_TXPROCESSING: completely internal to mac80211,
+ *	used to indicate that a pending frame requires TX processing before
+ *	it can be sent out.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -264,6 +267,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(11),
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
 	IEEE80211_TX_INTFL_RCALGO		= BIT(13),
+	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-03-23 14:03:46.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-03-23 14:04:30.000000000 +0100
@@ -132,16 +132,6 @@ static int ___ieee80211_stop_tx_ba_sessi
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
 	if (local->hw.ampdu_queues) {
-		if (initiator) {
-			/*
-			 * Stop the AC queue to avoid issues where we send
-			 * unaggregated frames already before the delba.
-			 */
-			ieee80211_stop_queue_by_reason(&local->hw,
-				local->hw.queues + sta->tid_to_tx_q[tid],
-				IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
-		}
-
 		/*
 		 * Pretend the driver woke the queue, just in case
 		 * it disabled it before the session was stopped.
@@ -158,6 +148,10 @@ static int ___ieee80211_stop_tx_ba_sessi
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
 		*state = HT_AGG_STATE_OPERATIONAL;
+		/*
+		 * We may have pending packets get stuck in this case...
+		 * Not bothering with a workaround for now.
+		 */
 	}
 
 	return ret;
@@ -226,13 +220,6 @@ int ieee80211_start_tx_ba_session(struct
 	       ra, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	if (hw->ampdu_queues && ieee80211_ac_from_tid(tid) == 0) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "rejecting on voice AC\n");
-#endif
-		return -EINVAL;
-	}
-
 	rcu_read_lock();
 
 	sta = sta_info_get(local, ra);
@@ -267,6 +254,7 @@ int ieee80211_start_tx_ba_session(struct
 	}
 
 	spin_lock_bh(&sta->lock);
+	spin_lock(&local->ampdu_lock);
 
 	sdata = sta->sdata;
 
@@ -308,21 +296,19 @@ int ieee80211_start_tx_ba_session(struct
 			ret = -ENOSPC;
 			goto err_unlock_sta;
 		}
-
-		/*
-		 * If we successfully allocate the session, we can't have
-		 * anything going on on the queue this TID maps into, so
-		 * stop it for now. This is a "virtual" stop using the same
-		 * mechanism that drivers will use.
-		 *
-		 * XXX: queue up frames for this session in the sta_info
-		 *	struct instead to avoid hitting all other STAs.
-		 */
-		ieee80211_stop_queue_by_reason(
-			&local->hw, hw->queues + qn,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
 	}
 
+	/*
+	 * While we're asking the driver about the aggregation,
+	 * stop the AC queue so that we don't have to worry
+	 * about frames that came in while we were doing that,
+	 * which would require us to put them to the AC pending
+	 * afterwards which just makes the code more complex.
+	 */
+	ieee80211_stop_queue_by_reason(
+		&local->hw, ieee80211_ac_from_tid(tid),
+		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+
 	/* prepare A-MPDU MLME for Tx aggregation */
 	sta->ampdu_mlme.tid_tx[tid] =
 			kmalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
@@ -336,6 +322,8 @@ int ieee80211_start_tx_ba_session(struct
 		goto err_return_queue;
 	}
 
+	skb_queue_head_init(&sta->ampdu_mlme.tid_tx[tid]->pending);
+
 	/* Tx timer */
 	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.function =
 			sta_addba_resp_timer_expired;
@@ -362,6 +350,12 @@ int ieee80211_start_tx_ba_session(struct
 	}
 	sta->tid_to_tx_q[tid] = qn;
 
+	/* Driver vetoed or OKed, but we can take packets again now */
+	ieee80211_wake_queue_by_reason(
+		&local->hw, ieee80211_ac_from_tid(tid),
+		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+
+	spin_unlock(&local->ampdu_lock);
 	spin_unlock_bh(&sta->lock);
 
 	/* send an addBA request */
@@ -388,15 +382,16 @@ int ieee80211_start_tx_ba_session(struct
 	sta->ampdu_mlme.tid_tx[tid] = NULL;
  err_return_queue:
 	if (qn >= 0) {
-		/* We failed, so start queue again right away. */
-		ieee80211_wake_queue_by_reason(hw, hw->queues + qn,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
 		/* give queue back to pool */
 		spin_lock(&local->queue_stop_reason_lock);
 		local->ampdu_ac_queue[qn] = -1;
 		spin_unlock(&local->queue_stop_reason_lock);
 	}
+	ieee80211_wake_queue_by_reason(
+		&local->hw, ieee80211_ac_from_tid(tid),
+		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
  err_unlock_sta:
+	spin_unlock(&local->ampdu_lock);
 	spin_unlock_bh(&sta->lock);
  unlock:
 	rcu_read_unlock();
@@ -404,6 +399,45 @@ int ieee80211_start_tx_ba_session(struct
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
 
+/*
+ * splice packets from the STA's pending to the local pending,
+ * requires a call to ieee80211_agg_splice_finish and holding
+ * local->ampdu_lock across both calls.
+ */
+static void ieee80211_agg_splice_packets(struct ieee80211_local *local,
+					 struct sta_info *sta, u16 tid)
+{
+	unsigned long flags;
+	u16 queue = ieee80211_ac_from_tid(tid);
+
+	ieee80211_stop_queue_by_reason(
+		&local->hw, queue,
+		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+
+	if (!skb_queue_empty(&sta->ampdu_mlme.tid_tx[tid]->pending)) {
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		/* mark queue as pending, it is stopped already */
+		__set_bit(IEEE80211_QUEUE_STOP_REASON_PENDING,
+			  &local->queue_stop_reasons[queue]);
+		/* copy over remaining packets */
+		skb_queue_splice_tail_init(
+			&sta->ampdu_mlme.tid_tx[tid]->pending,
+			&local->pending[queue]);
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	}
+}
+
+static void ieee80211_agg_splice_finish(struct ieee80211_local *local,
+					struct sta_info *sta, u16 tid)
+{
+	u16 queue = ieee80211_ac_from_tid(tid);
+
+	ieee80211_wake_queue_by_reason(
+		&local->hw, queue,
+		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+}
+
+/* caller must hold sta->lock */
 static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 					 struct sta_info *sta, u16 tid)
 {
@@ -411,15 +445,16 @@ static void ieee80211_agg_tx_operational
 	printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
 #endif
 
-	if (local->hw.ampdu_queues) {
-		/*
-		 * Wake up the A-MPDU queue, we stopped it earlier,
-		 * this will in turn wake the entire AC.
-		 */
-		ieee80211_wake_queue_by_reason(&local->hw,
-			local->hw.queues + sta->tid_to_tx_q[tid],
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
-	}
+	spin_lock(&local->ampdu_lock);
+	ieee80211_agg_splice_packets(local, sta, tid);
+	/*
+	 * NB: we rely on sta->lock being taken in the TX
+	 * processing here when adding to the pending queue,
+	 * otherwise we could only change the state of the
+	 * session to OPERATIONAL _here_.
+	 */
+	ieee80211_agg_splice_finish(local, sta, tid);
+	spin_unlock(&local->ampdu_lock);
 
 	local->ops->ampdu_action(&local->hw, IEEE80211_AMPDU_TX_OPERATIONAL,
 				 &sta->sta, tid, NULL);
@@ -602,22 +637,19 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
 	spin_lock_bh(&sta->lock);
+	spin_lock(&local->ampdu_lock);
 
-	if (*state & HT_AGG_STATE_INITIATOR_MSK &&
-	    hw->ampdu_queues) {
-		/*
-		 * Wake up this queue, we stopped it earlier,
-		 * this will in turn wake the entire AC.
-		 */
-		ieee80211_wake_queue_by_reason(hw,
-			hw->queues + sta->tid_to_tx_q[tid],
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
-	}
+	ieee80211_agg_splice_packets(local, sta, tid);
 
 	*state = HT_AGG_STATE_IDLE;
+	/* from now on packets are no longer put onto sta->pending */
 	sta->ampdu_mlme.addba_req_num[tid] = 0;
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
 	sta->ampdu_mlme.tid_tx[tid] = NULL;
+
+	ieee80211_agg_splice_finish(local, sta, tid);
+
+	spin_unlock(&local->ampdu_lock);
 	spin_unlock_bh(&sta->lock);
 
 	rcu_read_unlock();
--- wireless-testing.orig/net/mac80211/tx.c	2009-03-23 14:03:47.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-03-23 14:04:30.000000000 +0100
@@ -984,9 +984,9 @@ __ieee80211_tx_prepare(struct ieee80211_
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
 	int hdrlen, tid;
 	u8 *qc, *state;
+	bool queued = false;
 
 	memset(tx, 0, sizeof(*tx));
 	tx->skb = skb;
@@ -1013,20 +1013,53 @@ __ieee80211_tx_prepare(struct ieee80211_
 		 */
 	}
 
+	/*
+	 * If this flag is set to true anywhere, and we get here,
+	 * we are doing the needed processing, so remove the flag
+	 * now.
+	 */
+	info->flags &= ~IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+
 	hdr = (struct ieee80211_hdr *) skb->data;
 
 	tx->sta = sta_info_get(local, hdr->addr1);
 
-	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control)) {
+	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
+	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
 		unsigned long flags;
+		struct tid_ampdu_tx *tid_tx;
+
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 
 		spin_lock_irqsave(&tx->sta->lock, flags);
+		/*
+		 * XXX: This spinlock could be fairly expensive, but see the
+		 *	comment in agg-tx.c:ieee80211_agg_tx_operational().
+		 *	One way to solve this would be to do something RCU-like
+		 *	for managing the tid_tx struct and using atomic bitops
+		 *	for the actual state -- by introducing an actual
+		 *	'operational' bit that would be possible. It would
+		 *	require changing ieee80211_agg_tx_operational() to
+		 *	set that bit, and changing the way tid_tx is managed
+		 *	everywhere, including races between that bit and
+		 *	tid_tx going away (tid_tx being added can be easily
+		 *	committed to memory before the 'operational' bit).
+		 */
+		tid_tx = tx->sta->ampdu_mlme.tid_tx[tid];
 		state = &tx->sta->ampdu_mlme.tid_state_tx[tid];
-		if (*state == HT_AGG_STATE_OPERATIONAL)
+		if (*state == HT_AGG_STATE_OPERATIONAL) {
 			info->flags |= IEEE80211_TX_CTL_AMPDU;
+		} else if (*state != HT_AGG_STATE_IDLE) {
+			/* in progress */
+			queued = true;
+			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+			__skb_queue_tail(&tid_tx->pending, skb);
+		}
 		spin_unlock_irqrestore(&tx->sta->lock, flags);
+
+		if (unlikely(queued))
+			return TX_QUEUED;
 	}
 
 	if (is_multicast_ether_addr(hdr->addr1)) {
@@ -1077,7 +1110,14 @@ static int ieee80211_tx_prepare(struct i
 	}
 	if (unlikely(!dev))
 		return -ENODEV;
-	/* initialises tx with control */
+	/*
+	 * initialises tx with control
+	 *
+	 * return value is safe to ignore here because this function
+	 * can only be invoked for multicast frames
+	 *
+	 * XXX: clean up
+	 */
 	__ieee80211_tx_prepare(tx, skb, dev);
 	dev_put(dev);
 	return 0;
@@ -1188,7 +1228,8 @@ static int invoke_tx_handlers(struct iee
 	return 0;
 }
 
-static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb)
+static void ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
+			 bool txpending)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
@@ -1202,11 +1243,11 @@ static int ieee80211_tx(struct net_devic
 
 	queue = skb_get_queue_mapping(skb);
 
-	WARN_ON(!skb_queue_empty(&local->pending[queue]));
+	WARN_ON(!txpending && !skb_queue_empty(&local->pending[queue]));
 
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
-		return 0;
+		return;
 	}
 
 	rcu_read_lock();
@@ -1214,10 +1255,13 @@ static int ieee80211_tx(struct net_devic
 	/* initialises tx */
 	res_prepare = __ieee80211_tx_prepare(&tx, skb, dev);
 
-	if (res_prepare == TX_DROP) {
+	if (unlikely(res_prepare == TX_DROP)) {
 		dev_kfree_skb(skb);
 		rcu_read_unlock();
-		return 0;
+		return;
+	} else if (unlikely(res_prepare == TX_QUEUED)) {
+		rcu_read_unlock();
+		return;
 	}
 
 	sta = tx.sta;
@@ -1251,7 +1295,12 @@ static int ieee80211_tx(struct net_devic
 			do {
 				next = skb->next;
 				skb->next = NULL;
-				skb_queue_tail(&local->pending[queue], skb);
+				if (unlikely(txpending))
+					skb_queue_head(&local->pending[queue],
+						       skb);
+				else
+					skb_queue_tail(&local->pending[queue],
+						       skb);
 			} while ((skb = next));
 
 			/*
@@ -1276,7 +1325,7 @@ static int ieee80211_tx(struct net_devic
 	}
  out:
 	rcu_read_unlock();
-	return 0;
+	return;
 
  drop:
 	rcu_read_unlock();
@@ -1287,7 +1336,6 @@ static int ieee80211_tx(struct net_devic
 		dev_kfree_skb(skb);
 		skb = next;
 	}
-	return 0;
 }
 
 /* device xmit handlers */
@@ -1346,7 +1394,6 @@ int ieee80211_master_start_xmit(struct s
 		FOUND_SDATA,
 		UNKNOWN_ADDRESS,
 	} monitor_iface = NOT_MONITOR;
-	int ret;
 
 	if (skb->iif)
 		odev = dev_get_by_index(&init_net, skb->iif);
@@ -1360,7 +1407,7 @@ int ieee80211_master_start_xmit(struct s
 		       "originating device\n", dev->name);
 #endif
 		dev_kfree_skb(skb);
-		return 0;
+		return NETDEV_TX_OK;
 	}
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
@@ -1389,7 +1436,7 @@ int ieee80211_master_start_xmit(struct s
 		else
 			if (mesh_nexthop_lookup(skb, osdata)) {
 				dev_put(odev);
-				return 0;
+				return NETDEV_TX_OK;
 			}
 		if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
 			IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.mesh,
@@ -1451,7 +1498,7 @@ int ieee80211_master_start_xmit(struct s
 	if (ieee80211_skb_resize(osdata->local, skb, headroom, may_encrypt)) {
 		dev_kfree_skb(skb);
 		dev_put(odev);
-		return 0;
+		return NETDEV_TX_OK;
 	}
 
 	if (osdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -1460,10 +1507,11 @@ int ieee80211_master_start_xmit(struct s
 				      u.ap);
 	if (likely(monitor_iface != UNKNOWN_ADDRESS))
 		info->control.vif = &osdata->vif;
-	ret = ieee80211_tx(odev, skb);
+
+	ieee80211_tx(odev, skb, false);
 	dev_put(odev);
 
-	return ret;
+	return NETDEV_TX_OK;
 }
 
 int ieee80211_monitor_start_xmit(struct sk_buff *skb,
@@ -1827,6 +1875,54 @@ void ieee80211_clear_tx_pending(struct i
 		skb_queue_purge(&local->pending[i]);
 }
 
+static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
+				     struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+	struct ieee80211_hdr *hdr;
+	struct net_device *dev;
+	int ret;
+	bool result = true;
+
+	/* does interface still exist? */
+	dev = dev_get_by_index(&init_net, skb->iif);
+	if (!dev) {
+		dev_kfree_skb(skb);
+		return true;
+	}
+
+	/* validate info->control.vif against skb->iif */
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		sdata = container_of(sdata->bss,
+				     struct ieee80211_sub_if_data,
+				     u.ap);
+
+	if (unlikely(info->control.vif && info->control.vif != &sdata->vif)) {
+		dev_kfree_skb(skb);
+		result = true;
+		goto out;
+	}
+
+	if (info->flags & IEEE80211_TX_INTFL_NEED_TXPROCESSING) {
+		ieee80211_tx(dev, skb, true);
+	} else {
+		hdr = (struct ieee80211_hdr *)skb->data;
+		sta = sta_info_get(local, hdr->addr1);
+
+		ret = __ieee80211_tx(local, &skb, sta);
+		if (ret != IEEE80211_TX_OK)
+			result = false;
+	}
+
+ out:
+	dev_put(dev);
+
+	return result;
+}
+
 /*
  * Transmit all pending packets. Called from tasklet, locks master device
  * TX lock so that no new packets can come in.
@@ -1835,9 +1931,8 @@ void ieee80211_tx_pending(unsigned long 
 {
 	struct ieee80211_local *local = (struct ieee80211_local *)data;
 	struct net_device *dev = local->mdev;
-	struct ieee80211_hdr *hdr;
 	unsigned long flags;
-	int i, ret;
+	int i;
 	bool next;
 
 	rcu_read_lock();
@@ -1868,13 +1963,8 @@ void ieee80211_tx_pending(unsigned long 
 
 		while (!skb_queue_empty(&local->pending[i])) {
 			struct sk_buff *skb = skb_dequeue(&local->pending[i]);
-			struct sta_info *sta;
-
-			hdr = (struct ieee80211_hdr *)skb->data;
-			sta = sta_info_get(local, hdr->addr1);
 
-			ret = __ieee80211_tx(local, &skb, sta);
-			if (ret != IEEE80211_TX_OK) {
+			if (!ieee80211_tx_pending_skb(local, skb)) {
 				skb_queue_head(&local->pending[i], skb);
 				break;
 			}
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-03-23 13:59:18.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-03-23 14:04:30.000000000 +0100
@@ -239,6 +239,11 @@ void sta_info_destroy(struct sta_info *s
 		tid_tx = sta->ampdu_mlme.tid_tx[i];
 		if (tid_tx) {
 			del_timer_sync(&tid_tx->addba_resp_timer);
+			/*
+			 * STA removed while aggregation session being
+			 * started? Bit odd, but purge frames anyway.
+			 */
+			skb_queue_purge(&tid_tx->pending);
 			kfree(tid_tx);
 		}
 	}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-03-23 14:03:45.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-03-23 14:04:30.000000000 +0100
@@ -637,6 +637,14 @@ struct ieee80211_local {
 	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
+	/*
+	 * This lock is used to prevent concurrent A-MPDU
+	 * session start/stop processing, this thus also
+	 * synchronises the ->ampdu_action() callback to
+	 * drivers and limits it to one at a time.
+	 */
+	spinlock_t ampdu_lock;
+
 	/* number of interfaces with corresponding IFF_ flags */
 	atomic_t iff_allmultis, iff_promiscs;
 
--- wireless-testing.orig/net/mac80211/main.c	2009-03-23 14:03:45.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-03-23 14:04:30.000000000 +0100
@@ -795,6 +795,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
 
+	spin_lock_init(&local->ampdu_lock);
+
 	return local_to_hw(local);
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);

-- 

