Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab0FUSGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:06:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/9] iwlwifi: use sync commands for keys
Date: Mon, 21 Jun 2010 11:06:33 -0700
Message-Id: <1277143600-32554-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
References: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Key management can use sync commands
instead of asynchronous ones to have
better error checking.

Also add checks that the commands all
should have the mutex held.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index a62a032..d39bfac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -834,7 +834,9 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
-	int ret;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
 
 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
 
@@ -874,11 +876,10 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
-	ret = iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return ret;
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 
 static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
@@ -887,7 +888,9 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
-	int ret;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
 
 	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
@@ -922,11 +925,10 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
-	ret = iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return ret;
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 
 static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
@@ -1016,9 +1018,11 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 				u8 sta_id)
 {
 	unsigned long flags;
-	int ret = 0;
 	u16 key_flags;
 	u8 keyidx;
+	struct iwl_addsta_cmd sta_cmd;
+
+	lockdep_assert_held(&priv->mutex);
 
 	priv->key_mapping_key--;
 
@@ -1065,9 +1069,10 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		spin_unlock_irqrestore(&priv->sta_lock, flags);
 		return 0;
 	}
-	ret =  iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
-	return ret;
+
+	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 EXPORT_SYMBOL(iwl_remove_dynamic_key);
 
@@ -1076,6 +1081,8 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 {
 	int ret;
 
+	lockdep_assert_held(&priv->mutex);
+
 	priv->key_mapping_key++;
 	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
 
-- 
1.7.0.4

