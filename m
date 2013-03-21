Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41471 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab3CUCUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 22:20:19 -0400
Received: by mail-ie0-f177.google.com with SMTP id 16so2988897iea.36
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 19:20:18 -0700 (PDT)
Date: Wed, 20 Mar 2013 22:20:33 -0400
From: Bob Copeland <me@bobcopeland.com>
To: thomas@cozybit.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: return new mpath from mesh_path_add()
Message-ID: <20130321022033.GA17491@localhost> (sfid-20130321_032034_650524_366DB58D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most times that mesh_path_add() is called, it is followed by
a lookup to get the just-added mpath.  We can instead just
return the new mpath in the case that we allocated one (or the
existing one if already there), so do that.  Also, reorder the
code in mesh_path_add a bit so that we don't need to allocate
in the pre-existing case.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/cfg.c          |   12 +++-------
 net/mac80211/mesh.h         |    3 ++-
 net/mac80211/mesh_hwmp.c    |   22 +++++++----------
 net/mac80211/mesh_pathtbl.c |   56 +++++++++++++++++++++----------------------
 4 files changed, 42 insertions(+), 51 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 986556d..9c25afcb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1528,7 +1528,6 @@ static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
-	int err;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -1539,17 +1538,12 @@ static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 		return -ENOENT;
 	}
 
-	err = mesh_path_add(sdata, dst);
-	if (err) {
+	mpath = mesh_path_add(sdata, dst);
+	if (IS_ERR(mpath)) {
 		rcu_read_unlock();
-		return err;
+		return PTR_ERR(mpath);
 	}
 
-	mpath = mesh_path_lookup(sdata, dst);
-	if (!mpath) {
-		rcu_read_unlock();
-		return -ENXIO;
-	}
 	mesh_path_fix_nexthop(mpath, sta);
 
 	rcu_read_unlock();
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 336c88a..b5df334 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -275,7 +275,8 @@ void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt, size_t len);
-int mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst);
+struct mesh_path *
+mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst);
 
 int mesh_path_add_gate(struct mesh_path *mpath);
 int mesh_path_send_to_gates(struct mesh_path *mpath);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index bdb8d3b..ab9c65a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -445,9 +445,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 				}
 			}
 		} else {
-			mesh_path_add(sdata, orig_addr);
-			mpath = mesh_path_lookup(sdata, orig_addr);
-			if (!mpath) {
+			mpath = mesh_path_add(sdata, orig_addr);
+			if (IS_ERR(mpath)) {
 				rcu_read_unlock();
 				return 0;
 			}
@@ -486,9 +485,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 					(last_hop_metric > mpath->metric)))
 				fresh_info = false;
 		} else {
-			mesh_path_add(sdata, ta);
-			mpath = mesh_path_lookup(sdata, ta);
-			if (!mpath) {
+			mpath = mesh_path_add(sdata, ta);
+			if (IS_ERR(mpath)) {
 				rcu_read_unlock();
 				return 0;
 			}
@@ -804,9 +802,8 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	mpath = mesh_path_lookup(sdata, orig_addr);
 	if (!mpath) {
-		mesh_path_add(sdata, orig_addr);
-		mpath = mesh_path_lookup(sdata, orig_addr);
-		if (!mpath) {
+		mpath = mesh_path_add(sdata, orig_addr);
+		if (IS_ERR(mpath)) {
 			rcu_read_unlock();
 			sdata->u.mesh.mshstats.dropped_frames_no_route++;
 			return;
@@ -1098,11 +1095,10 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 	/* no nexthop found, start resolving */
 	mpath = mesh_path_lookup(sdata, target_addr);
 	if (!mpath) {
-		mesh_path_add(sdata, target_addr);
-		mpath = mesh_path_lookup(sdata, target_addr);
-		if (!mpath) {
+		mpath = mesh_path_add(sdata, target_addr);
+		if (IS_ERR(mpath)) {
 			mesh_path_discard_frame(sdata, skb);
-			err = -ENOSPC;
+			err = PTR_ERR(mpath);
 			goto endlookup;
 		}
 	}
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 6b3c4e1..01305a6 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -496,7 +496,8 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata)
  *
  * State: the initial state of the new path is set to 0
  */
-int mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst)
+struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
+				const u8 *dst)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
@@ -506,18 +507,33 @@ int mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 	struct hlist_head *bucket;
 	struct hlist_node *n;
 	int grow = 0;
-	int err = 0;
+	int err;
 	u32 hash_idx;
 
 	if (ether_addr_equal(dst, sdata->vif.addr))
 		/* never add ourselves as neighbours */
-		return -ENOTSUPP;
+		return ERR_PTR(-ENOTSUPP);
 
 	if (is_multicast_ether_addr(dst))
-		return -ENOTSUPP;
+		return ERR_PTR(-ENOTSUPP);
 
 	if (atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS) == 0)
-		return -ENOSPC;
+		return ERR_PTR(-ENOSPC);
+
+	read_lock_bh(&pathtbl_resize_lock);
+	tbl = resize_dereference_mesh_paths();
+
+	hash_idx = mesh_table_hash(dst, sdata, tbl);
+	bucket = &tbl->hash_buckets[hash_idx];
+
+	spin_lock(&tbl->hashwlock[hash_idx]);
+
+	hlist_for_each_entry(node, n, bucket, list) {
+		mpath = node->mpath;
+		if (mpath->sdata == sdata &&
+		    ether_addr_equal(dst, mpath->dst))
+			goto found;
+	}
 
 	err = -ENOMEM;
 	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_ATOMIC);
@@ -528,7 +544,6 @@ int mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 	if (!new_node)
 		goto err_node_alloc;
 
-	read_lock_bh(&pathtbl_resize_lock);
 	memcpy(new_mpath->dst, dst, ETH_ALEN);
 	eth_broadcast_addr(new_mpath->rann_snd_addr);
 	new_mpath->is_root = false;
@@ -542,21 +557,6 @@ int mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 	spin_lock_init(&new_mpath->state_lock);
 	init_timer(&new_mpath->timer);
 
-	tbl = resize_dereference_mesh_paths();
-
-	hash_idx = mesh_table_hash(dst, sdata, tbl);
-	bucket = &tbl->hash_buckets[hash_idx];
-
-	spin_lock(&tbl->hashwlock[hash_idx]);
-
-	err = -EEXIST;
-	hlist_for_each_entry(node, n, bucket, list) {
-		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    ether_addr_equal(dst, mpath->dst))
-			goto err_exists;
-	}
-
 	hlist_add_head_rcu(&new_node->list, bucket);
 	if (atomic_inc_return(&tbl->entries) >=
 	    tbl->mean_chain_len * (tbl->hash_mask + 1))
@@ -564,23 +564,23 @@ int mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 
 	mesh_paths_generation++;
 
-	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPATH_TABLE,  &ifmsh->wrkq_flags);
 		ieee80211_queue_work(&local->hw, &sdata->work);
 	}
-	return 0;
-
-err_exists:
+	mpath = new_mpath;
+found:
 	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
-	kfree(new_node);
+	return mpath;
+
 err_node_alloc:
 	kfree(new_mpath);
 err_path_alloc:
 	atomic_dec(&sdata->u.mesh.mpaths);
-	return err;
+	spin_unlock(&tbl->hashwlock[hash_idx]);
+	read_unlock_bh(&pathtbl_resize_lock);
+	return ERR_PTR(err);
 }
 
 static void mesh_table_free_rcu(struct rcu_head *rcu)
-- 
1.7.10.4

-- 
Bob Copeland %% www.bobcopeland.com
