Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab1KUKSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 05:18:38 -0500
Subject: [PATCH] mac80211: fix RCU warnings in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 11:18:33 +0100
Message-ID: <1321870713.3999.33.camel@jlt3.sipsolutions.net> (sfid-20111121_111841_644776_00D2FB95)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sparse RCU checking reports two warnings in the mesh
path table code. These are due to questionable uses of
rcu_dereference.

To fix the first one, get rid of mesh_gate_add() and
just make mesh_path_add_gate() do the correct deref.

To fix the second one, simply remove rcu_dereference()
in mesh_gate_del() -- it already gets a proper pointer
as indicated by the prototype (no __rcu annotation)
and confirmed by the code.

Cc: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_pathtbl.c |   26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

--- a/net/mac80211/mesh_pathtbl.c	2011-11-18 17:04:20.000000000 +0100
+++ b/net/mac80211/mesh_pathtbl.c	2011-11-21 11:13:58.000000000 +0100
@@ -69,8 +69,6 @@ static inline struct mesh_table *resize_
 		lockdep_is_held(&pathtbl_resize_lock));
 }
 
-static int mesh_gate_add(struct mesh_table *tbl, struct mesh_path *mpath);
-
 /*
  * CAREFUL -- "tbl" must not be an expression,
  * in particular not an rcu_dereference(), since
@@ -420,21 +418,17 @@ static void mesh_gate_node_reclaim(struc
 }
 
 /**
- * mesh_gate_add - mark mpath as path to a mesh gate and add to known_gates
- * @mesh_tbl: table which contains known_gates list
- * @mpath: mpath to known mesh gate
- *
- * Returns: 0 on success
- *
+ * mesh_path_add_gate - add the given mpath to a mesh gate to our path table
+ * @mpath: gate path to add to table
  */
-static int mesh_gate_add(struct mesh_table *tbl, struct mesh_path *mpath)
+static int mesh_path_add_gate(struct mesh_table *tbl, struct mesh_path *mpath)
 {
 	struct mpath_node *gate, *new_gate;
 	struct hlist_node *n;
 	int err;
 
 	rcu_read_lock();
-	tbl = rcu_dereference(tbl);
+	tbl = rcu_dereference(mesh_paths);
 
 	hlist_for_each_entry_rcu(gate, n, tbl->known_gates, list)
 		if (gate->mpath == mpath) {
@@ -478,8 +472,6 @@ static int mesh_gate_del(struct mesh_tab
 	struct mpath_node *gate;
 	struct hlist_node *p, *q;
 
-	tbl = rcu_dereference(tbl);
-
 	hlist_for_each_entry_safe(gate, p, q, tbl->known_gates, list)
 		if (gate->mpath == mpath) {
 			spin_lock_bh(&tbl->gates_lock);
@@ -498,16 +490,6 @@ static int mesh_gate_del(struct mesh_tab
 }
 
 /**
- *
- * mesh_path_add_gate - add the given mpath to a mesh gate to our path table
- * @mpath: gate path to add to table
- */
-int mesh_path_add_gate(struct mesh_path *mpath)
-{
-	return mesh_gate_add(mesh_paths, mpath);
-}
-
-/**
  * mesh_gate_num - number of gates known to this interface
  * @sdata: subif data
  */


