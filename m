Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab1FRQF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/25] iwlagn: introduce iwl_bus and iwl_bus_ops
Date: Sat, 18 Jun 2011 08:34:13 -0700
Message-Id: <1308411271-26093-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180617_121440_B495CDED)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_bus will represent a bus, and iwl_bus_ops all the operations that can be
done on this bus.
For the moment only set_prv_data is implemented. More to come...

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   28 ++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.h |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h |   23 ++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.c |   52 ++++++++++++++++++++++++++++++-
 4 files changed, 93 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d5eeb3e..1eeb4a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3479,7 +3479,8 @@ static void iwl_init_context(struct iwl_priv *priv)
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 }
 
-int iwl_probe(struct pci_dev *pdev, struct iwl_cfg *cfg)
+int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
+		struct iwl_cfg *cfg)
 {
 	int err = 0;
 	struct iwl_priv *priv;
@@ -3490,12 +3491,23 @@ int iwl_probe(struct pci_dev *pdev, struct iwl_cfg *cfg)
 	/************************
 	 * 1. Allocating HW data
 	 ************************/
+	/* TODO: remove this nasty hack when PCI encapsulation is done
+	 * assumes that struct pci_dev * is at the very beginning of whatever
+	 * is pointed by bus_specific */
+	unsigned long *ppdev = bus_specific;
+	struct pci_dev *pdev = (struct pci_dev *) *ppdev;
 
 	hw = iwl_alloc_all(cfg);
 	if (!hw) {
 		err = -ENOMEM;
 		goto out;	}
 	priv = hw->priv;
+
+	priv->bus.priv = priv;
+	priv->bus.bus_specific = bus_specific;
+	priv->bus.ops = bus_ops;
+	priv->bus.ops->set_drv_data(&priv->bus, priv);
+
 	/* At this point both hw and priv are allocated. */
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
@@ -3549,9 +3561,6 @@ int iwl_probe(struct pci_dev *pdev, struct iwl_cfg *cfg)
 	if (err)
 		goto out_pci_disable_device;
 
-	pci_set_drvdata(pdev, priv);
-
-
 	/***********************
 	 * 3. Read REV register
 	 ***********************/
@@ -3705,7 +3714,7 @@ int iwl_probe(struct pci_dev *pdev, struct iwl_cfg *cfg)
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
  out_pci_release_regions:
-	pci_set_drvdata(pdev, NULL);
+	priv->bus.ops->set_drv_data(&priv->bus, NULL);
 	pci_release_regions(pdev);
  out_pci_disable_device:
 	pci_disable_device(pdev);
@@ -3716,14 +3725,11 @@ int iwl_probe(struct pci_dev *pdev, struct iwl_cfg *cfg)
 	return err;
 }
 
-void __devexit iwl_remove(struct pci_dev *pdev)
+void __devexit iwl_remove(struct iwl_priv * priv)
 {
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	struct pci_dev *pdev = priv->pci_dev;
 	unsigned long flags;
 
-	if (!priv)
-		return;
-
 	wait_for_completion(&priv->_agn.firmware_loading_complete);
 
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
@@ -3783,7 +3789,7 @@ void __devexit iwl_remove(struct pci_dev *pdev)
 	pci_iounmap(pdev, priv->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
+	priv->bus.ops->set_drv_data(&priv->bus, NULL);
 
 	iwl_uninit_drv(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 9dab387..3463869 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -379,7 +379,8 @@ void iwl_testmode_cleanup(struct iwl_priv *priv)
 }
 #endif
 
-int iwl_probe(struct pci_dev *pdev, struct iwl_cfg *cfg);
-void iwl_remove(struct pci_dev *pdev);
+int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
+		struct iwl_cfg *cfg);
+void __devexit iwl_remove(struct iwl_priv * priv);
 
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 59316fb..8865514 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1188,6 +1188,26 @@ struct iwl_testmode_trace {
 	bool trace_enabled;
 };
 #endif
+
+struct iwl_bus;
+
+/**
+ * struct iwl_bus_ops - bus specific operations
+ * @set_drv_data: set the priv pointer to the bus layer
+ */
+struct iwl_bus_ops {
+	void (*set_drv_data)(struct iwl_bus *bus, void *priv);
+};
+
+struct iwl_bus {
+	/* pointer to bus specific struct */
+	void *bus_specific;
+
+	/* Common data to all buses */
+	struct iwl_priv *priv; /* driver's context */
+	struct iwl_bus_ops *ops;
+};
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1255,12 +1275,15 @@ struct iwl_priv {
 	spinlock_t reg_lock;	/* protect hw register access */
 	struct mutex mutex;
 
+	/* TODO: remove this after PCI abstraction is done */
 	/* basic pci-network driver stuff */
 	struct pci_dev *pci_dev;
 
 	/* pci hardware address support */
 	void __iomem *hw_base;
 
+	struct iwl_bus bus;	/* bus specific data */
+
 	/* microcode/device supports multiple contexts */
 	u8 valid_contexts;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index d930be4..ef9cb08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -67,6 +67,29 @@
 #include "iwl-agn.h"
 #include "iwl-core.h"
 
+struct iwl_pci_bus {
+	/* basic pci-network driver stuff */
+	struct pci_dev *pci_dev;
+
+	/* pci hardware address support */
+	void __iomem *hw_base;
+};
+
+#define IWL_BUS_GET_PCI_BUS(_iwl_bus) \
+			((struct iwl_pci_bus *) ((_iwl_bus)->bus_specific))
+
+#define IWL_BUS_GET_PCI_DEV(_iwl_bus) \
+			((IWL_BUS_GET_PCI_BUS(_iwl_bus))->pci_dev)
+
+static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_priv)
+{
+	pci_set_drvdata(IWL_BUS_GET_PCI_DEV(bus), drv_priv);
+}
+
+static struct iwl_bus_ops pci_ops = {
+	.set_drv_data = iwl_pci_set_drv_data,
+};
+
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
@@ -266,13 +289,38 @@ MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
-
-	return iwl_probe(pdev, cfg);
+	struct iwl_pci_bus *bus;
+	int err;
+
+	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
+	if (!bus) {
+		pr_err("Couldn't allocate iwl_pci_bus");
+		err = -ENOMEM;
+		goto out_no_pci;
+	}
+
+	bus->pci_dev = pdev;
+
+	err = iwl_probe((void *) bus, &pci_ops, cfg);
+	if (err)
+		goto out_no_pci;
+	return 0;
+
+out_no_pci:
+	kfree(bus);
+	return err;
 }
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	iwl_remove(pdev);
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
+
+	/* This can happen if probe failed */
+	if (unlikely(!priv))
+		return;
+
+	iwl_remove(priv);
+	kfree(IWL_BUS_GET_PCI_BUS(&priv->bus));
 }
 
 #ifdef CONFIG_PM
-- 
1.7.0.4

