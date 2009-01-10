Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:46840 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZAJLRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 06:17:51 -0500
Received: by ewy10 with SMTP id 10so10661288ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 03:17:49 -0800 (PST)
To: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: [RFC] rt2500pci: turn on led_qual for default LED mode
Date: Sat, 10 Jan 2009 12:17:45 +0100
Cc: linux-wireless@vger.kernel.org
References: <20090110100751.GA29761@silver.sucs.org>
In-Reply-To: <20090110100751.GA29761@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901101217.45569.IvDoorn@gmail.com> (sfid-20090110_121757_748067_34941BBD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Add a check for LED_MODE_DEFAULT so that we initialise the link LED.
> 
> Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
> ---
> 
> I'm submitting this patch just as an RFC as I have no idea whether it works
> with all rt2500pci devices. With my card, value holds 0 after the call to
> rt2x00_get_field16() and so the added check for LED_MODE_DEFAULT (which is 0)
> is needed for the link LED to work.
> 
> My card is a "RaLink RT2500 802.11g Cardbus/mini-PCI [1814:0201]" Belkin
> F5D7010 according to lspci.
> 
> Any advice would be much appreciated. Does this patch look reasonable? Are
> there any docs/specs which I could read to learn how this should be handled?

You raise a very good point with this patch, I need to double check what the legacy drivers
actually do with LED_MODE_DEFAULT and if it is similar as your approach this patch should
be done for all rt2x00 drivers.

I'll get back on this patch as soon as possible.

Thanks,

Ivo

> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index d3bc218..651cb4f 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1524,7 +1524,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
>  
>  	rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
> -	if (value == LED_MODE_TXRX_ACTIVITY)
> +	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
>  		rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
>  				   LED_TYPE_ACTIVITY);
>  #endif /* CONFIG_RT2X00_LIB_LEDS */


