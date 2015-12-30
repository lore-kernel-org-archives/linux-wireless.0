Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:32790 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbbL3BhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 20:37:07 -0500
MIME-Version: 1.0
In-Reply-To: <1451420268-15862-1-git-send-email-wuninsu@gmail.com>
References: <1451420268-15862-1-git-send-email-wuninsu@gmail.com>
Date: Wed, 30 Dec 2015 03:37:06 +0200
Message-ID: <CAHp75VdZHrXbUytAcXzitH8zzELjimNihG5LfLqX85u4y502SA@mail.gmail.com> (sfid-20151230_023720_463469_3DC33B61)
Subject: Re: [PATCH] mwifiex: correctly handling kzalloc
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Insu Yun <wuninsu@gmail.com>
Cc: akarwar@marvell.com, nishants@marvell.com,
	Kalle Valo <kvalo@codeaurora.org>,
	"open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 29, 2015 at 10:17 PM, Insu Yun <wuninsu@gmail.com> wrote:

Empty commit message?

> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/sdio.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index 78a8474..a8af72d 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -2053,8 +2053,19 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
>         /* Allocate skb pointer buffers */
>         card->mpa_rx.skb_arr = kzalloc((sizeof(void *)) *
>                                        card->mp_agg_pkt_limit, GFP_KERNEL);

Just noticed: Looks like good candidate for kcalloc or kmalloc_array,
whichever is suitable.

> +       if (!card->mpa_rx.skb_arr) {
> +               kfree(card->mp_regs);
> +               return -ENOMEM;
> +       }
> +
>         card->mpa_rx.len_arr = kzalloc(sizeof(*card->mpa_rx.len_arr) *
>                                        card->mp_agg_pkt_limit, GFP_KERNEL);

Ditto.

> +       if (!card->mpa_rx.len_arr) {
> +               kfree(card->mp_regs);
> +               kfree(card->mpa_rx.skb_arr);


> +               return -ENOMEM;
> +       }
> +
>         ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
>                                              card->mp_tx_agg_buf_size,
>                                              card->mp_rx_agg_buf_size);
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
