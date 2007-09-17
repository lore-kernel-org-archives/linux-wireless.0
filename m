Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:56880 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbXIQNmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 09:42:22 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: add sta_notify callback
Date: Mon, 17 Sep 2007 15:42:10 +0200
Message-Id: <1190036530108-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds sta_notify callback and removes
sta_table_notification which was not used by any driver
This patch helps drivers such as iwlwifi that keeps notion of station
internaly about removal and addition of station or AP to BSS.

Currently iwlwifi have to parse internaly management frames to get this
information.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h  |   18 ++++++++++++++++--
 net/mac80211/sta_info.c |   13 ++++++-------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a2c14f9..f762a95 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -497,6 +497,20 @@ typedef enum set_key_cmd {
 } set_key_cmd;
 
 /**
+ * enum sta_notify_cmd - sta notify command
+ *
+ * Used with the sta_notify() callback in &struct ieee80211_ops, this
+ * indicates whether a sta is being removed or added
+ *
+ * @STA_NOTIFY_ADD: a station is added
+ * @STA_NOTIFY_REMOVE: a  station is removed
+ */
+typedef enum sta_notify_cmd {
+	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE
+} sta_notify_cmd;
+
+
+/**
  * struct ieee80211_hw - hardware information and state
  * TODO: move documentation into kernel-doc format
  */
@@ -748,8 +762,8 @@ struct ieee80211_ops {
 
 	/* Number of STAs in STA table notification (NULL = disabled).
 	 * Must be atomic. */
-	void (*sta_table_notification)(struct ieee80211_hw *hw,
-				       int num_sta);
+	void (*sta_notify)(struct ieee80211_hw *hw,
+				sta_notify_cmd cmd, const u8 *addr);
 
 	/* Handle ERP IE change notifications. Must be atomic. */
 	void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c17172a..892e0d5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -158,9 +158,9 @@ struct sta_info * sta_info_add(struct ieee80211_local *local,
 	list_add(&sta->list, &local->sta_list);
 	local->num_sta++;
 	sta_info_hash_add(local, sta);
-	if (local->ops->sta_table_notification)
-		local->ops->sta_table_notification(local_to_hw(local),
-						  local->num_sta);
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(local_to_hw(local),
+					STA_NOTIFY_ADD, addr);
 	write_unlock_bh(&local->sta_lock);
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -197,10 +197,6 @@ void sta_info_remove(struct sta_info *sta)
 	}
 	local->num_sta--;
 	sta_info_remove_aid_ptr(sta);
-
-	if (local->ops->sta_table_notification)
-		local->ops->sta_table_notification(local_to_hw(local),
-						   local->num_sta);
 }
 
 void sta_info_free(struct sta_info *sta)
@@ -230,6 +226,9 @@ void sta_info_free(struct sta_info *sta)
 	ieee80211_key_free(sta->key);
 	sta->key = NULL;
 
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(local_to_hw(local),
+					STA_NOTIFY_ADD, sta->addr);
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
 
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
