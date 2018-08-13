Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51656 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730203AbeHNB6M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 21:58:12 -0400
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [RFC 2/3] mac80211: pause txq transmission on negative airtime deficit
Date: Mon, 13 Aug 2018 16:13:30 -0700
Message-Id: <1534202011-13101-3-git-send-email-rmanohar@codeaurora.org> (sfid-20180814_011423_037932_DCCE050C)
In-Reply-To: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org>
References: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Airtime fairness prioritizes txqs and picks high priority txq. Once
a txq is selected for transmission by next_txq(), dequeue routine is
not preventing over downloading packets. i.e the driver is still
allowed to dequeue frames from txq even when its fairness deficit
goes negative. This is also causing inefficient fq-codel of mac80211
when the driver/firmware is maintaining another set of data queues.
To address this problem, pause txq transmission when given txq's
was already served for the assigned quantum and resume the transmission
upon prioritization.

Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 net/mac80211/debugfs_sta.c | 7 ++++---
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/sta_info.c    | 9 +++++++++
 net/mac80211/tx.c          | 9 ++++++++-
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index bae0fa7ff95a..5c38994cd95c 100644
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
index 5825824cfe5b..3ef287075cb1 100644
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
index 8af9e5c05ce4..215ae3a690aa 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1830,6 +1830,8 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_local *local = sta->sdata->local;
+	struct fq *fq = &local->fq;
+	struct txq_info *txqi;
 	u8 ac = ieee80211_ac_from_tid(tid);
 	u32 airtime = 0;
 
@@ -1844,6 +1846,13 @@ void ieee80211_sta_register_airtime(struct ieee80211_sta *pubsta, u8 tid,
 	sta->airtime.deficit[ac] -= airtime;
 	if (airtime)
 		sta->local->airtime_flags |= AIRTIME_ACTIVE;
+
+	if (sta->airtime.deficit[ac] < 0) {
+		txqi = to_txq_info(pubsta->txq[tid]);
+		spin_lock_bh(&fq->lock);
+		set_bit(IEEE80211_TXQ_PAUSE, &txqi->flags);
+		spin_unlock_bh(&fq->lock);
+	}
 	spin_unlock_bh(&local->active_txq_lock);
 }
 EXPORT_SYMBOL(ieee80211_sta_register_airtime);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6a76852ba1f3..0af35c08e0d9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3475,7 +3475,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&fq->lock);
 
-	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
+	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags) ||
+	    test_bit(IEEE80211_TXQ_PAUSE, &txqi->flags))
 		goto out;
 
 	/* Make sure fragments stay together. */
@@ -3636,6 +3637,7 @@ static inline struct txq_info *find_txqi(struct ieee80211_local *local, s8 ac)
 struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct fq *fq = &local->fq;
 	struct txq_info *txqi = NULL;
 
 	spin_lock_bh(&local->active_txq_lock);
@@ -3653,6 +3655,11 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac)
 			sta->airtime.deficit[txqi->txq.ac] += IEEE80211_AIRTIME_QUANTUM * sta->airtime.weight;
 			list_move_tail(&txqi->schedule_order,
 				       &local->active_txqs[txqi->txq.ac]);
+			if (sta->airtime.deficit[txqi->txq.ac] > 0) {
+				spin_lock_bh(&fq->lock);
+				clear_bit(IEEE80211_TXQ_PAUSE, &txqi->flags);
+				spin_unlock_bh(&fq->lock);
+			}
 			goto begin;
 		}
 	}
-- 
1.9.1
