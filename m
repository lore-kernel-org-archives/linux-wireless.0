Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbYDUWmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 09/11] iwlwifi: support 64 bit DMA masks
Date: Mon, 21 Apr 2008 15:41:59 -0700
Message-Id: <1208817721-11333-10-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004344_684529_AF348E21)
In-Reply-To: <1208817721-11333-9-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-4-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-5-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-6-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-7-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-8-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds consistent DMA masks for 64 bit

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e35ab6e..7932a67 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7441,13 +7441,19 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
 	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	if (err) {
+		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if (!err)
+			err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		/* both attempts failed: */
 		if (err) {
-			printk(KERN_WARNING DRV_NAME
-				": No suitable DMA available.\n");
+			printk(KERN_WARNING "%s: No suitable DMA available.\n",
+				DRV_NAME);
 			goto out_pci_disable_device;
+		}
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
-- 
1.5.3.4

