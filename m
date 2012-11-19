Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:50933
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750963Ab2KSFtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 00:49:00 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: Add debugfs callbacks for station addition/removal
Date: Mon, 19 Nov 2012 11:18:36 +0530
Message-Id: <1353304116-7124-1-git-send-email-sujith@msujith.org> (sfid-20121119_064908_778391_F225FDAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Provide drivers with hooks to create debugfs files when
a new station is added. This would help drivers to take
advantage of mac80211's station list infrastructure and not maintain
tedious station management code internally.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 include/net/mac80211.h     | 18 ++++++++++++++++++
 net/mac80211/debugfs_sta.c | 12 ++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a789dd1..f697b28 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2192,6 +2192,14 @@ enum ieee80211_rate_control_changed {
  * @sta_remove: Notifies low level driver about removal of an associated
  *	station, AP, IBSS/WDS/mesh peer etc. This callback can sleep.
  *
+ * @sta_add_debugfs: Drivers can use this callback to add debugfs files
+ *	when a station is added to mac80211's station list. This callback
+ *	and @sta_remove_debugfs should be within a CONFIG_MAC80211_DEBUGFS
+ *	conditional. This callback can sleep.
+ *
+ * @sta_remove_debugfs: Remove the debugfs files which were added using
+ *	@sta_add_debugfs. This callback can sleep.
+ *
  * @sta_notify: Notifies low level driver about power state transition of an
  *	associated station, AP,  IBSS/WDS/mesh peer etc. For a VIF operating
  *	in AP mode, this callback will not be called when the flag
@@ -2473,6 +2481,16 @@ struct ieee80211_ops {
 		       struct ieee80211_sta *sta);
 	int (*sta_remove)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta);
+#ifdef CONFIG_MAC80211_DEBUGFS
+	void (*sta_add_debugfs)(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct dentry *dir);
+	void (*sta_remove_debugfs)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta,
+				   struct dentry *dir);
+#endif
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
 	int (*sta_state)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 5ccec2c..32a45ed 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -334,6 +334,8 @@ STA_OPS(ht_capa);
 
 void ieee80211_sta_debugfs_add(struct sta_info *sta)
 {
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct dentry *stations_dir = sta->sdata->debugfs.subdir_stations;
 	u8 mac[3*ETH_ALEN];
 
@@ -379,10 +381,20 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD_COUNTER(tx_retry_failed, tx_retry_failed);
 	DEBUGFS_ADD_COUNTER(tx_retry_count, tx_retry_count);
 	DEBUGFS_ADD_COUNTER(wep_weak_iv_count, wep_weak_iv_count);
+
+	if (local->ops->sta_add_debugfs)
+		local->ops->sta_add_debugfs(&local->hw, &sdata->vif,
+					    &sta->sta, sta->debugfs.dir);
 }
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
 {
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
+	if (local->ops->sta_remove_debugfs)
+		local->ops->sta_remove_debugfs(&local->hw, &sdata->vif,
+					       &sta->sta, sta->debugfs.dir);
 	debugfs_remove_recursive(sta->debugfs.dir);
 	sta->debugfs.dir = NULL;
 }
-- 
1.8.0

