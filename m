Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45151 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaIHGBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 02:01:49 -0400
Received: by mail-pd0-f175.google.com with SMTP id z10so6065044pdj.34
        for <linux-wireless@vger.kernel.org>; Sun, 07 Sep 2014 23:01:49 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] {nl, cfg, mac}80211: Implement hidden mesh ID
Date: Mon,  8 Sep 2014 14:01:22 +0800
Message-Id: <1410156082-17313-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140908_080155_075426_9B3ED65D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hidden mesh ID is use to enhance the security of
open mesh and possible secured mesh later on by not
advertising the mesh ID during beacon generation,
similar to hidden SSID implemented in AP mode.

The implementation of hidden mesh ID involves the
following:
- The mesh ID is not advertised by the beacon frame if
the hidden mesh ID is turned on during mesh join
supporting the NL80211_HIDDEN_SSID_ZERO_LEN.
- The mesh peering can only happen if the mesh STA does
the active scanning by sending the probe request frame
with mesh ID matching the mesh ID configured by another
mesh STA.
- The mesh STA with hidden mesh ID support won't reply
to probe request frame with wildcard mesh ID.
- Mesh synchronization or mesh neighbour update only
happens for peer mesh STA with hidden mesh ID support.
So even if a mesh STA with no hidden mesh ID support
is successfully peer with another mesh STA with hidden
mesh ID support, it will be removed once the STA expired
timeout or plink timeout reached due to inactivity.

To turn on the hidden mesh ID support:
iw mesh0 mesh join o11s hidden on

To do active scanning with specific mesh ID:
iw mesh0 scan meshid o11s

Tested with ath9k using open mesh setting.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 include/net/cfg80211.h    |  2 ++
 net/mac80211/cfg.c        |  2 ++
 net/mac80211/mesh.c       | 86 +++++++++++++++++++++++++++++++++++++----------
 net/mac80211/mesh.h       |  6 ++--
 net/mac80211/mesh_plink.c | 39 ++++++++++++++-------
 net/wireless/nl80211.c    |  8 +++++
 6 files changed, 109 insertions(+), 34 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ab21299..27efae1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1314,6 +1314,7 @@ struct mesh_config {
  * @beacon_interval: beacon interval to use
  * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
  * @basic_rates: basic rates to use when creating the mesh
+ * @hidden_ssid: to hide or not to hide the mesh id in beacon frame
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -1334,6 +1335,7 @@ struct mesh_setup {
 	u16 beacon_interval;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 	u32 basic_rates;
+	enum nl80211_hidden_ssid hidden_ssid;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4d8989b..f79319f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1563,6 +1563,8 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 
 	sdata->vif.bss_conf.beacon_int = setup->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = setup->dtim_period;
+	sdata->vif.bss_conf.hidden_ssid =
+		(setup->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE);
 
 	return 0;
 }
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e9f99c1..983dcc0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -60,7 +60,8 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
  * local mesh configuration, i.e. if both nodes belong to the same mesh network.
  */
 bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
-			struct ieee802_11_elems *ie)
+			struct ieee802_11_elems *ie,
+			u16 stype)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 basic_rates = 0;
@@ -76,13 +77,23 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	 *   - MDA enabled
 	 * - Power management control on fc
 	 */
-	if (!(ifmsh->mesh_id_len == ie->mesh_id_len &&
-	     memcmp(ifmsh->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
-	     (ifmsh->mesh_pp_id == ie->mesh_config->meshconf_psel) &&
-	     (ifmsh->mesh_pm_id == ie->mesh_config->meshconf_pmetric) &&
-	     (ifmsh->mesh_cc_id == ie->mesh_config->meshconf_congest) &&
-	     (ifmsh->mesh_sp_id == ie->mesh_config->meshconf_synch) &&
-	     (ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth)))
+	if (sdata->vif.bss_conf.hidden_ssid
+	    != NL80211_HIDDEN_SSID_NOT_IN_USE &&
+	    stype == IEEE80211_STYPE_BEACON) {
+		if (ie->mesh_id_len != 0)
+			return false;
+	} else {
+		if (!(ifmsh->mesh_id_len == ie->mesh_id_len &&
+		      memcmp(ifmsh->mesh_id, ie->mesh_id,
+			     ie->mesh_id_len) == 0))
+			return false;
+	}
+
+	if (!((ifmsh->mesh_pp_id == ie->mesh_config->meshconf_psel) &&
+	      (ifmsh->mesh_pm_id == ie->mesh_config->meshconf_pmetric) &&
+	      (ifmsh->mesh_cc_id == ie->mesh_config->meshconf_congest) &&
+	      (ifmsh->mesh_sp_id == ie->mesh_config->meshconf_synch) &&
+	      (ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth)))
 		return false;
 
 	ieee80211_sta_get_rates(sdata, ie, ieee80211_get_sdata_band(sdata),
@@ -292,19 +303,30 @@ int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-int mesh_add_meshid_ie(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+int mesh_add_meshid_ie(struct ieee80211_sub_if_data *sdata,
+		       struct sk_buff *skb, bool beacon)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u8 *pos;
 
-	if (skb_tailroom(skb) < 2 + ifmsh->mesh_id_len)
+	if (skb_tailroom(skb) < 2)
 		return -ENOMEM;
 
-	pos = skb_put(skb, 2 + ifmsh->mesh_id_len);
+	pos = skb_put(skb, 2);
 	*pos++ = WLAN_EID_MESH_ID;
-	*pos++ = ifmsh->mesh_id_len;
-	if (ifmsh->mesh_id_len)
-		memcpy(pos, ifmsh->mesh_id, ifmsh->mesh_id_len);
+
+	if (sdata->vif.bss_conf.hidden_ssid
+	    != NL80211_HIDDEN_SSID_NOT_IN_USE && beacon) {
+		*pos++ = 0;
+	} else {
+		if (skb_tailroom(skb) < ifmsh->mesh_id_len)
+			return -ENOMEM;
+
+		*pos++ = ifmsh->mesh_id_len;
+		pos = skb_put(skb, ifmsh->mesh_id_len);
+		if (ifmsh->mesh_id_len)
+			memcpy(pos, ifmsh->mesh_id, ifmsh->mesh_id_len);
+	}
 
 	return 0;
 }
@@ -713,7 +735,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 	    mesh_add_rsn_ie(sdata, skb) ||
 	    mesh_add_ht_cap_ie(sdata, skb) ||
 	    mesh_add_ht_oper_ie(sdata, skb) ||
-	    mesh_add_meshid_ie(sdata, skb) ||
+	    mesh_add_meshid_ie(sdata, skb, true) ||
 	    mesh_add_meshconf_ie(sdata, skb) ||
 	    mesh_add_awake_window_ie(sdata, skb) ||
 	    mesh_add_vendor_ies(sdata, skb))
@@ -949,6 +971,8 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *bcn;
 	struct ieee80211_mgmt *hdr;
 	struct ieee802_11_elems elems;
+	enum ieee80211_band band;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	size_t baselen;
 	u8 *pos;
 
@@ -968,6 +992,13 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 	    elems.ssid_len != 0)
 		return;
 
+	/* If hidden ssid, probe request frame with
+	 * broadcast mesh id is not accepted
+	 */
+	if (sdata->vif.bss_conf.hidden_ssid
+	    != NL80211_HIDDEN_SSID_NOT_IN_USE && elems.mesh_id_len == 0)
+		return;
+
 	if (elems.mesh_id_len != 0 &&
 	    (elems.mesh_id_len != ifmsh->mesh_id_len ||
 	     memcmp(elems.mesh_id, ifmsh->mesh_id, ifmsh->mesh_id_len)))
@@ -986,7 +1017,26 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 
 	skb_reserve(presp, local->tx_headroom);
 	memcpy(skb_put(presp, bcn->head_len), bcn->head, bcn->head_len);
-	memcpy(skb_put(presp, bcn->tail_len), bcn->tail, bcn->tail_len);
+
+	if (sdata->vif.bss_conf.hidden_ssid
+	    != NL80211_HIDDEN_SSID_NOT_IN_USE) {
+		rcu_read_lock();
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		band = chanctx_conf->def.chan->band;
+		rcu_read_unlock();
+		if (ieee80211_add_ext_srates_ie(sdata, presp, true, band) ||
+		    mesh_add_rsn_ie(sdata, presp) ||
+		    mesh_add_ht_cap_ie(sdata, presp) ||
+		    mesh_add_ht_oper_ie(sdata, presp) ||
+		    mesh_add_meshid_ie(sdata, presp, false) ||
+		    mesh_add_meshconf_ie(sdata, presp) ||
+		    mesh_add_awake_window_ie(sdata, presp) ||
+		    mesh_add_vendor_ies(sdata, presp))
+			goto out;
+	} else {
+		memcpy(skb_put(presp, bcn->tail_len), bcn->tail, bcn->tail_len);
+	}
+
 	hdr = (struct ieee80211_mgmt *) presp->data;
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_RESP);
@@ -1039,8 +1089,8 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	if (mesh_matches_local(sdata, &elems))
-		mesh_neighbour_update(sdata, mgmt->sa, &elems);
+	if (mesh_matches_local(sdata, &elems, stype))
+		mesh_neighbour_update(sdata, mgmt->sa, &elems, stype);
 
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index f39a19f..4b4b022 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -213,12 +213,12 @@ int ieee80211_new_mesh_header(struct ieee80211_sub_if_data *sdata,
 int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 		   const u8 *addr, struct ieee80211s_hdr *mesh_hdr);
 bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
-			struct ieee802_11_elems *ie);
+			struct ieee802_11_elems *ie, u16 stype);
 void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
 int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb);
 int mesh_add_meshid_ie(struct ieee80211_sub_if_data *sdata,
-		       struct sk_buff *skb);
+		       struct sk_buff *skb, bool beacon);
 int mesh_add_rsn_ie(struct ieee80211_sub_if_data *sdata,
 		    struct sk_buff *skb);
 int mesh_add_vendor_ies(struct ieee80211_sub_if_data *sdata,
@@ -283,7 +283,7 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
 
 /* Mesh plinks */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-			   u8 *hw_addr, struct ieee802_11_elems *ie);
+			   u8 *hw_addr, struct ieee802_11_elems *ie, u16 stype);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 u32 mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8f0887f..19528f0 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -310,12 +310,12 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_rsn_ie(sdata, skb) ||
-		    mesh_add_meshid_ie(sdata, skb) ||
+		    mesh_add_meshid_ie(sdata, skb, false) ||
 		    mesh_add_meshconf_ie(sdata, skb))
 			goto free;
 	} else {	/* WLAN_SP_MESH_PEERING_CLOSE */
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
-		if (mesh_add_meshid_ie(sdata, skb))
+		if (mesh_add_meshid_ie(sdata, skb, false))
 			goto free;
 	}
 
@@ -503,26 +503,38 @@ mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
  * @sdata: local meshif
  * @addr: peer's address
  * @elems: IEs from beacon or mesh peering frame
+ * @stype: frame type either beacon, probe response or action frame
  *
  * Initiates peering if appropriate.
  */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 			   u8 *hw_addr,
-			   struct ieee802_11_elems *elems)
+			   struct ieee802_11_elems *elems, u16 stype)
 {
 	struct sta_info *sta;
 	u32 changed = 0;
 
-	sta = mesh_sta_info_get(sdata, hw_addr, elems);
-	if (!sta)
-		goto out;
+	if (sdata->vif.bss_conf.hidden_ssid
+	    != NL80211_HIDDEN_SSID_NOT_IN_USE &&
+	    stype == IEEE80211_STYPE_BEACON) {
+		rcu_read_lock();
+		sta = sta_info_get(sdata, hw_addr);
+		if (sta)
+			mesh_sta_info_init(sdata, sta, elems, false);
+		else
+			goto out;
+	} else {
+		sta = mesh_sta_info_get(sdata, hw_addr, elems);
+		if (!sta)
+			goto out;
 
-	if (mesh_peer_accepts_plinks(elems) &&
-	    sta->plink_state == NL80211_PLINK_LISTEN &&
-	    sdata->u.mesh.accepting_plinks &&
-	    sdata->u.mesh.mshcfg.auto_open_plinks &&
-	    rssi_threshold_check(sdata, sta))
-		changed = mesh_plink_open(sta);
+		if (mesh_peer_accepts_plinks(elems) &&
+		    sta->plink_state == NL80211_PLINK_LISTEN &&
+		    sdata->u.mesh.accepting_plinks &&
+		    sdata->u.mesh.mshcfg.auto_open_plinks &&
+		    rssi_threshold_check(sdata, sta))
+			changed = mesh_plink_open(sta);
+	}
 
 	ieee80211_mps_frame_release(sta, elems);
 out:
@@ -910,7 +922,8 @@ mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
 	bool matches_local;
 
 	matches_local = (ftype == WLAN_SP_MESH_PEERING_CLOSE ||
-			 mesh_matches_local(sdata, elems));
+			 mesh_matches_local(sdata, elems,
+					    IEEE80211_STYPE_ACTION));
 
 	/* deny open request from non-matching peer */
 	if (!matches_local && !sta) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3011401..09bf1dd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8135,6 +8135,14 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (info->attrs[NL80211_ATTR_HIDDEN_SSID]) {
+		setup.hidden_ssid =
+			nla_get_u32(info->attrs[NL80211_ATTR_HIDDEN_SSID]);
+		if (setup.hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE &&
+		    setup.hidden_ssid != NL80211_HIDDEN_SSID_ZERO_LEN)
+			return -EINVAL;
+	}
+
 	if (info->attrs[NL80211_ATTR_MESH_SETUP]) {
 		/* parse additional setup parameters if given */
 		err = nl80211_parse_mesh_setup(info, &setup);
-- 
1.9.2

