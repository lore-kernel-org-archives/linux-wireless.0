Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab2GEIZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/9] iwlwifi: add trailing newline to some messages
Date: Thu,  5 Jul 2012 10:24:52 +0200
Message-Id: <1341476695-6889-7-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102527_755810_73B71509)
In-Reply-To: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
References: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some messages were missing a trailing newline, add it.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index bac0eb0..203d575 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1141,7 +1141,7 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 			FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch), 1000);
 		if (ret < 0)
 			IWL_ERR(trans,
-				"Failing on timeout while stopping DMA channel %d [0x%08x]",
+				"Failing on timeout while stopping DMA channel %d [0x%08x]\n",
 				ch,
 				iwl_read_direct32(trans,
 						  FH_TSSR_TX_STATUS_REG));
@@ -1149,7 +1149,8 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	if (!trans_pcie->txq) {
-		IWL_WARN(trans, "Stopping tx queues that aren't allocated...");
+		IWL_WARN(trans,
+			 "Stopping tx queues that aren't allocated...\n");
 		return 0;
 	}
 
@@ -1426,7 +1427,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 
 	err = iwl_prepare_card_hw(trans);
 	if (err) {
-		IWL_ERR(trans, "Error while preparing HW: %d", err);
+		IWL_ERR(trans, "Error while preparing HW: %d\n", err);
 		goto err_free_irq;
 	}
 
@@ -2127,13 +2128,14 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
-		dev_printk(KERN_ERR, &pdev->dev, "pci_request_regions failed");
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "pci_request_regions failed\n");
 		goto out_pci_disable_device;
 	}
 
 	trans_pcie->hw_base = pci_ioremap_bar(pdev, 0);
 	if (!trans_pcie->hw_base) {
-		dev_printk(KERN_ERR, &pdev->dev, "pci_ioremap_bar failed");
+		dev_printk(KERN_ERR, &pdev->dev, "pci_ioremap_bar failed\n");
 		err = -ENODEV;
 		goto out_pci_release_regions;
 	}
@@ -2154,7 +2156,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	err = pci_enable_msi(pdev);
 	if (err)
 		dev_printk(KERN_ERR, &pdev->dev,
-			   "pci_enable_msi failed(0X%x)", err);
+			   "pci_enable_msi failed(0X%x)\n", err);
 
 	trans->dev = &pdev->dev;
 	trans_pcie->irq = pdev->irq;
-- 
1.7.10

