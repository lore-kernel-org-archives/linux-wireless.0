Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:33056 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbbGPJDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2015 05:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <1435826089-83970-1-git-send-email-poggi.raph@gmail.com>
References: <1435826089-83970-1-git-send-email-poggi.raph@gmail.com>
From: =?UTF-8?Q?Rapha=C3=ABl_Poggi?= <poggi.raph@gmail.com>
Date: Thu, 16 Jul 2015 11:03:10 +0200
Message-ID: <CACqcpZBXwt4GEbQqARY6UGfGUewUd1KUHrA8BJoLcOHkGQg8MA@mail.gmail.com> (sfid-20150716_110852_283714_A70BF2F0)
Subject: Re: [PATCH] wlcore: sdio: return correct error code
To: kvalo@codeaurora.org, luca@coelho.fi
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Raphael Poggi <poggi.raph@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping ?

2015-07-02 10:34 GMT+02:00 Raphael Poggi <poggi.raph@gmail.com>:
> When wlcore_probe_of failed, return the correct error code instead of ENOMEM
>
> Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
> ---
>  drivers/net/wireless/ti/wlcore/sdio.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> index ea7e07a..c172da5 100644
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> @@ -293,7 +293,8 @@ static int wl1271_probe(struct sdio_func *func,
>         /* Use block mode for transferring over one block size of data */
>         func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
>
> -       if (wlcore_probe_of(&func->dev, &irq, &pdev_data))
> +       ret = wlcore_probe_of(&func->dev, &irq, &pdev_data);
> +       if (ret)
>                 goto out_free_glue;
>
>         /* if sdio can keep power while host is suspended, enable wow */
> --
> 2.1.0
>
