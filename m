Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab1FRQF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/25] iwlagn: add get_dev to iwl_bus_ops
Date: Sat, 18 Jun 2011 08:34:14 -0700
Message-Id: <1308411271-26093-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180616_565478_12B2AFBE)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Bus specific layer must know how to return the struct device* of the device.
Implement that as a callback of iwl_bus_ops and use that callback instead of
using the priv->pdev pointer which is meant to disappear soon.

Since the struct device * is needed in hot path, iwl_bus holds a pointer to it
instead of calling get_dev all the time.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    7 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |    7 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   53 +++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    3 ++
 drivers/net/wireless/iwlwifi/iwl-led.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c     |    6 +++
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c      |    6 ++--
 11 files changed, 60 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index 0d5fda4..f1b40ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -44,7 +44,7 @@
 void iwl_free_isr_ict(struct iwl_priv *priv)
 {
 	if (priv->_agn.ict_tbl_vir) {
-		dma_free_coherent(&priv->pci_dev->dev,
+		dma_free_coherent(priv->bus.dev,
 				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
 				  priv->_agn.ict_tbl_vir,
 				  priv->_agn.ict_tbl_dma);
@@ -61,7 +61,7 @@ int iwl_alloc_isr_ict(struct iwl_priv *priv)
 
 	/* allocate shrared data table */
 	priv->_agn.ict_tbl_vir =
-		dma_alloc_coherent(&priv->pci_dev->dev,
+		dma_alloc_coherent(priv->bus.dev,
 				   (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
 				   &priv->_agn.ict_tbl_dma, GFP_KERNEL);
 	if (!priv->_agn.ict_tbl_vir)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 99d473f..4c11edc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -966,9 +966,10 @@ void iwlagn_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 		}
 	}
 
-	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			  rxq->bd_dma);
-	dma_free_coherent(&priv->pci_dev->dev, sizeof(struct iwl_rb_status),
+	dma_free_coherent(priv->bus.dev, 4 * RX_QUEUE_SIZE,
+			  rxq->bd, rxq->bd_dma);
+	dma_free_coherent(priv->bus.dev,
+			  sizeof(struct iwl_rb_status),
 			  rxq->rb_stts, rxq->rb_stts_dma);
 	rxq->bd = NULL;
 	rxq->rb_stts  = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 8bd48f6..f4e5ede 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -834,8 +834,8 @@ drop_unlock_priv:
 static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
 				    struct iwl_dma_ptr *ptr, size_t size)
 {
-	ptr->addr = dma_alloc_coherent(&priv->pci_dev->dev, size, &ptr->dma,
-				       GFP_KERNEL);
+	ptr->addr = dma_alloc_coherent(priv->bus.dev, size,
+				       &ptr->dma, GFP_KERNEL);
 	if (!ptr->addr)
 		return -ENOMEM;
 	ptr->size = size;
@@ -848,7 +848,8 @@ static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
 	if (unlikely(!ptr->addr))
 		return;
 
-	dma_free_coherent(&priv->pci_dev->dev, ptr->size, ptr->addr, ptr->dma);
+	dma_free_coherent(priv->bus.dev,
+			  ptr->size, ptr->addr, ptr->dma);
 	memset(ptr, 0, sizeof(*ptr));
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1eeb4a7..0098245 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -937,22 +937,28 @@ static struct attribute_group iwl_attribute_group = {
  *
  ******************************************************************************/
 
-static void iwl_free_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc)
+static void iwl_free_fw_desc(struct iwl_priv *priv, struct fw_desc *desc)
 {
 	if (desc->v_addr)
-		dma_free_coherent(&pci_dev->dev, desc->len,
+		dma_free_coherent(priv->bus.dev, desc->len,
 				  desc->v_addr, desc->p_addr);
 	desc->v_addr = NULL;
 	desc->len = 0;
 }
 
-static void iwl_free_fw_img(struct pci_dev *pci_dev, struct fw_img *img)
+static void iwl_free_fw_img(struct iwl_priv *priv, struct fw_img *img)
 {
-	iwl_free_fw_desc(pci_dev, &img->code);
-	iwl_free_fw_desc(pci_dev, &img->data);
+	iwl_free_fw_desc(priv, &img->code);
+	iwl_free_fw_desc(priv, &img->data);
 }
 
-static int iwl_alloc_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc,
+static void iwl_dealloc_ucode(struct iwl_priv *priv)
+{
+	iwl_free_fw_img(priv, &priv->ucode_rt);
+	iwl_free_fw_img(priv, &priv->ucode_init);
+}
+
+static int iwl_alloc_fw_desc(struct iwl_priv *priv, struct fw_desc *desc,
 			     const void *data, size_t len)
 {
 	if (!len) {
@@ -960,21 +966,16 @@ static int iwl_alloc_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc,
 		return -EINVAL;
 	}
 
-	desc->v_addr = dma_alloc_coherent(&pci_dev->dev, len,
+	desc->v_addr = dma_alloc_coherent(priv->bus.dev, len,
 					  &desc->p_addr, GFP_KERNEL);
 	if (!desc->v_addr)
 		return -ENOMEM;
+
 	desc->len = len;
 	memcpy(desc->v_addr, data, len);
 	return 0;
 }
 
-static void iwl_dealloc_ucode_pci(struct iwl_priv *priv)
-{
-	iwl_free_fw_img(priv->pci_dev, &priv->ucode_rt);
-	iwl_free_fw_img(priv->pci_dev, &priv->ucode_init);
-}
-
 struct iwlagn_ucode_capabilities {
 	u32 max_probe_length;
 	u32 standard_phy_calibration_size;
@@ -1019,8 +1020,8 @@ static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 		       priv->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, priv->firmware_name,
-				       &priv->pci_dev->dev, GFP_KERNEL, priv,
-				       iwl_ucode_callback);
+				       priv->bus.dev,
+				       GFP_KERNEL, priv, iwl_ucode_callback);
 }
 
 struct iwlagn_firmware_pieces {
@@ -1441,19 +1442,19 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
-	if (iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_rt.code,
+	if (iwl_alloc_fw_desc(priv, &priv->ucode_rt.code,
 			      pieces.inst, pieces.inst_size))
 		goto err_pci_alloc;
-	if (iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_rt.data,
+	if (iwl_alloc_fw_desc(priv, &priv->ucode_rt.data,
 			      pieces.data, pieces.data_size))
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
 	if (pieces.init_size && pieces.init_data_size) {
-		if (iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init.code,
+		if (iwl_alloc_fw_desc(priv, &priv->ucode_init.code,
 				      pieces.init, pieces.init_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init.data,
+		if (iwl_alloc_fw_desc(priv, &priv->ucode_init.data,
 				      pieces.init_data, pieces.init_data_size))
 			goto err_pci_alloc;
 	}
@@ -1522,7 +1523,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	if (err)
 		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
 
-	err = sysfs_create_group(&priv->pci_dev->dev.kobj,
+	err = sysfs_create_group(&(priv->bus.dev->kobj),
 					&iwl_attribute_group);
 	if (err) {
 		IWL_ERR(priv, "failed to create sysfs device attributes\n");
@@ -1543,10 +1544,10 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
  err_pci_alloc:
 	IWL_ERR(priv, "failed to allocate pci memory\n");
-	iwl_dealloc_ucode_pci(priv);
+	iwl_dealloc_ucode(priv);
  out_unbind:
 	complete(&priv->_agn.firmware_loading_complete);
-	device_release_driver(&priv->pci_dev->dev);
+	device_release_driver(priv->bus.dev);
 	release_firmware(ucode_raw);
 }
 
@@ -3507,10 +3508,11 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	priv->bus.bus_specific = bus_specific;
 	priv->bus.ops = bus_ops;
 	priv->bus.ops->set_drv_data(&priv->bus, priv);
+	priv->bus.dev = priv->bus.ops->get_dev(&priv->bus);
 
 	/* At this point both hw and priv are allocated. */
 
-	SET_IEEE80211_DEV(hw, &pdev->dev);
+	SET_IEEE80211_DEV(hw, priv->bus.dev);
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
@@ -3735,7 +3737,8 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
 	iwl_dbgfs_unregister(priv);
-	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
+	sysfs_remove_group(&priv->bus.dev->kobj,
+			   &iwl_attribute_group);
 
 	/* ieee80211_unregister_hw call wil cause iwl_mac_stop to
 	 * to be called and iwl_down since we are removing the device
@@ -3765,7 +3768,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 
 	iwl_synchronize_irq(priv);
 
-	iwl_dealloc_ucode_pci(priv);
+	iwl_dealloc_ucode(priv);
 
 	if (priv->rxq.bd)
 		iwlagn_rx_queue_free(priv, &priv->rxq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index c844b51..eb95d1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -32,10 +32,10 @@
 struct iwl_priv;
 extern u32 iwl_debug_level;
 
-#define IWL_ERR(p, f, a...) dev_err(&((p)->pci_dev->dev), f, ## a)
-#define IWL_WARN(p, f, a...) dev_warn(&((p)->pci_dev->dev), f, ## a)
-#define IWL_INFO(p, f, a...) dev_info(&((p)->pci_dev->dev), f, ## a)
-#define IWL_CRIT(p, f, a...) dev_crit(&((p)->pci_dev->dev), f, ## a)
+#define IWL_ERR(p, f, a...) dev_err(p->bus.ops->get_dev(&p->bus), f, ## a)
+#define IWL_WARN(p, f, a...) dev_warn(p->bus.ops->get_dev(&p->bus), f, ## a)
+#define IWL_INFO(p, f, a...) dev_info(p->bus.ops->get_dev(&p->bus), f, ## a)
+#define IWL_CRIT(p, f, a...) dev_crit(p->bus.ops->get_dev(&p->bus), f, ## a)
 
 #define iwl_print_hex_error(priv, p, len) 				\
 do {									\
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8865514..49e6c68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1194,9 +1194,11 @@ struct iwl_bus;
 /**
  * struct iwl_bus_ops - bus specific operations
  * @set_drv_data: set the priv pointer to the bus layer
+ * @get_dev: returns the device struct
  */
 struct iwl_bus_ops {
 	void (*set_drv_data)(struct iwl_bus *bus, void *priv);
+	struct device *(*get_dev)(const struct iwl_bus *bus);
 };
 
 struct iwl_bus {
@@ -1205,6 +1207,7 @@ struct iwl_bus {
 
 	/* Common data to all buses */
 	struct iwl_priv *priv; /* driver's context */
+	struct device *dev;
 	struct iwl_bus_ops *ops;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 7ef2b23..ff08da0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -202,7 +202,8 @@ void iwl_leds_init(struct iwl_priv *priv)
 		break;
 	}
 
-	ret = led_classdev_register(&priv->pci_dev->dev, &priv->led);
+	ret = led_classdev_register(priv->bus.dev,
+				    &priv->led);
 	if (ret) {
 		kfree(priv->led.name);
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index ef9cb08..00458fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -86,8 +86,14 @@ static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_priv)
 	pci_set_drvdata(IWL_BUS_GET_PCI_DEV(bus), drv_priv);
 }
 
+static struct device *iwl_pci_get_dev(const struct iwl_bus *bus)
+{
+	return &(IWL_BUS_GET_PCI_DEV(bus)->dev);
+}
+
 static struct iwl_bus_ops pci_ops = {
 	.set_drv_data = iwl_pci_set_drv_data,
+	.get_dev = iwl_pci_get_dev,
 };
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b774517..3efa706 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -182,7 +182,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q
 int iwl_rx_queue_alloc(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
-	struct device *dev = &priv->pci_dev->dev;
+	struct device *dev = priv->bus.dev;
 	int i;
 
 	spin_lock_init(&rxq->lock);
@@ -213,7 +213,7 @@ int iwl_rx_queue_alloc(struct iwl_priv *priv)
 	return 0;
 
 err_rb:
-	dma_free_coherent(&priv->pci_dev->dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+	dma_free_coherent(dev, 4 * RX_QUEUE_SIZE, rxq->bd,
 			  rxq->bd_dma);
 err_bd:
 	return -ENOMEM;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 6f62642..c00aa5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -180,7 +180,7 @@ void iwl_testmode_init(struct iwl_priv *priv)
 
 static void iwl_trace_cleanup(struct iwl_priv *priv)
 {
-	struct device *dev = &priv->pci_dev->dev;
+	struct device *dev = priv->bus.dev;
 
 	if (priv->testmode_trace.trace_enabled) {
 		if (priv->testmode_trace.cpu_addr &&
@@ -484,7 +484,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 	struct iwl_priv *priv = hw->priv;
 	struct sk_buff *skb;
 	int status = 0;
-	struct device *dev = &priv->pci_dev->dev;
+	struct device *dev = priv->bus.dev;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 1084fe0..f982ac9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -266,7 +266,7 @@ void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct device *dev = &priv->pci_dev->dev;
+	struct device *dev = priv->bus.dev;
 	int i;
 
 	iwl_tx_queue_unmap(priv, txq_id);
@@ -332,7 +332,7 @@ void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 void iwl_cmd_queue_free(struct iwl_priv *priv)
 {
 	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
-	struct device *dev = &priv->pci_dev->dev;
+	struct device *dev = priv->bus.dev;
 	int i;
 
 	iwl_cmd_queue_unmap(priv);
@@ -434,7 +434,7 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 			      struct iwl_tx_queue *txq, u32 id)
 {
-	struct device *dev = &priv->pci_dev->dev;
+	struct device *dev = priv->bus.dev;
 	size_t tfd_sz = priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX;
 
 	/* Driver private data, only for Tx (not command) queues,
-- 
1.7.0.4

