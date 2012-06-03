Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63688 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab2FCU3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 16:29:09 -0400
Received: by wibhj8 with SMTP id hj8so2231889wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2012 13:29:08 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: don't call drv_ampdu_action() during reconfig
Date: Sun,  3 Jun 2012 23:29:01 +0300
Message-Id: <1338755341-13141-1-git-send-email-arik@wizery.com> (sfid-20120603_222937_990353_ADEBC923)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When tearing down BA sessions during HW reconfig, the low level driver
is not aware of them yet. Add a parameter to relevant Rx/Tx BA functions
to prevent calls to the driver, while removing all mac80211 related state.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/agg-rx.c      |   16 ++++++++++------
 net/mac80211/agg-tx.c      |   18 +++++++++++-------
 net/mac80211/debugfs_sta.c |    2 +-
 net/mac80211/ht.c          |   19 +++++++++++--------
 net/mac80211/ieee80211_i.h |   13 ++++++++-----
 net/mac80211/iface.c       |    2 +-
 net/mac80211/mlme.c        |    2 +-
 net/mac80211/pm.c          |    2 +-
 net/mac80211/sta_info.c    |    2 +-
 net/mac80211/util.c        |    3 ++-
 10 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index a070d4f..d1afa99 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -59,7 +59,8 @@ static void ieee80211_free_tid_rx(struct rcu_head *h)
 }
 
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-				     u16 initiator, u16 reason, bool tx)
+				     u16 initiator, u16 reason, bool tx,
+				     bool call_drv)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_rx *tid_rx;
@@ -82,8 +83,9 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	       (int)reason);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
-			     &sta->sta, tid, NULL, 0))
+	if (call_drv && drv_ampdu_action(local, sta->sdata,
+					 IEEE80211_AMPDU_RX_STOP,
+					 &sta->sta, tid, NULL, 0))
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
 
@@ -98,10 +100,12 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 }
 
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-				    u16 initiator, u16 reason, bool tx)
+				    u16 initiator, u16 reason, bool tx,
+				    bool call_drv)
 {
 	mutex_lock(&sta->ampdu_mlme.mtx);
-	___ieee80211_stop_rx_ba_session(sta, tid, initiator, reason, tx);
+	___ieee80211_stop_rx_ba_session(sta, tid, initiator, reason, tx,
+					call_drv);
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
 
@@ -290,7 +294,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 		/* delete existing Rx BA session on the same tid */
 		___ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
 						WLAN_STATUS_UNSPECIFIED_QOS,
-						false);
+						false, true);
 	}
 
 	/* prepare A-MPDU MLME for Rx aggregation */
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 7cf0715..daa1764 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -150,7 +150,7 @@ void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_back_parties initiator,
-				    bool tx)
+				    bool tx, bool call_drv)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_tx *tid_tx;
@@ -216,9 +216,12 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	tid_tx->stop_initiator = initiator;
 	tid_tx->tx_stop = tx;
 
-	ret = drv_ampdu_action(local, sta->sdata,
-			       IEEE80211_AMPDU_TX_STOP,
-			       &sta->sta, tid, NULL, 0);
+	if (call_drv)
+		ret = drv_ampdu_action(local, sta->sdata,
+				       IEEE80211_AMPDU_TX_STOP,
+				       &sta->sta, tid, NULL, 0);
+	else
+		ret = 0;
 
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
@@ -688,13 +691,14 @@ EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_back_parties initiator,
-				   bool tx)
+				   bool tx, bool call_drv)
 {
 	int ret;
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
-	ret = ___ieee80211_stop_tx_ba_session(sta, tid, initiator, tx);
+	ret = ___ieee80211_stop_tx_ba_session(sta, tid, initiator, tx,
+					      call_drv);
 
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 
@@ -911,7 +915,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
 	} else {
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR,
-						true);
+						true, true);
 	}
 
  out:
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 5ccec2c..0127367 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -230,7 +230,7 @@ static ssize_t sta_agg_status_write(struct file *file, const char __user *userbu
 			ret = ieee80211_stop_tx_ba_session(&sta->sta, tid);
 	} else {
 		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
-					       3, true);
+					       3, true, true);
 		ret = 0;
 	}
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 9b60336..a8125cb 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -179,16 +179,19 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	ieee80211_apply_htcap_overrides(sdata, ht_cap);
 }
 
-void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx)
+void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx,
+					 bool call_drv)
 {
 	int i;
 
 	cancel_work_sync(&sta->ampdu_mlme.work);
 
 	for (i = 0; i <  STA_TID_NUM; i++) {
-		__ieee80211_stop_tx_ba_session(sta, i, WLAN_BACK_INITIATOR, tx);
+		__ieee80211_stop_tx_ba_session(sta, i, WLAN_BACK_INITIATOR, tx,
+					       call_drv);
 		__ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
-					       WLAN_REASON_QSTA_LEAVE_QBSS, tx);
+					       WLAN_REASON_QSTA_LEAVE_QBSS, tx,
+					       call_drv);
 	}
 }
 
@@ -213,13 +216,13 @@ void ieee80211_ba_session_work(struct work_struct *work)
 		if (test_and_clear_bit(tid, sta->ampdu_mlme.tid_rx_timer_expired))
 			___ieee80211_stop_rx_ba_session(
 				sta, tid, WLAN_BACK_RECIPIENT,
-				WLAN_REASON_QSTA_TIMEOUT, true);
+				WLAN_REASON_QSTA_TIMEOUT, true, true);
 
 		if (test_and_clear_bit(tid,
 				       sta->ampdu_mlme.tid_rx_stop_requested))
 			___ieee80211_stop_rx_ba_session(
 				sta, tid, WLAN_BACK_RECIPIENT,
-				WLAN_REASON_UNSPECIFIED, true);
+				WLAN_REASON_UNSPECIFIED, true, true);
 
 		tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
 		if (tid_tx) {
@@ -246,7 +249,7 @@ void ieee80211_ba_session_work(struct work_struct *work)
 						 &tid_tx->state))
 			___ieee80211_stop_tx_ba_session(sta, tid,
 							WLAN_BACK_INITIATOR,
-							true);
+							true, true);
 	}
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
@@ -314,10 +317,10 @@ void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 
 	if (initiator == WLAN_BACK_INITIATOR)
 		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0,
-					       true);
+					       true, true);
 	else
 		__ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
-					       true);
+					       true, true);
 }
 
 int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ae046b5..1975f35 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1336,10 +1336,13 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 void ieee80211_request_smps_work(struct work_struct *work);
 
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-				     u16 initiator, u16 reason, bool stop);
+				     u16 initiator, u16 reason, bool stop,
+				     bool call_drv);
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-				    u16 initiator, u16 reason, bool stop);
-void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx);
+				    u16 initiator, u16 reason, bool stop,
+				    bool call_drv);
+void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx,
+					 bool call_drv);
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta,
 			     struct ieee80211_mgmt *mgmt, size_t len);
@@ -1354,10 +1357,10 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_back_parties initiator,
-				   bool tx);
+				   bool tx, bool call_drv);
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_back_parties initiator,
-				    bool tx);
+				    bool tx, bool call_drv);
 void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
 void ieee80211_ba_session_work(struct work_struct *work);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c550945..859271d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -922,7 +922,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 				__ieee80211_stop_rx_ba_session(
 					sta, tid, WLAN_BACK_RECIPIENT,
 					WLAN_REASON_QSTA_REQUIRE_SETUP,
-					true);
+					true, true);
 			}
 			mutex_unlock(&local->sta_mtx);
 		} else switch (sdata->vif.type) {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 40c933c..4ae9b23 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1363,7 +1363,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	sta = sta_info_get(sdata, bssid);
 	if (sta) {
 		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-		ieee80211_sta_tear_down_BA_sessions(sta, tx);
+		ieee80211_sta_tear_down_BA_sessions(sta, tx, true);
 	}
 	mutex_unlock(&local->sta_mtx);
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index af1c4e2..52cb3d3 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -43,7 +43,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		mutex_lock(&local->sta_mtx);
 		list_for_each_entry(sta, &local->sta_list, list) {
 			set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-			ieee80211_sta_tear_down_BA_sessions(sta, true);
+			ieee80211_sta_tear_down_BA_sessions(sta, true, true);
 		}
 		mutex_unlock(&local->sta_mtx);
 	}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 97a9d66..f5c2b7e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -682,7 +682,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	 * will be sufficient.
 	 */
 	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-	ieee80211_sta_tear_down_BA_sessions(sta, true);
+	ieee80211_sta_tear_down_BA_sessions(sta, true, true);
 
 	ret = sta_info_hash_del(local, sta);
 	if (ret)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a44c680..7c7e571 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1391,7 +1391,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_lock(&local->sta_mtx);
 
 		list_for_each_entry(sta, &local->sta_list, list) {
-			ieee80211_sta_tear_down_BA_sessions(sta, true);
+			/* don't call the driver when tearing down sessions */
+			ieee80211_sta_tear_down_BA_sessions(sta, true, false);
 			clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		}
 
-- 
1.7.9.5

