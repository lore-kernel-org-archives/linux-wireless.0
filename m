Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:33487 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbL3StZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 13:49:25 -0500
Received: by mail-ig0-f175.google.com with SMTP id mv3so150528924igc.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 10:49:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450936972-5773-1-git-send-email-glen.lee@atmel.com>
References: <1450936972-5773-1-git-send-email-glen.lee@atmel.com>
Date: Thu, 31 Dec 2015 00:19:25 +0530
Message-ID: <CAFqt6za45Mh-Fa5b5nfLkMuhPsbsC2OwPfVw2SWYZm0NfNWXbA@mail.gmail.com> (sfid-20151230_194929_074664_1555E687)
Subject: Re: [PATCH v2 1/2] staging: wilc1000: fix always return 0 error
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	tony.cho@atmel.com, leo.kim@atmel.com,
	Austin Shin <austin.shin@atmel.com>, adel.noureldin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI Glen,

On Thu, Dec 24, 2015 at 11:32 AM, Glen Lee <glen.lee@atmel.com> wrote:
> This patch fixes a bug that return always 0 so it fails every time.
>
> Fixes: c1af9db78950 ("staging: wilc1000: call linux_sdio_init instead of io_init")
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
> Changes in v2: separate v1 patch into two patches.
> ---
>  drivers/staging/wilc1000/wilc_sdio.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> index e961b50..464d27d 100644
> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -614,8 +614,6 @@ static int sdio_init(struct wilc *wilc)
>         if (!wilc_sdio_init()) {
>                 dev_err(&func->dev, "Failed io init bus...\n");
>                 return 0;
> -       } else {
> -               return 0;
>         }

I think it's better to handle the error case properly when
wilc_sdio_init() call fails.

>
>         /**
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-Souptick
