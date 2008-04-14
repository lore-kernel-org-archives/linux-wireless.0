Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:13238 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbYDNGhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 02:37:11 -0400
Received: by py-out-1112.google.com with SMTP id u52so1931972pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2008 23:36:49 -0700 (PDT)
From: Filipus Klutiero <chealer@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [Rt2400-devel] rt2x00: cleanup Kconfig help
Date: Mon, 14 Apr 2008 02:36:40 -0400
Cc: rt2400-devel@lists.sourceforge.net
References: <200804121509.56291.chealer@gmail.com> <200804121817.00328.chealer@gmail.com> <200804131244.06087.IvDoorn@gmail.com>
In-Reply-To: <200804131244.06087.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200804140236.40614.chealer@gmail.com> (sfid-20080414_073725_859448_D6DB7F5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le April 13, 2008 06:44:05 am Ivo van Doorn, vous avez =E9crit=A0:
[...]
>=20
> > @@ -38,12 +38,12 @@
> >  	select INPUT_POLLDEV
> > =20
> >  config RT2400PCI
> > -	tristate "Ralink rt2400 pci/pcmcia support"
> > +	tristate "Ralink RT2400 (PCI/PCMCIA) support"
> >  	depends on RT2X00 && PCI
> >  	select RT2X00_LIB_PCI
> >  	select EEPROM_93CX6
> >  	---help---
> > -	  This is an experimental driver for the Ralink rt2400 wireless c=
hip.
> > +	  This is an experimental driver for the Ralink RT2400 wireless c=
hipset.
> > =20
> >  	  When compiled as a module, this driver will be called "rt2400pc=
i.ko".
>=20
> I ask again, please keep the RT lowercase.
As I wrote, "rt" is capitalized in the name of the chips. I am not a Ra=
link expert though, so feel free to point to a reference where "rt" is =
lowercase if both forms are valid.
>=20
> >  config RT61PCI
> > -	tristate "Ralink rt61 pci/pcmcia support"
> > +	tristate "Ralink RT2561 and RT2661 (PCI) support"
>=20
> I can't see why you are overly obsessed with changing the device type=
 here.
> There are rt61 PCMCIA cards so make it:
>=20
> +	tristate "Ralink rt2561 and rt2661 (PCI/PCMCIA) support"
Ah, that's not an obsession but it's the way it was in both versions. I=
 removed "pcmcia" because it wasn't capitalized, before we started tryi=
ng to make it consistent. I made it consistent in the new patch.
>=20
> >  	depends on RT2X00 && PCI
> >  	select RT2X00_LIB_PCI
> >  	select RT2X00_LIB_FIRMWARE
> >  	select EEPROM_93CX6
> >  	---help---
> > -	  This is an experimental driver for the Ralink rt61 wireless chi=
p.
> > +	  This is an experimental driver for the Ralink RT2600 and RT2501=
 [Turbo] (PCI) wireless chipsets.
>=20
> Again: It doesn't make any sense to claim support for chip A in the s=
ubject and chip B in the help text.
A is the MAC chip, B is the chipset. Anyway, I forgot that entry when d=
oing the version which was supposed to be consistent. I changed it in t=
he new patch.
> Furthermore you don't need to repeat the (PCI) here, since it is alre=
ady clear from the subject and
> it isn't in the help text for the other drivers either.
Right.
>=20
> >  	  When compiled as a module, this driver will be called "rt61pci.=
ko".
> > =20
> > @@ -91,26 +91,26 @@
> >  	depends on RT61PCI
> >  	select RT2X00_LIB_RFKILL
> >  	---help---
> > -	  This adds support for integrated rt61 devices that feature a
> > +	  This adds support for integrated RT2600 and RT2501 devices that=
 feature a
>=20
> Same here, the driver is for rt2561 and rt2661
Changed.
>=20
> >  	  hardware button to control the radio state.
> >  	  This feature depends on the RF switch subsystem rfkill.
> > =20
> >  config RT2500USB
> > -	tristate "Ralink rt2500 usb support"
> > +	tristate "Ralink RT2500USB support"
>=20
> Again:
> -	tristate "Ralink rt2500 (USB) support"
> This is consistent with the rest where (PCI) is used.
> A space between rt2500 and usb should not give people the impression =
we are
> suddenly talking about PCI hardware.
>=20
> Another option if that makes you happy is that you could rename it to=
 rt2570
> if you really want to differentiate between rt2500 usb and rt2500 pci=
=2E
We already discussed that in previous messages.
>=20
> >  	depends on RT2X00 && USB
> >  	select RT2X00_LIB_USB
> >  	---help---
> > -	  This is an experimental driver for the Ralink rt2500 wireless c=
hip.
> > +	  This is an experimental driver for the Ralink RT2500USB wireles=
s chipset.
>=20
> Again:
> +	  This is an experimental driver for the Ralink RT2500 wireless chi=
pset.
As above.
> >  	  When compiled as a module, this driver will be called "rt2500us=
b.ko".
> > =20
> >  config RT73USB
> > -	tristate "Ralink rt73 usb support"
> > +	tristate "Ralink RT2571W and RT2671 (USB) support"
> >  	depends on RT2X00 && USB
> >  	select RT2X00_LIB_USB
> >  	select RT2X00_LIB_FIRMWARE
> >  	---help---
> > -	  This is an experimental driver for the Ralink rt73 wireless chi=
p.
> > +	  This is an experimental driver for the RT2571W and RT2671 MAC/B=
BP chips. It supports Ralink RT2501USB and RT5201USB wireless chipsets.
> >  	  When compiled as a module, this driver will be called "rt73usb.=
ko".
>=20
> *sigh* you seem to be absolutely sure you want to break any form of c=
onsistency in the rt2x00 KConfig entry.
> So to show how I would like to see it I have the following patch. Unl=
ess you have objections against below changes
> I will push this forward.
No objection, but note that:
* this has both "hardware that feature*s*" and  "hardware that feature"
* The names of drivers are duplicated and not exactly the same. For exa=
mple, "This is the experimental rt2500pci driver [...]" vs "[...] this =
driver will be called "rt2500pci.ko"".

Here is the third version of my patch.
---

--- drivers/net/wireless/rt2x00/Kconfig	2008-01-24 17:58:37.000000000 -=
0500
+++ drivers/net/wireless/rt2x00/Kconfig.USB	2008-04-14 02:29:37.0000000=
00 -0400
@@ -2,10 +2,10 @@
 	tristate "Ralink driver support"
 	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
 	---help---
-	  This will enable the experimental support for the Ralink drivers,
+	  This enables the experimental support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
=20
-	  These drivers will make use of the Devicescape ieee80211 stack.
+	  These drivers use the mac80211 stack.
=20
 	  When building one of the individual drivers, the rt2x00 library
 	  will also be created. That library (when the driver is built as
@@ -38,12 +38,12 @@
 	select INPUT_POLLDEV
=20
 config RT2400PCI
-	tristate "Ralink rt2400 pci/pcmcia support"
+	tristate "Ralink RT2400 (PCI/PCMCIA) support"
 	depends on RT2X00 && PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt2400 wireless chip.
+	  This is an experimental driver for the Ralink RT2400 wireless chips=
et.
=20
 	  When compiled as a module, this driver will be called "rt2400pci.ko=
".
=20
@@ -52,17 +52,17 @@
 	depends on RT2400PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt2400 devices that feature a
+	  This adds support for integrated RT2400 devices that feature a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
=20
 config RT2500PCI
-	tristate "Ralink rt2500 pci/pcmcia support"
+	tristate "Ralink RT2500 (PCI/PCMCIA) support"
 	depends on RT2X00 && PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
+	  This is an experimental driver for the Ralink RT2500 wireless chips=
et.
=20
 	  When compiled as a module, this driver will be called "rt2500pci.ko=
".
=20
@@ -71,18 +71,18 @@
 	depends on RT2500PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt2500 devices that feature a
+	  This adds support for integrated RT2500 devices that feature a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
=20
 config RT61PCI
-	tristate "Ralink rt61 pci/pcmcia support"
+	tristate "Ralink RT2561 and RT2661 (PCI/PCMCIA) support"
 	depends on RT2X00 && PCI
 	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
 	select EEPROM_93CX6
 	---help---
-	  This is an experimental driver for the Ralink rt61 wireless chip.
+	  This is an experimental driver for the Ralink RT2561 and RT2661 MAC=
/BBP chips. It supports RT2600 and RT2501 [Turbo] wireless chipsets.
=20
 	  When compiled as a module, this driver will be called "rt61pci.ko".
=20
@@ -91,26 +91,26 @@
 	depends on RT61PCI
 	select RT2X00_LIB_RFKILL
 	---help---
-	  This adds support for integrated rt61 devices that feature a
+	  This adds support for integrated RT2561 and RT2661 devices that fea=
ture a
 	  hardware button to control the radio state.
 	  This feature depends on the RF switch subsystem rfkill.
=20
 config RT2500USB
-	tristate "Ralink rt2500 usb support"
+	tristate "Ralink RT2500USB support"
 	depends on RT2X00 && USB
 	select RT2X00_LIB_USB
 	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
+	  This is an experimental driver for the Ralink RT2500USB wireless ch=
ipset.
=20
 	  When compiled as a module, this driver will be called "rt2500usb.ko=
".
=20
 config RT73USB
-	tristate "Ralink rt73 usb support"
+	tristate "Ralink RT2571W and RT2671 (USB) support"
 	depends on RT2X00 && USB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
 	---help---
-	  This is an experimental driver for the Ralink rt73 wireless chip.
+	  This is an experimental driver for the Ralink RT2571W and RT2671 MA=
C/BBP chips. It supports RT2501USB and RT5201USB wireless chipsets.
=20
 	  When compiled as a module, this driver will be called "rt73usb.ko".
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
