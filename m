Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3BELs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 06:48:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: add vif debugfs driver callbacks
Date: Tue,  5 Feb 2013 12:49:22 +0100
Message-Id: <1360064962-19946-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_124902_865037_2359A3C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Add debugfs driver callbacks so drivers can add
debugfs entries for interfaces. Note that they
_must_ remove the entries again as add/remove in
the driver doesn't correspond to add/remove in
debugfs; the former is up/down while the latter
is netdev create/destroy.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    | 18 ++++++++++++++++++
 net/mac80211/driver-ops.h | 37 +++++++++++++++++++++++++++++++++++++
 net/mac80211/iface.c      |  4 ++++
 3 files changed, 59 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7da1121..46e08ba 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2167,6 +2167,18 @@ enum ieee80211_rate_control_changed {
  *	MAC address of the device going away.
  *	Hence, this callback must be implemented. It can sleep.
  *
+ * @add_interface_debugfs: Drivers can use this callback to add debugfs files
+ *	when a vif is added to mac80211. This callback and
+ *	@remove_interface_debugfs should be within a CONFIG_MAC80211_DEBUGFS
+ *	conditional. @remove_interface_debugfs must be provided for cleanup.
+ *	This callback can sleep.
+ *
+ * @remove_interface_debugfs: Remove the debugfs files which were added using
+ *	@add_interface_debugfs. This callback must remove all debugfs entries
+ *	that were added because mac80211 only removes interface debugfs when the
+ *	interface is destroyed, not when it is removed from the driver.
+ *	This callback can sleep.
+ *
  * @config: Handler for configuration requests. IEEE 802.11 code calls this
  *	function to change hardware configuration, e.g., channel.
  *	This function should never fail but returns a negative error code
@@ -2580,6 +2592,12 @@ struct ieee80211_ops {
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
index 434b3c4..2b08b99 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -528,6 +528,43 @@ static inline void drv_sta_remove_debugfs(struct ieee80211_local *local,
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
index 0a36dc6..deb78e8 100644
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
@@ -882,6 +884,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		 */
 		ieee80211_free_keys(sdata);
 
+		drv_remove_interface_debugfs(local, sdata);
+
 		if (going_down)
 			drv_remove_interface(local, sdata);
 	}
-- 
1.8.0

