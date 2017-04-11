Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50514 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752267AbdDKMhx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:37:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:19 +0300
Message-Id: <20170411123742.12214-3-luca@coelho.fi> (sfid-20170411_143800_164299_16E5AEE4)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 02/25] iwlwifi: be more verbose about needed firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

If the supported firmware versions are not found, we currently only
print "no suitable firmware found".  This is not very informative for
the user trying to find the correct version to use.  Improve this by
printing the exact firmware name(s) the driver supports and pointing
to the git repository where they can be found.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index be466a074c1d..21c523a9cc7e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -211,24 +211,39 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw,
 
 static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 {
-	const char *name_pre = drv->trans->cfg->fw_name_pre;
+	const struct iwl_cfg *cfg = drv->trans->cfg;
 	char tag[8];
 
 	if (first) {
-		drv->fw_index = drv->trans->cfg->ucode_api_max;
+		drv->fw_index = cfg->ucode_api_max;
 		sprintf(tag, "%d", drv->fw_index);
 	} else {
 		drv->fw_index--;
 		sprintf(tag, "%d", drv->fw_index);
 	}
 
-	if (drv->fw_index < drv->trans->cfg->ucode_api_min) {
+	if (drv->fw_index < cfg->ucode_api_min) {
 		IWL_ERR(drv, "no suitable firmware found!\n");
+
+		if (cfg->ucode_api_min == cfg->ucode_api_max) {
+			IWL_ERR(drv, "%s%d is required\n", cfg->fw_name_pre,
+				cfg->ucode_api_max);
+		} else {
+			IWL_ERR(drv, "minimum version required: %s%d\n",
+				cfg->fw_name_pre,
+				cfg->ucode_api_min);
+			IWL_ERR(drv, "maximum version supported: %s%d\n",
+				cfg->fw_name_pre,
+				cfg->ucode_api_max);
+		}
+
+		IWL_ERR(drv,
+			"check git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git\n");
 		return -ENOENT;
 	}
 
 	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%s.ucode",
-		 name_pre, tag);
+		 cfg->fw_name_pre, tag);
 
 	IWL_DEBUG_INFO(drv, "attempting to load firmware '%s'\n",
 		       drv->firmware_name);
-- 
2.11.0
