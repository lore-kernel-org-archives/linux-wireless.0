Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40848 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbcEJUav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:27 +0300
Message-Id: <1462910797-20303-31-git-send-email-luca@coelho.fi> (sfid-20160510_223056_329850_72678B32)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 31/41] iwlwifi: remove IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This Kconfig option allows to load a firmware for
debugging with a different name. This mechanism has not
been used for a few years now and replacing the firmware
file works as well.
Kill this Kconfig option and all the code that goes with it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig   |  6 -----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 35 +++++++---------------------
 2 files changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 492035f..b64db47 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -134,12 +134,6 @@ config IWLWIFI_DEBUGFS
 	  is a low-impact option that allows getting insight into the
 	  driver's state at runtime.
 
-config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
-        bool "Experimental uCode support"
-        depends on IWLWIFI_DEBUG
-        ---help---
-	  Enable use of experimental ucode for testing and debugging.
-
 config IWLWIFI_DEVICE_TRACING
 	bool "iwlwifi device access tracing"
 	depends on EVENT_TRACING
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 82434c5..b338230 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -211,20 +211,12 @@ static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
 static void iwl_req_fw_callback(const struct firmware *ucode_raw,
 				void *context);
 
-#define UCODE_EXPERIMENTAL_INDEX	100
-#define UCODE_EXPERIMENTAL_TAG		"exp"
-
 static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 {
 	const char *name_pre = drv->cfg->fw_name_pre;
 	char tag[8];
 
 	if (first) {
-#ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
-		drv->fw_index = UCODE_EXPERIMENTAL_INDEX;
-		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
-	} else if (drv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
-#endif
 		drv->fw_index = drv->cfg->ucode_api_max;
 		sprintf(tag, "%d", drv->fw_index);
 	} else {
@@ -240,9 +232,7 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%s.ucode",
 		 name_pre, tag);
 
-	IWL_DEBUG_INFO(drv, "attempting to load firmware %s'%s'\n",
-		       (drv->fw_index == UCODE_EXPERIMENTAL_INDEX)
-				? "EXPERIMENTAL " : "",
+	IWL_DEBUG_INFO(drv, "attempting to load firmware '%s'\n",
 		       drv->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, drv->firmware_name,
@@ -541,9 +531,7 @@ static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 	}
 
 	if (build)
-		sprintf(buildstr, " build %u%s", build,
-		       (drv->fw_index == UCODE_EXPERIMENTAL_INDEX)
-				? " (EXP)" : "");
+		sprintf(buildstr, " build %u", build);
 	else
 		buildstr[0] = '\0';
 
@@ -627,9 +615,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	build = le32_to_cpu(ucode->build);
 
 	if (build)
-		sprintf(buildstr, " build %u%s", build,
-		       (drv->fw_index == UCODE_EXPERIMENTAL_INDEX)
-				? " (EXP)" : "");
+		sprintf(buildstr, " build %u", build);
 	else
 		buildstr[0] = '\0';
 
@@ -1274,15 +1260,12 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * firmware filename ... but we don't check for that and only rely
 	 * on the API version read from firmware header from here on forward
 	 */
-	/* no api version check required for experimental uCode */
-	if (drv->fw_index != UCODE_EXPERIMENTAL_INDEX) {
-		if (api_ver < api_min || api_ver > api_max) {
-			IWL_ERR(drv,
-				"Driver unable to support your firmware API. "
-				"Driver supports v%u, firmware is v%u.\n",
-				api_max, api_ver);
-			goto try_again;
-		}
+	if (api_ver < api_min || api_ver > api_max) {
+		IWL_ERR(drv,
+			"Driver unable to support your firmware API. "
+			"Driver supports v%u, firmware is v%u.\n",
+			api_max, api_ver);
+		goto try_again;
 	}
 
 	/*
-- 
2.8.1

