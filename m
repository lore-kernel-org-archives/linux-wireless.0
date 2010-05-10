Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab0EJW2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/47] iwlwifi: wimax co-exist code clean up
Date: Mon, 10 May 2010 15:27:41 -0700
Message-Id: <1273530498-11876-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

wifi/wimax co-exist command is part of _agn device configuration
sequence; move it to iwl-agn-ucode.c which is more appropriate place for the
function.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   60 +++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c      |   59 -------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h      |    1 -
 3 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index ae476c2..c3e3283 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -52,6 +52,37 @@ static const s8 iwlagn_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_UNUSED,
 };
 
+static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
+	{COEX_CU_UNASSOC_IDLE_RP, COEX_CU_UNASSOC_IDLE_WP,
+	 0, COEX_UNASSOC_IDLE_FLAGS},
+	{COEX_CU_UNASSOC_MANUAL_SCAN_RP, COEX_CU_UNASSOC_MANUAL_SCAN_WP,
+	 0, COEX_UNASSOC_MANUAL_SCAN_FLAGS},
+	{COEX_CU_UNASSOC_AUTO_SCAN_RP, COEX_CU_UNASSOC_AUTO_SCAN_WP,
+	 0, COEX_UNASSOC_AUTO_SCAN_FLAGS},
+	{COEX_CU_CALIBRATION_RP, COEX_CU_CALIBRATION_WP,
+	 0, COEX_CALIBRATION_FLAGS},
+	{COEX_CU_PERIODIC_CALIBRATION_RP, COEX_CU_PERIODIC_CALIBRATION_WP,
+	 0, COEX_PERIODIC_CALIBRATION_FLAGS},
+	{COEX_CU_CONNECTION_ESTAB_RP, COEX_CU_CONNECTION_ESTAB_WP,
+	 0, COEX_CONNECTION_ESTAB_FLAGS},
+	{COEX_CU_ASSOCIATED_IDLE_RP, COEX_CU_ASSOCIATED_IDLE_WP,
+	 0, COEX_ASSOCIATED_IDLE_FLAGS},
+	{COEX_CU_ASSOC_MANUAL_SCAN_RP, COEX_CU_ASSOC_MANUAL_SCAN_WP,
+	 0, COEX_ASSOC_MANUAL_SCAN_FLAGS},
+	{COEX_CU_ASSOC_AUTO_SCAN_RP, COEX_CU_ASSOC_AUTO_SCAN_WP,
+	 0, COEX_ASSOC_AUTO_SCAN_FLAGS},
+	{COEX_CU_ASSOC_ACTIVE_LEVEL_RP, COEX_CU_ASSOC_ACTIVE_LEVEL_WP,
+	 0, COEX_ASSOC_ACTIVE_LEVEL_FLAGS},
+	{COEX_CU_RF_ON_RP, COEX_CU_RF_ON_WP, 0, COEX_CU_RF_ON_FLAGS},
+	{COEX_CU_RF_OFF_RP, COEX_CU_RF_OFF_WP, 0, COEX_RF_OFF_FLAGS},
+	{COEX_CU_STAND_ALONE_DEBUG_RP, COEX_CU_STAND_ALONE_DEBUG_WP,
+	 0, COEX_STAND_ALONE_DEBUG_FLAGS},
+	{COEX_CU_IPAN_ASSOC_LEVEL_RP, COEX_CU_IPAN_ASSOC_LEVEL_WP,
+	 0, COEX_IPAN_ASSOC_LEVEL_FLAGS},
+	{COEX_CU_RSRVD1_RP, COEX_CU_RSRVD1_WP, 0, COEX_RSRVD1_FLAGS},
+	{COEX_CU_RSRVD2_RP, COEX_CU_RSRVD2_WP, 0, COEX_RSRVD2_FLAGS}
+};
+
 /*
  * ucode
  */
@@ -320,6 +351,33 @@ restart:
 	queue_work(priv->workqueue, &priv->restart);
 }
 
+static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
+{
+	struct iwl_wimax_coex_cmd coex_cmd;
+
+	if (priv->cfg->support_wimax_coexist) {
+		/* UnMask wake up src at associated sleep */
+		coex_cmd.flags = COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
+
+		/* UnMask wake up src at unassociated sleep */
+		coex_cmd.flags |= COEX_FLAGS_UNASSOC_WA_UNMASK_MSK;
+		memcpy(coex_cmd.sta_prio, cu_priorities,
+			sizeof(struct iwl_wimax_coex_event_entry) *
+			 COEX_NUM_OF_EVENTS);
+
+		/* enabling the coexistence feature */
+		coex_cmd.flags |= COEX_FLAGS_COEX_ENABLE_MSK;
+
+		/* enabling the priorities tables */
+		coex_cmd.flags |= COEX_FLAGS_STA_TABLE_VALID_MSK;
+	} else {
+		/* coexistence is disabled */
+		memset(&coex_cmd, 0, sizeof(coex_cmd));
+	}
+	return iwl_send_cmd_pdu(priv, COEX_PRIORITY_TABLE_CMD,
+				sizeof(coex_cmd), &coex_cmd);
+}
+
 int iwlagn_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
@@ -407,7 +465,7 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl_send_wimax_coex(priv);
+	iwlagn_send_wimax_coex(priv);
 
 	iwlagn_set_Xtal_calib(priv);
 	iwl_send_calib_results(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d8ee528..0c3b984 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -67,37 +67,6 @@ static bool bt_coex_active = true;
 module_param(bt_coex_active, bool, S_IRUGO);
 MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist");
 
-static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
-	{COEX_CU_UNASSOC_IDLE_RP, COEX_CU_UNASSOC_IDLE_WP,
-	 0, COEX_UNASSOC_IDLE_FLAGS},
-	{COEX_CU_UNASSOC_MANUAL_SCAN_RP, COEX_CU_UNASSOC_MANUAL_SCAN_WP,
-	 0, COEX_UNASSOC_MANUAL_SCAN_FLAGS},
-	{COEX_CU_UNASSOC_AUTO_SCAN_RP, COEX_CU_UNASSOC_AUTO_SCAN_WP,
-	 0, COEX_UNASSOC_AUTO_SCAN_FLAGS},
-	{COEX_CU_CALIBRATION_RP, COEX_CU_CALIBRATION_WP,
-	 0, COEX_CALIBRATION_FLAGS},
-	{COEX_CU_PERIODIC_CALIBRATION_RP, COEX_CU_PERIODIC_CALIBRATION_WP,
-	 0, COEX_PERIODIC_CALIBRATION_FLAGS},
-	{COEX_CU_CONNECTION_ESTAB_RP, COEX_CU_CONNECTION_ESTAB_WP,
-	 0, COEX_CONNECTION_ESTAB_FLAGS},
-	{COEX_CU_ASSOCIATED_IDLE_RP, COEX_CU_ASSOCIATED_IDLE_WP,
-	 0, COEX_ASSOCIATED_IDLE_FLAGS},
-	{COEX_CU_ASSOC_MANUAL_SCAN_RP, COEX_CU_ASSOC_MANUAL_SCAN_WP,
-	 0, COEX_ASSOC_MANUAL_SCAN_FLAGS},
-	{COEX_CU_ASSOC_AUTO_SCAN_RP, COEX_CU_ASSOC_AUTO_SCAN_WP,
-	 0, COEX_ASSOC_AUTO_SCAN_FLAGS},
-	{COEX_CU_ASSOC_ACTIVE_LEVEL_RP, COEX_CU_ASSOC_ACTIVE_LEVEL_WP,
-	 0, COEX_ASSOC_ACTIVE_LEVEL_FLAGS},
-	{COEX_CU_RF_ON_RP, COEX_CU_RF_ON_WP, 0, COEX_CU_RF_ON_FLAGS},
-	{COEX_CU_RF_OFF_RP, COEX_CU_RF_OFF_WP, 0, COEX_RF_OFF_FLAGS},
-	{COEX_CU_STAND_ALONE_DEBUG_RP, COEX_CU_STAND_ALONE_DEBUG_WP,
-	 0, COEX_STAND_ALONE_DEBUG_FLAGS},
-	{COEX_CU_IPAN_ASSOC_LEVEL_RP, COEX_CU_IPAN_ASSOC_LEVEL_WP,
-	 0, COEX_IPAN_ASSOC_LEVEL_FLAGS},
-	{COEX_CU_RSRVD1_RP, COEX_CU_RSRVD1_WP, 0, COEX_RSRVD1_FLAGS},
-	{COEX_CU_RSRVD2_RP, COEX_CU_RSRVD2_WP, 0, COEX_RSRVD2_FLAGS}
-};
-
 #define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
 				    IWL_RATE_SISO_##s##M_PLCP, \
@@ -2340,34 +2309,6 @@ void iwl_free_txq_mem(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_free_txq_mem);
 
-int iwl_send_wimax_coex(struct iwl_priv *priv)
-{
-	struct iwl_wimax_coex_cmd coex_cmd;
-
-	if (priv->cfg->support_wimax_coexist) {
-		/* UnMask wake up src at associated sleep */
-		coex_cmd.flags = COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
-
-		/* UnMask wake up src at unassociated sleep */
-		coex_cmd.flags |= COEX_FLAGS_UNASSOC_WA_UNMASK_MSK;
-		memcpy(coex_cmd.sta_prio, cu_priorities,
-			sizeof(struct iwl_wimax_coex_event_entry) *
-			 COEX_NUM_OF_EVENTS);
-
-		/* enabling the coexistence feature */
-		coex_cmd.flags |= COEX_FLAGS_COEX_ENABLE_MSK;
-
-		/* enabling the priorities tables */
-		coex_cmd.flags |= COEX_FLAGS_STA_TABLE_VALID_MSK;
-	} else {
-		/* coexistence is disabled */
-		memset(&coex_cmd, 0, sizeof(coex_cmd));
-	}
-	return iwl_send_cmd_pdu(priv, COEX_PRIORITY_TABLE_CMD,
-				sizeof(coex_cmd), &coex_cmd);
-}
-EXPORT_SYMBOL(iwl_send_wimax_coex);
-
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 
 #define IWL_TRAFFIC_DUMP_SIZE	(IWL_TRAFFIC_ENTRY_SIZE * IWL_TRAFFIC_ENTRIES)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 88c6412..f66c1c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -373,7 +373,6 @@ int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
 void iwlcore_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 				__le32 *tx_flags);
-int iwl_send_wimax_coex(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
-- 
1.6.3.3

