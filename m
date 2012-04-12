Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966114Ab2DLV6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/24] iwlwifi: move scan related declarations out of iwl-core.h
Date: Thu, 12 Apr 2012 14:54:19 -0700
Message-Id: <1334267661-14654-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235824_924247_5A5CBA8F)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move these as part of iwl-core.h cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h  |   24 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |   24 ------------------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 67d89dc..caef7a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -223,6 +223,30 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 void iwlagn_post_scan(struct iwl_priv *priv);
 void iwlagn_disable_roc(struct iwl_priv *priv);
 int iwl_force_rf_reset(struct iwl_priv *priv, bool external);
+void iwl_init_scan_params(struct iwl_priv *priv);
+int iwl_scan_cancel(struct iwl_priv *priv);
+void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
+void iwl_force_scan_end(struct iwl_priv *priv);
+void iwl_internal_short_hw_scan(struct iwl_priv *priv);
+void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
+void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
+void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
+int __must_check iwl_scan_initiate(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif,
+				   enum iwl_scan_type scan_type,
+				   enum ieee80211_band band);
+
+/* For faster active scanning, scan will move to the next channel if fewer than
+ * PLCP_QUIET_THRESH packets are heard on this channel within
+ * ACTIVE_QUIET_TIME after sending probe request.  This shortens the dwell
+ * time if it's a quiet channel (nothing responded to our probe, and there's
+ * no other traffic).
+ * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
+#define IWL_ACTIVE_QUIET_TIME       cpu_to_le16(10)  /* msec */
+#define IWL_PLCP_QUIET_THRESH       cpu_to_le16(1)  /* packets */
+
+#define IWL_SCAN_CHECK_WATCHDOG		(HZ * 7)
+
 
 /* bt coex */
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ddbf9ca..199a0c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -121,30 +121,6 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 /*******************************************************************************
  * Scanning
  ******************************************************************************/
-void iwl_init_scan_params(struct iwl_priv *priv);
-int iwl_scan_cancel(struct iwl_priv *priv);
-void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
-void iwl_force_scan_end(struct iwl_priv *priv);
-void iwl_internal_short_hw_scan(struct iwl_priv *priv);
-void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
-void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
-void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
-int __must_check iwl_scan_initiate(struct iwl_priv *priv,
-				   struct ieee80211_vif *vif,
-				   enum iwl_scan_type scan_type,
-				   enum ieee80211_band band);
-
-/* For faster active scanning, scan will move to the next channel if fewer than
- * PLCP_QUIET_THRESH packets are heard on this channel within
- * ACTIVE_QUIET_TIME after sending probe request.  This shortens the dwell
- * time if it's a quiet channel (nothing responded to our probe, and there's
- * no other traffic).
- * Disable "quiet" feature by setting PLCP_QUIET_THRESH to 0. */
-#define IWL_ACTIVE_QUIET_TIME       cpu_to_le16(10)  /* msec */
-#define IWL_PLCP_QUIET_THRESH       cpu_to_le16(1)  /* packets */
-
-#define IWL_SCAN_CHECK_WATCHDOG		(HZ * 7)
-
 /* traffic log definitions */
 #define IWL_TRAFFIC_ENTRIES	(256)
 #define IWL_TRAFFIC_ENTRY_SIZE  (64)
-- 
1.7.0.4

