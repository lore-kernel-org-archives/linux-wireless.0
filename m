Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:43312 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbYDMKl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 06:41:57 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1115679fgb.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2008 03:41:55 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2x00: cleanup Kconfig help
Date: Sun, 13 Apr 2008 12:44:05 +0200
Cc: Filipus Klutiero <chealer@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200804121509.56291.chealer@gmail.com> <200804122253.16920.IvDoorn@gmail.com> <200804121817.00328.chealer@gmail.com>
In-Reply-To: <200804121817.00328.chealer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804131244.06087.IvDoorn@gmail.com> (sfid-20080413_114201_957045_EA511C97)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> --- drivers/net/wireless/rt2x00/Kconfig	2008-01-24 17:58:37.000000000 -0500
> +++ drivers/net/wireless/rt2x00/Kconfig.USB	2008-04-12 18:12:06.000000000 -0400
> @@ -2,10 +2,10 @@
>  	tristate "Ralink driver support"
>  	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
>  	---help---
> -	  This will enable the experimental support for the Ralink drivers,
> +	  This enables the experimental support for the Ralink drivers,
>  	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
>  
> -	  These drivers will make use of the Devicescape ieee80211 stack.
> +	  These drivers use the mac80211 stack.
>  
>  	  When building one of the individual drivers, the rt2x00 library
>  	  will also be created. That library (when the driver is built as

These 2 changes are fine.

> @@ -38,12 +38,12 @@
>  	select INPUT_POLLDEV
>  
>  config RT2400PCI
> -	tristate "Ralink rt2400 pci/pcmcia support"
> +	tristate "Ralink RT2400 (PCI/PCMCIA) support"
>  	depends on RT2X00 && PCI
>  	select RT2X00_LIB_PCI
>  	select EEPROM_93CX6
>  	---help---
> -	  This is an experimental driver for the Ralink rt2400 wireless chip.
> +	  This is an experimental driver for the Ralink RT2400 wireless chipset.
>  
>  	  When compiled as a module, this driver will be called "rt2400pci.ko".

I ask again, please keep the RT lowercase.

>  config RT61PCI
> -	tristate "Ralink rt61 pci/pcmcia support"
> +	tristate "Ralink RT2561 and RT2661 (PCI) support"

I can't see why you are overly obsessed with changing the device type here.
There are rt61 PCMCIA cards so make it:

+	tristate "Ralink rt2561 and rt2661 (PCI/PCMCIA) support"

>  	depends on RT2X00 && PCI
>  	select RT2X00_LIB_PCI
>  	select RT2X00_LIB_FIRMWARE
>  	select EEPROM_93CX6
>  	---help---
> -	  This is an experimental driver for the Ralink rt61 wireless chip.
> +	  This is an experimental driver for the Ralink RT2600 and RT2501 [Turbo] (PCI) wireless chipsets.

Again: It doesn't make any sense to claim support for chip A in the subject and chip B in the help text.
Furthermore you don't need to repeat the (PCI) here, since it is already clear from the subject and
it isn't in the help text for the other drivers either.

>  	  When compiled as a module, this driver will be called "rt61pci.ko".
>  
> @@ -91,26 +91,26 @@
>  	depends on RT61PCI
>  	select RT2X00_LIB_RFKILL
>  	---help---
> -	  This adds support for integrated rt61 devices that feature a
> +	  This adds support for integrated RT2600 and RT2501 devices that feature a

Same here, the driver is for rt2561 and rt2661

>  	  hardware button to control the radio state.
>  	  This feature depends on the RF switch subsystem rfkill.
>  
>  config RT2500USB
> -	tristate "Ralink rt2500 usb support"
> +	tristate "Ralink RT2500USB support"

Again:
-	tristate "Ralink rt2500 (USB) support"
This is consistent with the rest where (PCI) is used.
A space between rt2500 and usb should not give people the impression we are
suddenly talking about PCI hardware.

Another option if that makes you happy is that you could rename it to rt2570
if you really want to differentiate between rt2500 usb and rt2500 pci.

>  	depends on RT2X00 && USB
>  	select RT2X00_LIB_USB
>  	---help---
> -	  This is an experimental driver for the Ralink rt2500 wireless chip.
> +	  This is an experimental driver for the Ralink RT2500USB wireless chipset.

Again:
+	  This is an experimental driver for the Ralink RT2500 wireless chipset.

>  	  When compiled as a module, this driver will be called "rt2500usb.ko".
>  
>  config RT73USB
> -	tristate "Ralink rt73 usb support"
> +	tristate "Ralink RT2571W and RT2671 (USB) support"
>  	depends on RT2X00 && USB
>  	select RT2X00_LIB_USB
>  	select RT2X00_LIB_FIRMWARE
>  	---help---
> -	  This is an experimental driver for the Ralink rt73 wireless chip.
> +	  This is an experimental driver for the RT2571W and RT2671 MAC/BBP chips. It supports Ralink RT2501USB and RT5201USB wireless chipsets.
>  	  When compiled as a module, this driver will be called "rt73usb.ko".

*sigh* you seem to be absolutely sure you want to break any form of consistency in the rt2x00 KConfig entry.
So to show how I would like to see it I have the following patch. Unless you have objections against below changes
I will push this forward.

---
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index a1e3938..7f093cc 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -40,12 +40,12 @@ config RT2X00_LIB_LEDS
 	depends on RT2X00_LIB
 
 config RT2400PCI
-	tristate "Ralink rt2400 pci/pcmcia support"
+	tristate "Ralink rt2400 (PCI/PCMCIA) support"
 	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt2400 wireless chip.
+	  This is the experimental rt2400pci driver for the Ralink rt2460 wireless chip.
 
 	  When compiled as a module, this driver will be called "rt2400pci.ko".
 
@@ -54,7 +54,7 @@ config RT2400PCI_RFKILL
 	depends on RT2400PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt2400 devices that feature a
+	  This adds support for integrated rt2400 hardware that features a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
 
@@ -66,12 +66,12 @@ config RT2400PCI_LEDS
 	  This adds support for led triggers provided my mac80211.
 
 config RT2500PCI
-	tristate "Ralink rt2500 pci/pcmcia support"
+	tristate "Ralink rt2500 (PCI/PCMCIA) support"
 	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
+	  This is the experimental rt2500pci driver for the Ralink rt2560 wireless chip.
 
 	  When compiled as a module, this driver will be called "rt2500pci.ko".
 
@@ -80,7 +80,7 @@ config RT2500PCI_RFKILL
 	depends on RT2500PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt2500 devices that feature a
+	  This adds support for integrated rt2500 hardware that feature a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
 
@@ -92,14 +92,14 @@ config RT2500PCI_LEDS
 	  This adds support for led triggers provided my mac80211.
 
 config RT61PCI
-	tristate "Ralink rt61 pci/pcmcia support"
+	tristate "Ralink rt61 (PCI/PCMCIA) support"
 	depends on PCI
 	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
 	select CRC_ITU_T
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt61 wireless chip.
+	  This is the experimental rt61pci driver for the Ralink rt2561 and rt2661 wireless chips.
 
 	  When compiled as a module, this driver will be called "rt61pci.ko".
 
@@ -108,7 +108,7 @@ config RT61PCI_RFKILL
 	depends on RT61PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt61 devices that feature a
+	  This adds support for integrated rt61 hardware that feature a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
 
@@ -120,11 +120,11 @@ config RT61PCI_LEDS
 	  This adds support for led triggers provided my mac80211.
 
 config RT2500USB
-	tristate "Ralink rt2500 usb support"
+	tristate "Ralink rt2500 (USB) support"
 	depends on USB
 	select RT2X00_LIB_USB
 	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
+	  This is the experimental rt2500usb driver for the Ralink rt2570 wireless chip.
 
 	  When compiled as a module, this driver will be called "rt2500usb.ko".
 
@@ -136,14 +136,13 @@ config RT2500USB_LEDS
 	  This adds support for led triggers provided my mac80211.
 
 config RT73USB
-	tristate "Ralink rt73 usb support"
+	tristate "Ralink rt73 (USB) support"
 	depends on USB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
 	select CRC_ITU_T
 	---help---
-	  This is an experimental driver for the Ralink rt73 wireless chip.
-
+	  This is the experimental rt73usb driver for the Ralink rt2571W and rt2671 wireless chips.
 	  When compiled as a module, this driver will be called "rt73usb.ko".
 
 config RT73USB_LEDS


