Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17985 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab2DXLRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 07:17:36 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Adds clean sdata helper
Date: Tue, 24 Apr 2012 14:18:28 +0300
Message-Id: <1335266308-3286-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_131807_192899_819D1A2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Adds hepler to clean sdata ieee80211_clean_sdata similar way as
ieee80211_setup_sdata is implemented. The function will be used by other
interfaces later.

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 net/mac80211/iface.c |   19 +++++++++++++++----
 net/mac80211/mesh.h  |    4 +++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 401c01f..96f8773 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -907,6 +907,18 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	ieee80211_debugfs_add_netdev(sdata);
 }
 
+static void ieee80211_clean_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_MESH_POINT:
+		mesh_path_flush_by_iface(sdata);
+		break;
+
+	default:
+		break;
+	}
+}
+
 static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 					   enum nl80211_iftype type)
 {
@@ -1227,8 +1239,8 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		mesh_path_flush_by_iface(sdata);
+	/* clean up type-dependent data */
+	ieee80211_clean_sdata(sdata);
 
 	synchronize_rcu();
 	unregister_netdevice(sdata->dev);
@@ -1249,8 +1261,7 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
 
-		if (ieee80211_vif_is_mesh(&sdata->vif))
-			mesh_path_flush_by_iface(sdata);
+		ieee80211_clean_sdata(sdata);
 
 		unregister_netdevice_queue(sdata->dev, &unreg_list);
 	}
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8d53b71..5b4f670 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -284,7 +284,6 @@ void mesh_pathtbl_unregister(void);
 int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata);
 void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
-void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_path_discard_frame(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_path_quiesce(struct ieee80211_sub_if_data *sdata);
@@ -325,6 +324,7 @@ void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_quiesce(struct sta_info *sta);
 void mesh_plink_restart(struct sta_info *sta);
+void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 #else
 #define mesh_allocated	0
 static inline void
@@ -337,6 +337,8 @@ static inline void mesh_plink_quiesce(struct sta_info *sta) {}
 static inline void mesh_plink_restart(struct sta_info *sta) {}
 static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 { return false; }
+static inline void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
+{}
 #endif
 
 #endif /* IEEE80211S_H */
-- 
1.7.9.5

