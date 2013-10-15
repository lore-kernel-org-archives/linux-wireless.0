Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59555 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3JOCI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 22:08:58 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so8160970pdj.36
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 19:08:58 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v5 5/5] mac80211: process mesh channel switching using beacon
Date: Mon, 14 Oct 2013 19:08:31 -0700
Message-Id: <1381802911-3921-6-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131015_040913_909133_2F89CFAF)
In-Reply-To: <1381802911-3921-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1381802911-3921-1-git-send-email-yeohchunyeow@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trigger the mesh channel switching procedure if the mesh STA
happens to miss the CSA action frame but able to receive the
beacon containing the CSA and MCSP elements from its peer
mesh STAs.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
v2: fix return value (Johannes Berg)

 net/mac80211/mesh.c      |  132 +++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/spectmgmt.c |    6 +++
 2 files changed, 130 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 50b1863..35c4147 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -850,6 +850,124 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_configure_filter(local);
 }
 
+static bool
+ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
+				 struct ieee802_11_elems *elems, bool beacon)
+{
+	struct cfg80211_csa_settings params;
+	struct ieee80211_csa_ie csa_ie;
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
+	memset(&csa_ie, 0, sizeof(csa_ie));
+	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, band,
+					   sta_flags, sdata->vif.addr,
+					   &csa_ie);
+	if (err < 0)
+		return false;
+	if (err)
+		return false;
+
+	params.chandef = csa_ie.chandef;
+	params.count = csa_ie.count;
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
+	params.block_tx = csa_ie.mode & WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT;
+	if (beacon)
+		ifmsh->chsw_ttl = csa_ie.ttl - 1;
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
@@ -956,6 +1074,9 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
+
+	if (!ifmsh->chsw_init)
+		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
@@ -1051,7 +1172,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee802_11_elems elems;
 	u16 pre_value;
-	bool block_tx, fwd_csa = true;
+	bool fwd_csa = true;
 	size_t baselen;
 	u8 *pos, ttl;
 
@@ -1080,13 +1201,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
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
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index a298e12..a40da20 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -74,6 +74,12 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
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
-- 
1.7.9.5

