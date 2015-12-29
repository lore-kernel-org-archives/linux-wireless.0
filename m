Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:59872 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbbL2UJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 15:09:30 -0500
Date: Tue, 29 Dec 2015 15:09:28 -0500 (EST)
Message-Id: <20151229.150928.1955323552394590874.davem@davemloft.net> (sfid-20151229_210951_024071_FF20E01A)
To: wuninsu@gmail.com
Cc: akarwar@marvell.com, nishants@marvell.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, taesoo@gatech.edu,
	yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
Subject: Re: [PATCH] mwifiex: correctly handling kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1451418925-11735-1-git-send-email-wuninsu@gmail.com>
References: <1451418925-11735-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Insu Yun <wuninsu@gmail.com>
Date: Tue, 29 Dec 2015 14:55:25 -0500

> Since kzalloc can be failed in memory pressure,
> it needs to be handled as above kzalloc.
> 
> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/sdio.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index 78a8474..d114934 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -2053,8 +2053,14 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
>  	/* Allocate skb pointer buffers */
>  	card->mpa_rx.skb_arr = kzalloc((sizeof(void *)) *
>  				       card->mp_agg_pkt_limit, GFP_KERNEL);
> +	if (!card->mpa_rx.skb_arr)
> +		return -ENOMEM;
> +
>  	card->mpa_rx.len_arr = kzalloc(sizeof(*card->mpa_rx.len_arr) *
>  				       card->mp_agg_pkt_limit, GFP_KERNEL);
> +	if (!card->mpa_rx.len_arr)
> +		return -ENOMEM;
> +
>  	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
>  					     card->mp_tx_agg_buf_size,
>  					     card->mp_rx_agg_buf_size);

You can't just return, you have to release all of the resources
acquired above the point where the error happens.
