Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2HURCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 13:02:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Subject: [PATCH 3/8] iwlwifi: rework the iwlwifi debugfs structure
Date: Tue, 21 Aug 2012 19:01:51 +0200
Message-Id: <1345568516-20822-3-git-send-email-johannes@sipsolutions.net> (sfid-20120821_190219_564475_20D73BDD)
In-Reply-To: <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
References: <1345568455.10280.11.camel@jlt3.sipsolutions.net>
 <1345568516-20822-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

The generic part of the driver now creates all debugfs
directories. It creates a root directory directly in
the the root of the debugfs filesystem and within that
directories for each device, named after the device ID
of the devices iwlwifi is attached to.

In the cfg80211/mac80211 directory there's now a link
to the toplevel iwlwifi debugfs directory to make it
easier to find the debugfs files.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h     |    9 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c |   56 ++++++------
 drivers/net/wireless/iwlwifi/dvm/main.c    |   12 +--
 drivers/net/wireless/iwlwifi/iwl-drv.c     |  132 ++++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-op-mode.h |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h   |    2 +
 drivers/net/wireless/iwlwifi/pcie/drv.c    |    6 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c  |    6 +-
 8 files changed, 166 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 9bb16bd..12762dc 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -485,16 +485,13 @@ static inline void iwl_dvm_set_pmi(struct iwl_priv *priv, bool state)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-int iwl_dbgfs_register(struct iwl_priv *priv, const char *name);
-void iwl_dbgfs_unregister(struct iwl_priv *priv);
+int iwl_dbgfs_register(struct iwl_priv *priv, struct dentry *dbgfs_dir);
 #else
-static inline int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
+static inline int iwl_dbgfs_register(struct iwl_priv *priv,
+				     struct dentry *dbgfs_dir)
 {
 	return 0;
 }
-static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
-{
-}
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 46782f1..ce826bc 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2349,24 +2349,19 @@ DEBUGFS_READ_WRITE_FILE_OPS(calib_disabled);
  * Create the debugfs files and directories
  *
  */
-int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
+int iwl_dbgfs_register(struct iwl_priv *priv, struct dentry *dbgfs_dir)
 {
-	struct dentry *phyd = priv->hw->wiphy->debugfsdir;
-	struct dentry *dir_drv, *dir_data, *dir_rf, *dir_debug;
+	struct dentry *dir_data, *dir_rf, *dir_debug;
 
-	dir_drv = debugfs_create_dir(name, phyd);
-	if (!dir_drv)
-		return -ENOMEM;
-
-	priv->debugfs_dir = dir_drv;
+	priv->debugfs_dir = dbgfs_dir;
 
-	dir_data = debugfs_create_dir("data", dir_drv);
+	dir_data = debugfs_create_dir("data", dbgfs_dir);
 	if (!dir_data)
 		goto err;
-	dir_rf = debugfs_create_dir("rf", dir_drv);
+	dir_rf = debugfs_create_dir("rf", dbgfs_dir);
 	if (!dir_rf)
 		goto err;
-	dir_debug = debugfs_create_dir("debug", dir_drv);
+	dir_debug = debugfs_create_dir("debug", dbgfs_dir);
 	if (!dir_debug)
 		goto err;
 
@@ -2412,25 +2407,30 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	/* Calibrations disabled/enabled status*/
 	DEBUGFS_ADD_FILE(calib_disabled, dir_rf, S_IWUSR | S_IRUSR);
 
-	if (iwl_trans_dbgfs_register(priv->trans, dir_debug))
-		goto err;
+	/*
+	 * Create a symlink with mac80211. This is not very robust, as it does
+	 * not remove the symlink created. The implicit assumption is that
+	 * when the opmode exits, mac80211 will also exit, and will remove
+	 * this symlink as part of its cleanup.
+	 */
+	if (priv->mac80211_registered) {
+		char buf[100];
+		struct dentry *mac80211_dir, *dev_dir, *root_dir;
+
+		dev_dir = dbgfs_dir->d_parent;
+		root_dir = dev_dir->d_parent;
+		mac80211_dir = priv->hw->wiphy->debugfsdir;
+
+		snprintf(buf, 100, "../../%s/%s", root_dir->d_name.name,
+			 dev_dir->d_name.name);
+
+		if (!debugfs_create_symlink("iwlwifi", mac80211_dir, buf))
+			goto err;
+	}
+
 	return 0;
 
 err:
-	IWL_ERR(priv, "Can't create the debugfs directory\n");
-	iwl_dbgfs_unregister(priv);
+	IWL_ERR(priv, "failed to create the dvm debugfs entries\n");
 	return -ENOMEM;
 }
-
-/**
- * Remove the debugfs files and directories
- *
- */
-void iwl_dbgfs_unregister(struct iwl_priv *priv)
-{
-	if (!priv->debugfs_dir)
-		return;
-
-	debugfs_remove_recursive(priv->debugfs_dir);
-	priv->debugfs_dir = NULL;
-}
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index e8ffbe4..ab7b9ed 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1222,7 +1222,8 @@ static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 
 static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 						 const struct iwl_cfg *cfg,
-						 const struct iwl_fw *fw)
+						 const struct iwl_fw *fw,
+						 struct dentry *dbgfs_dir)
 {
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
@@ -1466,12 +1467,13 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	if (iwlagn_mac_setup_register(priv, &fw->ucode_capa))
 		goto out_destroy_workqueue;
 
-	if (iwl_dbgfs_register(priv, DRV_NAME))
-		IWL_ERR(priv,
-			"failed to create debugfs files. Ignoring error\n");
+	if (iwl_dbgfs_register(priv, dbgfs_dir))
+		goto out_mac80211_unregister;
 
 	return op_mode;
 
+out_mac80211_unregister:
+	iwlagn_mac_unregister(priv);
 out_destroy_workqueue:
 	iwl_tt_exit(priv);
 	iwl_testmode_free(priv);
@@ -1496,8 +1498,6 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
-	iwl_dbgfs_unregister(priv);
-
 	iwl_testmode_free(priv);
 	iwlagn_mac_unregister(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 35a9d65..48d6d44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -101,6 +101,10 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+static struct dentry *iwl_dbgfs_root;
+#endif
+
 /**
  * struct iwl_drv - drv common data
  * @list: list of drv structures using this opmode
@@ -126,6 +130,12 @@ struct iwl_drv {
 	char firmware_name[25];         /* name of firmware file to load */
 
 	struct completion request_firmware_complete;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	struct dentry *dbgfs_drv;
+	struct dentry *dbgfs_trans;
+	struct dentry *dbgfs_op_mode;
+#endif
 };
 
 #define DVM_OP_MODE	0
@@ -760,6 +770,50 @@ static int validate_sec_sizes(struct iwl_drv *drv,
 	return 0;
 }
 
+static struct iwl_op_mode *
+_iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
+{
+	const struct iwl_op_mode_ops *ops = op->ops;
+	struct dentry *dbgfs_dir = NULL;
+	struct iwl_op_mode *op_mode = NULL;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	drv->dbgfs_op_mode = debugfs_create_dir(op->name,
+						drv->dbgfs_drv);
+	if (!drv->dbgfs_op_mode) {
+		IWL_ERR(drv,
+			"failed to create opmode debugfs directory\n");
+		return op_mode;
+	}
+	dbgfs_dir = drv->dbgfs_op_mode;
+#endif
+
+	op_mode = ops->start(drv->trans, drv->cfg, &drv->fw, dbgfs_dir);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (!op_mode) {
+		debugfs_remove_recursive(drv->dbgfs_op_mode);
+		drv->dbgfs_op_mode = NULL;
+	}
+#endif
+
+	return op_mode;
+}
+
+static void _iwl_op_mode_stop(struct iwl_drv *drv)
+{
+	/* op_mode can be NULL if its start failed */
+	if (drv->op_mode) {
+		iwl_op_mode_stop(drv->op_mode);
+		drv->op_mode = NULL;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		debugfs_remove_recursive(drv->dbgfs_op_mode);
+		drv->dbgfs_op_mode = NULL;
+#endif
+	}
+}
+
 /**
  * iwl_req_fw_callback - callback when firmware was loaded
  *
@@ -909,8 +963,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	list_add_tail(&drv->list, &op->drv);
 
 	if (op->ops) {
-		const struct iwl_op_mode_ops *ops = op->ops;
-		drv->op_mode = ops->start(drv->trans, drv->cfg, &drv->fw);
+		drv->op_mode = _iwl_op_mode_start(drv, op);
 
 		if (!drv->op_mode) {
 			mutex_unlock(&iwlwifi_opmode_table_mtx);
@@ -970,24 +1023,51 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 	init_completion(&drv->request_firmware_complete);
 	INIT_LIST_HEAD(&drv->list);
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	/* Create the device debugfs entries. */
+	drv->dbgfs_drv = debugfs_create_dir(dev_name(trans->dev),
+					    iwl_dbgfs_root);
+
+	if (!drv->dbgfs_drv) {
+		IWL_ERR(drv, "failed to create debugfs directory\n");
+		goto err_free_drv;
+	}
+
+	/* Create transport layer debugfs dir */
+	drv->trans->dbgfs_dir = debugfs_create_dir("trans", drv->dbgfs_drv);
+
+	if (!drv->trans->dbgfs_dir) {
+		IWL_ERR(drv, "failed to create transport debugfs directory\n");
+		goto err_free_dbgfs;
+	}
+#endif
+
 	ret = iwl_request_firmware(drv, true);
 
 	if (ret) {
 		IWL_ERR(trans, "Couldn't request the fw\n");
-		kfree(drv);
-		drv = NULL;
+		goto err_fw;
 	}
 
 	return drv;
+
+err_fw:
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+err_free_dbgfs:
+	debugfs_remove_recursive(drv->dbgfs_drv);
+err_free_drv:
+#endif
+	kfree(drv);
+	drv = NULL;
+
+	return drv;
 }
 
 void iwl_drv_stop(struct iwl_drv *drv)
 {
 	wait_for_completion(&drv->request_firmware_complete);
 
-	/* op_mode can be NULL if its start failed */
-	if (drv->op_mode)
-		iwl_op_mode_stop(drv->op_mode);
+	_iwl_op_mode_stop(drv);
 
 	iwl_dealloc_ucode(drv);
 
@@ -1001,6 +1081,10 @@ void iwl_drv_stop(struct iwl_drv *drv)
 		list_del(&drv->list);
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	debugfs_remove_recursive(drv->dbgfs_drv);
+#endif
+
 	kfree(drv);
 }
 
@@ -1023,15 +1107,18 @@ int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops)
 {
 	int i;
 	struct iwl_drv *drv;
+	struct iwlwifi_opmode_table *op;
 
 	mutex_lock(&iwlwifi_opmode_table_mtx);
 	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++) {
-		if (strcmp(iwlwifi_opmode_table[i].name, name))
+		op = &iwlwifi_opmode_table[i];
+		if (strcmp(op->name, name))
 			continue;
-		iwlwifi_opmode_table[i].ops = ops;
-		list_for_each_entry(drv, &iwlwifi_opmode_table[i].drv, list)
-			drv->op_mode = ops->start(drv->trans, drv->cfg,
-						  &drv->fw);
+		op->ops = ops;
+		/* TODO: need to handle exceptional case */
+		list_for_each_entry(drv, &op->drv, list)
+			drv->op_mode = _iwl_op_mode_start(drv, op);
+
 		mutex_unlock(&iwlwifi_opmode_table_mtx);
 		return 0;
 	}
@@ -1052,12 +1139,9 @@ void iwl_opmode_deregister(const char *name)
 		iwlwifi_opmode_table[i].ops = NULL;
 
 		/* call the stop routine for all devices */
-		list_for_each_entry(drv, &iwlwifi_opmode_table[i].drv, list) {
-			if (drv->op_mode) {
-				iwl_op_mode_stop(drv->op_mode);
-				drv->op_mode = NULL;
-			}
-		}
+		list_for_each_entry(drv, &iwlwifi_opmode_table[i].drv, list)
+			_iwl_op_mode_stop(drv);
+
 		mutex_unlock(&iwlwifi_opmode_table_mtx);
 		return;
 	}
@@ -1077,6 +1161,14 @@ static int __init iwl_drv_init(void)
 	pr_info(DRV_DESCRIPTION ", " DRV_VERSION "\n");
 	pr_info(DRV_COPYRIGHT "\n");
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	/* Create the root of iwlwifi debugfs subsystem. */
+	iwl_dbgfs_root = debugfs_create_dir(DRV_NAME, NULL);
+
+	if (!iwl_dbgfs_root)
+		return -EFAULT;
+#endif
+
 	return iwl_pci_register_driver();
 }
 module_init(iwl_drv_init);
@@ -1084,6 +1176,10 @@ module_init(iwl_drv_init);
 static void __exit iwl_drv_exit(void)
 {
 	iwl_pci_unregister_driver();
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	debugfs_remove_recursive(iwl_dbgfs_root);
+#endif
 }
 module_exit(iwl_drv_exit);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 64886f9..c8d9b95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -134,7 +134,8 @@ struct iwl_cfg;
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans,
 				     const struct iwl_cfg *cfg,
-				     const struct iwl_fw *fw);
+				     const struct iwl_fw *fw,
+				     struct dentry *dbgfs_dir);
 	void (*stop)(struct iwl_op_mode *op_mode);
 	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 		  struct iwl_device_cmd *cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 92576a3..8ac72a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -460,6 +460,8 @@ struct iwl_trans {
 	size_t dev_cmd_headroom;
 	char dev_cmd_pool_name[50];
 
+	struct dentry *dbgfs_dir;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index f4c3500..89bfb43 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -282,8 +282,14 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!trans_pcie->drv)
 		goto out_free_trans;
 
+	/* register transport layer debugfs here */
+	if (iwl_trans_dbgfs_register(iwl_trans, iwl_trans->dbgfs_dir))
+		goto out_free_drv;
+
 	return 0;
 
+out_free_drv:
+	iwl_drv_stop(trans_pcie->drv);
 out_free_trans:
 	iwl_trans_pcie_free(iwl_trans);
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 69bf615..0232628 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1769,7 +1769,7 @@ void iwl_dump_csr(struct iwl_trans *trans)
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
 	if (!debugfs_create_file(#name, mode, parent, trans,		\
 				 &iwl_dbgfs_##name##_ops))		\
-		return -ENOMEM;						\
+		goto err;						\
 } while (0)
 
 /* file operation */
@@ -2033,6 +2033,10 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(fw_restart, dir, S_IWUSR);
 	return 0;
+
+err:
+	IWL_ERR(trans, "failed to create the trans debugfs entry\n");
+	return -ENOMEM;
 }
 #else
 static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
-- 
1.7.10.4

