Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36220 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab0J0T0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 15:26:13 -0400
Subject: Re: [PATCH ] wl1271: Change wl12xx Files Names
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288091935-21688-1-git-send-email-shahar_levi@ti.com>
References: <1288091935-21688-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 22:25:58 +0300
Message-ID: <1288207558.1698.56.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 13:18 +0200, ext Shahar Levi wrote:
> As part of adding support to wl1281/3 all files name prefix removed.
> Also the definition in Kconfig changed respectively.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Thanks, Shahar! I have some comments below.

In the commit message, maybe you could mention that the change makes
sense alto due to wl1273 support (which is already implemented).


> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
> index 1b3b7bd..1f29284 100644
> --- a/drivers/net/wireless/wl12xx/Kconfig
> +++ b/drivers/net/wireless/wl12xx/Kconfig
> @@ -2,55 +2,55 @@ menuconfig WL12XX
>         tristate "TI wl12xx driver support"
>         depends on MAC80211 && EXPERIMENTAL
>         ---help---
> -         This will enable TI wl12xx driver support. The drivers make
> -         use of the mac80211 stack.
> +         This will enable TI wl12xx driver support: 1271, 1273.
> +         The drivers make use of the mac80211 stack.

Maybe "This will enable TI wl12xx driver support for the following
chips: wl1271 and wl1273." would look better?


> -config WL1271
> -       tristate "TI wl1271 support"
> +config WL127X
> +       tristate "TI wl127x support"

Why not use WL12XX and wl12xx here already? Regarding the wl128x stuff,
as I mentioned before, I think it's best if we do the check at runtime
and not in Kconfig.


>         depends on WL12XX && GENERIC_HARDIRQS
>         depends on INET
>         select FW_LOADER
>         select CRC7
>         ---help---
>           This module adds support for wireless adapters based on the
> -         TI wl1271 chipset.
> +         TI wl127x chipset.

TI wl127x is not a chipset.  Maybe we should say "This module adds
support for wireless adapters based on TI wl1271 and TI wl1273
chipsets"?


> -         If you choose to build a module, it'll be called wl1271. Say N if
> +         If you choose to build a module, it'll be called wl127x. Say N if
>           unsure.

"it will be called wl12xx."


> -config WL1271_HT
> -        bool "TI wl1271 802.11 HT support (EXPERIMENTAL)"
> -        depends on WL1271 && EXPERIMENTAL
> +config WL12XX_HT
> +        bool "TI wl12xx 802.11 HT support (EXPERIMENTAL)"
> +        depends on WL127X && EXPERIMENTAL

WL12XX


>          default n
>          ---help---
> -          This will enable 802.11 HT support for TI wl1271 chipset.
> +          This will enable 802.11 HT support for TI wl12xx chipset.

Maybe, to avoid confusion with wl1251 without repeating "wl1271, wl1273"
all the time, we could use "enable 802.11 HT support in the wl12xx
module"?


>           That configuration is temporary due to the code incomplete and
>           still in testing process.
> 
> -config WL1271_SPI
> -       tristate "TI wl1271 SPI support"
> -       depends on WL1271 && SPI_MASTER
> +config WL127X_SPI
> +       tristate "TI wl12xx SPI support"
> +       depends on WL127X && SPI_MASTER

WL12XX_SPI


>         ---help---
>           This module adds support for the SPI interface of adapters using
> -         TI wl1271 chipset.  Select this if your platform is using
> +         TI wl12xx chipset.  Select this if your platform is using

Maybe also here, something like "TI wl12xx chipsets."


>           the SPI bus.
> 
> -         If you choose to build a module, it'll be called wl1251_spi.
> +         If you choose to build a module, it'll be called spi.

Calling it simply "spi" is very confusing.  It should be called
wl12xx_spi. (wl1251 in the previous code was probably a copy&paste
mistake ;)


>           Say N if unsure.
> 
> -config WL1271_SDIO
> -       tristate "TI wl1271 SDIO support"
> -       depends on WL1271 && MMC
> +config WL12XX_SDIO
> +       tristate "TI wl12xx SDIO support"
> +       depends on WL127X && MMC
>         ---help---
>           This module adds support for the SDIO interface of adapters using
> -         TI wl1271 chipset.  Select this if your platform is using
> +         TI wl12xx chipset.  Select this if your platform is using
>           the SDIO bus.
> 
> -         If you choose to build a module, it'll be called
> -         wl1271_sdio. Say N if unsure.
> +         If you choose to build a module, it'll be called sdio.
> +         Say N if unsure.

Same as above for this whole block. "wl12xx chipsets" and wl12xx_sdio.


>  config WL12XX_PLATFORM_DATA
>         bool
> -       depends on WL1271_SDIO != n
> +       depends on WL12XX_SDIO != n
>         default y
> diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
> index 3a80744..a19f4f3 100644
> --- a/drivers/net/wireless/wl12xx/Makefile
> +++ b/drivers/net/wireless/wl12xx/Makefile
> @@ -1,12 +1,14 @@
> -wl1271-objs            = wl1271_main.o  wl1271_cmd.o wl1271_io.o \
> -                         wl1271_event.o wl1271_tx.o  wl1271_rx.o   \
> -                         wl1271_ps.o    wl1271_acx.o wl1271_boot.o \
> -                         wl1271_init.o  wl1271_debugfs.o wl1271_scan.o
> +wl12xx-objs            = main.o  cmd.o io.o \
> +                         event.o tx.o  rx.o   \
> +                         ps.o    acx.o boot.o \
> +                         init.o  debugfs.o scan.o

You can put these in less lines, now that the names are much shorter.


> +wl12xx_spi-objs                = spi.o
> +wl12xx_sdio-objs       = sdio.o

Here...


> -wl1271-$(CONFIG_NL80211_TESTMODE)      += wl1271_testmode.o
> -obj-$(CONFIG_WL1271)   += wl1271.o
> -obj-$(CONFIG_WL1271_SPI)       += wl1271_spi.o
> -obj-$(CONFIG_WL1271_SDIO)      += wl1271_sdio.o
> +wl1271-$(CONFIG_NL80211_TESTMODE)      += testmode.o
> +obj-$(CONFIG_WL127X)                   += wl12xx.o
> +obj-$(CONFIG_WL12XX_SPI)               += wl12xx_spi.o
> +obj-$(CONFIG_WL12XX_SDIO)              += wl12xx_sdio.o

...and here, you're using wl12xx_spi and wl12xx_sdio correctly, which
reinforces my comment about calling the modules "spi.ko" and "sdio.ko"
in the Kconfig section ;)


> diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/conf.h
> similarity index 100%
> rename from drivers/net/wireless/wl12xx/wl1271_conf.h
> rename to drivers/net/wireless/wl12xx/conf.h

You forgot to change this:

#ifndef __WL1271_CONF_H__

to:

#ifndef __WL12XX_CONF_H__

And the other appearances of __WL1271_CONF_H__ in that file.  This
applies to all header files.


> diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.h b/drivers/net/wireless/wl12xx/debugfs.h
> similarity index 98%
> rename from drivers/net/wireless/wl12xx/wl1271_debugfs.h
> rename to drivers/net/wireless/wl12xx/debugfs.h
> index 00a45b2..d12bf93 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_debugfs.h
> +++ b/drivers/net/wireless/wl12xx/debugfs.h
> @@ -24,7 +24,7 @@
>  #ifndef WL1271_DEBUGFS_H
>  #define WL1271_DEBUGFS_H

As mentioned above, this #ifndef and #define needs to be changed too.


> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/main.c
> similarity index 99%
> rename from drivers/net/wireless/wl12xx/wl1271_main.c
> rename to drivers/net/wireless/wl12xx/main.c
> index 63036b5..dab10a5 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -31,20 +31,20 @@

[...]

>  #define WL1271_BOOT_RETRIES 3

Did we agree not to change this stuff for now? Yes, now I remember, it's
better to do it in two steps indeed (ie. do the other changes in a
separate patch).  But I'd rather apply all the patches add once.


-- 
Cheers,
Luca.

