Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbbECTdN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/42] iwlwifi: mvm: remove deprecated command IDs
Date: Sun,  3 May 2015 22:31:46 +0300
Message-Id: <1430681513-7838-35-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213344_681935_1533566B)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h |  7 -------
 drivers/net/wireless/iwlwifi/mvm/fw.c     | 15 ---------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |  4 ----
 drivers/net/wireless/iwlwifi/mvm/ops.c    |  3 ---
 4 files changed, 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 01b1da6..56db2ba 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -147,13 +147,6 @@ enum {
 
 	LQ_CMD = 0x4e,
 
-	/* Calibration */
-	TEMPERATURE_NOTIFICATION = 0x62,
-	CALIBRATION_CFG_CMD = 0x65,
-	CALIBRATION_RES_NOTIFICATION = 0x66,
-	CALIBRATION_COMPLETE_NOTIFICATION = 0x67,
-	RADIO_VERSION_NOTIFICATION = 0x68,
-
 	/* Scan offload */
 	SCAN_OFFLOAD_REQUEST_CMD = 0x51,
 	SCAN_OFFLOAD_ABORT_CMD = 0x52,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index df86963..0601445 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -832,21 +832,6 @@ int iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
-int iwl_mvm_rx_radio_ver(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			 struct iwl_device_cmd *cmd)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_radio_version_notif *radio_version = (void *)pkt->data;
-
-	/* TODO: what to do with that? */
-	IWL_DEBUG_INFO(mvm,
-		       "Radio version: flavor: 0x%08x, step 0x%08x, dash 0x%08x\n",
-		       le32_to_cpu(radio_version->radio_flavor),
-		       le32_to_cpu(radio_version->radio_step),
-		       le32_to_cpu(radio_version->radio_dash));
-	return 0;
-}
-
 int iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm,
 			    struct iwl_rx_cmd_buffer *rxb,
 			    struct iwl_device_cmd *cmd)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 7679ad6..e6169c6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1100,8 +1100,6 @@ int iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		      struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_radio_ver(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			 struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 				  struct iwl_rx_cmd_buffer *rxb,
 				  struct iwl_device_cmd *cmd);
@@ -1110,8 +1108,6 @@ int iwl_mvm_rx_fw_error(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 int iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
 				struct iwl_rx_cmd_buffer *rxb,
 				struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_radio_ver(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			 struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			    struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_shared_mem_cfg_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 2ea0123..02028bc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -246,7 +246,6 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(SCAN_COMPLETE_UMAC, iwl_mvm_rx_umac_scan_complete_notif,
 		   true),
 
-	RX_HANDLER(RADIO_VERSION_NOTIFICATION, iwl_mvm_rx_radio_ver, false),
 	RX_HANDLER(CARD_STATE_NOTIFICATION, iwl_mvm_rx_card_state_notif, false),
 
 	RX_HANDLER(MISSED_BEACONS_NOTIFICATION, iwl_mvm_rx_missed_beacons_notif,
@@ -280,7 +279,6 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(BINDING_CONTEXT_CMD),
 	CMD(TIME_QUOTA_CMD),
 	CMD(NON_QOS_TX_COUNTER_CMD),
-	CMD(RADIO_VERSION_NOTIFICATION),
 	CMD(SCAN_REQUEST_CMD),
 	CMD(SCAN_ABORT_CMD),
 	CMD(SCAN_START_NOTIFICATION),
@@ -290,7 +288,6 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(PHY_CONFIGURATION_CMD),
 	CMD(CALIB_RES_NOTIF_PHY_DB),
 	CMD(SET_CALIB_DEFAULT_CMD),
-	CMD(CALIBRATION_COMPLETE_NOTIFICATION),
 	CMD(ADD_STA_KEY),
 	CMD(ADD_STA),
 	CMD(REMOVE_STA),
-- 
2.1.0

