Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36353 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbbLLBNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 20:13:04 -0500
Received: by pacdm15 with SMTP id dm15so73463444pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2015 17:13:03 -0800 (PST)
Subject: Re: [PATCH] wcn36xx: handle rx skb allocation failure to avoid system
 crash
To: Bob Copeland <me@bobcopeland.com>
References: <1449034051-12536-1-git-send-email-fengwei.yin@linaro.org>
 <566ACC1C.1070304@linaro.org> <20151211133730.GA8835@localhost>
 <566AD356.50404@linaro.org> <20151211140833.GA22332@localhost>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com,
	lking@qti.qualcomm.com
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <566B7499.4040403@linaro.org> (sfid-20151212_021309_116511_177344DF)
Date: Sat, 12 Dec 2015 09:12:57 +0800
MIME-Version: 1.0
In-Reply-To: <20151211140833.GA22332@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015/12/11 22:08, Bob Copeland wrote:
> On Fri, Dec 11, 2015 at 09:44:54PM +0800, fengwei.yin wrote:
>>>             /* skip this frame if we can't alloc a new rx buffer */
>>>             if (ret)
>>>                    goto drop;
>> This can't work because we need to initialize the DMA for the old skb again.
>> Which is done in following
>> 	switch (ch->ch_type) {
>> block.
>
> Hmm, good point.  You could still move that out to a function like this:
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
> index f8dfa05..fd447bf 100644
> --- a/drivers/net/wireless/ath/wcn36xx/dxe.c
> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
> @@ -467,6 +467,27 @@ out_err:
>
>   }
>
> +/* or whatever name makes sense... */
> +static void wcn36xx_restart_dma(struct wcn36xx *wcn,
> +				struct wcn36xx_dxe_ch *ch,
> +				struct wcn36xx_dxe_desc *dxe)
> +{
> +	switch (ch->ch_type) {
> +	case WCN36XX_DXE_CH_RX_L:
> +		dxe->ctrl = WCN36XX_DXE_CTRL_RX_L;
> +		wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
> +					   WCN36XX_DXE_INT_CH1_MASK);
> +		break;
> +	case WCN36XX_DXE_CH_RX_H:
> +		dxe->ctrl = WCN36XX_DXE_CTRL_RX_H;
> +		wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
> +					   WCN36XX_DXE_INT_CH3_MASK);
> +		break;
> +	default:
> +		wcn36xx_warn("Unknown channel\n");
> +	}
> +}
> +
>   static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>   				     struct wcn36xx_dxe_ch *ch)
>   {
> @@ -478,26 +499,18 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>   	while (!(dxe->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)) {
>   		skb = ctl->skb;
>   		dma_addr = dxe->dst_addr_l;
> -		wcn36xx_dxe_fill_skb(wcn->dev, ctl);
> +		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl);
>
> -		switch (ch->ch_type) {
> -		case WCN36XX_DXE_CH_RX_L:
> -			dxe->ctrl = WCN36XX_DXE_CTRL_RX_L;
> -			wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
> -						   WCN36XX_DXE_INT_CH1_MASK);
> -			break;
> -		case WCN36XX_DXE_CH_RX_H:
> -			dxe->ctrl = WCN36XX_DXE_CTRL_RX_H;
> -			wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR,
> -						   WCN36XX_DXE_INT_CH3_MASK);
> -			break;
> -		default:
> -			wcn36xx_warn("Unknown channel\n");
> -		}
> +		/* skip this frame in OOM condition */
> +		if (ret)
> +			goto drop;
>
>   		dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
>   				 DMA_FROM_DEVICE);
>   		wcn36xx_rx_skb(wcn, skb);
> +
> +drop:
> +		wcn36xx_restart_dma(wcn, ch, dxe);
>   		ctl = ctl->next;
>   		dxe = ctl->desc;
>   	}
>
>
>
> ...that said, not really sure it's worth it now that the 'goto' is only
> skipping two lines.  So, I would be ok with the original patch too.
>
I don't want to introduce "goto". But I really like your choice to create
wcn36xx_restart_dma. I will keep some original patch to avoid "goto" and
adopt the function wcn36xx_restart_dma. Will send the patch out.

Regards
Yin, Fengwei
