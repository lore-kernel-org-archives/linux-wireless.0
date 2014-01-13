Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58773 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaAMRnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 12:43:07 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v11 3/3] mac80211: only set CSA beacon when at least one beacon must be transmitted
Date: Mon, 13 Jan 2014 19:43:00 +0200
Message-Id: <1389634980-12584-4-git-send-email-luca@coelho.fi> (sfid-20140113_184315_526293_3B36A264)
In-Reply-To: <1389634980-12584-1-git-send-email-luca@coelho.fi>
References: <1389634980-12584-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

A beacon should never have a Channel Switch Announcement information
element with a count of 0, because a count of 1 means switch just
before the next beacon.  So, if a count of 0 was valid in a beacon, it
would have been transmitted in the next channel already, which is
useless.  A CSA count equal to zero is only meaningful in action
frames or probe_responses.

Fix the ieee80211_csa_is_complete() and ieee80211_update_csa()
functions accordingly.

With a CSA count of 0, we won't transmit any CSA beacons, because the
switch will happen before the next TBTT.  To avoid extra work and
potential confusion in the drivers, complete the CSA immediately,
instead of waiting for the driver to call ieee80211_csa_finish().

To keep things simpler, we also switch immediately when the CSA count
is 1, while in theory we should delay the switch until just before the
next TBTT.

Additionally, move the ieee80211_csa_finish() function to cfg.c,
where it makes more sense.

Tested by: Simon Wunderlich <sw@simonwunderlich.de>
Acked by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h     |  10 ++--
 net/mac80211/cfg.c         | 115 +++++++++++++++++++++++++++++++++------------
 net/mac80211/ibss.c        |   6 ---
 net/mac80211/ieee80211_i.h |   3 +-
 net/mac80211/mesh.c        |   9 ++--
 net/mac80211/tx.c          |  19 +++-----
 6 files changed, 102 insertions(+), 60 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f4ab2fb..df1004b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2750,11 +2750,13 @@ enum ieee80211_roc_type {
  * @channel_switch_beacon: Starts a channel switch to a new channel.
  *	Beacons are modified to include CSA or ECSA IEs before calling this
  *	function. The corresponding count fields in these IEs must be
- *	decremented, and when they reach zero the driver must call
+ *	decremented, and when they reach 1 the driver must call
  *	ieee80211_csa_finish(). Drivers which use ieee80211_beacon_get()
  *	get the csa counter decremented by mac80211, but must check if it is
- *	zero using ieee80211_csa_is_complete() after the beacon has been
+ *	1 using ieee80211_csa_is_complete() after the beacon has been
  *	transmitted and then call ieee80211_csa_finish().
+ *	If the CSA count starts as zero or 1, this function will not be called,
+ *	since there won't be any time to beacon before the switch anyway.
  *
  * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
  *	information in bss_conf is set up and the beacon can be retrieved. A
@@ -3452,13 +3454,13 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
  * After a channel switch announcement was scheduled and the counter in this
- * announcement hit zero, this function must be called by the driver to
+ * announcement hits 1, this function must be called by the driver to
  * notify mac80211 that the channel can be changed.
  */
 void ieee80211_csa_finish(struct ieee80211_vif *vif);
 
 /**
- * ieee80211_csa_is_complete - find out if counters reached zero
+ * ieee80211_csa_is_complete - find out if counters reached 1
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
  * This function returns whether the channel switch counters reached zero.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f111f8d..032081c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2988,28 +2988,26 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 	return new_beacon;
 }
 
-void ieee80211_csa_finalize_work(struct work_struct *work)
+void ieee80211_csa_finish(struct ieee80211_vif *vif)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data,
-			     csa_finalize_work);
-	struct ieee80211_local *local = sdata->local;
-	int err, changed = 0;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
-	sdata_lock(sdata);
-	/* AP might have been stopped while waiting for the lock. */
-	if (!sdata->vif.csa_active)
-		goto unlock;
+	ieee80211_queue_work(&sdata->local->hw,
+			     &sdata->csa_finalize_work);
+}
+EXPORT_SYMBOL(ieee80211_csa_finish);
 
-	if (!ieee80211_sdata_running(sdata))
-		goto unlock;
+static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	int err, changed = 0;
 
 	sdata->radar_required = sdata->csa_radar_required;
 	mutex_lock(&local->mtx);
 	err = ieee80211_vif_change_channel(sdata, &changed);
 	mutex_unlock(&local->mtx);
 	if (WARN_ON(err < 0))
-		goto unlock;
+		return;
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = sdata->csa_chandef;
@@ -3023,7 +3021,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	case NL80211_IFTYPE_AP:
 		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
 		if (err < 0)
-			goto unlock;
+			return;
 
 		changed |= err;
 		kfree(sdata->u.ap.next_beacon);
@@ -3038,12 +3036,12 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	case NL80211_IFTYPE_MESH_POINT:
 		err = ieee80211_mesh_finish_csa(sdata);
 		if (err < 0)
-			goto unlock;
+			return;
 		break;
 #endif
 	default:
 		WARN_ON(1);
-		goto unlock;
+		return;
 	}
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
@@ -3051,6 +3049,23 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
+}
+
+void ieee80211_csa_finalize_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     csa_finalize_work);
+
+	sdata_lock(sdata);
+	/* AP might have been stopped while waiting for the lock. */
+	if (!sdata->vif.csa_active)
+		goto unlock;
+
+	if (!ieee80211_sdata_running(sdata))
+		goto unlock;
+
+	ieee80211_csa_finalize(sdata);
 
 unlock:
 	sdata_unlock(sdata);
@@ -3064,7 +3079,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_chanctx *chanctx;
 	struct ieee80211_if_mesh __maybe_unused *ifmsh;
-	int err, num_chanctx;
+	int err, num_chanctx, changed = 0;
 
 	lockdep_assert_held(&sdata->wdev.mtx);
 
@@ -3105,19 +3120,40 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
-		sdata->csa_counter_offset_beacon =
-			params->counter_offset_beacon;
-		sdata->csa_counter_offset_presp = params->counter_offset_presp;
 		sdata->u.ap.next_beacon =
 			cfg80211_beacon_dup(&params->beacon_after);
 		if (!sdata->u.ap.next_beacon)
 			return -ENOMEM;
 
+		/*
+		 * With a count of 0, we don't have to wait for any
+		 * TBTT before switching, so complete the CSA
+		 * immediately.  In theory, with a count == 1 we
+		 * should delay the switch until just before the next
+		 * TBTT, but that would complicate things so we switch
+		 * immediately too.  If we would delay the switch
+		 * until the next TBTT, we would have to set the probe
+		 * response here.
+		 *
+		 * TODO: A channel switch with count <= 1 without
+		 * sending a CSA action frame is kind of useless,
+		 * because the clients won't know we're changing
+		 * channels.  The action frame must be implemented
+		 * either here or in the userspace.
+		 */
+		if (params->count <= 1)
+			break;
+
+		sdata->csa_counter_offset_beacon =
+			params->counter_offset_beacon;
+		sdata->csa_counter_offset_presp = params->counter_offset_presp;
 		err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
 		if (err < 0) {
 			kfree(sdata->u.ap.next_beacon);
 			return err;
 		}
+		changed |= err;
+
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		if (!sdata->vif.bss_conf.ibss_joined)
@@ -3145,9 +3181,16 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
-		err = ieee80211_ibss_csa_beacon(sdata, params);
-		if (err < 0)
-			return err;
+		/* see comments in the NL80211_IFTYPE_AP block */
+		if (params->count > 1) {
+			err = ieee80211_ibss_csa_beacon(sdata, params);
+			if (err < 0)
+				return err;
+			changed |= err;
+		}
+
+		ieee80211_send_action_csa(sdata, params);
+
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
@@ -3172,12 +3215,19 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_NONE)
 			ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_INIT;
 
-		err = ieee80211_mesh_csa_beacon(sdata, params,
-			(ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT));
-		if (err < 0) {
-			ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
-			return err;
+		/* see comments in the NL80211_IFTYPE_AP block */
+		if (params->count > 1) {
+			err = ieee80211_mesh_csa_beacon(sdata, params);
+			if (err < 0) {
+				ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
+				return err;
+			}
+			changed |= err;
 		}
+
+		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT)
+			ieee80211_send_action_csa(sdata, params);
+
 		break;
 #endif
 	default:
@@ -3194,8 +3244,13 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	sdata->csa_chandef = params->chandef;
 	sdata->vif.csa_active = true;
 
-	ieee80211_bss_info_change_notify(sdata, err);
-	drv_channel_switch_beacon(sdata, &params->chandef);
+	if (changed) {
+		ieee80211_bss_info_change_notify(sdata, changed);
+		drv_channel_switch_beacon(sdata, &params->chandef);
+	} else {
+		/* if the beacon didn't change, we can finalize immediately */
+		ieee80211_csa_finalize(sdata);
+	}
 
 	return 0;
 }
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 771080e..ed7eec3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -521,12 +521,6 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	if (old_presp)
 		kfree_rcu(old_presp, rcu_head);
 
-	/* it might not send the beacon for a while. send an action frame
-	 * immediately to announce the channel switch.
-	 */
-	if (csa_settings)
-		ieee80211_send_action_csa(sdata, csa_settings);
-
 	return BSS_CHANGED_BEACON;
  out:
 	return ret;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 428f5bd..96eb272 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1412,8 +1412,7 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb);
 int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
-			      struct cfg80211_csa_settings *csa_settings,
-			      bool csa_action);
+			      struct cfg80211_csa_settings *csa_settings);
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata);
 
 /* scan/BSS handling */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b421993..b02ac33 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1066,7 +1066,8 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
 	/* Remove the CSA and MCSP elements from the beacon */
 	tmp_csa_settings = rcu_dereference(ifmsh->csa);
 	rcu_assign_pointer(ifmsh->csa, NULL);
-	kfree_rcu(tmp_csa_settings, rcu_head);
+	if (tmp_csa_settings)
+		kfree_rcu(tmp_csa_settings, rcu_head);
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret)
 		return -EINVAL;
@@ -1079,8 +1080,7 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
 }
 
 int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
-			      struct cfg80211_csa_settings *csa_settings,
-			      bool csa_action)
+			      struct cfg80211_csa_settings *csa_settings)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_csa_settings *tmp_csa_settings;
@@ -1104,9 +1104,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 		return ret;
 	}
 
-	if (csa_action)
-		ieee80211_send_action_csa(sdata, csa_settings);
-
 	return BSS_CHANGED_BEACON;
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9f3cbf1..6259bc5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2399,15 +2399,6 @@ static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_csa_finish(struct ieee80211_vif *vif)
-{
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-
-	ieee80211_queue_work(&sdata->local->hw,
-			     &sdata->csa_finalize_work);
-}
-EXPORT_SYMBOL(ieee80211_csa_finish);
-
 static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 				 struct beacon_data *beacon)
 {
@@ -2436,8 +2427,12 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON(counter_offset_beacon >= beacon_data_len))
 		return;
 
-	/* warn if the driver did not check for/react to csa completeness */
-	if (WARN_ON(beacon_data[counter_offset_beacon] == 0))
+	/* Warn if the driver did not check for/react to csa
+	 * completeness.  A beacon with CSA counter set to 0 should
+	 * never occur, because a counter of 1 means switch just
+	 * before the next beacon.
+	 */
+	if (WARN_ON(beacon_data[counter_offset_beacon] == 1))
 		return;
 
 	beacon_data[counter_offset_beacon]--;
@@ -2503,7 +2498,7 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 	if (WARN_ON(counter_beacon > beacon_data_len))
 		goto out;
 
-	if (beacon_data[counter_beacon] == 0)
+	if (beacon_data[counter_beacon] == 1)
 		ret = true;
  out:
 	rcu_read_unlock();
-- 
1.8.5.2

