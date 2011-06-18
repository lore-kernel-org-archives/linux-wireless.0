Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab1FRQFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/25] iwlagn: finally kill the pointer to pci_dev from iwl-dev.h
Date: Sat, 18 Jun 2011 08:34:21 -0700
Message-Id: <1308411271-26093-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180602_907249_EEC0E5DD)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All pci related stuff is in iwl-pci.c.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   10 ----------
 drivers/net/wireless/iwlwifi/iwl-dev.h |    4 ----
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e2b319f..17228f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -32,9 +32,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-/* TODO: remove include to PCI*.h when no PCI will be needed here */
-#include <linux/pci.h>
-#include <linux/pci-aspm.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
@@ -3488,12 +3485,6 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	/************************
 	 * 1. Allocating HW data
 	 ************************/
-	/* TODO: remove this nasty hack when PCI encapsulation is done
-	 * assumes that struct pci_dev * is at the very beginning of whatever
-	 * is pointed by bus_specific */
-	unsigned long *ppdev = bus_specific;
-	struct pci_dev *pdev = (struct pci_dev *) *ppdev;
-
 	hw = iwl_alloc_all(cfg);
 	if (!hw) {
 		err = -ENOMEM;
@@ -3512,7 +3503,6 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
-	priv->pci_dev = pdev;
 	priv->inta_mask = CSR_INI_SET_MASK;
 
 	/* is antenna coupling more than 35dB ? */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f6b54c6..34f9d0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1293,10 +1293,6 @@ struct iwl_priv {
 	spinlock_t reg_lock;	/* protect hw register access */
 	struct mutex mutex;
 
-	/* TODO: remove this after PCI abstraction is done */
-	/* basic pci-network driver stuff */
-	struct pci_dev *pci_dev;
-
 	struct iwl_bus bus;	/* bus specific data */
 
 	/* microcode/device supports multiple contexts */
-- 
1.7.0.4

