Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46847 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab2LEPJp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 10:09:45 -0500
Message-ID: <50BF63A5.9050504@hauke-m.de> (sfid-20121205_160949_258263_45D68803)
Date: Wed, 05 Dec 2012 16:09:25 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Subject: Re: [PATCH 04/11] brcmsmac: radio on led support
References: <1354717564-7183-1-git-send-email-arend@broadcom.com> <1354717564-7183-5-git-send-email-arend@broadcom.com>
In-Reply-To: <1354717564-7183-5-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2012 03:25 PM, Arend van Spriel wrote:
> From: Piotr Haber <phaber@broadcom.com>
> 
> Add support for radio on led indicator.
> 
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Piotr Haber <phaber@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

I am planing to add support for led control into bcma/ssb in the future,
as SoC often have some additional leds like one showing that there is an
USB device plugged in and so on, these are often controlled by
userspace. I haven't planed much on how to do this, but it would be nice
if bcma knows who controls which leds, would it make sense to move some
of this code to bcma and brcmsmac only says it wants this led to trigger
now or something like this?

> ---
>  drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    3 +-
>  drivers/net/wireless/brcm80211/brcmsmac/led.c      |  103 ++++++++++++++++++++
>  drivers/net/wireless/brcm80211/brcmsmac/led.h      |   29 ++++++
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    5 +
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    4 +
>  5 files changed, 143 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.c
>  create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.h
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
> index d3d4151..0efa1c4 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
> @@ -41,7 +41,8 @@ BRCMSMAC_OFILES := \
>  	phy/phy_qmath.o \
>  	dma.o \
>  	brcms_trace_events.o \
> -	debug.o
> +	debug.o	\
> +	led.o
>  
>  MODULEPFX := brcmsmac
>  
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/led.c b/drivers/net/wireless/brcm80211/brcmsmac/led.c
> new file mode 100644
> index 0000000..9babf98
> --- /dev/null
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/led.c
> @@ -0,0 +1,103 @@
> +#include <net/mac80211.h>
> +#include <linux/bcma/bcma_driver_chipcommon.h>
> +
> +#include "mac80211_if.h"
> +#include "pub.h"
> +#include "main.h"
> +#include "led.h"
> +
> +	/* number of leds */
> +#define  BRCMS_LED_NO		4
> +	/* behavior mask */
> +#define  BRCMS_LED_BEH_MASK	0x7f
> +	/* activelow (polarity) bit */
> +#define  BRCMS_LED_AL_MASK	0x80
> +	/* radio enabled */
> +#define  BRCMS_LED_RADIO	3
> +
> +static void brcms_radio_led_ctrl(struct brcms_info *wl, bool state)
> +{
> +	/* get CC core */
> +	struct bcma_drv_cc *cc_drv  = &wl->wlc->hw->d11core->bus->drv_cc;
> +	int gpio_out;
> +
> +	if (wl->radio_led.gpio == 0xf)
> +		return;
> +
> +	gpio_out = 1 << wl->radio_led.gpio;
> +	if (wl->radio_led.active_low)
> +		state = !state;
> +
> +	if (state)
> +		bcma_cc_set32(cc_drv, BCMA_CC_GPIOOUT, gpio_out);
> +	else
> +		bcma_cc_mask32(cc_drv, BCMA_CC_GPIOOUT, ~gpio_out);

Could you use bcma_chipco_gpio_out() instead, in the mips tree is a
patch adding locking around the gpio registers. bcma_cc_set32 and
bcma_cc_mask32 are not atomic. Two threads are accessing them in
parallel will cause problems. The patches in the mips tree are adding
full libgpio support, so it should also be possible to register the gpio
from the generic gpio system and use the generic gpio functions.

> +}
> +
> +
> +/* Callback from the LED subsystem. */
> +static void brcms_led_brightness_set(struct led_classdev *led_dev,
> +				   enum led_brightness brightness)
> +{
> +	struct brcms_info *wl = container_of(led_dev,
> +		struct brcms_info, led_dev);
> +	brcms_radio_led_ctrl(wl, brightness);
> +}
> +
> +void brcms_led_register(struct brcms_info *wl)
> +{
> +	if (wl->radio_led.gpio == 0xf)
> +		return;
> +
> +	snprintf(wl->radio_led.name, sizeof(wl->radio_led.name),
> +		 "brcmsmac-%s:radio", wiphy_name(wl->wiphy));
> +
> +	wl->led_dev.name = wl->radio_led.name;
> +	wl->led_dev.default_trigger =
> +		ieee80211_get_radio_led_name(wl->pub->ieee_hw);
> +	wl->led_dev.brightness_set = brcms_led_brightness_set;
> +	led_classdev_register(wiphy_dev(wl->wiphy), &wl->led_dev);
> +}
> +
> +void brcms_led_unregister(struct brcms_info *wl)
> +{
> +	if (wl->led_dev.dev)
> +		led_classdev_unregister(&wl->led_dev);
> +}
> +
> +void brcms_led_init(struct brcms_info *wl)
> +{
> +	int i;
> +	struct brcms_led *radio_led = &wl->radio_led;
> +	/* get CC core */
> +	struct bcma_drv_cc *cc_drv  = &wl->wlc->hw->d11core->bus->drv_cc;
> +	struct ssb_sprom *sprom = &wl->wlc->hw->d11core->bus->sprom;
> +	u8 *leds[] = { &sprom->gpio0,
> +		&sprom->gpio1,
> +		&sprom->gpio2,
> +		&sprom->gpio3 };
> +
> +	/* none by default */
> +	radio_led->gpio = 0xf;
> +	radio_led->active_low = false;
> +
> +	/* find radio enabled LED */
> +	for (i = 0; i < BRCMS_LED_NO; i++) {
> +		u8 led = *leds[i];
> +		if ((led & BRCMS_LED_BEH_MASK) == BRCMS_LED_RADIO) {
> +			radio_led->gpio = i;
> +			if (led & BRCMS_LED_AL_MASK)
> +				radio_led->active_low = true;
> +			break;
> +		}
> +	}
> +
> +	if (radio_led->gpio != 0xf) {
> +		int gpio_out = 1 << radio_led->gpio;
> +		/* enable out */
> +		bcma_cc_set32(cc_drv, BCMA_CC_GPIOOUTEN, gpio_out);
> +		if (radio_led->active_low)
> +			bcma_cc_set32(cc_drv, BCMA_CC_GPIOPULLUP, gpio_out);

Same for these register accesses.

> +	}
> +}
> +
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/led.h b/drivers/net/wireless/brcm80211/brcmsmac/led.h
> new file mode 100644
> index 0000000..ce3f8a4
> --- /dev/null
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/led.h
> @@ -0,0 +1,29 @@
> +/*
> + * Copyright (c) 2012 Broadcom Corporation
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
> +#ifndef _BRCM_LED_H_
> +#define _BRCM_LED_H_
> +struct brcms_led {
> +	char name[32];
> +	u8 gpio;
> +	bool active_low;
> +};
> +
> +void brcms_led_register(struct brcms_info *wl);
> +void brcms_led_unregister(struct brcms_info *wl);
> +void brcms_led_init(struct brcms_info *wl);
> +
> +#endif /* _BRCM_LED_H_ */
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index 85dbaf8..b1ea75f 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -34,6 +34,7 @@
>  #include "mac80211_if.h"
>  #include "main.h"
>  #include "debug.h"
> +#include "led.h"
>  
>  #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
>  
> @@ -884,6 +885,7 @@ static void brcms_remove(struct bcma_device *pdev)
>  	struct brcms_info *wl = hw->priv;
>  
>  	if (wl->wlc) {
> +		brcms_led_unregister(wl);
>  		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
>  		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
>  		ieee80211_unregister_hw(hw);
> @@ -1129,6 +1131,9 @@ static int __devinit brcms_bcma_probe(struct bcma_device *pdev)
>  		pr_err("%s: brcms_attach failed!\n", __func__);
>  		return -ENODEV;
>  	}
> +	brcms_led_init(wl);
> +	brcms_led_register(wl);
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
> index 9358bd5..c16b849 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
> @@ -20,8 +20,10 @@
>  #include <linux/timer.h>
>  #include <linux/interrupt.h>
>  #include <linux/workqueue.h>
> +#include <linux/leds.h>
>  
>  #include "ucode_loader.h"
> +#include "led.h"
>  /*
>   * Starting index for 5G rates in the
>   * legacy rate table.
> @@ -79,6 +81,8 @@ struct brcms_info {
>  	struct wiphy *wiphy;
>  	struct brcms_ucode ucode;
>  	bool mute_tx;
> +	struct brcms_led radio_led;
> +	struct led_classdev led_dev;
>  };
>  
>  /* misc callbacks */
> 

