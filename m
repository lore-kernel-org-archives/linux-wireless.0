Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0K2KJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 05:09:20 -0500
Subject: [PATCH] mac80211: fix RX aggregation locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 11:09:16 +0100
Message-ID: <1291025356.3532.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The RX aggregation locking documentation was
wrong, which led Christian to also code the
timer timeout handling for it somewhat wrongly.

Fix the documentation, the two places that
need to hold the reorder lock across accesses
to the structure, and the debugfs code that
should just use RCU.

Also, remove acquiring the sta->lock across
reorder timeouts since it isn't necessary, and
change a few places to GFP_KERNEL because the
code path here doesn't need atomic allocations
as I noticed when reviewing all this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Christian, do you remember what else we needed to do here?

 net/mac80211/agg-rx.c      |    8 +++-----
 net/mac80211/debugfs_sta.c |   29 +++++++++++++++--------------
 net/mac80211/rx.c          |   17 +++++++++++++----
 net/mac80211/sta_info.h    |   29 ++++++++++++++---------------
 4 files changed, 45 insertions(+), 38 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-11-29 11:04:35.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2010-11-29 11:05:36.000000000 +0100
@@ -129,9 +129,7 @@ static void sta_rx_agg_reorder_timer_exp
 			timer_to_tid[0]);
 
 	rcu_read_lock();
-	spin_lock(&sta->lock);
 	ieee80211_release_reorder_timeout(sta, *ptid);
-	spin_unlock(&sta->lock);
 	rcu_read_unlock();
 }
 
@@ -256,7 +254,7 @@ void ieee80211_process_addba_request(str
 	}
 
 	/* prepare A-MPDU MLME for Rx aggregation */
-	tid_agg_rx = kmalloc(sizeof(struct tid_ampdu_rx), GFP_ATOMIC);
+	tid_agg_rx = kmalloc(sizeof(struct tid_ampdu_rx), GFP_KERNEL);
 	if (!tid_agg_rx) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
@@ -280,9 +278,9 @@ void ieee80211_process_addba_request(str
 
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
-		kcalloc(buf_size, sizeof(struct sk_buff *), GFP_ATOMIC);
+		kcalloc(buf_size, sizeof(struct sk_buff *), GFP_KERNEL);
 	tid_agg_rx->reorder_time =
-		kcalloc(buf_size, sizeof(unsigned long), GFP_ATOMIC);
+		kcalloc(buf_size, sizeof(unsigned long), GFP_KERNEL);
 	if (!tid_agg_rx->reorder_buf || !tid_agg_rx->reorder_time) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2010-11-23 09:02:57.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_sta.c	2010-11-29 11:05:36.000000000 +0100
@@ -112,34 +112,35 @@ static ssize_t sta_agg_status_read(struc
 	char buf[71 + STA_TID_NUM * 40], *p = buf;
 	int i;
 	struct sta_info *sta = file->private_data;
+	struct tid_ampdu_rx *tid_rx;
+	struct tid_ampdu_tx *tid_tx;
+
+	rcu_read_lock();
 
-	spin_lock_bh(&sta->lock);
 	p += scnprintf(p, sizeof(buf) + buf - p, "next dialog_token: %#02x\n",
 			sta->ampdu_mlme.dialog_token_allocator + 1);
 	p += scnprintf(p, sizeof(buf) + buf - p,
 		       "TID\t\tRX active\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
+
 	for (i = 0; i < STA_TID_NUM; i++) {
+		tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[i]);
+		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[i]);
+
 		p += scnprintf(p, sizeof(buf) + buf - p, "%02d", i);
-		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",
-				!!sta->ampdu_mlme.tid_rx[i]);
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x", !!tid_rx);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
-				sta->ampdu_mlme.tid_rx[i] ?
-				sta->ampdu_mlme.tid_rx[i]->dialog_token : 0);
+				tid_rx ? tid_rx->dialog_token : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
-				sta->ampdu_mlme.tid_rx[i] ?
-				sta->ampdu_mlme.tid_rx[i]->ssn : 0);
+				tid_rx ? tid_rx->ssn : 0);
 
-		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",
-				!!sta->ampdu_mlme.tid_tx[i]);
+		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x", !!tid_tx);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
-				sta->ampdu_mlme.tid_tx[i] ?
-				sta->ampdu_mlme.tid_tx[i]->dialog_token : 0);
+				tid_tx ? tid_tx->dialog_token : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%03d",
-				sta->ampdu_mlme.tid_tx[i] ?
-				skb_queue_len(&sta->ampdu_mlme.tid_tx[i]->pending) : 0);
+				tid_tx ? skb_queue_len(&tid_tx->pending) : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\n");
 	}
-	spin_unlock_bh(&sta->lock);
+	rcu_read_unlock();
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 }
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-11-29 11:04:35.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2010-11-29 11:05:36.000000000 +0100
@@ -81,13 +81,14 @@ enum ieee80211_sta_info_flags {
  * @stop_initiator: initiator of a session stop
  * @tx_stop: TX DelBA frame when stopping
  *
- * This structure is protected by RCU and the per-station
- * spinlock. Assignments to the array holding it must hold
- * the spinlock, only the TX path can access it under RCU
- * lock-free if, and only if, the state has  the flag
- * %HT_AGG_STATE_OPERATIONAL set. Otherwise, the TX path
- * must also acquire the spinlock and re-check the state,
- * see comments in the tx code touching it.
+ * This structure's lifetime is managed by RCU, assignments to
+ * the array holding it must hold the aggregation mutex.
+ *
+ * The TX path can access it under RCU lock-free if, and
+ * only if, the state has the flag %HT_AGG_STATE_OPERATIONAL
+ * set. Otherwise, the TX path must also acquire the spinlock
+ * and re-check the state, see comments in the tx code
+ * touching it.
  */
 struct tid_ampdu_tx {
 	struct rcu_head rcu_head;
@@ -115,15 +116,13 @@ struct tid_ampdu_tx {
  * @rcu_head: RCU head used for freeing this struct
  * @reorder_lock: serializes access to reorder buffer, see below.
  *
- * This structure is protected by RCU and the per-station
- * spinlock. Assignments to the array holding it must hold
- * the spinlock.
+ * This structure's lifetime is managed by RCU, assignments to
+ * the array holding it must hold the aggregation mutex.
  *
- * The @reorder_lock is used to protect the variables and
- * arrays such as @reorder_buf, @reorder_time, @head_seq_num,
- * @stored_mpdu_num and @reorder_time from being corrupted by
- * concurrent access of the RX path and the expired frame
- * release timer.
+ * The @reorder_lock is used to protect the members of this
+ * struct, except for @timeout, @buf_size and @dialog_token,
+ * which are constant across the lifetime of the struct (the
+ * dialog token being used only for debugging).
  */
 struct tid_ampdu_rx {
 	struct rcu_head rcu_head;
--- wireless-testing.orig/net/mac80211/rx.c	2010-11-29 11:05:32.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2010-11-29 11:05:36.000000000 +0100
@@ -538,6 +538,8 @@ static void ieee80211_release_reorder_fr
 {
 	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
 
+	lockdep_assert_held(&tid_agg_rx->reorder_lock);
+
 	if (!skb)
 		goto no_frame;
 
@@ -557,6 +559,8 @@ static void ieee80211_release_reorder_fr
 {
 	int index;
 
+	lockdep_assert_held(&tid_agg_rx->reorder_lock);
+
 	while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
 		index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
@@ -581,6 +585,8 @@ static void ieee80211_sta_reorder_releas
 {
 	int index, j;
 
+	lockdep_assert_held(&tid_agg_rx->reorder_lock);
+
 	/* release the buffer until next missing frame */
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 						tid_agg_rx->buf_size;
@@ -683,10 +689,11 @@ static bool ieee80211_sta_manage_reorder
 	int index;
 	bool ret = true;
 
+	spin_lock(&tid_agg_rx->reorder_lock);
+
 	buf_size = tid_agg_rx->buf_size;
 	head_seq_num = tid_agg_rx->head_seq_num;
 
-	spin_lock(&tid_agg_rx->reorder_lock);
 	/* frame with out of date sequence number */
 	if (seq_less(mpdu_seq_num, head_seq_num)) {
 		dev_kfree_skb(skb);
@@ -1921,9 +1928,12 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 			mod_timer(&tid_agg_rx->session_timer,
 				  TU_TO_EXP_TIME(tid_agg_rx->timeout));
 
+		spin_lock(&tid_agg_rx->reorder_lock);
 		/* release stored frames up to start of BAR */
 		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num,
 						 frames);
+		spin_unlock(&tid_agg_rx->reorder_lock);
+
 		kfree_skb(skb);
 		return RX_QUEUED;
 	}
@@ -2515,9 +2525,8 @@ static void ieee80211_invoke_rx_handlers
 }
 
 /*
- * This function makes calls into the RX path. Therefore the
- * caller must hold the sta_info->lock and everything has to
- * be under rcu_read_lock protection as well.
+ * This function makes calls into the RX path, therefore
+ * it has to be invoked under RCU read lock.
  */
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 {


