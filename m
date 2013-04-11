Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47997 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935338Ab3DKMHW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 08:07:22 -0400
Message-ID: <5166A745.9080709@hauke-m.de> (sfid-20130411_140727_545391_66E59AA6)
Date: Thu, 11 Apr 2013 14:06:29 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 11/15] brcmfmac: define and use platform specific data
 for SDIO.
References: <1365679740-25679-1-git-send-email-arend@broadcom.com> <1365679740-25679-12-git-send-email-arend@broadcom.com>
In-Reply-To: <1365679740-25679-12-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2013 01:28 PM, Arend van Spriel wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
> 
> This patch adds support for platform specific data for SDIO
> fullmac devices. Currently OOB interrupts are configured by Kconfig
> BRCMFMAC_SDIO_OOB but that is now determined dynamically by checking
> availibility of platform data.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Piotr Haber <phaber@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/net/wireless/brcm80211/Kconfig             |    9 --
>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  155 ++++++++++----------
>  .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  114 ++++----------
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   29 ++--
>  .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    6 +-
>  include/linux/brcmfmac_platform.h                  |  125 ++++++++++++++++
>  6 files changed, 251 insertions(+), 187 deletions(-)
>  create mode 100644 include/linux/brcmfmac_platform.h
> 

....

> --- /dev/null
> +++ b/include/linux/brcmfmac_platform.h

This should be placed into include/linux/platform_data/

> @@ -0,0 +1,125 @@
> +/*
> + * Copyright (c) 2013 Broadcom Corporation
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#ifndef _LINUX_BRCMFMAC_PLATFORM_H
> +#define _LINUX_BRCMFMAC_PLATFORM_H
> +
> +/*
> + * Platform specific driver functions and data. Through the platform specific
> + * device data functions can be provided to help the brcmfmac driver to
> + * operate with the device in combination with the used platform.
> + *
> + * Use the platform data in the following (similar) way:
> + *
> + *
> +#include <brcmfmac_platform.h>
> +
> +
> +static void brcmfmac_power_on(void)
> +{
> +}
> +
> +static void brcmfmac_power_off(void)
> +{
> +}
> +
> +static void brcmfmac_reset(void)
> +{
> +}
> +
> +static struct brcmfmac_sdio_platform_data brcmfmac_sdio_pdata = {
> +	.power_on		= brcmfmac_power_on,
> +	.power_off		= brcmfmac_power_off,
> +	.reset			= brcmfmac_reset
> +};
> +
> +static struct platform_device brcmfmac_device = {
> +	.name			= BRCMFMAC_SDIO_PDATA_NAME,
> +	.id			= PLATFORM_DEVID_NONE,
> +	.dev.platform_data	= &brcmfmac_sdio_pdata
> +};
> +
> +void __init brcmfmac_init_pdata(void)
> +{
> +	brcmfmac_sdio_pdata.oob_irq_supported = true;
> +	brcmfmac_sdio_pdata.oob_irq_nr = gpio_to_irq(GPIO_BRCMF_SDIO_OOB);
> +	brcmfmac_sdio_pdata.oob_irq_flags = IORESOURCE_IRQ |
> +					    IORESOURCE_IRQ_HIGHLEVEL;
> +	platform_device_register(&brcmfmac_device);
> +}
> + *
> + *
> + * Note: the brcmfmac can be loaded as module or be statically built-in into
> + * the kernel. If built-in then do note that it uses module_init (and
> + * module_exit) routines which equal device_initcall. So if you intend to
> + * create a module with the platform specific data for the brcmfmac and have
> + * it built-in to the kernel then use a higher initcall then device_initcall
> + * (see init.h). If this is not done then brcmfmac will load without problems
> + * but will not pickup the platform data.
> + *
> + * When the driver does not "detect" platform driver data then it will continue
> + * without reporting anything and just assume there is no data needed. Which is
> + * probably true for most platforms.
> + *
> + * Explanation of the platform_data fields:
> + *
> + * drive_strength: is the preferred drive_strength to be used for the SDIO
> + * pins. If 0 then a default value will be used. This is the target drive
> + * strength, the exact drive strength which will be used depends on the
> + * capabilities of the device.
> + *
> + * oob_irq_supported: does the board have support for OOB interrupts. SDIO
> + * in-band interrupts are relatively slow and for having less overhead on
> + * interrupt processing an out of band interrupt can be used. If the HW
> + * supports this then enable this by setting this field to true and configure
> + * the oob related fields.
> + *
> + * oob_irq_nr, oob_irq_flags: the OOB interrupt information. The values are
> + * used for registering the irq using request_irq function.
> + *
> + * power_on: This function is called by the brcmfmac when the module gets
> + * loaded. This can be particularly useful for low power devices. The platform
> + * spcific routine may for example decide to power up the complete device.
> + * If there is no use-case for this function then provide NULL.
> + *
> + * power_off: This function is called by the brcmfmac when the module gets
> + * unloaded. At this point the device can be powered down or otherwise be reset.
> + * So if an actual power_off is not supported but reset is then reset the device
> + * when this function gets called. This can be particularly useful for low power
> + * devices. If there is no use-case for this function (either power-down or
> + * reset) then provide NULL.
> + *
> + * reset: This function can get called if the device communication broke down.
> + * This functionality is particularly useful in case of SDIO type devices. It is
> + * possible to reset a dongle via sdio data interface, but it requires that
> + * this is fully functional. This function is chip/module specific and this
> + * function should return only after the complete reset has completed.
> + */
> +
> +#define BRCMFMAC_SDIO_PDATA_NAME	"brcmfmac_sdio"
> +
> +struct brcmfmac_sdio_platform_data {
> +	unsigned int drive_strength;
> +	bool oob_irq_supported;
> +	unsigned int oob_irq_nr;
> +	unsigned long oob_irq_flags;
> +	void (*power_on)(void);
> +	void (*power_off)(void);
> +	void (*reset)(void);
> +};
> +
> +#endif /* _LINUX_BRCMFMAC_PLATFORM_H */
> +
> 

