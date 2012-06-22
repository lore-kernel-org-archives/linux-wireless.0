Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2FVRSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 13:18:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/6] mac80211: clean up debugging
Date: Fri, 22 Jun 2012 19:18:43 +0200
Message-Id: <1340385525-14487-5-git-send-email-johannes@sipsolutions.net> (sfid-20120622_191856_957771_37688BFC)
In-Reply-To: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a few things that make the logging and
debugging in mac80211 less useful than it should
be right now:
 * a lot of messages should be pr_info, not pr_debug
 * wholesale use of pr_debug makes it require *both*
   Kconfig and dynamic configuration
 * there are still a lot of ifdefs
 * the style is very inconsistent, sometimes the
   sdata->name is printed in front

Clean up everything, introducing new macros and
separating out the station MLME debugging into
a new Kconfig symbol.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h        |   24 -----
 net/mac80211/Kconfig          |   32 +++++--
 net/mac80211/agg-rx.c         |   34 +++----
 net/mac80211/agg-tx.c         |   72 ++++++++-------
 net/mac80211/cfg.c            |    9 +-
 net/mac80211/debug.h          |  154 +++++++++++++++++++++++++++++++
 net/mac80211/debugfs_netdev.c |    5 +-
 net/mac80211/ht.c             |   10 +-
 net/mac80211/ibss.c           |   89 +++++++++---------
 net/mac80211/ieee80211_i.h    |    1 +
 net/mac80211/iface.c          |   13 +--
 net/mac80211/key.c            |    4 +-
 net/mac80211/mesh.c           |    4 -
 net/mac80211/mesh_hwmp.c      |   42 ++++-----
 net/mac80211/mesh_pathtbl.c   |   30 +++---
 net/mac80211/mesh_plink.c     |   61 +++++++------
 net/mac80211/mesh_sync.c      |   47 ++++------
 net/mac80211/mlme.c           |  203 +++++++++++++++++++----------------------
 net/mac80211/rx.c             |   40 +++-----
 net/mac80211/sta_info.c       |   44 ++++-----
 net/mac80211/status.c         |   11 +--
 net/mac80211/tx.c             |   43 ++++-----
 22 files changed, 520 insertions(+), 452 deletions(-)
 create mode 100644 net/mac80211/debug.h

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f11c2f8..510d852 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3842,28 +3842,4 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
  */
 int ieee80211_ave_rssi(struct ieee80211_vif *vif);
 
-/* Extra debugging macros */
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-#define ht_vdbg(fmt, ...)			\
-	pr_debug(fmt, ##__VA_ARGS__)
-#else
-#define ht_vdbg(fmt, ...)			\
-do {						\
-	if (0)					\
-		pr_debug(fmt, ##__VA_ARGS__);	\
-} while (0)
-#endif
-
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-#define ibss_vdbg(fmt, ...)			\
-	pr_debug(fmt, ##__VA_ARGS__)
-#else
-#define ibss_vdbg(fmt, ...)			\
-do {						\
-	if (0)					\
-		pr_debug(fmt, ##__VA_ARGS__);	\
-} while (0)
-#endif
-
 #endif /* MAC80211_H */
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 323aa19..7475e26 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -140,6 +140,26 @@ config MAC80211_VERBOSE_DEBUG
 
 	  Do not select this option.
 
+config MAC80211_MLME_DEBUG
+	bool "Verbose managed MLME output"
+	depends on MAC80211_DEBUG_MENU
+	---help---
+	  Selecting this option causes mac80211 to print out
+	  debugging messages for the managed-mode MLME. It
+	  should not be selected on production systems as some
+	  of the messages are remotely triggerable.
+
+	  Do not select this option.
+
+config MAC80211_STA_DEBUG
+	bool "Verbose station debugging"
+	depends on MAC80211_DEBUG_MENU
+	---help---
+	  Selecting this option causes mac80211 to print out
+	  debugging messages for station addition/removal.
+
+	  Do not select this option.
+
 config MAC80211_HT_DEBUG
 	bool "Verbose HT debugging"
 	depends on MAC80211_DEBUG_MENU
@@ -163,7 +183,7 @@ config MAC80211_IBSS_DEBUG
 
 	  Do not select this option.
 
-config MAC80211_VERBOSE_PS_DEBUG
+config MAC80211_PS_DEBUG
 	bool "Verbose powersave mode debugging"
 	depends on MAC80211_DEBUG_MENU
 	---help---
@@ -175,7 +195,7 @@ config MAC80211_VERBOSE_PS_DEBUG
 
 	  Do not select this option.
 
-config MAC80211_VERBOSE_MPL_DEBUG
+config MAC80211_MPL_DEBUG
 	bool "Verbose mesh peer link debugging"
 	depends on MAC80211_DEBUG_MENU
 	depends on MAC80211_MESH
@@ -188,7 +208,7 @@ config MAC80211_VERBOSE_MPL_DEBUG
 
 	  Do not select this option.
 
-config MAC80211_VERBOSE_MPATH_DEBUG
+config MAC80211_MPATH_DEBUG
 	bool "Verbose mesh path debugging"
 	depends on MAC80211_DEBUG_MENU
 	depends on MAC80211_MESH
@@ -201,7 +221,7 @@ config MAC80211_VERBOSE_MPATH_DEBUG
 
 	  Do not select this option.
 
-config MAC80211_VERBOSE_MHWMP_DEBUG
+config MAC80211_MHWMP_DEBUG
 	bool "Verbose mesh HWMP routing debugging"
 	depends on MAC80211_DEBUG_MENU
 	depends on MAC80211_MESH
@@ -214,7 +234,7 @@ config MAC80211_VERBOSE_MHWMP_DEBUG
 
 	  Do not select this option.
 
-config MAC80211_VERBOSE_MESH_SYNC_DEBUG
+config MAC80211_MESH_SYNC_DEBUG
 	bool "Verbose mesh mesh synchronization debugging"
 	depends on MAC80211_DEBUG_MENU
 	depends on MAC80211_MESH
@@ -225,7 +245,7 @@ config MAC80211_VERBOSE_MESH_SYNC_DEBUG
 
 	  Do not select this option.
 
-config MAC80211_VERBOSE_TDLS_DEBUG
+config MAC80211_TDLS_DEBUG
 	bool "Verbose TDLS debugging"
 	depends on MAC80211_DEBUG_MENU
 	---help---
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 32ef11d..186d991 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -74,15 +74,17 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 
 	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
 
-	ht_vdbg("Rx BA session stop requested for %pM tid %u %s reason: %d\n",
-		sta->sta.addr, tid,
-		initiator == WLAN_BACK_RECIPIENT ? "recipient" : "inititator",
-		(int)reason);
+	ht_dbg(sta->sdata,
+	       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
+	       sta->sta.addr, tid,
+	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "inititator",
+	       (int)reason);
 
 	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
 			     &sta->sta, tid, NULL, 0))
-		pr_debug("HW problem - can not stop rx aggregation for tid %d\n",
-			 tid);
+		sdata_info(sta->sdata,
+			   "HW problem - can not stop rx aggregation for tid %d\n",
+			   tid);
 
 	/* check if this is a self generated aggregation halt */
 	if (initiator == WLAN_BACK_RECIPIENT && tx)
@@ -157,7 +159,7 @@ static void sta_rx_agg_session_timer_expired(unsigned long data)
 	}
 	rcu_read_unlock();
 
-	ht_vdbg("rx session timer expired on tid %d\n", (u16)*ptid);
+	ht_dbg(sta->sdata, "rx session timer expired on tid %d\n", (u16)*ptid);
 
 	set_bit(*ptid, sta->ampdu_mlme.tid_rx_timer_expired);
 	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
@@ -245,7 +247,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	status = WLAN_STATUS_REQUEST_DECLINED;
 
 	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
-		ht_vdbg("Suspend in progress - Denying ADDBA request\n");
+		ht_dbg(sta->sdata, "Suspend in progress - Denying ADDBA request\n");
 		goto end_no_lock;
 	}
 
@@ -257,10 +259,9 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	     (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_DELAY_BA))) ||
 	    (buf_size > IEEE80211_MAX_AMPDU_BUF)) {
 		status = WLAN_STATUS_INVALID_QOS_PARAM;
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		net_dbg_ratelimited("AddBA Req with bad params from %pM on tid %u. policy %d, buffer size %d\n",
-				    mgmt->sa, tid, ba_policy, buf_size);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
+		ht_dbg_ratelimited(sta->sdata,
+				   "AddBA Req with bad params from %pM on tid %u. policy %d, buffer size %d\n",
+				   mgmt->sa, tid, ba_policy, buf_size);
 		goto end_no_lock;
 	}
 	/* determine default buffer size */
@@ -275,10 +276,9 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
 	if (sta->ampdu_mlme.tid_rx[tid]) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		net_dbg_ratelimited("unexpected AddBA Req from %pM on tid %u\n",
-				    mgmt->sa, tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
+		ht_dbg_ratelimited(sta->sdata,
+				   "unexpected AddBA Req from %pM on tid %u\n",
+				   mgmt->sa, tid);
 
 		/* delete existing Rx BA session on the same tid */
 		___ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
@@ -317,7 +317,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 
 	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
 			       &sta->sta, tid, &start_seq_num, 0);
-	ht_vdbg("Rx A-MPDU request on tid %d result %d\n", tid, ret);
+	ht_dbg(sta->sdata, "Rx A-MPDU request on tid %d result %d\n", tid, ret);
 	if (ret) {
 		kfree(tid_agg_rx->reorder_buf);
 		kfree(tid_agg_rx->reorder_time);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index da07f01..5cc1bf7 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -184,8 +184,8 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 
 	spin_unlock_bh(&sta->lock);
 
-	ht_vdbg("Tx BA session stop requested for %pM tid %u\n",
-		sta->sta.addr, tid);
+	ht_dbg(sta->sdata, "Tx BA session stop requested for %pM tid %u\n",
+	       sta->sta.addr, tid);
 
 	del_timer_sync(&tid_tx->addba_resp_timer);
 	del_timer_sync(&tid_tx->session_timer);
@@ -251,12 +251,13 @@ static void sta_addba_resp_timer_expired(unsigned long data)
 	if (!tid_tx ||
 	    test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state)) {
 		rcu_read_unlock();
-		ht_vdbg("timer expired on tid %d but we are not (or no longer) expecting addBA response there\n",
-			tid);
+		ht_dbg(sta->sdata,
+		       "timer expired on tid %d but we are not (or no longer) expecting addBA response there\n",
+		       tid);
 		return;
 	}
 
-	ht_vdbg("addBA response timer expired on tid %d\n", tid);
+	ht_dbg(sta->sdata, "addBA response timer expired on tid %d\n", tid);
 
 	ieee80211_stop_tx_ba_session(&sta->sta, tid);
 	rcu_read_unlock();
@@ -316,8 +317,9 @@ ieee80211_agg_splice_packets(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_stop_queue_agg(sdata, tid);
 
-	if (WARN(!tid_tx, "TID %d gone but expected when splicing aggregates"
-			  " from the pending queue\n", tid))
+	if (WARN(!tid_tx,
+		 "TID %d gone but expected when splicing aggregates from the pending queue\n",
+		 tid))
 		return;
 
 	if (!skb_queue_empty(&tid_tx->pending)) {
@@ -365,7 +367,8 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
 			       &sta->sta, tid, &start_seq_num, 0);
 	if (ret) {
-		ht_vdbg("BA request denied - HW unavailable for tid %d\n", tid);
+		ht_dbg(sdata,
+		       "BA request denied - HW unavailable for tid %d\n", tid);
 		spin_lock_bh(&sta->lock);
 		ieee80211_agg_splice_packets(sdata, tid_tx, tid);
 		ieee80211_assign_tid_tx(sta, tid, NULL);
@@ -378,7 +381,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 
 	/* activate the timer for the recipient's addBA response */
 	mod_timer(&tid_tx->addba_resp_timer, jiffies + ADDBA_RESP_INTERVAL);
-	ht_vdbg("activated addBA response timer on tid %d\n", tid);
+	ht_dbg(sdata, "activated addBA response timer on tid %d\n", tid);
 
 	spin_lock_bh(&sta->lock);
 	sta->ampdu_mlme.last_addba_req_time[tid] = jiffies;
@@ -425,7 +428,7 @@ static void sta_tx_agg_session_timer_expired(unsigned long data)
 
 	rcu_read_unlock();
 
-	ht_vdbg("tx session timer expired on tid %d\n", (u16)*ptid);
+	ht_dbg(sta->sdata, "tx session timer expired on tid %d\n", (u16)*ptid);
 
 	ieee80211_stop_tx_ba_session(&sta->sta, *ptid);
 }
@@ -449,8 +452,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	    (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW))
 		return -EINVAL;
 
-	ht_vdbg("Open BA session requested for %pM tid %u\n",
-		pubsta->addr, tid);
+	ht_dbg(sdata, "Open BA session requested for %pM tid %u\n",
+	       pubsta->addr, tid);
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
@@ -460,7 +463,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 
 	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
-		ht_vdbg("BA sessions blocked - Denying BA session request\n");
+		ht_dbg(sdata,
+		       "BA sessions blocked - Denying BA session request\n");
 		return -EINVAL;
 	}
 
@@ -478,8 +482,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	 */
 	if (sta->sdata->vif.type == NL80211_IFTYPE_ADHOC &&
 	    !sta->sta.ht_cap.ht_supported) {
-		ht_vdbg("BA request denied - IBSS STA %pM does not advertise HT support\n",
-			pubsta->addr);
+		ht_dbg(sdata,
+		       "BA request denied - IBSS STA %pM does not advertise HT support\n",
+		       pubsta->addr);
 		return -EINVAL;
 	}
 
@@ -499,8 +504,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_BURST_RETRIES &&
 	    time_before(jiffies, sta->ampdu_mlme.last_addba_req_time[tid] +
 			HT_AGG_RETRIES_PERIOD)) {
-		ht_vdbg("BA request denied - waiting a grace period after %d failed requests on tid %u\n",
-			sta->ampdu_mlme.addba_req_num[tid], tid);
+		ht_dbg(sdata,
+		       "BA request denied - waiting a grace period after %d failed requests on tid %u\n",
+		       sta->ampdu_mlme.addba_req_num[tid], tid);
 		ret = -EBUSY;
 		goto err_unlock_sta;
 	}
@@ -508,8 +514,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 	/* check if the TID is not in aggregation flow already */
 	if (tid_tx || sta->ampdu_mlme.tid_start_tx[tid]) {
-		ht_vdbg("BA request denied - session is not idle on tid %u\n",
-			tid);
+		ht_dbg(sdata,
+		       "BA request denied - session is not idle on tid %u\n",
+		       tid);
 		ret = -EAGAIN;
 		goto err_unlock_sta;
 	}
@@ -564,7 +571,7 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
-	ht_vdbg("Aggregation is on for tid %d\n", tid);
+	ht_dbg(sta->sdata, "Aggregation is on for tid %d\n", tid);
 
 	drv_ampdu_action(local, sta->sdata,
 			 IEEE80211_AMPDU_TX_OPERATIONAL,
@@ -598,7 +605,8 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 	trace_api_start_tx_ba_cb(sdata, ra, tid);
 
 	if (tid >= STA_TID_NUM) {
-		ht_vdbg("Bad TID value: tid = %d (>= %d)\n", tid, STA_TID_NUM);
+		ht_dbg(sdata, "Bad TID value: tid = %d (>= %d)\n",
+		       tid, STA_TID_NUM);
 		return;
 	}
 
@@ -606,7 +614,7 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 	sta = sta_info_get_bss(sdata, ra);
 	if (!sta) {
 		mutex_unlock(&local->sta_mtx);
-		ht_vdbg("Could not find station: %pM\n", ra);
+		ht_dbg(sdata, "Could not find station: %pM\n", ra);
 		return;
 	}
 
@@ -614,7 +622,7 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
 	if (WARN_ON(!tid_tx)) {
-		ht_vdbg("addBA was not requested!\n");
+		ht_dbg(sdata, "addBA was not requested!\n");
 		goto unlock;
 	}
 
@@ -714,17 +722,18 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 	trace_api_stop_tx_ba_cb(sdata, ra, tid);
 
 	if (tid >= STA_TID_NUM) {
-		ht_vdbg("Bad TID value: tid = %d (>= %d)\n", tid, STA_TID_NUM);
+		ht_dbg(sdata, "Bad TID value: tid = %d (>= %d)\n",
+		       tid, STA_TID_NUM);
 		return;
 	}
 
-	ht_vdbg("Stopping Tx BA session for %pM tid %d\n", ra, tid);
+	ht_dbg(sdata, "Stopping Tx BA session for %pM tid %d\n", ra, tid);
 
 	mutex_lock(&local->sta_mtx);
 
 	sta = sta_info_get_bss(sdata, ra);
 	if (!sta) {
-		ht_vdbg("Could not find station: %pM\n", ra);
+		ht_dbg(sdata, "Could not find station: %pM\n", ra);
 		goto unlock;
 	}
 
@@ -733,7 +742,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
 	if (!tid_tx || !test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
-		ht_vdbg("unexpected callback to A-MPDU stop\n");
+		ht_dbg(sdata, "unexpected callback to A-MPDU stop\n");
 		goto unlock_sta;
 	}
 
@@ -809,13 +818,13 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 		goto out;
 
 	if (mgmt->u.action.u.addba_resp.dialog_token != tid_tx->dialog_token) {
-		ht_vdbg("wrong addBA response token, tid %d\n", tid);
+		ht_dbg(sta->sdata, "wrong addBA response token, tid %d\n", tid);
 		goto out;
 	}
 
 	del_timer_sync(&tid_tx->addba_resp_timer);
 
-	ht_vdbg("switched off addBA timer for tid %d\n", tid);
+	ht_dbg(sta->sdata, "switched off addBA timer for tid %d\n", tid);
 
 	/*
 	 * addba_resp_timer may have fired before we got here, and
@@ -824,8 +833,9 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 	 */
 	if (test_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state) ||
 	    test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
-		ht_vdbg("got addBA resp for tid %d but we already gave up\n",
-			tid);
+		ht_dbg(sta->sdata,
+		       "got addBA resp for tid %d but we already gave up\n",
+		       tid);
 		goto out;
 	}
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d0c8f78..7722a73 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2771,9 +2771,8 @@ static int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	    !sdata->u.mgd.associated)
 		return -EINVAL;
 
-#ifdef CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
-	pr_debug("TDLS mgmt action %d peer %pM\n", action_code, peer);
-#endif
+	tdls_dbg(sdata, "TDLS mgmt action %d peer %pM\n",
+		 action_code, peer);
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    max(sizeof(struct ieee80211_mgmt),
@@ -2882,9 +2881,7 @@ static int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
-#ifdef CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
-	pr_debug("TDLS oper %d peer %pM\n", oper, peer);
-#endif
+	tdls_dbg(sdata, "TDLS oper %d peer %pM\n", oper, peer);
 
 	switch (oper) {
 	case NL80211_TDLS_ENABLE_LINK:
diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
new file mode 100644
index 0000000..dd5b5d0
--- /dev/null
+++ b/net/mac80211/debug.h
@@ -0,0 +1,154 @@
+#ifndef __MAC80211_DEBUG_H
+#define __MAC80211_DEBUG_H
+
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+#define MAC80211_IBSS_DEBUG 1
+#else
+#define MAC80211_IBSS_DEBUG 0
+#endif
+
+#ifdef CONFIG_MAC80211_PS_DEBUG
+#define MAC80211_PS_DEBUG 1
+#else
+#define MAC80211_PS_DEBUG 0
+#endif
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+#define MAC80211_HT_DEBUG 1
+#else
+#define MAC80211_HT_DEBUG 0
+#endif
+
+#ifdef CONFIG_MAC80211_MPL_DEBUG
+#define MAC80211_MPL_DEBUG 1
+#else
+#define MAC80211_MPL_DEBUG 0
+#endif
+
+#ifdef CONFIG_MAC80211_MPATH_DEBUG
+#define MAC80211_MPATH_DEBUG 1
+#else
+#define MAC80211_MPATH_DEBUG 0
+#endif
+
+#ifdef CONFIG_MAC80211_MHWMP_DEBUG
+#define MAC80211_MHWMP_DEBUG 1
+#else
+#define MAC80211_MHWMP_DEBUG 0
+#endif
+
+#ifdef CONFIG_MAC80211_MESH_SYNC_DEBUG
+#define MAC80211_MESH_SYNC_DEBUG 1
+#else
+#define MAC80211_MESH_SYNC_DEBUG 0
+#endif
+
+#ifdef CONFIG_MAC80211_TDLS_DEBUG
+#define MAC80211_TDLS_DEBUG 1
+#else
+#define MAC80211_TDLS_DEBUG 0
+#endif
+
+#ifdef CONFIG_MAC80211_STA_DEBUG
+#define MAC80211_STA_DEBUG 1
+#else
+#define MAC80211_STA_DEBUG 0
+#endif
+
+#ifdef CONFIG_MAC80211_MLME_DEBUG
+#define MAC80211_MLME_DEBUG 1
+#else
+#define MAC80211_MLME_DEBUG 0
+#endif
+
+#define DEBUG
+
+#define _sdata_info(sdata, fmt, ...)					\
+do {									\
+	pr_info("%s: " fmt,						\
+		(sdata)->name, ##__VA_ARGS__);				\
+} while (0)
+
+#define _sdata_dbg(print, sdata, fmt, ...)				\
+do {									\
+	if (print)							\
+		pr_debug("%s: " fmt,					\
+			 (sdata)->name, ##__VA_ARGS__);			\
+} while (0)
+
+#define _sdata_err(sdata, fmt, ...)					\
+do {									\
+	pr_debug("%s: " fmt,						\
+		 (sdata)->name, ##__VA_ARGS__);				\
+} while (0)
+
+#define _wiphy_dbg(print, wiphy, fmt, ...)				\
+do {									\
+	if (print)							\
+		wiphy_dbg((wiphy), fmt, ##__VA_ARGS__);			\
+} while (0)
+
+#define sdata_info(sdata, fmt, ...)					\
+	_sdata_info(sdata, fmt, ##__VA_ARGS__)
+#define sdata_err(sdata, fmt, ...)					\
+	_sdata_err(sdata, fmt, ##__VA_ARGS__)
+#define sdata_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(1, sdata, fmt, ##__VA_ARGS__)
+
+#define ht_dbg(sdata, fmt, ...)						\
+	_sdata_dbg(MAC80211_HT_DEBUG,					\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define ht_dbg_ratelimited(sdata, fmt, ...)				\
+	_sdata_dbg(MAC80211_HT_DEBUG && net_ratelimit(),		\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define ibss_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_IBSS_DEBUG,					\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define ps_dbg(sdata, fmt, ...)						\
+	_sdata_dbg(MAC80211_PS_DEBUG,					\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define ps_dbg_hw(hw, fmt, ...)						\
+	_wiphy_dbg(MAC80211_PS_DEBUG,					\
+		   (hw)->wiphy, fmt, ##__VA_ARGS__)
+
+#define ps_dbg_ratelimited(sdata, fmt, ...)				\
+	_sdata_dbg(MAC80211_PS_DEBUG && net_ratelimit(),		\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define mpl_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_MPL_DEBUG,					\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define mpath_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_MPATH_DEBUG,				\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define mhwmp_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_MHWMP_DEBUG,				\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define msync_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_MESH_SYNC_DEBUG,				\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define tdls_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_TDLS_DEBUG,					\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define sta_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_STA_DEBUG,					\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define mlme_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_MLME_DEBUG,					\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#define mlme_dbg_ratelimited(sdata, fmt, ...)				\
+	_sdata_dbg(MAC80211_MLME_DEBUG && net_ratelimit(),		\
+		   sdata, fmt, ##__VA_ARGS__)
+
+#endif /* __MAC80211_DEBUG_H */
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 512c894..6d5aec9 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -695,6 +695,7 @@ void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata)
 
 	sprintf(buf, "netdev:%s", sdata->name);
 	if (!debugfs_rename(dir->d_parent, dir, dir->d_parent, buf))
-		pr_err("mac80211: debugfs: failed to rename debugfs "
-		       "dir to %s\n", buf);
+		sdata_err(sdata,
+			  "debugfs: failed to rename debugfs dir to %s\n",
+			  buf);
 }
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 6f8615c..4b4538d 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -305,12 +305,10 @@ void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 	tid = (params & IEEE80211_DELBA_PARAM_TID_MASK) >> 12;
 	initiator = (params & IEEE80211_DELBA_PARAM_INITIATOR_MASK) >> 11;
 
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	net_dbg_ratelimited("delba from %pM (%s) tid %d reason code %d\n",
-			    mgmt->sa, initiator ? "initiator" : "recipient",
-			    tid,
-			    le16_to_cpu(mgmt->u.action.u.delba.reason_code));
-#endif /* CONFIG_MAC80211_HT_DEBUG */
+	ht_dbg_ratelimited(sdata, "delba from %pM (%s) tid %d reason code %d\n",
+			   mgmt->sa, initiator ? "initiator" : "recipient",
+			   tid,
+			   le16_to_cpu(mgmt->u.action.u.delba.reason_code));
 
 	if (initiator == WLAN_BACK_INITIATOR)
 		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8931110..5746d62 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -261,11 +261,7 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 
 	memcpy(addr, sta->sta.addr, ETH_ALEN);
 
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-	wiphy_debug(sdata->local->hw.wiphy,
-		    "Adding new IBSS station %pM (dev=%s)\n",
-		    addr, sdata->name);
-#endif
+	ibss_dbg(sdata, "Adding new IBSS station %pM\n", addr);
 
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
@@ -280,8 +276,9 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 	if (sta_info_insert_rcu(sta))
 		return sta_info_get(sdata, addr);
 	if (auth && !sdata->u.ibss.auth_frame_registrations) {
-		ibss_vdbg("TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
-			  sdata->vif.addr, sdata->u.ibss.bssid, addr);
+		ibss_dbg(sdata,
+			 "TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
+			 sdata->vif.addr, sdata->u.ibss.bssid, addr);
 		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
 				    addr, sdata->u.ibss.bssid, NULL, 0, 0);
 	}
@@ -304,7 +301,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	 * 	allow new one to be added.
 	 */
 	if (local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
-		net_dbg_ratelimited("%s: No room for a new IBSS STA entry %pM\n",
+		net_info_ratelimited("%s: No room for a new IBSS STA entry %pM\n",
 				    sdata->name, addr);
 		rcu_read_lock();
 		return NULL;
@@ -351,9 +348,9 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 
 	if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
 		return;
-	ibss_vdbg("%s: RX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=%d)\n",
-		  sdata->name, mgmt->sa, mgmt->da, mgmt->bssid,
-		  auth_transaction);
+	ibss_dbg(sdata,
+		 "RX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=%d)\n",
+		 mgmt->sa, mgmt->da, mgmt->bssid, auth_transaction);
 	sta_info_destroy_addr(sdata, mgmt->sa);
 	ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0, false);
 	rcu_read_unlock();
@@ -416,10 +413,10 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 					ieee80211_mandatory_rates(local, band);
 
 				if (sta->sta.supp_rates[band] != prev_rates) {
-					ibss_vdbg("%s: updated supp_rates set for %pM based on beacon/probe_resp (0x%x -> 0x%x)\n",
-						  sdata->name, sta->sta.addr,
-						  prev_rates,
-						  sta->sta.supp_rates[band]);
+					ibss_dbg(sdata,
+						 "updated supp_rates set for %pM based on beacon/probe_resp (0x%x -> 0x%x)\n",
+						 sta->sta.addr, prev_rates,
+						 sta->sta.supp_rates[band]);
 					rates_updated = true;
 				}
 			} else {
@@ -534,16 +531,18 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		rx_timestamp = drv_get_tsf(local, sdata);
 	}
 
-	ibss_vdbg("RX beacon SA=%pM BSSID=%pM TSF=0x%llx BCN=0x%llx diff=%lld @%lu\n",
-		  mgmt->sa, mgmt->bssid,
-		  (unsigned long long)rx_timestamp,
-		  (unsigned long long)beacon_timestamp,
-		  (unsigned long long)(rx_timestamp - beacon_timestamp),
-		  jiffies);
+	ibss_dbg(sdata,
+		 "RX beacon SA=%pM BSSID=%pM TSF=0x%llx BCN=0x%llx diff=%lld @%lu\n",
+		 mgmt->sa, mgmt->bssid,
+		 (unsigned long long)rx_timestamp,
+		 (unsigned long long)beacon_timestamp,
+		 (unsigned long long)(rx_timestamp - beacon_timestamp),
+		 jiffies);
 
 	if (beacon_timestamp > rx_timestamp) {
-		ibss_vdbg("%s: beacon TSF higher than local TSF - IBSS merge with BSSID %pM\n",
-			  sdata->name, mgmt->bssid);
+		ibss_dbg(sdata,
+			 "beacon TSF higher than local TSF - IBSS merge with BSSID %pM\n",
+			 mgmt->bssid);
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band, NULL);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
@@ -569,7 +568,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	 * 	allow new one to be added.
 	 */
 	if (local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
-		net_dbg_ratelimited("%s: No room for a new IBSS STA entry %pM\n",
+		net_info_ratelimited("%s: No room for a new IBSS STA entry %pM\n",
 				    sdata->name, addr);
 		return;
 	}
@@ -645,8 +644,8 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 	if (ifibss->fixed_channel)
 		return;
 
-	pr_debug("%s: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)\n",
-		 sdata->name);
+	sdata_info(sdata,
+		   "No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)\n");
 
 	ieee80211_request_internal_scan(sdata,
 			ifibss->ssid, ifibss->ssid_len, NULL);
@@ -674,8 +673,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		bssid[0] |= 0x02;
 	}
 
-	pr_debug("%s: Creating new IBSS network, BSSID %pM\n",
-		 sdata->name, bssid);
+	sdata_info(sdata, "Creating new IBSS network, BSSID %pM\n", bssid);
 
 	capability = WLAN_CAPABILITY_IBSS;
 
@@ -706,8 +704,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	lockdep_assert_held(&ifibss->mtx);
 
 	active_ibss = ieee80211_sta_active_ibss(sdata);
-	ibss_vdbg("%s: sta_find_ibss (active_ibss=%d)\n",
-		  sdata->name, active_ibss);
+	ibss_dbg(sdata, "sta_find_ibss (active_ibss=%d)\n", active_ibss);
 
 	if (active_ibss)
 		return;
@@ -730,23 +727,24 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		struct ieee80211_bss *bss;
 
 		bss = (void *)cbss->priv;
-		ibss_vdbg("   sta_find_ibss: selected %pM current %pM\n",
-			  cbss->bssid, ifibss->bssid);
-		pr_debug("%s: Selected IBSS BSSID %pM based on configured SSID\n",
-			 sdata->name, cbss->bssid);
+		ibss_dbg(sdata,
+			 "sta_find_ibss: selected %pM current %pM\n",
+			 cbss->bssid, ifibss->bssid);
+		sdata_info(sdata,
+			   "Selected IBSS BSSID %pM based on configured SSID\n",
+			   cbss->bssid);
 
 		ieee80211_sta_join_ibss(sdata, bss);
 		ieee80211_rx_bss_put(local, bss);
 		return;
 	}
 
-	ibss_vdbg("   did not try to join ibss\n");
+	ibss_dbg(sdata, "sta_find_ibss: did not try to join ibss\n");
 
 	/* Selected IBSS not found in current scan results - try to scan */
 	if (time_after(jiffies, ifibss->last_scan_completed +
 					IEEE80211_SCAN_INTERVAL)) {
-		pr_debug("%s: Trigger new scan to find an IBSS to join\n",
-			 sdata->name);
+		sdata_info(sdata, "Trigger new scan to find an IBSS to join\n");
 
 		ieee80211_request_internal_scan(sdata,
 				ifibss->ssid, ifibss->ssid_len,
@@ -760,9 +758,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 				ieee80211_sta_create_ibss(sdata);
 				return;
 			}
-			pr_debug("%s: IBSS not allowed on %d MHz\n",
-				 sdata->name,
-				 local->hw.conf.channel->center_freq);
+			sdata_info(sdata, "IBSS not allowed on %d MHz\n",
+				   local->hw.conf.channel->center_freq);
 
 			/* No IBSS found - decrease scan interval and continue
 			 * scanning. */
@@ -797,9 +794,9 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 
 	tx_last_beacon = drv_tx_last_beacon(local);
 
-	ibss_vdbg("%s: RX ProbeReq SA=%pM DA=%pM BSSID=%pM (tx_last_beacon=%d)\n",
-		  sdata->name, mgmt->sa, mgmt->da,
-		  mgmt->bssid, tx_last_beacon);
+	ibss_dbg(sdata,
+		 "RX ProbeReq SA=%pM DA=%pM BSSID=%pM (tx_last_beacon=%d)\n",
+		 mgmt->sa, mgmt->da, mgmt->bssid, tx_last_beacon);
 
 	if (!tx_last_beacon && is_multicast_ether_addr(mgmt->da))
 		return;
@@ -812,8 +809,8 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	pos = mgmt->u.probe_req.variable;
 	if (pos[0] != WLAN_EID_SSID ||
 	    pos + 2 + pos[1] > end) {
-		ibss_vdbg("%s: Invalid SSID IE in ProbeReq from %pM\n",
-			  sdata->name, mgmt->sa);
+		ibss_dbg(sdata, "Invalid SSID IE in ProbeReq from %pM\n",
+			 mgmt->sa);
 		return;
 	}
 	if (pos[1] != 0 &&
@@ -830,7 +827,7 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 
 	resp = (struct ieee80211_mgmt *) skb->data;
 	memcpy(resp->da, mgmt->sa, ETH_ALEN);
-	ibss_vdbg("%s: Sending ProbeResp to %pM\n", sdata->name, resp->da);
+	ibss_dbg(sdata, "Sending ProbeResp to %pM\n", resp->da);
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 36ce2bb..f834a00 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -30,6 +30,7 @@
 #include <net/mac80211.h>
 #include "key.h"
 #include "sta_info.h"
+#include "debug.h"
 
 struct ieee80211_local;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 728d3ea..5768803 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -57,9 +57,6 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 		return -EINVAL;
 	}
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	pr_debug("%s: setting MTU %d\n", dev->name, new_mtu);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 	dev->mtu = new_mtu;
 	return 0;
 }
@@ -1223,7 +1220,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 
 		if (__ffs64(mask) + hweight64(mask) != fls64(mask)) {
 			/* not a contiguous mask ... not handled now! */
-			pr_debug("not contiguous\n");
+			pr_info("not contiguous\n");
 			break;
 		}
 
@@ -1414,10 +1411,6 @@ static u32 ieee80211_idle_off(struct ieee80211_local *local,
 	if (!(local->hw.conf.flags & IEEE80211_CONF_IDLE))
 		return 0;
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "device no longer idle - %s\n", reason);
-#endif
-
 	local->hw.conf.flags &= ~IEEE80211_CONF_IDLE;
 	return IEEE80211_CONF_CHANGE_IDLE;
 }
@@ -1427,10 +1420,6 @@ static u32 ieee80211_idle_on(struct ieee80211_local *local)
 	if (local->hw.conf.flags & IEEE80211_CONF_IDLE)
 		return 0;
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "device now idle\n");
-#endif
-
 	drv_flush(local, false);
 
 	local->hw.conf.flags |= IEEE80211_CONF_IDLE;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 5bb600d..b3b7e52 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -139,7 +139,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	}
 
 	if (ret != -ENOSPC && ret != -EOPNOTSUPP)
-		wiphy_err(key->local->hw.wiphy,
+		sdata_err(sdata,
 			  "failed to set key (%d, %pM) to hardware (%d)\n",
 			  key->conf.keyidx,
 			  sta ? sta->sta.addr : bcast_addr, ret);
@@ -186,7 +186,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  sta ? &sta->sta : NULL, &key->conf);
 
 	if (ret)
-		wiphy_err(key->local->hw.wiphy,
+		sdata_err(sdata,
 			  "failed to remove key (%d, %pM) from hardware (%d)\n",
 			  key->conf.keyidx,
 			  sta ? sta->sta.addr : bcast_addr, ret);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ae40a83..764593d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -523,10 +523,6 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 {
 	bool free_plinks;
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	pr_debug("%s: running mesh housekeeping\n", sdata->name);
-#endif
-
 	ieee80211_sta_expire(sdata, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
 	mesh_path_expire(sdata);
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index aed1821..fb7b6a1 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -13,13 +13,6 @@
 #include "wme.h"
 #include "mesh.h"
 
-#ifdef CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG
-#define mhwmp_dbg(fmt, args...) \
-	pr_debug("Mesh HWMP (%s): " fmt "\n", sdata->name, ##args)
-#else
-#define mhwmp_dbg(fmt, args...)   do { (void)(0); } while (0)
-#endif
-
 #define TEST_FRAME_LEN	8192
 #define MAX_METRIC	0xffffffff
 #define ARITH_SHIFT	8
@@ -144,19 +137,19 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 
 	switch (action) {
 	case MPATH_PREQ:
-		mhwmp_dbg("sending PREQ to %pM", target);
+		mhwmp_dbg(sdata, "sending PREQ to %pM\n", target);
 		ie_len = 37;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREQ;
 		break;
 	case MPATH_PREP:
-		mhwmp_dbg("sending PREP to %pM", target);
+		mhwmp_dbg(sdata, "sending PREP to %pM\n", target);
 		ie_len = 31;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREP;
 		break;
 	case MPATH_RANN:
-		mhwmp_dbg("sending RANN from %pM", orig_addr);
+		mhwmp_dbg(sdata, "sending RANN from %pM\n", orig_addr);
 		ie_len = sizeof(struct ieee80211_rann_ie);
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_RANN;
@@ -535,10 +528,10 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	flags = PREQ_IE_FLAGS(preq_elem);
 	root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
 
-	mhwmp_dbg("received PREQ from %pM", orig_addr);
+	mhwmp_dbg(sdata, "received PREQ from %pM\n", orig_addr);
 
 	if (ether_addr_equal(target_addr, sdata->vif.addr)) {
-		mhwmp_dbg("PREQ is for us");
+		mhwmp_dbg(sdata, "PREQ is for us\n");
 		forward = false;
 		reply = true;
 		metric = 0;
@@ -590,7 +583,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
 		ttl = ifmsh->mshcfg.element_ttl;
 		if (ttl != 0) {
-			mhwmp_dbg("replying to the PREQ");
+			mhwmp_dbg(sdata, "replying to the PREQ\n");
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
 				cpu_to_le32(orig_sn), 0, target_addr,
 				cpu_to_le32(target_sn), mgmt->sa, 0, ttl,
@@ -611,7 +604,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			ifmsh->mshstats.dropped_frames_ttl++;
 			return;
 		}
-		mhwmp_dbg("forwarding the PREQ from %pM", orig_addr);
+		mhwmp_dbg(sdata, "forwarding the PREQ from %pM\n", orig_addr);
 		--ttl;
 		preq_id = PREQ_IE_PREQ_ID(preq_elem);
 		hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
@@ -658,7 +651,8 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	u8 next_hop[ETH_ALEN];
 	u32 target_sn, orig_sn, lifetime;
 
-	mhwmp_dbg("received PREP from %pM", PREP_IE_ORIG_ADDR(prep_elem));
+	mhwmp_dbg(sdata, "received PREP from %pM\n",
+		  PREP_IE_ORIG_ADDR(prep_elem));
 
 	orig_addr = PREP_IE_ORIG_ADDR(prep_elem);
 	if (ether_addr_equal(orig_addr, sdata->vif.addr))
@@ -784,8 +778,9 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	if (ether_addr_equal(orig_addr, sdata->vif.addr))
 		return;
 
-	mhwmp_dbg("received RANN from %pM via neighbour %pM (is_gate=%d)",
-			orig_addr, mgmt->sa, root_is_gate);
+	mhwmp_dbg(sdata,
+		  "received RANN from %pM via neighbour %pM (is_gate=%d)\n",
+		  orig_addr, mgmt->sa, root_is_gate);
 
 	rcu_read_lock();
 	sta = sta_info_get(sdata, mgmt->sa);
@@ -818,8 +813,9 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 				  root_path_confirmation_jiffies(sdata)) ||
 	     time_before(jiffies, mpath->last_preq_to_root))) &&
 	     !(mpath->flags & MESH_PATH_FIXED) && (ttl != 0)) {
-		mhwmp_dbg("%s time to refresh root mpath %pM", sdata->name,
-							       orig_addr);
+		mhwmp_dbg(sdata,
+			  "time to refresh root mpath %pM\n",
+			  orig_addr);
 		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 		mpath->last_preq_to_root = jiffies;
 	}
@@ -926,7 +922,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 
 	preq_node = kmalloc(sizeof(struct mesh_preq_queue), GFP_ATOMIC);
 	if (!preq_node) {
-		mhwmp_dbg("could not allocate PREQ node");
+		mhwmp_dbg(sdata, "could not allocate PREQ node\n");
 		return;
 	}
 
@@ -935,7 +931,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 		spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 		kfree(preq_node);
 		if (printk_ratelimit())
-			mhwmp_dbg("PREQ node queue full");
+			mhwmp_dbg(sdata, "PREQ node queue full\n");
 		return;
 	}
 
@@ -1183,7 +1179,7 @@ void mesh_path_timer(unsigned long data)
 		if (!mpath->is_gate && mesh_gate_num(sdata) > 0) {
 			ret = mesh_path_send_to_gates(mpath);
 			if (ret)
-				mhwmp_dbg("no gate was reachable");
+				mhwmp_dbg(sdata, "no gate was reachable\n");
 		} else
 			mesh_path_flush_pending(mpath);
 	}
@@ -1221,7 +1217,7 @@ mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 				0, cpu_to_le32(ifmsh->preq_id++), sdata);
 		break;
 	default:
-		mhwmp_dbg("Proactive mechanism not supported");
+		mhwmp_dbg(sdata, "Proactive mechanism not supported\n");
 		return;
 	}
 }
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 572f706..c9ae931 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -18,12 +18,6 @@
 #include "ieee80211_i.h"
 #include "mesh.h"
 
-#ifdef CONFIG_MAC80211_VERBOSE_MPATH_DEBUG
-#define mpath_dbg(fmt, args...)	pr_debug(fmt, ##args)
-#else
-#define mpath_dbg(fmt, args...)	do { (void)(0); } while (0)
-#endif
-
 /* There will be initially 2^INIT_PATHS_SIZE_ORDER buckets */
 #define INIT_PATHS_SIZE_ORDER	2
 
@@ -322,9 +316,8 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 
 	spin_lock_irqsave(&gate_mpath->frame_queue.lock, flags);
 	skb_queue_splice(&gateq, &gate_mpath->frame_queue);
-	mpath_dbg("Mpath queue for gate %pM has %d frames\n",
-			gate_mpath->dst,
-			skb_queue_len(&gate_mpath->frame_queue));
+	mpath_dbg(gate_mpath->sdata, "Mpath queue for gate %pM has %d frames\n",
+		  gate_mpath->dst, skb_queue_len(&gate_mpath->frame_queue));
 	spin_unlock_irqrestore(&gate_mpath->frame_queue.lock, flags);
 
 	if (!copy)
@@ -446,9 +439,9 @@ int mesh_path_add_gate(struct mesh_path *mpath)
 	hlist_add_head_rcu(&new_gate->list, tbl->known_gates);
 	spin_unlock_bh(&tbl->gates_lock);
 	rcu_read_unlock();
-	mpath_dbg("Mesh path (%s): Recorded new gate: %pM. %d known gates\n",
-		  mpath->sdata->name, mpath->dst,
-		  mpath->sdata->u.mesh.num_gates);
+	mpath_dbg(mpath->sdata,
+		  "Mesh path: Recorded new gate: %pM. %d known gates\n",
+		  mpath->dst, mpath->sdata->u.mesh.num_gates);
 	return 0;
 err_rcu:
 	rcu_read_unlock();
@@ -477,8 +470,8 @@ static int mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
 			spin_unlock_bh(&tbl->gates_lock);
 			mpath->sdata->u.mesh.num_gates--;
 			mpath->is_gate = false;
-			mpath_dbg("Mesh path (%s): Deleted gate: %pM. "
-				  "%d known gates\n", mpath->sdata->name,
+			mpath_dbg(mpath->sdata,
+				  "Mesh path: Deleted gate: %pM. %d known gates\n",
 				  mpath->dst, mpath->sdata->u.mesh.num_gates);
 			break;
 		}
@@ -946,19 +939,20 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 			continue;
 
 		if (gate->mpath->flags & MESH_PATH_ACTIVE) {
-			mpath_dbg("Forwarding to %pM\n", gate->mpath->dst);
+			mpath_dbg(sdata, "Forwarding to %pM\n", gate->mpath->dst);
 			mesh_path_move_to_queue(gate->mpath, from_mpath, copy);
 			from_mpath = gate->mpath;
 			copy = true;
 		} else {
-			mpath_dbg("Not forwarding %p\n", gate->mpath);
-			mpath_dbg("flags %x\n", gate->mpath->flags);
+			mpath_dbg(sdata,
+				  "Not forwarding %p (flags %#x)\n",
+				  gate->mpath, gate->mpath->flags);
 		}
 	}
 
 	hlist_for_each_entry_rcu(gate, n, known_gates, list)
 		if (gate->mpath->sdata == sdata) {
-			mpath_dbg("Sending to %pM\n", gate->mpath->dst);
+			mpath_dbg(sdata, "Sending to %pM\n", gate->mpath->dst);
 			mesh_path_tx_pending(gate->mpath);
 		}
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index be4fad1..a1dbd15 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -13,12 +13,6 @@
 #include "rate.h"
 #include "mesh.h"
 
-#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
-#define mpl_dbg(fmt, args...)	pr_debug(fmt, ##args)
-#else
-#define mpl_dbg(fmt, args...)	do { (void)(0); } while (0)
-#endif
-
 #define PLINK_GET_LLID(p) (p + 2)
 #define PLINK_GET_PLID(p) (p + 4)
 
@@ -134,12 +128,14 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 
 		switch (sta->ch_type) {
 		case NL80211_CHAN_NO_HT:
-			mpl_dbg("mesh_plink %pM: nonHT sta (%pM) is present",
+			mpl_dbg(sdata,
+				"mesh_plink %pM: nonHT sta (%pM) is present\n",
 				sdata->vif.addr, sta->sta.addr);
 			non_ht_sta = true;
 			goto out;
 		case NL80211_CHAN_HT20:
-			mpl_dbg("mesh_plink %pM: HT20 sta (%pM) is present",
+			mpl_dbg(sdata,
+				"mesh_plink %pM: HT20 sta (%pM) is present\n",
 				sdata->vif.addr, sta->sta.addr);
 			ht20_sta = true;
 		default:
@@ -160,7 +156,8 @@ out:
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
 		sdata->u.mesh.mshcfg.ht_opmode = ht_opmode;
 		changed = BSS_CHANGED_HT;
-		mpl_dbg("mesh_plink %pM: protection mode changed to %d",
+		mpl_dbg(sdata,
+			"mesh_plink %pM: protection mode changed to %d\n",
 			sdata->vif.addr, ht_opmode);
 	}
 
@@ -437,7 +434,8 @@ static void mesh_plink_timer(unsigned long data)
 		spin_unlock_bh(&sta->lock);
 		return;
 	}
-	mpl_dbg("Mesh plink timer for %pM fired on state %d\n",
+	mpl_dbg(sta->sdata,
+		"Mesh plink timer for %pM fired on state %d\n",
 		sta->sta.addr, sta->plink_state);
 	reason = 0;
 	llid = sta->llid;
@@ -450,7 +448,8 @@ static void mesh_plink_timer(unsigned long data)
 		/* retry timer */
 		if (sta->plink_retries < dot11MeshMaxRetries(sdata)) {
 			u32 rand;
-			mpl_dbg("Mesh plink for %pM (retry, timeout): %d %d\n",
+			mpl_dbg(sta->sdata,
+				"Mesh plink for %pM (retry, timeout): %d %d\n",
 				sta->sta.addr, sta->plink_retries,
 				sta->plink_timeout);
 			get_random_bytes(&rand, sizeof(u32));
@@ -530,7 +529,8 @@ int mesh_plink_open(struct sta_info *sta)
 	sta->plink_state = NL80211_PLINK_OPN_SNT;
 	mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
 	spin_unlock_bh(&sta->lock);
-	mpl_dbg("Mesh plink: starting establishment with %pM\n",
+	mpl_dbg(sdata,
+		"Mesh plink: starting establishment with %pM\n",
 		sta->sta.addr);
 
 	return mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
@@ -565,7 +565,6 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	u8 *baseaddr;
 	u32 changed = 0;
 	__le16 plid, llid, reason;
-#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	static const char *mplstates[] = {
 		[NL80211_PLINK_LISTEN] = "LISTEN",
 		[NL80211_PLINK_OPN_SNT] = "OPN-SNT",
@@ -575,14 +574,14 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		[NL80211_PLINK_HOLDING] = "HOLDING",
 		[NL80211_PLINK_BLOCKED] = "BLOCKED"
 	};
-#endif
 
 	/* need action_code, aux */
 	if (len < IEEE80211_MIN_ACTION_SIZE + 3)
 		return;
 
 	if (is_multicast_ether_addr(mgmt->da)) {
-		mpl_dbg("Mesh plink: ignore frame from multicast address");
+		mpl_dbg(sdata,
+			"Mesh plink: ignore frame from multicast address\n");
 		return;
 	}
 
@@ -595,12 +594,14 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	}
 	ieee802_11_parse_elems(baseaddr, len - baselen, &elems);
 	if (!elems.peering) {
-		mpl_dbg("Mesh plink: missing necessary peer link ie\n");
+		mpl_dbg(sdata,
+			"Mesh plink: missing necessary peer link ie\n");
 		return;
 	}
 	if (elems.rsn_len &&
 			sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) {
-		mpl_dbg("Mesh plink: can't establish link with secure peer\n");
+		mpl_dbg(sdata,
+			"Mesh plink: can't establish link with secure peer\n");
 		return;
 	}
 
@@ -610,14 +611,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	    (ftype == WLAN_SP_MESH_PEERING_CONFIRM && ie_len != 6) ||
 	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len != 6
 							&& ie_len != 8)) {
-		mpl_dbg("Mesh plink: incorrect plink ie length %d %d\n",
-		    ftype, ie_len);
+		mpl_dbg(sdata,
+			"Mesh plink: incorrect plink ie length %d %d\n",
+			ftype, ie_len);
 		return;
 	}
 
 	if (ftype != WLAN_SP_MESH_PEERING_CLOSE &&
 				(!elems.mesh_id || !elems.mesh_config)) {
-		mpl_dbg("Mesh plink: missing necessary ie\n");
+		mpl_dbg(sdata, "Mesh plink: missing necessary ie\n");
 		return;
 	}
 	/* Note the lines below are correct, the llid in the frame is the plid
@@ -632,21 +634,21 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 	sta = sta_info_get(sdata, mgmt->sa);
 	if (!sta && ftype != WLAN_SP_MESH_PEERING_OPEN) {
-		mpl_dbg("Mesh plink: cls or cnf from unknown peer\n");
+		mpl_dbg(sdata, "Mesh plink: cls or cnf from unknown peer\n");
 		rcu_read_unlock();
 		return;
 	}
 
 	if (ftype == WLAN_SP_MESH_PEERING_OPEN &&
 	    !rssi_threshold_check(sta, sdata)) {
-		mpl_dbg("Mesh plink: %pM does not meet rssi threshold\n",
+		mpl_dbg(sdata, "Mesh plink: %pM does not meet rssi threshold\n",
 			mgmt->sa);
 		rcu_read_unlock();
 		return;
 	}
 
 	if (sta && !test_sta_flag(sta, WLAN_STA_AUTH)) {
-		mpl_dbg("Mesh plink: Action frame from non-authed peer\n");
+		mpl_dbg(sdata, "Mesh plink: Action frame from non-authed peer\n");
 		rcu_read_unlock();
 		return;
 	}
@@ -683,7 +685,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	} else if (!sta) {
 		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
 		if (!mesh_plink_free_count(sdata)) {
-			mpl_dbg("Mesh plink error: no more free plinks\n");
+			mpl_dbg(sdata, "Mesh plink error: no more free plinks\n");
 			rcu_read_unlock();
 			return;
 		}
@@ -724,7 +726,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 				event = CLS_ACPT;
 			break;
 		default:
-			mpl_dbg("Mesh plink: unknown frame subtype\n");
+			mpl_dbg(sdata, "Mesh plink: unknown frame subtype\n");
 			rcu_read_unlock();
 			return;
 		}
@@ -734,13 +736,14 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		/* allocate sta entry if necessary and update info */
 		sta = mesh_peer_init(sdata, mgmt->sa, &elems);
 		if (!sta) {
-			mpl_dbg("Mesh plink: failed to init peer!\n");
+			mpl_dbg(sdata, "Mesh plink: failed to init peer!\n");
 			rcu_read_unlock();
 			return;
 		}
 	}
 
-	mpl_dbg("Mesh plink (peer, state, llid, plid, event): %pM %s %d %d %d\n",
+	mpl_dbg(sdata,
+		"Mesh plink (peer, state, llid, plid, event): %pM %s %d %d %d\n",
 		mgmt->sa, mplstates[sta->plink_state],
 		le16_to_cpu(sta->llid), le16_to_cpu(sta->plid),
 		event);
@@ -851,7 +854,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mesh_plink_inc_estab_count(sdata);
 			changed |= mesh_set_ht_prot_mode(sdata);
 			changed |= BSS_CHANGED_BEACON;
-			mpl_dbg("Mesh plink with %pM ESTABLISHED\n",
+			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			break;
 		default:
@@ -887,7 +890,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mesh_plink_inc_estab_count(sdata);
 			changed |= mesh_set_ht_prot_mode(sdata);
 			changed |= BSS_CHANGED_BEACON;
-			mpl_dbg("Mesh plink with %pM ESTABLISHED\n",
+			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			mesh_plink_frame_tx(sdata,
 					    WLAN_SP_MESH_PEERING_CONFIRM,
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 0ccdad4..accfa00 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -12,13 +12,6 @@
 #include "mesh.h"
 #include "driver-ops.h"
 
-#ifdef CONFIG_MAC80211_VERBOSE_MESH_SYNC_DEBUG
-#define msync_dbg(fmt, args...) \
-	pr_debug("Mesh sync (%s): " fmt "\n", sdata->name, ##args)
-#else
-#define msync_dbg(fmt, args...)   do { (void)(0); } while (0)
-#endif
-
 /* This is not in the standard.  It represents a tolerable tbtt drift below
  * which we do no TSF adjustment.
  */
@@ -65,14 +58,14 @@ void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 	spin_lock_bh(&ifmsh->sync_offset_lock);
 
 	if (ifmsh->sync_offset_clockdrift_max < beacon_int_fraction) {
-		msync_dbg("TBTT : max clockdrift=%lld; adjusting",
-			(long long) ifmsh->sync_offset_clockdrift_max);
+		msync_dbg(sdata, "TBTT : max clockdrift=%lld; adjusting\n",
+			  (long long) ifmsh->sync_offset_clockdrift_max);
 		tsfdelta = -ifmsh->sync_offset_clockdrift_max;
 		ifmsh->sync_offset_clockdrift_max = 0;
 	} else {
-		msync_dbg("TBTT : max clockdrift=%lld; adjusting by %llu",
-			(long long) ifmsh->sync_offset_clockdrift_max,
-			(unsigned long long) beacon_int_fraction);
+		msync_dbg(sdata, "TBTT : max clockdrift=%lld; adjusting by %llu\n",
+			  (long long) ifmsh->sync_offset_clockdrift_max,
+			  (unsigned long long) beacon_int_fraction);
 		tsfdelta = -beacon_int_fraction;
 		ifmsh->sync_offset_clockdrift_max -= beacon_int_fraction;
 	}
@@ -120,7 +113,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 	if (elems->mesh_config && mesh_peer_tbtt_adjusting(elems)) {
 		clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
-		msync_dbg("STA %pM : is adjusting TBTT", sta->sta.addr);
+		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n", sta->sta.addr);
 		goto no_sync;
 	}
 
@@ -169,7 +162,8 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
 		s64 t_clockdrift = sta->t_offset_setpoint
 				   - sta->t_offset;
-		msync_dbg("STA %pM : sta->t_offset=%lld, sta->t_offset_setpoint=%lld, t_clockdrift=%lld",
+		msync_dbg(sdata,
+			  "STA %pM : sta->t_offset=%lld, sta->t_offset_setpoint=%lld, t_clockdrift=%lld\n",
 			  sta->sta.addr,
 			  (long long) sta->t_offset,
 			  (long long)
@@ -178,7 +172,8 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 		if (t_clockdrift > TOFFSET_MAXIMUM_ADJUSTMENT ||
 			t_clockdrift < -TOFFSET_MAXIMUM_ADJUSTMENT) {
-			msync_dbg("STA %pM : t_clockdrift=%lld too large, setpoint reset",
+			msync_dbg(sdata,
+				  "STA %pM : t_clockdrift=%lld too large, setpoint reset\n",
 				  sta->sta.addr,
 				  (long long) t_clockdrift);
 			clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
@@ -197,8 +192,8 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	} else {
 		sta->t_offset_setpoint = sta->t_offset - TOFFSET_SET_MARGIN;
 		set_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
-		msync_dbg("STA %pM : offset was invalid, "
-			  " sta->t_offset=%lld",
+		msync_dbg(sdata,
+			  "STA %pM : offset was invalid, sta->t_offset=%lld\n",
 			  sta->sta.addr,
 			  (long long) sta->t_offset);
 		rcu_read_unlock();
@@ -226,17 +221,15 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 		 * to the driver tsf setter, we punt
 		 * the tsf adjustment to the mesh tasklet
 		 */
-		msync_dbg("TBTT : kicking off TBTT "
-			  "adjustment with "
-			  "clockdrift_max=%lld",
-		  ifmsh->sync_offset_clockdrift_max);
+		msync_dbg(sdata,
+			  "TBTT : kicking off TBTT adjustment with clockdrift_max=%lld\n",
+			  ifmsh->sync_offset_clockdrift_max);
 		set_bit(MESH_WORK_DRIFT_ADJUST,
 			&ifmsh->wrkq_flags);
 	} else {
-		msync_dbg("TBTT : max clockdrift=%lld; "
-			  "too small to adjust",
-			  (long long)
-		       ifmsh->sync_offset_clockdrift_max);
+		msync_dbg(sdata,
+			  "TBTT : max clockdrift=%lld; too small to adjust\n",
+			  (long long)ifmsh->sync_offset_clockdrift_max);
 		ifmsh->sync_offset_clockdrift_max = 0;
 	}
 	spin_unlock_bh(&ifmsh->sync_offset_lock);
@@ -268,7 +261,7 @@ static void mesh_sync_vendor_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	const u8 *oui;
 
 	WARN_ON(sdata->u.mesh.mesh_sp_id != IEEE80211_SYNC_METHOD_VENDOR);
-	msync_dbg("called mesh_sync_vendor_rx_bcn_presp");
+	msync_dbg(sdata, "called mesh_sync_vendor_rx_bcn_presp\n");
 	oui = mesh_get_vendor_oui(sdata);
 	/*  here you would implement the vendor offset tracking for this oui */
 }
@@ -278,7 +271,7 @@ static void mesh_sync_vendor_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 	const u8 *oui;
 
 	WARN_ON(sdata->u.mesh.mesh_sp_id != IEEE80211_SYNC_METHOD_VENDOR);
-	msync_dbg("called mesh_sync_vendor_adjust_tbtt");
+	msync_dbg(sdata, "called mesh_sync_vendor_adjust_tbtt\n");
 	oui = mesh_get_vendor_oui(sdata);
 	/*  here you would implement the vendor tsf adjustment for this oui */
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2b450f5..e11cd0e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1186,19 +1186,16 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		params.txop = get_unaligned_le16(pos + 2);
 		params.uapsd = uapsd;
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		wiphy_debug(local->hw.wiphy,
-			    "WMM queue=%d aci=%d acm=%d aifs=%d "
-			    "cWmin=%d cWmax=%d txop=%d uapsd=%d\n",
-			    queue, aci, acm,
-			    params.aifs, params.cw_min, params.cw_max,
-			    params.txop, params.uapsd);
-#endif
+		mlme_dbg(sdata,
+			 "WMM queue=%d aci=%d acm=%d aifs=%d cWmin=%d cWmax=%d txop=%d uapsd=%d\n",
+			 queue, aci, acm,
+			 params.aifs, params.cw_min, params.cw_max,
+			 params.txop, params.uapsd);
 		sdata->tx_conf[queue] = params;
 		if (drv_conf_tx(local, sdata, queue, &params))
-			wiphy_debug(local->hw.wiphy,
-				    "failed to set TX queue parameters for queue %d\n",
-				    queue);
+			sdata_err(sdata,
+				  "failed to set TX queue parameters for queue %d\n",
+				  queue);
 	}
 
 	/* enable WMM or activate new settings */
@@ -1565,11 +1562,10 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	if (beacon)
-		net_dbg_ratelimited("%s: detected beacon loss from AP - sending probe request\n",
-				    sdata->name);
-#endif
+		mlme_dbg_ratelimited(sdata,
+				     "detected beacon loss from AP - sending probe request\n");
+
 	ieee80211_cqm_rssi_notify(&sdata->vif,
 		NL80211_CQM_RSSI_BEACON_LOSS_EVENT, GFP_KERNEL);
 
@@ -1654,7 +1650,7 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 
 	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 
-	pr_debug("%s: Connection to AP %pM lost\n", sdata->name, bssid);
+	sdata_info(sdata, "Connection to AP %pM lost\n", bssid);
 
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
@@ -1788,8 +1784,8 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		return RX_MGMT_NONE;
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
-		pr_debug("%s: %pM denied authentication (status %d)\n",
-			 sdata->name, mgmt->sa, status_code);
+		sdata_info(sdata, "%pM denied authentication (status %d)\n",
+			   mgmt->sa, status_code);
 		ieee80211_destroy_auth_data(sdata, false);
 		return RX_MGMT_CFG80211_RX_AUTH;
 	}
@@ -1812,7 +1808,7 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		return RX_MGMT_NONE;
 	}
 
-	pr_debug("%s: authenticated\n", sdata->name);
+	sdata_info(sdata, "authenticated\n");
 	ifmgd->auth_data->done = true;
 	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
 	run_again(ifmgd, ifmgd->auth_data->timeout);
@@ -1825,7 +1821,7 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		goto out_err;
 	}
 	if (sta_info_move_state(sta, IEEE80211_STA_AUTH)) {
-		pr_debug("%s: failed moving %pM to auth\n", sdata->name, bssid);
+		sdata_info(sdata, "failed moving %pM to auth\n", bssid);
 		goto out_err;
 	}
 	mutex_unlock(&sdata->local->sta_mtx);
@@ -1859,8 +1855,8 @@ ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
-	pr_debug("%s: deauthenticated from %pM (Reason: %u)\n",
-		 sdata->name, bssid, reason_code);
+	sdata_info(sdata, "deauthenticated from %pM (Reason: %u)\n",
+		   bssid, reason_code);
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
@@ -1890,8 +1886,8 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
-	pr_debug("%s: disassociated from %pM (Reason: %u)\n",
-		 sdata->name, mgmt->sa, reason_code);
+	sdata_info(sdata, "disassociated from %pM (Reason: %u)\n",
+		   mgmt->sa, reason_code);
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
@@ -1983,15 +1979,15 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
 
 	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
-		pr_debug("%s: invalid AID value 0x%x; bits 15:14 not set\n",
-			 sdata->name, aid);
+		sdata_info(sdata, "invalid AID value 0x%x; bits 15:14 not set\n",
+			   aid);
 	aid &= ~(BIT(15) | BIT(14));
 
 	ifmgd->broken_ap = false;
 
 	if (aid == 0 || aid > IEEE80211_MAX_AID) {
-		pr_debug("%s: invalid AID value %d (out of range), turn off PS\n",
-			 sdata->name, aid);
+		sdata_info(sdata, "invalid AID value %d (out of range), turn off PS\n",
+			   aid);
 		aid = 0;
 		ifmgd->broken_ap = true;
 	}
@@ -2000,8 +1996,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 
 	if (!elems.supp_rates) {
-		pr_debug("%s: no SuppRates element in AssocResp\n",
-			 sdata->name);
+		sdata_info(sdata, "no SuppRates element in AssocResp\n");
 		return false;
 	}
 
@@ -2041,8 +2036,9 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	if (!err && !(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
 		err = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
 	if (err) {
-		pr_debug("%s: failed to move station %pM to desired state\n",
-			 sdata->name, sta->sta.addr);
+		sdata_info(sdata,
+			   "failed to move station %pM to desired state\n",
+			   sta->sta.addr);
 		WARN_ON(__sta_info_destroy(sta));
 		mutex_unlock(&sdata->local->sta_mtx);
 		return false;
@@ -2125,9 +2121,10 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
 
-	pr_debug("%s: RX %sssocResp from %pM (capab=0x%x status=%d aid=%d)\n",
-		 sdata->name, reassoc ? "Rea" : "A", mgmt->sa,
-		 capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
+	sdata_info(sdata,
+		   "RX %sssocResp from %pM (capab=0x%x status=%d aid=%d)\n",
+		   reassoc ? "Rea" : "A", mgmt->sa,
+		   capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
 
 	pos = mgmt->u.assoc_resp.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
@@ -2138,8 +2135,9 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		u32 tu, ms;
 		tu = get_unaligned_le32(elems.timeout_int + 1);
 		ms = tu * 1024 / 1000;
-		pr_debug("%s: %pM rejected association temporarily; comeback duration %u TU (%u ms)\n",
-			 sdata->name, mgmt->sa, tu, ms);
+		sdata_info(sdata,
+			   "%pM rejected association temporarily; comeback duration %u TU (%u ms)\n",
+			   mgmt->sa, tu, ms);
 		assoc_data->timeout = jiffies + msecs_to_jiffies(ms);
 		if (ms > IEEE80211_ASSOC_TIMEOUT)
 			run_again(ifmgd, assoc_data->timeout);
@@ -2149,11 +2147,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	*bss = assoc_data->bss;
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
-		pr_debug("%s: %pM denied association (code=%d)\n",
-			 sdata->name, mgmt->sa, status_code);
+		sdata_info(sdata, "%pM denied association (code=%d)\n",
+			   mgmt->sa, status_code);
 		ieee80211_destroy_assoc_data(sdata, false);
 	} else {
-		pr_debug("%s: associated\n", sdata->name);
+		sdata_info(sdata, "associated\n");
 
 		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
@@ -2261,7 +2259,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->auth_data && !ifmgd->auth_data->bss->proberesp_ies &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->auth_data->bss->bssid)) {
 		/* got probe response, continue with auth */
-		pr_debug("%s: direct probe responded\n", sdata->name);
+		sdata_info(sdata, "direct probe responded\n");
 		ifmgd->auth_data->tries = 0;
 		ifmgd->auth_data->timeout = jiffies;
 		run_again(ifmgd, ifmgd->auth_data->timeout);
@@ -2397,10 +2395,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		net_dbg_ratelimited("%s: cancelling probereq poll due to a received beacon\n",
-				    sdata->name);
-#endif
+		mlme_dbg_ratelimited(sdata,
+				     "cancelling probereq poll due to a received beacon\n");
 		mutex_lock(&local->mtx);
 		ifmgd->flags &= ~IEEE80211_STA_BEACON_POLL;
 		ieee80211_run_deferred_scan(local);
@@ -2625,8 +2621,8 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 	auth_data->tries++;
 
 	if (auth_data->tries > IEEE80211_AUTH_MAX_TRIES) {
-		pr_debug("%s: authentication with %pM timed out\n",
-			 sdata->name, auth_data->bss->bssid);
+		sdata_info(sdata, "authentication with %pM timed out\n",
+			   auth_data->bss->bssid);
 
 		/*
 		 * Most likely AP is not in the range so remove the
@@ -2638,9 +2634,9 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 	}
 
 	if (auth_data->bss->proberesp_ies) {
-		pr_debug("%s: send auth to %pM (try %d/%d)\n",
-			 sdata->name, auth_data->bss->bssid, auth_data->tries,
-			 IEEE80211_AUTH_MAX_TRIES);
+		sdata_info(sdata, "send auth to %pM (try %d/%d)\n",
+			   auth_data->bss->bssid, auth_data->tries,
+			   IEEE80211_AUTH_MAX_TRIES);
 
 		auth_data->expected_transaction = 2;
 		ieee80211_send_auth(sdata, 1, auth_data->algorithm,
@@ -2650,9 +2646,9 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 	} else {
 		const u8 *ssidie;
 
-		pr_debug("%s: direct probe to %pM (try %d/%i)\n",
-			 sdata->name, auth_data->bss->bssid, auth_data->tries,
-			 IEEE80211_AUTH_MAX_TRIES);
+		sdata_info(sdata, "direct probe to %pM (try %d/%i)\n",
+			   auth_data->bss->bssid, auth_data->tries,
+			   IEEE80211_AUTH_MAX_TRIES);
 
 		ssidie = ieee80211_bss_get_ie(auth_data->bss, WLAN_EID_SSID);
 		if (!ssidie)
@@ -2680,8 +2676,8 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 
 	assoc_data->tries++;
 	if (assoc_data->tries > IEEE80211_ASSOC_MAX_TRIES) {
-		pr_debug("%s: association with %pM timed out\n",
-			 sdata->name, assoc_data->bss->bssid);
+		sdata_info(sdata, "association with %pM timed out\n",
+			   assoc_data->bss->bssid);
 
 		/*
 		 * Most likely AP is not in the range so remove the
@@ -2692,9 +2688,9 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 		return -ETIMEDOUT;
 	}
 
-	pr_debug("%s: associate with %pM (try %d/%d)\n",
-		 sdata->name, assoc_data->bss->bssid, assoc_data->tries,
-		 IEEE80211_ASSOC_MAX_TRIES);
+	sdata_info(sdata, "associate with %pM (try %d/%d)\n",
+		   assoc_data->bss->bssid, assoc_data->tries,
+		   IEEE80211_ASSOC_MAX_TRIES);
 	ieee80211_send_assoc(sdata);
 
 	assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
@@ -2767,45 +2763,31 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			ieee80211_reset_ap_probe(sdata);
 		else if (ifmgd->nullfunc_failed) {
 			if (ifmgd->probe_send_count < max_tries) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-				wiphy_debug(local->hw.wiphy,
-					    "%s: No ack for nullfunc frame to"
-					    " AP %pM, try %d/%i\n",
-					    sdata->name, bssid,
-					    ifmgd->probe_send_count, max_tries);
-#endif
+				mlme_dbg(sdata,
+					 "No ack for nullfunc frame to AP %pM, try %d/%i\n",
+					 bssid, ifmgd->probe_send_count,
+					 max_tries);
 				ieee80211_mgd_probe_ap_send(sdata);
 			} else {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-				wiphy_debug(local->hw.wiphy,
-					    "%s: No ack for nullfunc frame to"
-					    " AP %pM, disconnecting.\n",
-					    sdata->name, bssid);
-#endif
+				mlme_dbg(sdata,
+					 "No ack for nullfunc frame to AP %pM, disconnecting.\n",
+					 bssid);
 				ieee80211_sta_connection_lost(sdata, bssid,
 					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
 			}
 		} else if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
 		else if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			wiphy_debug(local->hw.wiphy,
-				    "%s: Failed to send nullfunc to AP %pM"
-				    " after %dms, disconnecting.\n",
-				    sdata->name,
-				    bssid, probe_wait_ms);
-#endif
+			mlme_dbg(sdata,
+				 "Failed to send nullfunc to AP %pM after %dms, disconnecting\n",
+				 bssid, probe_wait_ms);
 			ieee80211_sta_connection_lost(sdata, bssid,
 				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
 		} else if (ifmgd->probe_send_count < max_tries) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			wiphy_debug(local->hw.wiphy,
-				    "%s: No probe response from AP %pM"
-				    " after %dms, try %d/%i\n",
-				    sdata->name,
-				    bssid, probe_wait_ms,
-				    ifmgd->probe_send_count, max_tries);
-#endif
+			mlme_dbg(sdata,
+				 "No probe response from AP %pM after %dms, try %d/%i\n",
+				 bssid, probe_wait_ms,
+				 ifmgd->probe_send_count, max_tries);
 			ieee80211_mgd_probe_ap_send(sdata);
 		} else {
 			/*
@@ -2920,11 +2902,8 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 		sdata->flags &= ~IEEE80211_SDATA_DISCONNECT_RESUME;
 		mutex_lock(&ifmgd->mtx);
 		if (ifmgd->associated) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			wiphy_debug(sdata->local->hw.wiphy,
-				    "%s: driver requested disconnect after resume.\n",
-				    sdata->name);
-#endif
+			mlme_dbg(sdata,
+				 "driver requested disconnect after resume\n");
 			ieee80211_sta_connection_lost(sdata,
 				ifmgd->associated->bssid,
 				WLAN_REASON_UNSPECIFIED);
@@ -3065,10 +3044,11 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			 * since we look at probe response/beacon data here
 			 * it should be OK.
 			 */
-			pr_debug("%s: Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
-				 sdata->name, cbss->channel->center_freq,
-				 ht_cfreq, ht_oper->primary_chan,
-				 cbss->channel->band);
+			sdata_info(sdata,
+				   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
+				   cbss->channel->center_freq,
+				   ht_cfreq, ht_oper->primary_chan,
+				   cbss->channel->band);
 			ht_oper = NULL;
 		}
 	}
@@ -3092,8 +3072,8 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
 		/* can only fail due to HT40+/- mismatch */
 		channel_type = NL80211_CHAN_HT20;
-		pr_debug("%s: disabling 40 MHz due to multi-vif mismatch\n",
-			 sdata->name);
+		sdata_info(sdata,
+			   "disabling 40 MHz due to multi-vif mismatch\n");
 		ifmgd->flags |= IEEE80211_STA_DISABLE_40MHZ;
 		WARN_ON(!ieee80211_set_channel_type(local, sdata,
 						    channel_type));
@@ -3122,8 +3102,8 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		 * we can connect -- with a warning.
 		 */
 		if (!basic_rates && min_rate_index >= 0) {
-			pr_debug("%s: No basic rates, using min rate instead\n",
-				 sdata->name);
+			sdata_info(sdata,
+				   "No basic rates, using min rate instead\n");
 			basic_rates = BIT(min_rate_index);
 		}
 
@@ -3149,8 +3129,9 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		err = sta_info_insert(sta);
 		sta = NULL;
 		if (err) {
-			pr_debug("%s: failed to insert STA entry for the AP (error %d)\n",
-				 sdata->name, err);
+			sdata_info(sdata,
+				   "failed to insert STA entry for the AP (error %d)\n",
+				   err);
 			return err;
 		}
 	} else
@@ -3228,7 +3209,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->associated)
 		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-	pr_debug("%s: authenticate with %pM\n", sdata->name, req->bss->bssid);
+	sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
 
 	err = ieee80211_prep_connection(sdata, req->bss, false);
 	if (err)
@@ -3410,8 +3391,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		 * Wait up to one beacon interval ...
 		 * should this be more if we miss one?
 		 */
-		pr_debug("%s: waiting for beacon from %pM\n",
-			 sdata->name, ifmgd->bssid);
+		sdata_info(sdata, "waiting for beacon from %pM\n",
+			   ifmgd->bssid);
 		assoc_data->timeout = TU_TO_EXP_TIME(req->bss->beacon_interval);
 	} else {
 		assoc_data->have_beacon = true;
@@ -3430,8 +3411,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 				corrupt_type = "beacon";
 		} else if (bss->corrupt_data & IEEE80211_BSS_CORRUPT_PROBE_RESP)
 			corrupt_type = "probe response";
-		pr_debug("%s: associating with AP with corrupt %s\n",
-			 sdata->name, corrupt_type);
+		sdata_info(sdata, "associating with AP with corrupt %s\n",
+			   corrupt_type);
 	}
 
 	err = 0;
@@ -3460,8 +3441,9 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		return 0;
 	}
 
-	pr_debug("%s: deauthenticating from %pM by local choice (reason=%d)\n",
-		 sdata->name, req->bssid, req->reason_code);
+	sdata_info(sdata,
+		   "deauthenticating from %pM by local choice (reason=%d)\n",
+		   req->bssid, req->reason_code);
 
 	if (ifmgd->associated &&
 	    ether_addr_equal(ifmgd->associated->bssid, req->bssid))
@@ -3503,8 +3485,9 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 		return -ENOLINK;
 	}
 
-	pr_debug("%s: disassociating from %pM by local choice (reason=%d)\n",
-		 sdata->name, req->bss->bssid, req->reason_code);
+	sdata_info(sdata,
+		   "disassociating from %pM by local choice (reason=%d)\n",
+		   req->bss->bssid, req->reason_code);
 
 	memcpy(bssid, req->bss->bssid, ETH_ALEN);
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DISASSOC,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9f1bd69..ab51850 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -632,11 +632,8 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 					HT_RX_REORDER_BUF_TIMEOUT))
 				goto set_release_timer;
 
-#ifdef CONFIG_MAC80211_HT_DEBUG
-			if (net_ratelimit())
-				wiphy_debug(sdata->local->hw.wiphy,
-					    "release an RX reorder frame due to timeout on earlier frames\n");
-#endif
+			ht_dbg_ratelimited(sdata,
+					   "release an RX reorder frame due to timeout on earlier frames\n");
 			ieee80211_release_reorder_frame(sdata, tid_agg_rx, j);
 
 			/*
@@ -1136,24 +1133,18 @@ static void ap_sta_ps_start(struct sta_info *sta)
 	set_sta_flag(sta, WLAN_STA_PS_STA);
 	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	pr_debug("%s: STA %pM aid %d enters power save mode\n",
-		 sdata->name, sta->sta.addr, sta->sta.aid);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+	ps_dbg(sdata, "STA %pM aid %d enters power save mode\n",
+	       sta->sta.addr, sta->sta.aid);
 }
 
 static void ap_sta_ps_end(struct sta_info *sta)
 {
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	pr_debug("%s: STA %pM aid %d exits power save mode\n",
-		 sta->sdata->name, sta->sta.addr, sta->sta.aid);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+	ps_dbg(sta->sdata, "STA %pM aid %d exits power save mode\n",
+	       sta->sta.addr, sta->sta.aid);
 
 	if (test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		pr_debug("%s: STA %pM aid %d driver-ps-blocked\n",
-			 sta->sdata->name, sta->sta.addr, sta->sta.aid);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+		ps_dbg(sta->sdata, "STA %pM aid %d driver-ps-blocked\n",
+		       sta->sta.addr, sta->sta.aid);
 		return;
 	}
 
@@ -1383,17 +1374,8 @@ ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 	if (sdata->fragment_next >= IEEE80211_FRAGMENT_MAX)
 		sdata->fragment_next = 0;
 
-	if (!skb_queue_empty(&entry->skb_list)) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		struct ieee80211_hdr *hdr =
-			(struct ieee80211_hdr *) entry->skb_list.next->data;
-		pr_debug("%s: RX reassembly removed oldest fragment entry (idx=%d age=%lu seq=%d last_frag=%d addr1=%pM addr2=%pM\n",
-			 sdata->name, idx,
-			 jiffies - entry->first_frag_time, entry->seq,
-			 entry->last_frag, hdr->addr1, hdr->addr2);
-#endif
+	if (!skb_queue_empty(&entry->skb_list))
 		__skb_queue_purge(&entry->skb_list);
-	}
 
 	__skb_queue_tail(&entry->skb_list, *skb); /* no need for locking */
 	*skb = NULL;
@@ -1751,7 +1733,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 			 */
 			xmit_skb = skb_copy(skb, GFP_ATOMIC);
 			if (!xmit_skb)
-				net_dbg_ratelimited("%s: failed to clone multicast frame\n",
+				net_info_ratelimited("%s: failed to clone multicast frame\n",
 						    dev->name);
 		} else {
 			dsta = sta_info_get(sdata, skb->data);
@@ -1955,7 +1937,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 
 	fwd_skb = skb_copy(skb, GFP_ATOMIC);
 	if (!fwd_skb) {
-		net_dbg_ratelimited("%s: failed to clone mesh frame\n",
+		net_info_ratelimited("%s: failed to clone mesh frame\n",
 				    sdata->name);
 		goto out;
 	}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 77dcf2f..06fa75c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -169,9 +169,7 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 	if (sta->rate_ctrl)
 		rate_control_free_sta(sta);
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "Destroyed STA %pM\n", sta->sta.addr);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
 
 	kfree(sta);
 }
@@ -278,9 +276,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "Allocated STA %pM\n", sta->sta.addr);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
 #ifdef CONFIG_MAC80211_MESH
 	sta->plink_state = NL80211_PLINK_LISTEN;
@@ -333,8 +329,9 @@ static int sta_info_insert_drv_state(struct ieee80211_local *local,
 	}
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		pr_debug("%s: failed to move IBSS STA %pM to state %d (%d) - keeping it anyway\n",
-			 sdata->name, sta->sta.addr, state + 1, err);
+		sdata_info(sdata,
+			   "failed to move IBSS STA %pM to state %d (%d) - keeping it anyway\n",
+			   sta->sta.addr, state + 1, err);
 		err = 0;
 	}
 
@@ -389,9 +386,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	sinfo.generation = local->sta_generation;
 	cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "Inserted STA %pM\n", sta->sta.addr);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	sta_dbg(sdata, "Inserted STA %pM\n", sta->sta.addr);
 
 	/* move reference to rcu-protected */
 	rcu_read_lock();
@@ -617,9 +612,8 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 			break;
 
 		local->total_ps_buffered--;
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		pr_debug("Buffered frame expired (STA %pM)\n", sta->sta.addr);
-#endif
+		ps_dbg(sta->sdata, "Buffered frame expired (STA %pM)\n",
+		       sta->sta.addr);
 		dev_kfree_skb(skb);
 	}
 
@@ -745,9 +739,8 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 		mesh_accept_plinks_update(sdata);
 #endif
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "Removed STA %pM\n", sta->sta.addr);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
+
 	cancel_work_sync(&sta->drv_unblock_wk);
 
 	cfg80211_del_sta(sdata->dev, sta->sta.addr, GFP_KERNEL);
@@ -887,8 +880,8 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			continue;
 
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
-			ibss_vdbg("%s: expiring inactive STA %pM\n",
-				  sdata->name, sta->sta.addr);
+			ibss_dbg(sdata, "expiring inactive STA %pM\n",
+				 sta->sta.addr);
 			WARN_ON(__sta_info_destroy(sta));
 		}
 	}
@@ -986,10 +979,9 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	sta_info_recalc_tim(sta);
 
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	pr_debug("%s: STA %pM aid %d sending %d filtered/%d PS frames since STA not sleeping anymore\n",
-		 sdata->name, sta->sta.addr, sta->sta.aid, filtered, buffered);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+	ps_dbg(sdata,
+	       "STA %pM aid %d sending %d filtered/%d PS frames since STA not sleeping anymore\n",
+	       sta->sta.addr, sta->sta.aid, filtered, buffered);
 }
 
 static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
@@ -1379,10 +1371,8 @@ int sta_info_move_state(struct sta_info *sta,
 		return -EINVAL;
 	}
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	pr_debug("%s: moving STA %pM to state %d\n",
-		 sta->sdata->name, sta->sta.addr, new_state);
-#endif
+	sta_dbg(sta->sdata, "moving STA %pM to state %d\n",
+		sta->sta.addr, new_state);
 
 	/*
 	 * notify the driver before the actual changes so it can
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 51a6d1e..2ed2f27 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -155,13 +155,10 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		return;
 	}
 
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	if (net_ratelimit())
-		wiphy_debug(local->hw.wiphy,
-			    "dropped TX filtered frame, queue_len=%d PS=%d @%lu\n",
-			    skb_queue_len(&sta->tx_filtered[ac]),
-			    !!test_sta_flag(sta, WLAN_STA_PS_STA), jiffies);
-#endif
+	ps_dbg_ratelimited(sta->sdata,
+			   "dropped TX filtered frame, queue_len=%d PS=%d @%lu\n",
+			   skb_queue_len(&sta->tx_filtered[ac]),
+			   !!test_sta_flag(sta, WLAN_STA_PS_STA), jiffies);
 	dev_kfree_skb(skb);
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index af25c4e..37eda7e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -297,9 +297,10 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		if (unlikely(!assoc &&
 			     ieee80211_is_data(hdr->frame_control))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			pr_debug("%s: dropped data frame to not associated station %pM\n",
-				 tx->sdata->name, hdr->addr1);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+			sdata_info(tx->sdata,
+				   "dropped data frame to not associated station %pM\n",
+				   hdr->addr1);
+#endif
 			I802_DEBUG_INC(tx->local->tx_handlers_drop_not_assoc);
 			return TX_DROP;
 		}
@@ -366,10 +367,7 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 	rcu_read_unlock();
 
 	local->total_ps_buffered = total;
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	wiphy_debug(local->hw.wiphy, "PS buffers full - purged %d frames\n",
-		    purged);
-#endif
+	ps_dbg_hw(&local->hw, "PS buffers full - purged %d frames\n", purged);
 }
 
 static ieee80211_tx_result
@@ -411,10 +409,8 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 		purge_old_ps_buffers(tx->local);
 
 	if (skb_queue_len(&tx->sdata->bss->ps_bc_buf) >= AP_MAX_BC_BUFFER) {
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		net_dbg_ratelimited("%s: BC TX buffer full - dropping the oldest frame\n",
-				    tx->sdata->name);
-#endif
+		ps_dbg(tx->sdata,
+		       "BC TX buffer full - dropping the oldest frame\n");
 		dev_kfree_skb(skb_dequeue(&tx->sdata->bss->ps_bc_buf));
 	} else
 		tx->local->total_ps_buffered++;
@@ -465,18 +461,15 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 			return TX_CONTINUE;
 		}
 
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		pr_debug("STA %pM aid %d: PS buffer for AC %d\n",
-			 sta->sta.addr, sta->sta.aid, ac);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
+		       sta->sta.addr, sta->sta.aid, ac);
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
 			purge_old_ps_buffers(tx->local);
 		if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
 			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-			net_dbg_ratelimited("%s: STA %pM TX buffer for AC %d full - dropping oldest frame\n",
-					    tx->sdata->name, sta->sta.addr, ac);
-#endif
+			ps_dbg(tx->sdata,
+			       "STA %pM TX buffer for AC %d full - dropping oldest frame\n",
+			       sta->sta.addr, ac);
 			dev_kfree_skb(old);
 		} else
 			tx->local->total_ps_buffered++;
@@ -498,13 +491,11 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		sta_info_recalc_tim(sta);
 
 		return TX_QUEUED;
+	} else if (unlikely(test_sta_flag(sta, WLAN_STA_PS_STA))) {
+		ps_dbg(tx->sdata,
+		       "STA %pM in PS mode, but polling/in SP -> send frame\n",
+		       sta->sta.addr);
 	}
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	else if (unlikely(test_sta_flag(sta, WLAN_STA_PS_STA))) {
-		pr_debug("%s: STA %pM in PS mode, but polling/in SP -> send frame\n",
-			 tx->sdata->name, sta->sta.addr);
-	}
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
 	return TX_CONTINUE;
 }
@@ -1963,7 +1954,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		     (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
 		      !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		net_dbg_ratelimited("%s: dropped frame to %pM (unauthorized port)\n",
+		net_info_ratelimited("%s: dropped frame to %pM (unauthorized port)\n",
 				    dev->name, hdr.addr1);
 #endif
 
-- 
1.7.10

