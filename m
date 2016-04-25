Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38852 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932541AbcDYRei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 13:34:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, emmanuel.grumbach@intel.com,
	sara.sharon@intel.com, pat-lkml@erley.org, luciano.coelho@intel.com
Date: Mon, 25 Apr 2016 20:02:09 +0300
Message-Id: <1461603729-20973-1-git-send-email-luca@coelho.fi> (sfid-20160425_193442_343674_4B5BD685)
Subject: [PATCH] iwlwifi: fix fw version reading for DVM devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

In commit 97f95c93c8ed ("iwlwifi: remove support for fw older than
-16.ucode") we accidentally changed the fw version reading code for
DVM devices.  The code intended to remove the old fw version API,
because all MVM firmwares version 16 and above that we support don't
use it anymore.  But DVM devices still use the old FW API.

Fix that by bringing the code back in.

Reported-by: Pat Erley <pat-lkml@erley.org>
Fixes: 97f95c93c8ed ("iwlwifi: remove support for fw older than-16.ucode")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c     | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 48e8737..4f495d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1280,7 +1280,10 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	if (err)
 		goto try_again;
 
-	api_ver = drv->fw.ucode_ver;
+	if (fw_has_api(&drv->fw.ucode_capa, IWL_UCODE_TLV_API_NEW_VERSION))
+		api_ver = drv->fw.ucode_ver;
+	else
+		api_ver = IWL_UCODE_API(drv->fw.ucode_ver);
 
 	/*
 	 * api_ver should match the api version forming part of the
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 843232b..37dc09e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -251,6 +251,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
  * @IWL_UCODE_TLV_API_WIDE_CMD_HDR: ucode supports wide command header
  * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
+ * @IWL_UCODE_TLV_API_NEW_VERSION: new versioning format
  * @IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY: scan APIs use 8-level priority
  *	instead of 3.
  * @IWL_UCODE_TLV_API_TX_POWER_CHAIN: TX power API has larger command size
@@ -263,6 +264,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
 	IWL_UCODE_TLV_API_WIDE_CMD_HDR		= (__force iwl_ucode_tlv_api_t)14,
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= (__force iwl_ucode_tlv_api_t)18,
+	IWL_UCODE_TLV_API_NEW_VERSION           = (__force iwl_ucode_tlv_api_t)20,
 	IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY	= (__force iwl_ucode_tlv_api_t)24,
 	IWL_UCODE_TLV_API_TX_POWER_CHAIN	= (__force iwl_ucode_tlv_api_t)27,
 
-- 
2.8.0.rc3

