Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51690 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730203AbeHNB6N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 21:58:13 -0400
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [RFC 3/3] mac80211: add ieee80211_reorder_txq
Date: Mon, 13 Aug 2018 16:13:31 -0700
Message-Id: <1534202011-13101-4-git-send-email-rmanohar@codeaurora.org> (sfid-20180814_011423_630910_2806B67D)
In-Reply-To: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org>
References: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the driver to refill airtime fairness deficit
where the driver will not access txqs by ieee80211_next_txq.
In tx push mode data path, high priority txqs will be scheduled
for data transmission by ieee80211_next_txq and driver will not
prioritize txqs whereas in push-pull mode, the drivers can
prioritize txqs and access them directly. In such mode, airtime
deficit can not filled by ieee80211_next_txq.

Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 include/net/mac80211.h | 15 +++++++++++++
 net/mac80211/tx.c      | 59 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cc16847bd52d..a2f0b6800100 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6033,6 +6033,21 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac);
 
 /**
+ * ieee80211_reorder_txq - change txq position in scheduling loop
+ *
+ * This function is used to reorder txq's position in scheduling loop.
+ * The txq fairness deficit will be refilled. The drivers calling this
+ * function should ensure the txq won't be accessed by ieee80211_next_txq
+ * in the same path.
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ */
+void ieee80211_reorder_txq(struct ieee80211_hw *hw,
+			   struct ieee80211_txq *txq);
+
+/**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
  * The values are not guaranteed to be coherent with regard to each other, i.e.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0af35c08e0d9..b7b2f93152f8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3634,10 +3634,38 @@ static inline struct txq_info *find_txqi(struct ieee80211_local *local, s8 ac)
 	return txqi;
 }
 
+static bool ieee80211_txq_refill_deficit(struct ieee80211_local *local,
+					 struct txq_info *txqi)
+{
+	struct fq *fq = &local->fq;
+	struct sta_info *sta;
+
+	lockdep_assert_held(&local->active_txq_lock);
+
+	if (!txqi->txq.sta)
+		return false;
+
+	sta = container_of(txqi->txq.sta, struct sta_info, sta);
+
+	if (sta->airtime.deficit[txqi->txq.ac] > 0)
+		return false;
+
+	sta->airtime.deficit[txqi->txq.ac] +=
+		IEEE80211_AIRTIME_QUANTUM * sta->airtime.weight;
+	list_move_tail(&txqi->schedule_order,
+		       &local->active_txqs[txqi->txq.ac]);
+
+	if (sta->airtime.deficit[txqi->txq.ac] > 0) {
+		spin_lock_bh(&fq->lock);
+		clear_bit(IEEE80211_TXQ_PAUSE, &txqi->flags);
+		spin_unlock_bh(&fq->lock);
+	}
+	return true;
+}
+
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct fq *fq = &local->fq;
 	struct txq_info *txqi = NULL;
 
 	spin_lock_bh(&local->active_txq_lock);
@@ -3647,22 +3675,8 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac)
 	if (!txqi)
 		goto out;
 
-	if (txqi->txq.sta) {
-		struct sta_info *sta = container_of(txqi->txq.sta,
-						struct sta_info, sta);
-
-		if (sta->airtime.deficit[txqi->txq.ac] < 0) {
-			sta->airtime.deficit[txqi->txq.ac] += IEEE80211_AIRTIME_QUANTUM * sta->airtime.weight;
-			list_move_tail(&txqi->schedule_order,
-				       &local->active_txqs[txqi->txq.ac]);
-			if (sta->airtime.deficit[txqi->txq.ac] > 0) {
-				spin_lock_bh(&fq->lock);
-				clear_bit(IEEE80211_TXQ_PAUSE, &txqi->flags);
-				spin_unlock_bh(&fq->lock);
-			}
-			goto begin;
-		}
-	}
+	if (ieee80211_txq_refill_deficit(local, txqi))
+		goto begin;
 
 	list_del_init(&txqi->schedule_order);
 
@@ -3676,6 +3690,17 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac)
 }
 EXPORT_SYMBOL(ieee80211_next_txq);
 
+void ieee80211_reorder_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = to_txq_info(txq);
+
+	spin_lock_bh(&local->active_txq_lock);
+	ieee80211_txq_refill_deficit(local, txqi);
+	spin_unlock_bh(&local->active_txq_lock);
+}
+EXPORT_SYMBOL(ieee80211_reorder_txq);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)
-- 
1.9.1
