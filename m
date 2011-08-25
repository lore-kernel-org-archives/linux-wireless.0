Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34619 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1HYBlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:41:24 -0400
Received: by mail-gy0-f174.google.com with SMTP id 6so1340575gya.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:41:23 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 6/9] mac80211: Don't iterate twice over all mpaths when once in sufficient
Date: Wed, 24 Aug 2011 18:40:49 -0700
Message-Id: <1314236452-7226-7-git-send-email-thomas@cozybit.com> (sfid-20110825_034126_128844_B3324887)
In-Reply-To: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |   64 +++++++++++++++++++++++++------------------
 1 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 562b150..e941de2 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -49,7 +49,9 @@ int mesh_paths_generation;
 
 /* This lock will have the grow table function as writer and add / delete nodes
  * as readers. When reading the table (i.e. doing lookups) we are well protected
- * by RCU
+ * by RCU.  We need to take this lock when modying the number of buckets
+ * on one of the path tables but we don't need to if adding or removing mpaths
+ * from hash buckets.
  */
 static DEFINE_RWLOCK(pathtbl_resize_lock);
 
@@ -817,6 +819,32 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	rcu_read_unlock();
 }
 
+static void mesh_path_node_reclaim(struct rcu_head *rp)
+{
+	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
+	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
+
+	del_timer_sync(&node->mpath->timer);
+	atomic_dec(&sdata->u.mesh.mpaths);
+	kfree(node->mpath);
+	kfree(node);
+}
+
+/* needs to be called with the corresponding hashwlock taken */
+static void __mesh_path_del(struct mesh_table *tbl, struct mpath_node *node)
+{
+	struct mesh_path *mpath;
+	mpath = node->mpath;
+	spin_lock(&mpath->state_lock);
+	mpath->flags |= MESH_PATH_RESOLVING;
+	if (mpath->is_gate)
+		mesh_gate_del(tbl, mpath);
+	hlist_del_rcu(&node->list);
+	call_rcu(&node->rcu, mesh_path_node_reclaim);
+	spin_unlock(&mpath->state_lock);
+	atomic_dec(&tbl->entries);
+}
+
 static void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_table *tbl;
@@ -829,23 +857,15 @@ static void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
 	tbl = rcu_dereference(mesh_paths);
 	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
-		if (mpath->sdata == sdata)
-			mesh_path_del(mpath->dst, mpath->sdata);
+		if (mpath->sdata == sdata) {
+			spin_lock_bh(&tbl->hashwlock[i]);
+			__mesh_path_del(tbl, node);
+			spin_unlock_bh(&tbl->hashwlock[i]);
+		}
 	}
 	rcu_read_unlock();
 }
 
-static void mesh_path_node_reclaim(struct rcu_head *rp)
-{
-	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
-	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
-
-	del_timer_sync(&node->mpath->timer);
-	atomic_dec(&sdata->u.mesh.mpaths);
-	kfree(node->mpath);
-	kfree(node);
-}
-
 static void mpp_path_flush(struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_table *tbl;
@@ -859,12 +879,8 @@ static void mpp_path_flush(struct ieee80211_sub_if_data *sdata)
 					lockdep_is_held(pathtbl_resize_lock));
 	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
-		if (mpath->sdata != sdata)
-			continue;
 		spin_lock_bh(&tbl->hashwlock[i]);
-		hlist_del_rcu(&node->list);
-		call_rcu(&node->rcu, mesh_path_node_reclaim);
-		atomic_dec(&tbl->entries);
+		__mesh_path_del(tbl, node);
 		spin_unlock_bh(&tbl->hashwlock[i]);
 	}
 	read_unlock_bh(&pathtbl_resize_lock);
@@ -912,14 +928,7 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
 		    memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
-			spin_lock_bh(&mpath->state_lock);
-			if (mpath->is_gate)
-				mesh_gate_del(tbl, mpath);
-			mpath->flags |= MESH_PATH_RESOLVING;
-			hlist_del_rcu(&node->list);
-			call_rcu(&node->rcu, mesh_path_node_reclaim);
-			atomic_dec(&tbl->entries);
-			spin_unlock_bh(&mpath->state_lock);
+			__mesh_path_del(tbl, node);
 			goto enddel;
 		}
 	}
@@ -1157,6 +1166,7 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 		    (!(mpath->flags & MESH_PATH_FIXED)) &&
 		     time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE))
 			mesh_path_del(mpath->dst, mpath->sdata);
+	}
 	rcu_read_unlock();
 }
 
-- 
1.7.4.1

