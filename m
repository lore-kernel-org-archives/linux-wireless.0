Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41919 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1ECX5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:45 -0400
Received: by mail-pz0-f46.google.com with SMTP id 9so260225pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:44 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 10/13] mac80211: Fix locking bug on mesh path table access
Date: Tue,  3 May 2011 16:57:16 -0700
Message-Id: <1304467039-7730-11-git-send-email-javier@cozybit.com> (sfid-20110504_015751_582608_4D5B5210)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh and mpp path tables are accessed from softirq and workqueue
context so non-irq locking cannot be used.  Or at least that's what
PROVE_RCU seems to tell us here:

[  431.240946] =================================
[  431.241061] [ INFO: inconsistent lock state ]
[  431.241061] 2.6.39-rc3-wl+ #354
[  431.241061] ---------------------------------
[  431.241061] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[  431.241061] kworker/u:1/1423 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  431.241061]  (&(&newtbl->hashwlock[i])->rlock){+.?...}, at:
[<c14671bf>] mesh_path_add+0x167/0x257

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |   54 ++++++++++++++++++++++--------------------
 1 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index d4e86fd..a1d59bd 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -55,12 +55,12 @@ void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
 
 	mesh_hash = tbl->hash_buckets;
 	for (i = 0; i <= tbl->hash_mask; i++) {
-		spin_lock(&tbl->hashwlock[i]);
+		spin_lock_bh(&tbl->hashwlock[i]);
 		hlist_for_each_safe(p, q, &mesh_hash[i]) {
 			tbl->free_node(p, free_leafs);
 			atomic_dec(&tbl->entries);
 		}
-		spin_unlock(&tbl->hashwlock[i]);
+		spin_unlock_bh(&tbl->hashwlock[i]);
 	}
 	__mesh_table_free(tbl);
 }
@@ -274,7 +274,7 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	if (!new_node)
 		goto err_node_alloc;
 
-	read_lock(&pathtbl_resize_lock);
+	read_lock_bh(&pathtbl_resize_lock);
 	memcpy(new_mpath->dst, dst, ETH_ALEN);
 	new_mpath->sdata = sdata;
 	new_mpath->flags = 0;
@@ -289,7 +289,7 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	hash_idx = mesh_table_hash(dst, sdata, mesh_paths);
 	bucket = &mesh_paths->hash_buckets[hash_idx];
 
-	spin_lock(&mesh_paths->hashwlock[hash_idx]);
+	spin_lock_bh(&mesh_paths->hashwlock[hash_idx]);
 
 	err = -EEXIST;
 	hlist_for_each_entry(node, n, bucket, list) {
@@ -305,8 +305,8 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 
 	mesh_paths_generation++;
 
-	spin_unlock(&mesh_paths->hashwlock[hash_idx]);
-	read_unlock(&pathtbl_resize_lock);
+	spin_unlock_bh(&mesh_paths->hashwlock[hash_idx]);
+	read_unlock_bh(&pathtbl_resize_lock);
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPATH_TABLE,  &ifmsh->wrkq_flags);
 		ieee80211_queue_work(&local->hw, &sdata->work);
@@ -314,8 +314,8 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	return 0;
 
 err_exists:
-	spin_unlock(&mesh_paths->hashwlock[hash_idx]);
-	read_unlock(&pathtbl_resize_lock);
+	spin_unlock_bh(&mesh_paths->hashwlock[hash_idx]);
+	read_unlock_bh(&pathtbl_resize_lock);
 	kfree(new_node);
 err_node_alloc:
 	kfree(new_mpath);
@@ -332,16 +332,17 @@ void mesh_mpath_table_grow(void)
 	newtbl = mesh_table_alloc(rcu_dereference(mesh_paths)->size_order + 1);
 	if (!newtbl)
 		return;
-	write_lock(&pathtbl_resize_lock);
+	write_lock_bh(&pathtbl_resize_lock);
 	oldtbl = mesh_paths;
 	if (mesh_table_grow(mesh_paths, newtbl) < 0) {
+		rcu_read_unlock();
 		__mesh_table_free(newtbl);
-		write_unlock(&pathtbl_resize_lock);
+		write_unlock_bh(&pathtbl_resize_lock);
 		return;
 	}
 	rcu_read_unlock();
 	rcu_assign_pointer(mesh_paths, newtbl);
-	write_unlock(&pathtbl_resize_lock);
+	write_unlock_bh(&pathtbl_resize_lock);
 
 	synchronize_rcu();
 	mesh_table_free(oldtbl, false);
@@ -355,16 +356,17 @@ void mesh_mpp_table_grow(void)
 	newtbl = mesh_table_alloc(rcu_dereference(mpp_paths)->size_order + 1);
 	if (!newtbl)
 		return;
-	write_lock(&pathtbl_resize_lock);
+	write_lock_bh(&pathtbl_resize_lock);
 	oldtbl = mpp_paths;
 	if (mesh_table_grow(mpp_paths, newtbl) < 0) {
+		rcu_read_unlock();
 		__mesh_table_free(newtbl);
-		write_unlock(&pathtbl_resize_lock);
+		write_unlock_bh(&pathtbl_resize_lock);
 		return;
 	}
 	rcu_read_unlock();
 	rcu_assign_pointer(mpp_paths, newtbl);
-	write_unlock(&pathtbl_resize_lock);
+	write_unlock_bh(&pathtbl_resize_lock);
 
 	synchronize_rcu();
 	mesh_table_free(oldtbl, false);
@@ -398,7 +400,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	if (!new_node)
 		goto err_node_alloc;
 
-	read_lock(&pathtbl_resize_lock);
+	read_lock_bh(&pathtbl_resize_lock);
 	memcpy(new_mpath->dst, dst, ETH_ALEN);
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
 	new_mpath->sdata = sdata;
@@ -411,7 +413,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	hash_idx = mesh_table_hash(dst, sdata, mpp_paths);
 	bucket = &mpp_paths->hash_buckets[hash_idx];
 
-	spin_lock(&mpp_paths->hashwlock[hash_idx]);
+	spin_lock_bh(&mpp_paths->hashwlock[hash_idx]);
 
 	err = -EEXIST;
 	hlist_for_each_entry(node, n, bucket, list) {
@@ -425,8 +427,8 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 		mpp_paths->mean_chain_len * (mpp_paths->hash_mask + 1))
 		grow = 1;
 
-	spin_unlock(&mpp_paths->hashwlock[hash_idx]);
-	read_unlock(&pathtbl_resize_lock);
+	spin_unlock_bh(&mpp_paths->hashwlock[hash_idx]);
+	read_unlock_bh(&pathtbl_resize_lock);
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
 		ieee80211_queue_work(&local->hw, &sdata->work);
@@ -434,8 +436,8 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	return 0;
 
 err_exists:
-	spin_unlock(&mpp_paths->hashwlock[hash_idx]);
-	read_unlock(&pathtbl_resize_lock);
+	spin_unlock_bh(&mpp_paths->hashwlock[hash_idx]);
+	read_unlock_bh(&pathtbl_resize_lock);
 	kfree(new_node);
 err_node_alloc:
 	kfree(new_mpath);
@@ -548,11 +550,11 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 	int hash_idx;
 	int err = 0;
 
-	read_lock(&pathtbl_resize_lock);
+	read_lock_bh(&pathtbl_resize_lock);
 	hash_idx = mesh_table_hash(addr, sdata, mesh_paths);
 	bucket = &mesh_paths->hash_buckets[hash_idx];
 
-	spin_lock(&mesh_paths->hashwlock[hash_idx]);
+	spin_lock_bh(&mesh_paths->hashwlock[hash_idx]);
 	hlist_for_each_entry(node, n, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
@@ -570,8 +572,8 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 	err = -ENXIO;
 enddel:
 	mesh_paths_generation++;
-	spin_unlock(&mesh_paths->hashwlock[hash_idx]);
-	read_unlock(&pathtbl_resize_lock);
+	spin_unlock_bh(&mesh_paths->hashwlock[hash_idx]);
+	read_unlock_bh(&pathtbl_resize_lock);
 	return err;
 }
 
@@ -723,7 +725,7 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 	struct hlist_node *p;
 	int i;
 
-	read_lock(&pathtbl_resize_lock);
+	read_lock_bh(&pathtbl_resize_lock);
 	for_each_mesh_entry(mesh_paths, p, node, i) {
 		if (node->mpath->sdata != sdata)
 			continue;
@@ -738,7 +740,7 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
-	read_unlock(&pathtbl_resize_lock);
+	read_unlock_bh(&pathtbl_resize_lock);
 }
 
 void mesh_pathtbl_unregister(void)
-- 
1.7.1

