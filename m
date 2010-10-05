Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0JERhl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 13:37:41 -0400
Subject: [PATCH] mac80211: avoid transmitting delBA to old AP
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 19:37:40 +0200
Message-ID: <1286300260.3641.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When roaming while we have active BA session,
we can end up transmitting delBA frames to
the old AP while we're already on the new AP's
channel, which can cause warnings.

Simply avoid sending those frames, but still
tear down the internal session state, since
they are not really necessary anyway as we
will implicitly disassociate when sending the
association to the new AP.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c      |    8 ++++----
 net/mac80211/agg-tx.c      |   14 +++++++++-----
 net/mac80211/debugfs_sta.c |    3 ++-
 net/mac80211/ht.c          |   17 ++++++++++-------
 net/mac80211/ieee80211_i.h |   12 +++++++-----
 net/mac80211/iface.c       |    3 ++-
 net/mac80211/mlme.c        |   18 +++++++++---------
 net/mac80211/pm.c          |    2 +-
 net/mac80211/sta_info.c    |    2 +-
 net/mac80211/sta_info.h    |    2 ++
 net/mac80211/util.c        |    2 +-
 11 files changed, 48 insertions(+), 35 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-10-04 16:13:00.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-10-05 19:33:54.000000000 +0200
@@ -145,7 +145,8 @@ static void kfree_tid_tx(struct rcu_head
 }
 
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				    enum ieee80211_back_parties initiator)
+				    enum ieee80211_back_parties initiator,
+				    bool tx)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_tx *tid_tx = sta->ampdu_mlme.tid_tx[tid];
@@ -183,6 +184,7 @@ int ___ieee80211_stop_tx_ba_session(stru
 	clear_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
 
 	tid_tx->stop_initiator = initiator;
+	tid_tx->tx_stop = tx;
 
 	ret = drv_ampdu_action(local, sta->sdata,
 			       IEEE80211_AMPDU_TX_STOP,
@@ -575,13 +577,14 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				   enum ieee80211_back_parties initiator)
+				   enum ieee80211_back_parties initiator,
+				   bool tx)
 {
 	int ret;
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
-	ret = ___ieee80211_stop_tx_ba_session(sta, tid, initiator);
+	ret = ___ieee80211_stop_tx_ba_session(sta, tid, initiator, tx);
 
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 
@@ -670,7 +673,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 		goto unlock_sta;
 	}
 
-	if (tid_tx->stop_initiator == WLAN_BACK_INITIATOR)
+	if (tid_tx->stop_initiator == WLAN_BACK_INITIATOR && tid_tx->tx_stop)
 		ieee80211_send_delba(sta->sdata, ra, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
@@ -770,7 +773,8 @@ void ieee80211_process_addba_resp(struct
 
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
 	} else {
-		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
+		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR,
+						true);
 	}
 
  out:
--- wireless-testing.orig/net/mac80211/ht.c	2010-10-04 16:13:00.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-10-05 19:33:54.000000000 +0200
@@ -101,16 +101,16 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(s
 		ht_cap->mcs.rx_mask[32/8] |= 1;
 }
 
-void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta)
+void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx)
 {
 	int i;
 
 	cancel_work_sync(&sta->ampdu_mlme.work);
 
 	for (i = 0; i <  STA_TID_NUM; i++) {
-		__ieee80211_stop_tx_ba_session(sta, i, WLAN_BACK_INITIATOR);
+		__ieee80211_stop_tx_ba_session(sta, i, WLAN_BACK_INITIATOR, tx);
 		__ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
-					       WLAN_REASON_QSTA_LEAVE_QBSS);
+					       WLAN_REASON_QSTA_LEAVE_QBSS, tx);
 	}
 }
 
@@ -135,7 +135,7 @@ void ieee80211_ba_session_work(struct wo
 		if (test_and_clear_bit(tid, sta->ampdu_mlme.tid_rx_timer_expired))
 			___ieee80211_stop_rx_ba_session(
 				sta, tid, WLAN_BACK_RECIPIENT,
-				WLAN_REASON_QSTA_TIMEOUT);
+				WLAN_REASON_QSTA_TIMEOUT, true);
 
 		tid_tx = sta->ampdu_mlme.tid_tx[tid];
 		if (!tid_tx)
@@ -146,7 +146,8 @@ void ieee80211_ba_session_work(struct wo
 		else if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
 					    &tid_tx->state))
 			___ieee80211_stop_tx_ba_session(sta, tid,
-							WLAN_BACK_INITIATOR);
+							WLAN_BACK_INITIATOR,
+							true);
 	}
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
@@ -214,9 +215,11 @@ void ieee80211_process_delba(struct ieee
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (initiator == WLAN_BACK_INITIATOR)
-		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0);
+		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0,
+					       true);
 	else
-		__ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_RECIPIENT);
+		__ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
+					       true);
 }
 
 int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-10-05 19:33:54.000000000 +0200
@@ -1172,10 +1172,10 @@ int ieee80211_send_smps_action(struct ie
 void ieee80211_request_smps_work(struct work_struct *work);
 
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-				     u16 initiator, u16 reason);
+				     u16 initiator, u16 reason, bool stop);
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-				    u16 initiator, u16 reason);
-void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta);
+				    u16 initiator, u16 reason, bool stop);
+void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx);
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta,
 			     struct ieee80211_mgmt *mgmt, size_t len);
@@ -1189,9 +1189,11 @@ void ieee80211_process_addba_request(str
 				     size_t len);
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				   enum ieee80211_back_parties initiator);
+				   enum ieee80211_back_parties initiator,
+				   bool tx);
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-				    enum ieee80211_back_parties initiator);
+				    enum ieee80211_back_parties initiator,
+				    bool tx);
 void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
 void ieee80211_ba_session_work(struct work_struct *work);
--- wireless-testing.orig/net/mac80211/mlme.c	2010-10-05 10:46:10.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-10-05 19:33:54.000000000 +0200
@@ -921,7 +921,7 @@ static void ieee80211_set_associated(str
 }
 
 static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
-				   bool remove_sta)
+				   bool remove_sta, bool tx)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
@@ -960,7 +960,7 @@ static void ieee80211_set_disassoc(struc
 	sta = sta_info_get(sdata, bssid);
 	if (sta) {
 		set_sta_flags(sta, WLAN_STA_BLOCK_BA);
-		ieee80211_sta_tear_down_BA_sessions(sta);
+		ieee80211_sta_tear_down_BA_sessions(sta, tx);
 	}
 	mutex_unlock(&local->sta_mtx);
 
@@ -1124,7 +1124,7 @@ static void __ieee80211_connection_loss(
 
 	printk(KERN_DEBUG "Connection to AP %pM lost.\n", bssid);
 
-	ieee80211_set_disassoc(sdata, true);
+	ieee80211_set_disassoc(sdata, true, true);
 	mutex_unlock(&ifmgd->mtx);
 
 	mutex_lock(&local->mtx);
@@ -1197,7 +1197,7 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 	printk(KERN_DEBUG "%s: deauthenticated from %pM (Reason: %u)\n",
 			sdata->name, bssid, reason_code);
 
-	ieee80211_set_disassoc(sdata, true);
+	ieee80211_set_disassoc(sdata, true, false);
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
 	mutex_unlock(&sdata->local->mtx);
@@ -1229,7 +1229,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 	printk(KERN_DEBUG "%s: disassociated from %pM (Reason: %u)\n",
 			sdata->name, mgmt->sa, reason_code);
 
-	ieee80211_set_disassoc(sdata, true);
+	ieee80211_set_disassoc(sdata, true, false);
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
 	mutex_unlock(&sdata->local->mtx);
@@ -1879,7 +1879,7 @@ void ieee80211_sta_work(struct ieee80211
 			printk(KERN_DEBUG "No probe response from AP %pM"
 				" after %dms, disconnecting.\n",
 				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
-			ieee80211_set_disassoc(sdata, true);
+			ieee80211_set_disassoc(sdata, true, true);
 			mutex_unlock(&ifmgd->mtx);
 			mutex_lock(&local->mtx);
 			ieee80211_recalc_idle(local);
@@ -2203,7 +2203,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 		}
 
 		/* Trying to reassociate - clear previous association state */
-		ieee80211_set_disassoc(sdata, true);
+		ieee80211_set_disassoc(sdata, true, false);
 	}
 	mutex_unlock(&ifmgd->mtx);
 
@@ -2315,7 +2315,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 	memcpy(bssid, req->bss->bssid, ETH_ALEN);
 	if (ifmgd->associated == req->bss) {
-		ieee80211_set_disassoc(sdata, false);
+		ieee80211_set_disassoc(sdata, false, true);
 		mutex_unlock(&ifmgd->mtx);
 		assoc_bss = true;
 	} else {
@@ -2398,7 +2398,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 	       sdata->name, req->bss->bssid, req->reason_code);
 
 	memcpy(bssid, req->bss->bssid, ETH_ALEN);
-	ieee80211_set_disassoc(sdata, false);
+	ieee80211_set_disassoc(sdata, false, true);
 
 	mutex_unlock(&ifmgd->mtx);
 
--- wireless-testing.orig/net/mac80211/pm.c	2010-10-04 16:13:00.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2010-10-05 19:33:54.000000000 +0200
@@ -46,7 +46,7 @@ int __ieee80211_suspend(struct ieee80211
 	list_for_each_entry(sta, &local->sta_list, list) {
 		if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
 			set_sta_flags(sta, WLAN_STA_BLOCK_BA);
-			ieee80211_sta_tear_down_BA_sessions(sta);
+			ieee80211_sta_tear_down_BA_sessions(sta, true);
 		}
 
 		if (sta->uploaded) {
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-10-05 19:33:54.000000000 +0200
@@ -633,7 +633,7 @@ static int __must_check __sta_info_destr
 	 * will be sufficient.
 	 */
 	set_sta_flags(sta, WLAN_STA_BLOCK_BA);
-	ieee80211_sta_tear_down_BA_sessions(sta);
+	ieee80211_sta_tear_down_BA_sessions(sta, true);
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	ret = sta_info_hash_del(local, sta);
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-10-05 19:33:54.000000000 +0200
@@ -79,6 +79,7 @@ enum ieee80211_sta_info_flags {
  * @dialog_token: dialog token for aggregation session
  * @state: session state (see above)
  * @stop_initiator: initiator of a session stop
+ * @tx_stop: TX DelBA frame when stopping
  *
  * This structure is protected by RCU and the per-station
  * spinlock. Assignments to the array holding it must hold
@@ -95,6 +96,7 @@ struct tid_ampdu_tx {
 	unsigned long state;
 	u8 dialog_token;
 	u8 stop_initiator;
+	bool tx_stop;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/util.c	2010-10-05 10:46:10.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-10-05 19:33:54.000000000 +0200
@@ -1221,7 +1221,7 @@ int ieee80211_reconfig(struct ieee80211_
 		mutex_lock(&local->sta_mtx);
 
 		list_for_each_entry(sta, &local->sta_list, list) {
-			ieee80211_sta_tear_down_BA_sessions(sta);
+			ieee80211_sta_tear_down_BA_sessions(sta, true);
 			clear_sta_flags(sta, WLAN_STA_BLOCK_BA);
 		}
 
--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-10-04 16:13:00.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-10-05 19:33:54.000000000 +0200
@@ -56,7 +56,7 @@ static void ieee80211_free_tid_rx(struct
 }
 
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-				     u16 initiator, u16 reason)
+				     u16 initiator, u16 reason, bool tx)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_rx *tid_rx;
@@ -81,7 +81,7 @@ void ___ieee80211_stop_rx_ba_session(str
 				"aggregation for tid %d\n", tid);
 
 	/* check if this is a self generated aggregation halt */
-	if (initiator == WLAN_BACK_RECIPIENT)
+	if (initiator == WLAN_BACK_RECIPIENT && tx)
 		ieee80211_send_delba(sta->sdata, sta->sta.addr,
 				     tid, 0, reason);
 
@@ -92,10 +92,10 @@ void ___ieee80211_stop_rx_ba_session(str
 }
 
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-				    u16 initiator, u16 reason)
+				    u16 initiator, u16 reason, bool tx)
 {
 	mutex_lock(&sta->ampdu_mlme.mtx);
-	___ieee80211_stop_rx_ba_session(sta, tid, initiator, reason);
+	___ieee80211_stop_rx_ba_session(sta, tid, initiator, reason, tx);
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
 
--- wireless-testing.orig/net/mac80211/iface.c	2010-10-04 16:13:00.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-10-05 19:33:54.000000000 +0200
@@ -793,7 +793,8 @@ static void ieee80211_iface_work(struct
 
 				__ieee80211_stop_rx_ba_session(
 					sta, tid, WLAN_BACK_RECIPIENT,
-					WLAN_REASON_QSTA_REQUIRE_SETUP);
+					WLAN_REASON_QSTA_REQUIRE_SETUP,
+					true);
 			}
 			mutex_unlock(&local->sta_mtx);
 		} else switch (sdata->vif.type) {
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2010-10-04 16:13:00.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2010-10-05 19:33:54.000000000 +0200
@@ -196,7 +196,8 @@ static ssize_t sta_agg_status_write(stru
 		else
 			ret = ieee80211_stop_tx_ba_session(&sta->sta, tid);
 	} else {
-		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT, 3);
+		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
+					       3, true);
 		ret = 0;
 	}
 


