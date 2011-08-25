Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39293 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1HYBli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:41:38 -0400
Received: by yxj19 with SMTP id 19so1335823yxj.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:41:37 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 9/9] mac80211: Consolidate mesh path duplicated functions
Date: Wed, 24 Aug 2011 18:40:52 -0700
Message-Id: <1314236452-7226-10-git-send-email-thomas@cozybit.com> (sfid-20110825_034140_279040_3E7E69D2)
In-Reply-To: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |   52 ++++++++++++++-----------------------------
 1 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 4bfbe31..4891cf1 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
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
 
 
-- 
1.7.4.1

