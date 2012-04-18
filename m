Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39112 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab2DROps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/15] iwlwifi: driver holds its pointer to the config
Date: Wed, 18 Apr 2012 07:41:06 -0700
Message-Id: <1334760077-5714-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_164606_456845_ACDF42AD)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Instead of using the shared area that will be killed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 72d0818..69b5b1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -79,6 +79,8 @@
  * @fw: the iwl_fw structure
  * @shrd: pointer to common shared structure
  * @op_mode: the running op_mode
+ * @trans: transport layer
+ * @cfg: configuration struct
  * @fw_index: firmware revision to try loading
  * @firmware_name: composite filename of ucode file to load
  * @request_firmware_complete: the firmware has been obtained from user space
@@ -89,6 +91,7 @@ struct iwl_drv {
 	struct iwl_shared *shrd;
 	struct iwl_op_mode *op_mode;
 	struct iwl_trans *trans;
+	const struct iwl_cfg *cfg;
 
 	int fw_index;                   /* firmware we're trying to load */
 	char firmware_name[25];         /* name of firmware file to load */
@@ -157,8 +160,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
 
 static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 {
-	const struct iwl_cfg *cfg = cfg(drv);
-	const char *name_pre = cfg->fw_name_pre;
+	const char *name_pre = drv->cfg->fw_name_pre;
 	char tag[8];
 
 	if (first) {
@@ -167,14 +169,14 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
 	} else if (drv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
 #endif
-		drv->fw_index = cfg->ucode_api_max;
+		drv->fw_index = drv->cfg->ucode_api_max;
 		sprintf(tag, "%d", drv->fw_index);
 	} else {
 		drv->fw_index--;
 		sprintf(tag, "%d", drv->fw_index);
 	}
 
-	if (drv->fw_index < cfg->ucode_api_min) {
+	if (drv->fw_index < drv->cfg->ucode_api_min) {
 		IWL_ERR(drv, "no suitable firmware found!\n");
 		return -ENOENT;
 	}
@@ -726,14 +728,13 @@ static int validate_sec_sizes(struct iwl_drv *drv,
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 {
 	struct iwl_drv *drv = context;
-	const struct iwl_cfg *cfg = cfg(drv);
 	struct iwl_fw *fw = &drv->fw;
 	struct iwl_ucode_header *ucode;
 	int err;
 	struct iwl_firmware_pieces pieces;
-	const unsigned int api_max = cfg->ucode_api_max;
-	unsigned int api_ok = cfg->ucode_api_ok;
-	const unsigned int api_min = cfg->ucode_api_min;
+	const unsigned int api_max = drv->cfg->ucode_api_max;
+	unsigned int api_ok = drv->cfg->ucode_api_ok;
+	const unsigned int api_min = drv->cfg->ucode_api_min;
 	u32 api_ver;
 	int i;
 
@@ -812,7 +813,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * In mvm uCode there is no difference between data and instructions
 	 * sections.
 	 */
-	if (!fw->mvm_fw && validate_sec_sizes(drv, &pieces, cfg))
+	if (!fw->mvm_fw && validate_sec_sizes(drv, &pieces, drv->cfg))
 		goto try_again;
 
 	/* Allocate ucode buffers for card's bus-master loading ... */
@@ -836,14 +837,14 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		fw->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
 	else
 		fw->init_evtlog_size =
-			cfg->base_params->max_event_log_size;
+			drv->cfg->base_params->max_event_log_size;
 	fw->init_errlog_ptr = pieces.init_errlog_ptr;
 	fw->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
 	if (pieces.inst_evtlog_size)
 		fw->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
 	else
 		fw->inst_evtlog_size =
-			cfg->base_params->max_event_log_size;
+			drv->cfg->base_params->max_event_log_size;
 	fw->inst_errlog_ptr = pieces.inst_errlog_ptr;
 
 	/*
@@ -859,7 +860,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 	complete(&drv->request_firmware_complete);
 
-	drv->op_mode = iwl_dvm_ops.start(drv->trans, cfg, &drv->fw);
+	drv->op_mode = iwl_dvm_ops.start(drv->trans, drv->cfg, &drv->fw);
 
 	if (!drv->op_mode)
 		goto out_unbind;
@@ -899,6 +900,7 @@ struct iwl_drv *iwl_drv_start(struct iwl_shared *shrd,
 	/* For printing only - temporary until we change the logger */
 	drv->shrd = shrd;
 	drv->trans = trans;
+	drv->cfg = cfg;
 
 	init_completion(&drv->request_firmware_complete);
 
-- 
1.7.0.4

