Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54157 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab1H2UX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 16:23:26 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so9020873pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 13:23:26 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v3 7/7] mac80211: Consolidate mesh path duplicated functions
Date: Mon, 29 Aug 2011 13:23:09 -0700
Message-Id: <1314649389-7115-8-git-send-email-javier@cozybit.com> (sfid-20110829_222333_396540_C93A9345)
In-Reply-To: <1314649389-7115-1-git-send-email-javier@cozybit.com>
References: <1314649389-7115-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
v3: - Do take the path resize read lock to prevent clash with table
      growth (Johannes)

 net/mac80211/mesh_pathtbl.c |   70 +++++++++++++++++-------------------------
 1 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3c03be9..9b81bb5 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -48,10 +48,10 @@ static struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */
 int mesh_paths_generation;
 
 /* This lock will have the grow table function as writer and add / delete nodes
- * as readers. When reading the table (i.e. doing lookups) we are well protected
- * by RCU.  We need to take this lock when modying the number of buckets
- * on one of the path tables but we don't need to if adding or removing mpaths
- * from hash buckets.
+ * as readers. RCU provides sufficient protection only when reading the table
+ * (i.e. doing lookups).  Adding or adding or removing nodes requires we take
+ * the read lock or we risk operating on an old table.  The write lock is only
+ * needed when modifying the number of buckets a table.
  */
 static DEFINE_RWLOCK(pathtbl_resize_lock);
 
@@ -335,25 +335,14 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 }
 
 
-/**
- * mesh_path_lookup - look up a path in the mesh path table
- * @dst: hardware address (ETH_ALEN length) of destination
- * @sdata: local subif
- *
- * Returns: pointer to the mesh path structure, or NULL if not found
- *
- * Locking: must be called within a read rcu section.
- */
-struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
+static struct mesh_path *path_lookup(struct mesh_table *tbl, u8 *dst,
+					  struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
 	struct hlist_node *n;
 	struct hlist_head *bucket;
-	struct mesh_table *tbl;
 	struct mpath_node *node;
 
-	tbl = rcu_dereference(mesh_paths);
-
 	bucket = &tbl->hash_buckets[mesh_table_hash(dst, sdata, tbl)];
 	hlist_for_each_entry_rcu(node, n, bucket, list) {
 		mpath = node->mpath;
@@ -370,30 +359,23 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	return NULL;
 }
 
-struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
+/**
+ * mesh_path_lookup - look up a path in the mesh path table
+ * @dst: hardware address (ETH_ALEN length) of destination
+ * @sdata: local subif
+ *
+ * Returns: pointer to the mesh path structure, or NULL if not found
+ *
+ * Locking: must be called within a read rcu section.
+ */
+struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
-	struct mesh_path *mpath;
-	struct hlist_node *n;
-	struct hlist_head *bucket;
-	struct mesh_table *tbl;
-	struct mpath_node *node;
-
-	tbl = rcu_dereference(mpp_paths);
+	return path_lookup(rcu_dereference(mesh_paths), dst, sdata);
+}
 
-	bucket = &tbl->hash_buckets[mesh_table_hash(dst, sdata, tbl)];
-	hlist_for_each_entry_rcu(node, n, bucket, list) {
-		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    memcmp(dst, mpath->dst, ETH_ALEN) == 0) {
-			if (MPATH_EXPIRED(mpath)) {
-				spin_lock_bh(&mpath->state_lock);
-				mpath->flags &= ~MESH_PATH_ACTIVE;
-				spin_unlock_bh(&mpath->state_lock);
-			}
-			return mpath;
-		}
-	}
-	return NULL;
+struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
+{
+	return path_lookup(rcu_dereference(mpp_paths), dst, sdata);
 }
 
 
@@ -836,7 +818,8 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	int i;
 
 	rcu_read_lock();
-	tbl = rcu_dereference(mesh_paths);
+	read_lock_bh(&pathtbl_resize_lock);
+	tbl = resize_dereference_mesh_paths();
 	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
 		if (rcu_dereference(mpath->next_hop) == sta) {
@@ -845,6 +828,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 			spin_unlock_bh(&tbl->hashwlock[i]);
 		}
 	}
+	read_unlock_bh(&pathtbl_resize_lock);
 	rcu_read_unlock();
 }
 
@@ -880,10 +864,12 @@ void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 	struct mesh_table *tbl;
 
 	rcu_read_lock();
+	read_lock_bh(&pathtbl_resize_lock);
-	tbl = rcu_dereference(mesh_paths);
+	tbl = resize_dereference_mesh_paths();
 	table_flush_by_iface(tbl, sdata);
-	tbl = rcu_dereference(mpp_paths);
+	tbl = resize_dereference_mpp_paths();
 	table_flush_by_iface(tbl, sdata);
+	read_unlock_bh(&pathtbl_resize_lock);
 	rcu_read_unlock();
 }
 
-- 
1.7.6

