Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62175 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1HYBlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:41:18 -0400
Received: by mail-gw0-f46.google.com with SMTP id a12so1345427gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:41:17 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 4/9] mac80211: Improve mpath state locking
Date: Wed, 24 Aug 2011 18:40:47 -0700
Message-Id: <1314236452-7226-5-git-send-email-thomas@cozybit.com> (sfid-20110825_034120_708866_25874059)
In-Reply-To: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

No need to take the mpath state lock when an mpath is removed.
Also, no need checking the lock when reading mpath flags.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh.h         |    4 +++-
 net/mac80211/mesh_pathtbl.c |   14 +++-----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index ac84dc6..42536a4 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -80,7 +80,9 @@ enum mesh_deferred_task_flags {
  * 	retry
  * @discovery_retries: number of discovery retries
  * @flags: mesh path flags, as specified on &enum mesh_path_flags
- * @state_lock: mesh path state lock
+ * @state_lock: mesh path state lock used to protect changes to the
+ * mpath itself.  No need to take this lock when adding or removing
+ * an mpath to a hash bucket on a path table.
  * @is_gate: the destination station of this path is a mesh gate
  *
  *
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index ef558c1..3c96e55 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -776,18 +776,17 @@ void mesh_plink_broken(struct sta_info *sta)
 	tbl = rcu_dereference(mesh_paths);
 	for_each_mesh_entry(tbl, p, node, i) {
 		mpath = node->mpath;
-		spin_lock_bh(&mpath->state_lock);
 		if (rcu_dereference(mpath->next_hop) == sta &&
 		    mpath->flags & MESH_PATH_ACTIVE &&
 		    !(mpath->flags & MESH_PATH_FIXED)) {
+			spin_lock_bh(&mpath->state_lock);
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			++mpath->sn;
 			spin_unlock_bh(&mpath->state_lock);
 			mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
 					mpath->dst, cpu_to_le32(mpath->sn),
 					reason, bcast, sdata);
-		} else
-		spin_unlock_bh(&mpath->state_lock);
+		}
 	}
 	rcu_read_unlock();
 }
@@ -866,11 +865,9 @@ static void mpp_path_flush(struct ieee80211_sub_if_data *sdata)
 		if (mpath->sdata != sdata)
 			continue;
 		spin_lock_bh(&tbl->hashwlock[i]);
-		spin_lock_bh(&mpath->state_lock);
 		hlist_del_rcu(&node->list);
 		call_rcu(&node->rcu, mesh_path_node_reclaim);
 		atomic_dec(&tbl->entries);
-		spin_unlock_bh(&mpath->state_lock);
 		spin_unlock_bh(&tbl->hashwlock[i]);
 	}
 	read_unlock_bh(&pathtbl_resize_lock);
@@ -1159,15 +1156,10 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 		if (node->mpath->sdata != sdata)
 			continue;
 		mpath = node->mpath;
-		spin_lock_bh(&mpath->state_lock);
 		if ((!(mpath->flags & MESH_PATH_RESOLVING)) &&
 		    (!(mpath->flags & MESH_PATH_FIXED)) &&
-		     time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE)) {
-			spin_unlock_bh(&mpath->state_lock);
+		     time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE))
 			mesh_path_del(mpath->dst, mpath->sdata);
-		} else
-			spin_unlock_bh(&mpath->state_lock);
-	}
 	rcu_read_unlock();
 }
 
-- 
1.7.4.1

