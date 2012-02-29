Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35176 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2B2Wvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 17:51:37 -0500
Received: by bkcik5 with SMTP id ik5so2842967bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 14:51:36 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] p54spi: Release GPIO lines and IRQ on error in p54spi_probe
Date: Wed, 29 Feb 2012 23:51:23 +0100
Cc: linux-wireless@vger.kernel.org, chunkeey@web.de,
	larry.finger@lwfinger.net
References: <1330548008-2120-1-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1330548008-2120-1-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201202292351.23306.chunkeey@googlemail.com> (sfid-20120229_235208_404423_BE9CEA65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, February 29, 2012 09:40:08 PM Max Filippov wrote:
> This makes it possible to reload driver if insmod has failed due to
> missing firmware.
> 
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

But I noticed something else... We never free the firmware
in the p54spi_probe errorpath either. 

> ---
>  drivers/net/wireless/p54/p54spi.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
> index 7faed62..f792990 100644
> --- a/drivers/net/wireless/p54/p54spi.c
> +++ b/drivers/net/wireless/p54/p54spi.c
> @@ -618,19 +618,19 @@ static int __devinit p54spi_probe(struct spi_device *spi)
>  	ret = spi_setup(spi);
>  	if (ret < 0) {
>  		dev_err(&priv->spi->dev, "spi_setup failed");
> -		goto err_free_common;
> +		goto err_free;
>  	}
>  
>  	ret = gpio_request(p54spi_gpio_power, "p54spi power");
>  	if (ret < 0) {
>  		dev_err(&priv->spi->dev, "power GPIO request failed: %d", ret);
> -		goto err_free_common;
> +		goto err_free;
>  	}
>  
>  	ret = gpio_request(p54spi_gpio_irq, "p54spi irq");
>  	if (ret < 0) {
>  		dev_err(&priv->spi->dev, "irq GPIO request failed: %d", ret);
> -		goto err_free_common;
> +		goto err_free_gpio_power;
>  	}
>  
>  	gpio_direction_output(p54spi_gpio_power, 0);
> @@ -641,7 +641,7 @@ static int __devinit p54spi_probe(struct spi_device *spi)
>  			  priv->spi);
>  	if (ret < 0) {
>  		dev_err(&priv->spi->dev, "request_irq() failed");
> -		goto err_free_common;
> +		goto err_free_gpio_irq;
>  	}
>  
>  	irq_set_irq_type(gpio_to_irq(p54spi_gpio_irq), IRQ_TYPE_EDGE_RISING);
> @@ -673,6 +673,12 @@ static int __devinit p54spi_probe(struct spi_device *spi)
>  	return 0;
>  
>  err_free_common:
> +	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
> +err_free_gpio_irq:
> +	gpio_free(p54spi_gpio_irq);
> +err_free_gpio_power:
> +	gpio_free(p54spi_gpio_power);
> +err_free:
>  	p54_free_common(priv->hw);
>  	return ret;
>  }
> 
