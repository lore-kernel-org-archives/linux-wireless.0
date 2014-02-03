Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45584 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbaBCKDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 05:03:53 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so3512037eek.31
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 02:03:52 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 1/2] mac80211: merge STA CSA code
Date: Mon,  3 Feb 2014 10:58:48 +0100
Message-Id: <1391421529-6067-2-git-send-email-michal.kazior@tieto.com> (sfid-20140203_110357_306453_068C1B90)
In-Reply-To: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Managed interface channel switching code was
mostly redundant.

This makes it easier to do more channel switching
code refactoring.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h     |   5 ++
 net/mac80211/cfg.c         | 110 +++++++++++++++++++++++++++++--------
 net/mac80211/ibss.c        |   7 ++-
 net/mac80211/ieee80211_i.h |   6 ++-
 net/mac80211/mesh.c        |   7 ++-
 net/mac80211/mlme.c        | 132 +++++++++++----------------------------------
 net/wireless/nl80211.c     |   4 +-
 7 files changed, 143 insertions(+), 128 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 459700e..f6651a2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -686,6 +686,10 @@ struct cfg80211_ap_settings {
  * @radar_required: whether radar detection is required on the new channel
  * @block_tx: whether transmissions should be blocked while changing
  * @count: number of beacons until switch
+ * @timestamp: value in microseconds of the 64-bit Time Synchronization
+ *	Function (TSF) timer when the frame containing the channel switch
+ *	announcement was received. This is simply the rx.mactime parameter
+ *	the driver passed in.
  */
 struct cfg80211_csa_settings {
 	struct cfg80211_chan_def chandef;
@@ -695,6 +699,7 @@ struct cfg80211_csa_settings {
 	bool radar_required;
 	bool block_tx;
 	u8 count;
+	u64 timestamp;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 875e63d..dff4d3a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3000,9 +3000,10 @@ void ieee80211_csa_finish(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(ieee80211_csa_finish);
 
-static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	int err, changed = 0;
 
 	sdata_assert_lock(sdata);
@@ -3011,51 +3012,89 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
 	mutex_unlock(&local->mtx);
-	if (WARN_ON(err < 0))
-		return;
+
+	sdata->vif.csa_active = false;
+
+	if (WARN_ON(err < 0)) {
+		sdata_info(sdata, "vif channel switch failed\n");
+		return err;
+	}
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = sdata->csa_chandef;
-		ieee80211_hw_config(local, 0);
+		/* XXX: Needs more work for multi-interface support */
+		if (local->ops->channel_switch &&
+		    (sdata->vif.type == NL80211_IFTYPE_STATION ||
+		     sdata->vif.type == NL80211_IFTYPE_P2P_CLIENT))
+			local->hw.conf.chandef = local->_oper_chandef;
+		else
+			ieee80211_hw_config(local, 0);
 	}
 
-	sdata->vif.csa_active = false;
 	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		/* XXX: shouldn't really modify cfg80211-owned data! */
+		ifmgd->associated->channel = sdata->csa_chandef.chan;
+
+		ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+		break;
 	case NL80211_IFTYPE_AP:
 		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
 		kfree(sdata->u.ap.next_beacon);
 		sdata->u.ap.next_beacon = NULL;
 
 		if (err < 0)
-			return;
+			return err;
 		changed |= err;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		err = ieee80211_ibss_finish_csa(sdata);
 		if (err < 0)
-			return;
+			return err;
 		changed |= err;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 		err = ieee80211_mesh_finish_csa(sdata);
 		if (err < 0)
-			return;
+			return err;
 		changed |= err;
 		break;
 #endif
 	default:
 		WARN_ON(1);
-		return;
+		return -EINVAL;
 	}
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	/* XXX: wait for a beacon before continuing if there's at least one
+	 * managed interface taking part in the switch? */
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
+
+	return 0;
+}
+
+void ieee80211_csa_disconnect(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		ieee80211_queue_work(&local->hw,
+				     &ifmgd->csa_connection_drop_work);
+		break;
+	default:
+		/* XXX: other iftypes should be halted too */
+		break;
+	}
 }
 
 void ieee80211_csa_finalize_work(struct work_struct *work)
@@ -3063,6 +3102,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
 			     csa_finalize_work);
+	int err;
 
 	sdata_lock(sdata);
 	/* AP might have been stopped while waiting for the lock. */
@@ -3072,16 +3112,17 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		goto unlock;
 
-	ieee80211_csa_finalize(sdata);
+	err = ieee80211_csa_finalize(sdata);
+	if (err)
+		ieee80211_csa_disconnect(sdata);
 
 unlock:
 	sdata_unlock(sdata);
 }
 
-int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			     struct cfg80211_csa_settings *params)
+int __ieee80211_channel_switch(struct ieee80211_sub_if_data *sdata,
+			       struct cfg80211_csa_settings *params)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_chanctx *chanctx;
@@ -3089,6 +3130,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	int err, num_chanctx, changed = 0;
 
 	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->chanctx_mtx);
 
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
@@ -3100,32 +3142,44 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				       &sdata->vif.bss_conf.chandef))
 		return -EINVAL;
 
-	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (!chanctx_conf) {
-		rcu_read_unlock();
+	if (WARN_ON(!chanctx_conf))
 		return -EBUSY;
-	}
 
 	/* don't handle for multi-VIF cases */
 	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
 	if (chanctx->refcount > 1) {
-		rcu_read_unlock();
+		sdata_info(sdata,
+			   "channel switch with multiple interfaces on the same channel\n");
 		return -EBUSY;
 	}
+
 	num_chanctx = 0;
 	list_for_each_entry_rcu(chanctx, &local->chanctx_list, list)
 		num_chanctx++;
-	rcu_read_unlock();
 
-	if (num_chanctx > 1)
-		return -EBUSY;
+	if (num_chanctx > 1) {
+		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+		    sdata->vif.type == NL80211_IFTYPE_P2P_CLIENT) {
+			if (!(local->hw.flags & IEEE80211_HW_CHANCTX_STA_CSA)) {
+				sdata_info(sdata,
+					   "not handling chan-switch with channel contexts\n");
+				return -EBUSY;
+			}
+		} else {
+			return -EBUSY;
+		}
+	}
 
 	/* don't allow another channel switch if one is already active. */
 	if (sdata->vif.csa_active)
 		return -EBUSY;
 
 	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		ieee80211_sta_chswitch_schedule(sdata, params);
+		break;
 	case NL80211_IFTYPE_AP:
 		sdata->u.ap.next_beacon =
 			cfg80211_beacon_dup(&params->beacon_after);
@@ -3259,6 +3313,20 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+				    struct cfg80211_csa_settings *params)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int err;
+
+	mutex_lock(&local->chanctx_mtx);
+	err = __ieee80211_channel_switch(sdata, params);
+	mutex_unlock(&local->chanctx_mtx);
+
+	return err;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct cfg80211_mgmt_tx_params *params,
 			     u64 *cookie)
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8e44447..a86e278 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -896,8 +896,11 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	params.block_tx = !!csa_ie.mode;
 
-	if (ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
-				     &params))
+	mutex_lock(&sdata->local->chanctx_mtx);
+	err = __ieee80211_channel_switch(sdata, &params);
+	mutex_unlock(&sdata->local->chanctx_mtx);
+
+	if (err < 0)
 		goto disconnect;
 
 	ieee80211_ibss_csa_mark_radar(sdata);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d37dc75..9a06580 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1460,8 +1460,10 @@ void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
 /* channel switch handling */
 void ieee80211_csa_finalize_work(struct work_struct *work);
-int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			     struct cfg80211_csa_settings *params);
+int __ieee80211_channel_switch(struct ieee80211_sub_if_data *sdata,
+			       struct cfg80211_csa_settings *params);
+void ieee80211_sta_chswitch_schedule(struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_csa_settings *params);
 
 /* interface handling */
 int ieee80211_iface_init(void);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f70e9cd..43dc808 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -936,8 +936,11 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 
 	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_REPEATER;
 
-	if (ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
-				     &params) < 0)
+	mutex_lock(&sdata->local->chanctx_mtx);
+	err = __ieee80211_channel_switch(sdata, &params);
+	mutex_unlock(&sdata->local->chanctx_mtx);
+
+	if (err < 0)
 		return false;
 
 	return true;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6c9ebca..3aaf2f2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -882,61 +882,6 @@ static void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-/* spectrum management related things */
-static void ieee80211_chswitch_work(struct work_struct *work)
-{
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u32 changed = 0;
-	int ret;
-
-	if (!ieee80211_sdata_running(sdata))
-		return;
-
-	sdata_lock(sdata);
-	if (!ifmgd->associated)
-		goto out;
-
-	mutex_lock(&local->mtx);
-	ret = ieee80211_vif_change_channel(sdata, &changed);
-	mutex_unlock(&local->mtx);
-	if (ret) {
-		sdata_info(sdata,
-			   "vif channel switch failed, disconnecting\n");
-		ieee80211_queue_work(&sdata->local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		goto out;
-	}
-
-	if (!local->use_chanctx) {
-		local->_oper_chandef = sdata->csa_chandef;
-		/* Call "hw_config" only if doing sw channel switch.
-		 * Otherwise update the channel directly
-		 */
-		if (!local->ops->channel_switch)
-			ieee80211_hw_config(local, 0);
-		else
-			local->hw.conf.chandef = local->_oper_chandef;
-	}
-
-	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->csa_chandef.chan;
-
-	/* XXX: wait for a beacon first? */
-	ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
-
-	ieee80211_bss_info_change_notify(sdata, changed);
-
- out:
-	sdata->vif.csa_active = false;
-	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
-	sdata_unlock(sdata);
-}
-
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
@@ -949,7 +894,8 @@ void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 		ieee80211_queue_work(&sdata->local->hw,
 				     &ifmgd->csa_connection_drop_work);
 	} else {
-		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->csa_finalize_work);
 	}
 }
 EXPORT_SYMBOL(ieee80211_chswitch_done);
@@ -959,7 +905,7 @@ static void ieee80211_chswitch_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.chswitch_work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->csa_finalize_work);
 }
 
 static void
@@ -970,9 +916,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_bss *cbss = ifmgd->associated;
-	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band current_band;
 	struct ieee80211_csa_ie csa_ie;
+	struct cfg80211_csa_settings params;
 	int res;
 
 	sdata_assert_lock(sdata);
@@ -998,6 +944,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (res)
 		return;
 
+	/* FIXME: This check should be moved to cfg80211 */
 	if (!cfg80211_chandef_usable(local->hw.wiphy, &csa_ie.chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
@@ -1013,56 +960,41 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
 
-	mutex_lock(&local->chanctx_mtx);
-	if (local->use_chanctx) {
-		u32 num_chanctx = 0;
-		list_for_each_entry(chanctx, &local->chanctx_list, list)
-		       num_chanctx++;
+	memset(&params, 0, sizeof(params));
+	params.chandef = csa_ie.chandef;
+	params.block_tx = !!(csa_ie.mode);
+	params.timestamp = timestamp;
+	params.count = csa_ie.count;
 
-		if (num_chanctx > 1 ||
-		    !(local->hw.flags & IEEE80211_HW_CHANCTX_STA_CSA)) {
-			sdata_info(sdata,
-				   "not handling chan-switch with channel contexts\n");
-			ieee80211_queue_work(&local->hw,
-					     &ifmgd->csa_connection_drop_work);
-			mutex_unlock(&local->chanctx_mtx);
-			return;
-		}
-	}
+	mutex_lock(&local->chanctx_mtx);
+	res = __ieee80211_channel_switch(sdata, &params);
+	mutex_unlock(&local->chanctx_mtx);
 
-	if (WARN_ON(!rcu_access_pointer(sdata->vif.chanctx_conf))) {
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&local->chanctx_mtx);
-		return;
-	}
-	chanctx = container_of(rcu_access_pointer(sdata->vif.chanctx_conf),
-			       struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1) {
-		sdata_info(sdata,
-			   "channel switch with multiple interfaces on the same channel, disconnecting\n");
+	if (res) {
+		sdata_info(sdata, "channel switch failed: %d, disconnecting",
+			   res);
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
-		mutex_unlock(&local->chanctx_mtx);
-		return;
 	}
-	mutex_unlock(&local->chanctx_mtx);
+}
 
-	sdata->csa_chandef = csa_ie.chandef;
-	sdata->vif.csa_active = true;
+void ieee80211_sta_chswitch_schedule(struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_csa_settings *params)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct cfg80211_bss *cbss = ifmgd->associated;
 
-	if (csa_ie.mode)
-		ieee80211_stop_queues_by_reason(&local->hw,
-				IEEE80211_MAX_QUEUE_MAP,
-				IEEE80211_QUEUE_STOP_REASON_CSA);
+	sdata_assert_lock(sdata);
 
+	/* XXX: This needs more work for multi-interface support */
 	if (local->ops->channel_switch) {
 		/* use driver's channel switch callback */
 		struct ieee80211_channel_switch ch_switch = {
-			.timestamp = timestamp,
-			.block_tx = csa_ie.mode,
-			.chandef = csa_ie.chandef,
-			.count = csa_ie.count,
+			.timestamp = params->timestamp,
+			.block_tx = params->block_tx,
+			.chandef = params->chandef,
+			.count = params->count,
 		};
 
 		drv_channel_switch(local, &ch_switch);
@@ -1070,11 +1002,11 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* channel switch handled in software */
-	if (csa_ie.count <= 1)
+	if (params->count <= 1)
 		ieee80211_queue_work(&local->hw, &ifmgd->chswitch_work);
 	else
 		mod_timer(&ifmgd->chswitch_timer,
-			  TU_TO_EXP_TIME(csa_ie.count * cbss->beacon_interval));
+			  TU_TO_EXP_TIME(params->count * cbss->beacon_interval));
 }
 
 static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
@@ -1758,6 +1690,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.timer);
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
 
+	sdata->vif.csa_active = false;
 	sdata->vif.bss_conf.dtim_period = 0;
 	sdata->vif.bss_conf.beacon_rate = NULL;
 
@@ -3523,7 +3456,6 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 
 	ifmgd = &sdata->u.mgd;
 	INIT_WORK(&ifmgd->monitor_work, ieee80211_sta_monitor_work);
-	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_connection_loss_work,
 		  ieee80211_beacon_connection_loss_work);
 	INIT_WORK(&ifmgd->csa_connection_drop_work,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8b32a1f..28ab3a9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11240,7 +11240,9 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
 		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
 		    wdev->iftype != NL80211_IFTYPE_ADHOC &&
-		    wdev->iftype != NL80211_IFTYPE_MESH_POINT))
+		    wdev->iftype != NL80211_IFTYPE_MESH_POINT &&
+		    wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
 		return;
 
 	wdev->channel = chandef->chan;
-- 
1.8.5.3

