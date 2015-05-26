Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbbEZTSI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:08 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/39] iwlwifi: refactor common transport alloc/init code
Date: Tue, 26 May 2015 22:17:19 +0300
Message-Id: <1432667872-18092-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211820_718803_5ACFDBEA)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The transport modules all need to allocate memory and set up
certain values. Refactor that code into a new common function
to share it and to simplify the error handling.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile     |   1 +
 drivers/net/wireless/iwlwifi/iwl-trans.c  | 113 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h  |  20 +++---
 drivers/net/wireless/iwlwifi/pcie/trans.c |  40 ++---------
 4 files changed, 131 insertions(+), 43 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 3d32f41..dbfc5b1 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -9,6 +9,7 @@ iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
 iwlwifi-$(CONFIG_IWLDVM) += iwl-1000.o iwl-2000.o iwl-5000.o iwl-6000.o
 iwlwifi-$(CONFIG_IWLMVM) += iwl-7000.o iwl-8000.o
+iwlwifi-objs		+= iwl-trans.o
 
 iwlwifi-objs += $(iwlwifi-m)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
new file mode 100644
index 0000000..9f8bcef
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -0,0 +1,113 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Mobile Communications GmbH
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
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Mobile Communications GmbH
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
+#include <linux/kernel.h>
+#include "iwl-trans.h"
+
+struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
+				  struct device *dev,
+				  const struct iwl_cfg *cfg,
+				  const struct iwl_trans_ops *ops,
+				  size_t dev_cmd_headroom)
+{
+	struct iwl_trans *trans;
+#ifdef CONFIG_LOCKDEP
+	static struct lock_class_key __key;
+#endif
+
+	trans = kzalloc(sizeof(*trans) + priv_size, GFP_KERNEL);
+	if (!trans)
+		return NULL;
+
+#ifdef CONFIG_LOCKDEP
+	lockdep_init_map(&trans->sync_cmd_lockdep_map, "sync_cmd_lockdep_map",
+			 &__key, 0);
+#endif
+
+	trans->dev = dev;
+	trans->cfg = cfg;
+	trans->ops = ops;
+	trans->dev_cmd_headroom = dev_cmd_headroom;
+
+	snprintf(trans->dev_cmd_pool_name, sizeof(trans->dev_cmd_pool_name),
+		 "iwl_cmd_pool:%s", dev_name(trans->dev));
+	trans->dev_cmd_pool =
+		kmem_cache_create(trans->dev_cmd_pool_name,
+				  sizeof(struct iwl_device_cmd)
+				  + trans->dev_cmd_headroom,
+				  sizeof(void *),
+				  SLAB_HWCACHE_ALIGN,
+				  NULL);
+	if (!trans->dev_cmd_pool)
+		goto free;
+
+	return trans;
+ free:
+	kfree(trans);
+	return NULL;
+}
+
+void iwl_trans_free(struct iwl_trans *trans)
+{
+	kmem_cache_destroy(trans->dev_cmd_pool);
+	kfree(trans);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 56254a8..eb34b94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -1011,19 +1011,19 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans)
 }
 
 /*****************************************************
+ * transport helper functions
+ *****************************************************/
+struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
+				  struct device *dev,
+				  const struct iwl_cfg *cfg,
+				  const struct iwl_trans_ops *ops,
+				  size_t dev_cmd_headroom);
+void iwl_trans_free(struct iwl_trans *trans);
+
+/*****************************************************
 * driver (transport) register/unregister functions
 ******************************************************/
 int __must_check iwl_pci_register_driver(void);
 void iwl_pci_unregister_driver(void);
 
-static inline void trans_lockdep_init(struct iwl_trans *trans)
-{
-#ifdef CONFIG_LOCKDEP
-	static struct lock_class_key __key;
-
-	lockdep_init_map(&trans->sync_cmd_lockdep_map, "sync_cmd_lockdep_map",
-			 &__key, 0);
-#endif
-}
-
 #endif /* __iwl_trans_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 1cb1204..dd1f828 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1366,14 +1366,13 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	iounmap(trans_pcie->hw_base);
 	pci_release_regions(trans_pcie->pci_dev);
 	pci_disable_device(trans_pcie->pci_dev);
-	kmem_cache_destroy(trans->dev_cmd_pool);
 
 	if (trans_pcie->napi.poll)
 		netif_napi_del(&trans_pcie->napi);
 
 	iwl_pcie_free_fw_monitor(trans);
 
-	kfree(trans);
+	iwl_trans_free(trans);
 }
 
 static void iwl_trans_pcie_set_pmi(struct iwl_trans *trans, bool state)
@@ -2466,18 +2465,13 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	u16 pci_cmd;
 	int err;
 
-	trans = kzalloc(sizeof(struct iwl_trans) +
-			sizeof(struct iwl_trans_pcie), GFP_KERNEL);
-	if (!trans) {
-		err = -ENOMEM;
-		goto out;
-	}
+	trans = iwl_trans_alloc(sizeof(struct iwl_trans_pcie),
+				&pdev->dev, cfg, &trans_ops_pcie, 0);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
 
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	trans->ops = &trans_ops_pcie;
-	trans->cfg = cfg;
-	trans_lockdep_init(trans);
 	trans_pcie->trans = trans;
 	spin_lock_init(&trans_pcie->irq_lock);
 	spin_lock_init(&trans_pcie->reg_lock);
@@ -2601,25 +2595,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	/* Initialize the wait queue for commands */
 	init_waitqueue_head(&trans_pcie->wait_command_queue);
 
-	snprintf(trans->dev_cmd_pool_name, sizeof(trans->dev_cmd_pool_name),
-		 "iwl_cmd_pool:%s", dev_name(trans->dev));
-
-	trans->dev_cmd_headroom = 0;
-	trans->dev_cmd_pool =
-		kmem_cache_create(trans->dev_cmd_pool_name,
-				  sizeof(struct iwl_device_cmd)
-				  + trans->dev_cmd_headroom,
-				  sizeof(void *),
-				  SLAB_HWCACHE_ALIGN,
-				  NULL);
-
-	if (!trans->dev_cmd_pool) {
-		err = -ENOMEM;
-		goto out_pci_disable_msi;
-	}
-
 	if (iwl_pcie_alloc_ict(trans))
-		goto out_free_cmd_pool;
+		goto out_pci_disable_msi;
 
 	err = request_threaded_irq(pdev->irq, iwl_pcie_isr,
 				   iwl_pcie_irq_handler,
@@ -2636,8 +2613,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 out_free_ict:
 	iwl_pcie_free_ict(trans);
-out_free_cmd_pool:
-	kmem_cache_destroy(trans->dev_cmd_pool);
 out_pci_disable_msi:
 	pci_disable_msi(pdev);
 out_pci_release_regions:
@@ -2645,7 +2620,6 @@ out_pci_release_regions:
 out_pci_disable_device:
 	pci_disable_device(pdev);
 out_no_pci:
-	kfree(trans);
-out:
+	iwl_trans_free(trans);
 	return ERR_PTR(err);
 }
-- 
2.1.4

