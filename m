Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58065 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbbKQOqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 09:46:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: mesh: fix call_rcu() usage
Date: Tue, 17 Nov 2015 15:46:01 +0100
Message-Id: <1447771561-28070-1-git-send-email-johannes@sipsolutions.net> (sfid-20151117_154609_445829_918D6751)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When using call_rcu(), the called function may be delayed quite
significantly, and without a matching rcu_barrier() there's no
way to be sure it has finished.
Therefore, global state that could be gone/freed/reused should
never be touched in the callback.

Fix this in mesh by moving the atomic_dec() into the caller;
that's not really a problem since we already unlinked the path
and it will be destroyed anyway.

This fixes a crash Jouni observed when running certain tests in
a certain order, in which the mesh interface was torn down, the
memory reused for a function pointer (work struct) and running
that then crashed since the pointer had been decremented by 1,
resulting in an invalid instruction byte stream.

Cc: stable@vger.kernel.org
Fixes: eb2b9311fd00 ("mac80211: mesh path table implementation")
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_pathtbl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index b890e225a8f1..b3b44a5dd375 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -779,10 +779,8 @@ void mesh_plink_broken(struct sta_info *sta)
 static void mesh_path_node_reclaim(struct rcu_head *rp)
 {
 	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
-	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
 
 	del_timer_sync(&node->mpath->timer);
-	atomic_dec(&sdata->u.mesh.mpaths);
 	kfree(node->mpath);
 	kfree(node);
 }
@@ -790,8 +788,9 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
 /* needs to be called with the corresponding hashwlock taken */
 static void __mesh_path_del(struct mesh_table *tbl, struct mpath_node *node)
 {
-	struct mesh_path *mpath;
-	mpath = node->mpath;
+	struct mesh_path *mpath = node->mpath;
+	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
+
 	spin_lock(&mpath->state_lock);
 	mpath->flags |= MESH_PATH_RESOLVING;
 	if (mpath->is_gate)
@@ -799,6 +798,7 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mpath_node *node)
 	hlist_del_rcu(&node->list);
 	call_rcu(&node->rcu, mesh_path_node_reclaim);
 	spin_unlock(&mpath->state_lock);
+	atomic_dec(&sdata->u.mesh.mpaths);
 	atomic_dec(&tbl->entries);
 }
 
-- 
2.6.2

