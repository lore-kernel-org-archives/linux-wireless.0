Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964952Ab2CEUiD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 01/33] iwlwifi: move iwl_clear_driver_stations to user
Date: Mon,  5 Mar 2012 11:24:19 -0800
Message-Id: <1330975491-19680-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213918_168797_556E4270)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's only one place using this function, so
move it where it's needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   35 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h |   35 --------------------------------
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e0fef9f..a7f3a70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -738,6 +738,41 @@ int iwl_alive_start(struct iwl_priv *priv)
 	return iwl_power_update_mode(priv, true);
 }
 
+/**
+ * iwl_clear_driver_stations - clear knowledge of all stations from driver
+ * @priv: iwl priv struct
+ *
+ * This is called during iwl_down() to make sure that in the case
+ * we're coming there from a hardware restart mac80211 will be
+ * able to reconfigure stations -- if we're getting there in the
+ * normal down flow then the stations will already be cleared.
+ */
+static void iwl_clear_driver_stations(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	struct iwl_rxon_context *ctx;
+
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	memset(priv->stations, 0, sizeof(priv->stations));
+	priv->num_stations = 0;
+
+	priv->ucode_key_table = 0;
+
+	for_each_context(priv, ctx) {
+		/*
+		 * Remove all key information that is not stored as part
+		 * of station information since mac80211 may not have had
+		 * a chance to remove all the keys. When device is
+		 * reconfigured by mac80211 after an error all keys will
+		 * be reconfigured.
+		 */
+		memset(ctx->wep_keys, 0, sizeof(ctx->wep_keys));
+		ctx->key_mapping_keys = 0;
+	}
+
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+}
+
 void iwl_down(struct iwl_priv *priv)
 {
 	int exit_pending;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index cb484e2..ef0cdf5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -232,41 +232,6 @@ int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 			       struct iwl_device_cmd *cmd);
 
 
-/**
- * iwl_clear_driver_stations - clear knowledge of all stations from driver
- * @priv: iwl priv struct
- *
- * This is called during iwl_down() to make sure that in the case
- * we're coming there from a hardware restart mac80211 will be
- * able to reconfigure stations -- if we're getting there in the
- * normal down flow then the stations will already be cleared.
- */
-static inline void iwl_clear_driver_stations(struct iwl_priv *priv)
-{
-	unsigned long flags;
-	struct iwl_rxon_context *ctx;
-
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	memset(priv->stations, 0, sizeof(priv->stations));
-	priv->num_stations = 0;
-
-	priv->ucode_key_table = 0;
-
-	for_each_context(priv, ctx) {
-		/*
-		 * Remove all key information that is not stored as part
-		 * of station information since mac80211 may not have had
-		 * a chance to remove all the keys. When device is
-		 * reconfigured by mac80211 after an error all keys will
-		 * be reconfigured.
-		 */
-		memset(ctx->wep_keys, 0, sizeof(ctx->wep_keys));
-		ctx->key_mapping_keys = 0;
-	}
-
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
-}
-
 static inline int iwl_sta_id(struct ieee80211_sta *sta)
 {
 	if (WARN_ON(!sta))
-- 
1.7.0.4

