Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:57264 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587AbZHHDud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 23:50:33 -0400
Received: by mail-pz0-f196.google.com with SMTP id 34so1943403pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 20:50:34 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH 8/8] mac80211: Moved mpath and mpp growth to mesh workqueue.
Date: Fri,  7 Aug 2009 20:38:31 -0700
Message-Id: <1249702711-32737-9-git-send-email-javier@cozybit.com>
In-Reply-To: <1249702711-32737-8-git-send-email-javier@cozybit.com>
References: <>
 <1249702711-32737-1-git-send-email-javier@cozybit.com>
 <1249702711-32737-2-git-send-email-javier@cozybit.com>
 <1249702711-32737-3-git-send-email-javier@cozybit.com>
 <1249702711-32737-4-git-send-email-javier@cozybit.com>
 <1249702711-32737-5-git-send-email-javier@cozybit.com>
 <1249702711-32737-6-git-send-email-javier@cozybit.com>
 <1249702711-32737-7-git-send-email-javier@cozybit.com>
 <1249702711-32737-8-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents calling rcu_synchronize from within the tx path.
Also, re-enable mesh in Kconfig

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/Kconfig        |    1 -
 net/mac80211/ieee80211_i.h  |    2 +-
 net/mac80211/mesh.c         |   75 +++-------------------
 net/mac80211/mesh.h         |   20 ++++++-
 net/mac80211/mesh_pathtbl.c |  146 ++++++++++++++++++++++++++++++++-----------
 5 files changed, 139 insertions(+), 105 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 7dd77b6..9b4fcbc 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -66,7 +66,6 @@ endmenu
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
 	depends on MAC80211 && EXPERIMENTAL
-	depends on BROKEN
 	---help---
 	 This options enables support of Draft 802.11s mesh networking.
 	 The implementation is based on Draft 1.08 of the Mesh Networking
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d6bd7dd..a6abc7d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -355,7 +355,7 @@ struct ieee80211_if_mesh {
 
 	unsigned long timers_running;
 
-	bool housekeeping;
+	unsigned long wrkq_flags;
 
 	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
 	size_t mesh_id_len;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 3b49d39..619364c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -47,7 +47,7 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	ifmsh->housekeeping = true;
+	ifmsh->wrkq_flags |= MESH_WORK_HOUSEKEEPING;
 
 	if (local->quiescing) {
 		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
@@ -320,30 +320,6 @@ struct mesh_table *mesh_table_alloc(int size_order)
 	return newtbl;
 }
 
-static void __mesh_table_free(struct mesh_table *tbl)
-{
-	kfree(tbl->hash_buckets);
-	kfree(tbl->hashwlock);
-	kfree(tbl);
-}
-
-void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
-{
-	struct hlist_head *mesh_hash;
-	struct hlist_node *p, *q;
-	int i;
-
-	mesh_hash = tbl->hash_buckets;
-	for (i = 0; i <= tbl->hash_mask; i++) {
-		spin_lock(&tbl->hashwlock[i]);
-		hlist_for_each_safe(p, q, &mesh_hash[i]) {
-			tbl->free_node(p, free_leafs);
-			atomic_dec(&tbl->entries);
-		}
-		spin_unlock(&tbl->hashwlock[i]);
-	}
-	__mesh_table_free(tbl);
-}
 
 static void ieee80211_mesh_path_timer(unsigned long data)
 {
@@ -360,44 +336,6 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 	ieee80211_queue_work(&local->hw, &ifmsh->work);
 }
 
-struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
-{
-	struct mesh_table *newtbl;
-	struct hlist_head *oldhash;
-	struct hlist_node *p, *q;
-	int i;
-
-	if (atomic_read(&tbl->entries)
-			< tbl->mean_chain_len * (tbl->hash_mask + 1))
-		goto endgrow;
-
-	newtbl = mesh_table_alloc(tbl->size_order + 1);
-	if (!newtbl)
-		goto endgrow;
-
-	newtbl->free_node = tbl->free_node;
-	newtbl->mean_chain_len = tbl->mean_chain_len;
-	newtbl->copy_node = tbl->copy_node;
-	atomic_set(&newtbl->entries, atomic_read(&tbl->entries));
-
-	oldhash = tbl->hash_buckets;
-	for (i = 0; i <= tbl->hash_mask; i++)
-		hlist_for_each(p, &oldhash[i])
-			if (tbl->copy_node(p, newtbl) < 0)
-				goto errcopy;
-
-	return newtbl;
-
-errcopy:
-	for (i = 0; i <= newtbl->hash_mask; i++) {
-		hlist_for_each_safe(p, q, &newtbl->hash_buckets[i])
-			tbl->free_node(p, 0);
-	}
-	__mesh_table_free(newtbl);
-endgrow:
-	return NULL;
-}
-
 /**
  * ieee80211_fill_mesh_addresses - fill addresses of a locally originated mesh frame
  * @hdr:    	802.11 frame header
@@ -487,7 +425,6 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 	if (free_plinks != sdata->u.mesh.accepting_plinks)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 
-	ifmsh->housekeeping = false;
 	mod_timer(&ifmsh->housekeeping_timer,
 		  round_jiffies(jiffies + IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
 }
@@ -524,7 +461,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
 
-	ifmsh->housekeeping = true;
+	ifmsh->wrkq_flags |= MESH_WORK_HOUSEKEEPING;
 	queue_work(local->hw, &ifmsh->work);
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
@@ -664,7 +601,13 @@ static void ieee80211_mesh_work(struct work_struct *work)
 		       ifmsh->last_preq + msecs_to_jiffies(ifmsh->mshcfg.dot11MeshHWMPpreqMinInterval)))
 		mesh_path_start_discovery(sdata);
 
-	if (ifmsh->housekeeping)
+	if (test_and_clear_bit(MESH_WORK_GROW_MPATH_TABLE, &ifmsh->wrkq_flags))
+		mesh_mpath_table_grow();
+
+	if (test_and_clear_bit(MESH_WORK_GROW_MPATH_TABLE, &ifmsh->wrkq_flags))
+		mesh_mpp_table_grow();
+
+	if (test_and_clear_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags))
 		ieee80211_mesh_housekeeping(sdata, ifmsh);
 }
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index b6ea100..fd4031f 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -44,6 +44,23 @@ enum mesh_path_flags {
 };
 
 /**
+ * enum mesh_deferred_task_flags - mac80211 mesh deferred tasks
+ *
+ *
+ *
+ * @MESH_WORK_HOUSEKEEPING: run the periodic mesh housekeeping tasks
+ * @MESH_WORK_GROW_MPATH_TABLE: the mesh path table is full and needs
+ * to grow.
+ * @MESH_WORK_GROW_MPP_TABLE: the mesh portals table is full and needs to
+ * grow
+ */
+enum mesh_deferred_task_flags {
+	MESH_WORK_HOUSEKEEPING,
+	MESH_WORK_GROW_MPATH_TABLE,
+	MESH_WORK_GROW_MPP_TABLE,
+};
+
+/**
  * struct mesh_path - mac80211 mesh path structure
  *
  * @dst: mesh path destination mac address
@@ -251,7 +268,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 /* Mesh tables */
 struct mesh_table *mesh_table_alloc(int size_order);
 void mesh_table_free(struct mesh_table *tbl, bool free_leafs);
-struct mesh_table *mesh_table_grow(struct mesh_table *tbl);
+void mesh_mpath_table_grow(void);
+void mesh_mpp_table_grow(void);
 u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata,
 		struct mesh_table *tbl);
 /* Mesh paths */
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 431865a..97e14bc 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -39,6 +39,69 @@ static struct mesh_table *mesh_paths;
 static struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
 
 int mesh_paths_generation;
+static void __mesh_table_free(struct mesh_table *tbl)
+{
+	kfree(tbl->hash_buckets);
+	kfree(tbl->hashwlock);
+	kfree(tbl);
+}
+
+void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
+{
+	struct hlist_head *mesh_hash;
+	struct hlist_node *p, *q;
+	int i;
+
+	mesh_hash = tbl->hash_buckets;
+	for (i = 0; i <= tbl->hash_mask; i++) {
+		spin_lock(&tbl->hashwlock[i]);
+		hlist_for_each_safe(p, q, &mesh_hash[i]) {
+			tbl->free_node(p, free_leafs);
+			atomic_dec(&tbl->entries);
+		}
+		spin_unlock(&tbl->hashwlock[i]);
+	}
+	__mesh_table_free(tbl);
+}
+
+static struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
+{
+	struct mesh_table *newtbl;
+	struct hlist_head *oldhash;
+	struct hlist_node *p, *q;
+	int i;
+
+	if (atomic_read(&tbl->entries)
+			< tbl->mean_chain_len * (tbl->hash_mask + 1))
+		goto endgrow;
+
+	newtbl = mesh_table_alloc(tbl->size_order + 1);
+	if (!newtbl)
+		goto endgrow;
+
+	newtbl->free_node = tbl->free_node;
+	newtbl->mean_chain_len = tbl->mean_chain_len;
+	newtbl->copy_node = tbl->copy_node;
+	atomic_set(&newtbl->entries, atomic_read(&tbl->entries));
+
+	oldhash = tbl->hash_buckets;
+	for (i = 0; i <= tbl->hash_mask; i++)
+		hlist_for_each(p, &oldhash[i])
+			if (tbl->copy_node(p, newtbl) < 0)
+				goto errcopy;
+
+	return newtbl;
+
+errcopy:
+	for (i = 0; i <= newtbl->hash_mask; i++) {
+		hlist_for_each_safe(p, q, &newtbl->hash_buckets[i])
+			tbl->free_node(p, 0);
+	}
+	__mesh_table_free(newtbl);
+endgrow:
+	return NULL;
+}
+
 
 /* This lock will have the grow table function as writer and add / delete nodes
  * as readers. When reading the table (i.e. doing lookups) we are well protected
@@ -187,6 +250,8 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
  */
 int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
 	struct hlist_head *bucket;
@@ -195,8 +260,6 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	int err = 0;
 	u32 hash_idx;
 
-	might_sleep();
-
 	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
 		/* never add ourselves as neighbours */
 		return -ENOTSUPP;
@@ -208,11 +271,11 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 		return -ENOSPC;
 
 	err = -ENOMEM;
-	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_KERNEL);
+	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_ATOMIC);
 	if (!new_mpath)
 		goto err_path_alloc;
 
-	new_node = kmalloc(sizeof(struct mpath_node), GFP_KERNEL);
+	new_node = kmalloc(sizeof(struct mpath_node), GFP_ATOMIC);
 	if (!new_node)
 		goto err_node_alloc;
 
@@ -250,20 +313,8 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	spin_unlock(&mesh_paths->hashwlock[hash_idx]);
 	read_unlock(&pathtbl_resize_lock);
 	if (grow) {
-		struct mesh_table *oldtbl, *newtbl;
-
-		write_lock(&pathtbl_resize_lock);
-		oldtbl = mesh_paths;
-		newtbl = mesh_table_grow(mesh_paths);
-		if (!newtbl) {
-			write_unlock(&pathtbl_resize_lock);
-			return 0;
-		}
-		rcu_assign_pointer(mesh_paths, newtbl);
-		write_unlock(&pathtbl_resize_lock);
-
-		synchronize_rcu();
-		mesh_table_free(oldtbl, false);
+		set_bit(MESH_WORK_GROW_MPATH_TABLE,  &ifmsh->wrkq_flags);
+		queue_work(local->hw.workqueue, &ifmsh->work);
 	}
 	return 0;
 
@@ -278,9 +329,46 @@ err_path_alloc:
 	return err;
 }
 
+void mesh_mpath_table_grow(void)
+{
+	struct mesh_table *oldtbl, *newtbl;
+
+	write_lock(&pathtbl_resize_lock);
+	oldtbl = mesh_paths;
+	newtbl = mesh_table_grow(mesh_paths);
+	if (!newtbl) {
+		write_unlock(&pathtbl_resize_lock);
+		return;
+	}
+	rcu_assign_pointer(mesh_paths, newtbl);
+	write_unlock(&pathtbl_resize_lock);
+
+	synchronize_rcu();
+	mesh_table_free(oldtbl, false);
+}
+
+void mesh_mpp_table_grow(void)
+{
+	struct mesh_table *oldtbl, *newtbl;
+
+	write_lock(&pathtbl_resize_lock);
+	oldtbl = mpp_paths;
+	newtbl = mesh_table_grow(mpp_paths);
+	if (!newtbl) {
+		write_unlock(&pathtbl_resize_lock);
+		return;
+	}
+	rcu_assign_pointer(mpp_paths, newtbl);
+	write_unlock(&pathtbl_resize_lock);
+
+	synchronize_rcu();
+	mesh_table_free(oldtbl, false);
+}
 
 int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
 	struct hlist_head *bucket;
@@ -289,8 +377,6 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	int err = 0;
 	u32 hash_idx;
 
-	might_sleep();
-
 	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
 		/* never add ourselves as neighbours */
 		return -ENOTSUPP;
@@ -299,11 +385,11 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 		return -ENOTSUPP;
 
 	err = -ENOMEM;
-	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_KERNEL);
+	new_mpath = kzalloc(sizeof(struct mesh_path), GFP_ATOMIC);
 	if (!new_mpath)
 		goto err_path_alloc;
 
-	new_node = kmalloc(sizeof(struct mpath_node), GFP_KERNEL);
+	new_node = kmalloc(sizeof(struct mpath_node), GFP_ATOMIC);
 	if (!new_node)
 		goto err_node_alloc;
 
@@ -337,20 +423,8 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	spin_unlock(&mpp_paths->hashwlock[hash_idx]);
 	read_unlock(&pathtbl_resize_lock);
 	if (grow) {
-		struct mesh_table *oldtbl, *newtbl;
-
-		write_lock(&pathtbl_resize_lock);
-		oldtbl = mpp_paths;
-		newtbl = mesh_table_grow(mpp_paths);
-		if (!newtbl) {
-			write_unlock(&pathtbl_resize_lock);
-			return 0;
-		}
-		rcu_assign_pointer(mpp_paths, newtbl);
-		write_unlock(&pathtbl_resize_lock);
-
-		synchronize_rcu();
-		mesh_table_free(oldtbl, false);
+		set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
+		queue_work(local->hw.workqueue, &ifmsh->work);
 	}
 	return 0;
 
-- 
1.5.4.3

