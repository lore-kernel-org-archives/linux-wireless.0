Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36879 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbaLBSLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:51 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so28814002wiv.17
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:50 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/26] iwlwifi: use correct fw file in 8000 b-step
Date: Tue,  2 Dec 2014 20:11:10 +0200
Message-Id: <1417543877-24193-19-git-send-email-egrumbach@gmail.com> (sfid-20141202_191219_754485_6355FDA5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In 8000 B-step the FW file has changed, but by the time we
know the HW step, the FW file is already requested.

This patch defaults 8000 family to B-step if no HW step is
detected in time. When it can it checks what HW step it
really is (in 8000 family) and if it isn't B-step, the FW
file is released and the A-step file is requested.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 54 ++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 249ed3b..2c6e830 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -245,6 +245,9 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	/*
 	 * Starting 8000B - FW name format has changed. This overwrites the
 	 * previous name and uses the new format.
+	 *
+	 * TODO:
+	 * Once there is only one supported step for 8000 family - delete this!
 	 */
 	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
 		char rev_step[2] = {
@@ -255,6 +258,13 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 		if (CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_A_STEP)
 			rev_step[0] = 0;
 
+		/*
+		 * If hw_rev wasn't set yet - default as B-step. If it IS A-step
+		 * we'll reload that FW later instead.
+		 */
+		if (drv->trans->hw_rev == 0)
+			rev_step[0] = 'B';
+
 		snprintf(drv->firmware_name, sizeof(drv->firmware_name),
 			 "%s%s-%s.ucode", name_pre, rev_step, tag);
 	}
@@ -993,6 +1003,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	u32 api_ver;
 	int i;
 	bool load_module = false;
+	u32 hw_rev = drv->trans->hw_rev;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -1159,6 +1170,49 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				op->name, err);
 #endif
 	}
+
+	/*
+	 * We may have loaded the wrong FW file in 8000 HW family if it is an
+	 * A-step card, and if drv->trans->hw_rev wasn't properly read when
+	 * the FW file had been loaded. (This might happen in SDIO.) In such a
+	 * case - unload and reload the correct file.
+	 *
+	 * TODO:
+	 * Once there is only one supported step for 8000 family - delete this!
+	 */
+	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
+	    CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_A_STEP &&
+	    drv->trans->hw_rev != hw_rev) {
+		char firmware_name[32];
+
+		/* Free previous FW resources */
+		if (drv->op_mode)
+			_iwl_op_mode_stop(drv);
+		iwl_dealloc_ucode(drv);
+
+		/* Build name of correct-step FW */
+		snprintf(firmware_name, sizeof(firmware_name),
+			 strrchr(drv->firmware_name, '-'));
+		snprintf(drv->firmware_name, sizeof(drv->firmware_name),
+			 "%s%s", drv->cfg->fw_name_pre, firmware_name);
+
+		/* Clear data before loading correct FW */
+		list_del(&drv->list);
+
+		/* Request correct FW file this time */
+		IWL_DEBUG_INFO(drv, "attempting to load A-step FW %s\n",
+			       drv->firmware_name);
+		err = request_firmware(&ucode_raw, drv->firmware_name,
+				       drv->trans->dev);
+		if (err) {
+			IWL_ERR(drv, "Failed swapping FW!\n");
+			goto out_unbind;
+		}
+
+		/* Redo callback function - this time with right FW */
+		iwl_req_fw_callback(ucode_raw, context);
+	}
+
 	return;
 
  try_again:
-- 
1.9.1

