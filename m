Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45773 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932229AbbIUVBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:51 +0300
Message-Id: <1442869141-31637-11-git-send-email-luca@coelho.fi> (sfid-20150921_230136_343119_1FA44B2C)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 11/21] iwlwifi: mvm: remove IWL_UCODE_TLV_API_TX_POWER_DEV TLV flag
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares use the new API.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h  |  2 --
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 17 -----------------
 2 files changed, 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 55ff72e..7af0ec2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -247,7 +247,6 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
- * @IWL_UCODE_TLV_API_TX_POWER_DEV: new API for tx power.
  * @IWL_UCODE_TLV_API_WIDE_CMD_HDR: ucode supports wide command header
  * @IWL_UCODE_TLV_API_SINGLE_SCAN_EBS: EBS is supported for single scans too.
  * @IWL_UCODE_TLV_API_ASYNC_DTM: Async temperature notifications are supported.
@@ -263,7 +262,6 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = (__force iwl_ucode_tlv_api_t)3,
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= (__force iwl_ucode_tlv_api_t)8,
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
-	IWL_UCODE_TLV_API_TX_POWER_DEV		= (__force iwl_ucode_tlv_api_t)11,
 	IWL_UCODE_TLV_API_WIDE_CMD_HDR		= (__force iwl_ucode_tlv_api_t)14,
 	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= (__force iwl_ucode_tlv_api_t)16,
 	IWL_UCODE_TLV_API_ASYNC_DTM		= (__force iwl_ucode_tlv_api_t)17,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f9f88e9..4c497fe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1577,20 +1577,6 @@ static struct iwl_mvm_phy_ctxt *iwl_mvm_get_free_phy_ctxt(struct iwl_mvm *mvm)
 	return NULL;
 }
 
-static int iwl_mvm_set_tx_power_old(struct iwl_mvm *mvm,
-				    struct ieee80211_vif *vif, s8 tx_power)
-{
-	/* FW is in charge of regulatory enforcement */
-	struct iwl_reduce_tx_power_cmd reduce_txpwr_cmd = {
-		.mac_context_id = iwl_mvm_vif_from_mac80211(vif)->id,
-		.pwr_restriction = cpu_to_le16(tx_power),
-	};
-
-	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0,
-				    sizeof(reduce_txpwr_cmd),
-				    &reduce_txpwr_cmd);
-}
-
 static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				s16 tx_power)
 {
@@ -1602,9 +1588,6 @@ static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	};
 	int len = sizeof(cmd);
 
-	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_TX_POWER_DEV))
-		return iwl_mvm_set_tx_power_old(mvm, vif, tx_power);
-
 	if (tx_power == IWL_DEFAULT_MAX_TX_POWER)
 		cmd.v2.pwr_restriction = cpu_to_le16(IWL_DEV_MAX_TX_POWER);
 
-- 
2.5.1

