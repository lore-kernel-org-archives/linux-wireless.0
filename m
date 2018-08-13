Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51600 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730203AbeHNB6J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 21:58:09 -0400
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [RFC 1/3] mac80211: make airtime txq list per ac
Date: Mon, 13 Aug 2018 16:13:29 -0700
Message-Id: <1534202011-13101-2-git-send-email-rmanohar@codeaurora.org> (sfid-20180814_011422_462614_2BB1254A)
In-Reply-To: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org>
References: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org>
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
 net/mac80211/tx.c          | 33 +++++++++++++++++++++++----------
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bd7f074ccf16..5825824cfe5b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1129,7 +1129,7 @@ struct ieee80211_local {
 
 	/* protects active_txqs and txqi->schedule_order */
 	spinlock_t active_txq_lock;
-	struct list_head active_txqs;
+	struct list_head active_txqs[IEEE80211_NUM_ACS];
 
 	u16 airtime_flags;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index fbb0bd6183d2..771366464f18 100644
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
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8acab75a0700..6a76852ba1f3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3597,9 +3597,11 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 		 * call to ieee80211_next_txq().
 		 */
 		if ((local->airtime_flags & AIRTIME_ACTIVE) && txqi->txq.sta)
-			list_add(&txqi->schedule_order, &local->active_txqs);
+			list_add(&txqi->schedule_order,
+				 &local->active_txqs[txq->ac]);
 		else
-			list_add_tail(&txqi->schedule_order, &local->active_txqs);
+			list_add_tail(&txqi->schedule_order,
+				      &local->active_txqs[txq->ac]);
 		ret = true;
 	}
 
@@ -3609,15 +3611,26 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
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
 
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac)
@@ -3628,7 +3641,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac)
 	spin_lock_bh(&local->active_txq_lock);
 
 begin:
-	txqi = find_txqi(&local->active_txqs, ac);
+	txqi = find_txqi(local, ac);
 	if (!txqi)
 		goto out;
 
@@ -3639,7 +3652,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac)
 		if (sta->airtime.deficit[txqi->txq.ac] < 0) {
 			sta->airtime.deficit[txqi->txq.ac] += IEEE80211_AIRTIME_QUANTUM * sta->airtime.weight;
 			list_move_tail(&txqi->schedule_order,
-				       &local->active_txqs);
+				       &local->active_txqs[txqi->txq.ac]);
 			goto begin;
 		}
 	}
-- 
1.9.1
