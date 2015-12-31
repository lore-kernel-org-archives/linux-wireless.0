Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28647 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbbLaO0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 09:26:34 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBVEPN73004451
	for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2015 06:26:34 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 204ynfrva0-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2015 06:26:34 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/4] mwifiex: fix missing debug messages
Date: Thu, 31 Dec 2015 06:24:12 -0800
Message-ID: <1451571855-29449-1-git-send-email-akarwar@marvell.com> (sfid-20151231_152706_377400_A27D6902)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Some critical messages are missed until "adapter->dev"
gets initialized in mwifiex_register_dev().
We will use pr_* print message instead of mwifiex_dbg at
those places to resolve the problem.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 4000357..165fe4f 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2480,50 +2480,44 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
 
 	pci_set_master(pdev);
 
-	mwifiex_dbg(adapter, INFO,
-		    "try set_consistent_dma_mask(32)\n");
+	pr_notice("try set_consistent_dma_mask(32)\n");
 	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		mwifiex_dbg(adapter, ERROR,
-			    "set_dma_mask(32) failed\n");
+		pr_err("set_dma_mask(32) failed\n");
 		goto err_set_dma_mask;
 	}
 
 	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		mwifiex_dbg(adapter, ERROR,
-			    "set_consistent_dma_mask(64) failed\n");
+		pr_err("set_consistent_dma_mask(64) failed\n");
 		goto err_set_dma_mask;
 	}
 
 	ret = pci_request_region(pdev, 0, DRV_NAME);
 	if (ret) {
-		mwifiex_dbg(adapter, ERROR,
-			    "req_reg(0) error\n");
+		pr_err("req_reg(0) error\n");
 		goto err_req_region0;
 	}
 	card->pci_mmap = pci_iomap(pdev, 0, 0);
 	if (!card->pci_mmap) {
-		mwifiex_dbg(adapter, ERROR, "iomap(0) error\n");
+		pr_err("iomap(0) error\n");
 		ret = -EIO;
 		goto err_iomap0;
 	}
 	ret = pci_request_region(pdev, 2, DRV_NAME);
 	if (ret) {
-		mwifiex_dbg(adapter, ERROR, "req_reg(2) error\n");
+		pr_err("req_reg(2) error\n");
 		goto err_req_region2;
 	}
 	card->pci_mmap1 = pci_iomap(pdev, 2, 0);
 	if (!card->pci_mmap1) {
-		mwifiex_dbg(adapter, ERROR,
-			    "iomap(2) error\n");
+		pr_err("iomap(2) error\n");
 		ret = -EIO;
 		goto err_iomap2;
 	}
 
-	mwifiex_dbg(adapter, INFO,
-		    "PCI memory map Virt0: %p PCI memory map Virt2: %p\n",
-		    card->pci_mmap, card->pci_mmap1);
+	pr_notice("PCI memory map Virt0: %p PCI memory map Virt2: %p\n",
+		  card->pci_mmap, card->pci_mmap1);
 
 	card->cmdrsp_buf = NULL;
 	ret = mwifiex_pcie_create_txbd_ring(adapter);
@@ -2642,11 +2636,11 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 
 	/* save adapter pointer in card */
 	card->adapter = adapter;
+	adapter->dev = &pdev->dev;
 
 	if (mwifiex_pcie_request_irq(adapter))
 		return -1;
 
-	adapter->dev = &pdev->dev;
 	adapter->tx_buf_size = card->pcie.tx_buf_size;
 	adapter->mem_type_mapping_tbl = mem_type_mapping_tbl;
 	adapter->num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl);
-- 
1.8.1.4

