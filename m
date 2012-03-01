Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37141 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965265Ab2CAJWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 04:22:49 -0500
Received: by pbcup15 with SMTP id up15so665720pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2012 01:22:49 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] mac80211: fix the support of setting non-forwarding entity in Mesh
Date: Fri,  2 Mar 2012 02:03:19 +0800
Message-Id: <1330624999-14917-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120301_102259_218777_3D66729F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RANN, PREP and PERR propagation should happen only if the dot11MeshForwarding is true.
Besides, data frame should not be forwarded if dot11MeshForwarding is false. This redundant
checking is necessary to avoid the broadcasted ARP breaking the non-forwarding rule.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 v2: fix suggestions from Thomas

 net/mac80211/mesh_hwmp.c |    9 ++++++++-
 net/mac80211/rx.c        |    3 +++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 2e5116d..53cf7b1 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -617,6 +617,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
 				    u8 *prep_elem, u32 metric)
 {
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 *target_addr, *orig_addr;
 	u8 ttl, hopcount, flags;
@@ -630,6 +631,9 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 		/* destination, no forwarding required */
 		return;
 
+	if (!ifmsh->mshcfg.dot11MeshForwarding)
+		return;
+	
 	ttl = PREP_IE_TTL(prep_elem);
 	if (ttl <= 1) {
 		sdata->u.mesh.mshstats.dropped_frames_ttl++;
@@ -705,12 +709,15 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			mpath->sn = target_sn;
 			spin_unlock_bh(&mpath->state_lock);
+			if (!ifmsh->mshcfg.dot11MeshForwarding)
+				goto endperr;
 			mesh_path_error_tx(ttl, target_addr, cpu_to_le32(target_sn),
 					   cpu_to_le16(target_rcode),
 					   broadcast_addr, sdata);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
+endperr:
 	rcu_read_unlock();
 }
 
@@ -767,7 +774,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 	}
 
-	if (mpath->sn < orig_sn) {
+	if (mpath->sn < orig_sn && ifmsh->mshcfg.dot11MeshForwarding) {
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
 				       cpu_to_le32(orig_sn),
 				       0, NULL, 0, broadcast_addr,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7d22641..9ed2599 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1967,6 +1967,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
 		return RX_DROP_MONITOR;
 	}
+	
+	if (!ifmsh->mshcfg.dot11MeshForwarding)
+		goto out;
 
 	fwd_skb = skb_copy(skb, GFP_ATOMIC);
 	if (!fwd_skb) {
-- 
1.7.0.4

