Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 113.245.131.213.static.inetbone.net ([213.131.245.113]:59053
	"EHLO smtp.tmcs.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZIJJpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 05:45:53 -0400
Subject: [RFC] rtl8180: change PCI DMA mask to DMA_BIT_MASK(32) to solve
 "No suitable DMA available" problems on sparc64.
From: Tiziano =?ISO-8859-1?Q?M=FCller?= <tm@dev-zero.ch>
Reply-To: tm@dev-zero.ch
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 10 Sep 2009 11:37:43 +0200
Message-Id: <1252575463.30576.59.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there

I had problems to get my rtl8185 PCI card running on Sparc64: I always
got an error about "No suitable DMA available" followed by an error
that no device could be detected. When comparing the rtl8180 driver to
others I noticed that others are mostly using DMA_BIT_MASK so I changed
the custom mask to DMA_BIT_MASK(32) which fixed my issue.

Cheers,
Tiziano

---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 16429c4..515f562 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -850,8 +850,8 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 		goto err_free_reg;
 	}
 
-	if ((err = pci_set_dma_mask(pdev, 0xFFFFFF00ULL)) ||
-	    (err = pci_set_consistent_dma_mask(pdev, 0xFFFFFF00ULL))) {
+	if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) ||
+	    (err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))) {
 		printk(KERN_ERR "%s (rtl8180): No suitable DMA available\n",
 		       pci_name(pdev));
 		goto err_free_reg;
-- 
1.6.4

