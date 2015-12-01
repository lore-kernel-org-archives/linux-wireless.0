Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19098 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbbLAJ7s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/41] iwlwifi: clean up transport debugfs handling
Date: Tue,  1 Dec 2015 11:58:52 +0200
Message-Id: <1448963947-24302-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110302_509786_DE6A859E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Transport code currently calls itself through the transport ops,
which is quite pointless. Clean up all of this. While at it,
remove the unnecessary dir argument and the redundant IDI code.

In slave transports, call both the common slave debugfs and the
transport's own. SDIO has no files, so remove it all there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  9 ---------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  9 +++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 18 ++++--------------
 4 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 607f4f7..3d089ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -542,8 +542,6 @@ struct iwl_trans_txq_scd_cfg {
  * @wait_tx_queue_empty: wait until tx queues are empty. May sleep.
  * @freeze_txq_timer: prevents the timer of the queue from firing until the
  *	queue is set to awake. Must be atomic.
- * @dbgfs_register: add the dbgfs files under this directory. Files will be
- *	automatically deleted.
  * @write8: write a u8 to a register at offset ofs from the BAR
  * @write32: write a u32 to a register at offset ofs from the BAR
  * @read32: read a u32 register at offset ofs from the BAR
@@ -599,7 +597,6 @@ struct iwl_trans_ops {
 	void (*txq_disable)(struct iwl_trans *trans, int queue,
 			    bool configure_scd);
 
-	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans, u32 txq_bm);
 	void (*freeze_txq_timer)(struct iwl_trans *trans, unsigned long txqs,
 				 bool freeze);
@@ -1022,12 +1019,6 @@ static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
 	return trans->ops->wait_tx_queue_empty(trans, txqs);
 }
 
-static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
-					   struct dentry *dir)
-{
-	return trans->ops->dbgfs_register(trans, dir);
-}
-
 static inline void iwl_trans_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 {
 	trans->ops->write8(trans, ofs, val);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 639761f..a52710f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -598,7 +598,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	set_dflt_pwr_limit(iwl_trans, pdev);
 
 	/* register transport layer debugfs here */
-	ret = iwl_trans_dbgfs_register(iwl_trans, iwl_trans->dbgfs_dir);
+	ret = iwl_trans_pcie_dbgfs_register(iwl_trans);
 	if (ret)
 		goto out_free_drv;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index bf41543..44dc09d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -569,4 +569,13 @@ static inline void __iwl_trans_pcie_set_bit(struct iwl_trans *trans,
 
 void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state);
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans);
+#else
+static inline int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
+{
+	return 0;
+}
+#endif
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 50614e4d..efef487 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2107,13 +2107,11 @@ DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_READ_FILE_OPS(tx_queue);
 DEBUGFS_WRITE_FILE_OPS(csr);
 
-/*
- * Create the debugfs files and directories
- *
- */
-static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
-					 struct dentry *dir)
+/* Create the debugfs files and directories */
+int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 {
+	struct dentry *dir = trans->dbgfs_dir;
+
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
@@ -2125,12 +2123,6 @@ err:
 	IWL_ERR(trans, "failed to create the trans debugfs entry\n");
 	return -ENOMEM;
 }
-#else
-static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
-					 struct dentry *dir)
-{
-	return 0;
-}
 #endif /*CONFIG_IWLWIFI_DEBUGFS */
 
 static u32 iwl_trans_pcie_get_cmdlen(struct iwl_tfd *tfd)
@@ -2473,8 +2465,6 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.txq_disable = iwl_trans_pcie_txq_disable,
 	.txq_enable = iwl_trans_pcie_txq_enable,
 
-	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
-
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_txq_empty,
 	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
 
-- 
2.5.0

