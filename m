Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:60239 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab0IOTVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 15:21:14 -0400
Subject: Re: [PATCH 04/04] wl1271: 11n Support, 11n Kconfig Configurable
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284575472-19888-5-git-send-email-shahar_levi@ti.com>
References: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
	 <1284575472-19888-5-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 22:21:08 +0300
Message-ID: <1284578468.1569.29.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-15 at 20:31 +0200, ext Shahar Levi wrote:
> Add support to configurable 11n

Please rephrase and make it more descriptive.  Explain that this is
temporary because the code is incomplete and not tested enough.


> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
> index 4a8bb25..1d5e5fd 100644
> --- a/drivers/net/wireless/wl12xx/Kconfig
> +++ b/drivers/net/wireless/wl12xx/Kconfig
> @@ -52,6 +52,13 @@ config WL1271
>  	  If you choose to build a module, it'll be called wl1271. Say N if
>  	  unsure.
>  
> +config WL1271_80211_HT
> +        bool "TI wl1271 802.11 HT support (EXPERIMENTAL)"
> +        depends on WL1271 && EXPERIMENTAL
> +        default y

For now, I'd prefer to have this as default n.


> +        ---help---
> +          This will enable 802.11 HT support for TI wl1271 chipset.
> +

This needs to be much more descriptive in order to avoid comments like
Johannes's. ;)

Please make it clear why the option exist, that it is temporary because
the code is not complete and not thoroughly tested etc.


> diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
> index 078b439..e0db9db 100644
> --- a/drivers/net/wireless/wl12xx/Makefile
> +++ b/drivers/net/wireless/wl12xx/Makefile
> @@ -16,3 +16,7 @@ wl1271-$(CONFIG_NL80211_TESTMODE)	+= wl1271_testmode.o
>  obj-$(CONFIG_WL1271)	+= wl1271.o
>  obj-$(CONFIG_WL1271_SPI)	+= wl1271_spi.o
>  obj-$(CONFIG_WL1271_SDIO)	+= wl1271_sdio.o
> +
> +ifeq ($(CONFIG_WL1271_80211_HT),y)
> +EXTRA_CFLAGS += -DCONFIG_WL1271_HT
> +endif

Please don't do this.  Just use the CONFIG_WL1271_80211_HT flag directly
in the code (see below).


> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index e89e574..8f2cea9 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -2087,7 +2087,9 @@ static struct ieee80211_supported_band wl1271_band_2ghz = {
>  	.n_channels = ARRAY_SIZE(wl1271_channels),
>  	.bitrates = wl1271_rates,
>  	.n_bitrates = ARRAY_SIZE(wl1271_rates),
> +#ifdef CONFIG_WL1271_HT
>  	.ht_cap	= WL12xx_HT_CAP,
> +#endif

Here you can use #ifdef CONFIG_WL1271_80211_HT directly, no need to
duplicate it into a new flag.


-- 
Cheers,
Luca.

