Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:35911 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbcB2BEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 20:04:09 -0500
Received: by mail-qg0-f66.google.com with SMTP id 14so9664194qgg.3
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 17:04:08 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/4] mac80211: mesh: embed known gates list in struct mesh_path
Date: Sun, 28 Feb 2016 20:03:59 -0500
Message-Id: <1456707839-19469-4-git-send-email-me@bobcopeland.com> (sfid-20160229_020424_085820_C46D447F)
In-Reply-To: <1456707839-19469-1-git-send-email-me@bobcopeland.com>
References: <1456707839-19469-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh path table uses a struct mesh_node in its hlists in
order to support a resizable hash table: the mesh_node provides
an indirection to the actual mesh path so that two different
bucket lists can point to the same path entry.

However, for the known gates list, we don't need this indirection
because there is ever only one list.  So we can just embed the
hlist_node in the mesh path itself, which simplifies things a bit
and saves a linear search whenever we need to find an item in
the list.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh.h         |   1 +
 net/mac80211/mesh_pathtbl.c | 100 +++++++++++++++++++-------------------------
 2 files changed, 45 insertions(+), 56 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 601992b6cd8a..f3cc3917e048 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -105,6 +105,7 @@ enum mesh_deferred_task_flags {
 struct mesh_path {
 	u8 dst[ETH_ALEN];
 	u8 mpp[ETH_ALEN];	/* used for MPP or MAP */
+	struct hlist_node gate_list;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info __rcu *next_hop;
 	struct timer_list timer;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 4794240e8f94..e4daf4b94eaf 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -119,10 +119,18 @@ static void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
 {
 	struct hlist_head *mesh_hash;
 	struct hlist_node *p, *q;
-	struct mpath_node *gate;
+	struct mesh_path *gate;
 	int i;
 
 	mesh_hash = tbl->hash_buckets;
+	if (free_leafs) {
+		spin_lock_bh(&tbl->gates_lock);
+		hlist_for_each_entry_safe(gate, q,
+					  tbl->known_gates, gate_list)
+			hlist_del(&gate->gate_list);
+		kfree(tbl->known_gates);
+		spin_unlock_bh(&tbl->gates_lock);
+	}
 	for (i = 0; i <= tbl->hash_mask; i++) {
 		spin_lock_bh(&tbl->hashwlock[i]);
 		hlist_for_each_safe(p, q, &mesh_hash[i]) {
@@ -131,16 +139,6 @@ static void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
 		}
 		spin_unlock_bh(&tbl->hashwlock[i]);
 	}
-	if (free_leafs) {
-		spin_lock_bh(&tbl->gates_lock);
-		hlist_for_each_entry_safe(gate, q,
-					 tbl->known_gates, list) {
-			hlist_del(&gate->list);
-			kfree(gate);
-		}
-		kfree(tbl->known_gates);
-		spin_unlock_bh(&tbl->gates_lock);
-	}
 
 	__mesh_table_free(tbl);
 }
@@ -431,30 +429,26 @@ mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 int mesh_path_add_gate(struct mesh_path *mpath)
 {
 	struct mesh_table *tbl;
-	struct mpath_node *gate, *new_gate;
 	int err;
 
 	rcu_read_lock();
 	tbl = rcu_dereference(mpath->sdata->u.mesh.mesh_paths);
 
-	hlist_for_each_entry_rcu(gate, tbl->known_gates, list)
-		if (gate->mpath == mpath) {
-			err = -EEXIST;
-			goto err_rcu;
-		}
-
-	new_gate = kzalloc(sizeof(struct mpath_node), GFP_ATOMIC);
-	if (!new_gate) {
-		err = -ENOMEM;
+	spin_lock_bh(&mpath->state_lock);
+	if (mpath->is_gate) {
+		err = -EEXIST;
+		spin_unlock_bh(&mpath->state_lock);
 		goto err_rcu;
 	}
-
 	mpath->is_gate = true;
 	mpath->sdata->u.mesh.num_gates++;
-	new_gate->mpath = mpath;
-	spin_lock_bh(&tbl->gates_lock);
-	hlist_add_head_rcu(&new_gate->list, tbl->known_gates);
-	spin_unlock_bh(&tbl->gates_lock);
+
+	spin_lock(&tbl->gates_lock);
+	hlist_add_head_rcu(&mpath->gate_list, tbl->known_gates);
+	spin_unlock(&tbl->gates_lock);
+
+	spin_unlock_bh(&mpath->state_lock);
+
 	mpath_dbg(mpath->sdata,
 		  "Mesh path: Recorded new gate: %pM. %d known gates\n",
 		  mpath->dst, mpath->sdata->u.mesh.num_gates);
@@ -468,28 +462,22 @@ err_rcu:
  * mesh_gate_del - remove a mesh gate from the list of known gates
  * @tbl: table which holds our list of known gates
  * @mpath: gate mpath
- *
- * Locking: must be called inside rcu_read_lock() section
  */
 static void mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
 {
-	struct mpath_node *gate;
-	struct hlist_node *q;
+	lockdep_assert_held(&mpath->state_lock);
+	if (!mpath->is_gate)
+		return;
 
-	hlist_for_each_entry_safe(gate, q, tbl->known_gates, list) {
-		if (gate->mpath != mpath)
-			continue;
-		spin_lock_bh(&tbl->gates_lock);
-		hlist_del_rcu(&gate->list);
-		kfree_rcu(gate, rcu);
-		spin_unlock_bh(&tbl->gates_lock);
-		mpath->sdata->u.mesh.num_gates--;
-		mpath->is_gate = false;
-		mpath_dbg(mpath->sdata,
-			  "Mesh path: Deleted gate: %pM. %d known gates\n",
-			  mpath->dst, mpath->sdata->u.mesh.num_gates);
-		break;
-	}
+	mpath->is_gate = false;
+	spin_lock_bh(&tbl->gates_lock);
+	hlist_del_rcu(&mpath->gate_list);
+	mpath->sdata->u.mesh.num_gates--;
+	spin_unlock_bh(&tbl->gates_lock);
+
+	mpath_dbg(mpath->sdata,
+		  "Mesh path: Deleted gate: %pM. %d known gates\n",
+		  mpath->dst, mpath->sdata->u.mesh.num_gates);
 }
 
 /**
@@ -781,13 +769,13 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mpath_node *node)
 	struct mesh_path *mpath = node->mpath;
 	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
 
-	spin_lock(&mpath->state_lock);
+	spin_lock_bh(&mpath->state_lock);
 	mpath->flags |= MESH_PATH_RESOLVING;
 	if (mpath->is_gate)
 		mesh_gate_del(tbl, mpath);
 	hlist_del_rcu(&node->list);
 	call_rcu(&node->rcu, mesh_path_node_reclaim);
-	spin_unlock(&mpath->state_lock);
+	spin_unlock_bh(&mpath->state_lock);
 	atomic_dec(&sdata->u.mesh.mpaths);
 	atomic_dec(&tbl->entries);
 }
@@ -999,7 +987,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 	struct ieee80211_sub_if_data *sdata = mpath->sdata;
 	struct mesh_table *tbl;
 	struct mesh_path *from_mpath = mpath;
-	struct mpath_node *gate = NULL;
+	struct mesh_path *gate = NULL;
 	bool copy = false;
 	struct hlist_head *known_gates;
 
@@ -1011,22 +999,22 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 	if (!known_gates)
 		return -EHOSTUNREACH;
 
-	hlist_for_each_entry_rcu(gate, known_gates, list) {
-		if (gate->mpath->flags & MESH_PATH_ACTIVE) {
-			mpath_dbg(sdata, "Forwarding to %pM\n", gate->mpath->dst);
-			mesh_path_move_to_queue(gate->mpath, from_mpath, copy);
-			from_mpath = gate->mpath;
+	hlist_for_each_entry_rcu(gate, known_gates, gate_list) {
+		if (gate->flags & MESH_PATH_ACTIVE) {
+			mpath_dbg(sdata, "Forwarding to %pM\n", gate->dst);
+			mesh_path_move_to_queue(gate, from_mpath, copy);
+			from_mpath = gate;
 			copy = true;
 		} else {
 			mpath_dbg(sdata,
 				  "Not forwarding to %pM (flags %#x)\n",
-				  gate->mpath->dst, gate->mpath->flags);
+				  gate->dst, gate->flags);
 		}
 	}
 
-	hlist_for_each_entry_rcu(gate, known_gates, list) {
-		mpath_dbg(sdata, "Sending to %pM\n", gate->mpath->dst);
-		mesh_path_tx_pending(gate->mpath);
+	hlist_for_each_entry_rcu(gate, known_gates, gate_list) {
+		mpath_dbg(sdata, "Sending to %pM\n", gate->dst);
+		mesh_path_tx_pending(gate);
 	}
 
 	return (from_mpath == mpath) ? -EHOSTUNREACH : 0;
-- 
2.6.1

