Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab2DWVxA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:53:00 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 26/29] iwlwifi: use direct calls for transport free
Date: Mon, 23 Apr 2012 14:47:37 -0700
Message-Id: <1335217660-21950-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235316_610090_6B57068F)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the transport allocates and frees itself in
the transport specific code, there's no need for
virtual functions for it. Remove the free method
and call the correct functions directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    5 ++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    6 +---
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   23 +--------------------
 4 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 49d2b18..e80e9aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -285,7 +285,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 out_free_trans:
-	iwl_trans_free(iwl_trans);
+	iwl_trans_pcie_free(iwl_trans);
 	pci_set_drvdata(pdev, NULL);
 	return -EFAULT;
 }
@@ -296,7 +296,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	iwl_drv_stop(trans_pcie->drv);
-	iwl_trans_free(trans);
+	iwl_trans_pcie_free(trans);
 
 	pci_set_drvdata(pdev, NULL);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 8a175e0..6213c05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -301,6 +301,11 @@ iwl_trans_pcie_get_trans(struct iwl_trans_pcie *trans_pcie)
 			    trans_specific);
 }
 
+struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
+				       const struct pci_device_id *ent,
+				       const struct iwl_cfg *cfg);
+void iwl_trans_pcie_free(struct iwl_trans *trans);
+
 /*****************************************************
 * RX
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index b6522ca..3eab7d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1549,7 +1549,7 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	trans_pcie->command_names = trans_cfg->command_names;
 }
 
-static void iwl_trans_pcie_free(struct iwl_trans *trans)
+void iwl_trans_pcie_free(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -2044,7 +2044,7 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 
 #endif /*CONFIG_IWLWIFI_DEBUGFS */
 
-const struct iwl_trans_ops trans_ops_pcie = {
+static const struct iwl_trans_ops trans_ops_pcie = {
 	.start_hw = iwl_trans_pcie_start_hw,
 	.stop_hw = iwl_trans_pcie_stop_hw,
 	.fw_alive = iwl_trans_pcie_fw_alive,
@@ -2061,8 +2061,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.tx_agg_disable = iwl_trans_pcie_tx_agg_disable,
 	.tx_agg_setup = iwl_trans_pcie_tx_agg_setup,
 
-	.free = iwl_trans_pcie_free,
-
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
 
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_tx_queue_empty,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index ba3c09d..7018d31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -354,10 +354,6 @@ struct iwl_trans;
  *	May sleep
  * @tx_agg_disable: de-configure a Tx queue to send AMPDUs
  *	Must be atomic
- * @free: release all the ressource for the transport layer itself such as
- *	irq, tasklet etc... From this point on, the device may not issue
- *	any interrupt (incl. RFKILL).
- *	May sleep
  * @wait_tx_queue_empty: wait until all tx queues are empty
  *	May sleep
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
@@ -393,8 +389,6 @@ struct iwl_trans_ops {
 			     int sta_id, int tid, int frame_limit, u16 ssn);
 	void (*tx_agg_disable)(struct iwl_trans *trans, int queue);
 
-	void (*free)(struct iwl_trans *trans);
-
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans);
 #ifdef CONFIG_PM_SLEEP
@@ -564,11 +558,6 @@ static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans, int queue,
 				 frame_limit, ssn);
 }
 
-static inline void iwl_trans_free(struct iwl_trans *trans)
-{
-	trans->ops->free(trans);
-}
-
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 {
 	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
@@ -616,19 +605,9 @@ static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
 }
 
 /*****************************************************
-* Transport layers implementations + their allocation function
+* driver (transport) register/unregister functions
 ******************************************************/
-struct pci_dev;
-struct pci_device_id;
-extern const struct iwl_trans_ops trans_ops_pcie;
-struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
-				       const struct pci_device_id *ent,
-				       const struct iwl_cfg *cfg);
 int __must_check iwl_pci_register_driver(void);
 void iwl_pci_unregister_driver(void);
 
-extern const struct iwl_trans_ops trans_ops_idi;
-struct iwl_trans *iwl_trans_idi_alloc(void *pdev_void,
-				      const void *ent_void,
-				      const struct iwl_cfg *cfg);
 #endif /* __iwl_trans_h__ */
-- 
1.7.0.4

