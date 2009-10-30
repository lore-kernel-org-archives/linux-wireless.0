Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbZJ3VgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/15] iwlwifi: add wimax/wifi coexist support for 6x50 series
Date: Fri, 30 Oct 2009 14:36:18 -0700
Message-Id: <1256938578-9638-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For 6x50 series, it is wimax/wifi combo device, so driver need to enable
the wimax/wifi co-exist function and send the coexist event priority
table to uCode for operation.

The priority table will be used by uCode to determine what is the proper
action it should take when co-exist with WiMAX.
For example, when WiFi runs a scan, it must own radio exclusively, therefore
will disconnect WiMAX if WiMAX is connected.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   12 +---
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    3 +
 drivers/net/wireless/iwlwifi/iwl-commands.h |   92 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   59 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 +
 5 files changed, 158 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b8ddd70..a97d93d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -592,16 +592,6 @@ static void iwl5000_tx_queue_set_status(struct iwl_priv *priv,
 		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
 
-static int iwl5000_send_wimax_coex(struct iwl_priv *priv)
-{
-	struct iwl_wimax_coex_cmd coex_cmd;
-
-	memset(&coex_cmd, 0, sizeof(coex_cmd));
-
-	return iwl_send_cmd_pdu(priv, COEX_PRIORITY_TABLE_CMD,
-				sizeof(coex_cmd), &coex_cmd);
-}
-
 int iwl5000_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
@@ -682,7 +672,7 @@ int iwl5000_alive_notify(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 
-	iwl5000_send_wimax_coex(priv);
+	iwl_send_wimax_coex(priv);
 
 	iwl5000_set_Xtal_calib(priv);
 	iwl_send_calib_results(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a4a8b5e..70e117f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -491,6 +491,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.support_sm_ps = true,
+	.support_wimax_coexist = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -520,6 +521,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
+	.support_wimax_coexist = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -581,6 +583,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.support_sm_ps = true,
+	.support_wimax_coexist = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 43dd6af..b62c90e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3507,6 +3507,98 @@ struct iwl_led_cmd {
  * also used as potential "events" value for both
  * COEX_MEDIUM_NOTIFICATION and COEX_EVENT_CMD
  */
+
+/*
+ * COEX events entry flag masks
+ * RP - Requested Priority
+ * WP - Win Medium Priority: priority assigned when the contention has been won
+ */
+#define COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG        (0x1)
+#define COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG        (0x2)
+#define COEX_EVT_FLAG_DELAY_MEDIUM_FREE_NTFY_FLG  (0x4)
+
+#define COEX_CU_UNASSOC_IDLE_RP               4
+#define COEX_CU_UNASSOC_MANUAL_SCAN_RP        4
+#define COEX_CU_UNASSOC_AUTO_SCAN_RP          4
+#define COEX_CU_CALIBRATION_RP                4
+#define COEX_CU_PERIODIC_CALIBRATION_RP       4
+#define COEX_CU_CONNECTION_ESTAB_RP           4
+#define COEX_CU_ASSOCIATED_IDLE_RP            4
+#define COEX_CU_ASSOC_MANUAL_SCAN_RP          4
+#define COEX_CU_ASSOC_AUTO_SCAN_RP            4
+#define COEX_CU_ASSOC_ACTIVE_LEVEL_RP         4
+#define COEX_CU_RF_ON_RP                      6
+#define COEX_CU_RF_OFF_RP                     4
+#define COEX_CU_STAND_ALONE_DEBUG_RP          6
+#define COEX_CU_IPAN_ASSOC_LEVEL_RP           4
+#define COEX_CU_RSRVD1_RP                     4
+#define COEX_CU_RSRVD2_RP                     4
+
+#define COEX_CU_UNASSOC_IDLE_WP               3
+#define COEX_CU_UNASSOC_MANUAL_SCAN_WP        3
+#define COEX_CU_UNASSOC_AUTO_SCAN_WP          3
+#define COEX_CU_CALIBRATION_WP                3
+#define COEX_CU_PERIODIC_CALIBRATION_WP       3
+#define COEX_CU_CONNECTION_ESTAB_WP           3
+#define COEX_CU_ASSOCIATED_IDLE_WP            3
+#define COEX_CU_ASSOC_MANUAL_SCAN_WP          3
+#define COEX_CU_ASSOC_AUTO_SCAN_WP            3
+#define COEX_CU_ASSOC_ACTIVE_LEVEL_WP         3
+#define COEX_CU_RF_ON_WP                      3
+#define COEX_CU_RF_OFF_WP                     3
+#define COEX_CU_STAND_ALONE_DEBUG_WP          6
+#define COEX_CU_IPAN_ASSOC_LEVEL_WP           3
+#define COEX_CU_RSRVD1_WP                     3
+#define COEX_CU_RSRVD2_WP                     3
+
+#define COEX_UNASSOC_IDLE_FLAGS                     0
+#define COEX_UNASSOC_MANUAL_SCAN_FLAGS		\
+	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG |	\
+	COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG)
+#define COEX_UNASSOC_AUTO_SCAN_FLAGS		\
+	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG |	\
+	COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG)
+#define COEX_CALIBRATION_FLAGS			\
+	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG |	\
+	COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG)
+#define COEX_PERIODIC_CALIBRATION_FLAGS             0
+/*
+ * COEX_CONNECTION_ESTAB:
+ * we need DELAY_MEDIUM_FREE_NTFY to let WiMAX disconnect from network.
+ */
+#define COEX_CONNECTION_ESTAB_FLAGS		\
+	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG |	\
+	COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG |	\
+	COEX_EVT_FLAG_DELAY_MEDIUM_FREE_NTFY_FLG)
+#define COEX_ASSOCIATED_IDLE_FLAGS                  0
+#define COEX_ASSOC_MANUAL_SCAN_FLAGS		\
+	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG |	\
+	COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG)
+#define COEX_ASSOC_AUTO_SCAN_FLAGS		\
+	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG |	\
+	 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG)
+#define COEX_ASSOC_ACTIVE_LEVEL_FLAGS               0
+#define COEX_RF_ON_FLAGS                            0
+#define COEX_RF_OFF_FLAGS                           0
+#define COEX_STAND_ALONE_DEBUG_FLAGS		\
+	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG |	\
+	 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG)
+#define COEX_IPAN_ASSOC_LEVEL_FLAGS		\
+	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG |	\
+	 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG |	\
+	 COEX_EVT_FLAG_DELAY_MEDIUM_FREE_NTFY_FLG)
+#define COEX_RSRVD1_FLAGS                           0
+#define COEX_RSRVD2_FLAGS                           0
+/*
+ * COEX_CU_RF_ON is the event wrapping all radio ownership.
+ * We need DELAY_MEDIUM_FREE_NTFY to let WiMAX disconnect from network.
+ */
+#define COEX_CU_RF_ON_FLAGS			\
+	(COEX_EVT_FLAG_MEDIUM_FREE_NTFY_FLG |	\
+	 COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_FLG |	\
+	 COEX_EVT_FLAG_DELAY_MEDIUM_FREE_NTFY_FLG)
+
+
 enum {
 	/* un-association part */
 	COEX_UNASSOC_IDLE		= 0,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6a9d593..112181b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -47,6 +47,37 @@ MODULE_VERSION(IWLWIFI_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
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
 #define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
 				    IWL_RATE_SISO_##s##M_PLCP, \
@@ -2866,6 +2897,34 @@ void iwl_free_txq_mem(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_free_txq_mem);
 
+int iwl_send_wimax_coex(struct iwl_priv *priv)
+{
+	struct iwl_wimax_coex_cmd uninitialized_var(coex_cmd);
+
+	if (priv->cfg->support_wimax_coexist) {
+		/* UnMask wake up src at associated sleep */
+		coex_cmd.flags |= COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
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
+EXPORT_SYMBOL(iwl_send_wimax_coex);
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 
 #define IWL_TRAFFIC_DUMP_SIZE	(IWL_TRAFFIC_ENTRY_SIZE * IWL_TRAFFIC_ENTRIES)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d2e47da..9574d8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -229,6 +229,7 @@ struct iwl_mod_params {
  * @adv_thermal_throttle: support advance thermal throttle
  * @support_ct_kill_exit: support ct kill exit condition
  * @support_sm_ps: support spatial multiplexing power save
+ * @support_wimax_coexist: support wimax/wifi co-exist
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -285,6 +286,7 @@ struct iwl_cfg {
 	bool adv_thermal_throttle;
 	bool support_ct_kill_exit;
 	bool support_sm_ps;
+	const bool support_wimax_coexist;
 };
 
 /***************************
@@ -340,6 +342,7 @@ int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
 void iwlcore_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 				__le32 *tx_flags);
+int iwl_send_wimax_coex(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
-- 
1.5.6.3

