Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2FKJxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:53:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/13] iwlwifi: fix dynamic loading
Date: Mon, 11 Jun 2012 11:53:02 +0200
Message-Id: <1339408392-19425-4-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115337_111495_27D6974B)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add locking to the dynamic loading code to prevent
corrupting the list if multiple device ever init at
the same time (which cannot happen for multiple PCI
devices, but could happen when different busses init
concurrently.)

Also remove a device from the list when it stops so
the list isn't left corrupted.

Reviewed-by: Donald H Fry <donald.h.fry@intel.com>
Tested-by: Donald H Fry <donald.h.fry@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index cdfdfae..cc7fed0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -131,6 +131,8 @@ struct iwl_drv {
 #define DVM_OP_MODE	0
 #define MVM_OP_MODE	1
 
+/* Protects the table contents, i.e. the ops pointer & drv list */
+static struct mutex iwlwifi_opmode_table_mtx;
 static struct iwlwifi_opmode_table {
 	const char *name;			/* name: iwldvm, iwlmvm, etc */
 	const struct iwl_op_mode_ops *ops;	/* pointer to op_mode ops */
@@ -899,6 +901,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 	complete(&drv->request_firmware_complete);
 
+	mutex_lock(&iwlwifi_opmode_table_mtx);
 	op = &iwlwifi_opmode_table[DVM_OP_MODE];
 
 	/* add this device to the list of devices using this op_mode */
@@ -910,6 +913,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	} else {
 		request_module_nowait("%s", op->name);
 	}
+	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
 	return;
 
@@ -966,6 +970,9 @@ void iwl_drv_stop(struct iwl_drv *drv)
 
 	iwl_dealloc_ucode(drv);
 
+	mutex_lock(&iwlwifi_opmode_table_mtx);
+	list_del(&drv->list);
+	mutex_unlock(&iwlwifi_opmode_table_mtx);
 	kfree(drv);
 }
 
@@ -988,6 +995,7 @@ int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops)
 	int i;
 	struct iwl_drv *drv;
 
+	mutex_lock(&iwlwifi_opmode_table_mtx);
 	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++) {
 		if (strcmp(iwlwifi_opmode_table[i].name, name))
 			continue;
@@ -995,8 +1003,10 @@ int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops)
 		list_for_each_entry(drv, &iwlwifi_opmode_table[i].drv, list)
 			drv->op_mode = ops->start(drv->trans, drv->cfg,
 						  &drv->fw);
+		mutex_unlock(&iwlwifi_opmode_table_mtx);
 		return 0;
 	}
+	mutex_unlock(&iwlwifi_opmode_table_mtx);
 	return -EIO;
 }
 EXPORT_SYMBOL_GPL(iwl_opmode_register);
@@ -1006,6 +1016,7 @@ void iwl_opmode_deregister(const char *name)
 	int i;
 	struct iwl_drv *drv;
 
+	mutex_lock(&iwlwifi_opmode_table_mtx);
 	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++) {
 		if (strcmp(iwlwifi_opmode_table[i].name, name))
 			continue;
@@ -1018,8 +1029,10 @@ void iwl_opmode_deregister(const char *name)
 				drv->op_mode = NULL;
 			}
 		}
+		mutex_unlock(&iwlwifi_opmode_table_mtx);
 		return;
 	}
+	mutex_unlock(&iwlwifi_opmode_table_mtx);
 }
 EXPORT_SYMBOL_GPL(iwl_opmode_deregister);
 
@@ -1027,6 +1040,8 @@ static int __init iwl_drv_init(void)
 {
 	int i;
 
+	mutex_init(&iwlwifi_opmode_table_mtx);
+
 	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++)
 		INIT_LIST_HEAD(&iwlwifi_opmode_table[i].drv);
 
-- 
1.7.10

