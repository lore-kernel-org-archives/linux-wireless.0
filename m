Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1ENJ4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 05:56:20 -0400
Subject: [PATCH] mac80211: annotate and fix RCU in mesh code
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 11:56:16 +0200
Message-ID: <1305366976.3437.11.camel@jlt3.sipsolutions.net> (sfid-20110514_115624_510848_E01DA8D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds proper RCU annotations to the mesh path
table code, and fixes a number of bugs in the code
that I found while checking the sparse warnings I
got as a result of the annotations.

Some things like the changes in mesh_path_add() or
mesh_pathtbl_init() only serve to shut up sparse,
but other changes like the changes surrounding the
for_each_mesh_entry() macro fix real RCU bugs in
the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.h         |    4 -
 net/mac80211/mesh_pathtbl.c |  156 +++++++++++++++++++++++++++++---------------
 2 files changed, 103 insertions(+), 57 deletions(-)

--- a/net/mac80211/mesh_pathtbl.c	2011-05-14 11:06:34.000000000 +0200
+++ b/net/mac80211/mesh_pathtbl.c	2011-05-14 11:43:26.000000000 +0200
@@ -36,8 +36,8 @@ struct mpath_node {
 	struct mesh_path *mpath;
 };
 
-static struct mesh_table *mesh_paths;
-static struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
+static struct mesh_table __rcu *mesh_paths;
+static struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */
 
 int mesh_paths_generation;
 
@@ -48,6 +48,29 @@ int mesh_paths_generation;
 static DEFINE_RWLOCK(pathtbl_resize_lock);
 
 
+static inline struct mesh_table *resize_dereference_mesh_paths(void)
+{
+	return rcu_dereference_protected(mesh_paths,
+		lockdep_is_held(&pathtbl_resize_lock));
+}
+
+static inline struct mesh_table *resize_dereference_mpp_paths(void)
+{
+	return rcu_dereference_protected(mpp_paths,
+		lockdep_is_held(&pathtbl_resize_lock));
+}
+
+/*
+ * CAREFUL -- "tbl" must not be an expression,
+ * in particular not an rcu_dereference(), since
+ * it's used twice. So it is illegal to do
+ *	for_each_mesh_entry(rcu_dereference(...), ...)
+ */
+#define for_each_mesh_entry(tbl, p, node, i) \
+	for (i = 0; i <= tbl->hash_mask; i++) \
+		hlist_for_each_entry_rcu(node, p, &tbl->hash_buckets[i], list)
+
+
 static struct mesh_table *mesh_table_alloc(int size_order)
 {
 	int i;
@@ -258,12 +281,13 @@ struct mesh_path *mpp_path_lookup(u8 *ds
  */
 struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data *sdata)
 {
+	struct mesh_table *tbl = rcu_dereference(mesh_paths);
 	struct mpath_node *node;
 	struct hlist_node *p;
 	int i;
 	int j = 0;
 
-	for_each_mesh_entry(mesh_paths, p, node, i) {
+	for_each_mesh_entry(tbl, p, node, i) {
 		if (sdata && node->mpath->sdata != sdata)
 			continue;
 		if (j++ == idx) {
@@ -293,6 +317,7 @@ int mesh_path_add(u8 *dst, struct ieee80
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	struct mesh_table *tbl;
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
 	struct hlist_head *bucket;
@@ -332,10 +357,12 @@ int mesh_path_add(u8 *dst, struct ieee80
 	spin_lock_init(&new_mpath->state_lock);
 	init_timer(&new_mpath->timer);
 
-	hash_idx = mesh_table_hash(dst, sdata, mesh_paths);
-	bucket = &mesh_paths->hash_buckets[hash_idx];
+	tbl = resize_dereference_mesh_paths();
 
-	spin_lock_bh(&mesh_paths->hashwlock[hash_idx]);
+	hash_idx = mesh_table_hash(dst, sdata, tbl);
+	bucket = &tbl->hash_buckets[hash_idx];
+
+	spin_lock_bh(&tbl->hashwlock[hash_idx]);
 
 	err = -EEXIST;
 	hlist_for_each_entry(node, n, bucket, list) {
@@ -345,13 +372,13 @@ int mesh_path_add(u8 *dst, struct ieee80
 	}
 
 	hlist_add_head_rcu(&new_node->list, bucket);
-	if (atomic_inc_return(&mesh_paths->entries) >=
-		mesh_paths->mean_chain_len * (mesh_paths->hash_mask + 1))
+	if (atomic_inc_return(&tbl->entries) >=
+	    tbl->mean_chain_len * (tbl->hash_mask + 1))
 		grow = 1;
 
 	mesh_paths_generation++;
 
-	spin_unlock_bh(&mesh_paths->hashwlock[hash_idx]);
+	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPATH_TABLE,  &ifmsh->wrkq_flags);
@@ -360,7 +387,7 @@ int mesh_path_add(u8 *dst, struct ieee80
 	return 0;
 
 err_exists:
-	spin_unlock_bh(&mesh_paths->hashwlock[hash_idx]);
+	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	kfree(new_node);
 err_node_alloc:
@@ -382,11 +409,11 @@ void mesh_mpath_table_grow(void)
 	struct mesh_table *oldtbl, *newtbl;
 
 	write_lock_bh(&pathtbl_resize_lock);
-	newtbl = mesh_table_alloc(mesh_paths->size_order + 1);
+	oldtbl = resize_dereference_mesh_paths();
+	newtbl = mesh_table_alloc(oldtbl->size_order + 1);
 	if (!newtbl)
 		goto out;
-	oldtbl = mesh_paths;
-	if (mesh_table_grow(mesh_paths, newtbl) < 0) {
+	if (mesh_table_grow(oldtbl, newtbl) < 0) {
 		__mesh_table_free(newtbl);
 		goto out;
 	}
@@ -403,11 +430,11 @@ void mesh_mpp_table_grow(void)
 	struct mesh_table *oldtbl, *newtbl;
 
 	write_lock_bh(&pathtbl_resize_lock);
-	newtbl = mesh_table_alloc(mpp_paths->size_order + 1);
+	oldtbl = resize_dereference_mpp_paths();
+	newtbl = mesh_table_alloc(oldtbl->size_order + 1);
 	if (!newtbl)
 		goto out;
-	oldtbl = mpp_paths;
-	if (mesh_table_grow(mpp_paths, newtbl) < 0) {
+	if (mesh_table_grow(oldtbl, newtbl) < 0) {
 		__mesh_table_free(newtbl);
 		goto out;
 	}
@@ -422,6 +449,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struc
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	struct mesh_table *tbl;
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
 	struct hlist_head *bucket;
@@ -456,10 +484,12 @@ int mpp_path_add(u8 *dst, u8 *mpp, struc
 	new_mpath->exp_time = jiffies;
 	spin_lock_init(&new_mpath->state_lock);
 
-	hash_idx = mesh_table_hash(dst, sdata, mpp_paths);
-	bucket = &mpp_paths->hash_buckets[hash_idx];
+	tbl = resize_dereference_mpp_paths();
 
-	spin_lock_bh(&mpp_paths->hashwlock[hash_idx]);
+	hash_idx = mesh_table_hash(dst, sdata, tbl);
+	bucket = &tbl->hash_buckets[hash_idx];
+
+	spin_lock_bh(&tbl->hashwlock[hash_idx]);
 
 	err = -EEXIST;
 	hlist_for_each_entry(node, n, bucket, list) {
@@ -469,11 +499,11 @@ int mpp_path_add(u8 *dst, u8 *mpp, struc
 	}
 
 	hlist_add_head_rcu(&new_node->list, bucket);
-	if (atomic_inc_return(&mpp_paths->entries) >=
-		mpp_paths->mean_chain_len * (mpp_paths->hash_mask + 1))
+	if (atomic_inc_return(&tbl->entries) >=
+	    tbl->mean_chain_len * (tbl->hash_mask + 1))
 		grow = 1;
 
-	spin_unlock_bh(&mpp_paths->hashwlock[hash_idx]);
+	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
@@ -482,7 +512,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struc
 	return 0;
 
 err_exists:
-	spin_unlock_bh(&mpp_paths->hashwlock[hash_idx]);
+	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	kfree(new_node);
 err_node_alloc:
@@ -502,6 +532,7 @@ err_path_alloc:
  */
 void mesh_plink_broken(struct sta_info *sta)
 {
+	struct mesh_table *tbl;
 	static const u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct mesh_path *mpath;
 	struct mpath_node *node;
@@ -510,10 +541,11 @@ void mesh_plink_broken(struct sta_info *
 	int i;
 
 	rcu_read_lock();
-	for_each_mesh_entry(mesh_paths, p, node, i) {
+	tbl = rcu_dereference(mesh_paths);
+	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
 		spin_lock_bh(&mpath->state_lock);
-		if (mpath->next_hop == sta &&
+		if (rcu_dereference(mpath->next_hop) == sta &&
 		    mpath->flags & MESH_PATH_ACTIVE &&
 		    !(mpath->flags & MESH_PATH_FIXED)) {
 			mpath->flags &= ~MESH_PATH_ACTIVE;
@@ -542,30 +574,38 @@ void mesh_plink_broken(struct sta_info *
  */
 void mesh_path_flush_by_nexthop(struct sta_info *sta)
 {
+	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_node *p;
 	int i;
 
-	for_each_mesh_entry(mesh_paths, p, node, i) {
+	rcu_read_lock();
+	tbl = rcu_dereference(mesh_paths);
+	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
-		if (mpath->next_hop == sta)
+		if (rcu_dereference(mpath->next_hop) == sta)
 			mesh_path_del(mpath->dst, mpath->sdata);
 	}
+	rcu_read_unlock();
 }
 
 void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
 {
+	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_node *p;
 	int i;
 
-	for_each_mesh_entry(mesh_paths, p, node, i) {
+	rcu_read_lock();
+	tbl = rcu_dereference(mesh_paths);
+	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata)
 			mesh_path_del(mpath->dst, mpath->sdata);
 	}
+	rcu_read_unlock();
 }
 
 static void mesh_path_node_reclaim(struct rcu_head *rp)
@@ -589,6 +629,7 @@ static void mesh_path_node_reclaim(struc
  */
 int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 {
+	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_head *bucket;
@@ -597,19 +638,20 @@ int mesh_path_del(u8 *addr, struct ieee8
 	int err = 0;
 
 	read_lock_bh(&pathtbl_resize_lock);
-	hash_idx = mesh_table_hash(addr, sdata, mesh_paths);
-	bucket = &mesh_paths->hash_buckets[hash_idx];
+	tbl = resize_dereference_mesh_paths();
+	hash_idx = mesh_table_hash(addr, sdata, tbl);
+	bucket = &tbl->hash_buckets[hash_idx];
 
-	spin_lock_bh(&mesh_paths->hashwlock[hash_idx]);
+	spin_lock_bh(&tbl->hashwlock[hash_idx]);
 	hlist_for_each_entry(node, n, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
-				memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
+		    memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
 			spin_lock_bh(&mpath->state_lock);
 			mpath->flags |= MESH_PATH_RESOLVING;
 			hlist_del_rcu(&node->list);
 			call_rcu(&node->rcu, mesh_path_node_reclaim);
-			atomic_dec(&mesh_paths->entries);
+			atomic_dec(&tbl->entries);
 			spin_unlock_bh(&mpath->state_lock);
 			goto enddel;
 		}
@@ -618,7 +660,7 @@ int mesh_path_del(u8 *addr, struct ieee8
 	err = -ENXIO;
 enddel:
 	mesh_paths_generation++;
-	spin_unlock_bh(&mesh_paths->hashwlock[hash_idx]);
+	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	return err;
 }
@@ -745,52 +787,60 @@ static int mesh_path_node_copy(struct hl
 
 int mesh_pathtbl_init(void)
 {
-	mesh_paths = mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
-	if (!mesh_paths)
+	struct mesh_table *tbl_path, *tbl_mpp;
+
+	tbl_path = mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
+	if (!tbl_path)
 		return -ENOMEM;
-	mesh_paths->free_node = &mesh_path_node_free;
-	mesh_paths->copy_node = &mesh_path_node_copy;
-	mesh_paths->mean_chain_len = MEAN_CHAIN_LEN;
-
-	mpp_paths = mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
-	if (!mpp_paths) {
-		mesh_table_free(mesh_paths, true);
+	tbl_path->free_node = &mesh_path_node_free;
+	tbl_path->copy_node = &mesh_path_node_copy;
+	tbl_path->mean_chain_len = MEAN_CHAIN_LEN;
+
+	tbl_mpp = mesh_table_alloc(INIT_PATHS_SIZE_ORDER);
+	if (!tbl_mpp) {
+		mesh_table_free(tbl_path, true);
 		return -ENOMEM;
 	}
-	mpp_paths->free_node = &mesh_path_node_free;
-	mpp_paths->copy_node = &mesh_path_node_copy;
-	mpp_paths->mean_chain_len = MEAN_CHAIN_LEN;
+	tbl_mpp->free_node = &mesh_path_node_free;
+	tbl_mpp->copy_node = &mesh_path_node_copy;
+	tbl_mpp->mean_chain_len = MEAN_CHAIN_LEN;
+
+	/* Need no locking since this is during init */
+	RCU_INIT_POINTER(mesh_paths, tbl_path);
+	RCU_INIT_POINTER(mpp_paths, tbl_mpp);
 
 	return 0;
 }
 
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 {
+	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_node *p;
 	int i;
 
-	read_lock_bh(&pathtbl_resize_lock);
-	for_each_mesh_entry(mesh_paths, p, node, i) {
+	rcu_read_lock();
+	tbl = rcu_dereference(mesh_paths);
+	for_each_mesh_entry(tbl, p, node, i) {
 		if (node->mpath->sdata != sdata)
 			continue;
 		mpath = node->mpath;
 		spin_lock_bh(&mpath->state_lock);
 		if ((!(mpath->flags & MESH_PATH_RESOLVING)) &&
 		    (!(mpath->flags & MESH_PATH_FIXED)) &&
-			time_after(jiffies,
-			 mpath->exp_time + MESH_PATH_EXPIRE)) {
+		     time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE)) {
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_del(mpath->dst, mpath->sdata);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
-	read_unlock_bh(&pathtbl_resize_lock);
+	rcu_read_unlock();
 }
 
 void mesh_pathtbl_unregister(void)
 {
-	mesh_table_free(mesh_paths, true);
-	mesh_table_free(mpp_paths, true);
+	/* no need for locking during exit path */
+	mesh_table_free(rcu_dereference_raw(mesh_paths), true);
+	mesh_table_free(rcu_dereference_raw(mpp_paths), true);
 }
--- a/net/mac80211/mesh.h	2011-05-14 11:22:20.000000000 +0200
+++ b/net/mac80211/mesh.h	2011-05-14 11:32:33.000000000 +0200
@@ -289,10 +289,6 @@ static inline bool mesh_path_sel_is_hwmp
 	return sdata->u.mesh.mesh_pp_id == IEEE80211_PATH_PROTOCOL_HWMP;
 }
 
-#define for_each_mesh_entry(x, p, node, i) \
-	for (i = 0; i <= x->hash_mask; i++) \
-		hlist_for_each_entry_rcu(node, p, &x->hash_buckets[i], list)
-
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 
 void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);


