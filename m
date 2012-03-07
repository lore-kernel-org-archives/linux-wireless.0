Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56871 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609Ab2CGAmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 19:42:23 -0500
Received: by obbuo6 with SMTP id uo6so6132631obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 16:42:22 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix smatch lock errors in mesh
Date: Tue,  6 Mar 2012 16:42:09 -0800
Message-Id: <1331080929-8852-1-git-send-email-thomas@cozybit.com> (sfid-20120307_014226_620759_FAB594EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

smatch was complaining:

CHECK   net/mac80211/mesh_pathtbl.c
net/mac80211/mesh_pathtbl.c:562 mesh_path_add() error: double lock
'bottom_half:'
net/mac80211/mesh_pathtbl.c:580 mesh_path_add() error: double unlock
'bottom_half:'
net/mac80211/mesh_pathtbl.c:589 mesh_path_add() error: double unlock
'bottom_half:'
net/mac80211/mesh_pathtbl.c:691 mpp_path_add() error: double lock
'bottom_half:'
net/mac80211/mesh_pathtbl.c:707 mpp_path_add() error: double unlock
'bottom_half:'
net/mac80211/mesh_pathtbl.c:716 mpp_path_add() error: double unlock
'bottom_half:'
net/mac80211/mesh_pathtbl.c:814 mesh_path_flush_by_nexthop() error:
double lock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:819 mesh_path_flush_by_nexthop() error:
double unlock 'bottom_half:'
net/mac80211/mesh_pathtbl.c:887 mesh_path_del() error: double lock
'bottom_half:'
net/mac80211/mesh_pathtbl.c:901 mesh_path_del() error: double unlock
'bottom_half:'

So don't lock / unlock with _bh() while bottom halves are already
disabled.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 157642f..be1361b 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -559,7 +559,7 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	hash_idx = mesh_table_hash(dst, sdata, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
-	spin_lock_bh(&tbl->hashwlock[hash_idx]);
+	spin_lock(&tbl->hashwlock[hash_idx]);
 
 	err = -EEXIST;
 	hlist_for_each_entry(node, n, bucket, list) {
@@ -576,7 +576,7 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 
 	mesh_paths_generation++;
 
-	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
+	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPATH_TABLE,  &ifmsh->wrkq_flags);
@@ -585,7 +585,7 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	return 0;
 
 err_exists:
-	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
+	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	kfree(new_node);
 err_node_alloc:
@@ -688,7 +688,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	hash_idx = mesh_table_hash(dst, sdata, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
-	spin_lock_bh(&tbl->hashwlock[hash_idx]);
+	spin_lock(&tbl->hashwlock[hash_idx]);
 
 	err = -EEXIST;
 	hlist_for_each_entry(node, n, bucket, list) {
@@ -703,7 +703,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	    tbl->mean_chain_len * (tbl->hash_mask + 1))
 		grow = 1;
 
-	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
+	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
@@ -712,7 +712,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	return 0;
 
 err_exists:
-	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
+	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	kfree(new_node);
 err_node_alloc:
@@ -811,9 +811,9 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
 		if (rcu_dereference(mpath->next_hop) == sta) {
-			spin_lock_bh(&tbl->hashwlock[i]);
+			spin_lock(&tbl->hashwlock[i]);
 			__mesh_path_del(tbl, node);
-			spin_unlock_bh(&tbl->hashwlock[i]);
+			spin_unlock(&tbl->hashwlock[i]);
 		}
 	}
 	read_unlock_bh(&pathtbl_resize_lock);
@@ -884,7 +884,7 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 	hash_idx = mesh_table_hash(addr, sdata, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
-	spin_lock_bh(&tbl->hashwlock[hash_idx]);
+	spin_lock(&tbl->hashwlock[hash_idx]);
 	hlist_for_each_entry(node, n, bucket, list) {
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
@@ -897,7 +897,7 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 	err = -ENXIO;
 enddel:
 	mesh_paths_generation++;
-	spin_unlock_bh(&tbl->hashwlock[hash_idx]);
+	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
 	return err;
 }
-- 
1.7.5.4

