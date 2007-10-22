Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbXJVRLq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 13:11:46 -0400
Subject: Re: [PATCH] libertas: make if_sdio align packets
From: Dan Williams <dcbw@redhat.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071022190532.5077ce3d@poseidon.drzeus.cx>
References: <20071022190532.5077ce3d@poseidon.drzeus.cx>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 13:11:27 -0400
Message-Id: <1193073087.4325.1.camel@localhost.localdomain> (sfid-20071022_181148_952323_DCDB63F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-22 at 19:05 +0200, Pierre Ossman wrote:
> Incoming packets have to be aligned or the IP stack becomes upset.
> Make sure to shift them two bytes to achieve this.
> 
> Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

Acked-by: Dan Williams <dcbw@redhat.com>

John; if you don't have if_sdio.c, please rebase from Linus or something
since it went in with Pierre's SDIO stack.

> ---
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 5b13705..56dd568 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -175,12 +175,20 @@ static int if_sdio_handle_data(struct if_sdio_card *card,
>  		goto out;
>  	}
>  
> -	skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE);
> +	skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + NET_IP_ALIGN);
>  	if (!skb) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}
>  
> +	/*
> +	 * The IP stack is littered with silly assumptions on alignment,
> +	 * so we need to do a bit of layering violation here and make
> +	 * assumptions about the size of the headers between us and the
> +	 * IP stack.
> +	 */
> +	skb_reserve(skb, NET_IP_ALIGN);
> +
>  	data = skb_put(skb, size);
>  
>  	memcpy(data, buffer, size);

