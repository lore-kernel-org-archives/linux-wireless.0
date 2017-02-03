Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37986 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752521AbdBCOj6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:39:58 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:09 +0200
Message-Id: <20170203143812.7525-23-luca@coelho.fi> (sfid-20170203_154001_344009_1D2DE403)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 22/25] iwlwifi: remove unnecessary cfg element in iwl_drv
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The iwl_drv structure contains trans which already contains cfg, so
storing cfg separately in iwl_drv is redundant.  Remove it and access
trans->cfg instead.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 899223e8414c..0e0293d42b5d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -102,7 +102,6 @@ static struct dentry *iwl_dbgfs_root;
  * @op_mode: the running op_mode
  * @trans: transport layer
  * @dev: for debug prints only
- * @cfg: configuration struct
  * @fw_index: firmware revision to try loading
  * @firmware_name: composite filename of ucode file to load
  * @request_firmware_complete: the firmware has been obtained from user space
@@ -114,7 +113,6 @@ struct iwl_drv {
 	struct iwl_op_mode *op_mode;
 	struct iwl_trans *trans;
 	struct device *dev;
-	const struct iwl_cfg *cfg;
 
 	int fw_index;                   /* firmware we're trying to load */
 	char firmware_name[64];         /* name of firmware file to load */
@@ -213,18 +211,18 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw,
 
 static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 {
-	const char *name_pre = drv->cfg->fw_name_pre;
+	const char *name_pre = drv->trans->cfg->fw_name_pre;
 	char tag[8];
 
 	if (first) {
-		drv->fw_index = drv->cfg->ucode_api_max;
+		drv->fw_index = drv->trans->cfg->ucode_api_max;
 		sprintf(tag, "%d", drv->fw_index);
 	} else {
 		drv->fw_index--;
 		sprintf(tag, "%d", drv->fw_index);
 	}
 
-	if (drv->fw_index < drv->cfg->ucode_api_min) {
+	if (drv->fw_index < drv->trans->cfg->ucode_api_min) {
 		IWL_ERR(drv, "no suitable firmware found!\n");
 		return -ENOENT;
 	}
@@ -1207,7 +1205,7 @@ _iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
 	dbgfs_dir = drv->dbgfs_op_mode;
 #endif
 
-	op_mode = ops->start(drv->trans, drv->cfg, &drv->fw, dbgfs_dir);
+	op_mode = ops->start(drv->trans, drv->trans->cfg, &drv->fw, dbgfs_dir);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (!op_mode) {
@@ -1247,8 +1245,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	struct iwlwifi_opmode_table *op;
 	int err;
 	struct iwl_firmware_pieces *pieces;
-	const unsigned int api_max = drv->cfg->ucode_api_max;
-	const unsigned int api_min = drv->cfg->ucode_api_min;
+	const unsigned int api_max = drv->trans->cfg->ucode_api_max;
+	const unsigned int api_min = drv->trans->cfg->ucode_api_min;
 	size_t trigger_tlv_sz[FW_DBG_TRIGGER_MAX];
 	u32 api_ver;
 	int i;
@@ -1310,7 +1308,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * In mvm uCode there is no difference between data and instructions
 	 * sections.
 	 */
-	if (fw->type == IWL_FW_DVM && validate_sec_sizes(drv, pieces, drv->cfg))
+	if (fw->type == IWL_FW_DVM && validate_sec_sizes(drv, pieces,
+							 drv->trans->cfg))
 		goto try_again;
 
 	/* Allocate ucode buffers for card's bus-master loading ... */
@@ -1408,14 +1407,14 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		fw->init_evtlog_size = (pieces->init_evtlog_size - 16)/12;
 	else
 		fw->init_evtlog_size =
-			drv->cfg->base_params->max_event_log_size;
+			drv->trans->cfg->base_params->max_event_log_size;
 	fw->init_errlog_ptr = pieces->init_errlog_ptr;
 	fw->inst_evtlog_ptr = pieces->inst_evtlog_ptr;
 	if (pieces->inst_evtlog_size)
 		fw->inst_evtlog_size = (pieces->inst_evtlog_size - 16)/12;
 	else
 		fw->inst_evtlog_size =
-			drv->cfg->base_params->max_event_log_size;
+			drv->trans->cfg->base_params->max_event_log_size;
 	fw->inst_errlog_ptr = pieces->inst_errlog_ptr;
 
 	/*
@@ -1517,7 +1516,6 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 
 	drv->trans = trans;
 	drv->dev = trans->dev;
-	drv->cfg = trans->cfg;
 
 	init_completion(&drv->request_firmware_complete);
 	INIT_LIST_HEAD(&drv->list);
-- 
2.11.0
