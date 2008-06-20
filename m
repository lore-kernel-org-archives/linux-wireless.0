Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55041 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYFTKls (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 06:41:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] ssb, b43, b43legacy, b44: Rewrite SSB DMA API
Date: Fri, 20 Jun 2008 12:41:12 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200806201150.29497.mb@bu3sch.de>
In-Reply-To: <200806201150.29497.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806201241.12344.mb@bu3sch.de> (sfid-20080620_124152_391117_EEB3AFB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 June 2008 11:50:29 Michael Buesch wrote:
> This is a rewrite of the DMA API for SSB devices.
> This is needed, because the old (non-existing) "API" made too many bad
> assumptions on the API of the host-bus (PCI).
> This introduces an almost complete SSB-DMA-API that maps to the lowlevel
> bus-API based on the bustype.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> John, please merge for 2.6.27
> This is one huge patch, because it's not really possible to split this
> without breaking bisect.

Note that this patch will slightly clash with another DMA update
that's going into linux-next.
This is trivial to resolve, however. wiggle will probably be able to
resolve most, if not all, of them.

>  static bool b43_dma_mapping_error(struct b43_dmaring *ring,
>  				  dma_addr_t addr,
>  				  size_t buffersize, bool dma_to_device)
>  {
> -	if (unlikely(dma_mapping_error(addr)))
> +	if (unlikely(ssb_dma_mapping_error(ring->dev->dev, addr)))
>  		return 1;


These calls will clash. The patch in linux-next introduced an additional
dev parameter to dma_mapping_error.
The fix is obvious. Remove the clashing line and add the ssb_dma_mapping_error
call exactly as shown above.

> +static inline int ssb_dma_mapping_error(struct ssb_device *dev, dma_addr_t addr)
> +{
> +	switch (dev->bus->bustype) {
> +	case SSB_BUSTYPE_PCI:
> +		return pci_dma_mapping_error(addr);
> +	case SSB_BUSTYPE_SSB:
> +		return dma_mapping_error(addr);
> +	default:
> +		__ssb_dma_not_implemented(dev);
> +	}
> +	return -ENOSYS;
> +}


The patch in linux-next will require a dev parameter to the lowlevel
functions. Simply do it this way:

pci_dma_mapping_error(dev->bus->host_pci, addr);

and

dma_mapping_error(dev->dev, addr);

-- 
Greetings Michael.
