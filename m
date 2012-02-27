Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab2B0XTI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/24] iwlwifi: kill iwl_bus.h
Date: Mon, 27 Feb 2012 14:07:41 -0800
Message-Id: <1330380468-17674-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001922_518022_48BF72AC)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

No one needs it any more

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-bus.h      |  145 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-pci.c      |   60 +++++------
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    5 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    2 +
 9 files changed, 29 insertions(+), 188 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-bus.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7e3e00d..e0fef9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -50,7 +50,6 @@
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
 #include "iwl-shared.h"
-#include "iwl-bus.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
deleted file mode 100644
index 7d56cbc..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ /dev/null
@@ -1,145 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
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
- * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
-#ifndef __iwl_bus_h__
-#define __iwl_bus_h__
-
-#include <linux/types.h>
-#include <linux/spinlock.h>
-
-/**
- * DOC: Bus layer - role and goal
- *
- * iwl-bus.h defines the API to the bus layer of the iwlwifi driver.
- * The bus layer is responsible for doing very basic bus operations that are
- * listed in the iwl_bus_ops structure.
- * The bus layer registers to the bus driver, advertises the supported HW and
- * gets notifications about enumeration, suspend, resume.
- * For the moment, the bus layer is not a linux kernel module as itself, and
- * the module_init function of the driver must call the bus specific
- * registration functions. These functions are listed at the end of this file.
- * For the moment, there is only one implementation of this interface: PCI-e.
- * This implementation is iwl-pci.c
- */
-
-/**
- * DOC: encapsulation and type safety
- *
- * The iwl_bus describes the data that is shared amongst all the bus layer
- * implementations. This data is visible to other layers. Data in the bus
- * specific area is not visible outside the bus specific implementation.
- * iwl_bus holds a pointer to iwl_shared which holds pointer to all the other
- * layers of the driver (iwl_priv, iwl_trans). In fact, this is the way to go
- * when the transport layer needs to call a function of another layer.
- *
- * In order to achieve encapsulation, iwl_priv cannot be dereferenced from the
- * bus layer. Type safety is still kept since functions that gets iwl_priv gets
- * a typed pointer (as opposed to void *).
- */
-
-/**
- * DOC: probe flow
- *
- * The module_init calls the bus specific registration function. The
- * registration to the bus layer will trigger an enumeration of the bus which
- * will call the bus specific probe function.
- * The first thing this function must do is to allocate the memory needed by
- * iwl_bus + the bus_specific data.
- * Once the bus specific probe function has configured the hardware, it
- * chooses the appropriate transport layer and calls iwl_probe that will run
- * the bus independent probe flow.
- *
- * Note: The bus specific code must set the following data in iwl_bus before it
- *       calls iwl_probe:
- *	* bus->dev
- *	* bus->irq
- *	* bus->ops
- */
-
-struct iwl_shared;
-struct iwl_bus;
-
-/**
- * struct iwl_bus - bus common data
- *
- * This data is common to all bus layer implementations.
- *
- * @ops - pointer to iwl_bus_ops
- * @shrd - pointer to iwl_shared which holds shared data from the upper layer
- *	NB: for the time being this needs to be set by the upper layer since
- *	it allocates the shared data
- */
-struct iwl_bus {
-	struct iwl_shared *shrd;
-
-	/* pointer to bus specific struct */
-	/*Ensure that this pointer will always be aligned to sizeof pointer */
-	char bus_specific[0] __aligned(sizeof(void *));
-};
-
-/*****************************************************
-* Bus layer registration functions
-******************************************************/
-int __must_check iwl_pci_register_driver(void);
-void iwl_pci_unregister_driver(void);
-
-#endif /* __iwl_bus_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index bfc0849..01b2330 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -29,7 +29,6 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
-#include "iwl-bus.h"
 #include "iwl-shared.h"
 #include "iwl-devtrace.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a670c82..6e5bf0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -47,7 +47,6 @@
 #include "iwl-power.h"
 #include "iwl-agn-rs.h"
 #include "iwl-agn-tt.h"
-#include "iwl-bus.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 #include "iwl-op-mode.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 3ca89ab..03f7705 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -51,7 +51,6 @@
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
 #include "iwl-shared.h"
-#include "iwl-bus.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index b9cdd1a..527f13b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -64,13 +64,13 @@
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
 
-#include "iwl-bus.h"
 #include "iwl-io.h"
 #include "iwl-shared.h"
 #include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "iwl-cfg.h"
 #include "iwl-drv.h"
+#include "iwl-trans.h"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
@@ -263,44 +263,40 @@ MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
-	struct iwl_bus *bus;
+	struct iwl_shared *shrd;
+	struct iwl_trans *iwl_trans;
 	int err;
 
-	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
-	if (!bus) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "Couldn't allocate iwl_pci_bus");
-		return -ENOMEM;
-	}
-
-	bus->shrd = kzalloc(sizeof(*bus->shrd), GFP_KERNEL);
-	if (!bus->shrd) {
+	shrd = kzalloc(sizeof(*iwl_trans->shrd), GFP_KERNEL);
+	if (!shrd) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "Couldn't allocate iwl_shared");
 		err = -ENOMEM;
 		goto out_free_bus;
 	}
 
-	bus->shrd->bus = bus;
-
-	pci_set_drvdata(pdev, bus);
-
 #ifdef CONFIG_IWLWIFI_IDI
-	trans(bus) = iwl_trans_idi_alloc(bus->shrd, pdev, ent);
-	if (trans(bus) == NULL) {
+	iwl_trans = iwl_trans_idi_alloc(shrd, pdev, ent);
+	if (trans == NULL) {
 		err = -ENOMEM;
 		goto out_free_bus;
 	}
 
-	err = iwl_drv_start(bus->shrd, trans(bus), cfg);
+	shrd->trans = iwl_trans;
+	pci_set_drvdata(pdev, iwl_trans);
+
+	err = iwl_drv_start(shrd, iwl_trans, cfg);
 #else
-	trans(bus) = iwl_trans_pcie_alloc(bus->shrd, pdev, ent);
-	if (trans(bus) == NULL) {
+	iwl_trans = iwl_trans_pcie_alloc(shrd, pdev, ent);
+	if (iwl_trans == NULL) {
 		err = -ENOMEM;
 		goto out_free_bus;
 	}
 
-	err = iwl_drv_start(bus->shrd, trans(bus), cfg);
+	shrd->trans = iwl_trans;
+	pci_set_drvdata(pdev, iwl_trans);
+
+	err = iwl_drv_start(shrd, iwl_trans, cfg);
 #endif
 	if (err)
 		goto out_free_trans;
@@ -308,26 +304,24 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 out_free_trans:
-	iwl_trans_free(trans(bus));
+	iwl_trans_free(iwl_trans);
 	pci_set_drvdata(pdev, NULL);
 out_free_bus:
-	kfree(bus->shrd);
-	kfree(bus);
+	kfree(shrd);
 	return err;
 }
 
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
-	struct iwl_shared *shrd = bus->shrd;
+	struct iwl_trans *iwl_trans = pci_get_drvdata(pdev);
+	struct iwl_shared *shrd = iwl_trans->shrd;
 
 	iwl_drv_stop(shrd);
 	iwl_trans_free(shrd->trans);
 
 	pci_set_drvdata(pdev, NULL);
 
-	kfree(bus->shrd);
-	kfree(bus);
+	kfree(shrd);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -335,22 +329,20 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 static int iwl_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
-	struct iwl_shared *shrd = bus->shrd;
+	struct iwl_trans *iwl_trans = pci_get_drvdata(pdev);
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
 	 * WoWLAN is enabled - don't kill the NIC, someone may need it in Sx.
 	 */
 
-	return iwl_trans_suspend(shrd->trans);
+	return iwl_trans_suspend(iwl_trans);
 }
 
 static int iwl_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_bus *bus = pci_get_drvdata(pdev);
-	struct iwl_shared *shrd = bus->shrd;
+	struct iwl_trans *iwl_trans = pci_get_drvdata(pdev);
 
 	/* Before you put code here, think about WoWLAN. You cannot check here
 	 * whether WoWLAN is enabled or not, and your code will run even if
@@ -363,7 +355,7 @@ static int iwl_pci_resume(struct device *device)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	return iwl_trans_resume(shrd->trans);
+	return iwl_trans_resume(iwl_trans);
 }
 
 static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index f3b6fd7..e7b075e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -94,7 +94,6 @@
  * This implementation is iwl-pci.c
  */
 
-struct iwl_bus;
 struct iwl_priv;
 struct iwl_trans;
 struct iwl_sensitivity_ranges;
@@ -385,7 +384,6 @@ struct iwl_shared {
 	bool wowlan;
 	u8 valid_contexts;
 
-	struct iwl_bus *bus;
 	struct iwl_cfg *cfg;
 	struct iwl_priv *priv;
 	struct iwl_trans *trans;
@@ -416,10 +414,9 @@ struct iwl_shared {
 
 };
 
-/*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
+/*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
 #define priv(_m)	((_m)->shrd->priv)
 #define cfg(_m)		((_m)->shrd->cfg)
-#define bus(_m)		((_m)->shrd->bus)
 #define nic(_m)		((_m)->shrd->nic)
 #define trans(_m)	((_m)->shrd->trans)
 #define hw_params(_m)	((_m)->shrd->hw_params)
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index e3cca66..23eea06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -78,7 +78,6 @@
 #include "iwl-agn.h"
 #include "iwl-testmode.h"
 #include "iwl-trans.h"
-#include "iwl-bus.h"
 #include "iwl-fh.h"
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index fbb09f6..52a1c2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -563,6 +563,8 @@ extern const struct iwl_trans_ops trans_ops_pcie;
 struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 				       struct pci_dev *pdev,
 				       const struct pci_device_id *ent);
+int __must_check iwl_pci_register_driver(void);
+void iwl_pci_unregister_driver(void);
 
 extern const struct iwl_trans_ops trans_ops_idi;
 struct iwl_trans *iwl_trans_idi_alloc(struct iwl_shared *shrd,
-- 
1.7.0.4

