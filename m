Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51424 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbeH2Ekv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 00:40:51 -0400
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [RFC v2 1/2] mac80211: make airtime txq list per ac
Date: Tue, 28 Aug 2018 17:46:33 -0700
Message-Id: <1535503594-32051-1-git-send-email-rmanohar@codeaurora.org> (sfid-20180829_024641_614747_6049BA08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

txqs of all access categories are maintained in single list
and in uneven order. To fetch a specific AC's txq from the list,
lookup might have to traverse the entire list in worst case.
To speedup txq lookup, txq list are maintained per each AC.

Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/main.c        |  3 ++-
 net/mac80211/tx.c          | 32 ++++++++++++++++++++++----------
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c1f8b9f6128d..2fc7a86b75a5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1130,7 +1130,7 @@ struct ieee80211_local {
 
 	/* protects active_txqs and txqi->schedule_order */
 	spinlock_t active_txq_lock;
-	struct list_head active_txqs;
+	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_seqno;
 
 	u16 airtime_flags;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e65c2abb2a54..43e097c0042b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -634,7 +634,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
-	INIT_LIST_HEAD(&local->active_txqs);
+	for (i = 0; i < IEEE80211_NUM_ACS; i++)
+		INIT_LIST_HEAD(&local->active_txqs[i]);
 	spin_lock_init(&local->active_txq_lock);
 	local->airtime_flags = AIRTIME_USE_TX | AIRTIME_USE_RX;
 	local->airtime_quantum = IEEE80211_DEFAULT_AIRTIME_QUANTUM;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bc24905fbd50..d41aa62ba332 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3600,10 +3600,11 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 		if (wiphy_ext_feature_isset(local->hw.wiphy,
 					    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS)
 		    && txqi->txq.sta)
-			list_add(&txqi->schedule_order, &local->active_txqs);
+			list_add(&txqi->schedule_order,
+				 &local->active_txqs[txq->ac]);
 		else
 			list_add_tail(&txqi->schedule_order,
-				      &local->active_txqs);
+				      &local->active_txqs[txq->ac]);
 
 		if (reset_seqno)
 			txqi->schedule_seqno = local->schedule_seqno - 1;
@@ -3616,15 +3617,26 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_schedule_txq);
 
-static inline struct txq_info *find_txqi(struct list_head *head, s8 ac)
+static inline struct txq_info *find_txqi(struct ieee80211_local *local, s8 ac)
 {
-	struct txq_info *txqi;
+	struct txq_info *txqi = NULL;
+	int i;
 
-	list_for_each_entry(txqi, head, schedule_order) {
-		if (ac < 0 || txqi->txq.ac == ac)
-			return txqi;
+	if (ac >= 0 && ac < IEEE80211_NUM_ACS) {
+		txqi = list_first_entry_or_null(&local->active_txqs[ac],
+						struct txq_info,
+						schedule_order);
+	} else {
+		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+			if (list_empty(&local->active_txqs[i]))
+				continue;
+			txqi = list_first_entry(&local->active_txqs[i],
+						struct txq_info,
+						schedule_order);
+		}
 	}
-	return NULL;
+
+	return txqi;
 }
 
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
@@ -3639,7 +3651,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 		local->schedule_seqno++;
 
 begin:
-	txqi = find_txqi(&local->active_txqs, ac);
+	txqi = find_txqi(local, ac);
 	if (!txqi)
 		goto out;
 
@@ -3651,7 +3663,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
 			sta->airtime.deficit[txqi->txq.ac] +=
 				local->airtime_quantum * sta->airtime.weight;
 			list_move_tail(&txqi->schedule_order,
-				       &local->active_txqs);
+				       &local->active_txqs[txqi->txq.ac]);
 			goto begin;
 		}
 	}
-- 
1.9.1
