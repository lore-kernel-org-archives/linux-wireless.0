Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757759Ab3CHNp6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 08:45:58 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Alexander Bondar <alexander.bondar@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] mac80211: remove vif debugfs driver callbacks
Date: Fri,  8 Mar 2013 14:46:15 +0100
Message-Id: <1362750375-3759-2-git-send-email-sgruszka@redhat.com> (sfid-20130308_144603_229400_36765C8D)
In-Reply-To: <1362750375-3759-1-git-send-email-sgruszka@redhat.com>
References: <1362750375-3759-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This basically reverts commit b207cdb07f3f01ec1adaac62e9d0cc918c60a81a.

Now is possible to use drv_{add,remove}_interface() and vif->debugfs_dir
to create/remove per interface debugfs files. Remove redundant
callbacks.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/mac80211.h    | 18 ------------------
 net/mac80211/driver-ops.h | 37 -------------------------------------
 net/mac80211/iface.c      |  4 ----
 3 files changed, 59 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 97da981..81d6733 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2218,18 +2218,6 @@ enum ieee80211_rate_control_changed {
  *	MAC address of the device going away.
  *	Hence, this callback must be implemented. It can sleep.
  *
- * @add_interface_debugfs: Drivers can use this callback to add debugfs files
- *	when a vif is added to mac80211. This callback and
- *	@remove_interface_debugfs should be within a CONFIG_MAC80211_DEBUGFS
- *	conditional. @remove_interface_debugfs must be provided for cleanup.
- *	This callback can sleep.
- *
- * @remove_interface_debugfs: Remove the debugfs files which were added using
- *	@add_interface_debugfs. This callback must remove all debugfs entries
- *	that were added because mac80211 only removes interface debugfs when the
- *	interface is destroyed, not when it is removed from the driver.
- *	This callback can sleep.
- *
  * @config: Handler for configuration requests. IEEE 802.11 code calls this
  *	function to change hardware configuration, e.g., channel.
  *	This function should never fail but returns a negative error code
@@ -2643,12 +2631,6 @@ struct ieee80211_ops {
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_sta *sta,
 				   struct dentry *dir);
-	void (*add_interface_debugfs)(struct ieee80211_hw *hw,
-				      struct ieee80211_vif *vif,
-				      struct dentry *dir);
-	void (*remove_interface_debugfs)(struct ieee80211_hw *hw,
-					 struct ieee80211_vif *vif,
-					 struct dentry *dir);
 #endif
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 2f3dfbf..ccbfb55 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -531,43 +531,6 @@ static inline void drv_sta_remove_debugfs(struct ieee80211_local *local,
 		local->ops->sta_remove_debugfs(&local->hw, &sdata->vif,
 					       sta, dir);
 }
-
-static inline
-void drv_add_interface_debugfs(struct ieee80211_local *local,
-			       struct ieee80211_sub_if_data *sdata)
-{
-	might_sleep();
-
-	check_sdata_in_driver(sdata);
-
-	if (!local->ops->add_interface_debugfs)
-		return;
-
-	local->ops->add_interface_debugfs(&local->hw, &sdata->vif,
-					  sdata->vif.debugfs_dir);
-}
-
-static inline
-void drv_remove_interface_debugfs(struct ieee80211_local *local,
-				  struct ieee80211_sub_if_data *sdata)
-{
-	might_sleep();
-
-	check_sdata_in_driver(sdata);
-
-	if (!local->ops->remove_interface_debugfs)
-		return;
-
-	local->ops->remove_interface_debugfs(&local->hw, &sdata->vif,
-					     sdata->vif.debugfs_dir);
-}
-#else
-static inline
-void drv_add_interface_debugfs(struct ieee80211_local *local,
-			       struct ieee80211_sub_if_data *sdata) {}
-static inline
-void drv_remove_interface_debugfs(struct ieee80211_local *local,
-				  struct ieee80211_sub_if_data *sdata) {}
 #endif
 
 static inline __must_check
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index baaa860..ea0e4791 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -559,8 +559,6 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 				goto err_del_interface;
 		}
 
-		drv_add_interface_debugfs(local, sdata);
-
 		if (sdata->vif.type == NL80211_IFTYPE_AP) {
 			local->fif_pspoll++;
 			local->fif_probe_req++;
@@ -846,8 +844,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		 */
 		ieee80211_free_keys(sdata);
 
-		drv_remove_interface_debugfs(local, sdata);
-
 		if (going_down)
 			drv_remove_interface(local, sdata);
 	}
-- 
1.7.11.7

