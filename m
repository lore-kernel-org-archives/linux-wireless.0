Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966113Ab2DLV6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/24] iwlwifi: move utility functions out of iwl-core.h
Date: Thu, 12 Apr 2012 14:54:18 -0700
Message-Id: <1334267661-14654-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_895169_67E6A767)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move these functions to iwl-agn.h as part of
iwl-core.h cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h  |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |   13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index a2f68d5..67d89dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -161,6 +161,13 @@ void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
 int iwl_send_statistics_request(struct iwl_priv *priv,
 				u8 flags, bool clear);
+
+static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
+			struct iwl_priv *priv, enum ieee80211_band band)
+{
+	return priv->hw->wiphy->bands[band];
+}
+
 #ifdef CONFIG_PM_SLEEP
 int iwlagn_send_patterns(struct iwl_priv *priv,
 			 struct cfg80211_wowlan *wowlan);
@@ -228,6 +235,12 @@ void iwlagn_bt_cancel_deferred_work(struct iwl_priv *priv);
 void iwlagn_bt_coex_rssi_monitor(struct iwl_priv *priv);
 void iwlagn_bt_adjust_rssi_monitor(struct iwl_priv *priv, bool rssi_ena);
 
+static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
+{
+	return cfg(priv)->bt_params &&
+	       cfg(priv)->bt_params->advanced_bt_coexist;
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 const char *iwl_get_tx_fail_reason(u32 status);
 const char *iwl_get_agg_tx_fail_reason(u16 status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index db340ce..ddbf9ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -152,19 +152,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
-
-static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
-			struct iwl_priv *priv, enum ieee80211_band band)
-{
-	return priv->hw->wiphy->bands[band];
-}
-
-static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
-{
-	return cfg(priv)->bt_params &&
-	       cfg(priv)->bt_params->advanced_bt_coexist;
-}
-
 extern bool bt_siso_mode;
 
 #endif /* __iwl_core_h__ */
-- 
1.7.0.4

