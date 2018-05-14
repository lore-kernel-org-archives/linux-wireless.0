Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 2.mo5.mail-out.ovh.net ([178.33.109.111]:60468 "EHLO
        2.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752372AbeENXA3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 19:00:29 -0400
Received: from player737.ha.ovh.net (unknown [10.109.120.51])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 029711ABDDA
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 22:33:57 +0200 (CEST)
From: Alexander Wetzel <alexander.wetzel@web.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Alexander Wetzel <Alexander.Wetzel@web.de>
Subject: [PATCH] mac80211: TX aggregation stop race can break TX
Date: Mon, 14 May 2018 22:33:34 +0200
Message-Id: <20180514203334.12264-1-alexander.wetzel@web.de> (sfid-20180515_010032_829694_99A83BB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 tear down code is not waiting for the driver call back.
This can bring down the the TX path (TID) till the user manually
reconnects. (Observed with iwldvm and enabled TX aggregation.)

The race can be prevented when the ampdu_mlme worker handles the tear
down.

The race:
 * ieee80211_sta_tear_down_BA_sessions calls
   ___ieee80211_stop_tx_ba_session for all TIDs,

 * then cancels the ampdu_mlme worker

 * and cleanups the TIDs the driver already has called back for.

 * ieee80211_stop_tx_ba_cb will never be called for a TID if the callback
   came after the the check in ieee80211_sta_tear_down_BA_sessions.

Signed-off-by: Alexander Wetzel <Alexander.Wetzel@web.de>
---
 net/mac80211/ht.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c78036a0ac94..073258e0cee1 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -301,26 +301,27 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 		___ieee80211_stop_tx_ba_session(sta, i, reason);
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 
-	/* stopping might queue the work again - so cancel only afterwards */
-	cancel_work_sync(&sta->ampdu_mlme.work);
-
 	/*
 	 * In case the tear down is part of a reconfigure due to HW restart
 	 * request, it is possible that the low level driver requested to stop
 	 * the BA session, so handle it to properly clean tid_tx data.
 	 */
-	mutex_lock(&sta->ampdu_mlme.mtx);
-	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
-		struct tid_ampdu_tx *tid_tx =
-			rcu_dereference_protected_tid_tx(sta, i);
+	if(reason == AGG_STOP_DESTROY_STA) {
+		cancel_work_sync(&sta->ampdu_mlme.work);
 
-		if (!tid_tx)
-			continue;
+		mutex_lock(&sta->ampdu_mlme.mtx);
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+			struct tid_ampdu_tx *tid_tx =
+				rcu_dereference_protected_tid_tx(sta, i);
 
-		if (test_and_clear_bit(HT_AGG_STATE_STOP_CB, &tid_tx->state))
-			ieee80211_stop_tx_ba_cb(sta, i, tid_tx);
+			if (!tid_tx)
+				continue;
+
+			if (test_and_clear_bit(HT_AGG_STATE_STOP_CB, &tid_tx->state))
+				ieee80211_stop_tx_ba_cb(sta, i, tid_tx);
+		}
+		mutex_unlock(&sta->ampdu_mlme.mtx);
 	}
-	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
 
 void ieee80211_ba_session_work(struct work_struct *work)
@@ -328,16 +329,12 @@ void ieee80211_ba_session_work(struct work_struct *work)
 	struct sta_info *sta =
 		container_of(work, struct sta_info, ampdu_mlme.work);
 	struct tid_ampdu_tx *tid_tx;
+	bool enabled = true;
 	int tid;
 
-	/*
-	 * When this flag is set, new sessions should be
-	 * blocked, and existing sessions will be torn
-	 * down by the code that set the flag, so this
-	 * need not run.
-	 */
+	/* When this flag is set, new sessions should be blocked. */
 	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA))
-		return;
+		enabled = false;
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
@@ -352,7 +349,8 @@ void ieee80211_ba_session_work(struct work_struct *work)
 				sta, tid, WLAN_BACK_RECIPIENT,
 				WLAN_REASON_UNSPECIFIED, true);
 
-		if (test_and_clear_bit(tid,
+		if (enabled &&
+		    test_and_clear_bit(tid,
 				       sta->ampdu_mlme.tid_rx_manage_offl))
 			___ieee80211_start_rx_ba_session(sta, 0, 0, 0, 1, tid,
 							 IEEE80211_MAX_AMPDU_BUF,
@@ -367,7 +365,7 @@ void ieee80211_ba_session_work(struct work_struct *work)
 		spin_lock_bh(&sta->lock);
 
 		tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
-		if (tid_tx) {
+		if (enabled && tid_tx) {
 			/*
 			 * Assign it over to the normal tid_tx array
 			 * where it "goes live".
@@ -390,7 +388,8 @@ void ieee80211_ba_session_work(struct work_struct *work)
 		if (!tid_tx)
 			continue;
 
-		if (test_and_clear_bit(HT_AGG_STATE_START_CB, &tid_tx->state))
+		if (enabled &&
+		    test_and_clear_bit(HT_AGG_STATE_START_CB, &tid_tx->state))
 			ieee80211_start_tx_ba_cb(sta, tid, tid_tx);
 		if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state))
 			___ieee80211_stop_tx_ba_session(sta, tid,
-- 
2.17.0
