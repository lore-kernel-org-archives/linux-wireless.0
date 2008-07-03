Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-02.mandic.com.br ([200.225.81.133]:35062 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYGCPeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 11:34:14 -0400
Subject: Re: [PATCH] ssb, b43, b43legacy, b44: Rewrite SSB DMA API
From: Felipe Maya <felipe.maya@vexcorp.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200806201150.29497.mb@bu3sch.de>
References: <200806201150.29497.mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 12:30:18 -0400
Message-Id: <1215102618.17143.13.camel@you> (sfid-20080703_173417_888521_C185F1A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I have applied this patch and i tested on a wl500gpv2 (BCM5354). The
following part disable the ethernet device. If this part of the patch is
restored the device work ok.
>  
> -int ssb_dma_set_mask(struct ssb_device *ssb_dev, u64 mask)
> +int ssb_dma_set_mask(struct ssb_device *dev, u64 mask)
>  {
> -	struct device *dma_dev = ssb_dev->dma_dev;
> -	int err = 0;
> +	int err;
>  
> -#ifdef CONFIG_SSB_PCIHOST
> -	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI) {
> -		err = pci_set_dma_mask(ssb_dev->bus->host_pci, mask);
> +	switch (dev->bus->bustype) {
> +	case SSB_BUSTYPE_PCI:
> +		err = pci_set_dma_mask(dev->bus->host_pci, mask);
>  		if (err)
>  			return err;
> -		err = pci_set_consistent_dma_mask(ssb_dev->bus->host_pci, mask);
> +		err = pci_set_consistent_dma_mask(dev->bus->host_pci, mask);
>  		return err;
> +	case SSB_BUSTYPE_SSB:
> +		return dma_set_mask(dev->dev, mask);
> +	default:
> +		__ssb_dma_not_implemented(dev);
>  	}
> -#endif
> -	dma_dev->coherent_dma_mask = mask;
> -	dma_dev->dma_mask = &dma_dev->coherent_dma_mask;
> -
> -	return err;
> +	return -ENOSYS;
>  }
>  EXPORT_SYMBOL(ssb_dma_set_mask);


