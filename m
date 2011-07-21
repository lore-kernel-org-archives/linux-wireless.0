Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1GUP0t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/25] iwlagn: simplify the bus architecture
Date: Thu, 21 Jul 2011 07:50:15 -0700
Message-Id: <1311259828-8415-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172718_043965_97EFDCC0)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Call iwl_probe with a ready iwl_bus struct. This means that the bus layer
assigns the irq, dev and iwl_bus_ops pointers to iwl_bus before giving it to
iwl_probe.

The device specific struct is allocated together with the common iwl_bus struct
by the bus specific layer. The pointer to the aggregate struct is passed to the
upper layer that holds a pointer to iwl_bus instead of an embedded iw_bus.
The private data given to the PCI subsystem is now iwl_bus and not iwl_priv.

Provide bus_* inliners on the way in order  to simplify the syntax.

Rename iwl-pci.h -> iwl-bus.h since it is bus agnostic and represent the
external of the bus layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   31 ++---
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    3 +-
 drivers/net/wireless/iwlwifi/iwl-bus.h           |  142 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   41 +------
 drivers/net/wireless/iwlwifi/iwl-io.h            |    7 +-
 drivers/net/wireless/iwlwifi/iwl-led.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c           |   64 +++++------
 drivers/net/wireless/iwlwifi/iwl-pci.h           |   69 -----------
 drivers/net/wireless/iwlwifi/iwl-power.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |   10 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |   12 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c         |   38 +++---
 15 files changed, 230 insertions(+), 209 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-bus.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-pci.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d3163d8..aee62d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -55,7 +55,7 @@
 #include "iwl-sta.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
-#include "iwl-pci.h"
+#include "iwl-bus.h"
 #include "iwl-trans.h"
 
 /******************************************************************************
@@ -580,7 +580,7 @@ static struct attribute_group iwl_attribute_group = {
 static void iwl_free_fw_desc(struct iwl_priv *priv, struct fw_desc *desc)
 {
 	if (desc->v_addr)
-		dma_free_coherent(priv->bus.dev, desc->len,
+		dma_free_coherent(priv->bus->dev, desc->len,
 				  desc->v_addr, desc->p_addr);
 	desc->v_addr = NULL;
 	desc->len = 0;
@@ -606,7 +606,7 @@ static int iwl_alloc_fw_desc(struct iwl_priv *priv, struct fw_desc *desc,
 		return -EINVAL;
 	}
 
-	desc->v_addr = dma_alloc_coherent(priv->bus.dev, len,
+	desc->v_addr = dma_alloc_coherent(priv->bus->dev, len,
 					  &desc->p_addr, GFP_KERNEL);
 	if (!desc->v_addr)
 		return -ENOMEM;
@@ -660,7 +660,7 @@ static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 		       priv->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, priv->firmware_name,
-				       priv->bus.dev,
+				       priv->bus->dev,
 				       GFP_KERNEL, priv, iwl_ucode_callback);
 }
 
@@ -1163,7 +1163,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	if (err)
 		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
 
-	err = sysfs_create_group(&(priv->bus.dev->kobj),
+	err = sysfs_create_group(&(priv->bus->dev->kobj),
 					&iwl_attribute_group);
 	if (err) {
 		IWL_ERR(priv, "failed to create sysfs device attributes\n");
@@ -1187,7 +1187,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	iwl_dealloc_ucode(priv);
  out_unbind:
 	complete(&priv->_agn.firmware_loading_complete);
-	device_release_driver(priv->bus.dev);
+	device_release_driver(priv->bus->dev);
 	release_firmware(ucode_raw);
 }
 
@@ -3102,8 +3102,7 @@ static void iwl_init_context(struct iwl_priv *priv)
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 }
 
-int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
-		struct iwl_cfg *cfg)
+int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 {
 	int err = 0;
 	struct iwl_priv *priv;
@@ -3121,17 +3120,12 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	}
 
 	priv = hw->priv;
-
-	priv->bus.priv = priv;
-	priv->bus.bus_specific = bus_specific;
-	priv->bus.ops = bus_ops;
-	priv->bus.irq = priv->bus.ops->get_irq(&priv->bus);
-	priv->bus.ops->set_drv_data(&priv->bus, priv);
-	priv->bus.dev = priv->bus.ops->get_dev(&priv->bus);
+	priv->bus = bus;
+	bus_set_drv_data(priv->bus, priv);
 
 	/* At this point both hw and priv are allocated. */
 
-	SET_IEEE80211_DEV(hw, priv->bus.dev);
+	SET_IEEE80211_DEV(hw, priv->bus->dev);
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
@@ -3154,7 +3148,6 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	if (iwl_alloc_traffic_mem(priv))
 		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
 
-
 	/* these spin locks will be used in apm_ops.init and EEPROM access
 	 * we should init now
 	 */
@@ -3289,7 +3282,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
 	iwl_dbgfs_unregister(priv);
-	sysfs_remove_group(&priv->bus.dev->kobj,
+	sysfs_remove_group(&priv->bus->dev->kobj,
 			   &iwl_attribute_group);
 
 	/* ieee80211_unregister_hw call wil cause iwl_mac_stop to
@@ -3339,7 +3332,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 
 	trans_free(&priv->trans);
 
-	priv->bus.ops->set_drv_data(&priv->bus, NULL);
+	bus_set_drv_data(priv->bus, NULL);
 
 	iwl_uninit_drv(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 496ab99..78dccde 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -336,8 +336,7 @@ void iwl_testmode_cleanup(struct iwl_priv *priv)
 }
 #endif
 
-int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
-		struct iwl_cfg *cfg);
+int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg);
 void __devexit iwl_remove(struct iwl_priv * priv);
 
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
new file mode 100644
index 0000000..fef62e6
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -0,0 +1,142 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#ifndef __iwl_pci_h__
+#define __iwl_pci_h__
+
+struct iwl_bus;
+
+/**
+ * struct iwl_bus_ops - bus specific operations
+
+ * @get_pm_support: must returns true if the bus can go to sleep
+ * @apm_config: will be called during the config of the APM configuration
+ * @set_drv_data: set the priv pointer to the bus layer
+ * @get_hw_id: prints the hw_id in the provided buffer
+ * @write8: write a byte to register at offset ofs
+ * @write32: write a dword to register at offset ofs
+ * @wread32: read a dword at register at offset ofs
+ */
+struct iwl_bus_ops {
+	bool (*get_pm_support)(struct iwl_bus *bus);
+	void (*apm_config)(struct iwl_bus *bus);
+	void (*set_drv_data)(struct iwl_bus *bus, void *drv_data);
+	void (*get_hw_id)(struct iwl_bus *bus, char buf[], int buf_len);
+	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
+	void (*write32)(struct iwl_bus *bus, u32 ofs, u32 val);
+	u32 (*read32)(struct iwl_bus *bus, u32 ofs);
+};
+
+struct iwl_bus {
+	/* Common data to all buses */
+
+	/*TODO: priv should be void * */
+	struct iwl_priv *priv; /* driver's context */
+	struct device *dev;
+	struct iwl_bus_ops *ops;
+
+	unsigned int irq;
+
+	/* pointer to bus specific struct */
+	/*Ensure that this pointer will always be aligned to sizeof pointer */
+	char bus_specific[0] __attribute__((__aligned__(sizeof(void *))));
+};
+
+static inline bool bus_get_pm_support(struct iwl_bus *bus)
+{
+	return bus->ops->get_pm_support(bus);
+}
+
+static inline void bus_apm_config(struct iwl_bus *bus)
+{
+	bus->ops->apm_config(bus);
+}
+
+static inline void bus_set_drv_data(struct iwl_bus *bus, void *drv_data)
+{
+	bus->ops->set_drv_data(bus, drv_data);
+}
+
+static inline void bus_get_hw_id(struct iwl_bus *bus, char buf[], int buf_len)
+{
+	bus->ops->get_hw_id(bus, buf, buf_len);
+}
+
+static inline void bus_write8(struct iwl_bus *bus, u32 ofs, u8 val)
+{
+	bus->ops->write8(bus, ofs, val);
+}
+
+static inline void bus_write32(struct iwl_bus *bus, u32 ofs, u32 val)
+{
+	bus->ops->write32(bus, ofs, val);
+}
+
+static inline u32 bus_read32(struct iwl_bus *bus, u32 ofs)
+{
+	return bus->ops->read32(bus, ofs);
+}
+
+int __must_check iwl_pci_register_driver(void);
+void iwl_pci_unregister_driver(void);
+
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a2a95ba..3be0111 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -211,7 +211,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     priv->cfg->sku & EEPROM_SKU_CAP_BAND_52GHZ) {
 		char buf[32];
-		priv->bus.ops->get_hw_id(&priv->bus, buf, sizeof(buf));
+		bus_get_hw_id(priv->bus, buf, sizeof(buf));
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
 			"Please send your %s to maintainer.\n", buf);
 		priv->cfg->sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
@@ -1012,7 +1012,7 @@ int iwl_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
 
-	priv->bus.ops->apm_config(&priv->bus);
+	bus_apm_config(priv->bus);
 
 	/* Configure analog phase-lock-loop before activating to D0A */
 	if (priv->cfg->base_params->pll_cfg_val)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index eb95d1a..4529e2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -32,10 +32,10 @@
 struct iwl_priv;
 extern u32 iwl_debug_level;
 
-#define IWL_ERR(p, f, a...) dev_err(p->bus.ops->get_dev(&p->bus), f, ## a)
-#define IWL_WARN(p, f, a...) dev_warn(p->bus.ops->get_dev(&p->bus), f, ## a)
-#define IWL_INFO(p, f, a...) dev_info(p->bus.ops->get_dev(&p->bus), f, ## a)
-#define IWL_CRIT(p, f, a...) dev_crit(p->bus.ops->get_dev(&p->bus), f, ## a)
+#define IWL_ERR(p, f, a...) dev_err(p->bus->dev, f, ## a)
+#define IWL_WARN(p, f, a...) dev_warn(p->bus->dev, f, ## a)
+#define IWL_INFO(p, f, a...) dev_info(p->bus->dev, f, ## a)
+#define IWL_CRIT(p, f, a...) dev_crit(p->bus->dev, f, ## a)
 
 #define iwl_print_hex_error(priv, p, len) 				\
 do {									\
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a89b40a..964be57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -47,6 +47,7 @@
 #include "iwl-power.h"
 #include "iwl-agn-rs.h"
 #include "iwl-agn-tt.h"
+#include "iwl-bus.h"
 #include "iwl-trans.h"
 
 #define DRV_NAME        "iwlagn"
@@ -1193,44 +1194,6 @@ struct iwl_testmode_trace {
 };
 #endif
 
-struct iwl_bus;
-
-/**
- * struct iwl_bus_ops - bus specific operations
-
- * @get_pm_support: must returns true if the bus can go to sleep
- * @apm_config: will be called during the config of the APM configuration
- * @set_drv_data: set the priv pointer to the bus layer
- * @get_dev: returns the device struct
- * @get_irq: returns the irq number
- * @get_hw_id: prints the hw_id in the provided buffer
- * @write8: write a byte to register at offset ofs
- * @write32: write a dword to register at offset ofs
- * @wread32: read a dword at register at offset ofs
- */
-struct iwl_bus_ops {
-	bool (*get_pm_support)(struct iwl_bus *bus);
-	void (*apm_config)(struct iwl_bus *bus);
-	void (*set_drv_data)(struct iwl_bus *bus, void *priv);
-	struct device *(*get_dev)(const struct iwl_bus *bus);
-	unsigned int (*get_irq)(const struct iwl_bus *bus);
-	void (*get_hw_id)(struct iwl_bus *bus, char buf[], int buf_len);
-	void (*write8)(struct iwl_bus *bus, u32 ofs, u8 val);
-	void (*write32)(struct iwl_bus *bus, u32 ofs, u32 val);
-	u32 (*read32)(struct iwl_bus *bus, u32 ofs);
-};
-
-struct iwl_bus {
-	/* pointer to bus specific struct */
-	void *bus_specific;
-
-	/* Common data to all buses */
-	struct iwl_priv *priv; /* driver's context */
-	struct device *dev;
-	struct iwl_bus_ops *ops;
-	unsigned int irq;
-};
-
 /* uCode ownership */
 #define IWL_OWNERSHIP_DRIVER	0
 #define IWL_OWNERSHIP_TM	1
@@ -1302,7 +1265,7 @@ struct iwl_priv {
 	spinlock_t reg_lock;	/* protect hw register access */
 	struct mutex mutex;
 
-	struct iwl_bus bus;	/* bus specific data */
+	struct iwl_bus *bus;	/* bus specific data */
 	struct iwl_trans trans;
 
 	/* microcode/device supports multiple contexts */
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index c56eae7..19a0931 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -34,22 +34,23 @@
 #include "iwl-dev.h"
 #include "iwl-debug.h"
 #include "iwl-devtrace.h"
+#include "iwl-bus.h"
 
 static inline void iwl_write8(struct iwl_priv *priv, u32 ofs, u8 val)
 {
 	trace_iwlwifi_dev_iowrite8(priv, ofs, val);
-	priv->bus.ops->write8(&priv->bus, ofs, val);
+	bus_write8(priv->bus, ofs, val);
 }
 
 static inline void iwl_write32(struct iwl_priv *priv, u32 ofs, u32 val)
 {
 	trace_iwlwifi_dev_iowrite32(priv, ofs, val);
-	priv->bus.ops->write32(&priv->bus, ofs, val);
+	bus_write32(priv->bus, ofs, val);
 }
 
 static inline u32 iwl_read32(struct iwl_priv *priv, u32 ofs)
 {
-	u32 val = priv->bus.ops->read32(&priv->bus, ofs);
+	u32 val = bus_read32(priv->bus, ofs);
 	trace_iwlwifi_dev_ioread32(priv, ofs, val);
 	return val;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 75663c1..a67ae56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -203,7 +203,7 @@ void iwl_leds_init(struct iwl_priv *priv)
 		break;
 	}
 
-	ret = led_classdev_register(priv->bus.dev,
+	ret = led_classdev_register(priv->bus->dev,
 				    &priv->led);
 	if (ret) {
 		kfree(priv->led.name);
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 7491134..6644889 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -63,11 +63,10 @@
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
 
-#include "iwl-pci.h"
+#include "iwl-bus.h"
 #include "iwl-agn.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-trans.h"
 
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
@@ -132,19 +131,9 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 	}
 }
 
-static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_priv)
+static void iwl_pci_set_drv_data(struct iwl_bus *bus, void *drv_data)
 {
-	pci_set_drvdata(IWL_BUS_GET_PCI_DEV(bus), drv_priv);
-}
-
-static struct device *iwl_pci_get_dev(const struct iwl_bus *bus)
-{
-	return &(IWL_BUS_GET_PCI_DEV(bus)->dev);
-}
-
-static unsigned int iwl_pci_get_irq(const struct iwl_bus *bus)
-{
-	return IWL_BUS_GET_PCI_DEV(bus)->irq;
+	bus->priv = drv_data;
 }
 
 static void iwl_pci_get_hw_id(struct iwl_bus *bus, char buf[],
@@ -176,8 +165,6 @@ static struct iwl_bus_ops pci_ops = {
 	.get_pm_support = iwl_pci_is_pm_supported,
 	.apm_config = iwl_pci_apm_config,
 	.set_drv_data = iwl_pci_set_drv_data,
-	.get_dev = iwl_pci_get_dev,
-	.get_irq = iwl_pci_get_irq,
 	.get_hw_id = iwl_pci_get_hw_id,
 	.write8 = iwl_pci_write8,
 	.write32 = iwl_pci_write32,
@@ -383,18 +370,20 @@ MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
-	struct iwl_pci_bus *bus;
+	struct iwl_bus *bus;
+	struct iwl_pci_bus *pci_bus;
 	u16 pci_cmd;
 	int err;
 
-	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
+	bus = kzalloc(sizeof(*bus) + sizeof(*pci_bus), GFP_KERNEL);
 	if (!bus) {
 		pr_err("Couldn't allocate iwl_pci_bus");
 		err = -ENOMEM;
 		goto out_no_pci;
 	}
 
-	bus->pci_dev = pdev;
+	pci_bus = IWL_BUS_GET_PCI_BUS(bus);
+	pci_bus->pci_dev = pdev;
 
 	/* W/A - seems to solve weird behavior. We need to remove this if we
 	 * don't want to stay in L1 all the time. This wastes a lot of power */
@@ -429,8 +418,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_pci_disable_device;
 	}
 
-	bus->hw_base = pci_iomap(pdev, 0, 0);
-	if (!bus->hw_base) {
+	pci_bus->hw_base = pci_iomap(pdev, 0, 0);
+	if (!pci_bus->hw_base) {
 		pr_err("pci_iomap failed");
 		err = -ENODEV;
 		goto out_pci_release_regions;
@@ -438,7 +427,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pr_info("pci_resource_len = 0x%08llx\n",
 		(unsigned long long) pci_resource_len(pdev, 0));
-	pr_info("pci_resource_base = %p\n", bus->hw_base);
+	pr_info("pci_resource_base = %p\n", pci_bus->hw_base);
 
 	pr_info("HW Revision ID = 0x%X\n", pdev->revision);
 
@@ -460,7 +449,13 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 	}
 
-	err = iwl_probe((void *) bus, &pci_ops, cfg);
+	pci_set_drvdata(pdev, bus);
+
+	bus->dev = &pdev->dev;
+	bus->irq = pdev->irq;
+	bus->ops = &pci_ops;
+
+	err = iwl_probe(bus, cfg);
 	if (err)
 		goto out_disable_msi;
 	return 0;
@@ -468,7 +463,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_disable_msi:
 	pci_disable_msi(pdev);
 out_iounmap:
-	pci_iounmap(pdev, bus->hw_base);
+	pci_iounmap(pdev, pci_bus->hw_base);
 out_pci_release_regions:
 	pci_set_drvdata(pdev, NULL);
 	pci_release_regions(pdev);
@@ -479,9 +474,9 @@ out_no_pci:
 	return err;
 }
 
-static void iwl_pci_down(void *bus)
+static void iwl_pci_down(struct iwl_bus *bus)
 {
-	struct iwl_pci_bus *pci_bus = (struct iwl_pci_bus *) bus;
+	struct iwl_pci_bus *pci_bus = (struct iwl_pci_bus *) bus->bus_specific;
 
 	pci_disable_msi(pci_bus->pci_dev);
 	pci_iounmap(pci_bus->pci_dev, pci_bus->hw_base);
@@ -489,17 +484,16 @@ static void iwl_pci_down(void *bus)
 	pci_disable_device(pci_bus->pci_dev);
 	pci_set_drvdata(pci_bus->pci_dev, NULL);
 
-	kfree(pci_bus);
+	kfree(bus);
 }
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
-	void *bus_specific = priv->bus.bus_specific;
+	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
-	iwl_remove(priv);
+	iwl_remove(bus->priv);
 
-	iwl_pci_down(bus_specific);
+	iwl_pci_down(bus);
 }
 
 #ifdef CONFIG_PM
@@ -507,15 +501,15 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 static int iwl_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
-	return iwl_suspend(priv);
+	return iwl_suspend(bus->priv);
 }
 
 static int iwl_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	struct iwl_bus *bus = pci_get_drvdata(pdev);
 
 	/*
 	 * We disable the RETRY_TIMEOUT register (0x41) to keep
@@ -523,7 +517,7 @@ static int iwl_pci_resume(struct device *device)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	return iwl_resume(priv);
+	return iwl_resume(bus->priv);
 }
 
 static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.h b/drivers/net/wireless/iwlwifi/iwl-pci.h
deleted file mode 100644
index 9396c7c..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-pci.h
+++ /dev/null
@@ -1,69 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-#ifndef __iwl_pci_h__
-#define __iwl_pci_h__
-
-int __must_check iwl_pci_register_driver(void);
-void iwl_pci_unregister_driver(void);
-
-#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 7c99f43..de4f333 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -432,7 +432,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
-	priv->power_data.bus_pm = priv->bus.ops->get_pm_support(&priv->bus);
+	priv->power_data.bus_pm = bus_get_pm_support(priv->bus);
 
 	priv->power_data.debug_sleep_level_override = -1;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index d474835..b11f60d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -181,12 +181,10 @@ void iwl_testmode_init(struct iwl_priv *priv)
 
 static void iwl_trace_cleanup(struct iwl_priv *priv)
 {
-	struct device *dev = priv->bus.dev;
-
 	if (priv->testmode_trace.trace_enabled) {
 		if (priv->testmode_trace.cpu_addr &&
 		    priv->testmode_trace.dma_addr)
-			dma_free_coherent(dev,
+			dma_free_coherent(priv->bus->dev,
 					priv->testmode_trace.total_size,
 					priv->testmode_trace.cpu_addr,
 					priv->testmode_trace.dma_addr);
@@ -486,7 +484,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 	struct iwl_priv *priv = hw->priv;
 	struct sk_buff *skb;
 	int status = 0;
-	struct device *dev = priv->bus.dev;
+	struct device *dev = priv->bus->dev;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index d5b9adf..7434358 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -305,7 +305,7 @@ static void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		BUG_ON(rxb->page);
 		rxb->page = page;
 		/* Get physical address of the RB */
-		rxb->page_dma = dma_map_page(priv->bus.dev, page, 0,
+		rxb->page_dma = dma_map_page(priv->bus->dev, page, 0,
 				PAGE_SIZE << priv->hw_params.rx_page_order,
 				DMA_FROM_DEVICE);
 		/* dma address must be no more than 36 bits */
@@ -404,7 +404,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		dma_unmap_page(priv->bus.dev, rxb->page_dma,
+		dma_unmap_page(priv->bus->dev, rxb->page_dma,
 			       PAGE_SIZE << priv->hw_params.rx_page_order,
 			       DMA_FROM_DEVICE);
 		pkt = rxb_addr(rxb);
@@ -455,7 +455,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		 * rx_free list for reuse later. */
 		spin_lock_irqsave(&rxq->lock, flags);
 		if (rxb->page != NULL) {
-			rxb->page_dma = dma_map_page(priv->bus.dev, rxb->page,
+			rxb->page_dma = dma_map_page(priv->bus->dev, rxb->page,
 				0, PAGE_SIZE << priv->hw_params.rx_page_order,
 				DMA_FROM_DEVICE);
 			list_add_tail(&rxb->list, &rxq->rx_free);
@@ -704,7 +704,7 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 void iwl_free_isr_ict(struct iwl_priv *priv)
 {
 	if (priv->_agn.ict_tbl_vir) {
-		dma_free_coherent(priv->bus.dev,
+		dma_free_coherent(priv->bus->dev,
 				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
 				  priv->_agn.ict_tbl_vir,
 				  priv->_agn.ict_tbl_dma);
@@ -725,7 +725,7 @@ int iwl_alloc_isr_ict(struct iwl_priv *priv)
 
 	/* allocate shrared data table */
 	priv->_agn.ict_tbl_vir =
-		dma_alloc_coherent(priv->bus.dev,
+		dma_alloc_coherent(priv->bus->dev,
 				   (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
 				   &priv->_agn.ict_tbl_dma, GFP_KERNEL);
 	if (!priv->_agn.ict_tbl_vir)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 7dac6ee..27f78fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -182,14 +182,14 @@ static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
 
 	/* Unmap tx_cmd */
 	if (num_tbs)
-		dma_unmap_single(priv->bus.dev,
+		dma_unmap_single(priv->bus->dev,
 				dma_unmap_addr(meta, mapping),
 				dma_unmap_len(meta, len),
 				DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
-		dma_unmap_single(priv->bus.dev, iwl_tfd_tb_get_addr(tfd, i),
+		dma_unmap_single(priv->bus->dev, iwl_tfd_tb_get_addr(tfd, i),
 				iwl_tfd_tb_get_len(tfd, i), dma_dir);
 }
 
@@ -640,9 +640,9 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
 			q->write_ptr, idx, priv->cmd_queue);
 
-	phys_addr = dma_map_single(priv->bus.dev, &out_cmd->hdr, copy_size,
+	phys_addr = dma_map_single(priv->bus->dev, &out_cmd->hdr, copy_size,
 				DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(priv->bus.dev, phys_addr))) {
+	if (unlikely(dma_mapping_error(priv->bus->dev, phys_addr))) {
 		idx = -ENOMEM;
 		goto out;
 	}
@@ -662,9 +662,9 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
-		phys_addr = dma_map_single(priv->bus.dev, (void *)cmd->data[i],
+		phys_addr = dma_map_single(priv->bus->dev, (void *)cmd->data[i],
 					   cmd->len[i], DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(priv->bus.dev, phys_addr)) {
+		if (dma_mapping_error(priv->bus->dev, phys_addr)) {
 			iwlagn_unmap_tfd(priv, out_meta,
 					 &txq->tfds[q->write_ptr],
 					 DMA_BIDIRECTIONAL);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index edd28f0..582ab1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -72,7 +72,7 @@
 static int iwl_trans_rx_alloc(struct iwl_priv *priv)
 {
 	struct iwl_rx_queue *rxq = &priv->rxq;
-	struct device *dev = priv->bus.dev;
+	struct device *dev = priv->bus->dev;
 
 	memset(&priv->rxq, 0, sizeof(priv->rxq));
 
@@ -118,7 +118,7 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_priv *priv)
 		/* In the reset function, these buffers may have been allocated
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].page != NULL) {
-			dma_unmap_page(priv->bus.dev, rxq->pool[i].page_dma,
+			dma_unmap_page(priv->bus->dev, rxq->pool[i].page_dma,
 				PAGE_SIZE << priv->hw_params.rx_page_order,
 				DMA_FROM_DEVICE);
 			__iwl_free_pages(priv, rxq->pool[i].page);
@@ -233,13 +233,13 @@ static void iwl_trans_rx_free(struct iwl_priv *priv)
 	iwl_trans_rxq_free_rx_bufs(priv);
 	spin_unlock_irqrestore(&rxq->lock, flags);
 
-	dma_free_coherent(priv->bus.dev, sizeof(__le32) * RX_QUEUE_SIZE,
+	dma_free_coherent(priv->bus->dev, sizeof(__le32) * RX_QUEUE_SIZE,
 			  rxq->bd, rxq->bd_dma);
 	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
 	rxq->bd = NULL;
 
 	if (rxq->rb_stts)
-		dma_free_coherent(priv->bus.dev,
+		dma_free_coherent(priv->bus->dev,
 				  sizeof(struct iwl_rb_status),
 				  rxq->rb_stts, rxq->rb_stts_dma);
 	else
@@ -263,7 +263,7 @@ static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
 	if (WARN_ON(ptr->addr))
 		return -EINVAL;
 
-	ptr->addr = dma_alloc_coherent(priv->bus.dev, size,
+	ptr->addr = dma_alloc_coherent(priv->bus->dev, size,
 				       &ptr->dma, GFP_KERNEL);
 	if (!ptr->addr)
 		return -ENOMEM;
@@ -277,7 +277,7 @@ static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
 	if (unlikely(!ptr->addr))
 		return;
 
-	dma_free_coherent(priv->bus.dev, ptr->size, ptr->addr, ptr->dma);
+	dma_free_coherent(priv->bus->dev, ptr->size, ptr->addr, ptr->dma);
 	memset(ptr, 0, sizeof(*ptr));
 }
 
@@ -324,7 +324,7 @@ static int iwl_trans_txq_alloc(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
-	txq->tfds = dma_alloc_coherent(priv->bus.dev, tfd_sz, &txq->q.dma_addr,
+	txq->tfds = dma_alloc_coherent(priv->bus->dev, tfd_sz, &txq->q.dma_addr,
 				       GFP_KERNEL);
 	if (!txq->tfds) {
 		IWL_ERR(priv, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
@@ -415,7 +415,7 @@ static void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
 static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct device *dev = priv->bus.dev;
+	struct device *dev = priv->bus->dev;
 	int i;
 	if (WARN_ON(!txq))
 		return;
@@ -1016,10 +1016,10 @@ static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = dma_map_single(priv->bus.dev,
+	txcmd_phys = dma_map_single(priv->bus->dev,
 				    &dev_cmd->hdr, firstlen,
 				    DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(priv->bus.dev, txcmd_phys)))
+	if (unlikely(dma_mapping_error(priv->bus->dev, txcmd_phys)))
 		return -1;
 	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
 	dma_unmap_len_set(out_meta, len, firstlen);
@@ -1035,10 +1035,10 @@ static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	 * if any (802.11 null frames have no payload). */
 	secondlen = skb->len - hdr_len;
 	if (secondlen > 0) {
-		phys_addr = dma_map_single(priv->bus.dev, skb->data + hdr_len,
+		phys_addr = dma_map_single(priv->bus->dev, skb->data + hdr_len,
 					   secondlen, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(priv->bus.dev, phys_addr))) {
-			dma_unmap_single(priv->bus.dev,
+		if (unlikely(dma_mapping_error(priv->bus->dev, phys_addr))) {
+			dma_unmap_single(priv->bus->dev,
 					 dma_unmap_addr(out_meta, mapping),
 					 dma_unmap_len(out_meta, len),
 					 DMA_BIDIRECTIONAL);
@@ -1056,7 +1056,7 @@ static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 				offsetof(struct iwl_tx_cmd, scratch);
 
 	/* take back ownership of DMA buffer to enable update */
-	dma_sync_single_for_cpu(priv->bus.dev, txcmd_phys, firstlen,
+	dma_sync_single_for_cpu(priv->bus->dev, txcmd_phys, firstlen,
 			DMA_BIDIRECTIONAL);
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
@@ -1072,7 +1072,7 @@ static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 		iwl_trans_txq_update_byte_cnt_tbl(priv, txq,
 					       le16_to_cpu(tx_cmd->len));
 
-	dma_sync_single_for_device(priv->bus.dev, txcmd_phys, firstlen,
+	dma_sync_single_for_device(priv->bus->dev, txcmd_phys, firstlen,
 			DMA_BIDIRECTIONAL);
 
 	trace_iwlwifi_dev_tx(priv,
@@ -1111,13 +1111,13 @@ static void iwl_trans_kick_nic(struct iwl_priv *priv)
 static void iwl_trans_sync_irq(struct iwl_priv *priv)
 {
 	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(priv->bus.irq);
+	synchronize_irq(priv->bus->irq);
 	tasklet_kill(&priv->irq_tasklet);
 }
 
 static void iwl_trans_free(struct iwl_priv *priv)
 {
-	free_irq(priv->bus.irq, priv);
+	free_irq(priv->bus->irq, priv);
 	iwl_free_isr_ict(priv);
 }
 
@@ -1155,10 +1155,10 @@ int iwl_trans_register(struct iwl_trans *trans, struct iwl_priv *priv)
 
 	iwl_alloc_isr_ict(priv);
 
-	err = request_irq(priv->bus.irq, iwl_isr_ict, IRQF_SHARED,
+	err = request_irq(priv->bus->irq, iwl_isr_ict, IRQF_SHARED,
 		DRV_NAME, priv);
 	if (err) {
-		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->bus.irq);
+		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->bus->irq);
 		iwl_free_isr_ict(priv);
 		return err;
 	}
-- 
1.7.0.4

