Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59674 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3IMXge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 19:36:34 -0400
Received: by mail-pb0-f52.google.com with SMTP id wz12so1819349pbc.25
        for <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2013 16:36:33 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH 5/5] mac80211: process mesh channel switching using beacon
Date: Fri, 13 Sep 2013 16:36:12 -0700
Message-Id: <1379115372-28426-6-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130914_013637_880422_72314DF1)
In-Reply-To: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trigger the mesh channel switching procedure if the mesh STA
happens to miss the CSA action frame but able to receive the
beacon containing the CSA and MCSP elements from its peer
mesh STAs.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
 net/mac80211/ibss.c        |    4 +-
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/mesh.c        |  129 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/mlme.c        |    4 +-
 net/mac80211/spectmgmt.c   |    8 ++-
 5 files changed, 134 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 017e206..a29f969 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -736,7 +736,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	enum nl80211_channel_type ch_type;
 	int err, num_chanctx;
 	u32 sta_flags;
-	u8 mode;
+	u8 mode, ttl;
 
 	if (sdata->vif.csa_active)
 		return true;
@@ -762,7 +762,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon,
 					   ifibss->chandef.chan->band,
 					   sta_flags, ifibss->bssid,
-					   &params.count, &mode,
+					   &params.count, &mode, &ttl,
 					   &params.chandef);
 
 	/* can't switch to destination channel, fail */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 48da719..fb24ad9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1510,6 +1510,7 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
  * @count: to be filled with the counter until the switch (on success only)
  * @bssid: the currently connected bssid (for reporting)
  * @mode: to be filled with CSA mode (on success only)
+ * @ttl: to be filled with mesh TTL related to channel switch
  * @new_chandef: to be filled with destination chandef (on success only)
  * Return: 0 on success, <0 on error and >0 if there is nothing to parse.
  */
@@ -1517,6 +1518,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				 struct ieee802_11_elems *elems, bool beacon,
 				 enum ieee80211_band current_band,
 				 u32 sta_flags, u8 *bssid, u8 *count, u8 *mode,
+				 u8 *ttl,
 				 struct cfg80211_chan_def *new_chandef);
 
 /* Suspend/resume and hw reconfiguration */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2f756dd..180c898 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -847,6 +847,121 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
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
+	u8 mode, ttl;
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
+					   &params.count, &mode, &ttl,
+					   &params.chandef);
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
+	params.block_tx = !!(mode & WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT);
+	if (beacon)
+		ifmsh->chsw_ttl = ttl - 1;
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
@@ -953,6 +1068,9 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
+
+	if (!ifmsh->chsw_init)
+		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
@@ -1047,7 +1165,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee802_11_elems elems;
 	u16 pre_value;
-	bool block_tx, fwd_csa = true;
+	bool fwd_csa = true;
 	size_t baselen;
 	u8 *pos, ttl;
 
@@ -1076,13 +1194,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 			mcsa_dbg(sdata, "Failed to forward the CSA frame");
 	}
 
-	/* block the Tx only after fowarding the CSA frame if required */
-	block_tx = !!(elems.mesh_chansw_params_ie->mesh_flags
-		      & WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT);
-	if (block_tx)
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
-				IEEE80211_MAX_QUEUE_MAP,
-				IEEE80211_QUEUE_STOP_REASON_CSA);
+	if (!ieee80211_mesh_process_chnswitch(sdata, &elems, false))
+		mcsa_dbg(sdata, "Failed to process CSA action frame");
 }
 
 static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9fce0f4..83e6609 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -942,7 +942,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band current_band;
 	u8 count;
-	u8 mode;
+	u8 mode, ttl;
 	struct cfg80211_chan_def new_chandef = {};
 	int res;
 
@@ -962,7 +962,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	res = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, current_band,
 					   ifmgd->flags,
 					   ifmgd->associated->bssid, &count,
-					   &mode, &new_chandef);
+					   &mode, &ttl, &new_chandef);
 	if (res	< 0)
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 921597e..0762676 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -25,7 +25,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				 struct ieee802_11_elems *elems, bool beacon,
 				 enum ieee80211_band current_band,
 				 u32 sta_flags, u8 *bssid, u8 *count, u8 *mode,
-				 struct cfg80211_chan_def *new_chandef)
+				 u8 *ttl, struct cfg80211_chan_def *new_chandef)
 {
 	enum ieee80211_band new_band;
 	int new_freq;
@@ -74,6 +74,12 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		return 1;
 	}
 
+	/* Mesh Channel Switch Parameters Element */
+	if (elems->mesh_chansw_params_ie) {
+		*ttl = elems->mesh_chansw_params_ie->mesh_ttl;
+		*mode = elems->mesh_chansw_params_ie->mesh_flags;
+	}
+
 	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
 	new_chan = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
 	if (!new_chan || new_chan->flags & IEEE80211_CHAN_DISABLED) {
-- 
1.7.9.5

