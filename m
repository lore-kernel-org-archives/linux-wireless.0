Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51990 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3FYRaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 13:30:11 -0400
Date: Tue, 25 Jun 2013 13:23:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [RFC][PATCH] b43: replace B43_BCMA_EXTRA with modparam
 allhwsupport
Message-ID: <20130625172305.GA31220@tuxdriver.com> (sfid-20130625_193020_463222_982A2381)
References: <1372174495-14471-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1372174495-14471-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seems OK to me...

On Tue, Jun 25, 2013 at 05:34:55PM +0200, Rafał Miłecki wrote:
> This allows enabling support for extra hardware with just a module
> param, without kernel/module recompilation.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/Kconfig |    6 ------
>  drivers/net/wireless/b43/main.c  |   16 ++++++++++++++--
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
> index 3f21e0b..51ff0b1 100644
> --- a/drivers/net/wireless/b43/Kconfig
> +++ b/drivers/net/wireless/b43/Kconfig
> @@ -31,12 +31,6 @@ config B43_BCMA
>  	depends on B43 && (BCMA = y || BCMA = B43)
>  	default y
>  
> -config B43_BCMA_EXTRA
> -	bool "Hardware support that overlaps with the brcmsmac driver"
> -	depends on B43_BCMA
> -	default n if BRCMSMAC
> -	default y
> -
>  config B43_SSB
>  	bool
>  	depends on B43 && (SSB = y || SSB = B43)
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index a95b77a..583993c 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -113,13 +113,19 @@ static int b43_modparam_pio = 0;
>  module_param_named(pio, b43_modparam_pio, int, 0644);
>  MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
>  
> +#ifdef CONFIG_BRCMSMAC
> +static int modparam_allhwsupport;
> +#else
> +static int modparam_allhwsupport = 1;
> +#endif
> +module_param_named(allhwsupport, modparam_allhwsupport, int, 0444);
> +MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if overlaps with the brcmsmac driver)");
> +
>  #ifdef CONFIG_B43_BCMA
>  static const struct bcma_device_id b43_bcma_tbl[] = {
>  	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x11, BCMA_ANY_CLASS),
> -#ifdef CONFIG_B43_BCMA_EXTRA
>  	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x17, BCMA_ANY_CLASS),
>  	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x18, BCMA_ANY_CLASS),
> -#endif
>  	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x1D, BCMA_ANY_CLASS),
>  	BCMA_CORETABLE_END
>  };
> @@ -5396,6 +5402,12 @@ static int b43_bcma_probe(struct bcma_device *core)
>  	struct b43_wl *wl;
>  	int err;
>  
> +	if (!modparam_allhwsupport &&
> +	    (core->id.rev == 0x17 || core->id.rev == 0x18)) {
> +		pr_err("Support for cores revisions 0x17 and 0x18 disabled by module param allhwsupport=0. Try b43.allhwsupport=1\n");
> +		return -ENOTSUPP;
> +	}
> +
>  	dev = b43_bus_dev_bcma_init(core);
>  	if (!dev)
>  		return -ENODEV;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
