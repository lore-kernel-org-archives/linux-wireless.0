Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36083 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcFWP7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 11:59:16 -0400
Received: by mail-wm0-f66.google.com with SMTP id c82so12108373wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 08:59:15 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name
Subject: Re: [PATCH 1/2] ath9k: parse the device configuration from an OF node
Date: Thu, 23 Jun 2016 17:59:11 +0200
Message-ID: <3936546.74vnbYymVv@debian64> (sfid-20160623_175920_148126_61188A5B)
In-Reply-To: <20160623151328.24061-2-martin.blumenstingl@googlemail.com>
References: <20160623151328.24061-1-martin.blumenstingl@googlemail.com> <20160623151328.24061-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, June 23, 2016 05:13:27 PM Martin Blumenstingl wrote:
> This makes it possible to configure ath9k based devices using
> devicetree. That makes some out-of-tree "convert devicetree to
> ath9k_platform_data glue"-code obsolete.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/ath/ath9k/init.c | 70 +++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index a0f4a52..0f76137 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -20,6 +20,8 @@
>  #include <linux/slab.h>
>  #include <linux/ath9k_platform.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_net.h>
>  #include <linux/relay.h>
>  #include <net/ieee80211_radiotap.h>
>  
> @@ -555,6 +557,70 @@ static int ath9k_init_platform(struct ath_softc *sc)
>  	return 0;
>  }
>  
> +static int ath9k_of_init(struct ath_softc *sc)
> +{
> +	struct device_node *np = sc->dev->of_node;
> +	struct ath_hw *ah = sc->sc_ah;
> +	struct ath_common *common = ath9k_hw_common(ah);
> +	const char *mac, *eeprom_name;
> +	int led_pin, ret;
> +	u32 gpio_data;
> +
> +	if (!np)
> +		return 0;

Can you please add a of_device_is_available check here too? So
we can skip it with the status property?

> +
> +	ath_dbg(common, CONFIG, "parsing configuration from OF node\n");
> +
> +	if (!of_property_read_u32(np, "ath,led-pin", &led_pin))
> +		ah->led_pin = led_pin;
> +
> +	if (!of_property_read_u32(np, "ath,gpio-mask", &gpio_data))
> +		ah->gpio_mask = gpio_data;
> +
> +	if (!of_property_read_u32(np, "ath,gpio-val", &gpio_data))
> +		ah->gpio_val = gpio_data;
> +
> +	if (of_property_read_bool(np, "ath,clk-25mhz"))
> +		ah->is_clk_25mhz = true;
> +
> +	if (!of_property_read_u32(np, "ath,gpio-mask", &gpio_data))
> +		ah->gpio_mask = gpio_data;
^^
Duplicated? (see 11 lines above)

> +
> +	if (!of_property_read_u32(np, "ath,gpio-val", &gpio_data))
> +		ah->gpio_val = gpio_data;
^^
Duplicated?

> +
> +	if (of_property_read_bool(np, "ath,clk-25mhz"))
> +		ah->is_clk_25mhz = true;
^^
Duplicated?

> +
> +	if (of_property_read_bool(np, "ath,led-active-high"))
> +		ah->config.led_active_high = true;
> +
> +	if (of_property_read_bool(np, "ath,disable-2ghz"))
> +		ah->disable_2ghz = true;
> +
> +	if (of_property_read_bool(np, "ath,disable-5ghz"))
> +		ah->disable_5ghz = true;
> +
> +	if (of_property_read_bool(np, "ath,check-eeprom-endianness"))
> +		ah->ah_flags &= ~AH_NO_EEP_SWAP;
> +	else
> +		ah->ah_flags |= AH_NO_EEP_SWAP;
> +
> +	if (!of_property_read_string(np, "ath,eeprom-name", &eeprom_name)) {
> +		ret = ath9k_eeprom_request(sc, eeprom_name);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	mac = of_get_mac_address(np);
> +	if (mac)
> +		ether_addr_copy(common->macaddr, mac);
> +
> +	ah->ah_flags &= ~AH_USE_EEPROM;
> +
> +	return 0;
> +}
> +
>  static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
>  			    const struct ath_bus_ops *bus_ops)
>  {
> @@ -611,6 +677,10 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
>  	if (ret)
>  		return ret;
>  
> +	ret = ath9k_of_init(sc);
> +	if (ret)
> +		return ret;
> +
>  	if (ath9k_led_active_high != -1)
>  		ah->config.led_active_high = ath9k_led_active_high == 1;


