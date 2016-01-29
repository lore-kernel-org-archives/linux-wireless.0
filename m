Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34940 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbcA2KJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 05:09:08 -0500
Received: by mail-wm0-f66.google.com with SMTP id l66so8873973wml.2
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2016 02:09:08 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <hrogge@gmail.com>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH v2 3/3] mac80211: Unify mesh and mpp path removal function
Date: Fri, 29 Jan 2016 11:08:58 +0100
Message-Id: <1454062138-18012-4-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160129_110917_854669_4D7DB3A1)
In-Reply-To: <1454062138-18012-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
References: <1454062138-18012-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mpp_path_del() and mesh_path_del() are mostly the same function.
Move common code into a new static function.

Signed-off-by: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
---
 net/mac80211/mesh_pathtbl.c | 110 ++++++++++++++++++++++----------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 33bb1f25..86316ee 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -55,16 +55,20 @@ int mpp_paths_generation;
 static DEFINE_RWLOCK(pathtbl_resize_lock);
 
 
+static inline struct mesh_table *resize_dereference_paths(struct mesh_table *table)
+{
+  return rcu_dereference_protected(table,
+    lockdep_is_held(&pathtbl_resize_lock));
+}
+
 static inline struct mesh_table *resize_dereference_mesh_paths(void)
 {
-	return rcu_dereference_protected(mesh_paths,
-		lockdep_is_held(&pathtbl_resize_lock));
+	return resize_dereference_paths(mesh_paths);
 }
 
 static inline struct mesh_table *resize_dereference_mpp_paths(void)
 {
-	return rcu_dereference_protected(mpp_paths,
-		lockdep_is_held(&pathtbl_resize_lock));
+    return resize_dereference_paths(mpp_paths);
 }
 
 /*
@@ -899,6 +903,45 @@ void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 }
 
 /**
+ * table_path_del - delete a path from the mesh or mpp table
+ *
+ * @tbl: mesh or mpp path table
+ * @sdata: local subif
+ * @addr: dst address (ETH_ALEN length)
+ *
+ * Returns: 0 if successful
+ */
+static int table_path_del(struct mesh_table *rcu_tbl,
+    struct ieee80211_sub_if_data *sdata, const u8 *addr)
+{
+  struct mesh_table *tbl;
+  struct mesh_path *mpath;
+  struct mpath_node *node;
+  struct hlist_head *bucket;
+  int hash_idx;
+  int err = 0;
+
+  tbl = resize_dereference_paths(rcu_tbl);
+  hash_idx = mesh_table_hash(addr, sdata, tbl);
+  bucket = &tbl->hash_buckets[hash_idx];
+
+  spin_lock(&tbl->hashwlock[hash_idx]);
+  hlist_for_each_entry(node, bucket, list) {
+    mpath = node->mpath;
+    if (mpath->sdata == sdata &&
+        ether_addr_equal(addr, mpath->dst)) {
+      __mesh_path_del(tbl, node);
+      goto enddel;
+    }
+  }
+
+  err = -ENXIO;
+enddel:
+  spin_unlock(&tbl->hashwlock[hash_idx]);
+  return err;
+}
+
+/**
  * mesh_path_del - delete a mesh path from the table
  *
  * @addr: dst address (ETH_ALEN length)
@@ -908,36 +951,16 @@ void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
  */
 int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 {
-	struct mesh_table *tbl;
-	struct mesh_path *mpath;
-	struct mpath_node *node;
-	struct hlist_head *bucket;
-	int hash_idx;
 	int err = 0;
 
 	/* flush relevant mpp entries first */
 	mpp_flush_by_proxy(sdata, addr);
 
 	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mesh_paths();
-	hash_idx = mesh_table_hash(addr, sdata, tbl);
-	bucket = &tbl->hash_buckets[hash_idx];
-
-	spin_lock(&tbl->hashwlock[hash_idx]);
-	hlist_for_each_entry(node, bucket, list) {
-		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    ether_addr_equal(addr, mpath->dst)) {
-			__mesh_path_del(tbl, node);
-			goto enddel;
-		}
-	}
-
-	err = -ENXIO;
-enddel:
+	err = table_path_del(mesh_paths, sdata, addr);
 	mesh_paths_generation++;
-	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
+
 	return err;
 }
 
@@ -951,37 +974,14 @@ enddel:
  */
 static int mpp_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 {
-	struct mesh_table *tbl;
-	struct mesh_path *mpath;
-	struct mpath_node *node;
-	struct hlist_head *bucket;
-	int hash_idx;
-	int err = 0;
-
-	/* flush relevant mpp entries first */
-	mpp_flush_by_proxy(sdata, addr);
-
-	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mpp_paths();
-	hash_idx = mesh_table_hash(addr, sdata, tbl);
-	bucket = &tbl->hash_buckets[hash_idx];
+  int err = 0;
 
-	spin_lock(&tbl->hashwlock[hash_idx]);
-	hlist_for_each_entry(node, bucket, list) {
-		mpath = node->mpath;
-		if (mpath->sdata == sdata &&
-		    ether_addr_equal(addr, mpath->dst)) {
-			__mesh_path_del(tbl, node);
-			goto enddel;
-		}
-	}
+  read_lock_bh(&pathtbl_resize_lock);
+  err = table_path_del(mpp_paths, sdata, addr);
+  mpp_paths_generation++;
+  read_unlock_bh(&pathtbl_resize_lock);
 
-	err = -ENXIO;
-enddel:
-	mesh_paths_generation++;
-	spin_unlock(&tbl->hashwlock[hash_idx]);
-	read_unlock_bh(&pathtbl_resize_lock);
-	return err;
+  return err;
 }
 
 /**
-- 
2.5.0

