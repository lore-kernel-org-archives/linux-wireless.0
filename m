Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab1FRQFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/25] iwlagn: add a get_irq method to iwl_bus_ops and use it
Date: Sat, 18 Jun 2011 08:34:20 -0700
Message-Id: <1308411271-26093-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180542_721589_98ABFCFE)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In order to remove a few more dereference to priv->pdev that will be killed
[Asoon, there is now a method to get the IRQ number.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl-agn.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-pci.c |    6 ++++++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1ff8e4b..e2b319f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3610,10 +3610,11 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	 ********************/
 	iwl_alloc_isr_ict(priv);
 
-	err = request_irq(priv->pci_dev->irq, iwl_isr_ict,
+	err = request_irq(priv->bus.ops->get_irq(&priv->bus), iwl_isr_ict,
 			  IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
-		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
+		IWL_ERR(priv, "Error allocating IRQ %d\n",
+			priv->bus.ops->get_irq(&priv->bus));
 		goto out_uninit_drv;
 	}
 
@@ -3650,7 +3651,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
  out_destroy_workqueue:
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
-	free_irq(priv->pci_dev->irq, priv);
+	free_irq(priv->bus.ops->get_irq(&priv->bus), priv);
 	iwl_free_isr_ict(priv);
  out_uninit_drv:
 	iwl_uninit_drv(priv);
@@ -3722,7 +3723,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	priv->workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
-	free_irq(priv->pci_dev->irq, priv);
+	free_irq(priv->bus.ops->get_irq(&priv->bus), priv);
 	priv->bus.ops->set_drv_data(&priv->bus, NULL);
 
 	iwl_uninit_drv(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 3463869..848a6c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -125,7 +125,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data);
 static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 {
 	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(priv->pci_dev->irq);
+	synchronize_irq(priv->bus.ops->get_irq(&priv->bus));
 	tasklet_kill(&priv->irq_tasklet);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1099944..f6b54c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1198,6 +1198,7 @@ struct iwl_bus;
  * @apm_config: will be called during the config of the APM configuration
  * @set_drv_data: set the priv pointer to the bus layer
  * @get_dev: returns the device struct
+ * @get_irq: returns the irq number
  * @get_hw_id: prints the hw_id in the provided buffer
  * @write8: write a byte to register at offset ofs
  * @write32: write a dword to register at offset ofs
@@ -1208,6 +1209,7 @@ struct iwl_bus_ops {
 	void (*apm_config)(struct iwl_bus *bus);
 	void (*set_drv_data)(struct iwl_bus *bus, void *priv);
 	struct device *(*get_dev)(const struct iwl_bus *bus);
+	unsigned int (*get_irq)(const struct iwl_bus *bus);
 	void (*get_hw_id)(struct iwl_bus *bus, char buf[], int buf_len);
 	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
 	void (*write32)(struct iwl_bus *bus, u32 ofs, u32 val);
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index adbc962..7328fbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -141,6 +141,11 @@ static struct device *iwl_pci_get_dev(const struct iwl_bus *bus)
 	return &(IWL_BUS_GET_PCI_DEV(bus)->dev);
 }
 
+static unsigned int iwl_pci_get_irq(const struct iwl_bus *bus)
+{
+	return IWL_BUS_GET_PCI_DEV(bus)->irq;
+}
+
 static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
 			      int buf_len)
 {
@@ -171,6 +176,7 @@ static struct iwl_bus_ops pci_ops = {
 	.apm_config = iwl_pci_apm_config,
 	.set_drv_data = iwl_pci_set_drv_data,
 	.get_dev = iwl_pci_get_dev,
+	.get_irq = iwl_pci_get_irq,
 	.get_hw_id = iwl_pci_get_hw_id,
 	.write8 = iwl_pci_write8,
 	.write32 = iwl_pci_write32,
-- 
1.7.0.4

