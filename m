Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42488 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752104AbdHETnl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:43:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:17 +0300
Message-Id: <20170805194331.17426-6-luca@coelho.fi> (sfid-20170805_214348_166800_54E7E1AB)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 05/19] iwlwifi: change functions that can only return 0 to void
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

Change iwl_set_ucode_api_flags(), iwl_set_ucode_capabilities() to be void.
No need to check returned values.
Found by Klocwork.

Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 6fdb5921e17f..cdb765656115 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -478,8 +478,8 @@ static int iwl_set_default_calib(struct iwl_drv *drv, const u8 *data)
 	return 0;
 }
 
-static int iwl_set_ucode_api_flags(struct iwl_drv *drv, const u8 *data,
-				   struct iwl_ucode_capabilities *capa)
+static void iwl_set_ucode_api_flags(struct iwl_drv *drv, const u8 *data,
+				    struct iwl_ucode_capabilities *capa)
 {
 	const struct iwl_ucode_api *ucode_api = (void *)data;
 	u32 api_index = le32_to_cpu(ucode_api->api_index);
@@ -490,20 +490,17 @@ static int iwl_set_ucode_api_flags(struct iwl_drv *drv, const u8 *data,
 		IWL_ERR(drv,
 			"api flags index %d larger than supported by driver\n",
 			api_index);
-		/* don't return an error so we can load FW that has more bits */
-		return 0;
+		return;
 	}
 
 	for (i = 0; i < 32; i++) {
 		if (api_flags & BIT(i))
 			__set_bit(i + 32 * api_index, capa->_api);
 	}
-
-	return 0;
 }
 
-static int iwl_set_ucode_capabilities(struct iwl_drv *drv, const u8 *data,
-				      struct iwl_ucode_capabilities *capa)
+static void iwl_set_ucode_capabilities(struct iwl_drv *drv, const u8 *data,
+				       struct iwl_ucode_capabilities *capa)
 {
 	const struct iwl_ucode_capa *ucode_capa = (void *)data;
 	u32 api_index = le32_to_cpu(ucode_capa->api_index);
@@ -514,16 +511,13 @@ static int iwl_set_ucode_capabilities(struct iwl_drv *drv, const u8 *data,
 		IWL_ERR(drv,
 			"capa flags index %d larger than supported by driver\n",
 			api_index);
-		/* don't return an error so we can load FW that has more bits */
-		return 0;
+		return;
 	}
 
 	for (i = 0; i < 32; i++) {
 		if (api_flags & BIT(i))
 			__set_bit(i + 32 * api_index, capa->_capa);
 	}
-
-	return 0;
 }
 
 static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
@@ -765,14 +759,12 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		case IWL_UCODE_TLV_API_CHANGES_SET:
 			if (tlv_len != sizeof(struct iwl_ucode_api))
 				goto invalid_tlv_len;
-			if (iwl_set_ucode_api_flags(drv, tlv_data, capa))
-				goto tlv_error;
+			iwl_set_ucode_api_flags(drv, tlv_data, capa);
 			break;
 		case IWL_UCODE_TLV_ENABLED_CAPABILITIES:
 			if (tlv_len != sizeof(struct iwl_ucode_capa))
 				goto invalid_tlv_len;
-			if (iwl_set_ucode_capabilities(drv, tlv_data, capa))
-				goto tlv_error;
+			iwl_set_ucode_capabilities(drv, tlv_data, capa);
 			break;
 		case IWL_UCODE_TLV_INIT_EVTLOG_PTR:
 			if (tlv_len != sizeof(u32))
-- 
2.13.2
