Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1EMLfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 07:35:43 -0400
Subject: [PATCH] mac80211: fix TX a-MPDU locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 13:35:40 +0200
Message-ID: <1305286540.3487.14.camel@jlt3.sipsolutions.net> (sfid-20110513_133552_791814_D849FD92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During my quest to make mac80211 not have any RCU
warnings from sparse, I came across the a-MPDU code
again and it wasn't quite clear why it isn't racy.
So instead of assigning the tid_tx array with just
the spinlock held in ieee80211_start_tx_ba_session
use a separate temporary array protected only by
the spinlock and protect all assignments to the
"live" array by both the spinlock and the mutex so
that other code is easily verified to be correct.

Due to pointer assignment atomicity I don't think
this is a real issue, but I'm not sure, especially
on Alpha the current code might be problematic.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c   |   23 +++++++++++++++++------
 net/mac80211/ht.c       |   27 +++++++++++++++++++++------
 net/mac80211/sta_info.h |    4 ++++
 3 files changed, 42 insertions(+), 12 deletions(-)

--- a/net/mac80211/agg-tx.c	2011-05-13 13:34:49.000000000 +0200
+++ b/net/mac80211/agg-tx.c	2011-05-13 13:34:50.000000000 +0200
@@ -136,6 +136,14 @@ void ieee80211_send_bar(struct ieee80211
 	ieee80211_tx_skb(sdata, skb);
 }
 
+void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
+			     struct tid_ampdu_tx *tid_tx)
+{
+	lockdep_assert_held(&sta->ampdu_mlme.mtx);
+	lockdep_assert_held(&sta->lock);
+	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
+}
+
 static void kfree_tid_tx(struct rcu_head *rcu_head)
 {
 	struct tid_ampdu_tx *tid_tx =
@@ -161,7 +169,7 @@ int ___ieee80211_stop_tx_ba_session(stru
 
 	if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/* not even started yet! */
-		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
+		ieee80211_assign_tid_tx(sta, tid, NULL);
 		spin_unlock_bh(&sta->lock);
 		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
 		return 0;
@@ -318,7 +326,7 @@ void ieee80211_tx_ba_session_handle_star
 					" tid %d\n", tid);
 #endif
 		spin_lock_bh(&sta->lock);
-		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
+		ieee80211_assign_tid_tx(sta, tid, NULL);
 		spin_unlock_bh(&sta->lock);
 
 		ieee80211_wake_queue_agg(local, tid);
@@ -398,7 +406,7 @@ int ieee80211_start_tx_ba_session(struct
 
 	tid_tx = sta->ampdu_mlme.tid_tx[tid];
 	/* check if the TID is not in aggregation flow already */
-	if (tid_tx) {
+	if (tid_tx || sta->ampdu_mlme.tid_start_tx[tid]) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - session is not "
 				 "idle on tid %u\n", tid);
@@ -433,8 +441,11 @@ int ieee80211_start_tx_ba_session(struct
 	sta->ampdu_mlme.dialog_token_allocator++;
 	tid_tx->dialog_token = sta->ampdu_mlme.dialog_token_allocator;
 
-	/* finally, assign it to the array */
-	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
+	/*
+	 * Finally, assign it to the start array; the work item will
+	 * collect it and move it to the normal array.
+	 */
+	sta->ampdu_mlme.tid_start_tx[tid] = tid_tx;
 
 	ieee80211_queue_work(&local->hw, &sta->ampdu_mlme.work);
 
@@ -697,7 +708,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	ieee80211_agg_splice_packets(local, tid_tx, tid);
 
 	/* future packets must not find the tid_tx struct any more */
-	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
+	ieee80211_assign_tid_tx(sta, tid, NULL);
 
 	ieee80211_agg_splice_finish(local, tid);
 
--- a/net/mac80211/sta_info.h	2011-05-13 13:34:49.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-05-13 13:34:50.000000000 +0200
@@ -152,6 +152,7 @@ struct tid_ampdu_rx {
  *
  * @tid_rx: aggregation info for Rx per TID -- RCU protected
  * @tid_tx: aggregation info for Tx per TID
+ * @tid_start_tx: sessions where start was requested
  * @addba_req_num: number of times addBA request has been sent.
  * @dialog_token_allocator: dialog token enumerator for each new session;
  * @work: work struct for starting/stopping aggregation
@@ -168,6 +169,7 @@ struct sta_ampdu_mlme {
 	/* tx */
 	struct work_struct work;
 	struct tid_ampdu_tx *tid_tx[STA_TID_NUM];
+	struct tid_ampdu_tx *tid_start_tx[STA_TID_NUM];
 	u8 addba_req_num[STA_TID_NUM];
 	u8 dialog_token_allocator;
 };
@@ -398,6 +400,8 @@ static inline u32 get_sta_flags(struct s
 	return ret;
 }
 
+void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
+			     struct tid_ampdu_tx *tid_tx);
 
 
 #define STA_HASH_SIZE 256
--- a/net/mac80211/ht.c	2011-05-13 13:34:49.000000000 +0200
+++ b/net/mac80211/ht.c	2011-05-13 13:34:59.000000000 +0200
@@ -140,14 +140,29 @@ void ieee80211_ba_session_work(struct wo
 				sta, tid, WLAN_BACK_RECIPIENT,
 				WLAN_REASON_QSTA_TIMEOUT, true);
 
-		tid_tx = sta->ampdu_mlme.tid_tx[tid];
-		if (!tid_tx)
-			continue;
+		tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
+		if (tid_tx) {
+			/*
+			 * Assign it over to the normal tid_tx array
+			 * where it "goes live".
+			 */
+			spin_lock_bh(&sta->lock);
+
+			sta->ampdu_mlme.tid_start_tx[tid] = NULL;
+			/* could there be a race? */
+			if (sta->ampdu_mlme.tid_tx[tid])
+				kfree(tid_tx);
+			else
+				ieee80211_assign_tid_tx(sta, tid, tid_tx);
+			spin_unlock_bh(&sta->lock);
 
-		if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state))
 			ieee80211_tx_ba_session_handle_start(sta, tid);
-		else if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
-					    &tid_tx->state))
+			continue;
+		}
+
+		tid_tx = sta->ampdu_mlme.tid_tx[tid];
+		if (tid_tx && test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
+						 &tid_tx->state))
 			___ieee80211_stop_tx_ba_session(sta, tid,
 							WLAN_BACK_INITIATOR,
 							true);


