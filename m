Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:40714 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYCVU7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2008 16:59:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Christian Casteyde <casteyde.christian@free.fr>
Subject: Re: [PATCH 2.6.25-rc6] b43/dma.c: fix DMA unmapping in DMA ring error path
Date: Sat, 22 Mar 2008 21:59:08 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <200803221832.18285.casteyde.christian@free.fr>
In-Reply-To: <200803221832.18285.casteyde.christian@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803222159.08293.mb@bu3sch.de> (sfid-20080322_205940_089126_E19BA108)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 March 2008 18:32:18 Christian Casteyde wrote:
> This fixes a DMA mapping leak in error path of the b43_setup_dmaring function.
> When DMA mapping fails because of device mask preventing the allocated DMA
> zone from being used, the mapping should be reversed before the second try with GFP_DMA.

This doesn't fix all occurences of the bug.
I'll send a fixed patch later.

> Signed-off-by: Christian Casteyde <casteyde.christian@free.fr>
> 
> ---
> --- linux-2.6.25.old/drivers/net/wireless/b43/dma.c	2008-03-22 17:28:52.000000000 +0100
> +++ linux-2.6.25/drivers/net/wireless/b43/dma.c	2008-03-22 17:57:44.000000000 +0100
> @@ -854,6 +854,10 @@
>  
>  		if (b43_dma_mapping_error(ring, dma_test, b43_txhdr_size(dev))) {
>  			/* ugh realloc */
> +			if (!dma_mapping_error(dma_test))
> +				dma_unmap_single(dev->dev->dev,
> +						 dma_test, b43_txhdr_size(dev),
> +						 DMA_TO_DEVICE);
>  			kfree(ring->txhdr_cache);
>  			ring->txhdr_cache = kcalloc(nr_slots,
>  						    b43_txhdr_size(dev),
> @@ -867,8 +871,13 @@
>  						  DMA_TO_DEVICE);
>  
>  			if (b43_dma_mapping_error(ring, dma_test,
> -						  b43_txhdr_size(dev)))
> +						  b43_txhdr_size(dev))) {
> +				if (!dma_mapping_error(dma_test))
> +					dma_unmap_single(dev->dev->dev,
> +							 dma_test, b43_txhdr_size(dev),
> +							 DMA_TO_DEVICE);
>  				goto err_kfree_txhdr_cache;
> +			}
>  		}
>  
>  		dma_unmap_single(dev->dev->dev,
> 
> 



-- 
Greetings Michael.
