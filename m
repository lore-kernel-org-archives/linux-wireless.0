Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:63936 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaAOMJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 07:09:30 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so417849ead.24
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 04:09:28 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 5/9] mac80211: improve CSA locking
Date: Wed, 15 Jan 2014 13:04:50 +0100
Message-Id: <1389787494-7361-6-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130939_357564_20DF7334)
In-Reply-To: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch improves channel switch related locking
(STA, IBSS, AP, mesh).

Now read access to sdata->vif.csa_active is
protected by wdev.mtx and local->mtx so holding
either is enough for read access but both are
required for write access.

The only exception is ieee80211_beacon_get_tim()
but it's safe to leave it as is and it doesn't
influence mac80211 state in any way.

The patch adds a few lockdep assertions along for
easier code/locking maintenance.

This also prepares for multi-interface CSA.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c   | 18 +++++++++++++++---
 net/mac80211/ibss.c  | 18 ++++++++++++++----
 net/mac80211/iface.c | 27 +++++++++++++++++++++++++--
 net/mac80211/mesh.c  | 13 ++++++++++++-
 net/mac80211/mlme.c  | 20 ++++++++++++++------
 5 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ef679de..9a2421d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1052,6 +1052,7 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	int err;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sdata_assert_lock(sdata);
 
 	/* don't allow changing the beacon while CSA is in place - offset
 	 * of channel switch counter may change
@@ -1079,15 +1080,19 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
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
 
@@ -2991,6 +2996,8 @@ static int ieee80211_ap_finish_csa(struct ieee80211_sub_if_data *sdata)
 {
 	int err;
 
+	lockdep_assert_held(&sdata->local->mtx);
+
 	err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
 	kfree(sdata->u.ap.next_beacon);
 	sdata->u.ap.next_beacon = NULL;
@@ -3011,6 +3018,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	int err, changed = 0;
 
 	sdata_lock(sdata);
+	mutex_lock(&local->mtx);
 	/* AP might have been stopped while waiting for the lock. */
 	if (!sdata->vif.csa_active)
 		goto unlock;
@@ -3018,10 +3026,9 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		goto unlock;
 
-	mutex_lock(&local->mtx);
 	sdata->radar_required = sdata->csa_radar_required;
+
 	err = ieee80211_vif_change_channel(sdata, &changed);
-	mutex_unlock(&local->mtx);
 	if (WARN_ON(err < 0))
 		goto unlock;
 
@@ -3063,6 +3070,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 
 unlock:
+	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
 
@@ -3076,7 +3084,8 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_if_mesh __maybe_unused *ifmsh;
 	int err, num_chanctx;
 
-	lockdep_assert_held(&sdata->wdev.mtx);
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
 
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
@@ -3219,8 +3228,11 @@ int ieee80211_channel_switch(struct wiphy *wiphy,
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
index d1dc641..706b666 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -802,6 +802,12 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
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
@@ -943,8 +949,9 @@ ieee80211_rx_mgmt_spectrum_mgmt(struct ieee80211_sub_if_data *sdata,
 	if (len < required_len)
 		return;
 
-	if (!sdata->vif.csa_active)
-		ieee80211_ibss_process_chanswitch(sdata, elems, false);
+	mutex_lock(&sdata->local->mtx);
+	ieee80211_ibss_process_chanswitch(sdata, elems, false);
+	mutex_unlock(&sdata->local->mtx);
 }
 
 static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
@@ -1125,9 +1132,12 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
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
index 0aa9675..a339334 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -250,14 +250,18 @@ static inline int identical_mac_addr_allowed(int type1, int type2)
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
 
+	/* access to vif.csa_active should be protected with `local->mtx` */
+	lockdep_assert_held(&local->mtx);
+
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		if (nsdata != sdata && ieee80211_sdata_running(nsdata)) {
@@ -308,6 +312,21 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
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
@@ -822,7 +841,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
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
index 5a74b24..fa758dc 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -865,6 +865,9 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	int err, num_chanctx;
 	u32 sta_flags;
 
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&sdata->local->mtx);
+
 	if (sdata->vif.csa_active)
 		return true;
 
@@ -967,6 +970,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
 
 	sdata->csa_chandef = params.chandef;
+
 	sdata->vif.csa_active = true;
 
 	ieee80211_bss_info_change_notify(sdata, err);
@@ -1085,8 +1089,10 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
 
+	mutex_lock(&sdata->local->mtx);
 	if (!ifmsh->chsw_init)
 		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
+	mutex_unlock(&sdata->local->mtx);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
@@ -1189,6 +1195,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	bool fwd_csa = true;
 	size_t baselen;
 	u8 *pos;
+	int err;
 
 	if (mgmt->u.action.u.measurement.action_code !=
 	    WLAN_ACTION_SPCT_CHL_SWITCH)
@@ -1209,7 +1216,11 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 
 	ifmsh->pre_value = pre_value;
 
-	if (!ieee80211_mesh_process_chnswitch(sdata, &elems, false)) {
+	mutex_lock(&sdata->local->mtx);
+	err = ieee80211_mesh_process_chnswitch(sdata, &elems, false);
+	mutex_unlock(&sdata->local->mtx);
+
+	if (!err) {
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

