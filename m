Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:56139 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928AbZCEUak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 15:30:40 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] p54pci: convert printk(KERN_* to dev_*
Date: Thu, 5 Mar 2009 21:30:37 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903052130.37768.chunkeey@web.de> (sfid-20090305_213052_594027_EE8F2759)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces most printk(KERN_* "") with their by dev_* analogue.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2009-03-05 15:07:16.000000000 +0100
+++ b/drivers/net/wireless/p54/p54pci.c	2009-03-05 15:11:40.000000000 +0100
@@ -413,8 +413,7 @@ static int p54p_open(struct ieee80211_hw
 	err = request_irq(priv->pdev->irq, &p54p_interrupt,
 			  IRQF_SHARED, "p54pci", dev);
 	if (err) {
-		printk(KERN_ERR "%s: failed to register IRQ handler\n",
-		       wiphy_name(dev->wiphy));
+		dev_err(&priv->pdev->dev, "failed to register IRQ handler\n");
 		return err;
 	}
 
@@ -476,30 +475,26 @@ static int __devinit p54p_probe(struct p
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR "%s (p54pci): Cannot enable new PCI device\n",
-		       pci_name(pdev));
+		dev_err(&pdev->dev, "Cannot enable new PCI device\n");
 		return err;
 	}
 
 	mem_addr = pci_resource_start(pdev, 0);
 	mem_len = pci_resource_len(pdev, 0);
 	if (mem_len < sizeof(struct p54p_csr)) {
-		printk(KERN_ERR "%s (p54pci): Too short PCI resources\n",
-		       pci_name(pdev));
+		dev_err(&pdev->dev, "Too short PCI resources\n");
 		goto err_disable_dev;
 	}
 
 	err = pci_request_regions(pdev, "p54pci");
 	if (err) {
-		printk(KERN_ERR "%s (p54pci): Cannot obtain PCI resources\n",
-		       pci_name(pdev));
+		dev_err(&pdev->dev, "Cannot obtain PCI resources\n");
 		goto err_disable_dev;
 	}
 
 	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
 	    pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
-		printk(KERN_ERR "%s (p54pci): No suitable DMA available\n",
-		       pci_name(pdev));
+		dev_err(&pdev->dev, "No suitable DMA available\n");
 		goto err_free_reg;
 	}
 
@@ -511,8 +506,7 @@ static int __devinit p54p_probe(struct p
 
 	dev = p54_init_common(sizeof(*priv));
 	if (!dev) {
-		printk(KERN_ERR "%s (p54pci): ieee80211 alloc failed\n",
-		       pci_name(pdev));
+		dev_err(&pdev->dev, "ieee80211 alloc failed\n");
 		err = -ENOMEM;
 		goto err_free_reg;
 	}
@@ -525,17 +519,15 @@ static int __devinit p54p_probe(struct p
 
 	priv->map = ioremap(mem_addr, mem_len);
 	if (!priv->map) {
-		printk(KERN_ERR "%s (p54pci): Cannot map device memory\n",
-		       pci_name(pdev));
-		err = -EINVAL;	// TODO: use a better error code?
+		dev_err(&pdev->dev, "Cannot map device memory\n");
+		err = -ENOMEM;
 		goto err_free_dev;
 	}
 
 	priv->ring_control = pci_alloc_consistent(pdev, sizeof(*priv->ring_control),
 						  &priv->ring_control_dma);
 	if (!priv->ring_control) {
-		printk(KERN_ERR "%s (p54pci): Cannot allocate rings\n",
-		       pci_name(pdev));
+		dev_err(&pdev->dev, "Cannot allocate rings\n");
 		err = -ENOMEM;
 		goto err_iounmap;
 	}
@@ -549,8 +541,7 @@ static int __devinit p54p_probe(struct p
 	err = request_firmware(&priv->firmware, "isl3886pci",
 			       &priv->pdev->dev);
 	if (err) {
-		printk(KERN_ERR "%s (p54pci): cannot find firmware "
-			"(isl3886pci)\n", pci_name(priv->pdev));
+		dev_err(&pdev->dev, "Cannot find firmware (isl3886pci)\n");
 		err = request_firmware(&priv->firmware, "isl3886",
 				       &priv->pdev->dev);
 		if (err)
