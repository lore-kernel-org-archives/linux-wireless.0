Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab2GRSnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 14:43:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 4/6] mac80211: split aggregation stop by reason
Date: Wed, 18 Jul 2012 20:43:18 +0200
Message-Id: <1342637000-5270-5-git-send-email-johannes@sipsolutions.net> (sfid-20120718_204331_639937_196BFE86)
In-Reply-To: <1342637000-5270-1-git-send-email-johannes@sipsolutions.net>
References: <1342637000-5270-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The initiator/tx doesn't really identify why an
aggregation session is stopped, give a reason
for stopping that more clearly identifies what's
going on. This will help tell the driver clearly
what is expected of it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      |   17 ++++++++---------
 net/mac80211/ht.c          |   15 ++++++++-------
 net/mac80211/ieee80211_i.h |    9 ++++-----
 net/mac80211/mlme.c        |    2 +-
 net/mac80211/pm.c          |    3 ++-
 net/mac80211/sta_info.c    |    2 +-
 net/mac80211/sta_info.h    |    7 +++++++
 net/mac80211/util.c        |    3 ++-
 8 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 3195a63..34d318e 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -150,8 +150,7 @@ void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 }
 
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				    enum ieee80211_back_parties initiator,
-				    bool tx)
+				    enum ieee80211_agg_stop_reason reason)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_tx *tid_tx;
@@ -212,8 +211,10 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	 */
 	synchronize_net();
 
-	tid_tx->stop_initiator = initiator;
-	tid_tx->tx_stop = tx;
+	tid_tx->stop_initiator = reason == AGG_STOP_PEER_REQUEST ?
+					WLAN_BACK_RECIPIENT :
+					WLAN_BACK_INITIATOR;
+	tid_tx->tx_stop = reason == AGG_STOP_LOCAL_REQUEST;
 
 	ret = drv_ampdu_action(local, sta->sdata,
 			       IEEE80211_AMPDU_TX_STOP,
@@ -660,14 +661,13 @@ void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				   enum ieee80211_back_parties initiator,
-				   bool tx)
+				   enum ieee80211_agg_stop_reason reason)
 {
 	int ret;
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
-	ret = ___ieee80211_stop_tx_ba_session(sta, tid, initiator, tx);
+	ret = ___ieee80211_stop_tx_ba_session(sta, tid, reason);
 
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 
@@ -868,8 +868,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 		}
 
 	} else {
-		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR,
-						false);
+		___ieee80211_stop_tx_ba_session(sta, tid, AGG_STOP_DECLINED);
 	}
 
  out:
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 4b4538d..8fda036 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -179,16 +179,19 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	ieee80211_apply_htcap_overrides(sdata, ht_cap);
 }
 
-void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx)
+void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
+					 enum ieee80211_agg_stop_reason reason)
 {
 	int i;
 
 	cancel_work_sync(&sta->ampdu_mlme.work);
 
 	for (i = 0; i <  STA_TID_NUM; i++) {
-		__ieee80211_stop_tx_ba_session(sta, i, WLAN_BACK_INITIATOR, tx);
+		__ieee80211_stop_tx_ba_session(sta, i, reason);
 		__ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
-					       WLAN_REASON_QSTA_LEAVE_QBSS, tx);
+					       WLAN_REASON_QSTA_LEAVE_QBSS,
+					       reason != AGG_STOP_DESTROY_STA &&
+					       reason != AGG_STOP_PEER_REQUEST);
 	}
 }
 
@@ -245,8 +248,7 @@ void ieee80211_ba_session_work(struct work_struct *work)
 		if (tid_tx && test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
 						 &tid_tx->state))
 			___ieee80211_stop_tx_ba_session(sta, tid,
-							WLAN_BACK_INITIATOR,
-							true);
+							AGG_STOP_LOCAL_REQUEST);
 	}
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
@@ -314,8 +316,7 @@ void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0,
 					       true);
 	else
-		__ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
-					       true);
+		__ieee80211_stop_tx_ba_session(sta, tid, AGG_STOP_PEER_REQUEST);
 }
 
 int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2ba0af4..83c6d75 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1328,7 +1328,8 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     u16 initiator, u16 reason, bool stop);
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				    u16 initiator, u16 reason, bool stop);
-void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx);
+void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
+					 enum ieee80211_agg_stop_reason reason);
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta,
 			     struct ieee80211_mgmt *mgmt, size_t len);
@@ -1342,11 +1343,9 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 				     size_t len);
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				   enum ieee80211_back_parties initiator,
-				   bool tx);
+				   enum ieee80211_agg_stop_reason reason);
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				    enum ieee80211_back_parties initiator,
-				    bool tx);
+				    enum ieee80211_agg_stop_reason reason);
 void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
 void ieee80211_ba_session_work(struct work_struct *work);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 42b2a06..af1c5c3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1363,7 +1363,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	sta = sta_info_get(sdata, bssid);
 	if (sta) {
 		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-		ieee80211_sta_tear_down_BA_sessions(sta, false);
+		ieee80211_sta_tear_down_BA_sessions(sta, AGG_STOP_DESTROY_STA);
 	}
 	mutex_unlock(&local->sta_mtx);
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 5c572e7..6a155dc 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -43,7 +43,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		mutex_lock(&local->sta_mtx);
 		list_for_each_entry(sta, &local->sta_list, list) {
 			set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-			ieee80211_sta_tear_down_BA_sessions(sta, true);
+			ieee80211_sta_tear_down_BA_sessions(
+					sta, AGG_STOP_LOCAL_REQUEST);
 		}
 		mutex_unlock(&local->sta_mtx);
 	}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 97d82f4..7fdd663 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -674,7 +674,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	 * will be sufficient.
 	 */
 	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-	ieee80211_sta_tear_down_BA_sessions(sta, false);
+	ieee80211_sta_tear_down_BA_sessions(sta, AGG_STOP_DESTROY_STA);
 
 	ret = sta_info_hash_del(local, sta);
 	if (ret)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a470e11..a62c241 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -93,6 +93,13 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_WANT_START		4
 #define HT_AGG_STATE_WANT_STOP		5
 
+enum ieee80211_agg_stop_reason {
+	AGG_STOP_DECLINED,
+	AGG_STOP_LOCAL_REQUEST,
+	AGG_STOP_PEER_REQUEST,
+	AGG_STOP_DESTROY_STA,
+};
+
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).
  *
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9fbc431..d4f4a9f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1462,7 +1462,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_lock(&local->sta_mtx);
 
 		list_for_each_entry(sta, &local->sta_list, list) {
-			ieee80211_sta_tear_down_BA_sessions(sta, true);
+			ieee80211_sta_tear_down_BA_sessions(
+					sta, AGG_STOP_LOCAL_REQUEST);
 			clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		}
 
-- 
1.7.10.4

