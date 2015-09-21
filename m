Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45739 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756350AbbIUU7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:49 +0300
Message-Id: <1442869141-31637-9-git-send-email-luca@coelho.fi> (sfid-20150921_230046_122372_517BDCEB)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 09/21] iwlwifi: mvm: remove SCD_QUEUE_CONFIG TLV flag
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

We don't support firmwares that don't use the new API.
This also allows to use all the SCD queues, so increase
the reported number of queues to 31.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c    |  2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c    |  2 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |  3 ---
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |  5 -----
 drivers/net/wireless/iwlwifi/mvm/utils.c   | 11 -----------
 5 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 22c2430..5b25f36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -113,7 +113,7 @@
 
 static const struct iwl_base_params iwl7000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_7000,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_queues = 31,
 	.pll_cfg_val = 0,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 6efef46..0116e5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -107,7 +107,7 @@
 
 static const struct iwl_base_params iwl8000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_8000,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_queues = 31,
 	.pll_cfg_val = 0,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 84653e3..483b1274 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -250,8 +250,6 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  * IWL_UCODE_TLV_API_HDC_PHASE_0: ucode supports finer configuration of LTR
  * @IWL_UCODE_TLV_API_TX_POWER_DEV: new API for tx power.
  * @IWL_UCODE_TLV_API_WIDE_CMD_HDR: ucode supports wide command header
- * @IWL_UCODE_TLV_API_SCD_CFG: This firmware can configure the scheduler
- *	through the dedicated host command.
  * @IWL_UCODE_TLV_API_SINGLE_SCAN_EBS: EBS is supported for single scans too.
  * @IWL_UCODE_TLV_API_ASYNC_DTM: Async temperature notifications are supported.
  * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
@@ -269,7 +267,6 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_HDC_PHASE_0		= (__force iwl_ucode_tlv_api_t)10,
 	IWL_UCODE_TLV_API_TX_POWER_DEV		= (__force iwl_ucode_tlv_api_t)11,
 	IWL_UCODE_TLV_API_WIDE_CMD_HDR		= (__force iwl_ucode_tlv_api_t)14,
-	IWL_UCODE_TLV_API_SCD_CFG		= (__force iwl_ucode_tlv_api_t)15,
 	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= (__force iwl_ucode_tlv_api_t)16,
 	IWL_UCODE_TLV_API_ASYNC_DTM		= (__force iwl_ucode_tlv_api_t)17,
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= (__force iwl_ucode_tlv_api_t)18,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ed9b0cc..cf1f514 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -937,11 +937,6 @@ static inline bool iwl_mvm_is_wifi_mcc_supported(struct iwl_mvm *mvm)
 			   IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC);
 }
 
-static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
-{
-	return fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_SCD_CFG);
-}
-
 static inline bool iwl_mvm_bt_is_plcr_supported(struct iwl_mvm *mvm)
 {
 	return fw_has_capa(&mvm->fw->ucode_capa,
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index a7d4342..06cba97 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -672,12 +672,6 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, u16 ssn,
 		.tid = cfg->tid,
 	};
 
-	if (!iwl_mvm_is_scd_cfg_supported(mvm)) {
-		iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, cfg,
-					 wdg_timeout);
-		return;
-	}
-
 	iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL, wdg_timeout);
 	WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd), &cmd),
 	     "Failed to configure queue %d on FIFO %d\n", queue, cfg->fifo);
@@ -691,11 +685,6 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, u8 flags)
 	};
 	int ret;
 
-	if (!iwl_mvm_is_scd_cfg_supported(mvm)) {
-		iwl_trans_txq_disable(mvm->trans, queue, true);
-		return;
-	}
-
 	iwl_trans_txq_disable(mvm->trans, queue, false);
 	ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
 				   sizeof(cmd), &cmd);
-- 
2.5.1

