Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0FGLDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa6v-0007CB-TP
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:18 +0200
Message-Id: <20100607110201.421185000@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 13/21] mac80211: refcount aggregation queue stop
References: <20100607110133.472649120@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 currently maintains the ampdu_lock to
avoid starting a queue due to one aggregation
session while another aggregation session needs
the queue stopped.

We can do better, however, and instead refcount
the queue stops for this particular purpose,
thus removing the need for the lock. This will
help making ampdu_action able to sleep.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      |   77 +++++++++++++++++++++++++++------------------
 net/mac80211/ieee80211_i.h |    8 ----
 net/mac80211/main.c        |    6 +--
 3 files changed, 51 insertions(+), 40 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-06 13:22:24.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-06 13:22:25.000000000 +0200
@@ -723,13 +723,7 @@ struct ieee80211_local {
 	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
-	/*
-	 * This lock is used to prevent concurrent A-MPDU
-	 * session start/stop processing, this thus also
-	 * synchronises the ->ampdu_action() callback to
-	 * drivers and limits it to one at a time.
-	 */
-	spinlock_t ampdu_lock;
+	atomic_t agg_queue_stop[IEEE80211_MAX_QUEUES];
 
 	/* number of interfaces with corresponding IFF_ flags */
 	atomic_t iff_allmultis, iff_promiscs;
--- wireless-testing.orig/net/mac80211/main.c	2010-06-06 13:22:21.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-06-06 13:22:25.000000000 +0200
@@ -460,8 +460,10 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	sta_info_init(local);
 
-	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
+	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
 		skb_queue_head_init(&local->pending[i]);
+		atomic_set(&local->agg_queue_stop[i], 0);
+	}
 	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
 		     (unsigned long)local);
 
@@ -472,8 +474,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
 
-	spin_lock_init(&local->ampdu_lock);
-
 	return local_to_hw(local);
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-06 13:22:24.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-06 13:22:25.000000000 +0200
@@ -220,6 +220,41 @@ static inline int ieee80211_ac_from_tid(
 	return ieee802_1d_to_ac[tid & 7];
 }
 
+/*
+ * When multiple aggregation sessions on multiple stations
+ * are being created/destroyed simultaneously, we need to
+ * refcount the global queue stop caused by that in order
+ * to not get into a situation where one of the aggregation
+ * setup or teardown re-enables queues before the other is
+ * ready to handle that.
+ *
+ * These two functions take care of this issue by keeping
+ * a global "agg_queue_stop" refcount.
+ */
+static void __acquires(agg_queue)
+ieee80211_stop_queue_agg(struct ieee80211_local *local, int tid)
+{
+	int queue = ieee80211_ac_from_tid(tid);
+
+	if (atomic_inc_return(&local->agg_queue_stop[queue]) == 1)
+		ieee80211_stop_queue_by_reason(
+			&local->hw, queue,
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	__acquire(agg_queue);
+}
+
+static void __releases(agg_queue)
+ieee80211_wake_queue_agg(struct ieee80211_local *local, int tid)
+{
+	int queue = ieee80211_ac_from_tid(tid);
+
+	if (atomic_dec_return(&local->agg_queue_stop[queue]) == 0)
+		ieee80211_wake_queue_by_reason(
+			&local->hw, queue,
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	__release(agg_queue);
+}
+
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
@@ -263,7 +298,6 @@ int ieee80211_start_tx_ba_session(struct
 	}
 
 	spin_lock_bh(&sta->lock);
-	spin_lock(&local->ampdu_lock);
 
 	/* we have tried too many times, receiver does not want A-MPDU */
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
@@ -289,9 +323,7 @@ int ieee80211_start_tx_ba_session(struct
 	 * which would require us to put them to the AC pending
 	 * afterwards which just makes the code more complex.
 	 */
-	ieee80211_stop_queue_by_reason(
-		&local->hw, ieee80211_ac_from_tid(tid),
-		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	ieee80211_stop_queue_agg(local, tid);
 
 	/* prepare A-MPDU MLME for Tx aggregation */
 	tid_tx = kzalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
@@ -327,11 +359,7 @@ int ieee80211_start_tx_ba_session(struct
 	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
 
 	/* Driver vetoed or OKed, but we can take packets again now */
-	ieee80211_wake_queue_by_reason(
-		&local->hw, ieee80211_ac_from_tid(tid),
-		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
-
-	spin_unlock(&local->ampdu_lock);
+	ieee80211_wake_queue_agg(local, tid);
 
 	/* activate the timer for the recipient's addBA response */
 	tid_tx->addba_resp_timer.expires = jiffies + ADDBA_RESP_INTERVAL;
@@ -358,11 +386,8 @@ int ieee80211_start_tx_ba_session(struct
  err_free:
 	kfree(tid_tx);
  err_wake_queue:
-	ieee80211_wake_queue_by_reason(
-		&local->hw, ieee80211_ac_from_tid(tid),
-		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	ieee80211_wake_queue_agg(local, tid);
  err_unlock_sta:
-	spin_unlock(&local->ampdu_lock);
 	spin_unlock_bh(&sta->lock);
 	return ret;
 }
@@ -370,19 +395,16 @@ EXPORT_SYMBOL(ieee80211_start_tx_ba_sess
 
 /*
  * splice packets from the STA's pending to the local pending,
- * requires a call to ieee80211_agg_splice_finish and holding
- * local->ampdu_lock across both calls.
+ * requires a call to ieee80211_agg_splice_finish later
  */
-static void ieee80211_agg_splice_packets(struct ieee80211_local *local,
-					 struct tid_ampdu_tx *tid_tx,
-					 u16 tid)
+static void __acquires(agg_queue)
+ieee80211_agg_splice_packets(struct ieee80211_local *local,
+			     struct tid_ampdu_tx *tid_tx, u16 tid)
 {
+	int queue = ieee80211_ac_from_tid(tid);
 	unsigned long flags;
-	u16 queue = ieee80211_ac_from_tid(tid);
 
-	ieee80211_stop_queue_by_reason(
-		&local->hw, queue,
-		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	ieee80211_stop_queue_agg(local, tid);
 
 	if (WARN(!tid_tx, "TID %d gone but expected when splicing aggregates"
 			  " from the pending queue\n", tid))
@@ -397,11 +419,10 @@ static void ieee80211_agg_splice_packets
 	}
 }
 
-static void ieee80211_agg_splice_finish(struct ieee80211_local *local, u16 tid)
+static void __releases(agg_queue)
+ieee80211_agg_splice_finish(struct ieee80211_local *local, u16 tid)
 {
-	ieee80211_wake_queue_by_reason(
-		&local->hw, ieee80211_ac_from_tid(tid),
-		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	ieee80211_wake_queue_agg(local, tid);
 }
 
 /* caller must hold sta->lock */
@@ -414,7 +435,6 @@ static void ieee80211_agg_tx_operational
 	printk(KERN_DEBUG "Aggregation is on for tid %d\n", tid);
 #endif
 
-	spin_lock(&local->ampdu_lock);
 	ieee80211_agg_splice_packets(local, sta->ampdu_mlme.tid_tx[tid], tid);
 	/*
 	 * Now mark as operational. This will be visible
@@ -423,7 +443,6 @@ static void ieee80211_agg_tx_operational
 	 */
 	set_bit(HT_AGG_STATE_OPERATIONAL, &sta->ampdu_mlme.tid_tx[tid]->state);
 	ieee80211_agg_splice_finish(local, tid);
-	spin_unlock(&local->ampdu_lock);
 
 	drv_ampdu_action(local, sta->sdata,
 			 IEEE80211_AMPDU_TX_OPERATIONAL,
@@ -604,7 +623,6 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	 * more.
 	 */
 
-	spin_lock(&local->ampdu_lock);
 	ieee80211_agg_splice_packets(local, tid_tx, tid);
 
 	/* future packets must not find the tid_tx struct any more */
@@ -613,7 +631,6 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	ieee80211_agg_splice_finish(local, tid);
 
 	call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
-	spin_unlock(&local->ampdu_lock);
 
 	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();


