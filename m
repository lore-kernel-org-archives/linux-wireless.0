Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932283AbdBQCJo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 21:09:44 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: johannes.berg@intel.com, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com, tj@kernel.org, arjan@linux.intel.com,
        ming.lei@canonical.com, zajec5@gmail.com
Cc: jeyu@redhat.com, rusty@rustcorp.com.au, pmladek@suse.com,
        gregkh@linuxfoundation.org, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 4/5] iwlwifi: move opmode loading to shared routine
Date: Thu, 16 Feb 2017 18:09:02 -0800
Message-Id: <20170217020903.6370-5-mcgrof@kernel.org> (sfid-20170217_031021_154991_54ACCD9A)
In-Reply-To: <20170217020903.6370-1-mcgrof@kernel.org>
References: <20170217020903.6370-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps us compartmentalize all last required opmode work
and declutter the async firmware callback.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 33 +++++++++++++++-------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 4a1937c77f90..6cfbc3c6e0d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -139,6 +139,8 @@ static struct iwlwifi_opmode_table {
 	const char *name;			/* name: iwldvm, iwlmvm, etc */
 	const struct iwl_op_mode_ops *ops;	/* pointer to op_mode ops */
 	struct list_head drv;		/* list of devices using this op_mode */
+	bool load_requested;		/* Do we need to load a driver ? */
+	struct iwl_drv *drv_req;	/* Device that set load_requested */
 } iwlwifi_opmode_table[] = {		/* ops set when driver is initialized */
 	[DVM_OP_MODE] = { .name = "iwldvm", .ops = NULL },
 	[MVM_OP_MODE] = { .name = "iwlmvm", .ops = NULL },
@@ -1233,27 +1235,32 @@ static void _iwl_op_mode_stop(struct iwl_drv *drv)
 	}
 }
 
-static void iwlwifi_try_load_op(struct iwlwifi_opmode_table *op,
-				struct iwl_drv *drv)
+/* We have to unlock and then lock for the caller */
+static void iwlwifi_try_load_op(struct iwlwifi_opmode_table *op)
 {
 	int ret = 0;
 
+	mutex_unlock(&iwlwifi_opmode_table_mtx);
+
 	ret = request_module("%s", op->name);
-	if (ret)
+	if (ret) {
+		mutex_lock(&iwlwifi_opmode_table_mtx);
 		goto out;
+	}
 
 	mutex_lock(&iwlwifi_opmode_table_mtx);
 	if (!op->ops)
 		ret = -ENOENT;
-	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
 out:
 #ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
 	if (ret)
-		IWL_ERR(drv,
+		IWL_ERR(op->drv_req,
 			"failed to load module %s (error %d), is dynamic loading enabled?\n",
 			op->name, ret);
 #endif
+	op->load_requested = false;
+	op->drv_req = NULL;
 }
 
 static void iwlwifi_opmode_start_drv(struct iwlwifi_opmode_table *op,
@@ -1294,6 +1301,8 @@ static void iwlwifi_opmode_dowork(void)
 		op = &iwlwifi_opmode_table[i];
 		if (op->ops)
 			iwlwifi_opmode_start(op);
+		else if (op->load_requested)
+			iwlwifi_try_load_op(op);
 	}
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 }
@@ -1317,7 +1326,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	size_t trigger_tlv_sz[FW_DBG_TRIGGER_MAX];
 	u32 api_ver;
 	int i;
-	bool load_module = false;
 	bool usniffer_images = false;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
@@ -1515,18 +1523,13 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	/* add this device to the list of devices using this op_mode */
 	list_add_tail(&drv->list, &op->drv);
 
-	if (!op->ops)
-		load_module = true;
+	if (!op->ops) {
+		op->load_requested = true;
+		op->drv_req = drv;
+	}
 
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
-	/*
-	 * Load the module last so we don't block anything
-	 * else from proceeding if the module fails to load
-	 * or hangs loading.
-	 */
-	if (load_module)
-		iwlwifi_try_load_op(op, drv);
 	iwlwifi_opmode_dowork();
 	goto free;
 
-- 
2.11.0
