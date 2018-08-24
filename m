Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeHXVKy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 17:10:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Colin King <colin.king@canonical.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wcn36xx: replace dma_alloc_coherent + memset with dma_zalloc_coherent
References: <20180824171410.22539-1-colin.king@canonical.com>
Date: Fri, 24 Aug 2018 20:35:12 +0300
In-Reply-To: <20180824171410.22539-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 24 Aug 2018 18:14:10 +0100")
Message-ID: <87bm9rhdm7.fsf@kamboji.qca.qualcomm.com> (sfid-20180824_193531_209035_0AA57F79)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> It is preferable to use dma_zalloc_coherent rather than dam_alloc_coherent
> and memset, so use it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/dxe.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
> index 06cfe8d311f3..e66ddaa39523 100644
> --- a/drivers/net/wireless/ath/wcn36xx/dxe.c
> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
> @@ -174,13 +174,11 @@ static int wcn36xx_dxe_init_descs(struct device *dev, struct wcn36xx_dxe_ch *wcn
>  	int i;
>  
>  	size = wcn_ch->desc_num * sizeof(struct wcn36xx_dxe_desc);
> -	wcn_ch->cpu_addr = dma_alloc_coherent(dev, size, &wcn_ch->dma_addr,
> -					      GFP_KERNEL);
> +	wcn_ch->cpu_addr = dma_zalloc_coherent(dev, size, &wcn_ch->dma_addr,
> +					       GFP_KERNEL);
>  	if (!wcn_ch->cpu_addr)
>  		return -ENOMEM;
>  
> -	memset(wcn_ch->cpu_addr, 0, size);
> -
>  	cur_dxe = (struct wcn36xx_dxe_desc *)wcn_ch->cpu_addr;
>  	cur_ctl = wcn_ch->head_blk_ctl;

Hehe, I think you are the third person submitting a similar patch :)
Anyway, I just applied this few hours ago:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=d410e28f3ae476e1572b8893c646ef44fae7bbbd

-- 
Kalle Valo
