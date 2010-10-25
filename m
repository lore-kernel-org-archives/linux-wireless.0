Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:59474 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab0JYTpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 15:45:40 -0400
Subject: Re: [PATCH] b43: remove extraneous code in free_ringmemory
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
In-Reply-To: <1288016649-4334-1-git-send-email-linville@tuxdriver.com> (sfid-20101025_103012_756543_A179E9D6)
References: <1288016649-4334-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20101025_103012_756543_A179E9D6)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 21:45:37 +0200
Message-ID: <1288035937.24194.0.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-25 at 10:24 -0400, John W. Linville wrote: 
> This code seems to have been cut-n-pasted from alloc_ringmemory?

No. It's leftover from the old SSB DMA mem allocator, which needed
the GFP flags.

> Anyway, it is useless.

ACK.

> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/b43/dma.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
> index 10d0aaf..3d5566e 100644
> --- a/drivers/net/wireless/b43/dma.c
> +++ b/drivers/net/wireless/b43/dma.c
> @@ -415,11 +415,6 @@ static int alloc_ringmemory(struct b43_dmaring *ring)
>  
>  static void free_ringmemory(struct b43_dmaring *ring)
>  {
> -	gfp_t flags = GFP_KERNEL;
> -
> -	if (ring->type == B43_DMA_64BIT)
> -		flags |= GFP_DMA;
> -
>  	dma_free_coherent(ring->dev->dev->dma_dev, B43_DMA_RINGMEMSIZE,
>  			  ring->descbase, ring->dmabase);
>  }


-- 
Greetings Michael.

