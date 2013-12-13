Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:34534 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3LMLyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 06:54:40 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v9 3/5] mac80211: refactor ieee80211_mesh_process_chanswitch()
Date: Fri, 13 Dec 2013 13:54:33 +0200
Message-Id: <1386935675-24548-4-git-send-email-luciano.coelho@intel.com> (sfid-20131213_125451_337236_91ABEED8)
In-Reply-To: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com>
References: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor ieee80211_mesh_process_chanswitch() to use
ieee80211_channel_switch() and avoid code duplication.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c         | 10 +++++--
 net/mac80211/ieee80211_i.h |  6 +++-
 net/mac80211/mesh.c        | 73 +++++++++++++---------------------------------
 net/mac80211/util.c        |  1 -
 4 files changed, 33 insertions(+), 57 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 96aebe5..4e98c49 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3156,9 +3156,15 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
-		err = ieee80211_mesh_csa_beacon(sdata, params, true);
-		if (err < 0)
+		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_NONE)
+			ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_INIT;
+
+		err = ieee80211_mesh_csa_beacon(sdata, params,
+			(ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT));
+		if (err < 0) {
+			ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
 			return err;
+		}
 		break;
 #endif
 	default:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a7b4d55..cf38a74 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -611,7 +611,11 @@ struct ieee80211_if_mesh {
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
 };
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 330d1f7..d0c4131 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -685,7 +685,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 		*pos++ = csa->settings.count;
 		*pos++ = WLAN_EID_CHAN_SWITCH_PARAM;
 		*pos++ = 6;
-		if (ifmsh->chsw_init) {
+		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT) {
 			*pos++ = ifmsh->mshcfg.dot11MeshTTL;
 			*pos |= WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
 		} else {
@@ -853,19 +853,11 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
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
@@ -890,10 +882,6 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	params.chandef = csa_ie.chandef;
 	params.count = csa_ie.count;
 
-	if (sdata->vif.bss_conf.chandef.chan->band !=
-	    params.chandef.chan->band)
-		return false;
-
 	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, &params.chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
@@ -916,24 +904,12 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
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
+		ibss_dbg(sdata,
+			 "received csa with an identical chandef, ignoring\n");
+		return true;
+	}
 
 	mcsa_dbg(sdata,
 		 "received channel switch announcement to go to channel %d MHz\n",
@@ -945,27 +921,16 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	else
 		ifmsh->chsw_ttl = 0;
 
-	if (ifmsh->chsw_ttl > 0)
-		if (ieee80211_mesh_csa_beacon(sdata, &params, false) < 0)
-			return false;
-
-	sdata->csa_radar_required = params.radar_required;
-
-	if (params.block_tx)
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
-				IEEE80211_MAX_QUEUE_MAP,
-				IEEE80211_QUEUE_STOP_REASON_CSA);
+	if (ifmsh->chsw_ttl == 0)
+		return false;
 
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
@@ -1075,7 +1040,8 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
 
-	if (!ifmsh->chsw_init)
+	if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
+	    !sdata->vif.csa_active)
 		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
@@ -1086,7 +1052,7 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
 	int ret = 0;
 
 	/* Reset the TTL value and Initiator flag */
-	ifmsh->chsw_init = false;
+	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
 	ifmsh->chsw_ttl = 0;
 
 	/* Remove the CSA and MCSP elements from the beacon */
@@ -1200,7 +1166,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 
 	ifmsh->pre_value = pre_value;
 
-	if (!ieee80211_mesh_process_chnswitch(sdata, &elems, false)) {
+	if (!sdata->vif.csa_active &&
+	    !ieee80211_mesh_process_chnswitch(sdata, &elems, false)) {
 		mcsa_dbg(sdata, "Failed to process CSA action frame");
 		return;
 	}
@@ -1355,7 +1322,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	mesh_rmc_init(sdata);
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
-	ifmsh->chsw_init = false;
+	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4a376a7..0dd7911 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2498,7 +2498,6 @@ int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
 			ifmsh->pre_value++;
 		put_unaligned_le16(ifmsh->pre_value, pos);/* Precedence Value */
 		pos += 2;
-		ifmsh->chsw_init = true;
 	}
 
 	ieee80211_tx_skb(sdata, skb);
-- 
1.8.5.1

