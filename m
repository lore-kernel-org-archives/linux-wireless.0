Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39858 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3KMHmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 02:42:19 -0500
Received: by mail-pb0-f54.google.com with SMTP id ro12so34353pbb.27
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 23:42:18 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: use put_unaligned_le in mesh when necessary
Date: Wed, 13 Nov 2013 15:39:12 +0800
Message-Id: <1384328352-24552-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131113_084228_325322_045AA267)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use put_unaligned_le16 and put_unaligned_le32 for
mesh_path_error_tx and mesh_path_sel_frame_tx.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh.h         |    4 +-
 net/mac80211/mesh_hwmp.c    |   87 ++++++++++++++++++-------------------------
 net/mac80211/mesh_pathtbl.c |    7 ++--
 net/mac80211/rx.c           |    5 ++-
 4 files changed, 45 insertions(+), 58 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 3f867e5..f39a19f 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -301,8 +301,8 @@ void mesh_mpath_table_grow(void);
 void mesh_mpp_table_grow(void);
 /* Mesh paths */
 int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
-		       u8 ttl, const u8 *target, __le32 target_sn,
-		       __le16 target_rcode, const u8 *ra);
+		       u8 ttl, const u8 *target, u32 target_sn,
+		       u16 target_rcode, const u8 *ra);
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 56e0c07..f951468 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -102,12 +102,11 @@ enum mpath_frame_type {
 static const u8 broadcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
-				  const u8 *orig_addr, __le32 orig_sn,
+				  const u8 *orig_addr, u32 orig_sn,
 				  u8 target_flags, const u8 *target,
-				  __le32 target_sn, const u8 *da,
+				  u32 target_sn, const u8 *da,
 				  u8 hop_count, u8 ttl,
-				  __le32 lifetime, __le32 metric,
-				  __le32 preq_id,
+				  u32 lifetime, u32 metric, u32 preq_id,
 				  struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -167,33 +166,33 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	if (action == MPATH_PREP) {
 		memcpy(pos, target, ETH_ALEN);
 		pos += ETH_ALEN;
-		memcpy(pos, &target_sn, 4);
+		put_unaligned_le32(target_sn, pos);
 		pos += 4;
 	} else {
 		if (action == MPATH_PREQ) {
-			memcpy(pos, &preq_id, 4);
+			put_unaligned_le32(preq_id, pos);
 			pos += 4;
 		}
 		memcpy(pos, orig_addr, ETH_ALEN);
 		pos += ETH_ALEN;
-		memcpy(pos, &orig_sn, 4);
+		put_unaligned_le32(orig_sn, pos);
 		pos += 4;
 	}
-	memcpy(pos, &lifetime, 4);	/* interval for RANN */
+	put_unaligned_le32(lifetime, pos); /* interval for RANN */
 	pos += 4;
-	memcpy(pos, &metric, 4);
+	put_unaligned_le32(metric, pos);
 	pos += 4;
 	if (action == MPATH_PREQ) {
 		*pos++ = 1; /* destination count */
 		*pos++ = target_flags;
 		memcpy(pos, target, ETH_ALEN);
 		pos += ETH_ALEN;
-		memcpy(pos, &target_sn, 4);
+		put_unaligned_le32(target_sn, pos);
 		pos += 4;
 	} else if (action == MPATH_PREP) {
 		memcpy(pos, orig_addr, ETH_ALEN);
 		pos += ETH_ALEN;
-		memcpy(pos, &orig_sn, 4);
+		put_unaligned_le32(orig_sn, pos);
 		pos += 4;
 	}
 
@@ -239,8 +238,8 @@ static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
  * frame directly but add it to the pending queue instead.
  */
 int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
-		       u8 ttl, const u8 *target, __le32 target_sn,
-		       __le16 target_rcode, const u8 *ra)
+		       u8 ttl, const u8 *target, u32 target_sn,
+		       u16 target_rcode, const u8 *ra)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -293,9 +292,9 @@ int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 	pos++;
 	memcpy(pos, target, ETH_ALEN);
 	pos += ETH_ALEN;
-	memcpy(pos, &target_sn, 4);
+	put_unaligned_le32(target_sn, pos);
 	pos += 4;
-	memcpy(pos, &target_rcode, 2);
+	put_unaligned_le16(target_rcode, pos);
 
 	/* see note in function header */
 	prepare_frame_for_deferred_tx(sdata, skb);
@@ -592,10 +591,9 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		if (ttl != 0) {
 			mhwmp_dbg(sdata, "replying to the PREQ\n");
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
-				cpu_to_le32(orig_sn), 0, target_addr,
-				cpu_to_le32(target_sn), mgmt->sa, 0, ttl,
-				cpu_to_le32(lifetime), cpu_to_le32(metric),
-				0, sdata);
+					       orig_sn, 0, target_addr,
+					       target_sn, mgmt->sa, 0, ttl,
+					       lifetime, metric, 0, sdata);
 		} else {
 			ifmsh->mshstats.dropped_frames_ttl++;
 		}
@@ -625,11 +623,9 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		}
 
 		mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
-				cpu_to_le32(orig_sn), target_flags, target_addr,
-				cpu_to_le32(target_sn), da,
-				hopcount, ttl, cpu_to_le32(lifetime),
-				cpu_to_le32(metric), cpu_to_le32(preq_id),
-				sdata);
+				       orig_sn, target_flags, target_addr,
+				       target_sn, da, hopcount, ttl, lifetime,
+				       metric, preq_id, sdata);
 		if (!is_multicast_ether_addr(da))
 			ifmsh->mshstats.fwded_unicast++;
 		else
@@ -695,11 +691,9 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	target_sn = PREP_IE_TARGET_SN(prep_elem);
 	orig_sn = PREP_IE_ORIG_SN(prep_elem);
 
-	mesh_path_sel_frame_tx(MPATH_PREP, flags, orig_addr,
-		cpu_to_le32(orig_sn), 0, target_addr,
-		cpu_to_le32(target_sn), next_hop, hopcount,
-		ttl, cpu_to_le32(lifetime), cpu_to_le32(metric),
-		0, sdata);
+	mesh_path_sel_frame_tx(MPATH_PREP, flags, orig_addr, orig_sn, 0,
+			       target_addr, target_sn, next_hop, hopcount,
+			       ttl, lifetime, metric, 0, sdata);
 	rcu_read_unlock();
 
 	sdata->u.mesh.mshstats.fwded_unicast++;
@@ -750,8 +744,7 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 			if (!ifmsh->mshcfg.dot11MeshForwarding)
 				goto endperr;
 			mesh_path_error_tx(sdata, ttl, target_addr,
-					   cpu_to_le32(target_sn),
-					   cpu_to_le16(target_rcode),
+					   target_sn, target_rcode,
 					   broadcast_addr);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
@@ -847,11 +840,9 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	if (ifmsh->mshcfg.dot11MeshForwarding) {
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
-				       cpu_to_le32(orig_sn),
-				       0, NULL, 0, broadcast_addr,
-				       hopcount, ttl, cpu_to_le32(interval),
-				       cpu_to_le32(metric + metric_txsta),
-				       0, sdata);
+				       orig_sn, 0, NULL, 0, broadcast_addr,
+				       hopcount, ttl, interval,
+				       metric + metric_txsta, 0, sdata);
 	}
 
 	rcu_read_unlock();
@@ -1049,11 +1040,9 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 
 	spin_unlock_bh(&mpath->state_lock);
 	da = (mpath->is_root) ? mpath->rann_snd_addr : broadcast_addr;
-	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->vif.addr,
-			cpu_to_le32(ifmsh->sn), target_flags, mpath->dst,
-			cpu_to_le32(mpath->sn), da, 0,
-			ttl, cpu_to_le32(lifetime), 0,
-			cpu_to_le32(ifmsh->preq_id++), sdata);
+	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->vif.addr, ifmsh->sn,
+			       target_flags, mpath->dst, mpath->sn, da, 0,
+			       ttl, lifetime, 0, ifmsh->preq_id++, sdata);
 	mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
 
 enddiscovery:
@@ -1212,10 +1201,9 @@ void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 	switch (ifmsh->mshcfg.dot11MeshHWMPRootMode) {
 	case IEEE80211_PROACTIVE_RANN:
 		mesh_path_sel_frame_tx(MPATH_RANN, flags, sdata->vif.addr,
-			       cpu_to_le32(++ifmsh->sn),
-			       0, NULL, 0, broadcast_addr,
-			       0, ifmsh->mshcfg.element_ttl,
-			       cpu_to_le32(interval), 0, 0, sdata);
+				       ++ifmsh->sn, 0, NULL, 0, broadcast_addr,
+				       0, ifmsh->mshcfg.element_ttl,
+				       interval, 0, 0, sdata);
 		break;
 	case IEEE80211_PROACTIVE_PREQ_WITH_PREP:
 		flags |= IEEE80211_PREQ_PROACTIVE_PREP_FLAG;
@@ -1224,11 +1212,10 @@ void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 		target_flags |= IEEE80211_PREQ_TO_FLAG |
 				IEEE80211_PREQ_USN_FLAG;
 		mesh_path_sel_frame_tx(MPATH_PREQ, flags, sdata->vif.addr,
-				cpu_to_le32(++ifmsh->sn), target_flags,
-				(u8 *) broadcast_addr, 0, broadcast_addr,
-				0, ifmsh->mshcfg.element_ttl,
-				cpu_to_le32(interval),
-				0, cpu_to_le32(ifmsh->preq_id++), sdata);
+				       ++ifmsh->sn, target_flags,
+				       (u8 *) broadcast_addr, 0, broadcast_addr,
+				       0, ifmsh->mshcfg.element_ttl, interval,
+				       0, ifmsh->preq_id++, sdata);
 		break;
 	default:
 		mhwmp_dbg(sdata, "Proactive mechanism not supported\n");
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 89aacfd..7d050ed 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -722,7 +722,6 @@ void mesh_plink_broken(struct sta_info *sta)
 	struct mpath_node *node;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	int i;
-	__le16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_DEST_UNREACHABLE);
 
 	rcu_read_lock();
 	tbl = rcu_dereference(mesh_paths);
@@ -736,9 +735,9 @@ void mesh_plink_broken(struct sta_info *sta)
 			++mpath->sn;
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_error_tx(sdata,
-					   sdata->u.mesh.mshcfg.element_ttl,
-					   mpath->dst, cpu_to_le32(mpath->sn),
-					   reason, bcast);
+				sdata->u.mesh.mshcfg.element_ttl,
+				mpath->dst, mpath->sn,
+				WLAN_REASON_MESH_PATH_DEST_UNREACHABLE, bcast);
 		}
 	}
 	rcu_read_unlock();
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bbd63b9..5638782 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2081,7 +2081,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	__le16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_NOFORWARD);
 	u16 q, hdrlen;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
@@ -2189,7 +2188,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	} else {
 		/* unable to resolve next hop */
 		mesh_path_error_tx(sdata, ifmsh->mshcfg.element_ttl,
-				   fwd_hdr->addr3, 0, reason, fwd_hdr->addr2);
+				   fwd_hdr->addr3, 0,
+				   WLAN_REASON_MESH_PATH_NOFORWARD,
+				   fwd_hdr->addr2);
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_no_route);
 		kfree_skb(fwd_skb);
 		return RX_DROP_MONITOR;
-- 
1.7.9.5

