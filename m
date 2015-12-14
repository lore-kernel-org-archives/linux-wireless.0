Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33225 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbbLNWrh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 17:47:37 -0500
Received: by mail-io0-f181.google.com with SMTP id 186so201586iow.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 14:47:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450087610-32477-1-git-send-email-fengwei.yin@linaro.org>
References: <1450087610-32477-1-git-send-email-fengwei.yin@linaro.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 15 Dec 2015 09:47:17 +1100
Message-ID: <CAGRGNgWoub75=8HZdhdwL3gVCO+3GntQ3_aD-WN_r7S3AmQaew@mail.gmail.com> (sfid-20151214_234741_510715_33D00D28)
Subject: Re: [PATCH v2] wcn36xx: handle rx skb allocation failure to avoid
 system crash
To: Fengwei Yin <fengwei.yin@linaro.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org, Bob Copeland <me@bobcopeland.com>,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com,
	lking@qti.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fengwei,

On Mon, Dec 14, 2015 at 9:06 PM, Fengwei Yin <fengwei.yin@linaro.org> wrote:
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
> +#define        GET_CH_CTRL_VALUE(x)                    \
> +       ({ u32 __v = WCN36XX_DXE_CTRL_RX_H;     \
> +          if ((x) == WCN36XX_DXE_CH_RX_L)      \
> +               __v = WCN36XX_DXE_CTRL_RX_L;    \
> +          __v; })
> +
> +#define        GET_CH_INT_MASK(x)                      \
> +       ({ u32 __v = WCN36XX_DXE_INT_CH3_MASK;  \
> +          if ((x) == WCN36XX_DXE_CH_RX_L)      \
> +               __v = WCN36XX_DXE_INT_CH1_MASK; \
> +          __v; })
> +

Why add these ugly macros if you're only calling them once?

>  static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>                                      struct wcn36xx_dxe_ch *ch)
>  {
> @@ -474,36 +486,34 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>         struct wcn36xx_dxe_desc *dxe = ctl->desc;
>         dma_addr_t  dma_addr;
>         struct sk_buff *skb;
> +       int ret = 0, int_mask;
> +       u32 value;
> +

Surely something like:

if (ch->ch_type == WCN36XX_DXE_CH_RX_L) {
    value = WCN36XX_DXE_CTRL_RX_L;
    int_mask = WCN36XX_DXE_INT_CH1_MASK;
} else {
    value = WCN36XX_DXE_CTRL_RX_H;
    int_mask = WCN36XX_DXE_INT_CH3_MASK;
}

would be much cleaner.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
