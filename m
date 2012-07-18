Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab2GRSnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 14:43:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 5/6] mac80211: split out aggregation TX removal
Date: Wed, 18 Jul 2012 20:43:19 +0200
Message-Id: <1342637000-5270-6-git-send-email-johannes@sipsolutions.net> (sfid-20120718_204334_035250_A88586B8)
In-Reply-To: <1342637000-5270-1-git-send-email-johannes@sipsolutions.net>
References: <1342637000-5270-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Create the function ieee80211_remove_tid_tx to call
it from ___ieee80211_stop_tx_ba_session in the next
patch, it's also necessary to move the code up in
the file for this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c |  196 ++++++++++++++++++++++++++-----------------------
 1 file changed, 104 insertions(+), 92 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 34d318e..5359b5c 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -149,6 +149,109 @@ void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
 }
 
+static inline int ieee80211_ac_from_tid(int tid)
+{
+	return ieee802_1d_to_ac[tid & 7];
+}
+
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
+ieee80211_stop_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
+{
+	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
+
+	if (atomic_inc_return(&sdata->local->agg_queue_stop[queue]) == 1)
+		ieee80211_stop_queue_by_reason(
+			&sdata->local->hw, queue,
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	__acquire(agg_queue);
+}
+
+static void __releases(agg_queue)
+ieee80211_wake_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
+{
+	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
+
+	if (atomic_dec_return(&sdata->local->agg_queue_stop[queue]) == 0)
+		ieee80211_wake_queue_by_reason(
+			&sdata->local->hw, queue,
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+	__release(agg_queue);
+}
+
+/*
+ * splice packets from the STA's pending to the local pending,
+ * requires a call to ieee80211_agg_splice_finish later
+ */
+static void __acquires(agg_queue)
+ieee80211_agg_splice_packets(struct ieee80211_sub_if_data *sdata,
+			     struct tid_ampdu_tx *tid_tx, u16 tid)
+{
+	struct ieee80211_local *local = sdata->local;
+	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
+	unsigned long flags;
+
+	ieee80211_stop_queue_agg(sdata, tid);
+
+	if (WARN(!tid_tx,
+		 "TID %d gone but expected when splicing aggregates from the pending queue\n",
+		 tid))
+		return;
+
+	if (!skb_queue_empty(&tid_tx->pending)) {
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		/* copy over remaining packets */
+		skb_queue_splice_tail_init(&tid_tx->pending,
+					   &local->pending[queue]);
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	}
+}
+
+static void __releases(agg_queue)
+ieee80211_agg_splice_finish(struct ieee80211_sub_if_data *sdata, u16 tid)
+{
+	ieee80211_wake_queue_agg(sdata, tid);
+}
+
+static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
+{
+	struct tid_ampdu_tx *tid_tx;
+
+	lockdep_assert_held(&sta->ampdu_mlme.mtx);
+	lockdep_assert_held(&sta->lock);
+
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+
+	/*
+	 * When we get here, the TX path will not be lockless any more wrt.
+	 * aggregation, since the OPERATIONAL bit has long been cleared.
+	 * Thus it will block on getting the lock, if it occurs. So if we
+	 * stop the queue now, we will not get any more packets, and any
+	 * that might be being processed will wait for us here, thereby
+	 * guaranteeing that no packets go to the tid_tx pending queue any
+	 * more.
+	 */
+
+	ieee80211_agg_splice_packets(sta->sdata, tid_tx, tid);
+
+	/* future packets must not find the tid_tx struct any more */
+	ieee80211_assign_tid_tx(sta, tid, NULL);
+
+	ieee80211_agg_splice_finish(sta->sdata, tid);
+
+	kfree_rcu(tid_tx, rcu_head);
+}
+
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_agg_stop_reason reason)
 {
@@ -265,80 +368,6 @@ static void sta_addba_resp_timer_expired(unsigned long data)
 	rcu_read_unlock();
 }
 
-static inline int ieee80211_ac_from_tid(int tid)
-{
-	return ieee802_1d_to_ac[tid & 7];
-}
-
-/*
- * When multiple aggregation sessions on multiple stations
- * are being created/destroyed simultaneously, we need to
- * refcount the global queue stop caused by that in order
- * to not get into a situation where one of the aggregation
- * setup or teardown re-enables queues before the other is
- * ready to handle that.
- *
- * These two functions take care of this issue by keeping
- * a global "agg_queue_stop" refcount.
- */
-static void __acquires(agg_queue)
-ieee80211_stop_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
-{
-	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
-
-	if (atomic_inc_return(&sdata->local->agg_queue_stop[queue]) == 1)
-		ieee80211_stop_queue_by_reason(
-			&sdata->local->hw, queue,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
-	__acquire(agg_queue);
-}
-
-static void __releases(agg_queue)
-ieee80211_wake_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
-{
-	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
-
-	if (atomic_dec_return(&sdata->local->agg_queue_stop[queue]) == 0)
-		ieee80211_wake_queue_by_reason(
-			&sdata->local->hw, queue,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
-	__release(agg_queue);
-}
-
-/*
- * splice packets from the STA's pending to the local pending,
- * requires a call to ieee80211_agg_splice_finish later
- */
-static void __acquires(agg_queue)
-ieee80211_agg_splice_packets(struct ieee80211_sub_if_data *sdata,
-			     struct tid_ampdu_tx *tid_tx, u16 tid)
-{
-	struct ieee80211_local *local = sdata->local;
-	int queue = sdata->vif.hw_queue[ieee80211_ac_from_tid(tid)];
-	unsigned long flags;
-
-	ieee80211_stop_queue_agg(sdata, tid);
-
-	if (WARN(!tid_tx,
-		 "TID %d gone but expected when splicing aggregates from the pending queue\n",
-		 tid))
-		return;
-
-	if (!skb_queue_empty(&tid_tx->pending)) {
-		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		/* copy over remaining packets */
-		skb_queue_splice_tail_init(&tid_tx->pending,
-					   &local->pending[queue]);
-		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
-	}
-}
-
-static void __releases(agg_queue)
-ieee80211_agg_splice_finish(struct ieee80211_sub_if_data *sdata, u16 tid)
-{
-	ieee80211_wake_queue_agg(sdata, tid);
-}
-
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
@@ -751,24 +780,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 		ieee80211_send_delba(sta->sdata, ra, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
-	/*
-	 * When we get here, the TX path will not be lockless any more wrt.
-	 * aggregation, since the OPERATIONAL bit has long been cleared.
-	 * Thus it will block on getting the lock, if it occurs. So if we
-	 * stop the queue now, we will not get any more packets, and any
-	 * that might be being processed will wait for us here, thereby
-	 * guaranteeing that no packets go to the tid_tx pending queue any
-	 * more.
-	 */
-
-	ieee80211_agg_splice_packets(sta->sdata, tid_tx, tid);
-
-	/* future packets must not find the tid_tx struct any more */
-	ieee80211_assign_tid_tx(sta, tid, NULL);
-
-	ieee80211_agg_splice_finish(sta->sdata, tid);
-
-	kfree_rcu(tid_tx, rcu_head);
+	ieee80211_remove_tid_tx(sta, tid);
 
  unlock_sta:
 	spin_unlock_bh(&sta->lock);
-- 
1.7.10.4

