Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:21177 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbJSHyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 03:54:50 -0400
Subject: Re: [PATCH] staging/wilc: fix Kconfig dependencies, second try
To: Arnd Bergmann <arnd@arndb.de>, <gregkh@linuxfoundation.org>
References: <5446980.8Rmykv9Tt3@wuerfel>
CC: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	<linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
	<linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <5624A1AF.8080607@atmel.com> (sfid-20151019_095510_960004_3D708D4E)
Date: Mon, 19 Oct 2015 16:54:23 +0900
MIME-Version: 1.0
In-Reply-To: <5446980.8Rmykv9Tt3@wuerfel>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd Bergmann,

When I apply this patch, I cannot make WILC1000 module (wilc1000.ko) because CONFIG_WILC1000 is y and also I can see some link errors for the cfg80211 APIs.

Can you consider this patch?

Thanks,

Tony.


On 2015년 10월 17일 05:45, Arnd Bergmann wrote:
> My first attempt to fix the Kconfig logic for wilc1000 was incomplete,
> as it missed the case where SPI is built-in while SDIO is modular
> and wilc1000 is configured as built-in in SPI mode (or vice versa),
> which would still lead to a link failure.
>
> This works around the problem by adding an intermediate Kconfig
> symbol "WILC1000_DRIVER" that controls visibility of the SDIO and
> SPI sub-drivers, so we can control the dependencies better.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 9535ebc5e9cc ("staging/wilc1000: fix Kconfig dependencies")
>
> diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
> index 59ccecc316df..ee51b4278088 100644
> --- a/drivers/staging/wilc1000/Kconfig
> +++ b/drivers/staging/wilc1000/Kconfig
> @@ -1,14 +1,16 @@
> -config WILC1000
> -	tristate "WILC1000 support (WiFi only)"
> -	depends on !S390
> +config WILC1000_DRIVER
> +	bool "WILC1000 support (WiFi only)"
>   	depends on CFG80211 && WEXT_CORE && INET
> -	depends on MMC || SPI
>   	---help---
>   	  This module only support IEEE 802.11n WiFi.
>   
> +if WILC1000_DRIVER
> +
> +config WILC1000
> +	tristate
> +
>   choice
>           prompt "Memory Allocation"
> -        depends on WILC1000
>           default WILC1000_PREALLOCATE_AT_LOADING_DRIVER
>   
>   config WILC1000_PREALLOCATE_AT_LOADING_DRIVER
> @@ -29,12 +31,12 @@ endchoice
>   
>   choice
>   	prompt "Bus Type"
> -	depends on WILC1000
>   	default WILC1000_SDIO
>   
> -	config WILC1000_SDIO
> +config WILC1000_SDIO
>   	bool "SDIO support"
>   	depends on MMC
> +	select WILC1000
>   	---help---
>   	  This module adds support for the SDIO interface of adapters using
>   	  WILC1000 chipset. The Atmel WILC1000 SDIO is a full speed interface.
> @@ -45,8 +47,9 @@ choice
>   	  To use this interface, pin9 (SDIO_SPI_CFG) must be grounded. Select
>   	  this if your platform is using the SDIO bus.
>   
> -	config WILC1000_SPI
> +config WILC1000_SPI
>   	depends on SPI
> +	select WILC1000
>   	bool "SPI support"
>   	---help---
>   	  This module adds support for the SPI interface of adapters using
> @@ -60,7 +63,7 @@ endchoice
>   
>   config WILC1000_HW_OOB_INTR
>   	bool "Use out of band interrupt"
> -	depends on WILC1000 && WILC1000_SDIO
> +	depends on WILC1000_SDIO
>   	default n
>   	---help---
>   	  This option enables out-of-band interrupt support for the WILC1000
> @@ -68,3 +71,5 @@ config WILC1000_HW_OOB_INTR
>   	  mechanism for SDIO host controllers that don't support SDIO interrupt.
>   	  Select this option If the SDIO host controller in your platform
>   	  doesn't support SDIO time devision interrupt.
> +
> +endif
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

