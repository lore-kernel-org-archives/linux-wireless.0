Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53234 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751366AbdIFNTW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 09:19:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Matteo Croce <mcroce@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix deadlock in driver-managed RX BA session start
Date: Wed,  6 Sep 2017 15:19:17 +0200
Message-Id: <20170906131917.21090-1-johannes@sipsolutions.net> (sfid-20170906_151925_365125_28F4ED16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an RX BA session is started by the driver, and it has to tell
mac80211 about it, the corresponding bit in tid_rx_manage_offl gets
set and the BA session work is scheduled. Upon testing this bit, it
will call __ieee80211_start_rx_ba_session(), thus deadlocking as it
already holds the ampdu_mlme.mtx, which that acquires again.

Fix this by adding ___ieee80211_start_rx_ba_session(), a version of
the function that requires the mutex already held.

Cc: stable@vger.kernel.org
Fixes: 699cb58c8a52 ("mac80211: manage RX BA session offload without SKB queue")
Reported-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c      | 32 +++++++++++++++++++++-----------
 net/mac80211/ht.c          |  6 +++---
 net/mac80211/ieee80211_i.h |  4 ++++
 3 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 2b36eff5d97e..2849a1fc41c5 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -245,10 +245,10 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void __ieee80211_start_rx_ba_session(struct sta_info *sta,
-				     u8 dialog_token, u16 timeout,
-				     u16 start_seq_num, u16 ba_policy, u16 tid,
-				     u16 buf_size, bool tx, bool auto_seq)
+void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
+				      u8 dialog_token, u16 timeout,
+				      u16 start_seq_num, u16 ba_policy, u16 tid,
+				      u16 buf_size, bool tx, bool auto_seq)
 {
 	struct ieee80211_local *local = sta->sdata->local;
 	struct tid_ampdu_rx *tid_agg_rx;
@@ -267,7 +267,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		ht_dbg(sta->sdata,
 		       "STA %pM requests BA session on unsupported tid %d\n",
 		       sta->sta.addr, tid);
-		goto end_no_lock;
+		goto end;
 	}
 
 	if (!sta->sta.ht_cap.ht_supported) {
@@ -275,14 +275,14 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		       "STA %pM erroneously requests BA session on tid %d w/o QoS\n",
 		       sta->sta.addr, tid);
 		/* send a response anyway, it's an error case if we get here */
-		goto end_no_lock;
+		goto end;
 	}
 
 	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
 		ht_dbg(sta->sdata,
 		       "Suspend in progress - Denying ADDBA request (%pM tid %d)\n",
 		       sta->sta.addr, tid);
-		goto end_no_lock;
+		goto end;
 	}
 
 	/* sanity check for incoming parameters:
@@ -296,7 +296,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		ht_dbg_ratelimited(sta->sdata,
 				   "AddBA Req with bad params from %pM on tid %u. policy %d, buffer size %d\n",
 				   sta->sta.addr, tid, ba_policy, buf_size);
-		goto end_no_lock;
+		goto end;
 	}
 	/* determine default buffer size */
 	if (buf_size == 0)
@@ -311,7 +311,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	       buf_size, sta->sta.addr);
 
 	/* examine state machine */
-	mutex_lock(&sta->ampdu_mlme.mtx);
+	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
 	if (test_bit(tid, sta->ampdu_mlme.agg_session_valid)) {
 		if (sta->ampdu_mlme.tid_rx_token[tid] == dialog_token) {
@@ -415,15 +415,25 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		__clear_bit(tid, sta->ampdu_mlme.unexpected_agg);
 		sta->ampdu_mlme.tid_rx_token[tid] = dialog_token;
 	}
-	mutex_unlock(&sta->ampdu_mlme.mtx);
 
-end_no_lock:
 	if (tx)
 		ieee80211_send_addba_resp(sta->sdata, sta->sta.addr, tid,
 					  dialog_token, status, 1, buf_size,
 					  timeout);
 }
 
+void __ieee80211_start_rx_ba_session(struct sta_info *sta,
+				     u8 dialog_token, u16 timeout,
+				     u16 start_seq_num, u16 ba_policy, u16 tid,
+				     u16 buf_size, bool tx, bool auto_seq)
+{
+	mutex_lock(&sta->ampdu_mlme.mtx);
+	___ieee80211_start_rx_ba_session(sta, dialog_token, timeout,
+					 start_seq_num, ba_policy, tid,
+					 buf_size, tx, auto_seq);
+	mutex_unlock(&sta->ampdu_mlme.mtx);
+}
+
 void ieee80211_process_addba_request(struct ieee80211_local *local,
 				     struct sta_info *sta,
 				     struct ieee80211_mgmt *mgmt,
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c92df492e898..198b2d3e56fd 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -333,9 +333,9 @@ void ieee80211_ba_session_work(struct work_struct *work)
 
 		if (test_and_clear_bit(tid,
 				       sta->ampdu_mlme.tid_rx_manage_offl))
-			__ieee80211_start_rx_ba_session(sta, 0, 0, 0, 1, tid,
-							IEEE80211_MAX_AMPDU_BUF,
-							false, true);
+			___ieee80211_start_rx_ba_session(sta, 0, 0, 0, 1, tid,
+							 IEEE80211_MAX_AMPDU_BUF,
+							 false, true);
 
 		if (test_and_clear_bit(tid + IEEE80211_NUM_TIDS,
 				       sta->ampdu_mlme.tid_rx_manage_offl))
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2197c62a0a6e..9675814f64db 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1760,6 +1760,10 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 				     u8 dialog_token, u16 timeout,
 				     u16 start_seq_num, u16 ba_policy, u16 tid,
 				     u16 buf_size, bool tx, bool auto_seq);
+void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
+				      u8 dialog_token, u16 timeout,
+				      u16 start_seq_num, u16 ba_policy, u16 tid,
+				      u16 buf_size, bool tx, bool auto_seq);
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 					 enum ieee80211_agg_stop_reason reason);
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
-- 
2.14.1
