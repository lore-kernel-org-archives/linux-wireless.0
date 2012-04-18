Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab2DROpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/15] iwlwifi: kill shrd->drv, driver points to transport
Date: Wed, 18 Apr 2012 07:41:03 -0700
Message-Id: <1334760077-5714-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_164551_658452_94EA1D48)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The driver layer now holds a pointer to the transport,
and shrd->drv is not needed any more, so kill it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c            |   22 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-drv.h            |   10 ++++--
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   33 ++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    7 ----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +
 5 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 17485e7..8e29621 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -88,6 +88,7 @@ struct iwl_drv {
 
 	struct iwl_shared *shrd;
 	struct iwl_op_mode *op_mode;
+	struct iwl_trans *trans;
 
 	int fw_index;                   /* firmware we're trying to load */
 	char firmware_name[25];         /* name of firmware file to load */
@@ -858,7 +859,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 	complete(&drv->request_firmware_complete);
 
-	drv->op_mode = iwl_dvm_ops.start(drv->shrd->trans, &drv->fw);
+	drv->op_mode = iwl_dvm_ops.start(drv->trans, &drv->fw);
 
 	if (!drv->op_mode)
 		goto out_unbind;
@@ -881,8 +882,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	device_release_driver(trans(drv)->dev);
 }
 
-int iwl_drv_start(struct iwl_shared *shrd,
-		  struct iwl_trans *trans, const struct iwl_cfg *cfg)
+struct iwl_drv *iwl_drv_start(struct iwl_shared *shrd,
+			      struct iwl_trans *trans,
+			      const struct iwl_cfg *cfg)
 {
 	struct iwl_drv *drv;
 	int ret;
@@ -892,10 +894,11 @@ int iwl_drv_start(struct iwl_shared *shrd,
 	drv = kzalloc(sizeof(*drv), GFP_KERNEL);
 	if (!drv) {
 		dev_printk(KERN_ERR, trans->dev, "Couldn't allocate iwl_drv");
-		return -ENOMEM;
+		return NULL;
 	}
+	/* For printing only - temporary until we change the logger */
 	drv->shrd = shrd;
-	shrd->drv = drv;
+	drv->trans = trans;
 
 	init_completion(&drv->request_firmware_complete);
 
@@ -904,16 +907,14 @@ int iwl_drv_start(struct iwl_shared *shrd,
 	if (ret) {
 		dev_printk(KERN_ERR, trans->dev, "Couldn't request the fw");
 		kfree(drv);
-		shrd->drv = NULL;
+		drv = NULL;
 	}
 
-	return ret;
+	return drv;
 }
 
-void iwl_drv_stop(struct iwl_shared *shrd)
+void iwl_drv_stop(struct iwl_drv *drv)
 {
-	struct iwl_drv *drv = shrd->drv;
-
 	wait_for_completion(&drv->request_firmware_complete);
 
 	/* op_mode can be NULL if its start failed */
@@ -923,5 +924,4 @@ void iwl_drv_stop(struct iwl_shared *shrd)
 	iwl_dealloc_ucode(drv);
 
 	kfree(drv);
-	shrd->drv = NULL;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index 3b771c1..290a368 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -90,6 +90,7 @@
  * 8) iwl_ucode_callback starts the wifi implementation to matches the fw
  */
 
+struct iwl_drv;
 /**
  * iwl_drv_start - start the drv
  *
@@ -102,10 +103,11 @@
  * starts the driver: fetches the firmware. This should be called by bus
  * specific system flows implementations. For example, the bus specific probe
  * function should do bus related operations only, and then call to this
- * function.
+ * function. It returns the driver object or %NULL if an error occured.
  */
-int iwl_drv_start(struct iwl_shared *shrd,
-		  struct iwl_trans *trans, const struct iwl_cfg *cfg);
+struct iwl_drv *iwl_drv_start(struct iwl_shared *shrd,
+			      struct iwl_trans *trans,
+			      const struct iwl_cfg *cfg);
 
 /**
  * iwl_drv_stop - stop the drv
@@ -118,6 +120,6 @@ int iwl_drv_start(struct iwl_shared *shrd,
  * implementations. For example, the bus specific remove function should first
  * call this function and then do the bus related operations only.
  */
-void iwl_drv_stop(struct iwl_shared *shrd);
+void iwl_drv_stop(struct iwl_drv *drv);
 
 #endif /* __iwl_drv_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 7540015..00a6dda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -72,6 +72,7 @@
 #include "iwl-cfg.h"
 #include "iwl-drv.h"
 #include "iwl-trans.h"
+#include "iwl-trans-pcie-int.h"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
@@ -262,11 +263,14 @@ MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
 
+#ifndef CONFIG_IWLWIFI_IDI
+
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	const struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	struct iwl_shared *shrd;
 	struct iwl_trans *iwl_trans;
+	struct iwl_trans_pcie *trans_pcie;
 	int err;
 
 	shrd = kzalloc(sizeof(*iwl_trans->shrd), GFP_KERNEL);
@@ -277,11 +281,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_free_bus;
 	}
 
-#ifdef CONFIG_IWLWIFI_IDI
-	iwl_trans = iwl_trans_idi_alloc(shrd, pdev, ent);
-#else
 	iwl_trans = iwl_trans_pcie_alloc(shrd, pdev, ent);
-#endif
 	if (iwl_trans == NULL) {
 		err = -ENOMEM;
 		goto out_free_bus;
@@ -290,8 +290,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	shrd->trans = iwl_trans;
 	pci_set_drvdata(pdev, iwl_trans);
 
-	err = iwl_drv_start(shrd, iwl_trans, cfg);
-	if (err)
+	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(iwl_trans);
+	trans_pcie->drv = iwl_drv_start(shrd, iwl_trans, cfg);
+	if (!trans_pcie->drv)
 		goto out_free_trans;
 
 	return 0;
@@ -306,17 +307,20 @@ out_free_bus:
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_trans *iwl_trans = pci_get_drvdata(pdev);
-	struct iwl_shared *shrd = iwl_trans->shrd;
+	struct iwl_trans *trans = pci_get_drvdata(pdev);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_shared *shrd = trans->shrd;
 
-	iwl_drv_stop(shrd);
-	iwl_trans_free(shrd->trans);
+	iwl_drv_stop(trans_pcie->drv);
+	iwl_trans_free(trans);
 
 	pci_set_drvdata(pdev, NULL);
 
 	kfree(shrd);
 }
 
+#endif /* CONFIG_IWLWIFI_IDI */
+
 #ifdef CONFIG_PM_SLEEP
 
 static int iwl_pci_suspend(struct device *device)
@@ -361,6 +365,15 @@ static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
 
 #endif
 
+#ifdef CONFIG_IWLWIFI_IDI
+/*
+ * Defined externally in iwl-idi.c
+ */
+int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+void __devexit iwl_pci_remove(struct pci_dev *pdev);
+
+#endif /* CONFIG_IWLWIFI_IDI */
+
 static struct pci_driver iwl_pci_driver = {
 	.name = DRV_NAME,
 	.id_table = iwl_hw_card_ids,
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 35bd83c..d519487 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -150,19 +150,12 @@ struct iwl_mod_params {
 /**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
- * @wowlan: are we running wowlan uCode
- * @bus: pointer to the bus layer data
  * @cfg: see struct iwl_cfg
- * @priv: pointer to the upper layer data
  * @trans: pointer to the transport layer data
- * @nic: pointer to the nic data
- * @lock: protect general shared data
- * @eeprom: pointer to the eeprom/OTP image
  */
 struct iwl_shared {
 	const struct iwl_cfg *cfg;
 	struct iwl_trans *trans;
-	void *drv;
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 70bdd0e..22e84f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -215,6 +215,7 @@ struct iwl_tx_queue {
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
  * @rx_replenish: work that will be called when buffers need to be allocated
+ * @drv - pointer to iwl_drv
  * @trans: pointer to the generic transport area
  * @irq - the irq number for the device
  * @irq_requested: true when the irq has been requested
@@ -235,6 +236,7 @@ struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
 	struct work_struct rx_replenish;
 	struct iwl_trans *trans;
+	struct iwl_drv *drv;
 
 	/* INT ICT Table */
 	__le32 *ict_tbl;
-- 
1.7.0.4

