Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55528 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935058AbdJRMK6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 08:10:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: avoid looking up tid_tx/tid_rx from timers
Date: Wed, 18 Oct 2017 14:10:56 +0200
Message-Id: <20171018121056.28216-1-johannes@sipsolutions.net> (sfid-20171018_141128_747094_1A888260)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to re-lookup the data structures now that
we actually get them immediately with from_timer(), just
avoid that. The struct has to be valid anyway, otherwise
the timer object itself would no longer be valid, and we
can't have a different version of the struct since only a
single session per TID is permitted.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c | 17 +++--------------
 net/mac80211/agg-tx.c | 31 ++++++++-----------------------
 2 files changed, 11 insertions(+), 37 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index d444752dbf40..35e94483fb8c 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -153,27 +153,16 @@ EXPORT_SYMBOL(ieee80211_stop_rx_ba_session);
  */
 static void sta_rx_agg_session_timer_expired(struct timer_list *t)
 {
-	struct tid_ampdu_rx *tid_rx_timer =
-		from_timer(tid_rx_timer, t, session_timer);
-	struct sta_info *sta = tid_rx_timer->sta;
-	u8 tid = tid_rx_timer->tid;
-	struct tid_ampdu_rx *tid_rx;
+	struct tid_ampdu_rx *tid_rx = from_timer(tid_rx, t, session_timer);
+	struct sta_info *sta = tid_rx->sta;
+	u8 tid = tid_rx->tid;
 	unsigned long timeout;
 
-	rcu_read_lock();
-	tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
-	if (!tid_rx) {
-		rcu_read_unlock();
-		return;
-	}
-
 	timeout = tid_rx->last_rx + TU_TO_JIFFIES(tid_rx->timeout);
 	if (time_is_after_jiffies(timeout)) {
 		mod_timer(&tid_rx->session_timer, timeout);
-		rcu_read_unlock();
 		return;
 	}
-	rcu_read_unlock();
 
 	ht_dbg(sta->sdata, "RX session timer expired on %pM tid %d\n",
 	       sta->sta.addr, tid);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 3680b380e70c..1d0bf857a3b5 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -424,18 +424,12 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
  */
 static void sta_addba_resp_timer_expired(struct timer_list *t)
 {
-	struct tid_ampdu_tx *tid_tx_timer =
-		from_timer(tid_tx_timer, t, addba_resp_timer);
-	struct sta_info *sta = tid_tx_timer->sta;
-	u8 tid = tid_tx_timer->tid;
-	struct tid_ampdu_tx *tid_tx;
+	struct tid_ampdu_tx *tid_tx = from_timer(tid_tx, t, addba_resp_timer);
+	struct sta_info *sta = tid_tx->sta;
+	u8 tid = tid_tx->tid;
 
 	/* check if the TID waits for addBA response */
-	rcu_read_lock();
-	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
-	if (!tid_tx ||
-	    test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state)) {
-		rcu_read_unlock();
+	if (test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state)) {
 		ht_dbg(sta->sdata,
 		       "timer expired on %pM tid %d not expecting addBA response\n",
 		       sta->sta.addr, tid);
@@ -446,7 +440,6 @@ static void sta_addba_resp_timer_expired(struct timer_list *t)
 	       sta->sta.addr, tid);
 
 	ieee80211_stop_tx_ba_session(&sta->sta, tid);
-	rcu_read_unlock();
 }
 
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
@@ -524,29 +517,21 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
  */
 static void sta_tx_agg_session_timer_expired(struct timer_list *t)
 {
-	struct tid_ampdu_tx *tid_tx_timer =
-		from_timer(tid_tx_timer, t, session_timer);
-	struct sta_info *sta = tid_tx_timer->sta;
-	u8 tid = tid_tx_timer->tid;
-	struct tid_ampdu_tx *tid_tx;
+	struct tid_ampdu_tx *tid_tx = from_timer(tid_tx, t, session_timer);
+	struct sta_info *sta = tid_tx->sta;
+	u8 tid = tid_tx->tid;
 	unsigned long timeout;
 
-	rcu_read_lock();
-	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
-	if (!tid_tx || test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
-		rcu_read_unlock();
+	if (test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
 		return;
 	}
 
 	timeout = tid_tx->last_tx + TU_TO_JIFFIES(tid_tx->timeout);
 	if (time_is_after_jiffies(timeout)) {
 		mod_timer(&tid_tx->session_timer, timeout);
-		rcu_read_unlock();
 		return;
 	}
 
-	rcu_read_unlock();
-
 	ht_dbg(sta->sdata, "tx session timer expired on %pM tid %d\n",
 	       sta->sta.addr, tid);
 
-- 
2.14.2
