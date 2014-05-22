Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:40415 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaEVPG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 11:06:28 -0400
Received: by mail-ee0-f52.google.com with SMTP id e53so2798935eek.11
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 08:06:27 -0700 (PDT)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>,
	Thomas Pedersen <thomas@noack.us>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
Date: Thu, 22 May 2014 17:06:21 +0200
Message-ID: <3893194.GDQagdLGN9@desktop.local> (sfid-20140522_170632_637378_26D4648C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henning Rogge <hrogge@gmail.com>

This patch is a preparation for exporting the MPP data of the 802.11s
implementation via netlink to userspace. It unifies the content of the
mesh_paths and mpp_paths tables in mesh_pathtbl.c without changing
the behavior of the code.

Signed-off-by: Henning Rogge <hrogge@gmail.com>
---
 net/mac80211/cfg.c          |   6 +-
 net/mac80211/mesh.c         |   3 -
 net/mac80211/mesh.h         |  18 ++--
 net/mac80211/mesh_hwmp.c    |  30 +++---
 net/mac80211/mesh_pathtbl.c | 235 +++++++++++---------------------------------
 net/mac80211/rx.c           |   4 +-
 net/mac80211/tx.c           |   5 +-
 7 files changed, 92 insertions(+), 209 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aaa59d7..a443b06 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1637,7 +1637,7 @@ static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 		return -ENOENT;
 	}
 
-	mpath = mesh_path_add(sdata, dst);
+	mpath = mesh_path_add(sdata, dst, NULL);
 	if (IS_ERR(mpath)) {
 		rcu_read_unlock();
 		return PTR_ERR(mpath);
@@ -1679,7 +1679,7 @@ static int ieee80211_change_mpath(struct wiphy *wiphy,
 		return -ENOENT;
 	}
 
-	mpath = mesh_path_lookup(sdata, dst);
+	mpath = mesh_path_lookup(sdata, dst, false);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENOENT;
@@ -1743,7 +1743,7 @@ static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, dst);
+	mpath = mesh_path_lookup(sdata, dst, false);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENOENT;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f70e9cd..14b5a77 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1283,9 +1283,6 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 	if (test_and_clear_bit(MESH_WORK_GROW_MPATH_TABLE, &ifmsh->wrkq_flags))
 		mesh_mpath_table_grow();
 
-	if (test_and_clear_bit(MESH_WORK_GROW_MPP_TABLE, &ifmsh->wrkq_flags))
-		mesh_mpp_table_grow();
-
 	if (test_and_clear_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags))
 		ieee80211_mesh_housekeeping(sdata);
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index f39a19f..7b1a854 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -43,6 +43,7 @@ enum mesh_path_flags {
 	MESH_PATH_FIXED	=	BIT(3),
 	MESH_PATH_RESOLVED =	BIT(4),
 	MESH_PATH_REQ_QUEUED =	BIT(5),
+	MESH_PATH_PROXIED =	BIT(6),
 };
 
 /**
@@ -63,7 +64,6 @@ enum mesh_path_flags {
 enum mesh_deferred_task_flags {
 	MESH_WORK_HOUSEKEEPING,
 	MESH_WORK_GROW_MPATH_TABLE,
-	MESH_WORK_GROW_MPP_TABLE,
 	MESH_WORK_ROOT,
 	MESH_WORK_DRIFT_ADJUST,
 	MESH_WORK_MBSS_CHANGED,
@@ -263,11 +263,7 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb);
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mesh_path_lookup(struct ieee80211_sub_if_data *sdata,
-				   const u8 *dst);
-struct mesh_path *mpp_path_lookup(struct ieee80211_sub_if_data *sdata,
-				  const u8 *dst);
-int mpp_path_add(struct ieee80211_sub_if_data *sdata,
-		 const u8 *dst, const u8 *mpp);
+				   const u8 *dst, bool is_proxied);
 struct mesh_path *
 mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
@@ -275,7 +271,8 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt, size_t len);
 struct mesh_path *
-mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst);
+mesh_path_add(struct ieee80211_sub_if_data *sdata,
+	      const u8 *dst, const u8 *mpp);
 
 int mesh_path_add_gate(struct mesh_path *mpath);
 int mesh_path_send_to_gates(struct mesh_path *mpath);
@@ -298,7 +295,6 @@ void mesh_sta_cleanup(struct sta_info *sta);
 /* Private interfaces */
 /* Mesh tables */
 void mesh_mpath_table_grow(void);
-void mesh_mpp_table_grow(void);
 /* Mesh paths */
 int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 		       u8 ttl, const u8 *target, u32 target_sn,
@@ -355,11 +351,17 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 	return sdata->u.mesh.mesh_pp_id == IEEE80211_PATH_PROTOCOL_HWMP;
 }
 
+static inline bool is_mesh_path_proxied(const struct mesh_path *mpath)
+{
+	return !!(mpath->flags & MESH_PATH_PROXIED);
+}
+
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_stop(void);
+
 #else
 static inline void
 ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local) {}
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f951468..57c088e 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -429,7 +429,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		process = false;
 		fresh_info = false;
 	} else {
-		mpath = mesh_path_lookup(sdata, orig_addr);
+		mpath = mesh_path_lookup(sdata, orig_addr, false);
 		if (mpath) {
 			spin_lock_bh(&mpath->state_lock);
 			if (mpath->flags & MESH_PATH_FIXED)
@@ -444,7 +444,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 				}
 			}
 		} else {
-			mpath = mesh_path_add(sdata, orig_addr);
+			mpath = mesh_path_add(sdata, orig_addr, NULL);
 			if (IS_ERR(mpath)) {
 				rcu_read_unlock();
 				return 0;
@@ -476,7 +476,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	else {
 		fresh_info = true;
 
-		mpath = mesh_path_lookup(sdata, ta);
+		mpath = mesh_path_lookup(sdata, ta, false);
 		if (mpath) {
 			spin_lock_bh(&mpath->state_lock);
 			if ((mpath->flags & MESH_PATH_FIXED) ||
@@ -484,7 +484,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 					(last_hop_metric > mpath->metric)))
 				fresh_info = false;
 		} else {
-			mpath = mesh_path_add(sdata, ta);
+			mpath = mesh_path_add(sdata, ta, NULL);
 			if (IS_ERR(mpath)) {
 				rcu_read_unlock();
 				return 0;
@@ -550,7 +550,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	} else if (is_broadcast_ether_addr(target_addr) &&
 		   (target_flags & IEEE80211_PREQ_TO_FLAG)) {
 		rcu_read_lock();
-		mpath = mesh_path_lookup(sdata, orig_addr);
+		mpath = mesh_path_lookup(sdata, orig_addr, false);
 		if (mpath) {
 			if (flags & IEEE80211_PREQ_PROACTIVE_PREP_FLAG) {
 				reply = true;
@@ -565,7 +565,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 	} else {
 		rcu_read_lock();
-		mpath = mesh_path_lookup(sdata, target_addr);
+		mpath = mesh_path_lookup(sdata, target_addr, false);
 		if (mpath) {
 			if ((!(mpath->flags & MESH_PATH_SN_VALID)) ||
 					SN_LT(mpath->sn, target_sn)) {
@@ -672,7 +672,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	}
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, orig_addr);
+	mpath = mesh_path_lookup(sdata, orig_addr, false);
 	if (mpath)
 		spin_lock_bh(&mpath->state_lock);
 	else
@@ -728,7 +728,7 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 	target_rcode = PERR_IE_TARGET_RCODE(perr_elem);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, target_addr);
+	mpath = mesh_path_lookup(sdata, target_addr, false);
 	if (mpath) {
 		struct sta_info *sta;
 
@@ -793,9 +793,9 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	metric_txsta = airtime_link_metric_get(local, sta);
 
-	mpath = mesh_path_lookup(sdata, orig_addr);
+	mpath = mesh_path_lookup(sdata, orig_addr, false);
 	if (!mpath) {
-		mpath = mesh_path_add(sdata, orig_addr);
+		mpath = mesh_path_add(sdata, orig_addr, NULL);
 		if (IS_ERR(mpath)) {
 			rcu_read_unlock();
 			sdata->u.mesh.mshstats.dropped_frames_no_route++;
@@ -994,7 +994,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 	spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, preq_node->dst);
+	mpath = mesh_path_lookup(sdata, preq_node->dst, false);
 	if (!mpath)
 		goto enddiscovery;
 
@@ -1082,9 +1082,9 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 		goto endlookup;
 
 	/* no nexthop found, start resolving */
-	mpath = mesh_path_lookup(sdata, target_addr);
+	mpath = mesh_path_lookup(sdata, target_addr, false);
 	if (!mpath) {
-		mpath = mesh_path_add(sdata, target_addr);
+		mpath = mesh_path_add(sdata, target_addr, NULL);
 		if (IS_ERR(mpath)) {
 			mesh_path_discard_frame(sdata, skb);
 			err = PTR_ERR(mpath);
@@ -1130,7 +1130,7 @@ int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
 	int err = -ENOENT;
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(sdata, target_addr);
+	mpath = mesh_path_lookup(sdata, target_addr, false);
 
 	if (!mpath || !(mpath->flags & MESH_PATH_ACTIVE))
 		goto endlookup;
@@ -1177,7 +1177,7 @@ void mesh_path_timer(unsigned long data)
 		spin_unlock_bh(&mpath->state_lock);
 		mesh_queue_preq(mpath, 0);
 	} else {
-		mpath->flags = 0;
+		mpath->flags &= ~MESH_PATH_PROXIED;
 		mpath->exp_time = jiffies;
 		spin_unlock_bh(&mpath->state_lock);
 		if (!mpath->is_gate && mesh_gate_num(sdata) > 0) {
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7d050ed..adf2d98 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -41,7 +41,6 @@ struct mpath_node {
 };
 
 static struct mesh_table __rcu *mesh_paths;
-static struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */
 
 int mesh_paths_generation;
 
@@ -60,12 +59,6 @@ static inline struct mesh_table *resize_dereference_mesh_paths(void)
 		lockdep_is_held(&pathtbl_resize_lock));
 }
 
-static inline struct mesh_table *resize_dereference_mpp_paths(void)
-{
-	return rcu_dereference_protected(mpp_paths,
-		lockdep_is_held(&pathtbl_resize_lock));
-}
-
 /*
  * CAREFUL -- "tbl" must not be an expression,
  * in particular not an rcu_dereference(), since
@@ -328,18 +321,31 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 	spin_unlock_irqrestore(&from_mpath->frame_queue.lock, flags);
 }
 
-
-static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
-				      struct ieee80211_sub_if_data *sdata)
+/**
+ * mesh_path_lookup - look up a path in the mesh path table
+ * @sdata: local subif
+ * @dst: hardware address (ETH_ALEN length) of destination
+ * @is_proxied: true to lookup mpp entries, false otherwise
+ * Returns: pointer to the mesh path structure, or NULL if not found
+ *
+ * Locking: must be called within a read rcu section.
+ */
+struct mesh_path *
+mesh_path_lookup(struct ieee80211_sub_if_data *sdata,
+		 const u8 *dst, bool is_proxied)
 {
+	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct hlist_head *bucket;
 	struct mpath_node *node;
 
+	tbl = rcu_dereference(mesh_paths);
+
 	bucket = &tbl->hash_buckets[mesh_table_hash(dst, sdata, tbl)];
 	hlist_for_each_entry_rcu(node, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
+		    is_mesh_path_proxied(mpath) == is_proxied &&
 		    ether_addr_equal(dst, mpath->dst)) {
 			if (mpath_expired(mpath)) {
 				spin_lock_bh(&mpath->state_lock);
@@ -353,28 +359,6 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 }
 
 /**
- * mesh_path_lookup - look up a path in the mesh path table
- * @sdata: local subif
- * @dst: hardware address (ETH_ALEN length) of destination
- *
- * Returns: pointer to the mesh path structure, or NULL if not found
- *
- * Locking: must be called within a read rcu section.
- */
-struct mesh_path *
-mesh_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
-{
-	return mpath_lookup(rcu_dereference(mesh_paths), dst, sdata);
-}
-
-struct mesh_path *
-mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
-{
-	return mpath_lookup(rcu_dereference(mpp_paths), dst, sdata);
-}
-
-
-/**
  * mesh_path_lookup_by_idx - look up a path in the mesh path table by its index
  * @idx: index
  * @sdata: local subif, or NULL for all entries
@@ -386,14 +370,18 @@ mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 struct mesh_path *
 mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	struct mesh_table *tbl = rcu_dereference(mesh_paths);
+	struct mesh_table *tbl;
 	struct mpath_node *node;
 	int i;
 	int j = 0;
 
+	tbl = rcu_dereference(mesh_paths);
+
 	for_each_mesh_entry(tbl, node, i) {
 		if (sdata && node->mpath->sdata != sdata)
 			continue;
+		if (is_mesh_path_proxied(node->mpath))
+			continue;
 		if (j++ == idx) {
 			if (mpath_expired(node->mpath)) {
 				spin_lock_bh(&node->mpath->state_lock);
@@ -486,15 +474,16 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata)
 
 /**
  * mesh_path_add - allocate and add a new path to the mesh path table
- * @dst: destination address of the path (ETH_ALEN length)
  * @sdata: local subif
+ * @dst: destination address of the path (ETH_ALEN length)
+ * @mpp: path proxy address or NULL if dst is mesh node (ETH_ALEN length)
  *
- * Returns: 0 on success
+ * Returns: pointer to mesh_path
  *
  * State: the initial state of the new path is set to 0
  */
 struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
-				const u8 *dst)
+		 const u8 *dst, const u8 *mpp)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
@@ -513,10 +502,12 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(dst))
 		return ERR_PTR(-ENOTSUPP);
 
-	if (atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS) == 0)
+	if (!mpp &&
+	    atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS) == 0)
 		return ERR_PTR(-ENOSPC);
 
 	read_lock_bh(&pathtbl_resize_lock);
+
 	tbl = resize_dereference_mesh_paths();
 
 	hash_idx = mesh_table_hash(dst, sdata, tbl);
@@ -527,6 +518,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	hlist_for_each_entry(node, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
+		    is_mesh_path_proxied(mpath) == (mpp != NULL) &&
 		    ether_addr_equal(dst, mpath->dst))
 			goto found;
 	}
@@ -536,32 +528,37 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	if (!new_mpath)
 		goto err_path_alloc;
 
-	new_node = kmalloc(sizeof(struct mpath_node), GFP_ATOMIC);
+	new_node = kzalloc(sizeof(struct mpath_node), GFP_ATOMIC);
 	if (!new_node)
 		goto err_node_alloc;
 
 	memcpy(new_mpath->dst, dst, ETH_ALEN);
-	eth_broadcast_addr(new_mpath->rann_snd_addr);
-	new_mpath->is_root = false;
+	if (mpp) {
+		memcpy(new_mpath->mpp, mpp, ETH_ALEN);
+		new_mpath->flags = MESH_PATH_PROXIED;
+	} else {
+		eth_broadcast_addr(new_mpath->rann_snd_addr);
+		new_mpath->timer.data = (unsigned long) new_mpath;
+		new_mpath->timer.function = mesh_path_timer;
+	}
 	new_mpath->sdata = sdata;
-	new_mpath->flags = 0;
 	skb_queue_head_init(&new_mpath->frame_queue);
 	new_node->mpath = new_mpath;
-	new_mpath->timer.data = (unsigned long) new_mpath;
-	new_mpath->timer.function = mesh_path_timer;
 	new_mpath->exp_time = jiffies;
-	spin_lock_init(&new_mpath->state_lock);
 	init_timer(&new_mpath->timer);
 
+	spin_lock_init(&new_mpath->state_lock);
+
 	hlist_add_head_rcu(&new_node->list, bucket);
 	if (atomic_inc_return(&tbl->entries) >=
 	    tbl->mean_chain_len * (tbl->hash_mask + 1))
 		grow = 1;
 
-	mesh_paths_generation++;
+	if (!mpp)
+		mesh_paths_generation++;
 
 	if (grow) {
-		set_bit(MESH_WORK_GROW_MPATH_TABLE,  &ifmsh->wrkq_flags);
+		set_bit(MESH_WORK_GROW_MPATH_TABLE, &ifmsh->wrkq_flags);
 		ieee80211_queue_work(&local->hw, &sdata->work);
 	}
 	mpath = new_mpath;
@@ -573,7 +570,8 @@ found:
 err_node_alloc:
 	kfree(new_mpath);
 err_path_alloc:
-	atomic_dec(&sdata->u.mesh.mpaths);
+	if (!mpp)
+		atomic_dec(&sdata->u.mesh.mpaths);
 	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	return ERR_PTR(err);
@@ -607,104 +605,6 @@ void mesh_mpath_table_grow(void)
 	write_unlock_bh(&pathtbl_resize_lock);
 }
 
-void mesh_mpp_table_grow(void)
-{
-	struct mesh_table *oldtbl, *newtbl;
-
-	write_lock_bh(&pathtbl_resize_lock);
-	oldtbl = resize_dereference_mpp_paths();
-	newtbl = mesh_table_alloc(oldtbl->size_order + 1);
-	if (!newtbl)
-		goto out;
-	if (mesh_table_grow(oldtbl, newtbl) < 0) {
-		__mesh_table_free(newtbl);
-		goto out;
-	}
-	rcu_assign_pointer(mpp_paths, newtbl);
-	call_rcu(&oldtbl->rcu_head, mesh_table_free_rcu);
-
- out:
-	write_unlock_bh(&pathtbl_resize_lock);
-}
-
-int mpp_path_add(struct ieee80211_sub_if_data *sdata,
-		 const u8 *dst, const u8 *mpp)
-{
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
-	struct mesh_table *tbl;
-	struct mesh_path *mpath, *new_mpath;
-	struct mpath_node *node, *new_node;
-	struct hlist_head *bucket;
-	int grow = 0;
-	int err = 0;
-	u32 hash_idx;
-
-	if (ether_addr_equal(dst, sdata->vif.addr))
-		/* never add ourselves as neighbours */
-		return -ENOTSUPP;
-
-	if (is_multicast_ether_addr(dst))
-		return -ENOTSUPP;
-
-	err = -ENOMEM;
-	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_ATOMIC);
-	if (!new_mpath)
-		goto err_path_alloc;
-
-	new_node = kmalloc(sizeof(struct mpath_node), GFP_ATOMIC);
-	if (!new_node)
-		goto err_node_alloc;
-
-	read_lock_bh(&pathtbl_resize_lock);
-	memcpy(new_mpath->dst, dst, ETH_ALEN);
-	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
-	new_mpath->sdata = sdata;
-	new_mpath->flags = 0;
-	skb_queue_head_init(&new_mpath->frame_queue);
-	new_node->mpath = new_mpath;
-	init_timer(&new_mpath->timer);
-	new_mpath->exp_time = jiffies;
-	spin_lock_init(&new_mpath->state_lock);
-
-	tbl = resize_dereference_mpp_paths();
-
-	hash_idx = mesh_table_hash(dst, sdata, tbl);
-	bucket = &tbl->hash_buckets[hash_idx];
-
-	spin_lock(&tbl->hashwlock[hash_idx]);
-
-	err = -EEXIST;
-	hlist_for_each_entry(node, bucket, list) {
-		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    ether_addr_equal(dst, mpath->dst))
-			goto err_exists;
-	}
-
-	hlist_add_head_rcu(&new_node->list, bucket);
-	if (atomic_inc_return(&tbl->entries) >=
-	    tbl->mean_chain_len * (tbl->hash_mask + 1))
-		grow = 1;
-
-	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
-	if (grow) {
-		set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
-		ieee80211_queue_work(&local->hw, &sdata->work);
-	}
-	return 0;
-
-err_exists:
-	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
-	kfree(new_node);
-err_node_alloc:
-	kfree(new_mpath);
-err_path_alloc:
-	return err;
-}
-
 
 /**
  * mesh_plink_broken - deactivates paths and sends perr when a link breaks
@@ -727,6 +627,8 @@ void mesh_plink_broken(struct sta_info *sta)
 	tbl = rcu_dereference(mesh_paths);
 	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
+		if (mpath->flags & MESH_PATH_PROXIED)
+			continue;
 		if (rcu_dereference(mpath->next_hop) == sta &&
 		    mpath->flags & MESH_PATH_ACTIVE &&
 		    !(mpath->flags & MESH_PATH_FIXED)) {
@@ -792,6 +694,8 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	tbl = resize_dereference_mesh_paths();
 	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
+		if (mpath->flags & MESH_PATH_PROXIED)
+			continue;
 		if (rcu_dereference(mpath->next_hop) == sta) {
 			spin_lock(&tbl->hashwlock[i]);
 			__mesh_path_del(tbl, node);
@@ -802,14 +706,16 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	rcu_read_unlock();
 }
 
-static void table_flush_by_iface(struct mesh_table *tbl,
-				 struct ieee80211_sub_if_data *sdata)
+static void table_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 {
+	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	int i;
 
 	WARN_ON(!rcu_read_lock_held());
+
+	tbl = resize_dereference_mesh_paths();
 	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
 		if (mpath->sdata != sdata)
@@ -830,14 +736,9 @@ static void table_flush_by_iface(struct mesh_table *tbl,
  */
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 {
-	struct mesh_table *tbl;
-
 	rcu_read_lock();
 	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mesh_paths();
-	table_flush_by_iface(tbl, sdata);
-	tbl = resize_dereference_mpp_paths();
-	table_flush_by_iface(tbl, sdata);
+	table_flush_by_iface(sdata);
 	read_unlock_bh(&pathtbl_resize_lock);
 	rcu_read_unlock();
 }
@@ -868,6 +769,7 @@ int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	hlist_for_each_entry(node, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
+		    !(mpath->flags & MESH_PATH_PROXIED) &&
 		    ether_addr_equal(addr, mpath->dst)) {
 			__mesh_path_del(tbl, node);
 			goto enddel;
@@ -1035,7 +937,7 @@ static int mesh_path_node_copy(struct hlist_node *p, struct mesh_table *newtbl)
 
 int mesh_pathtbl_init(void)
 {
-	struct mesh_table *tbl_path, *tbl_mpp;
+	struct mesh_table *tbl_path;
 	int ret;
 
 	tbl_path = mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
@@ -1051,30 +953,11 @@ int mesh_pathtbl_init(void)
 	}
 	INIT_HLIST_HEAD(tbl_path->known_gates);
 
-
-	tbl_mpp = mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
-	if (!tbl_mpp) {
-		ret = -ENOMEM;
-		goto free_path;
-	}
-	tbl_mpp->free_node = &mesh_path_node_free;
-	tbl_mpp->copy_node = &mesh_path_node_copy;
-	tbl_mpp->mean_chain_len = MEAN_CHAIN_LEN;
-	tbl_mpp->known_gates = kzalloc(sizeof(struct hlist_head), GFP_ATOMIC);
-	if (!tbl_mpp->known_gates) {
-		ret = -ENOMEM;
-		goto free_mpp;
-	}
-	INIT_HLIST_HEAD(tbl_mpp->known_gates);
-
 	/* Need no locking since this is during init */
 	RCU_INIT_POINTER(mesh_paths, tbl_path);
-	RCU_INIT_POINTER(mpp_paths, tbl_mpp);
 
 	return 0;
 
-free_mpp:
-	mesh_table_free(tbl_mpp, true);
 free_path:
 	mesh_table_free(tbl_path, true);
 	return ret;
@@ -1090,9 +973,10 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	tbl = rcu_dereference(mesh_paths);
 	for_each_mesh_entry(tbl, node, i) {
-		if (node->mpath->sdata != sdata)
-			continue;
 		mpath = node->mpath;
+		if (mpath->sdata != sdata ||
+		    (mpath->flags & MESH_PATH_PROXIED))
+			continue;
 		if ((!(mpath->flags & MESH_PATH_RESOLVING)) &&
 		    (!(mpath->flags & MESH_PATH_FIXED)) &&
 		     time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE))
@@ -1105,5 +989,4 @@ void mesh_pathtbl_unregister(void)
 {
 	/* no need for locking during exit path */
 	mesh_table_free(rcu_dereference_protected(mesh_paths, 1), true);
-	mesh_table_free(rcu_dereference_protected(mpp_paths, 1), true);
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 216c45b..6b354d5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2103,9 +2103,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		}
 
 		rcu_read_lock();
-		mppath = mpp_path_lookup(sdata, proxied_addr);
+		mppath = mesh_path_lookup(sdata, proxied_addr, true);
 		if (!mppath) {
-			mpp_path_add(sdata, proxied_addr, mpp_addr);
+			mesh_path_add(sdata, proxied_addr, mpp_addr);
 		} else {
 			spin_lock_bh(&mppath->state_lock);
 			if (!ether_addr_equal(mppath->mpp, mpp_addr))
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 19d36d4..06474ff 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1887,7 +1887,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			struct sta_info *next_hop;
 			bool mpp_lookup = true;
 
-			mpath = mesh_path_lookup(sdata, skb->data);
+			mpath = mesh_path_lookup(sdata, skb->data, false);
 			if (mpath) {
 				mpp_lookup = false;
 				next_hop = rcu_dereference(mpath->next_hop);
@@ -1898,7 +1898,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			}
 
 			if (mpp_lookup)
-				mppath = mpp_path_lookup(sdata, skb->data);
+				mppath = mesh_path_lookup(sdata,
+							  skb->data, true);
 
 			if (mppath && mpath)
 				mesh_path_del(mpath->sdata, mpath->dst);
-- 
1.9.0


