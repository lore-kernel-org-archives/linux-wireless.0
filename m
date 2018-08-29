Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbeH2Ekx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 00:40:53 -0400
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [RFC v2 2/2] mac80211: manage txq transmission based on airtime deficit
Date: Tue, 28 Aug 2018 17:46:34 -0700
Message-Id: <1535503594-32051-2-git-send-email-rmanohar@codeaurora.org> (sfid-20180829_024642_719105_C53FE47B)
In-Reply-To: <1535503594-32051-1-git-send-email-rmanohar@codeaurora.org>
References: <1535503594-32051-1-git-send-email-rmanohar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once a txq is selected for transmission by next_txq(), all data from
txq are dequeued by driver till hardware descriptors are drained.
i.e the driver is still allowed to dequeue frames from txq even when
its fairness deficit goes negative during transmission. This breaks
fairness and also cause inefficient fq-codel in mac80211 when data
queues are maintained in driver/firmware. To address this problem,
pause txq transmission immediately upon driver airtime report.

This change also introduces an API (ieee80211_txq_can_transmit) that
verifies that given txq is allowed for transmission. The drivers use
this API while accessing txqs directly instead of next_txq().

Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 include/net/mac80211.h     | 15 ++++++++++
 net/mac80211/debugfs_sta.c |  7 +++--
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/sta_info.c    |  7 +++++
 net/mac80211/tx.c          | 74 ++++++++++++++++++++++++++++++++++++++--------
 5 files changed, 89 insertions(+), 15 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 17759d55b7d4..5d4709c57652 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6049,6 +6049,21 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 					 bool inc_seqno);
 
 /**
+ * ieee80211_txq_can_transmit - check whether txq is paused due to deficit
+ *
+ * This function is used to check whether given txq is allowed for trasnmission
+ * or paused due to insufficient fairness deficit. Allows txq only if it is head
+ * node in scheduling loop and have sufficient deficit. Otherwise deficit is
+ * refilled and txq will be moved to tail of scheduling list.
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ */
+bool ieee80211_txq_can_transmit(struct ieee80211_hw *hw,
+				struct ieee80211_txq *txq);
+
+/**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
  * The values are not guaranteed to be coherent with regard to each other, i.e.
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index de4067bc11cd..2d8c83bfd812 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -178,9 +178,10 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 			       txqi->tin.tx_bytes,
 			       txqi->tin.tx_packets,
 			       txqi->flags,
-			       txqi->flags & (1<<IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
-			       txqi->flags & (1<<IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
-			       txqi->flags & (1<<IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : "");
+			       txqi->flags & (1 << IEEE80211_TXQ_STOP) ? "STOP" :
+			       txqi->flags & (1 << IEEE80211_TXQ_PAUSE) ? "PAUSE": "RUN",
+			       txqi->flags & (1 << IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
+			       txqi->flags & (1 << IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : "");
 	}
 
 	rcu_read_unlock();
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2fc7a86b75a5..fbddd55c9c1e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -818,6 +818,7 @@ enum txq_info_flags {
 	IEEE80211_TXQ_STOP,
 	IEEE80211_TXQ_AMPDU,
 	IEEE80211_TXQ_NO_AMSDU,
+	IEEE80211_TXQ_PAUSE,
 };
 
 /**
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f88f02df9e3a..c77c26b4aafa 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1832,6 +1832,7 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_local *local = sta->sdata->local;
+	struct txq_info *txqi;
 	u8 ac = ieee80211_ac_from_tid(tid);
 	u32 airtime = 0;
 
@@ -1844,6 +1845,12 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
 	sta->airtime.tx_airtime += tx_airtime;
 	sta->airtime.rx_airtime += rx_airtime;
 	sta->airtime.deficit[ac] -= airtime;
+
+	if (sta->airtime.deficit[ac] < 0) {
+		txqi = to_txq_info(pubsta->txq[tid]);
+		set_bit(IEEE80211_TXQ_PAUSE, &txqi->flags);
+		list_add_tail(&txqi->schedule_order, &local->active_txqs[ac]);
+	}
 	spin_unlock_bh(&local->active_txq_lock);
 }
 EXPORT_SYMBOL(ieee80211_sta_register_airtime);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d41aa62ba332..0a00b029da25 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1438,6 +1438,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	codel_stats_init(&txqi->cstats);
 	__skb_queue_head_init(&txqi->frags);
 	INIT_LIST_HEAD(&txqi->schedule_order);
+	txqi->flags = 0;
 
 	txqi->txq.vif = &sdata->vif;
 
@@ -1461,6 +1462,7 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 
 	fq_tin_reset(fq, tin, fq_skb_free_func);
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+	txqi->flags = 0;
 	spin_lock_bh(&local->active_txq_lock);
 	list_del_init(&txqi->schedule_order);
 	spin_unlock_bh(&local->active_txq_lock);
@@ -3639,6 +3641,31 @@ static inline struct txq_info *find_txqi(struct ieee80211_local *local, s8 ac)
 	return txqi;
 }
 
+static bool ieee80211_txq_requeued(struct ieee80211_local *local,
+				   struct txq_info *txqi)
+{
+	struct sta_info *sta;
+
+	lockdep_assert_held(&local->active_txq_lock);
+
+	if (!txqi->txq.sta)
+		return false;
+
+	sta = container_of(txqi->txq.sta, struct sta_info, sta);
+
+	if (sta->airtime.deficit[txqi->txq.ac] > 0) {
+		clear_bit(IEEE80211_TXQ_PAUSE, &txqi->flags);
+		return false;
+	}
+
+	sta->airtime.deficit[txqi->txq.ac] +=
+		local->airtime_quantum * sta->airtime.weight;
+	list_move_tail(&txqi->schedule_order,
+		       &local->active_txqs[txqi->txq.ac]);
+
+	return true;
+}
+
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 					 bool inc_seqno)
 {
@@ -3655,18 +3682,8 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 	if (!txqi)
 		goto out;
 
-	if (txqi->txq.sta) {
-		struct sta_info *sta = container_of(txqi->txq.sta,
-						struct sta_info, sta);
-
-		if (sta->airtime.deficit[txqi->txq.ac] < 0) {
-			sta->airtime.deficit[txqi->txq.ac] +=
-				local->airtime_quantum * sta->airtime.weight;
-			list_move_tail(&txqi->schedule_order,
-				       &local->active_txqs[txqi->txq.ac]);
-			goto begin;
-		}
-	}
+	if (ieee80211_txq_requeued(local, txqi))
+		goto begin;
 
 	/* If seqnos are equal, we've seen this txqi before in this scheduling
 	 * round, so abort.
@@ -3687,6 +3704,39 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 }
 EXPORT_SYMBOL(ieee80211_next_txq);
 
+bool ieee80211_txq_can_transmit(struct ieee80211_hw *hw,
+				struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi, *f_txqi;
+	bool can_tx;
+
+	txqi = to_txq_info(txq);
+	/* Check whether txq is paused or not */
+	if (test_bit(IEEE80211_TXQ_PAUSE, &txqi->flags))
+		return false;
+
+	can_tx = false;
+	spin_lock_bh(&local->active_txq_lock);
+	f_txqi = find_txqi(local, txq->ac);
+	if (!f_txqi)
+		goto out;
+
+	/* Allow only head node to ensure fairness */
+	if (f_txqi != txqi)
+		goto out;
+
+	/* Check if txq is in negative deficit */
+	if (!ieee80211_txq_requeued(local, txqi))
+		can_tx = true;
+
+	list_del_init(&txqi->schedule_order);
+out:
+	spin_unlock_bh(&local->active_txq_lock);
+	return can_tx;
+}
+EXPORT_SYMBOL(ieee80211_txq_can_transmit);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)
-- 
1.9.1
