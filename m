Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108]:58653 "EHLO
	smtp1.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYDXGQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 02:16:34 -0400
Message-ID: <20080424091631.4lh9op46jkg4gg84@naisho.dyndns.info> (sfid-20080424_081710_876265_4F2E99F4)
Date: Thu, 24 Apr 2008 09:16:31 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: rndis_wlan: modparam_workaround_interval is
	never below 0.
References: <480F97B5.9030009@tiscali.nl>
In-Reply-To: <480F97B5.9030009@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Roel Kluin <12o3l@tiscali.nl>:

> priv->param_workaround_interval is unsigned,   
> modparam_workaround_interval not.
> the former is never < 0.
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Thanks.

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

> ---
> diff --git a/drivers/net/wireless/rndis_wlan.c   
> b/drivers/net/wireless/rndis_wlan.c
> index 977751f..d0b1fb1 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -2402,7 +2402,6 @@ static int bcm4320_early_init(struct usbnet *dev)
>  	priv->param_power_output = modparam_power_output;
>  	priv->param_roamtrigger  = modparam_roamtrigger;
>  	priv->param_roamdelta    = modparam_roamdelta;
> -	priv->param_workaround_interval = modparam_workaround_interval;
>
>  	priv->param_country[0] = toupper(priv->param_country[0]);
>  	priv->param_country[1] = toupper(priv->param_country[1]);
> @@ -2425,8 +2424,10 @@ static int bcm4320_early_init(struct usbnet *dev)
>  	else if (priv->param_roamdelta > 2)
>  		priv->param_roamdelta = 2;
>
> -	if (priv->param_workaround_interval < 0)
> +	if (modparam_workaround_interval < 0)
>  		priv->param_workaround_interval = 500;
> +	else
> +		priv->param_workaround_interval = modparam_workaround_interval;
>
>  	rndis_set_config_parameter_str(dev, "Country", priv->param_country);
>  	rndis_set_config_parameter_str(dev, "FrameBursting",
>
>




