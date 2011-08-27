Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39904 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab1H0ASp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 20:18:45 -0400
Received: by mail-gx0-f174.google.com with SMTP id 21so3308768gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 17:18:45 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 8/8] mac80211: Consolidate mesh path duplicated functions
Date: Fri, 26 Aug 2011 17:18:14 -0700
Message-Id: <1314404294-4233-9-git-send-email-javier@cozybit.com> (sfid-20110827_021848_367542_71417CB4)
In-Reply-To: <1314404294-4233-1-git-send-email-javier@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314404294-4233-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |   52 ++++++++++++++-----------------------------
 1 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 216bd2f..9482e87 100644
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
1.7.6

