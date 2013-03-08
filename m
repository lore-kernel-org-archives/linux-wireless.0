Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757759Ab3CHNp5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 08:45:57 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Alexander Bondar <alexander.bondar@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] mac80211: move sdata debugfs dir to vif
Date: Fri,  8 Mar 2013 14:46:14 +0100
Message-Id: <1362750375-3759-1-git-send-email-sgruszka@redhat.com> (sfid-20130308_144601_130476_CAFB6D44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is need create driver own per interface debugfs files. This is
currently done by drv_{add,remove}_interface_debugfs() callbacks. But it
is possible that after we remove interface from the driver (i.e.
on suspend) we call drv_remove_interface_debugfs() function. Fixing this
problem will require to add call drv_{add,remove}_interface_debugfs()
anytime we create and remove interface in mac80211. So it's better to
add debugfs dir dentry to vif structure to allow to create/remove
custom debugfs driver files on drv_{add,remove}_interface().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/mac80211.h        |  6 ++++++
 net/mac80211/debugfs_key.c    | 10 +++++-----
 net/mac80211/debugfs_netdev.c | 22 +++++++++++-----------
 net/mac80211/driver-ops.h     |  4 ++--
 net/mac80211/ieee80211_i.h    |  1 -
 5 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f7eba13..97da981 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1067,6 +1067,8 @@ enum ieee80211_vif_flags {
  *	path needing to access it; even though the netdev carrier will always
  *	be off when it is %NULL there can still be races and packets could be
  *	processed after it switches back to %NULL.
+ * @debugfs_dir: debugfs dentry, can be used by drivers to create own per
+ *      interface debug files.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
@@ -1083,6 +1085,10 @@ struct ieee80211_vif {
 
 	u32 driver_flags;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct dentry *debugfs_dir;
+#endif
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index c3a3082..1521cab 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -295,7 +295,7 @@ void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 	char buf[50];
 	struct ieee80211_key *key;
 
-	if (!sdata->debugfs.dir)
+	if (!sdata->vif.debugfs_dir)
 		return;
 
 	lockdep_assert_held(&sdata->local->key_mtx);
@@ -311,7 +311,7 @@ void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
 		sdata->debugfs.default_unicast_key =
 			debugfs_create_symlink("default_unicast_key",
-					       sdata->debugfs.dir, buf);
+					       sdata->vif.debugfs_dir, buf);
 	}
 
 	if (sdata->debugfs.default_multicast_key) {
@@ -325,7 +325,7 @@ void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
 		sdata->debugfs.default_multicast_key =
 			debugfs_create_symlink("default_multicast_key",
-					       sdata->debugfs.dir, buf);
+					       sdata->vif.debugfs_dir, buf);
 	}
 }
 
@@ -334,7 +334,7 @@ void ieee80211_debugfs_key_add_mgmt_default(struct ieee80211_sub_if_data *sdata)
 	char buf[50];
 	struct ieee80211_key *key;
 
-	if (!sdata->debugfs.dir)
+	if (!sdata->vif.debugfs_dir)
 		return;
 
 	key = key_mtx_dereference(sdata->local,
@@ -343,7 +343,7 @@ void ieee80211_debugfs_key_add_mgmt_default(struct ieee80211_sub_if_data *sdata)
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
 		sdata->debugfs.default_mgmt_key =
 			debugfs_create_symlink("default_mgmt_key",
-					       sdata->debugfs.dir, buf);
+					       sdata->vif.debugfs_dir, buf);
 	} else
 		ieee80211_debugfs_key_remove_mgmt_default(sdata);
 }
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 059bbb8..ddb4268 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -521,7 +521,7 @@ IEEE80211_IF_FILE(dot11MeshAwakeWindowDuration,
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
-	debugfs_create_file(#name, mode, sdata->debugfs.dir, \
+	debugfs_create_file(#name, mode, sdata->vif.debugfs_dir, \
 			    sdata, &name##_ops);
 
 #define DEBUGFS_ADD(name) DEBUGFS_ADD_MODE(name, 0400)
@@ -577,7 +577,7 @@ static void add_mesh_files(struct ieee80211_sub_if_data *sdata)
 static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
 {
 	struct dentry *dir = debugfs_create_dir("mesh_stats",
-						sdata->debugfs.dir);
+						sdata->vif.debugfs_dir);
 #define MESHSTATS_ADD(name)\
 	debugfs_create_file(#name, 0400, dir, sdata, &name##_ops);
 
@@ -594,7 +594,7 @@ static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
 static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 {
 	struct dentry *dir = debugfs_create_dir("mesh_config",
-						sdata->debugfs.dir);
+						sdata->vif.debugfs_dir);
 
 #define MESHPARAMS_ADD(name) \
 	debugfs_create_file(#name, 0600, dir, sdata, &name##_ops);
@@ -631,7 +631,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 
 static void add_files(struct ieee80211_sub_if_data *sdata)
 {
-	if (!sdata->debugfs.dir)
+	if (!sdata->vif.debugfs_dir)
 		return;
 
 	DEBUGFS_ADD(flags);
@@ -673,21 +673,21 @@ void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata)
 	char buf[10+IFNAMSIZ];
 
 	sprintf(buf, "netdev:%s", sdata->name);
-	sdata->debugfs.dir = debugfs_create_dir(buf,
+	sdata->vif.debugfs_dir = debugfs_create_dir(buf,
 		sdata->local->hw.wiphy->debugfsdir);
-	if (sdata->debugfs.dir)
+	if (sdata->vif.debugfs_dir)
 		sdata->debugfs.subdir_stations = debugfs_create_dir("stations",
-			sdata->debugfs.dir);
+			sdata->vif.debugfs_dir);
 	add_files(sdata);
 }
 
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 {
-	if (!sdata->debugfs.dir)
+	if (!sdata->vif.debugfs_dir)
 		return;
 
-	debugfs_remove_recursive(sdata->debugfs.dir);
-	sdata->debugfs.dir = NULL;
+	debugfs_remove_recursive(sdata->vif.debugfs_dir);
+	sdata->vif.debugfs_dir = NULL;
 }
 
 void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata)
@@ -695,7 +695,7 @@ void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata)
 	struct dentry *dir;
 	char buf[10 + IFNAMSIZ];
 
-	dir = sdata->debugfs.dir;
+	dir = sdata->vif.debugfs_dir;
 
 	if (!dir)
 		return;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ee56d07..2f3dfbf 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -544,7 +544,7 @@ void drv_add_interface_debugfs(struct ieee80211_local *local,
 		return;
 
 	local->ops->add_interface_debugfs(&local->hw, &sdata->vif,
-					  sdata->debugfs.dir);
+					  sdata->vif.debugfs_dir);
 }
 
 static inline
@@ -559,7 +559,7 @@ void drv_remove_interface_debugfs(struct ieee80211_local *local,
 		return;
 
 	local->ops->remove_interface_debugfs(&local->hw, &sdata->vif,
-					     sdata->debugfs.dir);
+					     sdata->vif.debugfs_dir);
 }
 #else
 static inline
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 388580a..86ba3c1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -757,7 +757,6 @@ struct ieee80211_sub_if_data {
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct {
-		struct dentry *dir;
 		struct dentry *subdir_stations;
 		struct dentry *default_unicast_key;
 		struct dentry *default_multicast_key;
-- 
1.7.11.7

