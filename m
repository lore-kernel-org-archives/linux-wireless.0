Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from seldrel01.sonyericsson.com ([37.139.156.2]:10567 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932649AbbLOAUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 19:20:20 -0500
Date: Mon, 14 Dec 2015 16:20:13 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Fengwei Yin <fengwei.yin@linaro.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
	"me@bobcopeland.com" <me@bobcopeland.com>,
	"k.eugene.e@gmail.com" <k.eugene.e@gmail.com>,
	"lking@qti.qualcomm.com" <lking@qti.qualcomm.com>
Subject: Re: [PATCH v2] wcn36xx: handle rx skb allocation failure to avoid
 system crash
Message-ID: <20151215002013.GS4000@usrtlx11787.corpusers.net> (sfid-20151215_012028_386373_99D0FEB4)
References: <1450087610-32477-1-git-send-email-fengwei.yin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1450087610-32477-1-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon 14 Dec 02:06 PST 2015, Fengwei Yin wrote:

> Lawrence reported that git clone could make system crash on a
> Qualcomm ARM soc based device (DragonBoard, 1G memory without
> swap) running 64bit Debian.
> 
> It's turned out the crash is related with rx skb allocation
> failure. git could consume more than 600MB anonymous memory.
> And system is in extremely memory shortage case.
> 
> But driver didn't handle the rx allocation failure case. This patch
> doesn't submit skb to upper layer if rx skb allocation fails.
> Instead, it reuse the old skb for rx DMA again. It's more like
> drop the packets if system is in memory shortage case.
> 
> With this change, git clone is OOMed instead of system crash.
> 
> Reported-by: King, Lawrence <lking@qti.qualcomm.com>
> Signed-off-by: Fengwei Yin <fengwei.yin@linaro.org>
> ---
> Changes from v1:
>  * Move switch block out of while loop.
>  * Remove the warning of unknown channel because we didn't deal with it.
> 
>  drivers/net/wireless/ath/wcn36xx/dxe.c | 50 ++++++++++++++++++++--------------
>  1 file changed, 30 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
> index f8dfa05..6b61874 100644
> --- a/drivers/net/wireless/ath/wcn36xx/dxe.c
> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
> @@ -467,6 +467,18 @@ out_err:
>  
>  }
>  
> +#define	GET_CH_CTRL_VALUE(x)			\
> +	({ u32 __v = WCN36XX_DXE_CTRL_RX_H;	\
> +	   if ((x) == WCN36XX_DXE_CH_RX_L)	\
> +		__v = WCN36XX_DXE_CTRL_RX_L;	\
> +	   __v; })
> +
> +#define	GET_CH_INT_MASK(x)			\
> +	({ u32 __v = WCN36XX_DXE_INT_CH3_MASK;	\
> +	   if ((x) == WCN36XX_DXE_CH_RX_L)	\
> +		__v = WCN36XX_DXE_INT_CH1_MASK;	\
> +	   __v; })
> +
>  static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>  				     struct wcn36xx_dxe_ch *ch)
>  {
> @@ -474,36 +486,34 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>  	struct wcn36xx_dxe_desc *dxe = ctl->desc;
>  	dma_addr_t  dma_addr;
>  	struct sk_buff *skb;
> +	int ret = 0, int_mask;
> +	u32 value;
> +
> +	value = GET_CH_CTRL_VALUE(ch->ch_type);
> +	int_mask = GET_CH_INT_MASK(ch->ch_type);
>  
>  	while (!(dxe->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)) {
>  		skb = ctl->skb;
>  		dma_addr = dxe->dst_addr_l;
> -		wcn36xx_dxe_fill_skb(wcn->dev, ctl);

I believe a better way to implement this is to check the return value
here and simply break the loop upon error.

> -
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
> -
> -		dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
> -				 DMA_FROM_DEVICE);
> -		wcn36xx_rx_skb(wcn, skb);
> +		ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl);
> +		if (0 == ret) {

With this you say that if allocation of a new skb fails we just mark the
old one as free again and move the list forward. Not unlikely this will
run through all packets in the list and give them back to the hardware.

Most likely both cases will just result in us dropping a series of
packets, but I believe we should leave the buffers occupied rather then
running this loop cycling buffers back to the hardware.

> +			/* new skb allocation ok. Use the new one and queue
> +			 * the old one to network system.
> +			 */
> +			dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
> +					DMA_FROM_DEVICE);
> +			wcn36xx_rx_skb(wcn, skb);
> +		} /* else keep rx skb not submitted and use for rx DMA again */
> +
> +		dxe->ctrl = value;
>  		ctl = ctl->next;
>  		dxe = ctl->desc;
>  	}
>  
>  	ch->head_blk_ctl = ctl;
>  
> +	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_ENCH_ADDR, int_mask);
> +

I suspect this part kicks the hardware, to start filling new dxes after
updating our list. So it does make sense to only do that once, after
looping through all the descriptors. But please do so in a separate
patch, so we can bisect it if it turns out to cause issues.

>  	return 0;
>  }

Regards,
Bjorn
