Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtitmf2.realtek.com ([60.250.210.236]:4820 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbZHKL7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 07:59:32 -0400
From: David Woo <xinhua_wu@realsil.com.cn>
To: <javier@cozybit.com>
CC: <linux-wireless@vger.kernel.org>, <andrey@cozybit.com>,
	<johannes@sipsolutions.net>, <linville@tuxdriver.com>,
	<devel@lists.open80211s.org>
Subject: diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
Date: Tue, 11 Aug 2009 18:22:25 +0800
Message-ID: <1249986145-6531-1-git-send-email-xinhua_wu@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
-				    u8 *preq_elem, u32 metric)
-{
+				    u8 *preq_elem, u32 metric) {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 *dst_addr, *orig_addr;
@@ -431,7 +430,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			if ((!(mpath->flags & MESH_PATH_DSN_VALID)) ||
 					DSN_LT(mpath->dsn, dst_dsn)) {
 				mpath->dsn = dst_dsn;
-				mpath->flags |= MESH_PATH_DSN_VALID;
+				mpath->flags &= MESH_PATH_DSN_VALID;
 			} else if ((!(dst_flags & MP_F_DO)) &&
 					(mpath->flags & MESH_PATH_ACTIVE)) {
 				reply = true;
@@ -448,15 +447,14 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	if (reply) {
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
-		ttl = PREQ_IE_TTL(preq_elem);
-		if (ttl != 0) {
-			ttl = ifmsh->mshcfg.dot11MeshTTL;
+		ttl = ifmsh->mshcfg.dot11MeshTTL;
+		if (ttl != 0)
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, dst_addr,
 				cpu_to_le32(dst_dsn), 0, orig_addr,
 				cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
 				cpu_to_le32(lifetime), cpu_to_le32(metric),
 				0, sdata);
-		} else
+		else
 			ifmsh->mshstats.dropped_frames_ttl++;
 	}
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ffcbad7..cb14253 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -409,7 +409,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	baselen = (u8 *) mgmt->u.action.u.plink_action.variable - (u8 *) mgmt;
 	if (mgmt->u.action.u.plink_action.action_code == PLINK_CONFIRM) {
 		baseaddr += 4;
-		baselen += 4;
+		baselen -= 4;
 	}
 	ieee802_11_parse_elems(baseaddr, len - baselen, &elems);
 	if (!elems.peer_link) {
