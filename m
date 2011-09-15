Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934534Ab1IOTcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/27] iwlagn: document the bus layer API
Date: Thu, 15 Sep 2011 11:46:33 -0700
Message-Id: <1316112414-6341-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213214_058405_24C2BBFE)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add documentation to the bus layer API - iwl-bus.h

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h |   62 +++++++++++++++++++++++++++++---
 1 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 83aed46..98535df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -63,18 +63,65 @@
 #ifndef __iwl_bus_h__
 #define __iwl_bus_h__
 
-/*This file includes the declaration that are exported from the bus layer */
-
 #include <linux/types.h>
 #include <linux/spinlock.h>
 
+/**
+ * DOC: Bus layer - role and goal
+ *
+ * iwl-bus.h defines the API to the bus layer of the iwlwifi driver.
+ * The bus layer is responsible for doing very basic bus operations that are
+ * listed in the iwl_bus_ops structure.
+ * The bus layer registers to the bus driver, advertises the supported HW and
+ * gets notifications about enumeration, suspend, resume.
+ * For the moment, the bus layer is not a linux kernel module as itself, and
+ * the module_init function of the driver must call the bus specific
+ * registration functions. These functions are listed at the end of this file.
+ * For the moment, there is only one implementation of this interface: PCI-e.
+ * This implementation is iwl-pci.c
+ */
+
+/**
+ * DOC: encapsulation and type safety
+ *
+ * The iwl_bus describes the data that is shared amongst all the bus layer
+ * implementations. This data is visible to other layers. Data in the bus
+ * specific area is not visible outside the bus specific implementation.
+ * iwl_bus holds a pointer to iwl_shared which holds pointer to all the other
+ * layers of the driver (iwl_priv, iwl_trans). In fact, this is the way to go
+ * when the transport layer needs to call a function of another layer.
+ *
+ * In order to achieve encapsulation, iwl_priv cannot be dereferenced from the
+ * bus layer. Type safety is still kept since functions that gets iwl_priv gets
+ * a typed pointer (as opposed to void *).
+ */
+
+/**
+ * DOC: probe flow
+ *
+ * The module_init calls the bus specific registration function. The
+ * registration to the bus layer will trigger an enumeration of the bus which
+ * will call the bus specific probe function.
+ * The first thing this function must do is to allocate the memory needed by
+ * iwl_bus + the bus_specific data.
+ * Once the bus specific probe function has configured the hardware, it
+ * chooses the appropriate transport layer and calls iwl_probe that will run
+ * the bus independent probe flow.
+ *
+ * Note: The bus specific code must set the following data in iwl_bus before it
+ *       calls iwl_probe:
+ *	* bus->dev
+ *	* bus->irq
+ *	* bus->ops
+ */
+
 struct iwl_shared;
 struct iwl_bus;
 
 /**
  * struct iwl_bus_ops - bus specific operations
  * @get_pm_support: must returns true if the bus can go to sleep
- * @apm_config: will be called during the config of the APM configuration
+ * @apm_config: will be called during the config of the APM
  * @set_drv_data: set the shared data pointer to the bus layer
  * @get_hw_id: prints the hw_id in the provided buffer
  * @write8: write a byte to register at offset ofs
@@ -93,14 +140,16 @@ struct iwl_bus_ops {
 
 /**
  * struct iwl_bus - bus common data
- * @dev - pointer to struct device * that represent the device
+ *
+ * This data is common to all bus layer implementations.
+ *
+ * @dev - pointer to struct device * that represents the device
  * @ops - pointer to iwl_bus_ops
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  * @irq - the irq number for the device
  * @reg_lock - protect hw register access
  */
 struct iwl_bus {
-	/* Common data to all buses */
 	struct device *dev;
 	const struct iwl_bus_ops *ops;
 	struct iwl_shared *shrd;
@@ -149,6 +198,9 @@ static inline u32 bus_read32(struct iwl_bus *bus, u32 ofs)
 	return bus->ops->read32(bus, ofs);
 }
 
+/*****************************************************
+* Bus layer registration functions
+******************************************************/
 int __must_check iwl_pci_register_driver(void);
 void iwl_pci_unregister_driver(void);
 
-- 
1.7.0.4

