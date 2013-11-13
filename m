Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:51172 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab3KMRsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:48:08 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	johannes@sipsolutions.net, yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v4 3/5] mac80211: refactor ieee80211_mesh_process_chanswitch()
Date: Wed, 13 Nov 2013 19:47:29 +0200
Message-Id: <1384364851-31805-3-git-send-email-luciano.coelho@intel.com> (sfid-20131113_184817_520446_A9152484)
In-Reply-To: <1384364851-31805-1-git-send-email-luciano.coelho@intel.com>
References: <1384364851-31805-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor ieee80211_mesh_process_chanswitch() to use
ieee80211_channel_switch() and avoid code duplication.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

This depends on Chun-Yeow's "mac80211: fix the mesh channel switch
support", which Johannes already applied but is not in
wireless-testing yet.

 net/mac80211/cfg.c         | 16 +++++++-----
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mesh.c        | 64 ++++++++--------------------------------------
 3 files changed, 22 insertions(+), 59 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 87b2533..e242862 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3120,15 +3120,19 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
-		ifmsh->chsw_init = true;
-		if (!ifmsh->pre_value)
-			ifmsh->pre_value = 1;
-		else
-			ifmsh->pre_value++;
+		if (!ifmsh->csa_repeater) {
+			ifmsh->chsw_init = true;
+			if (!ifmsh->pre_value)
+				ifmsh->pre_value = 1;
+			else
+				ifmsh->pre_value++;
+		}
 
-		err = ieee80211_mesh_csa_beacon(sdata, params, true);
+		err = ieee80211_mesh_csa_beacon(sdata, params,
+						ifmsh->chsw_init);
 		if (err < 0) {
 			ifmsh->chsw_init = false;
+			ifmsh->csa_repeater = false;
 			return err;
 		}
 		break;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f4af05d..bba7897 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -612,6 +612,7 @@ struct ieee80211_if_mesh {
 	/* Channel Switching Support */
 	struct mesh_csa_settings __rcu *csa;
 	bool chsw_init;
+	bool csa_repeater;
 	u8 chsw_ttl;
 	u16 pre_value;
 };
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ba10525..a2344fc 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -856,19 +856,11 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 {
 	struct cfg80211_csa_settings params;
 	struct ieee80211_csa_ie csa_ie;
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_chanctx *chanctx;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
-	int err, num_chanctx;
+	int err;
 	u32 sta_flags;
 
-	if (sdata->vif.csa_active)
-		return true;
-
-	if (!ifmsh->mesh_id)
-		return false;
-
 	sta_flags = IEEE80211_STA_DISABLE_VHT;
 	switch (sdata->vif.bss_conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
@@ -893,10 +885,6 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	params.chandef = csa_ie.chandef;
 	params.count = csa_ie.count;
 
-	if (sdata->vif.bss_conf.chandef.chan->band !=
-	    params.chandef.chan->band)
-		return false;
-
 	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, &params.chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
@@ -919,25 +907,6 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 		return false;
 	}
 
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (!chanctx_conf)
-		goto failed_chswitch;
-
-	/* don't handle for multi-VIF cases */
-	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1)
-		goto failed_chswitch;
-
-	num_chanctx = 0;
-	list_for_each_entry_rcu(chanctx, &sdata->local->chanctx_list, list)
-		num_chanctx++;
-
-	if (num_chanctx > 1)
-		goto failed_chswitch;
-
-	rcu_read_unlock();
-
 	mcsa_dbg(sdata,
 		 "received channel switch announcement to go to channel %d MHz\n",
 		 params.chandef.chan->center_freq);
@@ -950,30 +919,16 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 		ifmsh->pre_value = csa_ie.pre_value;
 	}
 
-	if (ifmsh->chsw_ttl < ifmsh->mshcfg.dot11MeshTTL) {
-		if (ieee80211_mesh_csa_beacon(sdata, &params, false) < 0)
-			return false;
-	} else {
+	if (ifmsh->chsw_ttl >= ifmsh->mshcfg.dot11MeshTTL)
 		return false;
-	}
-
-	sdata->csa_radar_required = params.radar_required;
-
-	if (params.block_tx)
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
-				IEEE80211_MAX_QUEUE_MAP,
-				IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	sdata->local->csa_chandef = params.chandef;
-	sdata->vif.csa_active = true;
+	ifmsh->csa_repeater = true;
 
-	ieee80211_bss_info_change_notify(sdata, err);
-	drv_channel_switch_beacon(sdata, &params.chandef);
+	if (ieee80211_channel_switch(sdata->local->hw.wiphy, sdata->dev,
+				     &params) < 0)
+		return false;
 
 	return true;
-failed_chswitch:
-	rcu_read_unlock();
-	return false;
 }
 
 static void
@@ -1083,7 +1038,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
 
-	if (!ifmsh->chsw_init)
+	if (!ifmsh->chsw_init && !sdata->vif.csa_active)
 		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
@@ -1095,6 +1050,7 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
 
 	/* Reset the TTL value and Initiator flag */
 	ifmsh->chsw_init = false;
+	ifmsh->csa_repeater = false;
 	ifmsh->chsw_ttl = 0;
 
 	/* Remove the CSA and MCSP elements from the beacon */
@@ -1207,7 +1163,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 
 	ifmsh->pre_value = pre_value;
 
-	if (!ieee80211_mesh_process_chnswitch(sdata, &elems, false)) {
+	if (!sdata->vif.csa_active &&
+	    !ieee80211_mesh_process_chnswitch(sdata, &elems, false)) {
 		mcsa_dbg(sdata, "Failed to process CSA action frame");
 		return;
 	}
@@ -1363,6 +1320,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
 	ifmsh->chsw_init = false;
+	ifmsh->csa_repeater = false;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
-- 
1.8.4.rc3

