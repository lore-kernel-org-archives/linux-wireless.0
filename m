Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab2BCAQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/28] iwlwifi: Connect IDI transport to driver.
Date: Thu,  2 Feb 2012 15:08:53 -0800
Message-Id: <1328224159-18134-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011741_538126_6E096929)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch connects IDI transport to driver. It does so
by using a number of ifdefs at this stage.
IDI is a new transport that is under development.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c           |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   13 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    1 +
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 03702a2..2c46063 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -454,7 +454,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bus->irq = pdev->irq;
 	bus->ops = &bus_ops_pci;
 
+#ifdef CONFIG_IWLWIFI_IDI
+	err = iwl_probe(bus, &trans_ops_idi, cfg);
+#else
 	err = iwl_probe(bus, &trans_ops_pcie, cfg);
+#endif
 	if (err)
 		goto out_disable_msi;
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 2822b7e..b94c953 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -35,6 +35,10 @@
 #include "iwl-io.h"
 #include "iwl-trans-pcie-int.h"
 
+#ifdef CONFIG_IWLWIFI_IDI
+#include "iwl-amfh.h"
+#endif
+
 /******************************************************************************
  *
  * RX path functions
@@ -1100,8 +1104,11 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		/* Disable periodic interrupt; we use it as just a one-shot. */
 		iwl_write8(bus(trans), CSR_INT_PERIODIC_REG,
 			    CSR_INT_PERIODIC_DIS);
+#ifdef CONFIG_IWLWIFI_IDI
+		iwl_amfh_rx_handler();
+#else
 		iwl_rx_handle(trans);
-
+#endif
 		/*
 		 * Enable periodic interrupt in 8 msec only if we received
 		 * real RX interrupt (instead of just periodic int), to catch
@@ -1123,7 +1130,11 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		isr_stats->tx++;
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
+#ifdef CONFIG_IWLWIFI_IDI
+		trans->shrd->trans->ucode_write_complete = 1;
+#else
 		trans->ucode_write_complete = 1;
+#endif
 		wake_up(&trans->shrd->wait_command_queue);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index affa56f..0b4280c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -647,8 +647,10 @@ static int iwl_nic_init(struct iwl_trans *trans)
 
 	iwl_nic_config(priv(trans));
 
+#ifndef CONFIG_IWLWIFI_IDI
 	/* Allocate the RX queue, or reset if it is already allocated */
 	iwl_rx_init(trans);
+#endif
 
 	/* Allocate or reset and init all Tx and Command queues */
 	if (iwl_tx_init(trans))
@@ -1016,8 +1018,9 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	 */
 	if (test_bit(STATUS_DEVICE_ENABLED, &trans->shrd->status)) {
 		iwl_trans_tx_stop(trans);
+#ifndef CONFIG_IWLWIFI_IDI
 		iwl_trans_rx_stop(trans);
-
+#endif
 		/* Power-down device's busmaster DMA clocks */
 		iwl_write_prph(bus(trans), APMG_CLK_DIS_REG,
 			       APMG_CLK_VAL_DMA_CLK_RQT);
@@ -1298,7 +1301,9 @@ static void iwl_trans_pcie_free(struct iwl_trans *trans)
 {
 	iwl_calib_free_results(trans);
 	iwl_trans_pcie_tx_free(trans);
+#ifndef CONFIG_IWLWIFI_IDI
 	iwl_trans_pcie_rx_free(trans);
+#endif
 	free_irq(bus(trans)->irq, trans);
 	iwl_free_isr_ict(trans);
 	trans->shrd->trans = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 9795a23..2a6649c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -383,6 +383,7 @@ static inline int iwl_trans_resume(struct iwl_trans *trans)
 * Transport layers implementations
 ******************************************************/
 extern const struct iwl_trans_ops trans_ops_pcie;
+extern const struct iwl_trans_ops trans_ops_idi;
 
 int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
 		      const void *data, size_t len);
-- 
1.7.0.4

