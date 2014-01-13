Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58766 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaAMRnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 12:43:07 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v11 1/3] mac80211: refactor ieee80211_mesh_process_chanswitch()
Date: Mon, 13 Jan 2014 19:42:58 +0200
Message-Id: <1389634980-12584-2-git-send-email-luca@coelho.fi> (sfid-20140113_184312_264905_4066BEB6)
In-Reply-To: <1389634980-12584-1-git-send-email-luca@coelho.fi>
References: <1389634980-12584-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Refactor ieee80211_mesh_process_chanswitch() to use
ieee80211_channel_switch() and avoid code duplication.

Tested by: Simon Wunderlich <sw@simonwunderlich.de>
Acked by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c         |  9 ++++--
 net/mac80211/ieee80211_i.h |  6 +++-
 net/mac80211/mesh.c        | 74 ++++++++++++----------------------------------
 3 files changed, 30 insertions(+), 59 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f9ae9b8..f111f8d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3164,15 +3164,18 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
-		ifmsh->chsw_init = true;
 		if (!ifmsh->pre_value)
 			ifmsh->pre_value = 1;
 		else
 			ifmsh->pre_value++;
 
-		err = ieee80211_mesh_csa_beacon(sdata, params, true);
+		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_NONE)
+			ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_INIT;
+
+		err = ieee80211_mesh_csa_beacon(sdata, params,
+			(ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT));
 		if (err < 0) {
-			ifmsh->chsw_init = false;
+			ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
 			return err;
 		}
 		break;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3701930..428f5bd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -616,7 +616,11 @@ struct ieee80211_if_mesh {
 	struct ps_data ps;
 	/* Channel Switching Support */
 	struct mesh_csa_settings __rcu *csa;
-	bool chsw_init;
+	enum {
+		IEEE80211_MESH_CSA_ROLE_NONE,
+		IEEE80211_MESH_CSA_ROLE_INIT,
+		IEEE80211_MESH_CSA_ROLE_REPEATER,
+	} csa_role;
 	u8 chsw_ttl;
 	u16 pre_value;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5b919ca..319adf4 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -688,7 +688,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 		*pos++ = csa->settings.count;
 		*pos++ = WLAN_EID_CHAN_SWITCH_PARAM;
 		*pos++ = 6;
-		if (ifmsh->chsw_init) {
+		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT) {
 			*pos++ = ifmsh->mshcfg.dot11MeshTTL;
 			*pos |= WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
 		} else {
@@ -859,19 +859,11 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
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
@@ -896,10 +888,6 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	params.chandef = csa_ie.chandef;
 	params.count = csa_ie.count;
 
-	if (sdata->vif.bss_conf.chandef.chan->band !=
-	    params.chandef.chan->band)
-		return false;
-
 	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, &params.chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
@@ -922,24 +910,12 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
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
+	if (cfg80211_chandef_identical(&params.chandef,
+				       &sdata->vif.bss_conf.chandef)) {
+		mcsa_dbg(sdata,
+			 "received csa with an identical chandef, ignoring\n");
+		return true;
+	}
 
 	mcsa_dbg(sdata,
 		 "received channel switch announcement to go to channel %d MHz\n",
@@ -953,30 +929,16 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
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
 
-	sdata->csa_chandef = params.chandef;
-	sdata->vif.csa_active = true;
+	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_REPEATER;
 
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
@@ -1086,7 +1048,8 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
 
-	if (!ifmsh->chsw_init)
+	if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
+	    !sdata->vif.csa_active)
 		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
@@ -1097,7 +1060,7 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
 	int ret = 0;
 
 	/* Reset the TTL value and Initiator flag */
-	ifmsh->chsw_init = false;
+	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
 	ifmsh->chsw_ttl = 0;
 
 	/* Remove the CSA and MCSP elements from the beacon */
@@ -1210,7 +1173,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 
 	ifmsh->pre_value = pre_value;
 
-	if (!ieee80211_mesh_process_chnswitch(sdata, &elems, false)) {
+	if (!sdata->vif.csa_active &&
+	    !ieee80211_mesh_process_chnswitch(sdata, &elems, false)) {
 		mcsa_dbg(sdata, "Failed to process CSA action frame");
 		return;
 	}
@@ -1365,7 +1329,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	mesh_rmc_init(sdata);
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
-	ifmsh->chsw_init = false;
+	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
-- 
1.8.5.2

