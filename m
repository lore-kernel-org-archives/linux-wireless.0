Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34029 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753711AbdFSK4B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:56:01 -0400
Date: Mon, 19 Jun 2017 13:55:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
Message-ID: <20170619105552.GB23995@elgon.mountain> (sfid-20170619_125604_676615_66F85997)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Igor Mitsyanko,

The patch 98f44cb0655c: "qtnfmac: introduce new FullMAC driver for
Quantenna chipsets" from May 11, 2017, leads to the following static
checker warning:

	drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c:285 qtnf_pcie_init_dma_mask()
	info: return a literal instead of 'ret'

drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
   277  static int
   278  qtnf_pcie_init_dma_mask(struct qtnf_pcie_bus_priv *priv, u64 dma_mask)
   279  {
   280          int ret;
   281  
   282          ret = dma_supported(&priv->pdev->dev, dma_mask);
   283          if (!ret) {
   284                  pr_err("DMA mask %llu not supported\n", dma_mask);
   285                  return ret;

We should probably return a negative?  It's also possible that returning
zero is intended but then we should use a literal so it's more clearly
deliberate.

   286          }
   287  
   288          ret = pci_set_dma_mask(priv->pdev, dma_mask);
   289          if (ret) {
   290                  pr_err("failed to set DMA mask %llu\n", dma_mask);
   291                  return ret;
   292          }
   293  
   294          ret = pci_set_consistent_dma_mask(priv->pdev, dma_mask);
   295          if (ret) {
   296                  pr_err("failed to set consistent DMA mask %llu\n", dma_mask);
   297                  return ret;
   298          }
   299  
   300          return ret;
   301  }

regards,
dan carpenter
