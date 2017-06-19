Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0050.outbound.protection.outlook.com ([104.47.40.50]:23387
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751842AbdFSVfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 17:35:07 -0400
Subject: Re: [bug report] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
References: <20170619105552.GB23995@elgon.mountain>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <3730af22-ad1e-a6d9-273d-af1fe5dc7cb2@quantenna.com> (sfid-20170619_233512_606207_83FC7760)
Date: Mon, 19 Jun 2017 14:35:00 -0700
MIME-Version: 1.0
In-Reply-To: <20170619105552.GB23995@elgon.mountain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2017 03:55 AM, Dan Carpenter wrote:
> 
> External Email
> 
> 
> Hello Igor Mitsyanko,
> 
> The patch 98f44cb0655c: "qtnfmac: introduce new FullMAC driver for
> Quantenna chipsets" from May 11, 2017, leads to the following static
> checker warning:
> 
>          drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c:285 qtnf_pcie_init_dma_mask()
>          info: return a literal instead of 'ret'
> 
> drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
>     277  static int
>     278  qtnf_pcie_init_dma_mask(struct qtnf_pcie_bus_priv *priv, u64 dma_mask)
>     279  {
>     280          int ret;
>     281
>     282          ret = dma_supported(&priv->pdev->dev, dma_mask);
>     283          if (!ret) {
>     284                  pr_err("DMA mask %llu not supported\n", dma_mask);
>     285                  return ret;
> 
> We should probably return a negative?  It's also possible that returning
> zero is intended but then we should use a literal so it's more clearly
> deliberate.

Hello Dan,
it is indeed a bug, 0 is not expected in case of error. Will fix, thanks!

> 
>     286          }
>     287
>     288          ret = pci_set_dma_mask(priv->pdev, dma_mask);
>     289          if (ret) {
>     290                  pr_err("failed to set DMA mask %llu\n", dma_mask);
>     291                  return ret;
>     292          }
>     293
>     294          ret = pci_set_consistent_dma_mask(priv->pdev, dma_mask);
>     295          if (ret) {
>     296                  pr_err("failed to set consistent DMA mask %llu\n", dma_mask);
>     297                  return ret;
>     298          }
>     299
>     300          return ret;
>     301  }
> 
> regards,
> dan carpenter
> 
