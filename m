Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:65179 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAOMJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 07:09:34 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so416715ead.20
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 04:09:33 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 9/9] mac80211: implement multi-interface CSA
Date: Wed, 15 Jan 2014 13:04:54 +0100
Message-Id: <1389787494-7361-10-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130947_042758_926811DD)
In-Reply-To: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements a fairly simple multi-interface
CSA. It doesn't support multiple channel
contexts so it doesn't support multi-channel.

Once a CSA is started other CSA requests are
denied until the first one is completed. A single
CSA may affect multiple interfaces. CSA can happen
only if it all target CSA chandefs are compatible
and it affects all interfaces are sharing a single
channel context exclusively.

A new worker is introduced: csa_complete_work
which is used to account per-interface countdowns
and issue the actual channel switch after last
interface completes its CSA.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         | 364 ++++++++++++++++++++++++++++++++++++---------
 net/mac80211/chan.c        | 117 +++++++++++----
 net/mac80211/ibss.c        |   2 +-
 net/mac80211/ieee80211_i.h |  23 ++-
 net/mac80211/iface.c       |   5 +-
 net/mac80211/mlme.c        |   9 +-
 net/mac80211/tx.c          |  10 +-
 7 files changed, 419 insertions(+), 111 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 13d1624..873c57d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1093,9 +1093,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	/* abort any running channel switch */
 	mutex_lock(&local->mtx);
-	sdata->vif.csa_active = false;
-	kfree(sdata->u.ap.next_beacon);
-	sdata->u.ap.next_beacon = NULL;
+	ieee80211_csa_clear(sdata);
+	ieee80211_csa_free(sdata);
 	mutex_unlock(&local->mtx);
 
 	cancel_work_sync(&sdata->u.ap.request_smps_work);
@@ -3001,15 +3000,79 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 	return new_beacon;
 }
 
+static int ieee80211_ap_beacon_presp_backup(struct ieee80211_sub_if_data *sdata)
+{
+	struct beacon_data *beacon;
+	struct probe_resp *probe_resp;
+
+	beacon = sdata_dereference(sdata->u.ap.beacon, sdata);
+	if (beacon) {
+		sdata->u.ap.prev_beacon = kmemdup(beacon, sizeof(beacon) +
+						  beacon->head_len +
+						  beacon->tail_len, GFP_KERNEL);
+		if (!sdata->u.ap.prev_beacon)
+			return -ENOMEM;
+	}
+
+	probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
+	if (probe_resp) {
+		sdata->u.ap.prev_presp = kmemdup(probe_resp,
+						 sizeof(probe_resp) +
+						 probe_resp->len, GFP_KERNEL);
+		if (!sdata->u.ap.prev_presp) {
+			kfree(sdata->u.ap.prev_beacon);
+			sdata->u.ap.prev_beacon = NULL;
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static int ieee80211_ap_beacon_presp_restore(struct ieee80211_sub_if_data *sdata)
+{
+	struct beacon_data *beacon;
+	struct probe_resp *probe_resp;
+	int changed = 0;
+
+	if (sdata->u.ap.prev_beacon) {
+		beacon = sdata_dereference(sdata->u.ap.beacon, sdata);
+		rcu_assign_pointer(sdata->u.ap.beacon, sdata->u.ap.prev_beacon);
+		if (beacon)
+			kfree_rcu(beacon, rcu_head);
+		sdata->u.ap.prev_beacon = NULL;
+		changed |= BSS_CHANGED_BEACON;
+	}
+
+	if (sdata->u.ap.prev_presp) {
+		probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
+		rcu_assign_pointer(sdata->u.ap.probe_resp, sdata->u.ap.prev_presp);
+		if (probe_resp)
+			kfree_rcu(probe_resp, rcu_head);
+		sdata->u.ap.prev_presp = NULL;
+		changed |= BSS_CHANGED_AP_PROBE_RESP;
+	}
+
+	return changed;
+}
+
 static int ieee80211_ap_finish_csa(struct ieee80211_sub_if_data *sdata)
 {
-	int err;
+	int err = 0;
 
 	lockdep_assert_held(&sdata->local->mtx);
 
-	err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+	if (sdata->u.ap.next_beacon)
+		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+	else
+		err = ieee80211_ap_beacon_presp_restore(sdata);
+
 	kfree(sdata->u.ap.next_beacon);
+	kfree(sdata->u.ap.prev_beacon);
+	kfree(sdata->u.ap.prev_presp);
 	sdata->u.ap.next_beacon = NULL;
+	sdata->u.ap.prev_beacon = NULL;
+	sdata->u.ap.prev_presp = NULL;
 
 	if (err < 0)
 		return err;
@@ -3018,88 +3081,227 @@ static int ieee80211_ap_finish_csa(struct ieee80211_sub_if_data *sdata)
 	return 0;
 }
 
-void ieee80211_csa_finalize_work(struct work_struct *work)
+void ieee80211_csa_clear(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data,
-			     csa_finalize_work);
 	struct ieee80211_local *local = sdata->local;
-	int err, changed = 0;
 
-	sdata_lock(sdata);
-	mutex_lock(&local->mtx);
-	/* AP might have been stopped while waiting for the lock. */
-	if (!sdata->vif.csa_active)
-		goto unlock;
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
 
-	if (!ieee80211_sdata_running(sdata))
-		goto unlock;
+	sdata->vif.csa_active = false;
+	sdata->csa_complete = false;
+
+	/* unblock queues when last CSA interface is cleared (either finalizes
+	 * or is cancelled) */
+	if (!ieee80211_is_csa_active(local))
+		ieee80211_wake_queues_by_reason(&local->hw,
+						IEEE80211_MAX_QUEUE_MAP,
+						IEEE80211_QUEUE_STOP_REASON_CSA);
+}
 
-	sdata->radar_required = sdata->csa_radar_required;
+void ieee80211_csa_free(struct ieee80211_sub_if_data *sdata)
+{
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&sdata->local->mtx);
 
-	err = ieee80211_vif_change_channel(sdata, &changed);
-	if (WARN_ON(err < 0))
-		goto unlock;
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
+		return;
 
-	if (!local->use_chanctx) {
-		local->_oper_chandef = sdata->csa_chandef;
-		ieee80211_hw_config(local, 0);
-	}
+	kfree(sdata->u.ap.next_beacon);
+	kfree(sdata->u.ap.prev_beacon);
+	kfree(sdata->u.ap.prev_presp);
+	sdata->u.ap.next_beacon = NULL;
+	sdata->u.ap.prev_beacon = NULL;
+	sdata->u.ap.prev_presp = NULL;
+}
 
-	ieee80211_bss_info_change_notify(sdata, changed);
+static int ieee80211_csa_finish_beacon(struct ieee80211_sub_if_data *sdata)
+{
+	int err;
+
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&sdata->local->mtx);
 
-	sdata->vif.csa_active = false;
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
 		err = ieee80211_ap_finish_csa(sdata);
 		if (err < 0)
-			goto unlock;
+			return err;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		err = ieee80211_ibss_finish_csa(sdata);
 		if (err < 0)
-			goto unlock;
+			return err;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 		err = ieee80211_mesh_finish_csa(sdata);
 		if (err < 0)
-			goto unlock;
+			return err;
 		break;
 #endif
 	default:
 		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void ieee80211_csa_finalize_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     csa_finalize_work);
+	struct ieee80211_local *local = sdata->local;
+	int err, changed = 0;
+
+	sdata_lock(sdata);
+	mutex_lock(&local->mtx);
+
+	if (!ieee80211_sdata_running(sdata))
+		goto unlock;
+
+	if (!sdata->vif.csa_active)
+		goto unlock;
+
+	if (sdata->vif.bss_conf.chandef.width != sdata->csa_chandef.width)
+		changed |= BSS_CHANGED_BANDWIDTH;
+
+	/* channel switch is called for each sdata csa is being performed, but
+	 * this shouldn't be a problem */
+	mutex_lock(&local->chanctx_mtx);
+	err = ieee80211_chanctx_chswitch(local);
+	mutex_unlock(&local->chanctx_mtx);
+
+	if (WARN_ON(err < 0))
 		goto unlock;
+
+	if (!local->use_chanctx) {
+		local->_oper_chandef = sdata->csa_chandef;
+		ieee80211_hw_config(local, 0);
 	}
 
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	err = ieee80211_csa_finish_beacon(sdata);
+	if (err)
+		goto unlock;
 
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 
 unlock:
+	ieee80211_csa_clear(sdata);
+
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 }
 
+static bool ieee80211_is_csa_complete(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int num_active = 0;
+	int num_complete = 0;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->iflist_mtx);
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.csa_active)
+			num_active++;
+		if (sdata->csa_complete)
+			num_complete++;
+	}
+
+	if (num_active == 0)
+		return false;
+	if (num_active != num_complete)
+		return false;
+
+	return true;
+}
+
+static void ieee80211_queue_csa_finalize(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->iflist_mtx);
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		if (!sdata->vif.csa_active)
+			continue;
+
+		ieee80211_queue_work(&local->hw, &sdata->csa_finalize_work);
+	}
+}
+
+void ieee80211_csa_complete_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     csa_complete_work);
+	struct ieee80211_local *local = sdata->local;
+
+	mutex_lock(&local->mtx);
+	mutex_lock(&local->iflist_mtx);
+
+	if (sdata->vif.csa_active)
+		sdata->csa_complete = true;
+
+	if (ieee80211_is_csa_complete(sdata->local))
+		ieee80211_queue_csa_finalize(sdata->local);
+
+	mutex_unlock(&local->iflist_mtx);
+	mutex_unlock(&local->mtx);
+}
+
+static void ieee80211_channel_switch_abort(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   struct cfg80211_csa_settings *params)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_mesh __maybe_unused *ifmsh;
+
+	sdata_assert_lock(sdata);
+	lockdep_assert_held(&local->mtx);
+
+	ieee80211_csa_clear(sdata);
+
+	/* force to switch to previous AP beacon */
+	kfree(sdata->u.ap.next_beacon);
+	sdata->u.ap.next_beacon = NULL;
+
+	ieee80211_csa_finish_beacon(sdata);
+}
+
 int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			       struct cfg80211_csa_settings *params)
+			       struct cfg80211_csa_settings *params,
+			       bool first)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_chanctx *chanctx;
 	struct ieee80211_if_mesh __maybe_unused *ifmsh;
-	int err, num_chanctx;
+	int err;
 
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
 
-	if (!list_empty(&local->roc_list) || local->scanning ||
-	    ieee80211_is_csa_active(local))
+	/* only first csa call-in should check this, otherwise second csa for a
+	 * multi-interface csa would always fail */
+	if (first && (!list_empty(&local->roc_list) ||
+		      local->scanning ||
+		      ieee80211_is_csa_active(local)))
 		return -EBUSY;
 
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
 	if (sdata->wdev.cac_started)
 		return -EBUSY;
 
@@ -3108,24 +3310,10 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 
 	mutex_lock(&local->chanctx_mtx);
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (!chanctx_conf) {
-		mutex_unlock(&local->chanctx_mtx);
-		return -EBUSY;
-	}
-
-	/* don't handle for multi-VIF cases */
-	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1) {
-		mutex_unlock(&local->chanctx_mtx);
-		return -EBUSY;
-	}
-	num_chanctx = 0;
-	list_for_each_entry(chanctx, &local->chanctx_list, list)
-		num_chanctx++;
+	chanctx = ieee80211_get_csa_chanctx(local);
 	mutex_unlock(&local->chanctx_mtx);
 
-	if (num_chanctx > 1)
+	if (!chanctx)
 		return -EBUSY;
 
 	/* don't allow another channel switch if one is already active. */
@@ -3142,9 +3330,15 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		if (!sdata->u.ap.next_beacon)
 			return -ENOMEM;
 
+		err = ieee80211_ap_beacon_presp_backup(sdata);
+		if (err) {
+			ieee80211_csa_free(sdata);
+			return -ENOMEM;
+		}
+
 		err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
 		if (err < 0) {
-			kfree(sdata->u.ap.next_beacon);
+			ieee80211_csa_free(sdata);
 			return err;
 		}
 		break;
@@ -3226,26 +3420,62 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_csa_allowed_settings(struct cfg80211_csa_settings *params,
+					  int num_params)
+{
+	const struct cfg80211_chan_def *chandef;
+	int i;
+
+	if (num_params == 0)
+		return -EINVAL;
+
+	chandef = &params[0].chandef;
+	for (i = 1; i < num_params; i++) {
+		chandef = cfg80211_chandef_compatible(chandef,
+						      &params[i].chandef);
+		if (!chandef)
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
 int ieee80211_channel_switch(struct wiphy *wiphy,
 			     struct cfg80211_csa_settings *params,
 			     int num_params)
 {
 	struct ieee80211_sub_if_data *sdata;
-	int err;
-
-	/* multi-vif CSA is not implemented */
-	if (num_params > 1)
-		return -EOPNOTSUPP;
+	int err, i;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(params[0].dev);
+	err = ieee80211_csa_allowed_settings(params, num_params);
+	if (err)
+		return err;
 
-	sdata_lock(sdata);
-	mutex_lock(&sdata->local->mtx);
-	err = __ieee80211_channel_switch(wiphy, params[0].dev, &params[0]);
-	mutex_unlock(&sdata->local->mtx);
-	sdata_unlock(sdata);
+	for (i = 0; i < num_params; i++) {
+		sdata = IEEE80211_DEV_TO_SUB_IF(params[i].dev);
+
+		sdata_lock(sdata);
+		mutex_lock(&sdata->local->mtx);
+		err = __ieee80211_channel_switch(wiphy, params[i].dev,
+						 &params[i], i == 0);
+		mutex_unlock(&sdata->local->mtx);
+		sdata_unlock(sdata);
+
+		if (err) {
+			for (i--; i >= 0; i--) {
+				sdata_lock(sdata);
+				mutex_lock(&sdata->local->mtx);
+				ieee80211_channel_switch_abort(wiphy,
+							       params[i].dev,
+							       &params[i]);
+				mutex_unlock(&sdata->local->mtx);
+				sdata_unlock(sdata);
+			}
+			return err;
+		}
+	}
 
-	return err;
+	return 0;
 }
 
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f43613a..71e3e18 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -545,49 +545,103 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
-int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-				 u32 *changed)
+const struct cfg80211_chan_def *
+ieee80211_get_csa_chandef(struct ieee80211_local *local)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *conf;
-	struct ieee80211_chanctx *ctx;
-	const struct cfg80211_chan_def *chandef = &sdata->csa_chandef;
-	int ret;
-	u32 chanctx_changed = 0;
+	struct ieee80211_sub_if_data *sdata;
+	const struct cfg80211_chan_def *chandef = NULL;
 
 	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
 
-	/* should never be called if not performing a channel switch. */
-	if (WARN_ON(!sdata->vif.csa_active))
-		return -EINVAL;
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!sdata->vif.csa_active)
+			continue;
 
-	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
-				     IEEE80211_CHAN_DISABLED))
-		return -EINVAL;
+		if (!sdata->csa_complete)
+			return NULL;
 
-	mutex_lock(&local->chanctx_mtx);
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf) {
-		ret = -EINVAL;
-		goto out;
+		if (chandef == NULL)
+			chandef = &sdata->csa_chandef;
+		else
+			chandef = cfg80211_chandef_compatible(
+					chandef, &sdata->csa_chandef);
+
+		if (!chandef)
+			return NULL;
 	}
 
-	ctx = container_of(conf, struct ieee80211_chanctx, conf);
-	if (ctx->refcount != 1) {
-		ret = -EINVAL;
-		goto out;
+	return chandef;
+}
+
+static void ieee80211_use_csa_chandef(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!sdata->vif.csa_active)
+			continue;
+
+		sdata->radar_required = sdata->csa_radar_required;
+		sdata->vif.bss_conf.chandef = sdata->csa_chandef;
 	}
+}
 
-	if (sdata->vif.bss_conf.chandef.width != chandef->width) {
-		chanctx_changed = IEEE80211_CHANCTX_CHANGE_WIDTH;
-		*changed |= BSS_CHANGED_BANDWIDTH;
+struct ieee80211_chanctx *
+ieee80211_get_csa_chanctx(struct ieee80211_local *local)
+{
+	struct ieee80211_chanctx *chanctx = NULL, *ctx;
+	int num_chanctx = 0;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		chanctx = ctx;
+		num_chanctx++;
 	}
 
-	sdata->vif.bss_conf.chandef = *chandef;
-	ctx->conf.def = *chandef;
+	/* multi-channel is not supported, multi-vif is */
+	if (num_chanctx > 1)
+		return NULL;
+
+	return chanctx;
+}
+
+int ieee80211_chanctx_chswitch(struct ieee80211_local *local)
+{
+	u32 chanctx_changed = 0;
+	struct ieee80211_chanctx *ctx;
+	const struct cfg80211_chan_def *chandef;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	ctx = ieee80211_get_csa_chanctx(local);
+	if (!ctx)
+		return -EBUSY;
+
+	rcu_read_lock();
+	chandef = ieee80211_get_csa_chandef(local);
+	if (!chandef) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	if (!cfg80211_chandef_usable(local->hw.wiphy, chandef,
+				     IEEE80211_CHAN_DISABLED)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	ieee80211_use_csa_chandef(local);
+	rcu_read_unlock();
 
 	chanctx_changed |= IEEE80211_CHANCTX_CHANGE_CHANNEL;
+
+	if (ctx->conf.def.width != chandef->width)
+		chanctx_changed = IEEE80211_CHANCTX_CHANGE_WIDTH;
+
+	ctx->conf.def = *chandef;
 	drv_change_chanctx(local, ctx, chanctx_changed);
 
 	ieee80211_recalc_chanctx_chantype(local, ctx);
@@ -595,10 +649,7 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_radar_chanctx(local, ctx);
 	ieee80211_recalc_chanctx_min_def(local, ctx);
 
-	ret = 0;
- out:
-	mutex_unlock(&local->chanctx_mtx);
-	return ret;
+	return 0;
 }
 
 int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 12c6019..081beba 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -920,7 +920,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	params.block_tx = !!csa_ie.mode;
 
 	if (__ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
-				       &params))
+				       &params, true))
 		goto disconnect;
 
 	ieee80211_ibss_csa_mark_radar(sdata);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e523429..3adc5ea 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -262,6 +262,10 @@ struct ieee80211_if_ap {
 	struct cfg80211_beacon_data *next_beacon;
 	struct list_head vlans;
 
+	/* to be used if channel switch fails. */
+	struct beacon_data *prev_beacon;
+	struct probe_resp *prev_presp;
+
 	struct ps_data ps;
 	atomic_t num_mcast_sta; /* number of stations receiving multicast */
 	enum ieee80211_smps_mode req_smps, /* requested smps mode */
@@ -701,6 +705,7 @@ struct mac80211_qos_map {
 
 struct ieee80211_sub_if_data {
 	struct list_head list;
+	struct list_head csa_list;
 
 	struct wireless_dev wdev;
 
@@ -747,9 +752,11 @@ struct ieee80211_sub_if_data {
 	struct mac80211_qos_map __rcu *qos_map;
 
 	struct work_struct csa_finalize_work;
+	struct work_struct csa_complete_work;
 	int csa_counter_offset_beacon;
 	int csa_counter_offset_presp;
 	bool csa_radar_required;
+	bool csa_complete;
 	struct cfg80211_chan_def csa_chandef;
 
 	/* used to reconfigure hardware SM PS */
@@ -1457,12 +1464,22 @@ void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
 /* channel switch handling */
 void ieee80211_csa_finalize_work(struct work_struct *work);
+void ieee80211_csa_complete_work(struct work_struct *work);
 int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			       struct cfg80211_csa_settings *params);
+			       struct cfg80211_csa_settings *params,
+			       bool first);
 int ieee80211_channel_switch(struct wiphy *wiphy,
 			     struct cfg80211_csa_settings *params,
 			     int num_params);
 bool ieee80211_is_csa_active(struct ieee80211_local *local);
+void ieee80211_csa_clear(struct ieee80211_sub_if_data *sdata);
+void ieee80211_csa_free(struct ieee80211_sub_if_data *sdata);
+const struct cfg80211_chan_def *
+ieee80211_get_csa_chandef(struct ieee80211_local *local);
+struct ieee80211_chanctx *
+ieee80211_get_csa_chanctx(struct ieee80211_local *local);
+int ieee80211_chanctx_csa(struct ieee80211_local *local);
+int ieee80211_chanctx_chswitch(struct ieee80211_local *local);
 
 /* interface handling */
 int ieee80211_iface_init(void);
@@ -1775,10 +1792,6 @@ int __must_check
 ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 			       const struct cfg80211_chan_def *chandef,
 			       u32 *changed);
-/* NOTE: only use ieee80211_vif_change_channel() for channel switch */
-int __must_check
-ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
-			     u32 *changed);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 58cc061..0286a73 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -846,9 +846,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_work_sync(&sdata->recalc_smps);
 	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
-	sdata->vif.csa_active = false;
+	ieee80211_csa_clear(sdata);
+	ieee80211_csa_free(sdata);
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
+	cancel_work_sync(&sdata->csa_complete_work);
 	cancel_work_sync(&sdata->csa_finalize_work);
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
@@ -1294,6 +1296,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 	INIT_WORK(&sdata->recalc_smps, ieee80211_recalc_smps_work);
 	INIT_WORK(&sdata->csa_finalize_work, ieee80211_csa_finalize_work);
+	INIT_WORK(&sdata->csa_complete_work, ieee80211_csa_complete_work);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b3fa66a..a898036 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -889,7 +889,14 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	ret = ieee80211_vif_change_channel(sdata, &changed);
+	if (sdata->vif.bss_conf.chandef.width !=
+	    sdata->csa_chandef.width)
+		changed |= BSS_CHANGED_BANDWIDTH;
+
+	mutex_lock(&local->chanctx_mtx);
+	ret = ieee80211_chanctx_chswitch(local);
+	mutex_unlock(&local->chanctx_mtx);
+
 	if (ret) {
 		sdata_info(sdata,
 			   "vif channel switch failed, disconnecting\n");
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ef3555e..9d4567c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2405,7 +2405,7 @@ void ieee80211_csa_finish(struct ieee80211_vif *vif)
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
 	ieee80211_queue_work(&sdata->local->hw,
-			     &sdata->csa_finalize_work);
+			     &sdata->csa_complete_work);
 }
 EXPORT_SYMBOL(ieee80211_csa_finish);
 
@@ -2437,9 +2437,13 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON(counter_offset_beacon >= beacon_data_len))
 		return;
 
-	/* warn if the driver did not check for/react to csa completeness */
-	if (WARN_ON(beacon_data[counter_offset_beacon] == 0))
+	if (beacon_data[counter_offset_beacon] == 0) {
+		/* warn if the driver did not check for/react to csa
+		 * completeness. keep in mind that for multi-interface csa some
+		 * BSSes may need to wait for others to complete */
+		WARN_ON(!sdata->csa_complete);
 		return;
+	}
 
 	beacon_data[counter_offset_beacon]--;
 
-- 
1.8.4.rc3

