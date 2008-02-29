Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:13593 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYCCUUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:50 -0500
Received: by gv-out-0910.google.com with SMTP id s4so170725gve.37
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:48 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 15:04:13 -0800
Subject: [PATCH 07/10] mac80211: always force mesh_path deletions
Message-ID: <47cc5d9e.06d6720a.421c.7563@mx.google.com> (sfid-20080303_202100_317234_23C7B313)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Postponing the deletion is not really useful anymore.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/cfg.c          |    2 +-
 net/mac80211/mesh.h         |    4 +---
 net/mac80211/mesh_hwmp.c    |    8 +-------
 net/mac80211/mesh_pathtbl.c |   24 ++++++++----------------
 4 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 69238fa..6b183a3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -785,7 +785,7 @@ static int ieee80211_del_mpath(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *dst)
 {
 	if (dst)
-		return mesh_path_del(dst, dev, false);
+		return mesh_path_del(dst, dev);
 
 	mesh_path_flush(dev);
 	return 0;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index add9b0d..742003d 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -30,7 +30,6 @@
  * @MESH_PATH_FIXED: the mesh path has been manually set and should not be
  * 	modified
  * @MESH_PATH_RESOLVED: the mesh path can has been resolved
- * @MESH_PATH_DELETE: the mesh path is scheduled to be deleted
  *
  * MESH_PATH_RESOLVED and MESH_PATH_DELETE are used by the mesh path timer to
  * decide when to stop or cancel the mesh path discovery.
@@ -41,7 +40,6 @@ enum mesh_path_flags {
 	MESH_PATH_DSN_VALID =	BIT(2),
 	MESH_PATH_FIXED	=	BIT(3),
 	MESH_PATH_RESOLVED =	BIT(4),
-	MESH_PATH_DELETE =	BIT(5),
 };
 
 /**
@@ -254,7 +252,7 @@ void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
 int mesh_pathtbl_init(void);
 void mesh_pathtbl_unregister(void);
-int mesh_path_del(u8 *addr, struct net_device *dev, bool force);
+int mesh_path_del(u8 *addr, struct net_device *dev);
 void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
 void mesh_path_discard_frame(struct sk_buff *skb, struct net_device *dev);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index c8c7d9a..324ebea 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -828,7 +828,6 @@ void mesh_path_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
-	bool delete = false;
 
 	rcu_read_lock();
 	mpath = (struct mesh_path *) data;
@@ -837,10 +836,7 @@ void mesh_path_timer(unsigned long data)
 		goto endmpathtimer;
 	spin_lock_bh(&mpath->state_lock);
 	sdata = IEEE80211_DEV_TO_SUB_IF(mpath->dev);
-	if (mpath->flags & MESH_PATH_DELETE) {
-		mpath->flags = 0;
-		delete = true;
-	} else if (mpath->flags & MESH_PATH_RESOLVED ||
+	if (mpath->flags & MESH_PATH_RESOLVED ||
 			(!(mpath->flags & MESH_PATH_RESOLVING)))
 		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
 	else if (mpath->discovery_retries < max_preq_retries(sdata)) {
@@ -856,6 +852,4 @@ void mesh_path_timer(unsigned long data)
 	spin_unlock_bh(&mpath->state_lock);
 endmpathtimer:
 	rcu_read_unlock();
-	if (delete)
-		mesh_path_del(mpath->dst, mpath->dev, false);
 }
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index bd58849..f74e4ce 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -277,7 +277,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	for_each_mesh_entry(mesh_paths, p, node, i) {
 		mpath = node->mpath;
 		if (mpath->next_hop == sta)
-			mesh_path_del(mpath->dst, mpath->dev, true);
+			mesh_path_del(mpath->dst, mpath->dev);
 	}
 }
 
@@ -291,7 +291,7 @@ void mesh_path_flush(struct net_device *dev)
 	for_each_mesh_entry(mesh_paths, p, node, i) {
 		mpath = node->mpath;
 		if (mpath->dev == dev)
-			mesh_path_del(mpath->dst, mpath->dev, false);
+			mesh_path_del(mpath->dst, mpath->dev);
 	}
 }
 
@@ -314,12 +314,8 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
  * @dev: local interface
  *
  * Returns: 0 if succesful
- *
- * State: if the path is being resolved, the deletion will be postponed until
- * the path resolution completes or times out, unless the force parameter
- * is given.
  */
-int mesh_path_del(u8 *addr, struct net_device *dev, bool force)
+int mesh_path_del(u8 *addr, struct net_device *dev)
 {
 	struct mesh_path *mpath;
 	struct mpath_node *node;
@@ -338,14 +334,10 @@ int mesh_path_del(u8 *addr, struct net_device *dev, bool force)
 		if (mpath->dev == dev &&
 				memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
 			spin_lock_bh(&mpath->state_lock);
-			if (!force && mpath->flags & MESH_PATH_RESOLVING) {
-				mpath->flags |= MESH_PATH_DELETE;
-			} else {
-				mpath->flags |= MESH_PATH_RESOLVING;
-				hlist_del_rcu(&node->list);
-				call_rcu(&node->rcu, mesh_path_node_reclaim);
-				atomic_dec(&mesh_paths->entries);
-			}
+			mpath->flags |= MESH_PATH_RESOLVING;
+			hlist_del_rcu(&node->list);
+			call_rcu(&node->rcu, mesh_path_node_reclaim);
+			atomic_dec(&mesh_paths->entries);
 			spin_unlock_bh(&mpath->state_lock);
 			goto enddel;
 		}
@@ -508,7 +500,7 @@ void mesh_path_expire(struct net_device *dev)
 			time_after(jiffies,
 			 mpath->exp_time + MESH_PATH_EXPIRE)) {
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_del(mpath->dst, mpath->dev, false);
+			mesh_path_del(mpath->dst, mpath->dev);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
-- 
1.5.2.5



