Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:9387 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbZKHNuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:50:01 -0500
Received: by ey-out-2122.google.com with SMTP id 22so494972eye.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:50:05 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 1/9] rt2800: prepare for unification of EEPROM support code
Date: Sun, 8 Nov 2009 14:50:04 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133854.23584.86842.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081450.04598.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800: prepare for unification of EEPROM support code
> 
> * Factor out common code from rt2800[pci,usb]_validate_eeprom()
>   to rt2800_validate_eeprom().
> 
> * Fix interface specific comment in rt2800[pci,usb]_validate_eeprom().
> 
> * Enclose interface specific code in rt2800[pci,usb]_init_eeprom()
>   with rt2x00_intf_is_[pci,usb]() checks.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> on top of "rt2x00: Add dynamic detection of eFuse EEPROM in rt2800pci."
> patch from Gertjan
> 
>  drivers/net/wireless/rt2x00/rt2800pci.c |   51 ++++++++++++++++++--------------
>  drivers/net/wireless/rt2x00/rt2800usb.c |   40 +++++++++++++++----------
>  2 files changed, 55 insertions(+), 36 deletions(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1091,29 +1091,13 @@ static irqreturn_t rt2800pci_interrupt(i
>  /*
>   * Device probe functions.
>   */
> -static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
> +static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
>  	u16 word;
>  	u8 *mac;
>  	u8 default_lna_gain;
>  
>  	/*
> -	 * Read EEPROM into buffer
> -	 */
> -	switch(rt2x00dev->chip.rt) {
> -	case RT2880:
> -	case RT3052:
> -		rt2800pci_read_eeprom_soc(rt2x00dev);
> -		break;
> -	default:
> -		if (rt2800pci_efuse_detect(rt2x00dev))
> -			rt2800pci_read_eeprom_efuse(rt2x00dev);
> -		else
> -			rt2800pci_read_eeprom_pci(rt2x00dev);
> -		break;
> -	}
> -
> -	/*
>  	 * Start validation of the data that has been read.
>  	 */
>  	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
> @@ -1131,7 +1115,7 @@ static int rt2800pci_validate_eeprom(str
>  		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
>  	} else if (rt2x00_rev(&rt2x00dev->chip) < RT2883_VERSION) {
>  		/*
> -		 * There is a max of 2 RX streams for RT2860 series
> +		 * There is a max of 2 RX streams for RT28x0 series
>  		 */
>  		if (rt2x00_get_field16(word, EEPROM_ANTENNA_RXPATH) > 2)
>  			rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
> @@ -1210,6 +1194,27 @@ static int rt2800pci_validate_eeprom(str
>  	return 0;
>  }
>  
> +static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
> +{
> +	/*
> +	 * Read EEPROM into buffer
> +	 */
> +	switch (rt2x00dev->chip.rt) {
> +	case RT2880:
> +	case RT3052:
> +		rt2800pci_read_eeprom_soc(rt2x00dev);
> +		break;
> +	default:
> +		if (rt2800pci_efuse_detect(rt2x00dev))
> +			rt2800pci_read_eeprom_efuse(rt2x00dev);
> +		else
> +			rt2800pci_read_eeprom_pci(rt2x00dev);
> +		break;
> +	}
> +
> +	return rt2800_validate_eeprom(rt2x00dev);
> +}
> +
>  static int rt2800pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
>  	u32 reg;
> @@ -1226,7 +1231,9 @@ static int rt2800pci_init_eeprom(struct 
>  	 */
>  	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
>  	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
> -	rt2x00_set_chip_rf(rt2x00dev, value, reg);
> +
> +	if (rt2x00_intf_is_pci(rt2x00dev))
> +		rt2x00_set_chip_rf(rt2x00dev, value, reg);
>  
>  	if (!rt2x00_rf(&rt2x00dev->chip, RF2820) &&
>  	    !rt2x00_rf(&rt2x00dev->chip, RF2850) &&
> @@ -1234,8 +1241,10 @@ static int rt2800pci_init_eeprom(struct 
>  	    !rt2x00_rf(&rt2x00dev->chip, RF2750) &&
>  	    !rt2x00_rf(&rt2x00dev->chip, RF3020) &&
>  	    !rt2x00_rf(&rt2x00dev->chip, RF2020) &&
> -	    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
> -	    !rt2x00_rf(&rt2x00dev->chip, RF3022)) {
> +	    (rt2x00_intf_is_usb(rt2x00dev) ||
> +	     (rt2x00_intf_is_pci(rt2x00dev) &&
> +	      !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
> +	      !rt2x00_rf(&rt2x00dev->chip, RF3022)))) {
>  		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
>  		return -ENODEV;
>  	}
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -665,14 +665,12 @@ static void rt2800usb_fill_rxdone(struct
>  /*
>   * Device probe functions.
>   */
> -static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
> +static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
>  	u16 word;
>  	u8 *mac;
>  	u8 default_lna_gain;
>  
> -	rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom, EEPROM_SIZE);
> -
>  	/*
>  	 * Start validation of the data that has been read.
>  	 */
> @@ -691,7 +689,7 @@ static int rt2800usb_validate_eeprom(str
>  		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
>  	} else if (rt2x00_rev(&rt2x00dev->chip) < RT2883_VERSION) {
>  		/*
> -		 * There is a max of 2 RX streams for RT2870 series
> +		 * There is a max of 2 RX streams for RT28x0 series
>  		 */
>  		if (rt2x00_get_field16(word, EEPROM_ANTENNA_RXPATH) > 2)
>  			rt2x00_set_field16(&word, EEPROM_ANTENNA_RXPATH, 2);
> @@ -770,6 +768,13 @@ static int rt2800usb_validate_eeprom(str
>  	return 0;
>  }
>  
> +static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
> +{
> +	rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom, EEPROM_SIZE);
> +
> +	return rt2800_validate_eeprom(rt2x00dev);
> +}
> +
>  static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
>  	u32 reg;
> @@ -786,18 +791,23 @@ static int rt2800usb_init_eeprom(struct 
>  	 */
>  	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
>  	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
> -	rt2x00_set_chip(rt2x00dev, RT2870, value, reg);
>  
> -	/*
> -	 * The check for rt2860 is not a typo, some rt2870 hardware
> -	 * identifies itself as rt2860 in the CSR register.
> -	 */
> -	if (!rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28600000) &&
> -	    !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28700000) &&
> -	    !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28800000) &&
> -	    !rt2x00_check_rev(&rt2x00dev->chip, 0xffff0000, 0x30700000)) {
> -		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
> -		return -ENODEV;
> +	if (rt2x00_intf_is_usb(rt2x00dev)) {
> +		struct rt2x00_chip *chip = &rt2x00dev->chip;
> +
> +		rt2x00_set_chip(rt2x00dev, RT2870, value, reg);
> +
> +		/*
> +		 * The check for rt2860 is not a typo, some rt2870 hardware
> +		 * identifies itself as rt2860 in the CSR register.
> +		 */
> +		if (!rt2x00_check_rev(chip, 0xfff00000, 0x28600000) &&
> +		    !rt2x00_check_rev(chip, 0xfff00000, 0x28700000) &&
> +		    !rt2x00_check_rev(chip, 0xfff00000, 0x28800000) &&
> +		    !rt2x00_check_rev(chip, 0xffff0000, 0x30700000)) {
> +			ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
> +			return -ENODEV;
> +		}
>  	}
>  
>  	if (!rt2x00_rf(&rt2x00dev->chip, RF2820) &&
> 


