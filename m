Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:59388 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZAJX0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 18:26:15 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1253279nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 15:26:13 -0800 (PST)
To: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: [PATCH] rt2400,rt2500: init led_qual for LED_MODE_DEFAULT
Date: Sun, 11 Jan 2009 00:26:10 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200901101345.57310.IvDoorn@gmail.com> <20090110193805.GA13086@silver.sucs.org>
In-Reply-To: <20090110193805.GA13086@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901110026.10562.IvDoorn@gmail.com> (sfid-20090111_002620_253278_29A56368)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 10 January 2009, Andrew Price wrote:
> Add a check for LED_MODE_DEFAULT so that we use the link LED for rt2400
> and rt2500 devices.
> 
> Signed-off-by: Andrew Price <andy@andrewprice.me.uk>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index 6a97767..b86400d 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -1365,7 +1365,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
>  
>  	rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
> -	if (value == LED_MODE_TXRX_ACTIVITY)
> +	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
>  		rt2400pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
>  				   LED_TYPE_ACTIVITY);
>  #endif /* CONFIG_RT2X00_LIB_LEDS */
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
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 30028e2..c8e38a5 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1569,7 +1569,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
>  
>  	rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
> -	if (value == LED_MODE_TXRX_ACTIVITY)
> +	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
>  		rt2500usb_init_led(rt2x00dev, &rt2x00dev->led_qual,
>  				   LED_TYPE_ACTIVITY);
>  #endif /* CONFIG_RT2X00_LIB_LEDS */


