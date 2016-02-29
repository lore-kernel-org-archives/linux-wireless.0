Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:34537 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbcB2BEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 20:04:09 -0500
Received: by mail-qg0-f68.google.com with SMTP id e61so9657251qgf.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 17:04:08 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/4] mac80211: mesh: move path tables into if_mesh
Date: Sun, 28 Feb 2016 20:03:56 -0500
Message-Id: <1456707839-19469-1-git-send-email-me@bobcopeland.com> (sfid-20160229_020423_297544_7BB95295)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh path and mesh gate hashtables are global, containing
all of the mpaths for every mesh interface, but the paths are
all tied logically to a single interface.  The common case is
just a single mesh interface, so optimize for that by moving
the global hashtable into the per-interface struct.

Doing so allows us to drop sdata pointer comparisons inside
the lookups and also saves a few bytes of BSS and data.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/cfg.c          |   4 +-
 net/mac80211/ieee80211_i.h  |  12 +++
 net/mac80211/mesh.c         |  10 ++-
 net/mac80211/mesh.h         |  10 +--
 net/mac80211/mesh_pathtbl.c | 181 +++++++++++++++++++-------------------------
 net/mac80211/tx.c           |   2 +-
 6 files changed, 104 insertions(+), 115 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fe1704c4e8fb..b37adb60c9cb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1499,7 +1499,7 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 
 	memset(pinfo, 0, sizeof(*pinfo));
 
-	pinfo->generation = mesh_paths_generation;
+	pinfo->generation = mpath->sdata->u.mesh.mesh_paths_generation;
 
 	pinfo->filled = MPATH_INFO_FRAME_QLEN |
 			MPATH_INFO_SN |
@@ -1577,7 +1577,7 @@ static void mpp_set_pinfo(struct mesh_path *mpath, u8 *mpp,
 	memset(pinfo, 0, sizeof(*pinfo));
 	memcpy(mpp, mpath->mpp, ETH_ALEN);
 
-	pinfo->generation = mpp_paths_generation;
+	pinfo->generation = mpath->sdata->u.mesh.mpp_paths_generation;
 }
 
 static int ieee80211_get_mpp(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1630975c89f1..597f1b6260f4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -696,6 +696,18 @@ struct ieee80211_if_mesh {
 
 	/* offset from skb->data while building IE */
 	int meshconf_offset;
+
+	struct mesh_table __rcu *mesh_paths;
+	struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */
+	int mesh_paths_generation;
+	int mpp_paths_generation;
+
+	/* Protects assignment of the mesh_paths/mpp_paths table
+	 * pointer for resize against reading it for add/delete
+	 * of individual paths.  Pure readers (lookups) just use
+	 * RCU.
+	 */
+	rwlock_t pathtbl_resize_lock;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d32cefcb63b0..c92af2a7714d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -25,7 +25,6 @@ bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt)
 
 void ieee80211s_init(void)
 {
-	mesh_pathtbl_init();
 	mesh_allocated = 1;
 	rm_cache = kmem_cache_create("mesh_rmc", sizeof(struct rmc_entry),
 				     0, 0, NULL);
@@ -35,7 +34,6 @@ void ieee80211s_stop(void)
 {
 	if (!mesh_allocated)
 		return;
-	mesh_pathtbl_unregister();
 	kmem_cache_destroy(rm_cache);
 }
 
@@ -902,6 +900,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata);
 	mesh_path_flush_by_iface(sdata);
+	mesh_pathtbl_unregister(sdata);
 
 	/* free all potentially still buffered group-addressed frames */
 	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
@@ -1349,10 +1348,10 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 		mesh_path_start_discovery(sdata);
 
 	if (test_and_clear_bit(MESH_WORK_GROW_MPATH_TABLE, &ifmsh->wrkq_flags))
-		mesh_mpath_table_grow();
+		mesh_mpath_table_grow(sdata);
 
 	if (test_and_clear_bit(MESH_WORK_GROW_MPP_TABLE, &ifmsh->wrkq_flags))
-		mesh_mpp_table_grow();
+		mesh_mpp_table_grow(sdata);
 
 	if (test_and_clear_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags))
 		ieee80211_mesh_housekeeping(sdata);
@@ -1388,6 +1387,9 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
+
+	mesh_pathtbl_init(sdata);
+
 	setup_timer(&ifmsh->mesh_path_timer,
 		    ieee80211_mesh_path_timer,
 		    (unsigned long) sdata);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 87c017a3b1ce..601992b6cd8a 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -300,8 +300,8 @@ void mesh_sta_cleanup(struct sta_info *sta);
 
 /* Private interfaces */
 /* Mesh tables */
-void mesh_mpath_table_grow(void);
-void mesh_mpp_table_grow(void);
+void mesh_mpath_table_grow(struct ieee80211_sub_if_data *sdata);
+void mesh_mpp_table_grow(struct ieee80211_sub_if_data *sdata);
 /* Mesh paths */
 int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 		       u8 ttl, const u8 *target, u32 target_sn,
@@ -309,8 +309,8 @@ int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
-int mesh_pathtbl_init(void);
-void mesh_pathtbl_unregister(void);
+int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata);
+void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata);
 int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr);
 void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
@@ -319,8 +319,6 @@ void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
 void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
 
 bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt);
-extern int mesh_paths_generation;
-extern int mpp_paths_generation;
 
 #ifdef CONFIG_MAC80211_MESH
 static inline
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 2ba7aa56b11c..0508b37b0471 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -40,36 +40,24 @@ struct mpath_node {
 	struct mesh_path *mpath;
 };
 
-static struct mesh_table __rcu *mesh_paths;
-static struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */
-
-int mesh_paths_generation;
-int mpp_paths_generation;
-
-/* This lock will have the grow table function as writer and add / delete nodes
- * as readers. RCU provides sufficient protection only when reading the table
- * (i.e. doing lookups).  Adding or adding or removing nodes requires we take
- * the read lock or we risk operating on an old table.  The write lock is only
- * needed when modifying the number of buckets a table.
- */
-static DEFINE_RWLOCK(pathtbl_resize_lock);
-
-
 static inline struct mesh_table *resize_dereference_paths(
+	struct ieee80211_sub_if_data *sdata,
 	struct mesh_table __rcu *table)
 {
 	return rcu_dereference_protected(table,
-					lockdep_is_held(&pathtbl_resize_lock));
+		lockdep_is_held(&sdata->u.mesh.pathtbl_resize_lock));
 }
 
-static inline struct mesh_table *resize_dereference_mesh_paths(void)
+static inline struct mesh_table *resize_dereference_mesh_paths(
+		struct ieee80211_sub_if_data *sdata)
 {
-	return resize_dereference_paths(mesh_paths);
+	return resize_dereference_paths(sdata, sdata->u.mesh.mesh_paths);
 }
 
-static inline struct mesh_table *resize_dereference_mpp_paths(void)
+static inline struct mesh_table *resize_dereference_mpp_paths(
+		struct ieee80211_sub_if_data *sdata)
 {
-	return resize_dereference_paths(mpp_paths);
+	return resize_dereference_paths(sdata, sdata->u.mesh.mpp_paths);
 }
 
 /*
@@ -346,8 +334,7 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 	bucket = &tbl->hash_buckets[mesh_table_hash(dst, sdata, tbl)];
 	hlist_for_each_entry_rcu(node, bucket, list) {
 		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    ether_addr_equal(dst, mpath->dst)) {
+		if (ether_addr_equal(dst, mpath->dst)) {
 			if (mpath_expired(mpath)) {
 				spin_lock_bh(&mpath->state_lock);
 				mpath->flags &= ~MESH_PATH_ACTIVE;
@@ -371,13 +358,15 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 struct mesh_path *
 mesh_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(rcu_dereference(mesh_paths), dst, sdata);
+	return mpath_lookup(rcu_dereference(sdata->u.mesh.mesh_paths), dst,
+			    sdata);
 }
 
 struct mesh_path *
 mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(rcu_dereference(mpp_paths), dst, sdata);
+	return mpath_lookup(rcu_dereference(sdata->u.mesh.mpp_paths), dst,
+			    sdata);
 }
 
 
@@ -393,14 +382,12 @@ mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 struct mesh_path *
 mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	struct mesh_table *tbl = rcu_dereference(mesh_paths);
+	struct mesh_table *tbl = rcu_dereference(sdata->u.mesh.mesh_paths);
 	struct mpath_node *node;
 	int i;
 	int j = 0;
 
 	for_each_mesh_entry(tbl, node, i) {
-		if (sdata && node->mpath->sdata != sdata)
-			continue;
 		if (j++ == idx) {
 			if (mpath_expired(node->mpath)) {
 				spin_lock_bh(&node->mpath->state_lock);
@@ -426,14 +413,12 @@ mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 struct mesh_path *
 mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	struct mesh_table *tbl = rcu_dereference(mpp_paths);
+	struct mesh_table *tbl = rcu_dereference(sdata->u.mesh.mpp_paths);
 	struct mpath_node *node;
 	int i;
 	int j = 0;
 
 	for_each_mesh_entry(tbl, node, i) {
-		if (sdata && node->mpath->sdata != sdata)
-			continue;
 		if (j++ == idx)
 			return node->mpath;
 	}
@@ -452,7 +437,7 @@ int mesh_path_add_gate(struct mesh_path *mpath)
 	int err;
 
 	rcu_read_lock();
-	tbl = rcu_dereference(mesh_paths);
+	tbl = rcu_dereference(mpath->sdata->u.mesh.mesh_paths);
 
 	hlist_for_each_entry_rcu(gate, tbl->known_gates, list)
 		if (gate->mpath == mpath) {
@@ -550,8 +535,8 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	if (atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS) == 0)
 		return ERR_PTR(-ENOSPC);
 
-	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mesh_paths();
+	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
+	tbl = resize_dereference_mesh_paths(sdata);
 
 	hash_idx = mesh_table_hash(dst, sdata, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
@@ -560,8 +545,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 
 	hlist_for_each_entry(node, bucket, list) {
 		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    ether_addr_equal(dst, mpath->dst))
+		if (ether_addr_equal(dst, mpath->dst))
 			goto found;
 	}
 
@@ -592,7 +576,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	    MEAN_CHAIN_LEN * (tbl->hash_mask + 1))
 		grow = 1;
 
-	mesh_paths_generation++;
+	sdata->u.mesh.mesh_paths_generation++;
 
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPATH_TABLE,  &ifmsh->wrkq_flags);
@@ -601,7 +585,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	mpath = new_mpath;
 found:
 	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
+	read_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 	return mpath;
 
 err_node_alloc:
@@ -609,7 +593,7 @@ err_node_alloc:
 err_path_alloc:
 	atomic_dec(&sdata->u.mesh.mpaths);
 	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
+	read_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 	return ERR_PTR(err);
 }
 
@@ -620,12 +604,12 @@ static void mesh_table_free_rcu(struct rcu_head *rcu)
 	mesh_table_free(tbl, false);
 }
 
-void mesh_mpath_table_grow(void)
+void mesh_mpath_table_grow(struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_table *oldtbl, *newtbl;
 
-	write_lock_bh(&pathtbl_resize_lock);
-	oldtbl = resize_dereference_mesh_paths();
+	write_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
+	oldtbl = resize_dereference_mesh_paths(sdata);
 	newtbl = mesh_table_alloc(oldtbl->size_order + 1);
 	if (!newtbl)
 		goto out;
@@ -633,20 +617,20 @@ void mesh_mpath_table_grow(void)
 		__mesh_table_free(newtbl);
 		goto out;
 	}
-	rcu_assign_pointer(mesh_paths, newtbl);
+	rcu_assign_pointer(sdata->u.mesh.mesh_paths, newtbl);
 
 	call_rcu(&oldtbl->rcu_head, mesh_table_free_rcu);
 
  out:
-	write_unlock_bh(&pathtbl_resize_lock);
+	write_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 }
 
-void mesh_mpp_table_grow(void)
+void mesh_mpp_table_grow(struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_table *oldtbl, *newtbl;
 
-	write_lock_bh(&pathtbl_resize_lock);
-	oldtbl = resize_dereference_mpp_paths();
+	write_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
+	oldtbl = resize_dereference_mpp_paths(sdata);
 	newtbl = mesh_table_alloc(oldtbl->size_order + 1);
 	if (!newtbl)
 		goto out;
@@ -654,11 +638,11 @@ void mesh_mpp_table_grow(void)
 		__mesh_table_free(newtbl);
 		goto out;
 	}
-	rcu_assign_pointer(mpp_paths, newtbl);
+	rcu_assign_pointer(sdata->u.mesh.mpp_paths, newtbl);
 	call_rcu(&oldtbl->rcu_head, mesh_table_free_rcu);
 
  out:
-	write_unlock_bh(&pathtbl_resize_lock);
+	write_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 }
 
 int mpp_path_add(struct ieee80211_sub_if_data *sdata,
@@ -690,7 +674,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	if (!new_node)
 		goto err_node_alloc;
 
-	read_lock_bh(&pathtbl_resize_lock);
+	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 	memcpy(new_mpath->dst, dst, ETH_ALEN);
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
 	new_mpath->sdata = sdata;
@@ -701,7 +685,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	new_mpath->exp_time = jiffies;
 	spin_lock_init(&new_mpath->state_lock);
 
-	tbl = resize_dereference_mpp_paths();
+	tbl = resize_dereference_mpp_paths(sdata);
 
 	hash_idx = mesh_table_hash(dst, sdata, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
@@ -711,8 +695,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	err = -EEXIST;
 	hlist_for_each_entry(node, bucket, list) {
 		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    ether_addr_equal(dst, mpath->dst))
+		if (ether_addr_equal(dst, mpath->dst))
 			goto err_exists;
 	}
 
@@ -722,9 +705,9 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		grow = 1;
 
 	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
+	read_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 
-	mpp_paths_generation++;
+	sdata->u.mesh.mpp_paths_generation++;
 
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
@@ -734,7 +717,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 
 err_exists:
 	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
+	read_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 	kfree(new_node);
 err_node_alloc:
 	kfree(new_mpath);
@@ -761,7 +744,7 @@ void mesh_plink_broken(struct sta_info *sta)
 	int i;
 
 	rcu_read_lock();
-	tbl = rcu_dereference(mesh_paths);
+	tbl = rcu_dereference(sdata->u.mesh.mesh_paths);
 	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
 		if (rcu_access_pointer(mpath->next_hop) == sta &&
@@ -819,14 +802,15 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mpath_node *node)
  */
 void mesh_path_flush_by_nexthop(struct sta_info *sta)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	int i;
 
 	rcu_read_lock();
-	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mesh_paths();
+	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
+	tbl = resize_dereference_mesh_paths(sdata);
 	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
 		if (rcu_access_pointer(mpath->next_hop) == sta) {
@@ -835,7 +819,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 			spin_unlock(&tbl->hashwlock[i]);
 		}
 	}
-	read_unlock_bh(&pathtbl_resize_lock);
+	read_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 	rcu_read_unlock();
 }
 
@@ -848,8 +832,8 @@ static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
 	int i;
 
 	rcu_read_lock();
-	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mpp_paths();
+	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
+	tbl = resize_dereference_mpp_paths(sdata);
 	for_each_mesh_entry(tbl, node, i) {
 		mpp = node->mpath;
 		if (ether_addr_equal(mpp->mpp, proxy)) {
@@ -858,7 +842,7 @@ static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
 			spin_unlock(&tbl->hashwlock[i]);
 		}
 	}
-	read_unlock_bh(&pathtbl_resize_lock);
+	read_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 	rcu_read_unlock();
 }
 
@@ -872,8 +856,6 @@ static void table_flush_by_iface(struct mesh_table *tbl,
 	WARN_ON(!rcu_read_lock_held());
 	for_each_mesh_entry(tbl, node, i) {
 		mpath = node->mpath;
-		if (mpath->sdata != sdata)
-			continue;
 		spin_lock_bh(&tbl->hashwlock[i]);
 		__mesh_path_del(tbl, node);
 		spin_unlock_bh(&tbl->hashwlock[i]);
@@ -893,12 +875,12 @@ void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 	struct mesh_table *tbl;
 
 	rcu_read_lock();
-	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mesh_paths();
+	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
+	tbl = resize_dereference_mesh_paths(sdata);
 	table_flush_by_iface(tbl, sdata);
-	tbl = resize_dereference_mpp_paths();
+	tbl = resize_dereference_mpp_paths(sdata);
 	table_flush_by_iface(tbl, sdata);
-	read_unlock_bh(&pathtbl_resize_lock);
+	read_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 	rcu_read_unlock();
 }
 
@@ -922,15 +904,14 @@ static int table_path_del(struct mesh_table __rcu *rcu_tbl,
 	int hash_idx;
 	int err = 0;
 
-	tbl = resize_dereference_paths(rcu_tbl);
+	tbl = resize_dereference_paths(sdata, rcu_tbl);
 	hash_idx = mesh_table_hash(addr, sdata, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
 	spin_lock(&tbl->hashwlock[hash_idx]);
 	hlist_for_each_entry(node, bucket, list) {
 		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    ether_addr_equal(addr, mpath->dst)) {
+		if (ether_addr_equal(addr, mpath->dst)) {
 			__mesh_path_del(tbl, node);
 			goto enddel;
 		}
@@ -957,10 +938,10 @@ int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	/* flush relevant mpp entries first */
 	mpp_flush_by_proxy(sdata, addr);
 
-	read_lock_bh(&pathtbl_resize_lock);
-	err = table_path_del(mesh_paths, sdata, addr);
-	mesh_paths_generation++;
-	read_unlock_bh(&pathtbl_resize_lock);
+	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
+	err = table_path_del(sdata->u.mesh.mesh_paths, sdata, addr);
+	sdata->u.mesh.mesh_paths_generation++;
+	read_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 
 	return err;
 }
@@ -977,10 +958,10 @@ static int mpp_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 {
 	int err = 0;
 
-	read_lock_bh(&pathtbl_resize_lock);
-	err = table_path_del(mpp_paths, sdata, addr);
-	mpp_paths_generation++;
-	read_unlock_bh(&pathtbl_resize_lock);
+	read_lock_bh(&sdata->u.mesh.pathtbl_resize_lock);
+	err = table_path_del(sdata->u.mesh.mpp_paths, sdata, addr);
+	sdata->u.mesh.mpp_paths_generation++;
+	read_unlock_bh(&sdata->u.mesh.pathtbl_resize_lock);
 
 	return err;
 }
@@ -1020,7 +1001,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 	struct hlist_head *known_gates;
 
 	rcu_read_lock();
-	tbl = rcu_dereference(mesh_paths);
+	tbl = rcu_dereference(sdata->u.mesh.mesh_paths);
 	known_gates = tbl->known_gates;
 	rcu_read_unlock();
 
@@ -1028,9 +1009,6 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 		return -EHOSTUNREACH;
 
 	hlist_for_each_entry_rcu(gate, known_gates, list) {
-		if (gate->mpath->sdata != sdata)
-			continue;
-
 		if (gate->mpath->flags & MESH_PATH_ACTIVE) {
 			mpath_dbg(sdata, "Forwarding to %pM\n", gate->mpath->dst);
 			mesh_path_move_to_queue(gate->mpath, from_mpath, copy);
@@ -1043,11 +1021,10 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 		}
 	}
 
-	hlist_for_each_entry_rcu(gate, known_gates, list)
-		if (gate->mpath->sdata == sdata) {
-			mpath_dbg(sdata, "Sending to %pM\n", gate->mpath->dst);
-			mesh_path_tx_pending(gate->mpath);
-		}
+	hlist_for_each_entry_rcu(gate, known_gates, list) {
+		mpath_dbg(sdata, "Sending to %pM\n", gate->mpath->dst);
+		mesh_path_tx_pending(gate->mpath);
+	}
 
 	return (from_mpath == mpath) ? -EHOSTUNREACH : 0;
 }
@@ -1136,7 +1113,7 @@ static int mesh_path_node_copy(struct hlist_node *p, struct mesh_table *newtbl)
 	return 0;
 }
 
-int mesh_pathtbl_init(void)
+int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_table *tbl_path, *tbl_mpp;
 	int ret;
@@ -1168,9 +1145,11 @@ int mesh_pathtbl_init(void)
 	}
 	INIT_HLIST_HEAD(tbl_mpp->known_gates);
 
+	rwlock_init(&sdata->u.mesh.pathtbl_resize_lock);
+
 	/* Need no locking since this is during init */
-	RCU_INIT_POINTER(mesh_paths, tbl_path);
-	RCU_INIT_POINTER(mpp_paths, tbl_mpp);
+	RCU_INIT_POINTER(sdata->u.mesh.mesh_paths, tbl_path);
+	RCU_INIT_POINTER(sdata->u.mesh.mpp_paths, tbl_mpp);
 
 	return 0;
 
@@ -1189,33 +1168,31 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 	int i;
 
 	rcu_read_lock();
-	tbl = rcu_dereference(mesh_paths);
+	tbl = rcu_dereference(sdata->u.mesh.mesh_paths);
 	for_each_mesh_entry(tbl, node, i) {
-		if (node->mpath->sdata != sdata)
-			continue;
 		mpath = node->mpath;
 		if ((!(mpath->flags & MESH_PATH_RESOLVING)) &&
 		    (!(mpath->flags & MESH_PATH_FIXED)) &&
 		     time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE))
-			mesh_path_del(mpath->sdata, mpath->dst);
+			mesh_path_del(sdata, mpath->dst);
 	}
 
-	tbl = rcu_dereference(mpp_paths);
+	tbl = rcu_dereference(sdata->u.mesh.mpp_paths);
 	for_each_mesh_entry(tbl, node, i) {
-		if (node->mpath->sdata != sdata)
-			continue;
 		mpath = node->mpath;
 		if ((!(mpath->flags & MESH_PATH_FIXED)) &&
 		    time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE))
-			mpp_path_del(mpath->sdata, mpath->dst);
+			mpp_path_del(sdata, mpath->dst);
 	}
 
 	rcu_read_unlock();
 }
 
-void mesh_pathtbl_unregister(void)
+void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata)
 {
 	/* no need for locking during exit path */
-	mesh_table_free(rcu_dereference_protected(mesh_paths, 1), true);
-	mesh_table_free(rcu_dereference_protected(mpp_paths, 1), true);
+	mesh_table_free(rcu_dereference_protected(sdata->u.mesh.mesh_paths, 1),
+			true);
+	mesh_table_free(rcu_dereference_protected(sdata->u.mesh.mpp_paths, 1),
+			true);
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3a7475ff1a41..4388a7a91c42 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2181,7 +2181,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			}
 
 			if (mppath && mpath)
-				mesh_path_del(mpath->sdata, mpath->dst);
+				mesh_path_del(sdata, mpath->dst);
 		}
 
 		/*
-- 
2.6.1

