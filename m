Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:40551 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3ECCgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:15 -0400
Received: by mail-da0-f46.google.com with SMTP id e20so583321dak.33
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:15 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Subject: [RFC 03/12] mac80211: use all MBSS interfaces for path selection
Date: Thu,  2 May 2013 19:33:53 -0700
Message-Id: <1367548442-8229-4-git-send-email-thomas@cozybit.com> (sfid-20130503_043620_739346_3FA4EAF1)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Change the HWMP path selection code to establish paths using
all interfaces participating in a shared mbss.  This means that
group-addressed action frames like PREQ will go out on each
interface, while individually addressed frames use whichever
interface has the destination as a peer.

When processing received frames, consider it a match if any
local interface in the mbss matches the target address.

Finally, mesh_path_lookup() now scans the path table on each
interface until a path (if any) is found so that paths can
be shared among the interfaces.

[ PERR/unicast frame handling fixes from Thomas Pedersen ]

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/cfg.c          |    8 +--
 net/mac80211/mesh.h         |    6 +--
 net/mac80211/mesh_hwmp.c    |  121 ++++++++++++++++++++++++++++++-------------
 net/mac80211/mesh_pathtbl.c |   47 +++++++++++------
 net/mac80211/rx.c           |    5 +-
 net/mac80211/tx.c           |    5 +-
 6 files changed, 128 insertions(+), 64 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1f51bdf..76e9575 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1605,8 +1605,8 @@ static int ieee80211_change_mpath(struct wiphy *wiphy,
 		return -ENOENT;
 	}
 
-	mpath = mesh_path_lookup(sdata, dst);
-	if (!mpath) {
+	mpath = mesh_path_lookup(mbss(sdata), dst);
+	if (!mpath || mpath->sdata != sdata) {
 		rcu_read_unlock();
 		return -ENOENT;
 	}
@@ -1669,8 +1669,8 @@ static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, dst);
-	if (!mpath) {
+	mpath = mesh_path_lookup(mbss(sdata), dst);
+	if (!mpath || mpath->sdata != sdata) {
 		rcu_read_unlock();
 		return -ENOENT;
 	}
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 4a1a15e..2f83e8c 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -258,14 +258,14 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 				 struct ieee802_11_elems *elems);
 
 /* Mesh paths */
-int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
+int mesh_nexthop_lookup(struct mesh_local_bss *mbss,
 			struct sk_buff *skb);
 int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb);
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
-struct mesh_path *mesh_path_lookup(struct ieee80211_sub_if_data *sdata,
+struct mesh_path *mesh_path_lookup(struct mesh_local_bss *mbss,
 				   const u8 *dst);
-struct mesh_path *mpp_path_lookup(struct ieee80211_sub_if_data *sdata,
+struct mesh_path *mpp_path_lookup(struct mesh_local_bss *mbss,
 				  const u8 *dst);
 int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		 const u8 *dst, const u8 *mpp);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 486819c..d8eaccc 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -101,14 +101,14 @@ enum mpath_frame_type {
 
 static const u8 broadcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
-static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
-				  const u8 *orig_addr, __le32 orig_sn,
-				  u8 target_flags, const u8 *target,
-				  __le32 target_sn, const u8 *da,
-				  u8 hop_count, u8 ttl,
-				  __le32 lifetime, __le32 metric,
-				  __le32 preq_id,
-				  struct ieee80211_sub_if_data *sdata)
+static int __mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
+				    const u8 *orig_addr, __le32 orig_sn,
+				    u8 target_flags, const u8 *target,
+				    __le32 target_sn, const u8 *da,
+				    u8 hop_count, u8 ttl,
+				    __le32 lifetime, __le32 metric,
+				    __le32 preq_id,
+				    struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -201,6 +201,38 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	return 0;
 }
 
+static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
+				    const u8 *orig_addr, __le32 orig_sn,
+				    u8 target_flags, const u8 *target,
+				    __le32 target_sn, const u8 *da,
+				    u8 hop_count, u8 ttl,
+				    __le32 lifetime, __le32 metric,
+				    __le32 preq_id,
+				    struct ieee80211_sub_if_data *sdata)
+{
+	struct mesh_local_bss *mbss = mbss(sdata);
+	struct ieee80211_sub_if_data *tmp_sdata;
+	bool broadcast = is_broadcast_ether_addr(da);
+	struct sta_info *sta;
+	int ret = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tmp_sdata, &mbss->if_list, u.mesh.if_list) {
+		if (!broadcast) {
+			/* find right outgoing interface */
+			sta = sta_info_get(tmp_sdata, da);
+			if (!sta)
+				continue;
+		}
+		ret = __mesh_path_sel_frame_tx(action, flags, orig_addr,
+				orig_sn, target_flags, target, target_sn,
+				da, hop_count, ttl, lifetime, metric,
+				preq_id, tmp_sdata);
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
 
 /*  Headroom is not adjusted.  Caller should ensure that skb has sufficient
  *  headroom in case the frame is encrypted. */
@@ -302,6 +334,8 @@ int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 	ifmsh->next_perr = TU_TO_EXP_TIME(
 				   ifmsh->mshcfg.dot11MeshHWMPperrMinInterval);
 	ieee80211_add_pending_skb(local, skb);
+	if (is_multicast_ether_addr(mgmt->da))
+		mesh_bss_forward_tx(sdata, skb);
 	return 0;
 }
 
@@ -376,6 +410,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			       const u8 *hwmp_ie, enum mpath_frame_type action)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct mesh_local_bss *mbss = mbss(sdata);
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 	bool fresh_info;
@@ -423,14 +458,14 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		new_metric = MAX_METRIC;
 	exp_time = TU_TO_EXP_TIME(orig_lifetime);
 
-	if (ether_addr_equal(orig_addr, sdata->vif.addr)) {
+	if (mesh_bss_matches_addr(mbss, orig_addr)) {
 		/* This MP is the originator, we are not interested in this
 		 * frame, except for updating transmitter's path info.
 		 */
 		process = false;
 		fresh_info = false;
 	} else {
-		mpath = mesh_path_lookup(sdata, orig_addr);
+		mpath = mesh_path_lookup(mbss, orig_addr);
 		if (mpath) {
 			spin_lock_bh(&mpath->state_lock);
 			if (mpath->flags & MESH_PATH_FIXED)
@@ -477,7 +512,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	else {
 		fresh_info = true;
 
-		mpath = mesh_path_lookup(sdata, ta);
+		mpath = mesh_path_lookup(mbss, ta);
 		if (mpath) {
 			spin_lock_bh(&mpath->state_lock);
 			if ((mpath->flags & MESH_PATH_FIXED) ||
@@ -515,6 +550,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				    const u8 *preq_elem, u32 metric)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_local_bss *mbss = mbss(sdata);
 	struct mesh_path *mpath = NULL;
 	const u8 *target_addr, *orig_addr;
 	const u8 *da;
@@ -537,7 +573,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	mhwmp_dbg(sdata, "received PREQ from %pM\n", orig_addr);
 
-	if (ether_addr_equal(target_addr, sdata->vif.addr)) {
+	if (mesh_bss_matches_addr(mbss, target_addr)) {
 		mhwmp_dbg(sdata, "PREQ is for us\n");
 		forward = false;
 		reply = true;
@@ -551,7 +587,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	} else if (is_broadcast_ether_addr(target_addr) &&
 		   (target_flags & IEEE80211_PREQ_TO_FLAG)) {
 		rcu_read_lock();
-		mpath = mesh_path_lookup(sdata, orig_addr);
+		mpath = mesh_path_lookup(mbss, orig_addr);
 		if (mpath) {
 			if (flags & IEEE80211_PREQ_PROACTIVE_PREP_FLAG) {
 				reply = true;
@@ -566,7 +602,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 	} else {
 		rcu_read_lock();
-		mpath = mesh_path_lookup(sdata, target_addr);
+		mpath = mesh_path_lookup(mbss, target_addr);
 		if (mpath) {
 			if ((!(mpath->flags & MESH_PATH_SN_VALID)) ||
 					SN_LT(mpath->sn, target_sn)) {
@@ -646,12 +682,12 @@ next_hop_deref_protected(struct mesh_path *mpath)
 					 lockdep_is_held(&mpath->state_lock));
 }
 
-
 static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
 				    const u8 *prep_elem, u32 metric)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_local_bss *mbss = mbss(sdata);
 	struct mesh_path *mpath;
 	const u8 *target_addr, *orig_addr;
 	u8 ttl, hopcount, flags;
@@ -662,7 +698,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 		  PREP_IE_TARGET_ADDR(prep_elem));
 
 	orig_addr = PREP_IE_ORIG_ADDR(prep_elem);
-	if (ether_addr_equal(orig_addr, sdata->vif.addr))
+	if (mesh_bss_matches_addr(mbss, orig_addr))
 		/* destination, no forwarding required */
 		return;
 
@@ -676,7 +712,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	}
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, orig_addr);
+	mpath = mesh_path_lookup(mbss, orig_addr);
 	if (mpath)
 		spin_lock_bh(&mpath->state_lock);
 	else
@@ -734,7 +770,7 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 	target_rcode = PERR_IE_TARGET_RCODE(perr_elem);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, target_addr);
+	mpath = mesh_path_lookup(mbss(sdata), target_addr);
 	if (mpath) {
 		struct sta_info *sta;
 
@@ -766,6 +802,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	struct mesh_local_bss *mbss = mbss(sdata);
 	struct sta_info *sta;
 	struct mesh_path *mpath;
 	u8 ttl, flags, hopcount;
@@ -784,7 +821,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	metric = le32_to_cpu(rann->rann_metric);
 
 	/*  Ignore our own RANNs */
-	if (ether_addr_equal(orig_addr, sdata->vif.addr))
+	if (mesh_bss_matches_addr(mbss, orig_addr))
 		return;
 
 	mhwmp_dbg(sdata,
@@ -800,7 +837,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	metric_txsta = airtime_link_metric_get(local, sta);
 
-	mpath = mesh_path_lookup(sdata, orig_addr);
+	mpath = mesh_path_lookup(mbss, orig_addr);
 	if (!mpath) {
 		mpath = mesh_path_add(sdata, orig_addr);
 		if (IS_ERR(mpath)) {
@@ -982,6 +1019,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_local_bss *mbss = mbss(sdata);
 	struct mesh_preq_queue *preq_node;
 	struct mesh_path *mpath;
 	u8 ttl, target_flags;
@@ -1003,7 +1041,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 	spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, preq_node->dst);
+	mpath = mesh_path_lookup(mbss, preq_node->dst);
 	if (!mpath)
 		goto enddiscovery;
 
@@ -1078,6 +1116,7 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mesh_local_bss *mbss = mbss(sdata);
 	struct mesh_path *mpath;
 	struct sk_buff *skb_to_free = NULL;
 	u8 *target_addr = hdr->addr3;
@@ -1088,12 +1127,12 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 		return 0;
 
 	rcu_read_lock();
-	err = mesh_nexthop_lookup(sdata, skb);
+	err = mesh_nexthop_lookup(mbss, skb);
 	if (!err)
 		goto endlookup;
 
 	/* no nexthop found, start resolving */
-	mpath = mesh_path_lookup(sdata, target_addr);
+	mpath = mesh_path_lookup(mbss, target_addr);
 	if (!mpath) {
 		mpath = mesh_path_add(sdata, target_addr);
 		if (IS_ERR(mpath)) {
@@ -1122,46 +1161,54 @@ endlookup:
 }
 
 /**
- * mesh_nexthop_lookup - put the appropriate next hop on a mesh frame. Calling
- * this function is considered "using" the associated mpath, so preempt a path
- * refresh if this mpath expires soon.
+ * mesh_nexthop_lookup - put the appropriate next hop on a mesh frame and
+ * insert the correct outgoing interface on the skb cb. Calling this function
+ * is considered "using" the associated mpath, so preempt a path refresh if
+ * this mpath expires soon.
  *
  * @skb: 802.11 frame to be sent
- * @sdata: network subif the frame will be sent through
+ * @mbss: MBSS in which to find a path
  *
  * Returns: 0 if the next hop was found. Nonzero otherwise.
  */
-int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
+int mesh_nexthop_lookup(struct mesh_local_bss *mbss,
 			struct sk_buff *skb)
 {
+	struct ieee80211_sub_if_data *sdata = NULL;
 	struct mesh_path *mpath;
 	struct sta_info *next_hop;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info;
 	u8 *target_addr = hdr->addr3;
 	int err = -ENOENT;
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, target_addr);
+	mpath = mesh_path_lookup(mbss, target_addr);
 
 	if (!mpath || !(mpath->flags & MESH_PATH_ACTIVE))
 		goto endlookup;
 
-	if (time_after(jiffies,
-		       mpath->exp_time -
-		       msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time)) &&
-	    ether_addr_equal(sdata->vif.addr, hdr->addr4) &&
-	    !(mpath->flags & MESH_PATH_RESOLVING) &&
-	    !(mpath->flags & MESH_PATH_FIXED))
-		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
-
 	next_hop = rcu_dereference(mpath->next_hop);
 	if (next_hop) {
+		info = IEEE80211_SKB_CB(skb);
+		sdata = mpath->sdata;
+		info->control.vif = &sdata->vif;
 		memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
 		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
 		ieee80211_mps_set_frame_flags(sdata, next_hop, hdr);
 		err = 0;
 	}
 
+	if (sdata &&
+	    time_after(jiffies,
+		       mpath->exp_time -
+		       msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time)) &&
+	    ether_addr_equal(sdata->vif.addr, hdr->addr4) &&
+	    !(mpath->flags & MESH_PATH_RESOLVING) &&
+	    !(mpath->flags & MESH_PATH_FIXED))
+		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
+
+
 endlookup:
 	rcu_read_unlock();
 	return err;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 89aacfd..993a270 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -184,11 +184,11 @@ errcopy:
 	return -ENOMEM;
 }
 
-static u32 mesh_table_hash(const u8 *addr, struct ieee80211_sub_if_data *sdata,
+static u32 mesh_table_hash(struct mesh_local_bss *mbss, const u8 *addr,
 			   struct mesh_table *tbl)
 {
-	/* Use last four bytes of hw addr and interface index as hash index */
-	return jhash_2words(*(u32 *)(addr+2), sdata->dev->ifindex,
+	/* Use last four bytes of hw addr and first four of meshid */
+	return jhash_2words(*(u32 *)(addr+2), *(u32 *) mbss->mesh_id,
 			    tbl->hash_rnd) & tbl->hash_mask;
 }
 
@@ -328,15 +328,14 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 	spin_unlock_irqrestore(&from_mpath->frame_queue.lock, flags);
 }
 
-
-static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
-				      struct ieee80211_sub_if_data *sdata)
+static struct mesh_path *__mpath_lookup(struct mesh_table *tbl, const u8 *dst,
+					struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
 	struct hlist_head *bucket;
 	struct mpath_node *node;
 
-	bucket = &tbl->hash_buckets[mesh_table_hash(dst, sdata, tbl)];
+	bucket = &tbl->hash_buckets[mesh_table_hash(mbss(sdata), dst, tbl)];
 	hlist_for_each_entry_rcu(node, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
@@ -352,9 +351,25 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 	return NULL;
 }
 
+static struct mesh_path *mpath_lookup(struct mesh_table *tbl,
+				      struct mesh_local_bss *mbss,
+				      const u8 *dst)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct mesh_path *mpath;
+
+	list_for_each_entry_rcu(sdata, &mbss->if_list, u.mesh.if_list) {
+		mpath = __mpath_lookup(tbl, dst, sdata);
+		if (mpath)
+			return mpath;
+	}
+	return NULL;
+}
+
 /**
  * mesh_path_lookup - look up a path in the mesh path table
- * @sdata: local subif
+ *
+ * @mbss: MBSS where this destination might be found
  * @dst: hardware address (ETH_ALEN length) of destination
  *
  * Returns: pointer to the mesh path structure, or NULL if not found
@@ -362,15 +377,15 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
  * Locking: must be called within a read rcu section.
  */
 struct mesh_path *
-mesh_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
+mesh_path_lookup(struct mesh_local_bss *mbss, const u8 *dst)
 {
-	return mpath_lookup(rcu_dereference(mesh_paths), dst, sdata);
+	return mpath_lookup(rcu_dereference(mesh_paths), mbss, dst);
 }
 
 struct mesh_path *
-mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
+mpp_path_lookup(struct mesh_local_bss *mbss, const u8 *dst)
 {
-	return mpath_lookup(rcu_dereference(mpp_paths), dst, sdata);
+	return mpath_lookup(rcu_dereference(mpp_paths), mbss, dst);
 }
 
 
@@ -519,7 +534,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	read_lock_bh(&pathtbl_resize_lock);
 	tbl = resize_dereference_mesh_paths();
 
-	hash_idx = mesh_table_hash(dst, sdata, tbl);
+	hash_idx = mesh_table_hash(mbss(sdata), dst, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
 	spin_lock(&tbl->hashwlock[hash_idx]);
@@ -669,7 +684,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 
 	tbl = resize_dereference_mpp_paths();
 
-	hash_idx = mesh_table_hash(dst, sdata, tbl);
+	hash_idx = mesh_table_hash(mbss(sdata), dst, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
 	spin_lock(&tbl->hashwlock[hash_idx]);
@@ -862,7 +877,7 @@ int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 
 	read_lock_bh(&pathtbl_resize_lock);
 	tbl = resize_dereference_mesh_paths();
-	hash_idx = mesh_table_hash(addr, sdata, tbl);
+	hash_idx = mesh_table_hash(mbss(sdata), addr, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
 	spin_lock(&tbl->hashwlock[hash_idx]);
@@ -1028,7 +1043,7 @@ static int mesh_path_node_copy(struct hlist_node *p, struct mesh_table *newtbl)
 	node = hlist_entry(p, struct mpath_node, list);
 	mpath = node->mpath;
 	new_node->mpath = mpath;
-	hash_idx = mesh_table_hash(mpath->dst, mpath->sdata, newtbl);
+	hash_idx = mesh_table_hash(mbss(mpath->sdata), mpath->dst, newtbl);
 	hlist_add_head(&new_node->list,
 			&newtbl->hash_buckets[hash_idx]);
 	return 0;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 22e412b..4e7886d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2006,6 +2006,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct sk_buff *skb = rx->skb, *fwd_skb;
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mesh_local_bss *mbss = mbss(sdata);
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	__le16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_NOFORWARD);
@@ -2059,7 +2060,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		}
 
 		rcu_read_lock();
-		mppath = mpp_path_lookup(sdata, proxied_addr);
+		mppath = mpp_path_lookup(mbss, proxied_addr);
 		if (!mppath) {
 			mpp_path_add(sdata, proxied_addr, mpp_addr);
 		} else {
@@ -2110,7 +2111,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
 		/* update power mode indication when forwarding */
 		ieee80211_mps_set_frame_flags(sdata, NULL, fwd_hdr);
-	} else if (!mesh_nexthop_lookup(sdata, fwd_skb)) {
+	} else if (!mesh_nexthop_lookup(mbss, fwd_skb)) {
 		/* mesh power mode flags updated in mesh_nexthop_lookup */
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_unicast);
 	} else {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4a5fbf8..c132c76 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1799,7 +1799,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			struct sta_info *next_hop;
 			bool mpp_lookup = true;
 
-			mpath = mesh_path_lookup(sdata, skb->data);
+			mpath = mesh_path_lookup(mbss(sdata), skb->data);
 			if (mpath) {
 				mpp_lookup = false;
 				next_hop = rcu_dereference(mpath->next_hop);
@@ -1810,7 +1810,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			}
 
 			if (mpp_lookup)
-				mppath = mpp_path_lookup(sdata, skb->data);
+				mppath = mpp_path_lookup(mbss(sdata),
+							 skb->data);
 
 			if (mppath && mpath)
 				mesh_path_del(mpath->sdata, mpath->dst);
-- 
1.7.10.4

