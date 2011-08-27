Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55140 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1H0ASa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 20:18:30 -0400
Received: by gwaa12 with SMTP id a12so3310201gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 17:18:30 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 2/8] mac80211: Remove mesh paths when an interface is removed
Date: Fri, 26 Aug 2011 17:18:08 -0700
Message-Id: <1314404294-4233-3-git-send-email-javier@cozybit.com> (sfid-20110827_021834_025046_B230B7D0)
In-Reply-To: <1314404294-4233-1-git-send-email-javier@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314404294-4233-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an interface is removed, the mesh paths associated with it should
also be removed.

This fixes a bug we observed when reloading a device driver module
without reloading mac80211s.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/cfg.c          |    2 +-
 net/mac80211/iface.c        |    6 ++++++
 net/mac80211/mesh.h         |    2 +-
 net/mac80211/mesh_pathtbl.c |   40 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0baaaec..5c0d8fa 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -921,7 +921,7 @@ static int ieee80211_del_mpath(struct wiphy *wiphy, struct net_device *dev,
 	if (dst)
 		return mesh_path_del(dst, sdata);
 
-	mesh_path_flush(sdata);
+	mesh_path_flush_by_iface(sdata);
 	return 0;
 }
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 556e7e6..eaa80a3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1214,6 +1214,9 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		mesh_path_flush_by_iface(sdata);
+
 	synchronize_rcu();
 	unregister_netdevice(sdata->dev);
 }
@@ -1233,6 +1236,9 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
 
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			mesh_path_flush_by_iface(sdata);
+
 		unregister_netdevice_queue(sdata->dev, &unreg_list);
 	}
 	mutex_unlock(&local->iflist_mtx);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2027207..57a2ad0 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -238,7 +238,6 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
-void mesh_path_flush(struct ieee80211_sub_if_data *sdata);
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_mgmt *mgmt, size_t len);
 int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata);
@@ -275,6 +274,7 @@ void mesh_pathtbl_unregister(void);
 int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata);
 void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
+void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_path_discard_frame(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_path_quiesce(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index c92fd70..1c8c420 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -821,7 +821,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	rcu_read_unlock();
 }
 
-void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
+static void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
@@ -850,6 +850,44 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
 	kfree(node);
 }
 
+static void mpp_path_flush(struct ieee80211_sub_if_data *sdata)
+{
+	struct mesh_table *tbl;
+	struct mesh_path *mpath;
+	struct mpath_node *node;
+	struct hlist_node *p;
+	int i;
+
+	read_lock_bh(&pathtbl_resize_lock);
+	tbl = rcu_dereference_protected(mpp_paths,
+					lockdep_is_held(pathtbl_resize_lock));
+	for_each_mesh_entry(tbl, p, node, i) {
+		mpath = node->mpath;
+		if (mpath->sdata != sdata)
+			continue;
+		spin_lock_bh(&tbl->hashwlock[i]);
+		spin_lock_bh(&mpath->state_lock);
+		call_rcu(&node->rcu, mesh_path_node_reclaim);
+		atomic_dec(&tbl->entries);
+		spin_unlock_bh(&tbl->hashwlock[i]);
+	}
+	read_unlock_bh(&pathtbl_resize_lock);
+}
+
+/**
+ * mesh_path_flush_by_iface - Deletes all mesh paths associated with a given iface
+ *
+ * This function deletes both mesh paths as well as mesh portal paths.
+ *
+ * @sdata - interface data to match
+ *
+ */
+void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
+{
+	mesh_path_flush(sdata);
+	mpp_path_flush(sdata);
+}
+
 /**
  * mesh_path_del - delete a mesh path from the table
  *
-- 
1.7.6

