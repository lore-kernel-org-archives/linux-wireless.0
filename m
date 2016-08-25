Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbcHYJeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 05:34:09 -0400
Date: Thu, 25 Aug 2016 11:33:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: add support for mac addr from device tree
Message-ID: <20160825093330.GA2827@redhat.com> (sfid-20160825_113414_705950_C4567506)
References: <1472113162-26915-1-git-send-email-dev@kresin.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472113162-26915-1-git-send-email-dev@kresin.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2016 at 10:19:22AM +0200, Mathias Kresin wrote:
> The EEPROM used on some CPEs has for every device the same generic
> ralink mac in EEPROM and needs to be overridden.

I don't know what is CPE, but even if I would know that, I most likely
sill will not understand that description.

> +++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> @@ -1459,10 +1459,7 @@ static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  	 * Start validation of the data that has been read.
>  	 */
>  	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
> -	if (!is_valid_ether_addr(mac)) {
> -		eth_random_addr(mac);
> -		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", mac);
> -	}
> +	rt2x00lib_set_mac_address(rt2x00dev, mac);
<snip>
> +#include <linux/of.h>
> +#include <linux/of_net.h>
>  
>  #include "rt2x00.h"
>  #include "rt2x00lib.h"
> @@ -931,6 +933,21 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
>  		entry->flags |= IEEE80211_RATE_SHORT_PREAMBLE;
>  }
>  
> +void rt2x00lib_set_mac_address(struct rt2x00_dev *rt2x00dev, u8 *eeprom_mac_addr)
> +{
> +	const char *mac_addr;
> +
> +	mac_addr = of_get_mac_address(rt2x00dev->dev->of_node);

Shouldn't use dev_of_node(&rt2x00dev->dev) and check against NULL ? 

> +	if (mac_addr)
> +		ether_addr_copy(eeprom_mac_addr, mac_addr);

Why we do not read MAC from EEPROM if fail to get it from of_node?

Thanks
Stanislaw
