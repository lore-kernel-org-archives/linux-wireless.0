Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:33964 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbcCSCLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 22:11:41 -0400
Received: by mail-qg0-f68.google.com with SMTP id j92so6595918qgj.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 19:11:41 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/5] mac80211: mesh: embed gates hlist head directly
Date: Fri, 18 Mar 2016 22:11:30 -0400
Message-Id: <1458353492-8654-4-git-send-email-me@bobcopeland.com> (sfid-20160319_031155_123006_375F875B)
In-Reply-To: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
References: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we have converted the mesh path tables to rhashtable, we are
no longer swapping out the entire mesh_pathtbl pointer with RCU.
As a result, we no longer need indirection to the hlist head for
the gates list and can simply embed it, saving a pair of
pointer-sized allocations.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh.h         |  2 +-
 net/mac80211/mesh_pathtbl.c | 18 ++++--------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index bc3f9a32b5a4..46b540a25d9d 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -134,7 +134,7 @@ struct mesh_path {
  */
 struct mesh_table {
 	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
-	struct hlist_head *known_gates;
+	struct hlist_head known_gates;
 	spinlock_t gates_lock;
 
 	struct rhashtable rhead;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 1c9412a29ca3..6db2ddfa0695 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -58,12 +58,7 @@ static struct mesh_table *mesh_table_alloc(void)
 	if (!newtbl)
 		return NULL;
 
-	newtbl->known_gates = kzalloc(sizeof(struct hlist_head), GFP_ATOMIC);
-	if (!newtbl->known_gates) {
-		kfree(newtbl);
-		return NULL;
-	}
-	INIT_HLIST_HEAD(newtbl->known_gates);
+	INIT_HLIST_HEAD(&newtbl->known_gates);
 	atomic_set(&newtbl->entries,  0);
 	spin_lock_init(&newtbl->gates_lock);
 
@@ -341,7 +336,7 @@ int mesh_path_add_gate(struct mesh_path *mpath)
 	mpath->sdata->u.mesh.num_gates++;
 
 	spin_lock(&tbl->gates_lock);
-	hlist_add_head_rcu(&mpath->gate_list, tbl->known_gates);
+	hlist_add_head_rcu(&mpath->gate_list, &tbl->known_gates);
 	spin_unlock(&tbl->gates_lock);
 
 	spin_unlock_bh(&mpath->state_lock);
@@ -759,16 +754,11 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 	struct mesh_path *from_mpath = mpath;
 	struct mesh_path *gate;
 	bool copy = false;
-	struct hlist_head *known_gates;
 
 	tbl = sdata->u.mesh.mesh_paths;
-	known_gates = tbl->known_gates;
-
-	if (!known_gates)
-		return -EHOSTUNREACH;
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(gate, known_gates, gate_list) {
+	hlist_for_each_entry_rcu(gate, &tbl->known_gates, gate_list) {
 		if (gate->flags & MESH_PATH_ACTIVE) {
 			mpath_dbg(sdata, "Forwarding to %pM\n", gate->dst);
 			mesh_path_move_to_queue(gate, from_mpath, copy);
@@ -781,7 +771,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 		}
 	}
 
-	hlist_for_each_entry_rcu(gate, known_gates, gate_list) {
+	hlist_for_each_entry_rcu(gate, &tbl->known_gates, gate_list) {
 		mpath_dbg(sdata, "Sending to %pM\n", gate->dst);
 		mesh_path_tx_pending(gate);
 	}
-- 
2.6.1

