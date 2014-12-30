Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12344 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaL3OTq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Dor Shaish <dor.shaish@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/33] Revert "iwlwifi: use correct fw file in 8000 b-step"
Date: Tue, 30 Dec 2014 16:18:38 +0200
Message-Id: <1419949148-24046-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151950_581932_E0454F58)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 55 ----------------------------------
 1 file changed, 55 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 36ae191..afa63f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -237,9 +237,6 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	/*
 	 * Starting 8000B - FW name format has changed. This overwrites the
 	 * previous name and uses the new format.
-	 *
-	 * TODO:
-	 * Once there is only one supported step for 8000 family - delete this!
 	 */
 	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
 		char rev_step[2] = {
@@ -250,13 +247,6 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 		if (CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_A_STEP)
 			rev_step[0] = 0;
 
-		/*
-		 * If hw_rev wasn't set yet - default as B-step. If it IS A-step
-		 * we'll reload that FW later instead.
-		 */
-		if (drv->trans->hw_rev == 0)
-			rev_step[0] = 'B';
-
 		snprintf(drv->firmware_name, sizeof(drv->firmware_name),
 			 "%s%s-%s.ucode", name_pre, rev_step, tag);
 	}
@@ -1069,7 +1059,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	u32 api_ver;
 	int i;
 	bool load_module = false;
-	u32 hw_rev = drv->trans->hw_rev;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -1262,50 +1251,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				op->name, err);
 #endif
 	}
-
-	/*
-	 * We may have loaded the wrong FW file in 8000 HW family if it is an
-	 * A-step card, and if drv->trans->hw_rev wasn't properly read when
-	 * the FW file had been loaded. (This might happen in SDIO.) In such a
-	 * case - unload and reload the correct file.
-	 *
-	 * TODO:
-	 * Once there is only one supported step for 8000 family - delete this!
-	 */
-	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
-	    CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_A_STEP &&
-	    drv->trans->hw_rev != hw_rev) {
-		char firmware_name[32];
-
-		/* Free previous FW resources */
-		if (drv->op_mode)
-			_iwl_op_mode_stop(drv);
-		iwl_dealloc_ucode(drv);
-
-		/* Build name of correct-step FW */
-		snprintf(firmware_name, sizeof(firmware_name),
-			 strrchr(drv->firmware_name, '-'));
-		snprintf(drv->firmware_name, sizeof(drv->firmware_name),
-			 "%s%s", drv->cfg->fw_name_pre, firmware_name);
-
-		/* Clear data before loading correct FW */
-		list_del(&drv->list);
-
-		/* Request correct FW file this time */
-		IWL_DEBUG_INFO(drv, "attempting to load A-step FW %s\n",
-			       drv->firmware_name);
-		err = request_firmware(&ucode_raw, drv->firmware_name,
-				       drv->trans->dev);
-		if (err) {
-			IWL_ERR(drv, "Failed swapping FW!\n");
-			goto out_unbind;
-		}
-
-		/* Redo callback function - this time with right FW */
-		iwl_req_fw_callback(ucode_raw, context);
-	}
-
-	kfree(pieces);
 	return;
 
  try_again:
-- 
1.9.1

