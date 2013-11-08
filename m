Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62390 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3KHHMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:12:00 -0500
Received: by mail-pa0-f44.google.com with SMTP id fb1so1809527pad.31
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:12:00 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v4] mac80211: fix the mesh channel switch support
Date: Fri,  8 Nov 2013 15:09:43 +0800
Message-Id: <1383894583-3454-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131108_081205_579632_88C4BC40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh STA receiving the mesh CSA action frame is not able to trigger
the mesh channel switch due to the incorrect handling and comparison
of mesh channel switch parameters element (MCSP)'s TTL. Make sure
the MCSP's TTL is updated accordingly before calling the
ieee80211_mesh_process_chnswitch. Also, we update the beacon before
forwarding the CSA action frame, so MCSP's precedence value and
initiator flag need to be updated prior to this.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: only allow channel switch if mesh TTL less than dot11MeshTTL (Chun-Yeow)
v3: set the initiator flag and precedence value prior to beacon update (Chun-Yeow)
v4: return false if mesh TTL is not complied (Chun-Yeow)

 net/mac80211/cfg.c         |   10 +++++++++-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |   20 ++++++++++++--------
 net/mac80211/spectmgmt.c   |    2 ++
 net/mac80211/util.c        |    5 -----
 5 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ed1e9a8..bd007eb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3120,9 +3120,17 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
+		ifmsh->chsw_init = true;
+		if (!ifmsh->pre_value)
+			ifmsh->pre_value = 1;
+		else
+			ifmsh->pre_value++;
+
 		err = ieee80211_mesh_csa_beacon(sdata, params, true);
-		if (err < 0)
+		if (err < 0) {
+			ifmsh->chsw_init = false;
 			return err;
+		}
 		break;
 #endif
 	default:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5cfa160..f8d6710 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1224,6 +1224,7 @@ struct ieee80211_csa_ie {
 	u8 mode;
 	u8 count;
 	u8 ttl;
+	u16 pre_value;
 };
 
 /* Parsed Information Elements */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 896fe3b..ba10525 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -943,14 +943,19 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 		 params.chandef.chan->center_freq);
 
 	params.block_tx = csa_ie.mode & WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT;
-	if (beacon)
+	if (beacon) {
 		ifmsh->chsw_ttl = csa_ie.ttl - 1;
-	else
-		ifmsh->chsw_ttl = 0;
+		if (ifmsh->pre_value >= csa_ie.pre_value)
+			return false;
+		ifmsh->pre_value = csa_ie.pre_value;
+	}
 
-	if (ifmsh->chsw_ttl > 0)
+	if (ifmsh->chsw_ttl < ifmsh->mshcfg.dot11MeshTTL) {
 		if (ieee80211_mesh_csa_beacon(sdata, &params, false) < 0)
 			return false;
+	} else {
+		return false;
+	}
 
 	sdata->csa_radar_required = params.radar_required;
 
@@ -1163,7 +1168,6 @@ static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
 	offset_ttl = (len < 42) ? 7 : 10;
 	*(pos + offset_ttl) -= 1;
 	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
-	sdata->u.mesh.chsw_ttl = *(pos + offset_ttl);
 
 	memcpy(mgmt_fwd, mgmt, len);
 	eth_broadcast_addr(mgmt_fwd->da);
@@ -1182,7 +1186,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	u16 pre_value;
 	bool fwd_csa = true;
 	size_t baselen;
-	u8 *pos, ttl;
+	u8 *pos;
 
 	if (mgmt->u.action.u.measurement.action_code !=
 	    WLAN_ACTION_SPCT_CHL_SWITCH)
@@ -1193,8 +1197,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 			   u.action.u.chan_switch.variable);
 	ieee802_11_parse_elems(pos, len - baselen, false, &elems);
 
-	ttl = elems.mesh_chansw_params_ie->mesh_ttl;
-	if (!--ttl)
+	ifmsh->chsw_ttl = elems.mesh_chansw_params_ie->mesh_ttl;
+	if (!--ifmsh->chsw_ttl)
 		fwd_csa = false;
 
 	pre_value = le16_to_cpu(elems.mesh_chansw_params_ie->mesh_pre_value);
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index a40da20..6ab0090 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -78,6 +78,8 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 	if (elems->mesh_chansw_params_ie) {
 		csa_ie->ttl = elems->mesh_chansw_params_ie->mesh_ttl;
 		csa_ie->mode = elems->mesh_chansw_params_ie->mesh_flags;
+		csa_ie->pre_value = le16_to_cpu(
+				elems->mesh_chansw_params_ie->mesh_pre_value);
 	}
 
 	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a38d582..29f8ef9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2458,14 +2458,9 @@ int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
 			  WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT : 0x00;
 		put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos); /* Reason Cd */
 		pos += 2;
-		if (!ifmsh->pre_value)
-			ifmsh->pre_value = 1;
-		else
-			ifmsh->pre_value++;
 		pre_value = cpu_to_le16(ifmsh->pre_value);
 		memcpy(pos, &pre_value, 2);		/* Precedence Value */
 		pos += 2;
-		ifmsh->chsw_init = true;
 	}
 
 	ieee80211_tx_skb(sdata, skb);
-- 
1.7.9.5

