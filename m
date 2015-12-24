Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33698 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbbLXCjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 21:39:31 -0500
Received: by mail-ig0-f181.google.com with SMTP id mv3so76623041igc.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 18:39:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450838003-24379-1-git-send-email-glen.lee@atmel.com>
References: <1450838003-24379-1-git-send-email-glen.lee@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 24 Dec 2015 13:39:11 +1100
Message-ID: <CAGRGNgWrFdRYXg+912stL9fcYE2ZqbEzNoOiHnyjYvX+5BHR=A@mail.gmail.com> (sfid-20151224_033934_701328_E5DCC561)
Subject: Re: [PATCH] staging: wilc1000: remove wilc_sdio_init
To: Glen Lee <glen.lee@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tony Cho <tony.cho@atmel.com>, leo.kim@atmel.com,
	Austin Shin <austin.shin@atmel.com>, adel.noureldin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Glen,

On Wed, Dec 23, 2015 at 1:33 PM, Glen Lee <glen.lee@atmel.com> wrote:
> wilc_sdio_init return always 1. It is needless, so just remove it and it's
> related codes also.
>
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/wilc_sdio.c | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> index e961b50..caad876 100644
> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -185,11 +185,6 @@ static void wilc_sdio_disable_interrupt(struct wilc *dev)
>         dev_info(&func->dev, "wilc_sdio_disable_interrupt OUT\n");
>  }
>
> -static int wilc_sdio_init(void)
> -{
> -       return 1;
> -}
> -
>  /********************************************
>   *
>   *      Function 0
> @@ -611,13 +606,6 @@ static int sdio_init(struct wilc *wilc)
>
>         g_sdio.irq_gpio = (wilc->dev_irq_num);
>
> -       if (!wilc_sdio_init()) {
> -               dev_err(&func->dev, "Failed io init bus...\n");
> -               return 0;
> -       } else {
> -               return 0;
> -       }
> -

This isn't equivalent code as both arms of the if statement eventually
call return 0.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
