Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35571 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbcC3OGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/43] iwlwifi: pcie: Fix index iteration on free_irq in MSIX mode
Date: Wed, 30 Mar 2016 17:05:11 +0300
Message-Id: <1459346715-7954-39-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160642_582635_89510C43)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

In MSIX mode we iterate over the allocated interrupt vectors and
register them to an handler. In case of registration failure,
we free all the allocated irq.
we use the outer index mistakenly instead of the inner one.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f1a506b..5e1a13e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1500,8 +1500,8 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 			IWL_ERR(trans_pcie->trans,
 				"Error allocating IRQ %d\n", i);
 			for (j = 0; j < i; j++)
-				free_irq(trans_pcie->msix_entries[i].vector,
-					 &trans_pcie->msix_entries[i]);
+				free_irq(trans_pcie->msix_entries[j].vector,
+					 &trans_pcie->msix_entries[j]);
 			pci_disable_msix(pdev);
 			return ret;
 		}
-- 
2.5.0

