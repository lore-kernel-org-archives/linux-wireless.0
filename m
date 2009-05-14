Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60047 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbZENX40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 19:56:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/2] b43legacy: Remove unnecessary MMIO in interrupt hotpath
Date: Fri, 15 May 2009 01:54:40 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
References: <4A0CA755.8000802@lwfinger.net>
In-Reply-To: <4A0CA755.8000802@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905150154.40819.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 May 2009 01:20:53 Larry Finger wrote:
>  	dev->dma_reason[0] = b43legacy_read32(dev,
>  					      B43legacy_MMIO_DMA0_REASON)
>  					      & 0x0001DC00;
> -	dev->dma_reason[1] = b43legacy_read32(dev,
> -					      B43legacy_MMIO_DMA1_REASON)
> -					      & 0x0000DC00;
> -	dev->dma_reason[2] = b43legacy_read32(dev,
> -					      B43legacy_MMIO_DMA2_REASON)
> -					      & 0x0000DC00;
> -	dev->dma_reason[3] = b43legacy_read32(dev,
> -					      B43legacy_MMIO_DMA3_REASON)
> -					      & 0x0001DC00;
> -	dev->dma_reason[4] = b43legacy_read32(dev,
> -					      B43legacy_MMIO_DMA4_REASON)
> -					      & 0x0000DC00;
> -	dev->dma_reason[5] = b43legacy_read32(dev,
> -					      B43legacy_MMIO_DMA5_REASON)
> -					      & 0x0000DC00;
> +/* Unused rings.
> + *	dev->dma_reason[1] = b43legacy_read32(dev,
> + *					      B43legacy_MMIO_DMA1_REASON)
> + *					      & 0x0000DC00;
> + *	dev->dma_reason[2] = b43legacy_read32(dev,
> + *					      B43legacy_MMIO_DMA2_REASON)
> + *					      & 0x0000DC00;
> + *	dev->dma_reason[3] = b43legacy_read32(dev,
> + *					      B43legacy_MMIO_DMA3_REASON)
> + *					      & 0x0001DC00;
> + *	dev->dma_reason[4] = b43legacy_read32(dev,
> + *					      B43legacy_MMIO_DMA4_REASON)
> + *					      & 0x0000DC00;
> + *	dev->dma_reason[5] = b43legacy_read32(dev,
> + *					      B43legacy_MMIO_DMA5_REASON)
> + *					      & 0x0000DC00;
> + */

This is not correct. Ring1 is used for transmission.
With this patch applied, you won't receive error notification interrupts
for the TX ring anymore.
And ring3 is used for transmission status reporting on old devices.
This patch breaks it for these devices.

-- 
Greetings, Michael.
