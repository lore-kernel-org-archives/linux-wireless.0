Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45743 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756677AbbIUU7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:50 +0300
Message-Id: <1442869141-31637-10-git-send-email-luca@coelho.fi> (sfid-20150921_230123_545396_ED1B0D20)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 10/21] iwlwifi: mvm: remove IWL_UCODE_TLV_API_HDC_PHASE_0 TLV flag
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firwmares support the new API.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |  2 --
 drivers/net/wireless/iwlwifi/iwl-io.c      |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c      | 16 ----------------
 3 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 483b1274..55ff72e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -247,7 +247,6 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
- * IWL_UCODE_TLV_API_HDC_PHASE_0: ucode supports finer configuration of LTR
  * @IWL_UCODE_TLV_API_TX_POWER_DEV: new API for tx power.
  * @IWL_UCODE_TLV_API_WIDE_CMD_HDR: ucode supports wide command header
  * @IWL_UCODE_TLV_API_SINGLE_SCAN_EBS: EBS is supported for single scans too.
@@ -264,7 +263,6 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = (__force iwl_ucode_tlv_api_t)3,
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= (__force iwl_ucode_tlv_api_t)8,
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
-	IWL_UCODE_TLV_API_HDC_PHASE_0		= (__force iwl_ucode_tlv_api_t)10,
 	IWL_UCODE_TLV_API_TX_POWER_DEV		= (__force iwl_ucode_tlv_api_t)11,
 	IWL_UCODE_TLV_API_WIDE_CMD_HDR		= (__force iwl_ucode_tlv_api_t)14,
 	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= (__force iwl_ucode_tlv_api_t)16,
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 3c263a1..0bd9d4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -53,6 +53,7 @@ IWL_EXPORT_SYMBOL(iwl_write32);
 u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
 {
 	u32 val = iwl_trans_read32(trans, ofs);
+
 	trace_iwlwifi_dev_ioread32(trans->dev, ofs, val);
 	return val;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 4a0ce83..248b025 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -940,19 +940,6 @@ int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 conf_id)
 	return ret;
 }
 
-static int iwl_mvm_config_ltr_v1(struct iwl_mvm *mvm)
-{
-	struct iwl_ltr_config_cmd_v1 cmd_v1 = {
-		.flags = cpu_to_le32(LTR_CFG_FLAG_FEATURE_ENABLE),
-	};
-
-	if (!mvm->trans->ltr_enabled)
-		return 0;
-
-	return iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, 0,
-				    sizeof(cmd_v1), &cmd_v1);
-}
-
 static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
 {
 	struct iwl_ltr_config_cmd cmd = {
@@ -962,9 +949,6 @@ static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
 	if (!mvm->trans->ltr_enabled)
 		return 0;
 
-	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_HDC_PHASE_0))
-		return iwl_mvm_config_ltr_v1(mvm);
-
 	return iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, 0,
 				    sizeof(cmd), &cmd);
 }
-- 
2.5.1

