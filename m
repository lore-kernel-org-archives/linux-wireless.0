Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:52527 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3KNMKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 07:10:13 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	johannes@sipsolutions.net, yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v5 5/5] mac80211: only set CSA beacon when at least one beacon must be transmitted
Date: Thu, 14 Nov 2013 14:09:36 +0200
Message-Id: <1384430976-13708-5-git-send-email-luciano.coelho@intel.com> (sfid-20131114_131018_406313_7991ECFE)
In-Reply-To: <1384430976-13708-1-git-send-email-luciano.coelho@intel.com>
References: <1384430976-13708-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

In v5:

* use csa_role instead of chsw_init (to match the changes in the mesh patches);

 include/net/mac80211.h     | 10 +++--
 net/mac80211/cfg.c         | 96 +++++++++++++++++++++++++++++++++++-----------
 net/mac80211/ibss.c        |  6 ---
 net/mac80211/ieee80211_i.h |  3 +-
 net/mac80211/mesh.c        |  6 +--
 net/mac80211/tx.c          | 19 ++++-----
 6 files changed, 89 insertions(+), 51 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3cd408b..535bda3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2720,11 +2720,13 @@ enum ieee80211_roc_type {
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
@@ -3423,13 +3425,13 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
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
index 6eb8e08..48faf6a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2978,17 +2978,20 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 	return new_beacon;
 }
 
-void ieee80211_csa_finalize_work(struct work_struct *work)
+void ieee80211_csa_finish(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	ieee80211_queue_work(&sdata->local->hw,
+			     &sdata->csa_finalize_work);
+}
+EXPORT_SYMBOL(ieee80211_csa_finish);
+
+static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data,
-			     csa_finalize_work);
 	struct ieee80211_local *local = sdata->local;
 	int err, changed = 0;
 
-	if (!ieee80211_sdata_running(sdata))
-		return;
-
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &changed);
 	if (WARN_ON(err < 0))
@@ -3035,6 +3038,18 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 }
 
+void ieee80211_csa_finalize_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     csa_finalize_work);
+
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
+	ieee80211_csa_finalize(sdata);
+}
+
 int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			     struct cfg80211_csa_settings *params)
 {
@@ -3043,7 +3058,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_chanctx *chanctx;
 	struct ieee80211_if_mesh __maybe_unused *ifmsh;
-	int err, num_chanctx;
+	int err, num_chanctx, changed = 0;
 
 	if (!list_empty(&local->roc_list) || local->scanning)
 		return -EBUSY;
@@ -3082,19 +3097,40 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 
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
@@ -3122,9 +3158,16 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
-		err = ieee80211_ibss_csa_beacon(sdata, params);
-		if (err < 0)
-			return err;
+		/* see comments and TODO in the NL80211_IFTYPE_AP block */
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
@@ -3149,13 +3192,17 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				ifmsh->pre_value++;
 		}
 
-		err = ieee80211_mesh_csa_beacon(sdata, params,
-			(ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT));
-		if (err < 0) {
-			ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
-			return err;
+		if (params->count > 1) {
+			err = ieee80211_mesh_csa_beacon(sdata, params);
+			if (err < 0) {
+				ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
+				return err;
+			}
+			changed |= err;
 		}
-		changed |= err;
+
+		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT)
+			ieee80211_send_action_csa(sdata, params);
 
 		break;
 #endif
@@ -3173,8 +3220,13 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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
index 23e035f..595902c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -516,12 +516,6 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
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
index 15c9c39..6252ee7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1370,8 +1370,7 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb);
 int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
-			      struct cfg80211_csa_settings *csa_settings,
-			      bool csa_action);
+			      struct cfg80211_csa_settings *csa_settings);
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata);
 
 /* scan/BSS handling */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 94dff7f..9628bda 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1066,8 +1066,7 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
 }
 
 int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
-			      struct cfg80211_csa_settings *csa_settings,
-			      bool csa_action)
+			      struct cfg80211_csa_settings *csa_settings)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_csa_settings *tmp_csa_settings;
@@ -1091,9 +1090,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 		return ret;
 	}
 
-	if (csa_action)
-		ieee80211_send_action_csa(sdata, csa_settings);
-
 	return BSS_CHANGED_BEACON;
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ec1726a..0b5dbc3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2372,15 +2372,6 @@ static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
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
@@ -2409,8 +2400,12 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
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
@@ -2476,7 +2471,7 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 	if (WARN_ON(counter_beacon > beacon_data_len))
 		goto out;
 
-	if (beacon_data[counter_beacon] == 0)
+	if (beacon_data[counter_beacon] == 1)
 		ret = true;
  out:
 	rcu_read_unlock();
-- 
1.8.4.rc3

