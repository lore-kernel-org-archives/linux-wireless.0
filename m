Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59546 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbYGCVHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 17:07:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Felipe Maya <felipe.maya@vexcorp.com>
Subject: Re: [PATCH] ssb, b43, b43legacy, b44: Rewrite SSB DMA API
Date: Thu, 3 Jul 2008 23:07:20 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200806201150.29497.mb@bu3sch.de> <1215102618.17143.13.camel@you> <200807032252.35662.mb@bu3sch.de>
In-Reply-To: <200807032252.35662.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807032307.20680.mb@bu3sch.de> (sfid-20080703_230748_729432_1248D506)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 July 2008 22:52:35 Michael Buesch wrote:
> On Thursday 03 July 2008 18:30:18 Felipe Maya wrote:
> > Hi, I have applied this patch and i tested on a wl500gpv2 (BCM5354). The
> > following part disable the ethernet device. If this part of the patch is
> > restored the device work ok.
> 
> 
> Well, I would say your architecture is pretty broken then.
> This patch replaces an incorrect manual DMA mask setting by
> a call to the official API.
> Please report this to your archtitecture maintainer.

Ah and btw, the bug most likely is that dma_set_mask does not
set the dev->coherent_dma_mask or something like that
while the dma remapping function require it to be set (I could be wrong,
this is just guesswork). In any case, I think the bug really is in the
arch DMA implementation and we must not workaround that in the ssb code.
So I will reject a patch that adds the
	dev->coherent_dma_mask = mask;
	dma_dev->dma_mask = &dma_dev->coherent_dma_mask;
stuff back. dma_set_mask should set all required masks for the dma_...
remapping functions. If it doesn't, it's either a bug in dma_set_mask
or in the remapping functions using the wrong mask.
We need to fix it correctly this time, as the whole purpose of
my SSB patch was the get the DMA remapping _right_ so it doesn't break
every two months if somebody changes some arch internal assumption.
So please do not to send me any SSB patch that works around the bug. ;)

> 
> > > -int ssb_dma_set_mask(struct ssb_device *ssb_dev, u64 mask)
> > > +int ssb_dma_set_mask(struct ssb_device *dev, u64 mask)
> > >  {
> > > -	struct device *dma_dev = ssb_dev->dma_dev;
> > > -	int err = 0;
> > > +	int err;
> > >  
> > > -#ifdef CONFIG_SSB_PCIHOST
> > > -	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI) {
> > > -		err = pci_set_dma_mask(ssb_dev->bus->host_pci, mask);
> > > +	switch (dev->bus->bustype) {
> > > +	case SSB_BUSTYPE_PCI:
> > > +		err = pci_set_dma_mask(dev->bus->host_pci, mask);
> > >  		if (err)
> > >  			return err;
> > > -		err = pci_set_consistent_dma_mask(ssb_dev->bus->host_pci, mask);
> > > +		err = pci_set_consistent_dma_mask(dev->bus->host_pci, mask);
> > >  		return err;
> > > +	case SSB_BUSTYPE_SSB:
> > > +		return dma_set_mask(dev->dev, mask);
> > > +	default:
> > > +		__ssb_dma_not_implemented(dev);
> > >  	}
> > > -#endif
> > > -	dma_dev->coherent_dma_mask = mask;
> > > -	dma_dev->dma_mask = &dma_dev->coherent_dma_mask;
> > > -
> > > -	return err;
> > > +	return -ENOSYS;
> > >  }
> > >  EXPORT_SYMBOL(ssb_dma_set_mask);
> > 
> > 
> > 
> > 
> 
> 
> 



-- 
Greetings Michael.
