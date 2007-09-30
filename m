Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22358 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323AbXI3Lwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 07:52:46 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1 V2] mac80211: add sta_notify callback
Date: Sun, 30 Sep 2007 13:52:37 +0200
Message-Id: <1191153157853-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds sta_notify callback and removes sta_table_notification
which was not used by any driver.
sta_notify() is essential for drivers that keeps notion of station
internally and need to be notified about removal or addition of a station
to the (I)BSS or assocation to an AP.

This version adds interface id to the parameter list
as suggested by Johannes Berg

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h  |   20 ++++++++++++++++----
 net/mac80211/sta_info.c |   13 +++++++------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 06f9aad..d0e091c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -613,6 +613,18 @@ enum set_key_cmd {
 	SET_KEY, DISABLE_KEY,
 };
 
+/**
+ * enum sta_notify_cmd - sta notify command
+ *
+ * Used with the sta_notify() callback in &struct ieee80211_ops, this
+ * indicates addition and removal of a station to station table
+ *
+ * @STA_NOTIFY_ADD: a station was added to the station table
+ * @STA_NOTIFY_REMOVE: a station being removed from the station table
+ */
+enum sta_notify_cmd {
+	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE
+};
 
 /**
  * enum ieee80211_hw_flags - hardware flags
@@ -957,8 +969,8 @@ enum ieee80211_erp_change_flags {
  *
  * @set_retry_limit: Configuration of retry limits (if device needs it)
  *
- * @sta_table_notification: Number of STAs in STA table notification. Must
- *	be atomic.
+ * @sta_notify: Notifies low level driver about addition or removal
+ *	of assocaited station or AP.
  *
  * @erp_ie_changed: Handle ERP IE change notifications. Must be atomic.
  *
@@ -1025,8 +1037,8 @@ struct ieee80211_ops {
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_retry_limit)(struct ieee80211_hw *hw,
 			       u32 short_retry, u32 long_retr);
-	void (*sta_table_notification)(struct ieee80211_hw *hw,
-				       int num_sta);
+	void (*sta_notify)(struct ieee80211_hw *hw, int if_id,
+			enum sta_notify_cmd, const u8 *addr);
 	void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
 			       int cts_protection, int preamble);
 	int (*conf_tx)(struct ieee80211_hw *hw, int queue,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index cacceff..4ed1b60 100644
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
+		local->ops->sta_notify(local_to_hw(local), dev->ifindex,
+					STA_NOTIFY_ADD, addr);
 	write_unlock_bh(&local->sta_lock);
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -198,9 +198,6 @@ void sta_info_remove(struct sta_info *sta)
 	local->num_sta--;
 	sta_info_remove_aid_ptr(sta);
 
-	if (local->ops->sta_table_notification)
-		local->ops->sta_table_notification(local_to_hw(local),
-						   local->num_sta);
 }
 
 void sta_info_free(struct sta_info *sta)
@@ -230,6 +227,10 @@ void sta_info_free(struct sta_info *sta)
 	ieee80211_key_free(sta->key);
 	sta->key = NULL;
 
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(local_to_hw(local), sta->dev->ifindex,
+					STA_NOTIFY_REMOVE, sta->addr);
+
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
