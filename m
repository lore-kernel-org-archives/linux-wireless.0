Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2IGIMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:12:32 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlwifi: remove unused IDI code stubs
Date: Fri,  7 Sep 2012 10:13:08 +0200
Message-Id: <1347005588-16110-1-git-send-email-johannes@sipsolutions.net> (sfid-20120907_101239_551428_FB88B8E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These stubs are from internal experimental code
and aren't needed in the driver in the kernel
so just remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c   |   13 -------------
 drivers/net/wireless/iwlwifi/pcie/rx.c    |   10 ++--------
 drivers/net/wireless/iwlwifi/pcie/trans.c |    8 ++------
 3 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 89bfb43..2a46753 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -263,8 +263,6 @@ MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
 
-#ifndef CONFIG_IWLWIFI_IDI
-
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	const struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
@@ -307,8 +305,6 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 }
 
-#endif /* CONFIG_IWLWIFI_IDI */
-
 #ifdef CONFIG_PM_SLEEP
 
 static int iwl_pci_suspend(struct device *device)
@@ -353,15 +349,6 @@ static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
 
 #endif
 
-#ifdef CONFIG_IWLWIFI_IDI
-/*
- * Defined externally in iwl-idi.c
- */
-int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
-void __devexit iwl_pci_remove(struct pci_dev *pdev);
-
-#endif /* CONFIG_IWLWIFI_IDI */
-
 static struct pci_driver iwl_pci_driver = {
 	.name = DRV_NAME,
 	.id_table = iwl_hw_card_ids,
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index d80604a..7b2ac67 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -35,10 +35,6 @@
 #include "internal.h"
 #include "iwl-op-mode.h"
 
-#ifdef CONFIG_IWLWIFI_IDI
-#include "iwl-amfh.h"
-#endif
-
 /******************************************************************************
  *
  * RX path functions
@@ -723,11 +719,9 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		/* Disable periodic interrupt; we use it as just a one-shot. */
 		iwl_write8(trans, CSR_INT_PERIODIC_REG,
 			    CSR_INT_PERIODIC_DIS);
-#ifdef CONFIG_IWLWIFI_IDI
-		iwl_amfh_rx_handler();
-#else
+
 		iwl_rx_handle(trans);
-#endif
+
 		/*
 		 * Enable periodic interrupt in 8 msec only if we received
 		 * real RX interrupt (instead of just periodic int), to catch
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 38f51b0..e555dff 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -855,10 +855,8 @@ static int iwl_nic_init(struct iwl_trans *trans)
 
 	iwl_op_mode_nic_config(trans->op_mode);
 
-#ifndef CONFIG_IWLWIFI_IDI
 	/* Allocate the RX queue, or reset if it is already allocated */
 	iwl_rx_init(trans);
-#endif
 
 	/* Allocate or reset and init all Tx and Command queues */
 	if (iwl_tx_init(trans))
@@ -1184,9 +1182,8 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	 */
 	if (test_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status)) {
 		iwl_trans_tx_stop(trans);
-#ifndef CONFIG_IWLWIFI_IDI
 		iwl_trans_rx_stop(trans);
-#endif
+
 		/* Power-down device's busmaster DMA clocks */
 		iwl_write_prph(trans, APMG_CLK_DIS_REG,
 			       APMG_CLK_VAL_DMA_CLK_RQT);
@@ -1551,9 +1548,8 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	iwl_trans_pcie_tx_free(trans);
-#ifndef CONFIG_IWLWIFI_IDI
 	iwl_trans_pcie_rx_free(trans);
-#endif
+
 	if (trans_pcie->irq_requested == true) {
 		free_irq(trans_pcie->irq, trans);
 		iwl_free_isr_ict(trans);
-- 
1.7.10.4

