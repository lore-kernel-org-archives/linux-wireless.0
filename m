Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:30176 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZAJMqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 07:46:02 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1229257nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 04:45:59 -0800 (PST)
To: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: [RFC] rt2500pci: turn on led_qual for default LED mode
Date: Sat, 10 Jan 2009 13:45:57 +0100
Cc: linux-wireless@vger.kernel.org
References: <20090110100751.GA29761@silver.sucs.org>
In-Reply-To: <20090110100751.GA29761@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901101345.57310.IvDoorn@gmail.com> (sfid-20090110_134609_626813_C8D13585)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 10 January 2009, Andrew Price wrote:
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
> 
> P.S. This is not related to my previous LED patch. This one is for the other
> LED which has never worked as far as I can remember, until now :-)

Ok, I just checked legacy driver and LED_MODE_DEFAULT indeed can be considered
as LED_MODE_TXRX_ACTIVITY. Could you resend this patch as normal patch,
but with the same change for rt2400pci and rt2500usb.

Thanks,

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


