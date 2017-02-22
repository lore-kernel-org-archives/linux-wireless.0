Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754324AbdBVCKv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 21:10:51 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: johannes.berg@intel.com, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com
Cc: ming.lei@canonical.com, zajec5@gmail.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 1/2] iwlwifi: share opmode start work code
Date: Tue, 21 Feb 2017 18:10:38 -0800
Message-Id: <20170222021039.28193-2-mcgrof@kernel.org> (sfid-20170222_031114_913060_8F63DC0F)
In-Reply-To: <20170222021039.28193-1-mcgrof@kernel.org>
References: <20170222001822.GE31264@wotan.suse.de>
 <20170222021039.28193-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware async callback and the opmode registration share
some functionality -- to start the drv's opmode. Move this work
into a helper which is shared. This should help us share fixes
should these diverging code paths change.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 90 +++++++++++++++++++---------
 1 file changed, 61 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index e96095c1824a..ea88b5cec869 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -102,6 +102,7 @@ static struct dentry *iwl_dbgfs_root;
  * @op_mode: the running op_mode
  * @trans: transport layer
  * @dev: for debug prints only
+ * @start_requested: start op has been requested and is pending on this device
  * @fw_index: firmware revision to try loading
  * @firmware_name: composite filename of ucode file to load
  * @request_firmware_complete: the firmware has been obtained from user space
@@ -113,6 +114,7 @@ struct iwl_drv {
 	struct iwl_op_mode *op_mode;
 	struct iwl_trans *trans;
 	struct device *dev;
+	bool start_requested;
 
 	int fw_index;                   /* firmware we're trying to load */
 	char firmware_name[64];         /* name of firmware file to load */
@@ -1231,6 +1233,48 @@ static void _iwl_op_mode_stop(struct iwl_drv *drv)
 	}
 }
 
+static void iwlwifi_opmode_start_drv(struct iwlwifi_opmode_table *op,
+				     struct iwl_drv *drv)
+{
+	if (!drv->start_requested)
+		return;
+
+	drv->op_mode = _iwl_op_mode_start(drv, op);
+	drv->start_requested = false;
+
+	/*
+	 * Complete the firmware request last so that
+	 * a driver unbind (stop) doesn't run while we
+	 * are doing the start() above.
+	 */
+	complete(&drv->request_firmware_complete);
+
+	if (!drv->op_mode)
+		device_release_driver(drv->trans->dev);
+}
+
+static void iwlwifi_opmode_start(struct iwlwifi_opmode_table *op)
+{
+	struct iwl_drv *drv;
+
+	list_for_each_entry(drv, &op->drv, list)
+		iwlwifi_opmode_start_drv(op, drv);
+}
+
+static void iwlwifi_opmode_dowork(void)
+{
+	unsigned int i;
+	struct iwlwifi_opmode_table *op;
+
+	mutex_lock(&iwlwifi_opmode_table_mtx);
+	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++) {
+		op = &iwlwifi_opmode_table[i];
+		if (op->ops)
+			iwlwifi_opmode_start(op);
+	}
+	mutex_unlock(&iwlwifi_opmode_table_mtx);
+}
+
 /**
  * iwl_req_fw_callback - callback when firmware was loaded
  *
@@ -1443,30 +1487,17 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	IWL_INFO(drv, "loaded firmware version %s op_mode %s\n",
 		 drv->fw.fw_version, op->name);
 
+	drv->start_requested = true;
 	/* add this device to the list of devices using this op_mode */
 	list_add_tail(&drv->list, &op->drv);
 
-	if (op->ops) {
-		drv->op_mode = _iwl_op_mode_start(drv, op);
-
-		if (!drv->op_mode) {
-			mutex_unlock(&iwlwifi_opmode_table_mtx);
-			goto out_unbind;
-		}
-	}
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
-	/*
-	 * Complete the firmware request last so that
-	 * a driver unbind (stop) doesn't run while we
-	 * are doing the start() above.
-	 */
-	complete(&drv->request_firmware_complete);
-
 	err = request_module_nowait("%s", op->name);
 	if (err)
 		goto out_unbind;
 
+	iwlwifi_opmode_dowork();
 	goto free;
 
  try_again:
@@ -1588,8 +1619,8 @@ IWL_EXPORT_SYMBOL(iwlwifi_mod_params);
 int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops)
 {
 	int i;
-	struct iwl_drv *drv;
 	struct iwlwifi_opmode_table *op;
+	int ret = -EIO;
 
 	mutex_lock(&iwlwifi_opmode_table_mtx);
 	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++) {
@@ -1597,20 +1628,15 @@ int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops)
 		if (strcmp(op->name, name))
 			continue;
 		op->ops = ops;
-		/* TODO: need to handle exceptional case */
-		list_for_each_entry(drv, &op->drv, list) {
-			drv->op_mode = _iwl_op_mode_start(drv, op);
-			if (!drv->op_mode) {
-				complete(&drv->request_firmware_complete);
-				device_release_driver(drv->trans->dev);
-			}
-		}
-
-		mutex_unlock(&iwlwifi_opmode_table_mtx);
-		return 0;
+		ret = 0;
+		break;
 	}
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
-	return -EIO;
+
+	if (!ret)
+		iwlwifi_opmode_dowork();
+
+	return ret;
 }
 IWL_EXPORT_SYMBOL(iwl_opmode_register);
 
@@ -1626,8 +1652,14 @@ void iwl_opmode_deregister(const char *name)
 		iwlwifi_opmode_table[i].ops = NULL;
 
 		/* call the stop routine for all devices */
-		list_for_each_entry(drv, &iwlwifi_opmode_table[i].drv, list)
+		list_for_each_entry(drv, &iwlwifi_opmode_table[i].drv, list) {
 			_iwl_op_mode_stop(drv);
+			/*
+			 * So that if iwlmvm gets unloaded alone, but then
+			 * loaded again we can kick the old registered devices
+			 */
+			drv->start_requested = true;
+		}
 
 		mutex_unlock(&iwlwifi_opmode_table_mtx);
 		return;
-- 
2.11.0
