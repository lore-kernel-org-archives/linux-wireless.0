Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:36279 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYCCUVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:21:03 -0500
Received: by el-out-1112.google.com with SMTP id v27so330530ele.17
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:21:02 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 17:51:25 -0800
Subject: [PATCH 10/10] mac80211: fix mesh_path and sta_info get_by_idx functions
Message-ID: <47cc5dac.1bbd600a.20b9.ffff82b2@mx.google.com> (sfid-20080303_202142_687122_36D72F0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Skip properly entries whose dev does not match.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    7 +++++--
 net/mac80211/sta_info.c     |    5 +++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 135022d..5845dc2 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -98,7 +98,7 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct net_device *dev)
 /**
  * mesh_path_lookup_by_idx - look up a path in the mesh path table by its index
  * @idx: index
- * @dev: local interface
+ * @dev: local interface, or NULL for all entries
  *
  * Returns: pointer to the mesh path structure, or NULL if not found.
  *
@@ -111,7 +111,9 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct net_device *dev)
 	int i;
 	int j = 0;
 
-	for_each_mesh_entry(mesh_paths, p, node, i)
+	for_each_mesh_entry(mesh_paths, p, node, i) {
+		if (dev && node->mpath->dev != dev)
+			continue;
 		if (j++ == idx) {
 			if (MPATH_EXPIRED(node->mpath)) {
 				spin_lock_bh(&node->mpath->state_lock);
@@ -121,6 +123,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct net_device *dev)
 			}
 			return node->mpath;
 		}
+	}
 
 	return NULL;
 }
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e27f896..3b84c16 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -115,12 +115,13 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
 	int i = 0;
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (dev && dev != sta->sdata->dev)
+			continue;
 		if (i < idx) {
 			++i;
 			continue;
-		} else if (!dev || dev == sta->sdata->dev) {
-			return sta;
 		}
+		return sta;
 	}
 
 	return NULL;
-- 
1.5.2.5



