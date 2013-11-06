Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48802 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3KFKiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:38:06 -0500
Received: by mail-pa0-f50.google.com with SMTP id fb1so10351611pad.37
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 02:38:03 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the mesh channel switch support
Date: Wed,  6 Nov 2013 18:34:06 +0800
Message-Id: <1383734046-3584-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131106_113809_368558_7DFB3D41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh STA receiving the mesh CSA action frame is not able to trigger
the mesh channel switch due to the incorrect handling and comparison
of mesh channel switch parameters element (MCSP)'s TTL. Make sure
the MCSP's TTL is updated accordingly before calling the
ieee80211_mesh_process_chnswitch.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 896fe3b..973c8dd 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -945,10 +945,8 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	params.block_tx = csa_ie.mode & WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT;
 	if (beacon)
 		ifmsh->chsw_ttl = csa_ie.ttl - 1;
-	else
-		ifmsh->chsw_ttl = 0;
 
-	if (ifmsh->chsw_ttl > 0)
+	if (ifmsh->chsw_ttl >= 0)
 		if (ieee80211_mesh_csa_beacon(sdata, &params, false) < 0)
 			return false;
 
@@ -1163,7 +1161,6 @@ static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
 	offset_ttl = (len < 42) ? 7 : 10;
 	*(pos + offset_ttl) -= 1;
 	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
-	sdata->u.mesh.chsw_ttl = *(pos + offset_ttl);
 
 	memcpy(mgmt_fwd, mgmt, len);
 	eth_broadcast_addr(mgmt_fwd->da);
@@ -1182,7 +1179,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	u16 pre_value;
 	bool fwd_csa = true;
 	size_t baselen;
-	u8 *pos, ttl;
+	u8 *pos;
 
 	if (mgmt->u.action.u.measurement.action_code !=
 	    WLAN_ACTION_SPCT_CHL_SWITCH)
@@ -1193,8 +1190,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 			   u.action.u.chan_switch.variable);
 	ieee802_11_parse_elems(pos, len - baselen, false, &elems);
 
-	ttl = elems.mesh_chansw_params_ie->mesh_ttl;
-	if (!--ttl)
+	ifmsh->chsw_ttl = elems.mesh_chansw_params_ie->mesh_ttl;
+	if (!--ifmsh->chsw_ttl)
 		fwd_csa = false;
 
 	pre_value = le16_to_cpu(elems.mesh_chansw_params_ie->mesh_pre_value);
-- 
1.7.9.5

