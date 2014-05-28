Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37491 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaE1Key (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 06:34:54 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so3431629wib.13
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 03:34:52 -0700 (PDT)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Pedersen <thomas@noack.us>
Subject: [RFC Patch v2] Unify mpp/mesh_path handling for Mac 802.11s
Date: Wed, 28 May 2014 12:34:46 +0200
Message-ID: <2083629.VLZzpqGjAs@desktop.local> (sfid-20140528_123459_328970_F1219E30)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I looked a little bit more into the 802.11s mesh code to see if there is still
a chance for unifying some code without forcing the issue as the last patch
did.

The result was the attached patch, which still needs one "if (mpp) ... else"
block but unifies most of the code for mpp_path_add() and mesh_path_add().

If this is still too much I would suggest leaving the mesh_pathtbl code as it is.

While looking through the code I noticed that there seems to be no code-path
that removes stall mpp_path entries (except for the removal of the mesh
interface) ! Unless I overlooked something this would be a way to use up all
existing memory of the kernel by sending it 802.11s packets with changing
proxied addresses.

I have added an atomic counter to restrict the number of proxied paths
(similar to the restriction of the mesh paths), but I am not convinced that
this would be enough. There needs to be some timeout mechanism, but resetting
the timeout of a MPP every times we receive an unicast from it sounds
expensive.

Henning Rogge

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f169b6e..acb40a9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -580,6 +580,7 @@ struct ieee80211_if_mesh {
 	/* Last used PREQ ID */
 	u32 preq_id;
 	atomic_t mpaths;
+	atomic_t mpps;
 	/* Timestamp of last SN update */
 	unsigned long last_sn_update;
 	/* Time when it's ok to send next PERR */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f70e9cd..598a1f0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1324,6 +1324,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 
 	ifmsh->accepting_plinks = true;
 	atomic_set(&ifmsh->mpaths, 0);
+	atomic_set(&ifmsh->mpps, 0);
 	mesh_rmc_init(sdata);
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index f39a19f..dd128ff 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -200,6 +200,9 @@ struct mesh_rmc {
 /* Maximum number of paths per interface */
 #define MESH_MAX_MPATHS		1024
 
+/* Maximum number of proxied paths per interface */
+#define MESH_MAX_MPPS		1024
+
 /* Number of frames buffered per destination for unresolved destinations */
 #define MESH_FRAME_QUEUE_LEN	10
 
@@ -266,10 +269,12 @@ struct mesh_path *mesh_path_lookup(struct ieee80211_sub_if_data *sdata,
 				   const u8 *dst);
 struct mesh_path *mpp_path_lookup(struct ieee80211_sub_if_data *sdata,
 				  const u8 *dst);
-int mpp_path_add(struct ieee80211_sub_if_data *sdata,
+struct mesh_path * mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		 const u8 *dst, const u8 *mpp);
 struct mesh_path *
 mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx);
+struct mesh_path *
+mpp_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7d050ed..4d39908 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -484,101 +484,6 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata)
 	return sdata->u.mesh.num_gates;
 }
 
-/**
- * mesh_path_add - allocate and add a new path to the mesh path table
- * @dst: destination address of the path (ETH_ALEN length)
- * @sdata: local subif
- *
- * Returns: 0 on success
- *
- * State: the initial state of the new path is set to 0
- */
-struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
-				const u8 *dst)
-{
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
-	struct mesh_table *tbl;
-	struct mesh_path *mpath, *new_mpath;
-	struct mpath_node *node, *new_node;
-	struct hlist_head *bucket;
-	int grow = 0;
-	int err;
-	u32 hash_idx;
-
-	if (ether_addr_equal(dst, sdata->vif.addr))
-		/* never add ourselves as neighbours */
-		return ERR_PTR(-ENOTSUPP);
-
-	if (is_multicast_ether_addr(dst))
-		return ERR_PTR(-ENOTSUPP);
-
-	if (atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS) == 0)
-		return ERR_PTR(-ENOSPC);
-
-	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mesh_paths();
-
-	hash_idx = mesh_table_hash(dst, sdata, tbl);
-	bucket = &tbl->hash_buckets[hash_idx];
-
-	spin_lock(&tbl->hashwlock[hash_idx]);
-
-	hlist_for_each_entry(node, bucket, list) {
-		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    ether_addr_equal(dst, mpath->dst))
-			goto found;
-	}
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
-	memcpy(new_mpath->dst, dst, ETH_ALEN);
-	eth_broadcast_addr(new_mpath->rann_snd_addr);
-	new_mpath->is_root = false;
-	new_mpath->sdata = sdata;
-	new_mpath->flags = 0;
-	skb_queue_head_init(&new_mpath->frame_queue);
-	new_node->mpath = new_mpath;
-	new_mpath->timer.data = (unsigned long) new_mpath;
-	new_mpath->timer.function = mesh_path_timer;
-	new_mpath->exp_time = jiffies;
-	spin_lock_init(&new_mpath->state_lock);
-	init_timer(&new_mpath->timer);
-
-	hlist_add_head_rcu(&new_node->list, bucket);
-	if (atomic_inc_return(&tbl->entries) >=
-	    tbl->mean_chain_len * (tbl->hash_mask + 1))
-		grow = 1;
-
-	mesh_paths_generation++;
-
-	if (grow) {
-		set_bit(MESH_WORK_GROW_MPATH_TABLE,  &ifmsh->wrkq_flags);
-		ieee80211_queue_work(&local->hw, &sdata->work);
-	}
-	mpath = new_mpath;
-found:
-	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
-	return mpath;
-
-err_node_alloc:
-	kfree(new_mpath);
-err_path_alloc:
-	atomic_dec(&sdata->u.mesh.mpaths);
-	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
-	return ERR_PTR(err);
-}
-
 static void mesh_table_free_rcu(struct rcu_head *rcu)
 {
 	struct mesh_table *tbl = container_of(rcu, struct mesh_table, rcu_head);
@@ -627,12 +532,13 @@ void mesh_mpp_table_grow(void)
 	write_unlock_bh(&pathtbl_resize_lock);
 }
 
-int mpp_path_add(struct ieee80211_sub_if_data *sdata,
+static struct mesh_path *mpath_add(struct mesh_table *tbl,
+		atomic_t *counter, int max_counter, int mesh_work_flag,
+		struct ieee80211_sub_if_data *sdata,
 		 const u8 *dst, const u8 *mpp)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
-	struct mesh_table *tbl;
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
 	struct hlist_head *bucket;
@@ -642,10 +548,27 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 
 	if (ether_addr_equal(dst, sdata->vif.addr))
 		/* never add ourselves as neighbours */
-		return -ENOTSUPP;
+		return ERR_PTR(-ENOTSUPP);
 
 	if (is_multicast_ether_addr(dst))
-		return -ENOTSUPP;
+		return ERR_PTR(-ENOTSUPP);
+
+	if (atomic_add_unless(counter, 1, max_counter) == 0)
+		return ERR_PTR(-ENOSPC);
+
+	read_lock_bh(&pathtbl_resize_lock);
+	hash_idx = mesh_table_hash(dst, sdata, tbl);
+	bucket = &tbl->hash_buckets[hash_idx];
+
+	spin_lock(&tbl->hashwlock[hash_idx]);
+
+	err = -EEXIST;
+	hlist_for_each_entry(node, bucket, list) {
+		mpath = node->mpath;
+		if (mpath->sdata == sdata &&
+		    ether_addr_equal(dst, mpath->dst))
+			goto found;
+	}
 
 	err = -ENOMEM;
 	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_ATOMIC);
@@ -656,32 +579,26 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	if (!new_node)
 		goto err_node_alloc;
 
-	read_lock_bh(&pathtbl_resize_lock);
 	memcpy(new_mpath->dst, dst, ETH_ALEN);
-	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
+	if (!mpp) {
+		eth_broadcast_addr(new_mpath->rann_snd_addr);
+
+		init_timer(&new_mpath->timer);
+		new_mpath->timer.data = (unsigned long) new_mpath;
+		new_mpath->timer.function = mesh_path_timer;
+	}
+	else {
+		memcpy(new_mpath->mpp, mpp, ETH_ALEN);
+	}
+
+	new_mpath->is_root = false;
 	new_mpath->sdata = sdata;
 	new_mpath->flags = 0;
 	skb_queue_head_init(&new_mpath->frame_queue);
 	new_node->mpath = new_mpath;
-	init_timer(&new_mpath->timer);
 	new_mpath->exp_time = jiffies;
 	spin_lock_init(&new_mpath->state_lock);
 
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
 	hlist_add_head_rcu(&new_node->list, bucket);
 	if (atomic_inc_return(&tbl->entries) >=
 	    tbl->mean_chain_len * (tbl->hash_mask + 1))
@@ -690,21 +607,57 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	if (grow) {
-		set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
+		set_bit(mesh_work_flag,  &ifmsh->wrkq_flags);
 		ieee80211_queue_work(&local->hw, &sdata->work);
 	}
 	return 0;
 
-err_exists:
+found:
 	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
-	kfree(new_node);
+	return mpath;
 err_node_alloc:
 	kfree(new_mpath);
 err_path_alloc:
-	return err;
+	atomic_dec(counter);
+	spin_unlock(&tbl->hashwlock[hash_idx]);
+	read_unlock_bh(&pathtbl_resize_lock);
+	return ERR_PTR(err);
 }
 
+/**
+ * mpp_path_add - allocate and add a new proxied path to
+ * the mesh proxied path table
+ * @sdata: local subif
+ * @dst: destination address of the path (ETH_ALEN length)
+ * @mpp: last mesh node that proxies the destination (ETH_ALEN length)
+ *
+ * Returns: pointer to mesh_path
+ *
+ * State: the initial state of the new path is set to 0
+ */
+struct mesh_path *mpp_path_add(struct ieee80211_sub_if_data *sdata,
+			       const u8 *dst, const u8 *mpp) {
+	struct mesh_table *tbl = resize_dereference_mpp_paths();
+	return mpath_add(tbl, &sdata->u.mesh.mpps, MESH_MAX_MPPS,
+			 MESH_WORK_GROW_MPP_TABLE, sdata, dst, mpp);
+}
+
+/**
+ * mesh_path_add - allocate and add a new path to the mesh path table
+ * @sdata: local subif
+ * @dst: destination address of the path (ETH_ALEN length)
+ *
+ * Returns: pointer to mesh_path
+ *
+ * State: the initial state of the new path is set to 0
+ */
+struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
+				const u8 *dst) {
+	struct mesh_table *tbl = resize_dereference_mesh_paths();
+	return mpath_add(tbl, &sdata->u.mesh.mpaths, MESH_MAX_MPATHS,
+			 MESH_WORK_GROW_MPATH_TABLE, sdata, dst, NULL);
+}
 
 /**
  * mesh_plink_broken - deactivates paths and sends perr when a link breaks

