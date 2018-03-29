Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:47088 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752546AbeC2SEM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 14:04:12 -0400
Subject: Re: [PATCH] wcn36xx: allocate skbs with GFP_KERNEL during init
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, rfried@codeaurora.org,
        kvalo@codeaurora.org, bjorn.andersson@linaro.org
References: <20180319063002.24665-1-daniel@zonque.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <0dafe1f7-6f79-faa7-aff9-3eca532d237e@zonque.org> (sfid-20180329_203016_248008_807B8375)
Date: Thu, 29 Mar 2018 20:04:10 +0200
MIME-Version: 1.0
In-Reply-To: <20180319063002.24665-1-daniel@zonque.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, March 19, 2018 07:30 AM, Daniel Mack wrote:
> GFP_ATOMIC should only be used when the allocation is done from atomic
> context. Introduce a new flag to wcn36xx_dxe_fill_skb() and use GFP_KERNEL
> when pre-allocating buffers during init.
> 
> This doesn't fix an issue that was observed in the wild, but it reduces
> the chance of failed allocations under memory pressure.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>

Any opinion about this one?


Thanks,
Daniel

> ---
>  drivers/net/wireless/ath/wcn36xx/dxe.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
> index 5672154948c3..3e180828fbfa 100644
> --- a/drivers/net/wireless/ath/wcn36xx/dxe.c
> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
> @@ -275,12 +275,14 @@ static int wcn36xx_dxe_enable_ch_int(struct wcn36xx *wcn, u16 wcn_ch)
>  	return 0;
>  }
>  
> -static int wcn36xx_dxe_fill_skb(struct device *dev, struct wcn36xx_dxe_ctl *ctl)
> +static int wcn36xx_dxe_fill_skb(struct device *dev,
> +				struct wcn36xx_dxe_ctl *ctl,
> +				gfp_t gfp)
>  {
>  	struct wcn36xx_dxe_desc *dxe = ctl->desc;
>  	struct sk_buff *skb;
>  
> -	skb = alloc_skb(WCN36XX_PKT_SIZE, GFP_ATOMIC);
> +	skb = alloc_skb(WCN36XX_PKT_SIZE, gfp);
>  	if (skb == NULL)
>  		return -ENOMEM;
>  
> @@ -307,7 +309,7 @@ static int wcn36xx_dxe_ch_alloc_skb(struct wcn36xx *wcn,
>  	cur_ctl = wcn_ch->head_blk_ctl;
>  
>  	for (i = 0; i < wcn_ch->desc_num; i++) {
> -		wcn36xx_dxe_fill_skb(wcn->dev, cur_ctl);
> +		wcn36xx_dxe_fill_skb(wcn->dev, cur_ctl, GFP_KERNEL);
>  		cur_ctl = cur_ctl->next;
>  	}
>  
> @@ -533,7 +535,7 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>  	while (!(dxe->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)) {
>  		skb = ctl->skb;
>  		dma_addr = dxe->dst_addr_l;
> -		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl);
> +		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl, GFP_ATOMIC);
>  		if (0 == ret) {
>  			/* new skb allocation ok. Use the new one and queue
>  			 * the old one to network system.
> 
