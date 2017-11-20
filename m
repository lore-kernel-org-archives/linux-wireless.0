Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41052 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdKTQBq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 11:01:46 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: properly free requested-but-not-started TX agg sessions
Date: Mon, 20 Nov 2017 17:01:44 +0100
Message-Id: <20171120160144.20961-1-johannes@sipsolutions.net> (sfid-20171120_170205_655032_C82C5584)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When deleting a station or otherwise tearing down all aggregation
sessions, make sure to delete requested but not yet started ones,
to avoid the following scenario:

 * session is requested, added to tid_start_tx[]
 * ieee80211_ba_session_work() runs, gets past BLOCK_BA check
 * ieee80211_sta_tear_down_BA_sessions() runs, locks &sta->ampdu_mlme.mtx,
   e.g. while deleting the station - deleting all active sessions
 * ieee80211_ba_session_work() continues since tear down flushes it, and
   calls ieee80211_tx_ba_session_handle_start() for the new session, arms
   the timer for it
 * station deletion continues to __cleanup_single_sta() and frees the
   session struct, while the timer is armed

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 3680b380e70c..5f8ab5be369f 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -330,6 +330,11 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 
 	spin_lock_bh(&sta->lock);
 
+	/* free struct pending for start, if present */
+	tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
+	kfree(tid_tx);
+	sta->ampdu_mlme.tid_start_tx[tid] = NULL;
+
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 	if (!tid_tx) {
 		spin_unlock_bh(&sta->lock);
-- 
2.14.2
