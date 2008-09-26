Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50693 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYIZHOV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 03:14:21 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/3] iwlwifi: use correct DMA_MASK
Date: Fri, 26 Sep 2008 15:09:34 +0800
Message-Id: <1222412974-18221-3-git-send-email-yi.zhu@intel.com> (sfid-20080926_091424_681249_F94BDF3E)
In-Reply-To: <1222412974-18221-2-git-send-email-yi.zhu@intel.com>
References: <1222412974-18221-1-git-send-email-yi.zhu@intel.com>
 <1222412974-18221-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

Use correct DMA_MASK: 4964 and 5000 support 36 bit addresses for
pci express memory access.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a589f7e..204abab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4243,13 +4243,13 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
 	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(36));
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (!err)
-			err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		/* both attempts failed: */
 		if (err) {
 			printk(KERN_WARNING "%s: No suitable DMA available.\n",
-- 
1.5.3.6

