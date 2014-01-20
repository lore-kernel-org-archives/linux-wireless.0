Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:56114 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaATOZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:25:43 -0500
Received: by mail-ea0-f172.google.com with SMTP id g15so2573090eak.17
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:25:42 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/7] mac80211: improve CSA locking
Date: Mon, 20 Jan 2014 15:21:08 +0100
Message-Id: <1390227670-19030-6-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152549_144003_64462720)
In-Reply-To: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch improves channel switch related locking
(STA, IBSS, AP, mesh).

Now read access to sdata->vif.csa_active is
protected by wdev.mtx and local->mtx so holding
either is enough for read access but both are
required for write access. Keep in mind sdata lock
must be taken before local->mtx. Taking them in
reverse order creates a deadlock situation.

The only exception is ieee80211_beacon_get_tim()
but it's safe to leave it as is and it doesn't
influence mac80211 state in any way.

The patch adds a few lockdep assertions along for
easier code/locking maintenance.

This also prepares for multi-interface CSA.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c   | 22 +++++++++++++++++++---
 net/mac80211/ibss.c  | 18 ++++++++++++++----
 net/mac80211/iface.c | 28 ++++++++++++++++++++++++++--
 net/mac80211/mesh.c  | 18 ++++++++++++++++--
 net/mac80211/mlme.c  | 20 ++++++++++++++------
 5 files changed, 89 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ddb1c4d..29692f6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1053,6 +1053,7 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	int err;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sdata_assert_lock(sdata);
 
 	/* don't allow changing the beacon while CSA is in place - offset
 	 * of channel switch counter may change
@@ -1080,15 +1081,19 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	struct probe_resp *old_probe_resp;
 	struct cfg80211_chan_def chandef;
 
+	sdata_assert_lock(sdata);
+
 	old_beacon = sdata_dereference(sdata->u.ap.beacon, sdata);
 	if (!old_beacon)
 		return -ENOENT;
 	old_probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
 	/* abort any running channel switch */
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
 	kfree(sdata->u.ap.next_beacon);
 	sdata->u.ap.next_beacon = NULL;
+	mutex_unlock(&local->mtx);
 
 	cancel_work_sync(&sdata->u.ap.request_smps_work);
 
@@ -2992,6 +2997,8 @@ static int ieee80211_ap_finish_csa(struct ieee80211_sub_if_data *sdata)
 {
 	int err;
 
+	lockdep_assert_held(&sdata->local->mtx);
+
 	err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
 	kfree(sdata->u.ap.next_beacon);
 	sdata->u.ap.next_beacon = NULL;
@@ -3017,10 +3024,12 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	int err, changed = 0;
 
-	mutex_lock(&local->mtx);
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
+
 	sdata->radar_required = sdata->csa_radar_required;
+
 	err = ieee80211_vif_change_channel(sdata, &changed);
-	mutex_unlock(&local->mtx);
 	if (WARN_ON(err < 0))
 		return;
 
@@ -3069,6 +3078,8 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 			     csa_finalize_work);
 
 	sdata_lock(sdata);
+	mutex_lock(&sdata->local->mtx);
+
 	/* AP might have been stopped while waiting for the lock. */
 	if (!sdata->vif.csa_active)
 		goto unlock;
@@ -3079,6 +3090,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	ieee80211_csa_finalize(sdata);
 
 unlock:
+	mutex_unlock(&sdata->local->mtx);
 	sdata_unlock(sdata);
 }
 
@@ -3092,7 +3104,8 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_if_mesh __maybe_unused *ifmsh;
 	int err, num_chanctx, changed = 0;
 
-	lockdep_assert_held(&sdata->wdev.mtx);
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
 
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
@@ -3278,8 +3291,11 @@ int ieee80211_channel_switch(struct wiphy *wiphy,
 		return -EOPNOTSUPP;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(params[0].dev);
+
 	sdata_lock(sdata);
+	mutex_lock(&sdata->local->mtx);
 	err = __ieee80211_channel_switch(wiphy, params[0].dev, &params[0]);
+	mutex_unlock(&sdata->local->mtx);
 	sdata_unlock(sdata);
 
 	return err;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 4854800..003434a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -796,6 +796,12 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	int err;
 	u32 sta_flags;
 
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&sdata->local->mtx);
+
+	if (sdata->vif.csa_active)
+		return true;
+
 	sta_flags = IEEE80211_STA_DISABLE_VHT;
 	switch (ifibss->chandef.width) {
 	case NL80211_CHAN_WIDTH_5:
@@ -937,8 +943,9 @@ ieee80211_rx_mgmt_spectrum_mgmt(struct ieee80211_sub_if_data *sdata,
 	if (len < required_len)
 		return;
 
-	if (!sdata->vif.csa_active)
-		ieee80211_ibss_process_chanswitch(sdata, elems, false);
+	mutex_lock(&sdata->local->mtx);
+	ieee80211_ibss_process_chanswitch(sdata, elems, false);
+	mutex_unlock(&sdata->local->mtx);
 }
 
 static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
@@ -1119,9 +1126,12 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		goto put_bss;
 
 	/* process channel switch */
-	if (sdata->vif.csa_active ||
-	    ieee80211_ibss_process_chanswitch(sdata, elems, true))
+	mutex_lock(&local->mtx);
+	if (ieee80211_ibss_process_chanswitch(sdata, elems, true)) {
+		mutex_unlock(&local->mtx);
 		goto put_bss;
+	}
+	mutex_unlock(&local->mtx);
 
 	/* same BSSID */
 	if (ether_addr_equal(cbss->bssid, sdata->u.ibss.bssid))
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0aa9675..5583987 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -250,14 +250,19 @@ static inline int identical_mac_addr_allowed(int type1, int type2)
 			 type2 == NL80211_IFTYPE_AP_VLAN));
 }
 
-static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
-					    enum nl80211_iftype iftype)
+static int
+__ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
+				   enum nl80211_iftype iftype)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *nsdata;
 
 	ASSERT_RTNL();
 
+	/* access to vif.csa_active must be protected by sdata or local->mtx.
+	 * this interates over interfaces so sdata lock won't do */
+	lockdep_assert_held(&local->mtx);
+
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		if (nsdata != sdata && ieee80211_sdata_running(nsdata)) {
@@ -308,6 +313,21 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
+					    enum nl80211_iftype iftype)
+{
+	struct ieee80211_local *local = sdata->local;
+	int err;
+
+	ASSERT_RTNL();
+
+	mutex_lock(&local->mtx);
+	err = __ieee80211_check_concurrent_iface(sdata, iftype);
+	mutex_unlock(&local->mtx);
+
+	return err;
+}
+
 static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata,
 				  enum nl80211_iftype iftype)
 {
@@ -822,7 +842,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	cancel_work_sync(&sdata->recalc_smps);
+	sdata_lock(sdata);
+	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
+	mutex_unlock(&local->mtx);
+	sdata_unlock(sdata);
 	cancel_work_sync(&sdata->csa_finalize_work);
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 98bcd2b..4617bf8 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -864,6 +864,12 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	int err;
 	u32 sta_flags;
 
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&sdata->local->mtx);
+
+	if (sdata->vif.csa_active)
+		return true;
+
 	sta_flags = IEEE80211_STA_DISABLE_VHT;
 	switch (sdata->vif.bss_conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
@@ -933,6 +939,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 		return false;
 
 	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_REPEATER;
+	sdata->csa_chandef = params.chandef;
 
 	if (__ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
 				       &params) < 0)
@@ -1048,9 +1055,11 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
 
+	mutex_lock(&sdata->local->mtx);
 	if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
 	    !sdata->vif.csa_active)
 		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
+	mutex_unlock(&sdata->local->mtx);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
@@ -1148,6 +1157,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	bool fwd_csa = true;
 	size_t baselen;
 	u8 *pos;
+	bool csa_ok = true;
 
 	if (mgmt->u.action.u.measurement.action_code !=
 	    WLAN_ACTION_SPCT_CHL_SWITCH)
@@ -1168,8 +1178,12 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 
 	ifmsh->pre_value = pre_value;
 
-	if (!sdata->vif.csa_active &&
-	    !ieee80211_mesh_process_chnswitch(sdata, &elems, false)) {
+	mutex_lock(&sdata->local->mtx);
+	if (!sdata->vif.csa_active)
+		csa_ok = ieee80211_mesh_process_chnswitch(sdata, &elems, false);
+	mutex_unlock(&sdata->local->mtx);
+
+	if (!csa_ok) {
 		mcsa_dbg(sdata, "Failed to process CSA action frame");
 		return;
 	}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bfb81cb..d898dc9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -885,12 +885,11 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		return;
 
 	sdata_lock(sdata);
+	mutex_lock(&local->mtx);
 	if (!ifmgd->associated)
 		goto out;
 
-	mutex_lock(&local->mtx);
 	ret = ieee80211_vif_change_channel(sdata, &changed);
-	mutex_unlock(&local->mtx);
 	if (ret) {
 		sdata_info(sdata,
 			   "vif channel switch failed, disconnecting\n");
@@ -923,6 +922,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
  out:
 	sdata->vif.csa_active = false;
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
 
@@ -965,6 +965,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	int res;
 
 	sdata_assert_lock(sdata);
+	lockdep_assert_held(&sdata->local->mtx);
 
 	if (!cbss)
 		return;
@@ -1987,10 +1988,9 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	sdata_lock(sdata);
-	if (!ifmgd->associated) {
-		sdata_unlock(sdata);
-		return;
-	}
+	mutex_lock(&sdata->local->mtx);
+	if (!ifmgd->associated)
+		goto out;
 
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
@@ -2003,6 +2003,8 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 
 	cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
 			      IEEE80211_DEAUTH_FRAME_LEN);
+out:
+	mutex_unlock(&sdata->local->mtx);
 	sdata_unlock(sdata);
 }
 
@@ -2969,8 +2971,10 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 
+	mutex_lock(&local->mtx);
 	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
 					 &elems, true);
+	mutex_unlock(&local->mtx);
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_WMM) &&
 	    ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
@@ -3101,9 +3105,11 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			if (elems.parse_error)
 				break;
 
+			mutex_lock(&sdata->local->mtx);
 			ieee80211_sta_process_chanswitch(sdata,
 							 rx_status->mactime,
 							 &elems, false);
+			mutex_unlock(&sdata->local->mtx);
 		} else if (mgmt->u.action.category == WLAN_CATEGORY_PUBLIC) {
 			ies_len = skb->len -
 				  offsetof(struct ieee80211_mgmt,
@@ -3123,9 +3129,11 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			elems.ext_chansw_ie =
 				&mgmt->u.action.u.ext_chan_switch.data;
 
+			mutex_lock(&sdata->local->mtx);
 			ieee80211_sta_process_chanswitch(sdata,
 							 rx_status->mactime,
 							 &elems, false);
+			mutex_unlock(&sdata->local->mtx);
 		}
 		break;
 	}
-- 
1.8.4.rc3

