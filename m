Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab1HMSS3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/60] iwlagn: introduce struct iwl-shared - known by all layers
Date: Sat, 13 Aug 2011 10:37:41 -0700
Message-Id: <1313257116-2697-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201837_836306_1182CDFC)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This struct will hold pointers to all the layers, so that every layer will find
the pointers it needs when calling another layer.

Note that the drv_data set to struct device is now a pointer to
struct iwl_shared.
This solves of bug that I introduced in

	iwlagn: simplify the bus architecture

Bug description:

sysfs gets the the driver data from struct device. Till the aforementioned
patch, dev_get_drvdata would return iwl_priv. After the patch, dev_get_drvdata
return iwl_bus which is buggy since the sysfs handlers rely on this value, and
sysfs handlers need iwl_priv.

Now, dev_get_drvdata return iwl-shared. Since we have pointers to all the
layers in iwl_shared, every layer will be able to get the pointer it needs:
bus layer will gets iwl_bus from the PCI suspend callbacks, and the sysfs
handlers will get the iwl_priv they need.

In order to keep good encapsulation, we need to avoid to dereference iwl_priv
from a different layer. This is why instead of including iwl-dev.h from
iwl-shared.h, I added a forward declaration to iwl_priv. Moreover we keep type
safety while providing encapsulation.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   15 ++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-bus.h    |   12 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-pci.c    |   24 ++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-shared.h |   16 ++++++++++++++++
 5 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0e4ef47..8fdc883 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -474,14 +474,15 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 static ssize_t show_debug_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	return sprintf(buf, "0x%08X\n", iwl_get_debug_level(priv));
+	struct iwl_shared *shrd = dev_get_drvdata(d);
+	return sprintf(buf, "0x%08X\n", iwl_get_debug_level(shrd->priv));
 }
 static ssize_t store_debug_level(struct device *d,
 				struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl_shared *shrd = dev_get_drvdata(d);
+	struct iwl_priv *priv = shrd->priv;
 	unsigned long val;
 	int ret;
 
@@ -507,7 +508,8 @@ static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
 static ssize_t show_temperature(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
-	struct iwl_priv *priv = dev_get_drvdata(d);
+	struct iwl_shared *shrd = dev_get_drvdata(d);
+	struct iwl_priv *priv = shrd->priv;
 
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
@@ -3666,7 +3668,10 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 
 	priv = hw->priv;
 	priv->bus = bus;
-	bus_set_drv_data(priv->bus, priv);
+	priv->shrd = &priv->_shrd;
+	priv->shrd->bus = bus;
+	priv->shrd->priv = priv;
+	bus_set_drv_data(priv->bus, priv->shrd);
 
 	/* At this point both hw and priv are allocated. */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index f3ee1c0..a698004 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -63,13 +63,14 @@
 #ifndef __iwl_pci_h__
 #define __iwl_pci_h__
 
+struct iwl_shared;
 struct iwl_bus;
 
 /**
  * struct iwl_bus_ops - bus specific operations
  * @get_pm_support: must returns true if the bus can go to sleep
  * @apm_config: will be called during the config of the APM configuration
- * @set_drv_data: set the drv_data pointer to the bus layer
+ * @set_drv_data: set the shared data pointer to the bus layer
  * @get_hw_id: prints the hw_id in the provided buffer
  * @write8: write a byte to register at offset ofs
  * @write32: write a dword to register at offset ofs
@@ -78,7 +79,7 @@ struct iwl_bus;
 struct iwl_bus_ops {
 	bool (*get_pm_support)(struct iwl_bus *bus);
 	void (*apm_config)(struct iwl_bus *bus);
-	void (*set_drv_data)(struct iwl_bus *bus, void *drv_data);
+	void (*set_drv_data)(struct iwl_bus *bus, struct iwl_shared *shrd);
 	void (*get_hw_id)(struct iwl_bus *bus, char buf[], int buf_len);
 	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
 	void (*write32)(struct iwl_bus *bus, u32 ofs, u32 val);
@@ -87,9 +88,9 @@ struct iwl_bus_ops {
 
 struct iwl_bus {
 	/* Common data to all buses */
-	void *drv_data; /* driver's context */
 	struct device *dev;
 	struct iwl_bus_ops *ops;
+	struct iwl_shared *shrd;
 
 	unsigned int irq;
 
@@ -108,9 +109,10 @@ static inline void bus_apm_config(struct iwl_bus *bus)
 	bus->ops->apm_config(bus);
 }
 
-static inline void bus_set_drv_data(struct iwl_bus *bus, void *drv_data)
+static inline void bus_set_drv_data(struct iwl_bus *bus,
+				struct iwl_shared *shrd)
 {
-	bus->ops->set_drv_data(bus, drv_data);
+	bus->ops->set_drv_data(bus, shrd);
 }
 
 static inline void bus_get_hw_id(struct iwl_bus *bus, char buf[], int buf_len)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b2e5ca7..d772df6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1212,6 +1212,10 @@ struct iwl_testmode_trace {
 
 struct iwl_priv {
 
+	/*data shared among all the driver's layers */
+	struct iwl_shared _shrd;
+	struct iwl_shared *shrd;
+
 	/* ieee device used by generic ieee processing code */
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index be8102a..3b7efd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -123,20 +123,21 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
 				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
 		/* L1-ASPM enabled; disable(!) L0S */
-		iwl_set_bit(bus->drv_data, CSR_GIO_REG,
+		iwl_set_bit(priv(bus), CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
 		dev_printk(KERN_INFO, bus->dev, "L1 Enabled; Disabling L0S\n");
 	} else {
 		/* L1-ASPM disabled; enable(!) L0S */
-		iwl_clear_bit(bus->drv_data, CSR_GIO_REG,
+		iwl_clear_bit(priv(bus), CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
 		dev_printk(KERN_INFO, bus->dev, "L1 Disabled; Enabling L0S\n");
 	}
 }
 
-static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_data)
+static void iwl_pci_set_drv_data(struct iwl_bus *bus, struct iwl_shared *shrd)
 {
-	bus->drv_data = drv_data;
+	bus->shrd = shrd;
+	pci_set_drvdata(IWL_BUS_GET_PCI_DEV(bus), shrd);
 }
 
 static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
@@ -457,8 +458,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 	}
 
-	pci_set_drvdata(pdev, bus);
-
 	bus->dev = &pdev->dev;
 	bus->irq = pdev->irq;
 	bus->ops = &pci_ops;
@@ -497,9 +496,10 @@ static void iwl_pci_down(struct iwl_bus *bus)
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_shared *shrd = pci_get_drvdata(pdev);
+	struct iwl_bus *bus = shrd->bus;
 
-	iwl_remove(bus->drv_data);
+	iwl_remove(shrd->priv);
 
 	iwl_pci_down(bus);
 }
@@ -509,20 +509,20 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 static int iwl_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_shared *shrd = pci_get_drvdata(pdev);
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
 	 * WoWLAN is enabled - don't kill the NIC, someone may need it in Sx.
 	 */
 
-	return iwl_suspend(bus->drv_data);
+	return iwl_suspend(shrd->priv);
 }
 
 static int iwl_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
+	struct iwl_shared *shrd = pci_get_drvdata(pdev);
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
@@ -535,7 +535,7 @@ static int iwl_pci_resume(struct device *device)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	return iwl_resume(bus->drv_data);
+	return iwl_resume(shrd->priv);
 }
 
 static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 5d48d05..32744a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -64,6 +64,7 @@
 #define __iwl_shared_h__
 
 struct iwl_cfg;
+struct iwl_bus;
 struct iwl_priv;
 
 extern struct iwl_mod_params iwlagn_mod_params;
@@ -89,6 +90,21 @@ struct iwl_mod_params {
 	int wanted_ucode_alternative;
 };
 
+/**
+ * struct iwl_shared - shared fields for all the layers of the driver
+ *
+ * @bus: pointer to the bus layer data
+ * @priv: pointer to the upper layer data
+ */
+struct iwl_shared {
+	struct iwl_bus *bus;
+	struct iwl_priv *priv;
+};
+
+/*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
+#define priv(_m)	((_m)->shrd->priv)
+#define bus(_m)		((_m)->shrd->bus)
+
 #ifdef CONFIG_PM
 int iwl_suspend(struct iwl_priv *priv);
 int iwl_resume(struct iwl_priv *priv);
-- 
1.7.0.4

