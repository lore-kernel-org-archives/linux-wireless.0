Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab2DROpv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/15] iwlwifi: remove the shared area
Date: Wed, 18 Apr 2012 07:41:10 -0700
Message-Id: <1334760077-5714-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_164608_650086_DDB2A3DF)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is not needed any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h        |    2 -
 drivers/net/wireless/iwlwifi/iwl-drv.c        |    7 +----
 drivers/net/wireless/iwlwifi/iwl-drv.h        |   11 ++-----
 drivers/net/wireless/iwlwifi/iwl-pci.c        |   32 ++++----------------
 drivers/net/wireless/iwlwifi/iwl-shared.h     |   38 -------------------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    5 +--
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   10 ++----
 8 files changed, 16 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3f8b30d..948529f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1507,7 +1507,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	op_mode = hw->priv;
 	op_mode->ops = &iwl_dvm_ops;
 	priv = IWL_OP_MODE_GET_DVM(op_mode);
-	priv->shrd = trans->shrd;
 	priv->trans = trans;
 	priv->dev = trans->dev;
 	priv->cfg = cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 185289f..22386a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -758,8 +758,6 @@ struct iwl_wipan_noa_data {
 
 struct iwl_priv {
 
-	/*data shared among all the driver's layers */
-	struct iwl_shared *shrd;
 	struct iwl_trans *trans;
 	struct device *dev;		/* for debug prints only */
 	const struct iwl_cfg *cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 1221a8c..1219c0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -77,7 +77,6 @@
 /**
  * struct iwl_drv - drv common data
  * @fw: the iwl_fw structure
- * @shrd: pointer to common shared structure
  * @op_mode: the running op_mode
  * @trans: transport layer
  * @dev: for debug prints only
@@ -89,7 +88,6 @@
 struct iwl_drv {
 	struct iwl_fw fw;
 
-	struct iwl_shared *shrd;
 	struct iwl_op_mode *op_mode;
 	struct iwl_trans *trans;
 	struct device *dev;
@@ -885,8 +883,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	device_release_driver(drv->trans->dev);
 }
 
-struct iwl_drv *iwl_drv_start(struct iwl_shared *shrd,
-			      struct iwl_trans *trans,
+struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 			      const struct iwl_cfg *cfg)
 {
 	struct iwl_drv *drv;
@@ -897,8 +894,6 @@ struct iwl_drv *iwl_drv_start(struct iwl_shared *shrd,
 		dev_printk(KERN_ERR, trans->dev, "Couldn't allocate iwl_drv");
 		return NULL;
 	}
-	/* For printing only - temporary until we change the logger */
-	drv->shrd = shrd;
 	drv->trans = trans;
 	drv->dev = trans->dev;
 	drv->cfg = cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index 290a368..b673982 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -91,30 +91,25 @@
  */
 
 struct iwl_drv;
+struct iwl_trans;
 /**
  * iwl_drv_start - start the drv
  *
- * @shrd: the shrd area
  * @trans_ops: the ops of the transport
  * @cfg: device specific constants / virtual functions
  *
- * TODO: review the parameters given to this function
- *
  * starts the driver: fetches the firmware. This should be called by bus
  * specific system flows implementations. For example, the bus specific probe
  * function should do bus related operations only, and then call to this
  * function. It returns the driver object or %NULL if an error occured.
  */
-struct iwl_drv *iwl_drv_start(struct iwl_shared *shrd,
-			      struct iwl_trans *trans,
+struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 			      const struct iwl_cfg *cfg);
 
 /**
  * iwl_drv_stop - stop the drv
  *
- * @shrd: the shrd area
- *
- * TODO: review the parameters given to this function
+ * @drv:
  *
  * Stop the driver. This should be called by bus specific system flows
  * implementations. For example, the bus specific remove function should first
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 68974a9..47db96f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -268,30 +268,17 @@ MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	const struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
-	struct iwl_shared *shrd;
 	struct iwl_trans *iwl_trans;
 	struct iwl_trans_pcie *trans_pcie;
-	int err;
-
-	shrd = kzalloc(sizeof(*iwl_trans->shrd), GFP_KERNEL);
-	if (!shrd) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "Couldn't allocate iwl_shared");
-		err = -ENOMEM;
-		goto out_free_bus;
-	}
-
-	iwl_trans = iwl_trans_pcie_alloc(shrd, pdev, ent, cfg);
-	if (iwl_trans == NULL) {
-		err = -ENOMEM;
-		goto out_free_bus;
-	}
-
-	shrd->trans = iwl_trans;
+
+	iwl_trans = iwl_trans_pcie_alloc(pdev, ent, cfg);
+	if (iwl_trans == NULL)
+		return -ENOMEM;
+
 	pci_set_drvdata(pdev, iwl_trans);
 
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
-	trans_pcie->drv = iwl_drv_start(shrd, iwl_trans, cfg);
+	trans_pcie->drv = iwl_drv_start(iwl_trans, cfg);
 	if (!trans_pcie->drv)
 		goto out_free_trans;
 
@@ -300,23 +287,18 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_free_trans:
 	iwl_trans_free(iwl_trans);
 	pci_set_drvdata(pdev, NULL);
-out_free_bus:
-	kfree(shrd);
-	return err;
+	return -EFAULT;
 }
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_trans *trans = pci_get_drvdata(pdev);
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_shared *shrd = trans->shrd;
 
 	iwl_drv_stop(trans_pcie->drv);
 	iwl_trans_free(trans);
 
 	pci_set_drvdata(pdev, NULL);
-
-	kfree(shrd);
 }
 
 #endif /* CONFIG_IWLWIFI_IDI */
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 3ebe96e..8bb56f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -72,32 +72,6 @@
 #include "iwl-fw.h"
 #include "iwl-config.h"
 
-/**
- * DOC: shared area - role and goal
- *
- * The shared area contains all the data exported by the upper layer to the
- * other layers. Since the bus and transport layer shouldn't dereference
- * iwl_priv, all the data needed by the upper layer and the transport / bus
- * layer must be here.
- * The shared area also holds pointer to all the other layers. This allows a
- * layer to call a function from another layer.
- *
- * NOTE: All the layers hold a pointer to the shared area which must be shrd.
- *	A few macros assume that (_m)->shrd points to the shared area no matter
- *	what _m is.
- *
- * gets notifications about enumeration, suspend, resume.
- * For the moment, the bus layer is not a linux kernel module as itself, and
- * the module_init function of the driver must call the bus specific
- * registration functions. These functions are listed at the end of this file.
- * For the moment, there is only one implementation of this interface: PCI-e.
- * This implementation is iwl-pci.c
- */
-
-struct iwl_priv;
-struct iwl_trans;
-struct iwl_trans_ops;
-
 #define DRV_NAME        "iwlwifi"
 #define IWLWIFI_VERSION "in-tree:"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2012 Intel Corporation"
@@ -147,18 +121,6 @@ struct iwl_mod_params {
 	bool auto_agg;
 };
 
-/**
- * struct iwl_shared - shared fields for all the layers of the driver
- *
- * @trans: pointer to the transport layer data
- */
-struct iwl_shared {
-	struct iwl_trans *trans;
-};
-
-/*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
-#define trans(_m)	((_m)->shrd->trans)
-
 static inline bool iwl_have_debug_level(u32 level)
 {
 	return iwlagn_mod_params.debug_level & level;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 76f05ea..72ee1e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1567,7 +1567,6 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 	pci_release_regions(trans_pcie->pci_dev);
 	pci_disable_device(trans_pcie->pci_dev);
 
-	trans->shrd->trans = NULL;
 	kfree(trans);
 }
 
@@ -2083,8 +2082,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.set_pmi = iwl_trans_pcie_set_pmi,
 };
 
-struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
-				       struct pci_dev *pdev,
+struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				       const struct pci_device_id *ent,
 				       const struct iwl_cfg *cfg)
 {
@@ -2102,7 +2100,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	trans->ops = &trans_ops_pcie;
-	trans->shrd = shrd;
 	trans->cfg = cfg;
 	trans_pcie->trans = trans;
 	spin_lock_init(&trans_pcie->irq_lock);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 80e3399..b28de2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -326,6 +326,8 @@ struct iwl_trans_config {
 	const char **command_names;
 };
 
+struct iwl_trans;
+
 /**
  * struct iwl_trans_ops - transport specific operations
  *
@@ -428,7 +430,6 @@ enum iwl_trans_state {
  *
  * @ops - pointer to iwl_trans_ops
  * @op_mode - pointer to the op_mode
- * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  * @cfg - pointer to the configuration
  * @reg_lock - protect hw register access
  * @dev - pointer to struct device * that represents the device
@@ -441,7 +442,6 @@ enum iwl_trans_state {
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
 	struct iwl_op_mode *op_mode;
-	struct iwl_shared *shrd;
 	const struct iwl_cfg *cfg;
 	enum iwl_trans_state state;
 	spinlock_t reg_lock;
@@ -625,16 +625,14 @@ static inline void iwl_trans_set_pmi(struct iwl_trans *trans, bool state)
 struct pci_dev;
 struct pci_device_id;
 extern const struct iwl_trans_ops trans_ops_pcie;
-struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
-				       struct pci_dev *pdev,
+struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				       const struct pci_device_id *ent,
 				       const struct iwl_cfg *cfg);
 int __must_check iwl_pci_register_driver(void);
 void iwl_pci_unregister_driver(void);
 
 extern const struct iwl_trans_ops trans_ops_idi;
-struct iwl_trans *iwl_trans_idi_alloc(struct iwl_shared *shrd,
-				      void *pdev_void,
+struct iwl_trans *iwl_trans_idi_alloc(void *pdev_void,
 				      const void *ent_void,
 				      const struct iwl_cfg *cfg);
 #endif /* __iwl_trans_h__ */
-- 
1.7.0.4

