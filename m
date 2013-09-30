Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54128 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3I3JC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:02:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlwifi: pcie: fix merge damage
Date: Mon, 30 Sep 2013 11:02:46 +0200
Message-Id: <1380531766-15384-1-git-send-email-johannes@sipsolutions.net> (sfid-20130930_110300_453054_8E26BCBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The merge b35c8097 seems to have lost commit eabc4ac5d,
put the code back.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index bad95d2..c3f904d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1401,6 +1401,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	spin_lock_init(&trans_pcie->reg_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
+	err = pci_enable_device(pdev);
+	if (err)
+		goto out_no_pci;
+
 	if (!cfg->base_params->pcie_l1_allowed) {
 		/*
 		 * W/A - seems to solve weird behavior. We need to remove this
@@ -1412,10 +1416,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				       PCIE_LINK_STATE_CLKPM);
 	}
 
-	err = pci_enable_device(pdev);
-	if (err)
-		goto out_no_pci;
-
 	pci_set_master(pdev);
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
-- 
1.8.4.rc3

