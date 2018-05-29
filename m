Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46534 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751158AbeE2HZY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:25:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: emmanuel.grumbach@intel.com, jadit2@gmail.com,
        linux-wireless@vger.kernel.org, Hao Wei Tee <angelsl@in04.sg>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 29 May 2018 10:25:17 +0300
Message-Id: <20180529072517.30135-1-luca@coelho.fi> (sfid-20180529_092528_348020_4F98B06D)
Subject: [PATCH] iwlwifi: pcie: compare with number of IRQs requested for, not number of CPUs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hao Wei Tee <angelsl@in04.sg>

When there are 16 or more logical CPUs, we request for
`IWL_MAX_RX_HW_QUEUES` (16) IRQs only as we limit to that number of
IRQs, but later on we compare the number of IRQs returned to
nr_online_cpus+2 instead of max_irqs, the latter being what we
actually asked for. This ends up setting num_rx_queues to 17 which
causes lots of out-of-bounds array accesses later on.

Compare to max_irqs instead, and also add an assertion in case
num_rx_queues > IWM_MAX_RX_HW_QUEUES.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=199551

Signed-off-by: Hao Wei Tee <angelsl@in04.sg>
Tested-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f8a0234d332c..5517ea4c2aa0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1590,14 +1590,13 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 					struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int max_irqs, num_irqs, i, ret, nr_online_cpus;
+	int max_irqs, num_irqs, i, ret;
 	u16 pci_cmd;
 
 	if (!trans->cfg->mq_rx_supported)
 		goto enable_msi;
 
-	nr_online_cpus = num_online_cpus();
-	max_irqs = min_t(u32, nr_online_cpus + 2, IWL_MAX_RX_HW_QUEUES);
+	max_irqs = min_t(u32, num_online_cpus() + 2, IWL_MAX_RX_HW_QUEUES);
 	for (i = 0; i < max_irqs; i++)
 		trans_pcie->msix_entries[i].entry = i;
 
@@ -1623,16 +1622,17 @@ static void iwl_pcie_set_interrupt_capa(struct pci_dev *pdev,
 	 * Two interrupts less: non rx causes shared with FBQ and RSS.
 	 * More than two interrupts: we will use fewer RSS queues.
 	 */
-	if (num_irqs <= nr_online_cpus) {
+	if (num_irqs <= max_irqs - 2) {
 		trans_pcie->trans->num_rx_queues = num_irqs + 1;
 		trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX |
 			IWL_SHARED_IRQ_FIRST_RSS;
-	} else if (num_irqs == nr_online_cpus + 1) {
+	} else if (num_irqs == max_irqs - 1) {
 		trans_pcie->trans->num_rx_queues = num_irqs;
 		trans_pcie->shared_vec_mask = IWL_SHARED_IRQ_NON_RX;
 	} else {
 		trans_pcie->trans->num_rx_queues = num_irqs - 1;
 	}
+	WARN_ON(trans_pcie->trans->num_rx_queues > IWL_MAX_RX_HW_QUEUES);
 
 	trans_pcie->alloc_vecs = num_irqs;
 	trans_pcie->msix_enabled = true;
-- 
2.17.0
