Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:37883 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112AbYFUAEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 20:04:52 -0400
Message-ID: <485C45D2.1050106@lwfinger.net> (sfid-20080621_020456_580171_2574711B)
Date: Fri, 20 Jun 2008 19:05:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb, b43, b43legacy, b44: Rewrite SSB DMA API
References: <200806201150.29497.mb@bu3sch.de>
In-Reply-To: <200806201150.29497.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This is a rewrite of the DMA API for SSB devices.
> This is needed, because the old (non-existing) "API" made too many bad
> assumptions on the API of the host-bus (PCI).
> This introduces an almost complete SSB-DMA-API that maps to the lowlevel
> bus-API based on the bustype.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 

Is there a pre-requisite for this patch? I tried to apply it to 
wireless-testing with version v2.6.26-rc6-10526-ga0d3022. Hunk 4 of 
the patch for drivers/net/wireless/b43legacy/dma.c failed due to a 
line missing from the original source:

> @@ -891,39 +890,39 @@ struct b43legacy_dmaring *b43legacy_setu

--snip--

> +		ssb_dma_unmap_single(dev->dev, dma_test,
> +				     sizeof(struct b43legacy_txhdr_fw3),
> +				     DMA_TO_DEVICE);
>  	}
>  
	ring->dev = dev;     <-------------- This line missing.
>  	ring->nr_slots = nr_slots;
>  	ring->mmio_base = b43legacy_dmacontroller_base(type, controller_index);
>  	ring->index = controller_index;
>  	if (type == B43legacy_DMA_64BIT)

Larry
