Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16786 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab0IPTlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 15:41:21 -0400
Subject: Re: [PATCH v6 2/7] wl1271: propagate set_power's return value
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1284592929-29616-3-git-send-email-ohad@wizery.com>
References: <1284592929-29616-1-git-send-email-ohad@wizery.com>
	 <1284592929-29616-3-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 22:40:18 +0300
Message-ID: <1284666018.8951.66.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 01:22 +0200, ext Ohad Ben-Cohen wrote:
> Make it possible for the set power method to indicate a
> success/failure return value. This is needed to support
> more complex power on/off operations such as SDIO
> power manipulations.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Some comments below.


> diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
> index bc806c7..c1f92e6 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_io.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_io.h
> @@ -144,10 +144,13 @@ static inline void wl1271_power_off(struct wl1271 *wl)
>  	clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
>  }
>  
> -static inline void wl1271_power_on(struct wl1271 *wl)
> +static inline int wl1271_power_on(struct wl1271 *wl)
>  {
> -	wl->if_ops->power(wl, true);
> -	set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
> +	int ret = wl->if_ops->power(wl, true);

I think it look nicer if you keep the "int ret" in one line by itself
and then do a ret = wl->if_ops... on another one.


> +	if (ret == 0)
> +		set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
> +
> +	return ret;
>  }


> diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
> index b5d9565..1d5dc72 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
> @@ -159,35 +159,38 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
>  		wl1271_error("sdio write failed (%d)", ret);
>  }
>  
> -static void wl1271_sdio_power_on(struct wl1271 *wl)
> +static int wl1271_sdio_power_on(struct wl1271 *wl)
>  {
>  	struct sdio_func *func = wl_to_func(wl);
>  
>  	sdio_claim_host(func);
>  	sdio_enable_func(func);
>  	sdio_release_host(func);
> +
> +	return 0;
>  }

You seem to always return 0, so the whole chain to pass the value up
seems unnecessary.  Is this just a preparation for a future patch?

-- 
Cheers,
Luca.

