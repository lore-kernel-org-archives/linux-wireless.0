Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab0FIPHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 11:07:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OMMs5-00089D-1t
	for linux-wireless@vger.kernel.org; Wed, 09 Jun 2010 17:07:13 +0200
Message-Id: <20100609150455.036642080@sipsolutions.net>
Date: Wed, 09 Jun 2010 17:01:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 11/22] mac80211: use RCU for TX aggregation
References: <20100609150142.227469359@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently we allocate some memory for each TX
aggregation session and additionally keep a
state bitmap indicating the state it is in.
By using RCU to protect the pointer, moving
the state into the structure and some locking
trickery we can avoid locking when the TX agg
session is fully operational.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c              |  229 ++++++++++++++++++-------------------
 net/mac80211/debugfs_sta.c         |    8 -
 net/mac80211/ht.c                  |    9 -
 net/mac80211/ieee80211_i.h         |    2 
 net/mac80211/rc80211_minstrel_ht.c |    2 
 net/mac80211/sta_info.c            |   12 -
 net/mac80211/sta_info.h            |   33 +++--
 net/mac80211/tx.c                  |   88 +++++++++-----
 8 files changed, 206 insertions(+), 177 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-09 12:57:26.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-09 12:57:27.000000000 +0200
@@ -125,25 +125,42 @@ void ieee80211_send_bar(struct ieee80211
 	ieee80211_tx_skb(sdata, skb);
 }
 
-int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				    enum ieee80211_back_parties initiator)
+static void kfree_tid_tx(struct rcu_head *rcu_head)
+{
+	struct tid_ampdu_tx *tid_tx =
+	    container_of(rcu_head, struct tid_ampdu_tx, rcu_head);
+
+	kfree(tid_tx);
+}
+
+static int ___ieee80211_stop_tx_ba_session(
+		struct sta_info *sta, u16 tid,
+		enum ieee80211_back_parties initiator)
 {
 	struct ieee80211_local *local = sta->local;
+	struct tid_ampdu_tx *tid_tx = sta->ampdu_mlme.tid_tx[tid];
 	int ret;
-	u8 *state;
+
+	lockdep_assert_held(&sta->lock);
+
+	if (WARN_ON(!tid_tx))
+		return -ENOENT;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Tx BA session stop requested for %pM tid %u\n",
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
 
-	if (*state == HT_AGG_STATE_OPERATIONAL)
-		sta->ampdu_mlme.addba_req_num[tid] = 0;
+	/*
+	 * After this packets are no longer handed right through
+	 * to the driver but are put onto tid_tx->pending instead,
+	 * with locking to ensure proper access.
+	 */
+	clear_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
 
-	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
-		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
+	tid_tx->stop_initiator = initiator;
 
 	ret = drv_ampdu_action(local, sta->sdata,
 			       IEEE80211_AMPDU_TX_STOP,
@@ -174,15 +191,13 @@ static void sta_addba_resp_timer_expired
 	u16 tid = *(u8 *)data;
 	struct sta_info *sta = container_of((void *)data,
 		struct sta_info, timer_to_tid[tid]);
-	u8 *state;
-
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	struct tid_ampdu_tx *tid_tx;
 
 	/* check if the TID waits for addBA response */
 	spin_lock_bh(&sta->lock);
-	if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK |
-		       HT_AGG_STATE_REQ_STOP_BA_MSK)) !=
-						HT_ADDBA_REQUESTED_MSK) {
+	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	if (!tid_tx ||
+	    test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state)) {
 		spin_unlock_bh(&sta->lock);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "timer expired on tid %d but we are not "
@@ -210,7 +225,7 @@ int ieee80211_start_tx_ba_session(struct
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	u8 *state;
+	struct tid_ampdu_tx *tid_tx;
 	int ret = 0;
 	u16 start_seq_num;
 
@@ -256,9 +271,9 @@ int ieee80211_start_tx_ba_session(struct
 		goto err_unlock_sta;
 	}
 
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	tid_tx = sta->ampdu_mlme.tid_tx[tid];
 	/* check if the TID is not in aggregation flow already */
-	if (*state != HT_AGG_STATE_IDLE) {
+	if (tid_tx) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - session is not "
 				 "idle on tid %u\n", tid);
@@ -279,9 +294,8 @@ int ieee80211_start_tx_ba_session(struct
 		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
 
 	/* prepare A-MPDU MLME for Tx aggregation */
-	sta->ampdu_mlme.tid_tx[tid] =
-			kmalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
-	if (!sta->ampdu_mlme.tid_tx[tid]) {
+	tid_tx = kzalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
+	if (!tid_tx) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_ERR "allocate tx mlme to tid %d failed\n",
@@ -291,33 +305,27 @@ int ieee80211_start_tx_ba_session(struct
 		goto err_wake_queue;
 	}
 
-	skb_queue_head_init(&sta->ampdu_mlme.tid_tx[tid]->pending);
+	skb_queue_head_init(&tid_tx->pending);
 
 	/* Tx timer */
-	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.function =
-			sta_addba_resp_timer_expired;
-	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.data =
-			(unsigned long)&sta->timer_to_tid[tid];
-	init_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
-
-	/* Ok, the Addba frame hasn't been sent yet, but if the driver calls the
-	 * call back right away, it must see that the flow has begun */
-	*state |= HT_ADDBA_REQUESTED_MSK;
+	tid_tx->addba_resp_timer.function = sta_addba_resp_timer_expired;
+	tid_tx->addba_resp_timer.data = (unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&tid_tx->addba_resp_timer);
 
 	start_seq_num = sta->tid_seq[tid] >> 4;
 
 	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
 			       pubsta, tid, &start_seq_num);
-
 	if (ret) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - HW unavailable for"
 					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		*state = HT_AGG_STATE_IDLE;
 		goto err_free;
 	}
 
+	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
+
 	/* Driver vetoed or OKed, but we can take packets again now */
 	ieee80211_wake_queue_by_reason(
 		&local->hw, ieee80211_ac_from_tid(tid),
@@ -325,32 +333,30 @@ int ieee80211_start_tx_ba_session(struct
 
 	spin_unlock(&local->ampdu_lock);
 
+	/* activate the timer for the recipient's addBA response */
+	tid_tx->addba_resp_timer.expires = jiffies + ADDBA_RESP_INTERVAL;
+	add_timer(&tid_tx->addba_resp_timer);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
+#endif
+
 	/* prepare tid data */
 	sta->ampdu_mlme.dialog_token_allocator++;
-	sta->ampdu_mlme.tid_tx[tid]->dialog_token =
-			sta->ampdu_mlme.dialog_token_allocator;
-	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
+	tid_tx->dialog_token = sta->ampdu_mlme.dialog_token_allocator;
+	tid_tx->ssn = start_seq_num;
+
+	sta->ampdu_mlme.addba_req_num[tid]++;
 
 	spin_unlock_bh(&sta->lock);
 
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, pubsta->addr, tid,
-			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
-			 sta->ampdu_mlme.tid_tx[tid]->ssn,
+			 tid_tx->dialog_token, tid_tx->ssn,
 			 0x40, 5000);
-	sta->ampdu_mlme.addba_req_num[tid]++;
-	/* activate the timer for the recipient's addBA response */
-	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =
-				jiffies + ADDBA_RESP_INTERVAL;
-	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
-#endif
 	return 0;
 
  err_free:
-	kfree(sta->ampdu_mlme.tid_tx[tid]);
-	sta->ampdu_mlme.tid_tx[tid] = NULL;
+	kfree(tid_tx);
  err_wake_queue:
 	ieee80211_wake_queue_by_reason(
 		&local->hw, ieee80211_ac_from_tid(tid),
@@ -368,7 +374,8 @@ EXPORT_SYMBOL(ieee80211_start_tx_ba_sess
  * local->ampdu_lock across both calls.
  */
 static void ieee80211_agg_splice_packets(struct ieee80211_local *local,
-					 struct sta_info *sta, u16 tid)
+					 struct tid_ampdu_tx *tid_tx,
+					 u16 tid)
 {
 	unsigned long flags;
 	u16 queue = ieee80211_ac_from_tid(tid);
@@ -377,31 +384,23 @@ static void ieee80211_agg_splice_packets
 		&local->hw, queue,
 		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
 
-	if (!(sta->ampdu_mlme.tid_state_tx[tid] & HT_ADDBA_REQUESTED_MSK))
-		return;
-
-	if (WARN(!sta->ampdu_mlme.tid_tx[tid],
-		 "TID %d gone but expected when splicing aggregates from"
-		 "the pending queue\n", tid))
+	if (WARN(!tid_tx, "TID %d gone but expected when splicing aggregates"
+			  " from the pending queue\n", tid))
 		return;
 
-	if (!skb_queue_empty(&sta->ampdu_mlme.tid_tx[tid]->pending)) {
+	if (!skb_queue_empty(&tid_tx->pending)) {
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		/* copy over remaining packets */
-		skb_queue_splice_tail_init(
-			&sta->ampdu_mlme.tid_tx[tid]->pending,
-			&local->pending[queue]);
+		skb_queue_splice_tail_init(&tid_tx->pending,
+					   &local->pending[queue]);
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 	}
 }
 
-static void ieee80211_agg_splice_finish(struct ieee80211_local *local,
-					struct sta_info *sta, u16 tid)
+static void ieee80211_agg_splice_finish(struct ieee80211_local *local, u16 tid)
 {
-	u16 queue = ieee80211_ac_from_tid(tid);
-
 	ieee80211_wake_queue_by_reason(
-		&local->hw, queue,
+		&local->hw, ieee80211_ac_from_tid(tid),
 		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
 }
 
@@ -409,19 +408,21 @@ static void ieee80211_agg_splice_finish(
 static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 					 struct sta_info *sta, u16 tid)
 {
+	lockdep_assert_held(&sta->lock);
+
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Aggregation is on for tid %d\n", tid);
 #endif
 
 	spin_lock(&local->ampdu_lock);
-	ieee80211_agg_splice_packets(local, sta, tid);
+	ieee80211_agg_splice_packets(local, sta->ampdu_mlme.tid_tx[tid], tid);
 	/*
-	 * NB: we rely on sta->lock being taken in the TX
-	 * processing here when adding to the pending queue,
-	 * otherwise we could only change the state of the
-	 * session to OPERATIONAL _here_.
+	 * Now mark as operational. This will be visible
+	 * in the TX path, and lets it go lock-free in
+	 * the common case.
 	 */
-	ieee80211_agg_splice_finish(local, sta, tid);
+	set_bit(HT_AGG_STATE_OPERATIONAL, &sta->ampdu_mlme.tid_tx[tid]->state);
+	ieee80211_agg_splice_finish(local, tid);
 	spin_unlock(&local->ampdu_lock);
 
 	drv_ampdu_action(local, sta->sdata,
@@ -434,7 +435,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	u8 *state;
+	struct tid_ampdu_tx *tid_tx;
 
 	trace_api_start_tx_ba_cb(sdata, ra, tid);
 
@@ -456,25 +457,22 @@ void ieee80211_start_tx_ba_cb(struct iee
 		return;
 	}
 
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
 	spin_lock_bh(&sta->lock);
+	tid_tx = sta->ampdu_mlme.tid_tx[tid];
 
-	if (WARN_ON(!(*state & HT_ADDBA_REQUESTED_MSK))) {
+	if (WARN_ON(!tid_tx)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "addBA was not requested yet, state is %d\n",
-				*state);
+		printk(KERN_DEBUG "addBA was not requested!\n");
 #endif
 		spin_unlock_bh(&sta->lock);
 		rcu_read_unlock();
 		return;
 	}
 
-	if (WARN_ON(*state & HT_ADDBA_DRV_READY_MSK))
+	if (WARN_ON(test_and_set_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state)))
 		goto out;
 
-	*state |= HT_ADDBA_DRV_READY_MSK;
-
-	if (*state == HT_AGG_STATE_OPERATIONAL)
+	if (test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state))
 		ieee80211_agg_tx_operational(local, sta, tid);
 
  out:
@@ -512,14 +510,14 @@ EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_i
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_back_parties initiator)
 {
-	u8 *state;
+	struct tid_ampdu_tx *tid_tx;
 	int ret;
 
-	/* check if the TID is in aggregation */
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
 	spin_lock_bh(&sta->lock);
+	tid_tx = sta->ampdu_mlme.tid_tx[tid];
 
-	if (*state != HT_AGG_STATE_OPERATIONAL) {
+	/* check if the TID is in aggregation */
+	if (!tid_tx || !test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 		ret = -ENOENT;
 		goto unlock;
 	}
@@ -554,7 +552,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	u8 *state;
+	struct tid_ampdu_tx *tid_tx;
 
 	trace_api_stop_tx_ba_cb(sdata, ra, tid);
 
@@ -580,39 +578,45 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 		rcu_read_unlock();
 		return;
 	}
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
-	/* NOTE: no need to use sta->lock in this state check, as
-	 * ieee80211_stop_tx_ba_session will let only one stop call to
-	 * pass through per sta/tid
-	 */
-	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
+	spin_lock_bh(&sta->lock);
+	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+
+	if (!tid_tx || !test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
 #endif
+		spin_unlock_bh(&sta->lock);
 		rcu_read_unlock();
 		return;
 	}
 
-	if (*state & HT_AGG_STATE_INITIATOR_MSK)
+	if (tid_tx->stop_initiator == WLAN_BACK_INITIATOR)
 		ieee80211_send_delba(sta->sdata, ra, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
-	spin_lock_bh(&sta->lock);
-	spin_lock(&local->ampdu_lock);
+	/*
+	 * When we get here, the TX path will not be lockless any more wrt.
+	 * aggregation, since the OPERATIONAL bit has long been cleared.
+	 * Thus it will block on getting the lock, if it occurs. So if we
+	 * stop the queue now, we will not get any more packets, and any
+	 * that might be being processed will wait for us here, thereby
+	 * guaranteeing that no packets go to the tid_tx pending queue any
+	 * more.
+	 */
 
-	ieee80211_agg_splice_packets(local, sta, tid);
+	spin_lock(&local->ampdu_lock);
+	ieee80211_agg_splice_packets(local, tid_tx, tid);
 
-	*state = HT_AGG_STATE_IDLE;
-	/* from now on packets are no longer put onto sta->pending */
-	kfree(sta->ampdu_mlme.tid_tx[tid]);
-	sta->ampdu_mlme.tid_tx[tid] = NULL;
+	/* future packets must not find the tid_tx struct any more */
+	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
 
-	ieee80211_agg_splice_finish(local, sta, tid);
+	ieee80211_agg_splice_finish(local, tid);
 
+	call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
 	spin_unlock(&local->ampdu_lock);
-	spin_unlock_bh(&sta->lock);
 
+	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
@@ -649,40 +653,41 @@ void ieee80211_process_addba_resp(struct
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len)
 {
+	struct tid_ampdu_tx *tid_tx;
 	u16 capab, tid;
-	u8 *state;
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
 
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-
 	spin_lock_bh(&sta->lock);
 
-	if (!(*state & HT_ADDBA_REQUESTED_MSK))
+	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+
+	if (!tid_tx)
 		goto out;
 
-	if (mgmt->u.action.u.addba_resp.dialog_token !=
-		sta->ampdu_mlme.tid_tx[tid]->dialog_token) {
+	if (mgmt->u.action.u.addba_resp.dialog_token != tid_tx->dialog_token) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
+#endif
 		goto out;
 	}
 
-	del_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+	del_timer(&tid_tx->addba_resp_timer);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
+#endif
 
 	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
 			== WLAN_STATUS_SUCCESS) {
-		u8 curstate = *state;
-
-		*state |= HT_ADDBA_RECEIVED_MSK;
+		if (test_and_set_bit(HT_AGG_STATE_RESPONSE_RECEIVED,
+				     &tid_tx->state)) {
+			/* ignore duplicate response */
+			goto out;
+		}
 
-		if (*state != curstate && *state == HT_AGG_STATE_OPERATIONAL)
+		if (test_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state))
 			ieee80211_agg_tx_operational(local, sta, tid);
 
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-06-09 12:57:26.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-06-09 12:57:27.000000000 +0200
@@ -61,33 +61,40 @@ enum ieee80211_sta_info_flags {
 
 #define STA_TID_NUM 16
 #define ADDBA_RESP_INTERVAL HZ
-#define HT_AGG_MAX_RETRIES		(0x3)
+#define HT_AGG_MAX_RETRIES		0x3
 
-#define HT_AGG_STATE_INITIATOR_SHIFT	(4)
-
-#define HT_ADDBA_REQUESTED_MSK		BIT(0)
-#define HT_ADDBA_DRV_READY_MSK		BIT(1)
-#define HT_ADDBA_RECEIVED_MSK		BIT(2)
-#define HT_AGG_STATE_REQ_STOP_BA_MSK	BIT(3)
-#define HT_AGG_STATE_INITIATOR_MSK      BIT(HT_AGG_STATE_INITIATOR_SHIFT)
-#define HT_AGG_STATE_IDLE		(0x0)
-#define HT_AGG_STATE_OPERATIONAL	(HT_ADDBA_REQUESTED_MSK |	\
-					 HT_ADDBA_DRV_READY_MSK |	\
-					 HT_ADDBA_RECEIVED_MSK)
+#define HT_AGG_STATE_DRV_READY		0
+#define HT_AGG_STATE_RESPONSE_RECEIVED	1
+#define HT_AGG_STATE_OPERATIONAL	2
+#define HT_AGG_STATE_STOPPING		3
 
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).
  *
+ * @rcu_head: rcu head for freeing structure
  * @addba_resp_timer: timer for peer's response to addba request
  * @pending: pending frames queue -- use sta's spinlock to protect
  * @ssn: Starting Sequence Number expected to be aggregated.
  * @dialog_token: dialog token for aggregation session
+ * @state: session state (see above)
+ * @stop_initiator: initiator of a session stop
+ *
+ * This structure is protected by RCU and the per-station
+ * spinlock. Assignments to the array holding it must hold
+ * the spinlock, only the TX path can access it under RCU
+ * lock-free if, and only if, the state has  the flag
+ * %HT_AGG_STATE_OPERATIONAL set. Otherwise, the TX path
+ * must also acquire the spinlock and re-check the state,
+ * see comments in the tx code touching it.
  */
 struct tid_ampdu_tx {
+	struct rcu_head rcu_head;
 	struct timer_list addba_resp_timer;
 	struct sk_buff_head pending;
+	unsigned long state;
 	u16 ssn;
 	u8 dialog_token;
+	u8 stop_initiator;
 };
 
 /**
@@ -129,7 +136,6 @@ struct tid_ampdu_rx {
  * struct sta_ampdu_mlme - STA aggregation information.
  *
  * @tid_rx: aggregation info for Rx per TID -- RCU protected
- * @tid_state_tx: TID's state in Tx session state machine.
  * @tid_tx: aggregation info for Tx per TID
  * @addba_req_num: number of times addBA request has been sent.
  * @dialog_token_allocator: dialog token enumerator for each new session;
@@ -138,7 +144,6 @@ struct sta_ampdu_mlme {
 	/* rx */
 	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
 	/* tx */
-	u8 tid_state_tx[STA_TID_NUM];
 	struct tid_ampdu_tx *tid_tx[STA_TID_NUM];
 	u8 addba_req_num[STA_TID_NUM];
 	u8 dialog_token_allocator;
--- wireless-testing.orig/net/mac80211/tx.c	2010-06-09 12:51:28.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2010-06-09 12:57:27.000000000 +0200
@@ -1092,6 +1092,54 @@ static bool __ieee80211_parse_tx_radiota
 	return true;
 }
 
+static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
+				  struct sk_buff *skb,
+				  struct ieee80211_tx_info *info,
+				  struct tid_ampdu_tx *tid_tx,
+				  int tid)
+{
+	bool queued = false;
+
+	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+		info->flags |= IEEE80211_TX_CTL_AMPDU;
+	} else {
+		spin_lock(&tx->sta->lock);
+		/*
+		 * Need to re-check now, because we may get here
+		 *
+		 *  1) in the window during which the setup is actually
+		 *     already done, but not marked yet because not all
+		 *     packets are spliced over to the driver pending
+		 *     queue yet -- if this happened we acquire the lock
+		 *     either before or after the splice happens, but
+		 *     need to recheck which of these cases happened.
+		 *
+		 *  2) during session teardown, if the OPERATIONAL bit
+		 *     was cleared due to the teardown but the pointer
+		 *     hasn't been assigned NULL yet (or we loaded it
+		 *     before it was assigned) -- in this case it may
+		 *     now be NULL which means we should just let the
+		 *     packet pass through because splicing the frames
+		 *     back is already done.
+		 */
+		tid_tx = tx->sta->ampdu_mlme.tid_tx[tid];
+
+		if (!tid_tx) {
+			/* do nothing, let packet pass through */
+		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+			info->flags |= IEEE80211_TX_CTL_AMPDU;
+		} else {
+			queued = true;
+			info->control.vif = &tx->sdata->vif;
+			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+			__skb_queue_tail(&tid_tx->pending, skb);
+		}
+		spin_unlock(&tx->sta->lock);
+	}
+
+	return queued;
+}
+
 /*
  * initialises @tx
  */
@@ -1104,8 +1152,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen, tid;
-	u8 *qc, *state;
-	bool queued = false;
+	u8 *qc;
 
 	memset(tx, 0, sizeof(*tx));
 	tx->skb = skb;
@@ -1157,35 +1204,16 @@ ieee80211_tx_prepare(struct ieee80211_su
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 
-		spin_lock(&tx->sta->lock);
-		/*
-		 * XXX: This spinlock could be fairly expensive, but see the
-		 *	comment in agg-tx.c:ieee80211_agg_tx_operational().
-		 *	One way to solve this would be to do something RCU-like
-		 *	for managing the tid_tx struct and using atomic bitops
-		 *	for the actual state -- by introducing an actual
-		 *	'operational' bit that would be possible. It would
-		 *	require changing ieee80211_agg_tx_operational() to
-		 *	set that bit, and changing the way tid_tx is managed
-		 *	everywhere, including races between that bit and
-		 *	tid_tx going away (tid_tx being added can be easily
-		 *	committed to memory before the 'operational' bit).
-		 */
-		tid_tx = tx->sta->ampdu_mlme.tid_tx[tid];
-		state = &tx->sta->ampdu_mlme.tid_state_tx[tid];
-		if (*state == HT_AGG_STATE_OPERATIONAL) {
-			info->flags |= IEEE80211_TX_CTL_AMPDU;
-		} else if (*state != HT_AGG_STATE_IDLE) {
-			/* in progress */
-			queued = true;
-			info->control.vif = &sdata->vif;
-			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
-			__skb_queue_tail(&tid_tx->pending, skb);
-		}
-		spin_unlock(&tx->sta->lock);
+		tid_tx = rcu_dereference(tx->sta->ampdu_mlme.tid_tx[tid]);
+		if (tid_tx) {
+			bool queued;
+
+			queued = ieee80211_tx_prep_agg(tx, skb, info,
+						       tid_tx, tid);
 
-		if (unlikely(queued))
-			return TX_QUEUED;
+			if (unlikely(queued))
+				return TX_QUEUED;
+		}
 	}
 
 	if (is_multicast_ether_addr(hdr->addr1)) {
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-06-09 12:51:28.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-06-09 12:57:27.000000000 +0200
@@ -246,14 +246,12 @@ struct sta_info *sta_info_alloc(struct i
 	}
 
 	for (i = 0; i < STA_TID_NUM; i++) {
-		/* timer_to_tid must be initialized with identity mapping to
-		 * enable session_timer's data differentiation. refer to
-		 * sta_rx_agg_session_timer_expired for useage */
+		/*
+		 * timer_to_tid must be initialized with identity mapping
+		 * to enable session_timer's data differentiation. See
+		 * sta_rx_agg_session_timer_expired for usage.
+		 */
 		sta->timer_to_tid[i] = i;
-		/* tx */
-		sta->ampdu_mlme.tid_state_tx[i] = HT_AGG_STATE_IDLE;
-		sta->ampdu_mlme.tid_tx[i] = NULL;
-		sta->ampdu_mlme.addba_req_num[i] = 0;
 	}
 	skb_queue_head_init(&sta->ps_tx_buf);
 	skb_queue_head_init(&sta->tx_filtered);
--- wireless-testing.orig/net/mac80211/ht.c	2010-06-09 12:51:28.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-06-09 12:57:27.000000000 +0200
@@ -176,13 +176,8 @@ void ieee80211_process_delba(struct ieee
 
 	if (initiator == WLAN_BACK_INITIATOR)
 		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0);
-	else { /* WLAN_BACK_RECIPIENT */
-		spin_lock_bh(&sta->lock);
-		if (sta->ampdu_mlme.tid_state_tx[tid] & HT_ADDBA_REQUESTED_MSK)
-			___ieee80211_stop_tx_ba_session(sta, tid,
-							WLAN_BACK_RECIPIENT);
-		spin_unlock_bh(&sta->lock);
-	}
+	else
+		__ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_RECIPIENT);
 }
 
 int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2010-06-09 12:57:26.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2010-06-09 12:57:27.000000000 +0200
@@ -134,15 +134,15 @@ static ssize_t sta_agg_status_read(struc
 				sta->ampdu_mlme.tid_rx[i]->ssn : 0);
 
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",
-				sta->ampdu_mlme.tid_state_tx[i]);
+				!!sta->ampdu_mlme.tid_tx[i]);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
-				sta->ampdu_mlme.tid_state_tx[i] ?
+				sta->ampdu_mlme.tid_tx[i] ?
 				sta->ampdu_mlme.tid_tx[i]->dialog_token : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
-				sta->ampdu_mlme.tid_state_tx[i] ?
+				sta->ampdu_mlme.tid_tx[i] ?
 				sta->ampdu_mlme.tid_tx[i]->ssn : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%03d",
-				sta->ampdu_mlme.tid_state_tx[i] ?
+				sta->ampdu_mlme.tid_tx[i] ?
 				skb_queue_len(&sta->ampdu_mlme.tid_tx[i]->pending) : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\n");
 	}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-09 12:57:26.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-09 12:57:27.000000000 +0200
@@ -1124,8 +1124,6 @@ void ieee80211_process_addba_request(str
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_back_parties initiator);
-int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				    enum ieee80211_back_parties initiator);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/rc80211_minstrel_ht.c	2010-06-09 12:51:28.000000000 +0200
+++ wireless-testing/net/mac80211/rc80211_minstrel_ht.c	2010-06-09 12:57:27.000000000 +0200
@@ -365,7 +365,7 @@ minstrel_aggr_check(struct minstrel_priv
 		return;
 
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
-	if (likely(sta->ampdu_mlme.tid_state_tx[tid] != HT_AGG_STATE_IDLE))
+	if (likely(sta->ampdu_mlme.tid_tx[tid]))
 		return;
 
 	ieee80211_start_tx_ba_session(pubsta, tid);


