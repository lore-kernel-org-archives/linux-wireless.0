Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59768 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3JBIDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 04:03:01 -0400
Received: by mail-pb0-f44.google.com with SMTP id xa7so538803pbc.31
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 01:03:00 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v2 5/5] mac80211: process mesh channel switching using beacon
Date: Wed,  2 Oct 2013 01:02:44 -0700
Message-Id: <1380700964-844-6-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131002_100309_378526_EA8149D7)
In-Reply-To: <1380700964-844-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1380700964-844-1-git-send-email-yeohchunyeow@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trigger the mesh channel switching procedure if the mesh STA
happens to miss the CSA action frame but able to receive the
beacon containing the CSA and MCSP elements from its peer
mesh STAs.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
v2: refactoring the ieee80211_parse_ch_switch_ie to reduce 
    parameters (Johannes Berg)

 include/net/cfg80211.h     |    4 ++
 net/mac80211/ibss.c        |    6 +--
 net/mac80211/ieee80211_i.h |    8 ++-
 net/mac80211/mesh.c        |  128 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/mlme.c        |   30 +++++------
 net/mac80211/spectmgmt.c   |   33 +++++++-----
 6 files changed, 163 insertions(+), 46 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 47fdb1d..b278986 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -686,7 +686,9 @@ struct cfg80211_ap_settings {
  * @beacon_after: beacon data to be used on the new channel
  * @radar_required: whether radar detection is required on the new channel
  * @block_tx: whether transmissions should be blocked while changing
+ * @mode: restriction on transmission until a channel switch
  * @count: number of beacons until switch
+ * @ttl: mesh TTL related to channel switch
  */
 struct cfg80211_csa_settings {
 	struct cfg80211_chan_def chandef;
@@ -695,7 +697,9 @@ struct cfg80211_csa_settings {
 	struct cfg80211_beacon_data beacon_after;
 	bool radar_required;
 	bool block_tx;
+	u8 mode;
 	u8 count;
+	u8 ttl;
 };
 
 /**
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 017e206..06a6a76 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -736,7 +736,6 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	enum nl80211_channel_type ch_type;
 	int err, num_chanctx;
 	u32 sta_flags;
-	u8 mode;
 
 	if (sdata->vif.csa_active)
 		return true;
@@ -762,8 +761,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon,
 					   ifibss->chandef.chan->band,
 					   sta_flags, ifibss->bssid,
-					   &params.count, &mode,
-					   &params.chandef);
+					   &params);
 
 	/* can't switch to destination channel, fail */
 	if (err < 0)
@@ -859,7 +857,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		 "received channel switch announcement to go to channel %d MHz\n",
 		 params.chandef.chan->center_freq);
 
-	params.block_tx = !!mode;
+	params.block_tx = !!params.mode;
 
 	ieee80211_ibss_csa_beacon(sdata, &params);
 	sdata->csa_radar_required = params.radar_required;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 175ec7e..6c0b749 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1508,17 +1508,15 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
  *	%IEEE80211_STA_DISABLE_HT, %IEEE80211_STA_DISABLE_VHT,
  *	%IEEE80211_STA_DISABLE_40MHZ, %IEEE80211_STA_DISABLE_80P80MHZ,
  *	%IEEE80211_STA_DISABLE_160MHZ.
- * @count: to be filled with the counter until the switch (on success only)
  * @bssid: the currently connected bssid (for reporting)
- * @mode: to be filled with CSA mode (on success only)
- * @new_chandef: to be filled with destination chandef (on success only)
+ * @csa_ie: the output structure holding the required fields of chanswitch IEs
  * Return: 0 on success, <0 on error and >0 if there is nothing to parse.
  */
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				 struct ieee802_11_elems *elems, bool beacon,
 				 enum ieee80211_band current_band,
-				 u32 sta_flags, u8 *bssid, u8 *count, u8 *mode,
-				 struct cfg80211_chan_def *new_chandef);
+				 u32 sta_flags, u8 *bssid,
+				 struct cfg80211_csa_settings *csa_ie);
 
 /* Suspend/resume and hw reconfiguration */
 int ieee80211_reconfig(struct ieee80211_local *local);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 93cfcb0..428bf49 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -849,6 +849,120 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_configure_filter(local);
 }
 
+static bool
+ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
+				 struct ieee802_11_elems *elems, bool beacon)
+{
+	struct cfg80211_csa_settings params;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx *chanctx;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	int err, num_chanctx;
+	u32 sta_flags;
+
+	if (sdata->vif.csa_active)
+		return true;
+
+	if (!ifmsh->mesh_id)
+		return false;
+
+	sta_flags = IEEE80211_STA_DISABLE_VHT;
+	switch (sdata->vif.bss_conf.chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		sta_flags |= IEEE80211_STA_DISABLE_HT;
+	case NL80211_CHAN_WIDTH_20:
+		sta_flags |= IEEE80211_STA_DISABLE_40MHZ;
+		break;
+	default:
+		break;
+	}
+
+	memset(&params, 0, sizeof(params));
+	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, band,
+					   sta_flags, sdata->vif.addr,
+					   &params);
+
+	if (err < 0)
+		return false;
+	if (err)
+		return false;
+
+	if (sdata->vif.bss_conf.chandef.chan->band !=
+	    params.chandef.chan->band)
+		return false;
+
+	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, &params.chandef,
+				     IEEE80211_CHAN_DISABLED)) {
+		sdata_info(sdata,
+			   "mesh STA %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), aborting\n",
+			   sdata->vif.addr,
+			   params.chandef.chan->center_freq,
+			   params.chandef.width,
+			   params.chandef.center_freq1,
+			   params.chandef.center_freq2);
+		return false;
+	}
+
+	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
+					    &params.chandef);
+	if (err < 0)
+		return false;
+	if (err) {
+		params.radar_required = true;
+		/* TODO: DFS not (yet) supported */
+		return false;
+	}
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf)
+		goto failed_chswitch;
+
+	/* don't handle for multi-VIF cases */
+	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
+	if (chanctx->refcount > 1)
+		goto failed_chswitch;
+
+	num_chanctx = 0;
+	list_for_each_entry_rcu(chanctx, &sdata->local->chanctx_list, list)
+		num_chanctx++;
+
+	if (num_chanctx > 1)
+		goto failed_chswitch;
+
+	rcu_read_unlock();
+
+	mcsa_dbg(sdata,
+		 "received channel switch announcement to go to channel %d MHz\n",
+		 params.chandef.chan->center_freq);
+
+	params.block_tx = params.mode & WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT;
+	if (beacon)
+		ifmsh->chsw_ttl = params.ttl - 1;
+
+	if (ifmsh->chsw_ttl > 0)
+		ieee80211_mesh_csa_beacon(sdata, &params, false);
+
+	sdata->csa_radar_required = params.radar_required;
+
+	if (params.block_tx)
+		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+				IEEE80211_MAX_QUEUE_MAP,
+				IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	sdata->local->csa_chandef = params.chandef;
+	sdata->vif.csa_active = true;
+
+	ieee80211_bss_info_change_notify(sdata, err);
+	drv_channel_switch_beacon(sdata, &params.chandef);
+
+	return true;
+failed_chswitch:
+	rcu_read_unlock();
+	return false;
+}
+
 static void
 ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt, size_t len)
@@ -955,6 +1069,9 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
+
+	if (!ifmsh->chsw_init)
+		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
@@ -1051,7 +1168,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee802_11_elems elems;
 	u16 pre_value;
-	bool block_tx, fwd_csa = true;
+	bool fwd_csa = true;
 	size_t baselen;
 	u8 *pos, ttl;
 
@@ -1080,13 +1197,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 			mcsa_dbg(sdata, "Failed to forward the CSA frame");
 	}
 
-	/* block the Tx only after forwarding the CSA frame if required */
-	block_tx = elems.mesh_chansw_params_ie->mesh_flags &
-		   WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT;
-	if (block_tx)
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
-				IEEE80211_MAX_QUEUE_MAP,
-				IEEE80211_QUEUE_STOP_REASON_CSA);
+	if (!ieee80211_mesh_process_chnswitch(sdata, &elems, false))
+		mcsa_dbg(sdata, "Failed to process CSA action frame");
 }
 
 static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9fce0f4..2e8297f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -941,9 +941,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *cbss = ifmgd->associated;
 	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band current_band;
-	u8 count;
-	u8 mode;
-	struct cfg80211_chan_def new_chandef = {};
+	struct cfg80211_csa_settings params;
 	int res;
 
 	sdata_assert_lock(sdata);
@@ -959,24 +957,24 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	current_band = cbss->channel->band;
+	memset(&params, 0, sizeof(params));
 	res = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, current_band,
 					   ifmgd->flags,
-					   ifmgd->associated->bssid, &count,
-					   &mode, &new_chandef);
+					   ifmgd->associated->bssid, &params);
 	if (res	< 0)
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
 	if (res)
 		return;
 
-	if (!cfg80211_chandef_usable(local->hw.wiphy, &new_chandef,
+	if (!cfg80211_chandef_usable(local->hw.wiphy, &params.chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
 			   "AP %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
 			   ifmgd->associated->bssid,
-			   new_chandef.chan->center_freq,
-			   new_chandef.width, new_chandef.center_freq1,
-			   new_chandef.center_freq2);
+			   params.chandef.chan->center_freq,
+			   params.chandef.width, params.chandef.center_freq1,
+			   params.chandef.center_freq2);
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
 		return;
@@ -1009,9 +1007,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&local->chanctx_mtx);
 
-	local->csa_chandef = new_chandef;
+	local->csa_chandef = params.chandef;
 
-	if (mode)
+	if (params.mode)
 		ieee80211_stop_queues_by_reason(&local->hw,
 				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -1020,9 +1018,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		/* use driver's channel switch callback */
 		struct ieee80211_channel_switch ch_switch = {
 			.timestamp = timestamp,
-			.block_tx = mode,
-			.chandef = new_chandef,
-			.count = count,
+			.block_tx = params.mode,
+			.chandef = params.chandef,
+			.count = params.count,
 		};
 
 		drv_channel_switch(local, &ch_switch);
@@ -1030,11 +1028,11 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* channel switch handled in software */
-	if (count <= 1)
+	if (params.count <= 1)
 		ieee80211_queue_work(&local->hw, &ifmgd->chswitch_work);
 	else
 		mod_timer(&ifmgd->chswitch_timer,
-			  TU_TO_EXP_TIME(count * cbss->beacon_interval));
+			  TU_TO_EXP_TIME(params.count * cbss->beacon_interval));
 }
 
 static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 921597e..ad0cded 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -24,8 +24,8 @@
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				 struct ieee802_11_elems *elems, bool beacon,
 				 enum ieee80211_band current_band,
-				 u32 sta_flags, u8 *bssid, u8 *count, u8 *mode,
-				 struct cfg80211_chan_def *new_chandef)
+				 u32 sta_flags, u8 *bssid,
+				 struct cfg80211_csa_settings *csa_ie)
 {
 	enum ieee80211_band new_band;
 	int new_freq;
@@ -62,18 +62,24 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 			return -EINVAL;
 		}
 		new_chan_no = elems->ext_chansw_ie->new_ch_num;
-		*count = elems->ext_chansw_ie->count;
-		*mode = elems->ext_chansw_ie->mode;
+		csa_ie->count = elems->ext_chansw_ie->count;
+		csa_ie->mode = elems->ext_chansw_ie->mode;
 	} else if (elems->ch_switch_ie) {
 		new_band = current_band;
 		new_chan_no = elems->ch_switch_ie->new_ch_num;
-		*count = elems->ch_switch_ie->count;
-		*mode = elems->ch_switch_ie->mode;
+		csa_ie->count = elems->ch_switch_ie->count;
+		csa_ie->mode = elems->ch_switch_ie->mode;
 	} else {
 		/* nothing here we understand */
 		return 1;
 	}
 
+	/* Mesh Channel Switch Parameters Element */
+	if (elems->mesh_chansw_params_ie) {
+		csa_ie->ttl = elems->mesh_chansw_params_ie->mesh_ttl;
+		csa_ie->mode = elems->mesh_chansw_params_ie->mesh_flags;
+	}
+
 	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
 	new_chan = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
 	if (!new_chan || new_chan->flags & IEEE80211_CHAN_DISABLED) {
@@ -103,25 +109,26 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 	default:
 		/* secondary_channel_offset was present but is invalid */
 	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
-		cfg80211_chandef_create(new_chandef, new_chan,
+		cfg80211_chandef_create(&csa_ie->chandef, new_chan,
 					NL80211_CHAN_HT20);
 		break;
 	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-		cfg80211_chandef_create(new_chandef, new_chan,
+		cfg80211_chandef_create(&csa_ie->chandef, new_chan,
 					NL80211_CHAN_HT40PLUS);
 		break;
 	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-		cfg80211_chandef_create(new_chandef, new_chan,
+		cfg80211_chandef_create(&csa_ie->chandef, new_chan,
 					NL80211_CHAN_HT40MINUS);
 		break;
 	case -1:
-		cfg80211_chandef_create(new_chandef, new_chan,
+		cfg80211_chandef_create(&csa_ie->chandef, new_chan,
 					NL80211_CHAN_NO_HT);
 		/* keep width for 5/10 MHz channels */
 		switch (sdata->vif.bss_conf.chandef.width) {
 		case NL80211_CHAN_WIDTH_5:
 		case NL80211_CHAN_WIDTH_10:
-			new_chandef->width = sdata->vif.bss_conf.chandef.width;
+			csa_ie->chandef.width =
+					sdata->vif.bss_conf.chandef.width;
 			break;
 		default:
 			break;
@@ -171,13 +178,13 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 	/* if VHT data is there validate & use it */
 	if (new_vht_chandef.chan) {
 		if (!cfg80211_chandef_compatible(&new_vht_chandef,
-						 new_chandef)) {
+						 &csa_ie->chandef)) {
 			sdata_info(sdata,
 				   "BSS %pM: CSA has inconsistent channel data, disconnecting\n",
 				   bssid);
 			return -EINVAL;
 		}
-		*new_chandef = new_vht_chandef;
+		csa_ie->chandef = new_vht_chandef;
 	}
 
 	return 0;
-- 
1.7.9.5

