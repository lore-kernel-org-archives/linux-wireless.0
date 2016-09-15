Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54870 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753418AbcIOSMn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:27 +0300
Message-Id: <20160915181131.32213-21-luca@coelho.fi> (sfid-20160915_201249_041690_F3113D32)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 21/25] iwlwifi: pcie: replace possible_cpus() with online_cpus() in MSIX mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

In MSIX mode the number of irq depends on the number of
possible cpus existing on the host.
This cause to bug in case there are offline cores.
Take into account only the online CPUs instead.
Also save it in temporary variable.

Fixes: commit 2e5d4a8f61dc ("iwlwifi: pcie: Add new configuration to enable MSIX")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 43c3915..188b0de 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1513,13 +1513,14 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 					struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int max_irqs, num_irqs, i, ret;
+	int max_irqs, num_irqs, i, ret, nr_online_cpus;
 	u16 pci_cmd;
 
 	if (!trans->cfg->mq_rx_supported)
 		goto enable_msi;
 
-	max_irqs = min_t(u32, num_possible_cpus() + 2, IWL_MAX_RX_HW_QUEUES);
+	nr_online_cpus = num_online_cpus();
+	max_irqs = min_t(u32, nr_online_cpus + 2, IWL_MAX_RX_HW_QUEUES);
 	for (i = 0; i < max_irqs; i++)
 		trans_pcie->msix_entries[i].entry = i;
 
@@ -1545,11 +1546,11 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 	 * Two interrupts less: non rx causes shared with FBQ and RSS.
 	 * More than two interrupts: we will use fewer RSS queues.
 	 */
-	if (num_irqs <= num_online_cpus()) {
+	if (num_irqs <= nr_online_cpus) {
 		trans_pcie->trans->num_rx_queues = num_irqs + 1;
 		trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX |
 			IWL_SHARED_IRQ_FIRST_RSS;
-	} else if (num_irqs == num_online_cpus() + 1) {
+	} else if (num_irqs == nr_online_cpus + 1) {
 		trans_pcie->trans->num_rx_queues = num_irqs;
 		trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX;
 	} else {
-- 
2.9.3
