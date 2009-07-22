Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:63368 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbZGVQVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 12:21:19 -0400
Received: by pzk30 with SMTP id 30so5676pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 09:21:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907192126.13207.chunkeey@web.de>
References: <alpine.DEB.2.00.0907171607280.12306@bicker>
	 <200907192126.13207.chunkeey@web.de>
Date: Wed, 22 Jul 2009 15:40:56 +0100
Message-ID: <a63d67fe0907220740o5b16dc0ne04bc9265d3570bc@mail.gmail.com>
Subject: Re: [PATCH v2] p54spi: fix potential null deref in p54spi.c
From: Dan Carpenter <error27@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

On 7/19/09, Christian Lamparter <chunkeey@web.de> wrote:
> From: Dan Carpenter <error27@gmail.com>
>
> Fix a potential NULL dereference bug during
> error handling in p54spi_probe.
>
> This bug was discovered by smatch:
> (http://repo.or.cz/w/smatch.git).
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> On Sunday 19 July 2009 13:53:57 Dan Carpenter wrote:
>
>> We can't use dev_err() becuase "priv" is NULL.
> yep, but that's my fault and not Micheal's.
>
>> Found by smatch (http://repo.or.cz/w/smatch.git).
>> regards,
>> dan carpenter
> what about this alternative?
> it retains the dev_err by simply moving to the spi_device *spi
> which comes from spi-subsystem and is initialized?
>
> Regards,
> 	Chr
> ---
> diff --git a/drivers/net/wireless/p54/p54spi.c
> b/drivers/net/wireless/p54/p54spi.c
> index d5f181a..eef5329 100644
> --- a/drivers/net/wireless/p54/p54spi.c
> +++ b/drivers/net/wireless/p54/p54spi.c
> @@ -600,7 +600,7 @@ static int __devinit p54spi_probe(struct spi_device
> *spi)
>
>  	hw = p54_init_common(sizeof(*priv));
>  	if (!hw) {
> -		dev_err(&priv->spi->dev, "could not alloc ieee80211_hw");
> +		dev_err(&spi->dev, "could not alloc ieee80211_hw");
>  		return -ENOMEM;
>  	}
>
>
>
>
