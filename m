Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab2BCAQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/28] iwlwifi: remove the pointer to dev from the bus layer
Date: Thu,  2 Feb 2012 15:09:00 -0800
Message-Id: <1328224159-18134-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011725_216451_DF3FA731)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-bus.h   |    2 --
 drivers/net/wireless/iwlwifi/iwl-debug.h |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-pci.c   |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-ucode.c |    4 ++--
 5 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f797915..d890b64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1146,7 +1146,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	iwl_dealloc_ucode(trans(priv));
  out_unbind:
 	complete(&priv->firmware_loading_complete);
-	device_release_driver(bus(priv)->dev);
+	device_release_driver(trans(priv)->dev);
 	release_firmware(ucode_raw);
 }
 
@@ -1785,7 +1785,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 
 	/* At this point both hw and priv are allocated. */
 
-	SET_IEEE80211_DEV(hw, bus(priv)->dev);
+	SET_IEEE80211_DEV(hw, trans(priv)->dev);
 
 	/* what debugging capabilities we have */
 	iwl_debug_config(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index ce1a9cc..2065c5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -137,14 +137,12 @@ struct iwl_bus_ops {
  *
  * This data is common to all bus layer implementations.
  *
- * @dev - pointer to struct device * that represents the device
  * @ops - pointer to iwl_bus_ops
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  *	NB: for the time being this needs to be set by the upper layer since
  *	it allocates the shared data
  */
 struct iwl_bus {
-	struct device *dev;
 	const struct iwl_bus_ops *ops;
 	struct iwl_shared *shrd;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 6f76127..351b41d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -35,10 +35,10 @@
 struct iwl_priv;
 
 /*No matter what is m (priv, bus, trans), this will work */
-#define IWL_ERR(m, f, a...) dev_err(bus(m)->dev, f, ## a)
-#define IWL_WARN(m, f, a...) dev_warn(bus(m)->dev, f, ## a)
-#define IWL_INFO(m, f, a...) dev_info(bus(m)->dev, f, ## a)
-#define IWL_CRIT(m, f, a...) dev_crit(bus(m)->dev, f, ## a)
+#define IWL_ERR(m, f, a...) dev_err(trans(m)->dev, f, ## a)
+#define IWL_WARN(m, f, a...) dev_warn(trans(m)->dev, f, ## a)
+#define IWL_INFO(m, f, a...) dev_info(trans(m)->dev, f, ## a)
+#define IWL_CRIT(m, f, a...) dev_crit(trans(m)->dev, f, ## a)
 
 #define iwl_print_hex_error(m, p, len)					\
 do {									\
@@ -50,7 +50,7 @@ do {									\
 #define IWL_DEBUG(m, level, fmt, ...)					\
 do {									\
 	if (iwl_get_debug_level((m)->shrd) & (level))			\
-		dev_err(bus(m)->dev, "%c %s " fmt,			\
+		dev_err(trans(m)->dev, "%c %s " fmt,			\
 			in_interrupt() ? 'I' : 'U', __func__,		\
 			##__VA_ARGS__);					\
 } while (0)
@@ -59,7 +59,7 @@ do {									\
 do {									\
 	if (iwl_get_debug_level((m)->shrd) & (level) &&			\
 	    net_ratelimit())						\
-		dev_err(bus(m)->dev, "%c %s " fmt,			\
+		dev_err(trans(m)->dev, "%c %s " fmt,			\
 			in_interrupt() ? 'I' : 'U', __func__,		\
 			##__VA_ARGS__);					\
 } while (0)
@@ -74,12 +74,12 @@ do {                                            			\
 #define IWL_DEBUG_QUIET_RFKILL(p, fmt, ...)				\
 do {									\
 	if (!iwl_is_rfkill(p->shrd))					\
-		dev_err(bus(p)->dev, "%s%c %s " fmt,			\
+		dev_err(trans(p)->dev, "%s%c %s " fmt,			\
 			"",						\
 			in_interrupt() ? 'I' : 'U', __func__,		\
 			##__VA_ARGS__);					\
 	else if	(iwl_get_debug_level(p->shrd) & IWL_DL_RADIO)		\
-		dev_err(bus(p)->dev, "%s%c %s " fmt,			\
+		dev_err(trans(p)->dev, "%s%c %s " fmt,			\
 			"(RFKILL) ",					\
 			in_interrupt() ? 'I' : 'U', __func__,		\
 			##__VA_ARGS__);					\
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 7bab819..6451739 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -123,12 +123,14 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 		/* L1-ASPM enabled; disable(!) L0S */
 		iwl_set_bit(trans(bus), CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
-		dev_printk(KERN_INFO, bus->dev, "L1 Enabled; Disabling L0S\n");
+		dev_printk(KERN_INFO, trans(bus)->dev,
+			   "L1 Enabled; Disabling L0S\n");
 	} else {
 		/* L1-ASPM disabled; enable(!) L0S */
 		iwl_clear_bit(trans(bus), CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
-		dev_printk(KERN_INFO, bus->dev, "L1 Disabled; Enabling L0S\n");
+		dev_printk(KERN_INFO, trans(bus)->dev,
+			   "L1 Disabled; Enabling L0S\n");
 	}
 }
 
@@ -368,7 +370,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata(pdev, bus);
 
-	bus->dev = &pdev->dev;
 	bus->ops = &bus_ops_pci;
 
 #ifdef CONFIG_IWLWIFI_IDI
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 5de8b5b..08483d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -83,7 +83,7 @@ static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 static void iwl_free_fw_desc(struct iwl_bus *bus, struct fw_desc *desc)
 {
 	if (desc->v_addr)
-		dma_free_coherent(bus->dev, desc->len,
+		dma_free_coherent(trans(bus)->dev, desc->len,
 				  desc->v_addr, desc->p_addr);
 	desc->v_addr = NULL;
 	desc->len = 0;
@@ -110,7 +110,7 @@ int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
 		return -EINVAL;
 	}
 
-	desc->v_addr = dma_alloc_coherent(bus->dev, len,
+	desc->v_addr = dma_alloc_coherent(trans(bus)->dev, len,
 					  &desc->p_addr, GFP_KERNEL);
 	if (!desc->v_addr)
 		return -ENOMEM;
-- 
1.7.0.4

