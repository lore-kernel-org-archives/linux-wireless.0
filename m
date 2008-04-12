Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:45842 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729AbYDLT0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 15:26:39 -0400
Received: by ug-out-1314.google.com with SMTP id z38so149017ugc.16
        for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 12:26:37 -0700 (PDT)
To: Filipus Klutiero <chealer@gmail.com>,
	rt2400-devel@lists.sourceforge.net
Subject: Re: rt2x00: cleanup Kconfig help
Date: Sat, 12 Apr 2008 21:28:11 +0200
Cc: linux-wireless@vger.kernel.org
References: <200804121509.56291.chealer@gmail.com>
In-Reply-To: <200804121509.56291.chealer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804122128.11521.IvDoorn@gmail.com> (sfid-20080412_202659_527563_B7F40548)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Please CC either me or the rt2400-devel mailinglist for rt2x00 patches.
Thanks

> Clarify in CONFIG_RT2500USB that proper RT2500 (PCI) is not supported. While at it, capitalize "rt" in Ralink chipsets names and "usb", "pci". Also clarify what RT61 and RT73 refers to. Finally, update CONFIG_RT2X00 now that this isn't just futureware.

Lots of comments for this patch...
I agree with only a handfull of changes.

> Signed-off-by: Filipus Klutiero <chealer@gmail.com>
> ---
> 
> --- drivers/net/wireless/rt2x00/Kconfig	2008-01-24 17:58:37.000000000 -0500
> +++ drivers/net/wireless/rt2x00/Kconfig.USB	2008-04-12 03:22:12.000000000 -0400
> @@ -2,10 +2,10 @@
>  	tristate "Ralink driver support"
>  	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
>  	---help---
> -	  This will enable the experimental support for the Ralink drivers,
> +	  This enables the experimental support for the Ralink drivers,
>  	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.

Ack.

> -	  These drivers will make use of the Devicescape ieee80211 stack.
> +	  These drivers use the mac80211 stack.

Against what tree did you create this patch?
I send a patch that fixed this line several weeks/months ago upstream.

>  	  When building one of the individual drivers, the rt2x00 library
>  	  will also be created. That library (when the driver is built as
> @@ -38,12 +38,12 @@
>  	select INPUT_POLLDEV
>  
>  config RT2400PCI
> -	tristate "Ralink rt2400 pci/pcmcia support"
> +	tristate "Ralink RT2400 (PCI/PCMCIA) support"

Can't see a real reason for either capatilizing RT or PCI/PCMCIA ...

>  config RT61PCI
> -	tristate "Ralink rt61 pci/pcmcia support"
> +	tristate "Ralink RT2561, RT2661 support"

Since we are setting the bus type clearly everywhere else,
we shouldn't remove it here...

tristate "Ralink rt2561 & rt2661 pci/pcmcia support"

>  	depends on RT2X00 && PCI
>  	select RT2X00_LIB_PCI
>  	select RT2X00_LIB_FIRMWARE
>  	select EEPROM_93CX6
>  	---help---
> -	  This is an experimental driver for the Ralink rt61 wireless chip.
> +	  This is an experimental driver for the Ralink RT2600 and RT2501 [Turbo] (PCI) wireless chipsets.

This is an experimental driver for the Ralink rt2600 andrt2501(Turbo) wireless chipsets.

>  	  When compiled as a module, this driver will be called "rt61pci.ko".
>  
> @@ -91,26 +91,26 @@
>  	depends on RT61PCI
>  	select RT2X00_LIB_RFKILL
>  	---help---
> -	  This adds support for integrated rt61 devices that feature a
> +	  This adds support for integrated RT2600 and RT2501 devices that feature a

Minus capitilization sounds fine

>  	  hardware button to control the radio state.
>  	  This feature depends on the RF switch subsystem rfkill.
>  
>  config RT2500USB
> -	tristate "Ralink rt2500 usb support"
> +	tristate "Ralink RT2500USB support"

Original version was fine since it is consistent with the rest...

>  	depends on RT2X00 && USB
>  	select RT2X00_LIB_USB
>  	---help---
> -	  This is an experimental driver for the Ralink rt2500 wireless chip.
> +	  This is an experimental driver for the Ralink RT2500USB wireless chipset.

See no point in changing this, the config title already states we are talking about USB.

>  	  When compiled as a module, this driver will be called "rt2500usb.ko".
>  
>  config RT73USB
> -	tristate "Ralink rt73 usb support"
> +	tristate "Ralink RT2571W (USB) support"

consistency and don't forget to add all types.
tristate "Ralink rt2571W & rt2671 usb support"

>  	depends on RT2X00 && USB
>  	select RT2X00_LIB_USB
>  	select RT2X00_LIB_FIRMWARE
>  	---help---
> -	  This is an experimental driver for the Ralink rt73 wireless chip.
> +	  This is an experimental driver for the Ralink RT2501USB and RT5201USB wireless chipsets.

Those devices doesn't match the config title, so it should be something like:

This is an experimental driver for the Ralink rt2571W and rt2671 wireless chipsets.

Ivo
