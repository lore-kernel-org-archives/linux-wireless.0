Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50218 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S944296AbcJSPSc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:51 +0300
Message-Id: <20161019100755.23874-7-luca@coelho.fi> (sfid-20161019_171835_976852_F589B642)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 06/10] iwlwifi: pcie: give a meaningful name to interrupt request
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

Instead of passing DRV_NAME pass a string that
represents the reason for the interrupt.

Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 29 ++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ae95533..b10e363 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1598,6 +1598,29 @@ static void iwl_pcie_irq_set_affinity(struct iwl_trans *trans)
 	}
 }
 
+static const char *queue_name(struct device *dev,
+			      struct iwl_trans_pcie *trans_p, int i)
+{
+	if (trans_p->shared_vec_mask) {
+		int vec = trans_p->shared_vec_mask &
+			  IWL_SHARED_IRQ_FIRST_RSS ? 1 : 0;
+
+		if (i == 0)
+			return DRV_NAME ": shared IRQ";
+
+		return devm_kasprintf(dev, GFP_KERNEL,
+				      DRV_NAME ": queue %d", i + vec);
+	}
+	if (i == 0)
+		return DRV_NAME ": default queue";
+
+	if (i == trans_p->alloc_vecs - 1)
+		return DRV_NAME ": exception";
+
+	return devm_kasprintf(dev, GFP_KERNEL,
+			      DRV_NAME  ": queue %d", i);
+}
+
 static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 				      struct iwl_trans_pcie *trans_pcie)
 {
@@ -1606,6 +1629,10 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 	for (i = 0; i < trans_pcie->alloc_vecs; i++) {
 		int ret;
 		struct msix_entry *msix_entry;
+		const char *qname = queue_name(&pdev->dev, trans_pcie, i);
+
+		if (!qname)
+			return -ENOMEM;
 
 		msix_entry = &trans_pcie->msix_entries[i];
 		ret = devm_request_threaded_irq(&pdev->dev,
@@ -1615,7 +1642,7 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 						iwl_pcie_irq_msix_handler :
 						iwl_pcie_irq_rx_msix_handler,
 						IRQF_SHARED,
-						DRV_NAME,
+						qname,
 						msix_entry);
 		if (ret) {
 			IWL_ERR(trans_pcie->trans,
-- 
2.9.3
