Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3AXMBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 07:01:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: Add vif debugfs driver callbacks
Date: Thu, 24 Jan 2013 13:01:39 +0100
Message-Id: <1359028899-14202-1-git-send-email-johannes@sipsolutions.net> (sfid-20130124_130124_687174_8696D982)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Add debugfs driver callbacks to be called upon interface addition,
removal and type change.

Change-Id: Iaf95ba5b2a6a3fca7d3dd7484de94127d23b8448
Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-on: http://musxgits01.imu.intel.com:8080/8761
Tested-by: IWL Jenkins
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    | 16 ++++++++++++++++
 net/mac80211/driver-ops.h | 37 +++++++++++++++++++++++++++++++++++++
 net/mac80211/iface.c      |  3 +++
 3 files changed, 56 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f10fe9f..4273e83 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2165,6 +2165,16 @@ enum ieee80211_rate_control_changed {
  *	MAC address of the device going away.
  *	Hence, this callback must be implemented. It can sleep.
  *
+ * @add_interface_debugfs: Drivers can use this callback to add debugfs files
+ *	when a vif is added to mac80211. This callback and
+ *	@remove_interface_debugfs should be within a CONFIG_MAC80211_DEBUGFS
+ *	conditional. This callback can sleep.
+ *
+ * @remove_interface_debugfs: Remove the debugfs files which were added using
+ *	@add_interface_debugfs. Even if add_interface_debufs is implemented,
+ *	this callback is optional, since all the directory will be removed
+ *	recursively. This callback can sleep.
+ *
  * @config: Handler for configuration requests. IEEE 802.11 code calls this
  *	function to change hardware configuration, e.g., channel.
  *	This function should never fail but returns a negative error code
@@ -2580,6 +2590,12 @@ struct ieee80211_ops {
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_sta *sta,
 				   struct dentry *dir);
+	void (*add_interface_debugfs)(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct dentry *dir);
+	void (*remove_interface_debugfs)(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif,
+					 struct dentry *dir);
 #endif
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4ce8d34..c6eef63 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -542,6 +542,43 @@ static inline void drv_sta_remove_debugfs(struct ieee80211_local *local,
 		local->ops->sta_remove_debugfs(&local->hw, &sdata->vif,
 					       sta, dir);
 }
+
+static inline
+void drv_add_interface_debugfs(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata)
+{
+	might_sleep();
+
+	check_sdata_in_driver(sdata);
+
+	if (!local->ops->add_interface_debugfs)
+		return;
+
+	local->ops->add_interface_debugfs(&local->hw, &sdata->vif,
+					  sdata->debugfs.dir);
+}
+
+static inline
+void drv_remove_interface_debugfs(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata)
+{
+	might_sleep();
+
+	check_sdata_in_driver(sdata);
+
+	if (!local->ops->remove_interface_debugfs)
+		return;
+
+	local->ops->remove_interface_debugfs(&local->hw, &sdata->vif,
+					     sdata->debugfs.dir);
+}
+#else
+static inline
+void drv_add_interface_debugfs(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata) {}
+static inline
+void drv_remove_interface_debugfs(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata) {}
 #endif
 
 static inline __must_check
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 02a3ec6..8bfc2fb 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -621,6 +621,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 				goto err_del_interface;
 		}
 
+		drv_add_interface_debugfs(local, sdata);
+
 		if (sdata->vif.type == NL80211_IFTYPE_AP) {
 			local->fif_pspoll++;
 			local->fif_probe_req++;
@@ -887,6 +889,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		 */
 		ieee80211_free_keys(sdata);
 
+		drv_remove_interface_debugfs(local, sdata);
 		if (going_down)
 			drv_remove_interface(local, sdata);
 	}
-- 
1.8.0

