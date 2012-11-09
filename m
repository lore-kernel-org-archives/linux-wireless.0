Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab2KIUJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:09:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/13] iwlwifi: remove useless messages
Date: Fri,  9 Nov 2012 21:08:10 +0100
Message-Id: <1352491692-28994-12-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210913_440988_1BAFFA0F)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to print the PCI resource
length and base address, nor the hardware
revision ID (which can be found in lspci)

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 0703da8..74d4c79 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2176,15 +2176,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		goto out_pci_release_regions;
 	}
 
-	dev_printk(KERN_INFO, &pdev->dev,
-		   "pci_resource_len = 0x%08llx\n",
-		   (unsigned long long) pci_resource_len(pdev, 0));
-	dev_printk(KERN_INFO, &pdev->dev,
-		   "pci_resource_base = %p\n", trans_pcie->hw_base);
-
-	dev_printk(KERN_INFO, &pdev->dev,
-		   "HW Revision ID = 0x%X\n", pdev->revision);
-
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
-- 
1.8.0

