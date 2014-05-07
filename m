Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:42588 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaEGUBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 16:01:40 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 5/5] iwlwifi: pcie: disable interrupts upon PCIe alloc
Date: Wed,  7 May 2014 23:01:24 +0300
Message-Id: <1399492884-13508-5-git-send-email-egrumbach@gmail.com> (sfid-20140507_220146_764383_ECBDE55E)
In-Reply-To: <536A90BD.8010204@gmail.com>
References: <536A90BD.8010204@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In case RFKILL is in KILL position, the NIC will issue an
interrupt straight away. This interrupt won't be sent
because it is masked in the hardware.
But if our interrupt service routine is called for another
reason (SHARED_IRQ), then we'll look at the interrupt cause
and service it. This can cause bad things if we are not
ready yet.
Explicitly clean the interrupt cause register to make sure
we won't service anything before we are ready to.

Cc: <stable@vger.kernel.org> [3.14]
Reported-and-tested-by: Alexander Monakov <amonakov@gmail.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index dcfd6d8..2365553 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1749,6 +1749,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
+	trans->dev = &pdev->dev;
+	trans_pcie->pci_dev = pdev;
+	iwl_disable_interrupts(trans);
+
 	err = pci_enable_msi(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_msi failed(0X%x)\n", err);
@@ -1760,8 +1764,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	}
 
-	trans->dev = &pdev->dev;
-	trans_pcie->pci_dev = pdev;
 	trans->hw_rev = iwl_read32(trans, CSR_HW_REV);
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
 	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
@@ -1787,8 +1789,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		goto out_pci_disable_msi;
 	}
 
-	trans_pcie->inta_mask = CSR_INI_SET_MASK;
-
 	if (iwl_pcie_alloc_ict(trans))
 		goto out_free_cmd_pool;
 
@@ -1800,6 +1800,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		goto out_free_ict;
 	}
 
+	trans_pcie->inta_mask = CSR_INI_SET_MASK;
+
 	return trans;
 
 out_free_ict:
-- 
1.8.3.2

