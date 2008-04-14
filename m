Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:36894 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYDNLas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 07:30:48 -0400
Received: by fk-out-0910.google.com with SMTP id 19so1611357fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2008 04:30:46 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2x00: cleanup Kconfig help
Date: Mon, 14 Apr 2008 13:33:32 +0200
Cc: Filipus Klutiero <chealer@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200804121509.56291.chealer@gmail.com> <200804131244.06087.IvDoorn@gmail.com> <200804140236.40614.chealer@gmail.com>
In-Reply-To: <200804140236.40614.chealer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200804141333.33128.IvDoorn@gmail.com> (sfid-20080414_123052_693347_FBD07360)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > >  	  When compiled as a module, this driver will be called "rt2500=
usb.ko".
> > > =20
> > >  config RT73USB
> > > -	tristate "Ralink rt73 usb support"
> > > +	tristate "Ralink RT2571W and RT2671 (USB) support"
> > >  	depends on RT2X00 && USB
> > >  	select RT2X00_LIB_USB
> > >  	select RT2X00_LIB_FIRMWARE
> > >  	---help---
> > > -	  This is an experimental driver for the Ralink rt73 wireless c=
hip.
> > > +	  This is an experimental driver for the RT2571W and RT2671 MAC=
/BBP chips. It supports Ralink RT2501USB and RT5201USB wireless chipset=
s.
> > >  	  When compiled as a module, this driver will be called "rt73us=
b.ko".
> >=20
> > *sigh* you seem to be absolutely sure you want to break any form of=
 consistency in the rt2x00 KConfig entry.
> > So to show how I would like to see it I have the following patch. U=
nless you have objections against below changes
> > I will push this forward.
> No objection, but note that:
> * this has both "hardware that feature*s*" and  "hardware that featur=
e"

I'll fix that.

> * The names of drivers are duplicated and not exactly the same. For e=
xample, "This is the experimental rt2500pci driver [...]" vs "[...] thi=
s driver will be called "rt2500pci.ko"".

I'll change that to:
This is the experimental rt2500pci driver [...]" vs "[...] the module w=
ill be called "rt2500pci.ko"".

> Here is the third version of my patch.

NACK

All my complaints about your previous patch still aplies to this new on=
e,
and I am not going to repeat myself over and over again for exactly the=
 same.

As for the bug this patch is supposedly going to fix,
the config option is named:
	tristate "Ralink rt2500 usb support"
How can people confuse that with pci support?
=DDour patch suggests the confusion is to blame because there is a spac=
e
between rt2500 and usb, and that usb isn't capitalized...

I'll update my previous patch with some additional chipset notices and =
send that upstream in a few days.
I'll consider this issue (including the bug report) closed after that.

Ivo

> ---
>=20
> --- drivers/net/wireless/rt2x00/Kconfig	2008-01-24 17:58:37.000000000=
 -0500
> +++ drivers/net/wireless/rt2x00/Kconfig.USB	2008-04-14 02:29:37.00000=
0000 -0400
> @@ -2,10 +2,10 @@
>  	tristate "Ralink driver support"
>  	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
>  	---help---
> -	  This will enable the experimental support for the Ralink drivers,
> +	  This enables the experimental support for the Ralink drivers,
>  	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
> =20
> -	  These drivers will make use of the Devicescape ieee80211 stack.
> +	  These drivers use the mac80211 stack.
> =20
>  	  When building one of the individual drivers, the rt2x00 library
>  	  will also be created. That library (when the driver is built as
> @@ -38,12 +38,12 @@
>  	select INPUT_POLLDEV
> =20
>  config RT2400PCI
> -	tristate "Ralink rt2400 pci/pcmcia support"
> +	tristate "Ralink RT2400 (PCI/PCMCIA) support"
>  	depends on RT2X00 && PCI
>  	select RT2X00_LIB_PCI
>  	select EEPROM_93CX6
>  	---help---
> -	  This is an experimental driver for the Ralink rt2400 wireless chi=
p.
> +	  This is an experimental driver for the Ralink RT2400 wireless chi=
pset.
> =20
>  	  When compiled as a module, this driver will be called "rt2400pci.=
ko".
> =20
> @@ -52,17 +52,17 @@
>  	depends on RT2400PCI
>  	select RT2X00_LIB_RFKILL
>  	---help---
> -	  This adds support for integrated rt2400 devices that feature a
> +	  This adds support for integrated RT2400 devices that feature a
>  	  hardware button to control the radio state.
>  	  This feature depends on the RF switch subsystem rfkill.
> =20
>  config RT2500PCI
> -	tristate "Ralink rt2500 pci/pcmcia support"
> +	tristate "Ralink RT2500 (PCI/PCMCIA) support"
>  	depends on RT2X00 && PCI
>  	select RT2X00_LIB_PCI
>  	select EEPROM_93CX6
>  	---help---
> -	  This is an experimental driver for the Ralink rt2500 wireless chi=
p.
> +	  This is an experimental driver for the Ralink RT2500 wireless chi=
pset.
> =20
>  	  When compiled as a module, this driver will be called "rt2500pci.=
ko".
> =20
> @@ -71,18 +71,18 @@
>  	depends on RT2500PCI
>  	select RT2X00_LIB_RFKILL
>  	---help---
> -	  This adds support for integrated rt2500 devices that feature a
> +	  This adds support for integrated RT2500 devices that feature a
>  	  hardware button to control the radio state.
>  	  This feature depends on the RF switch subsystem rfkill.
> =20
>  config RT61PCI
> -	tristate "Ralink rt61 pci/pcmcia support"
> +	tristate "Ralink RT2561 and RT2661 (PCI/PCMCIA) support"
>  	depends on RT2X00 && PCI
>  	select RT2X00_LIB_PCI
>  	select RT2X00_LIB_FIRMWARE
>  	select EEPROM_93CX6
>  	---help---
> -	  This is an experimental driver for the Ralink rt61 wireless chip.
> +	  This is an experimental driver for the Ralink RT2561 and RT2661 M=
AC/BBP chips. It supports RT2600 and RT2501 [Turbo] wireless chipsets.
> =20
>  	  When compiled as a module, this driver will be called "rt61pci.ko=
".
> =20
> @@ -91,26 +91,26 @@
>  	depends on RT61PCI
>  	select RT2X00_LIB_RFKILL
>  	---help---
> -	  This adds support for integrated rt61 devices that feature a
> +	  This adds support for integrated RT2561 and RT2661 devices that f=
eature a
>  	  hardware button to control the radio state.
>  	  This feature depends on the RF switch subsystem rfkill.
> =20
>  config RT2500USB
> -	tristate "Ralink rt2500 usb support"
> +	tristate "Ralink RT2500USB support"
>  	depends on RT2X00 && USB
>  	select RT2X00_LIB_USB
>  	---help---
> -	  This is an experimental driver for the Ralink rt2500 wireless chi=
p.
> +	  This is an experimental driver for the Ralink RT2500USB wireless =
chipset.
> =20
>  	  When compiled as a module, this driver will be called "rt2500usb.=
ko".
> =20
>  config RT73USB
> -	tristate "Ralink rt73 usb support"
> +	tristate "Ralink RT2571W and RT2671 (USB) support"
>  	depends on RT2X00 && USB
>  	select RT2X00_LIB_USB
>  	select RT2X00_LIB_FIRMWARE
>  	---help---
> -	  This is an experimental driver for the Ralink rt73 wireless chip.
> +	  This is an experimental driver for the Ralink RT2571W and RT2671 =
MAC/BBP chips. It supports RT2501USB and RT5201USB wireless chipsets.
> =20
>  	  When compiled as a module, this driver will be called "rt73usb.ko=
".
> =20
>=20
> ---------------------------------------------------------------------=
----
> This SF.net email is sponsored by the 2008 JavaOne(SM) Conference=20
> Don't miss this year's exciting event. There's still time to save $10=
0.=20
> Use priority code J8TL2D2.=20
> http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.co=
m/javaone
> _______________________________________________
> Rt2400-devel mailing list
> Rt2400-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/rt2400-devel
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
