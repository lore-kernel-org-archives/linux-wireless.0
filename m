Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54840 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752020AbcIOSM1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:21 +0300
Message-Id: <20160915181131.32213-15-luca@coelho.fi> (sfid-20160915_203149_373644_3F2A4DF7)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 15/25] iwlwifi: pcie: Set affinity mask for rx interrupt vectors per cpu
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

In order to utilize the host's CPUs in the most efficient way
we bind each rx interrupt vector to each CPU on the host.
Each rx interrupt is prioritized to execute only on the designated CPU
rather than any CPU.
Processor affinity takes advantage of the fact that some remnants of
a process that was run on a given processor may remain in that
processor's memory state for example, data in the CPU cache after
another process is run on that CPU. Scheduling that process to execute
on the same processor could result in an efficient use of process by
reducing performance-degrading situations such as cache misses
and parallel processing.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 32 +++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 8ad92fa..987a077 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -37,6 +37,7 @@
 #include <linux/wait.h>
 #include <linux/pci.h>
 #include <linux/timer.h>
+#include <linux/cpu.h>
 
 #include "iwl-fh.h"
 #include "iwl-csr.h"
@@ -426,6 +427,7 @@ struct iwl_trans_pcie {
 	u32 hw_init_mask;
 	u32 fh_mask;
 	u32 hw_mask;
+	cpumask_t affinity_mask[IWL_MAX_RX_HW_QUEUES];
 };
 
 static inline struct iwl_trans_pcie *
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index be32fe1..d7521c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1573,6 +1573,30 @@ msi:
 	}
 }
 
+static void iwl_pcie_irq_set_affinity(struct iwl_trans *trans)
+{
+	int iter_rx_q, i, ret, cpu, offset;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	i = trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_FIRST_RSS ? 0 : 1;
+	iter_rx_q = trans_pcie->trans->num_rx_queues - 1 + i;
+	offset = 1 + i;
+	for (; i < iter_rx_q ; i++) {
+		/*
+		 * Get the cpu prior to the place to search
+		 * (i.e. return will be > i - 1).
+		 */
+		cpu = cpumask_next(i - offset, cpu_online_mask);
+		cpumask_set_cpu(cpu, &trans_pcie->affinity_mask[i]);
+		ret = irq_set_affinity_hint(trans_pcie->msix_entries[i].vector,
+					    &trans_pcie->affinity_mask[i]);
+		if (ret)
+			IWL_ERR(trans_pcie->trans,
+				"Failed to set affinity mask for IRQ %d\n",
+				i);
+	}
+}
+
 static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 				      struct iwl_trans_pcie *trans_pcie)
 {
@@ -1601,6 +1625,7 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 			return ret;
 		}
 	}
+	iwl_pcie_irq_set_affinity(trans_pcie->trans);
 
 	return 0;
 }
@@ -1760,9 +1785,14 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 	iwl_pcie_rx_free(trans);
 
 	if (trans_pcie->msix_enabled) {
-		for (i = 0; i < trans_pcie->alloc_vecs; i++)
+		for (i = 0; i < trans_pcie->alloc_vecs; i++) {
+			irq_set_affinity_hint(
+				trans_pcie->msix_entries[i].vector,
+				NULL);
+
 			free_irq(trans_pcie->msix_entries[i].vector,
 				 &trans_pcie->msix_entries[i]);
+		}
 
 		pci_disable_msix(trans_pcie->pci_dev);
 		trans_pcie->msix_enabled = false;
-- 
2.9.3
