Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34733 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbcBCM6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 07:58:50 -0500
Received: by mail-wm0-f43.google.com with SMTP id 128so164162797wmz.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Feb 2016 04:58:49 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <hrogge@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH v3 3/3] mac80211: Unify mesh and mpp path removal function
Date: Wed,  3 Feb 2016 13:58:38 +0100
Message-Id: <1454504318-24988-4-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160203_135855_009976_1F1834FA)
In-Reply-To: <1454504318-24988-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
References: <1454504318-24988-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mpp_path_del() and mesh_path_del() are mostly the same function.
Move common code into a new static function.

Signed-off-by: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
---
 net/mac80211/mesh_pathtbl.c | 77 ++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 0ab862a..f85262d 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -55,16 +55,21 @@ int mpp_paths_generation;
 static DEFINE_RWLOCK(pathtbl_resize_lock);
 
 
+static inline struct mesh_table *resize_dereference_paths(
+	struct mesh_table __rcu *table)
+{
+	return rcu_dereference_protected(table,
+					lockdep_is_held(&pathtbl_resize_lock));
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
+	return resize_dereference_paths(mpp_paths);
 }
 
 /*
@@ -899,14 +904,17 @@ void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 }
 
 /**
- * mesh_path_del - delete a mesh path from the table
+ * table_path_del - delete a path from the mesh or mpp table
  *
- * @addr: dst address (ETH_ALEN length)
+ * @tbl: mesh or mpp path table
  * @sdata: local subif
+ * @addr: dst address (ETH_ALEN length)
  *
  * Returns: 0 if successful
  */
-int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
+static int table_path_del(struct mesh_table __rcu *rcu_tbl,
+			  struct ieee80211_sub_if_data *sdata,
+			  const u8 *addr)
 {
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
@@ -915,11 +923,7 @@ int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	int hash_idx;
 	int err = 0;
 
-	/* flush relevant mpp entries first */
-	mpp_flush_by_proxy(sdata, addr);
-
-	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mesh_paths();
+	tbl = resize_dereference_paths(rcu_tbl);
 	hash_idx = mesh_table_hash(addr, sdata, tbl);
 	bucket = &tbl->hash_buckets[hash_idx];
 
@@ -935,9 +939,30 @@ int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 
 	err = -ENXIO;
 enddel:
-	mesh_paths_generation++;
 	spin_unlock(&tbl->hashwlock[hash_idx]);
+	return err;
+}
+
+/**
+ * mesh_path_del - delete a mesh path from the table
+ *
+ * @addr: dst address (ETH_ALEN length)
+ * @sdata: local subif
+ *
+ * Returns: 0 if successful
+ */
+int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
+{
+	int err = 0;
+
+	/* flush relevant mpp entries first */
+	mpp_flush_by_proxy(sdata, addr);
+
+	read_lock_bh(&pathtbl_resize_lock);
+	err = table_path_del(mesh_paths, sdata, addr);
+	mesh_paths_generation++;
 	read_unlock_bh(&pathtbl_resize_lock);
+
 	return err;
 }
 
@@ -951,33 +976,13 @@ enddel:
  */
 static int mpp_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 {
-	struct mesh_table *tbl;
-	struct mesh_path *mpath;
-	struct mpath_node *node;
-	struct hlist_head *bucket;
-	int hash_idx;
 	int err = 0;
 
 	read_lock_bh(&pathtbl_resize_lock);
-	tbl = resize_dereference_mpp_paths();
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
-	mesh_paths_generation++;
-	spin_unlock(&tbl->hashwlock[hash_idx]);
+	err = table_path_del(mpp_paths, sdata, addr);
+	mpp_paths_generation++;
 	read_unlock_bh(&pathtbl_resize_lock);
+
 	return err;
 }
 
-- 
2.5.0

