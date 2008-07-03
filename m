Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55233 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYGCUxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 16:53:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Felipe Maya <felipe.maya@vexcorp.com>
Subject: Re: [PATCH] ssb, b43, b43legacy, b44: Rewrite SSB DMA API
Date: Thu, 3 Jul 2008 22:52:35 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200806201150.29497.mb@bu3sch.de> <1215102618.17143.13.camel@you>
In-Reply-To: <1215102618.17143.13.camel@you>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807032252.35662.mb@bu3sch.de> (sfid-20080703_225307_870393_7820442A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 July 2008 18:30:18 Felipe Maya wrote:
> Hi, I have applied this patch and i tested on a wl500gpv2 (BCM5354). The
> following part disable the ethernet device. If this part of the patch is
> restored the device work ok.


Well, I would say your architecture is pretty broken then.
This patch replaces an incorrect manual DMA mask setting by
a call to the official API.
Please report this to your archtitecture maintainer.


> > -int ssb_dma_set_mask(struct ssb_device *ssb_dev, u64 mask)
> > +int ssb_dma_set_mask(struct ssb_device *dev, u64 mask)
> >  {
> > -	struct device *dma_dev = ssb_dev->dma_dev;
> > -	int err = 0;
> > +	int err;
> >  
> > -#ifdef CONFIG_SSB_PCIHOST
> > -	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI) {
> > -		err = pci_set_dma_mask(ssb_dev->bus->host_pci, mask);
> > +	switch (dev->bus->bustype) {
> > +	case SSB_BUSTYPE_PCI:
> > +		err = pci_set_dma_mask(dev->bus->host_pci, mask);
> >  		if (err)
> >  			return err;
> > -		err = pci_set_consistent_dma_mask(ssb_dev->bus->host_pci, mask);
> > +		err = pci_set_consistent_dma_mask(dev->bus->host_pci, mask);
> >  		return err;
> > +	case SSB_BUSTYPE_SSB:
> > +		return dma_set_mask(dev->dev, mask);
> > +	default:
> > +		__ssb_dma_not_implemented(dev);
> >  	}
> > -#endif
> > -	dma_dev->coherent_dma_mask = mask;
> > -	dma_dev->dma_mask = &dma_dev->coherent_dma_mask;
> > -
> > -	return err;
> > +	return -ENOSYS;
> >  }
> >  EXPORT_SYMBOL(ssb_dma_set_mask);
> 
> 
> 
> 



-- 
Greetings Michael.
