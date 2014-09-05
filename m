Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41776 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaIELop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 07:44:45 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so784423lbv.24
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2014 04:44:43 -0700 (PDT)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Subject: [PATCH v2 2/2] Implement get_mpp and dump_mpp cfg80211_ops to export  the content of the 802.11s mesh proxy path table to userspace.
Date: Fri, 05 Sep 2014 13:44:40 +0200
Message-ID: <1420374.Xr0mcMrsU7@rogge-hp-probook-6470b> (sfid-20140905_134447_595779_8B54FEB6)
In-Reply-To: <2453987.UPN20YN3D3@rogge-hp-probook-6470b>
References: <2453987.UPN20YN3D3@rogge-hp-probook-6470b>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Henning Rogge" <henning.rogge <at> fkie.fraunhofer.de>

This patch implements the get_mpp and dump_mpp cfg80211_ops for the default
mac80211s implementation.

---
 net/mac80211/cfg.c          | 53 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mesh.h         |  3 +++
 net/mac80211/mesh_pathtbl.c | 31 ++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 927b4ea..2b85eed 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1511,6 +1511,57 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static void mpp_set_pinfo(struct mesh_path *mpath, u8 *mpp,
+			  struct mpath_info *pinfo)
+{
+	memset(pinfo, 0, sizeof(*pinfo));
+	memcpy(mpp, mpath->mpp, ETH_ALEN);
+
+	pinfo->generation = mpp_paths_generation;
+}
+
+static int ieee80211_get_mpp(struct wiphy *wiphy, struct net_device *dev,
+			     u8 *dst, u8 *mpp, struct mpath_info *pinfo)
+
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct mesh_path *mpath;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	rcu_read_lock();
+	mpath = mpp_path_lookup(sdata, dst);
+	if (!mpath) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+	memcpy(dst, mpath->dst, ETH_ALEN);
+	mpp_set_pinfo(mpath, mpp, pinfo);
+	rcu_read_unlock();
+	return 0;
+}
+
+static int ieee80211_dump_mpp(struct wiphy *wiphy, struct net_device *dev,
+			      int idx, u8 *dst, u8 *mpp,
+			      struct mpath_info *pinfo)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct mesh_path *mpath;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	rcu_read_lock();
+	mpath = mpp_path_lookup_by_idx(sdata, idx);
+	if (!mpath) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+	memcpy(dst, mpath->dst, ETH_ALEN);
+	mpp_set_pinfo(mpath, mpp, pinfo);
+	rcu_read_unlock();
+	return 0;
+}
+
 static int ieee80211_get_mesh_config(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct mesh_config *conf)
@@ -3507,6 +3558,8 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.change_mpath = ieee80211_change_mpath,
 	.get_mpath = ieee80211_get_mpath,
 	.dump_mpath = ieee80211_dump_mpath,
+	.get_mpp = ieee80211_get_mpp,
+	.dump_mpp = ieee80211_dump_mpp,
 	.update_mesh_config = ieee80211_update_mesh_config,
 	.get_mesh_config = ieee80211_get_mesh_config,
 	.join_mesh = ieee80211_join_mesh,
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index f39a19f..50c8473 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -270,6 +270,8 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		 const u8 *dst, const u8 *mpp);
 struct mesh_path *
 mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx);
+struct mesh_path *
+mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
@@ -317,6 +319,7 @@ void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
 
 bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt);
 extern int mesh_paths_generation;
+extern int mpp_paths_generation;
 
 #ifdef CONFIG_MAC80211_MESH
 static inline
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index cf032a8..8630963 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -44,6 +44,7 @@ static struct mesh_table __rcu *mesh_paths;
 static struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */
 
 int mesh_paths_generation;
+int mpp_paths_generation;
 
 /* This lock will have the grow table function as writer and add / delete nodes
  * as readers. RCU provides sufficient protection only when reading the table
@@ -410,6 +411,33 @@ mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 }
 
 /**
+ * mpp_path_lookup_by_idx - look up a path in the proxy path table by its index
+ * @idx: index
+ * @sdata: local subif, or NULL for all entries
+ *
+ * Returns: pointer to the proxy path structure, or NULL if not found.
+ *
+ * Locking: must be called within a read rcu section.
+ */
+struct mesh_path *
+mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
+{
+	struct mesh_table *tbl = rcu_dereference(mpp_paths);
+	struct mpath_node *node;
+	int i;
+	int j = 0;
+
+	for_each_mesh_entry(tbl, node, i) {
+		if (sdata && node->mpath->sdata != sdata)
+			continue;
+		if (j++ == idx)
+			return node->mpath;
+	}
+
+	return NULL;
+}
+
+/**
  * mesh_path_add_gate - add the given mpath to a mesh gate to our path table
  * @mpath: gate path to add to table
  */
@@ -691,6 +719,9 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 
 	spin_unlock(&tbl->hashwlock[hash_idx]);
 	read_unlock_bh(&pathtbl_resize_lock);
+
+	mpp_paths_generation++;
+
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
 		ieee80211_queue_work(&local->hw, &sdata->work);
-- 
1.9.1


