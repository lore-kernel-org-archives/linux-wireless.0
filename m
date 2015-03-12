Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbbCLNFv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:51 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/49] iwlwifi: mvm: remove IWL_UCODE_TLV_API_DISABLE_STA_TX
Date: Thu, 12 Mar 2015 15:04:06 +0200
Message-Id: <1426165474-25586-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143417_444450_5F7C8C52)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the supported firwmares have this new API.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 2 --
 drivers/net/wireless/iwlwifi/mvm/sta.c     | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 81c2f48..489bda4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -240,7 +240,6 @@ enum iwl_ucode_tlv_flag {
 /**
  * enum iwl_ucode_tlv_api - ucode api
  * @IWL_UCODE_TLV_API_BT_COEX_SPLIT: new API for BT Coex
- * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
  * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
@@ -259,7 +258,6 @@ enum iwl_ucode_tlv_flag {
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
-	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
 	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= BIT(9),
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 5c23cdd..325cbbb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1681,9 +1681,6 @@ void iwl_mvm_sta_modify_disable_tx(struct iwl_mvm *mvm,
 	};
 	int ret;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_DISABLE_STA_TX))
-		return;
-
 	ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA, CMD_ASYNC, sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
-- 
1.9.1

