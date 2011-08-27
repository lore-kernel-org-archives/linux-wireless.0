Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61573 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1H0ASl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 20:18:41 -0400
Received: by yie30 with SMTP id 30so2047705yie.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 17:18:40 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 6/8] mac80211: Consolidate {mesh,mpp}_path_flush into one function
Date: Fri, 26 Aug 2011 17:18:12 -0700
Message-Id: <1314404294-4233-7-git-send-email-javier@cozybit.com> (sfid-20110827_021844_832620_27517CEE)
In-Reply-To: <1314404294-4233-1-git-send-email-javier@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314404294-4233-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>

---
v2: - Fix extra space (checkpatch)
    - Add lockdep check for RCU
 net/mac80211/mesh_pathtbl.c |   65 +++++++++++++++++-------------------------
 1 files changed, 26 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index ea9e34a..3c03be9 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -790,35 +790,6 @@ void mesh_plink_broken(struct sta_info *sta)
 	rcu_read_unlock();
 }
 
-/**
- * mesh_path_flush_by_nexthop - Deletes mesh paths if their next hop matches
- *
- * @sta - mesh peer to match
- *
- * RCU notes: this function is called when a mesh plink transitions from
- * PLINK_ESTAB to any other state, since PLINK_ESTAB state is the only one that
- * allows path creation. This will happen before the sta can be freed (because
- * sta_info_destroy() calls this) so any reader in a rcu read block will be
- * protected against the plink disappearing.
- */
-void mesh_path_flush_by_nexthop(struct sta_info *sta)
-{
-	struct mesh_table *tbl;
-	struct mesh_path *mpath;
-	struct mpath_node *node;
-	struct hlist_node *p;
-	int i;
-
-	rcu_read_lock();
-	tbl = rcu_dereference(mesh_paths);
-	for_each_mesh_entry(tbl, p, node, i) {
-		mpath = node->mpath;
-		if (rcu_dereference(mpath->next_hop) == sta)
-			mesh_path_del(mpath->dst, mpath->sdata);
-	}
-	rcu_read_unlock();
-}
-
 static void mesh_path_node_reclaim(struct rcu_head *rp)
 {
 	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
@@ -845,7 +816,18 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mpath_node *node)
 	atomic_dec(&tbl->entries);
 }
 
-static void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
+/**
+ * mesh_path_flush_by_nexthop - Deletes mesh paths if their next hop matches
+ *
+ * @sta - mesh peer to match
+ *
+ * RCU notes: this function is called when a mesh plink transitions from
+ * PLINK_ESTAB to any other state, since PLINK_ESTAB state is the only one that
+ * allows path creation. This will happen before the sta can be freed (because
+ * sta_info_destroy() calls this) so any reader in a rcu read block will be
+ * protected against the plink disappearing.
+ */
+void mesh_path_flush_by_nexthop(struct sta_info *sta)
 {
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
@@ -857,7 +839,7 @@ static void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
 	tbl = rcu_dereference(mesh_paths);
 	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
-		if (mpath->sdata == sdata) {
+		if (rcu_dereference(mpath->next_hop) == sta) {
 			spin_lock_bh(&tbl->hashwlock[i]);
 			__mesh_path_del(tbl, node);
 			spin_unlock_bh(&tbl->hashwlock[i]);
@@ -866,24 +848,23 @@ static void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
 	rcu_read_unlock();
 }
 
-static void mpp_path_flush(struct ieee80211_sub_if_data *sdata)
+static void table_flush_by_iface(struct mesh_table *tbl,
+				 struct ieee80211_sub_if_data *sdata)
 {
-	struct mesh_table *tbl;
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_node *p;
 	int i;
 
-	read_lock_bh(&pathtbl_resize_lock);
-	tbl = rcu_dereference_protected(mpp_paths,
-					lockdep_is_held(pathtbl_resize_lock));
+	WARN_ON(!rcu_read_lock_held());
 	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
+		if (mpath->sdata != sdata)
+			continue;
 		spin_lock_bh(&tbl->hashwlock[i]);
 		__mesh_path_del(tbl, node);
 		spin_unlock_bh(&tbl->hashwlock[i]);
 	}
-	read_unlock_bh(&pathtbl_resize_lock);
 }
 
 /**
@@ -896,8 +877,14 @@ static void mpp_path_flush(struct ieee80211_sub_if_data *sdata)
  */
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 {
-	mesh_path_flush(sdata);
-	mpp_path_flush(sdata);
+	struct mesh_table *tbl;
+
+	rcu_read_lock();
+	tbl = rcu_dereference(mesh_paths);
+	table_flush_by_iface(tbl, sdata);
+	tbl = rcu_dereference(mpp_paths);
+	table_flush_by_iface(tbl, sdata);
+	rcu_read_unlock();
 }
 
 /**
-- 
1.7.6

