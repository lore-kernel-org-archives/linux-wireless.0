Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:46129 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbYDLUMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 16:12:06 -0400
Received: by py-out-1112.google.com with SMTP id u52so1386980pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 13:12:06 -0700 (PDT)
From: Filipus Klutiero <chealer@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: rt2x00: cleanup Kconfig help
Date: Sat, 12 Apr 2008 16:10:59 -0400
Cc: rt2400-devel@lists.sourceforge.net
References: <200804121509.56291.chealer@gmail.com> <200804122128.11521.IvDoorn@gmail.com>
In-Reply-To: <200804122128.11521.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200804121610.59971.chealer@gmail.com> (sfid-20080412_211216_390848_C3161FDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le April 12, 2008 03:28:11 pm Ivo van Doorn, vous avez =E9crit=A0:
> Hi,
>=20
> Please CC either me or the rt2400-devel mailinglist for rt2x00 patche=
s.
> Thanks
>=20
> > Clarify in CONFIG_RT2500USB that proper RT2500 (PCI) is not support=
ed. While at it, capitalize "rt" in Ralink chipsets names and "usb", "p=
ci". Also clarify what RT61 and RT73 refers to. Finally, update CONFIG_=
RT2X00 now that this isn't just futureware.
>=20
> Lots of comments for this patch...
> I agree with only a handfull of changes.
>=20
> > Signed-off-by: Filipus Klutiero <chealer@gmail.com>
> > ---
> >=20
> > --- drivers/net/wireless/rt2x00/Kconfig	2008-01-24 17:58:37.0000000=
00 -0500
> > +++ drivers/net/wireless/rt2x00/Kconfig.USB	2008-04-12 03:22:12.000=
000000 -0400
> > @@ -2,10 +2,10 @@
> >  	tristate "Ralink driver support"
> >  	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
> >  	---help---
> > -	  This will enable the experimental support for the Ralink driver=
s,
> > +	  This enables the experimental support for the Ralink drivers,
> >  	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com=
>.
>=20
> Ack.
>=20
> > -	  These drivers will make use of the Devicescape ieee80211 stack.
> > +	  These drivers use the mac80211 stack.
>=20
> Against what tree did you create this patch?
2.6.24, as I wrote.
> I send a patch that fixed this line several weeks/months ago upstream=
=2E
>=20
> >  	  When building one of the individual drivers, the rt2x00 library
> >  	  will also be created. That library (when the driver is built as
> > @@ -38,12 +38,12 @@
> >  	select INPUT_POLLDEV
> > =20
> >  config RT2400PCI
> > -	tristate "Ralink rt2400 pci/pcmcia support"
> > +	tristate "Ralink RT2400 (PCI/PCMCIA) support"
>=20
> Can't see a real reason for either capatilizing RT or PCI/PCMCIA ...
rtxxxx refer to the drivers. "rt" is capitalized in the name of the chi=
ps. For PCI and PCMCIA, these are abbreviations.
>=20
> >  config RT61PCI
> > -	tristate "Ralink rt61 pci/pcmcia support"
> > +	tristate "Ralink RT2561, RT2661 support"
>=20
> Since we are setting the bus type clearly everywhere else,
> we shouldn't remove it here...
The reason I changed it is because the abbreviations weren't capitalize=
d, but I simply removed it since RT2561 and RT2661 are only used in PCI=
 (or PCMCIA) devices.
>=20
> tristate "Ralink rt2561 & rt2661 pci/pcmcia support"
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
> This is an experimental driver for the Ralink rt2600 andrt2501(Turbo)=
 wireless chipsets.
There is "RT2501" and "RT2501 Turbo". The brackets mean that both are s=
upported.
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
> Minus capitilization sounds fine
>=20
> >  	  hardware button to control the radio state.
> >  	  This feature depends on the RF switch subsystem rfkill.
> > =20
> >  config RT2500USB
> > -	tristate "Ralink rt2500 usb support"
> > +	tristate "Ralink RT2500USB support"
>=20
> Original version was fine since it is consistent with the rest...
See bug #10440. "RT2500" refers to the RT2500 (PCI or PCMCIA) chipset.
>=20
> >  	depends on RT2X00 && USB
> >  	select RT2X00_LIB_USB
> >  	---help---
> > -	  This is an experimental driver for the Ralink rt2500 wireless c=
hip.
> > +	  This is an experimental driver for the Ralink RT2500USB wireles=
s chipset.
>=20
> See no point in changing this, the config title already states we are=
 talking about USB.
Same as above.
>=20
> >  	  When compiled as a module, this driver will be called "rt2500us=
b.ko".
> > =20
> >  config RT73USB
> > -	tristate "Ralink rt73 usb support"
> > +	tristate "Ralink RT2571W (USB) support"
>=20
> consistency and don't forget to add all types.
> tristate "Ralink rt2571W & rt2671 usb support"
You must know better than me if RT2671 is also supported. I didn't mean=
 that my patch fixed everything.
>=20
> >  	depends on RT2X00 && USB
> >  	select RT2X00_LIB_USB
> >  	select RT2X00_LIB_FIRMWARE
> >  	---help---
> > -	  This is an experimental driver for the Ralink rt73 wireless chi=
p.
> > +	  This is an experimental driver for the Ralink RT2501USB and RT5=
201USB wireless chipsets.
>=20
> Those devices doesn't match the config title, so it should be somethi=
ng like:
>=20
> This is an experimental driver for the Ralink rt2571W and rt2671 wire=
less chipsets.
Other extended descriptions only refer to the chipsets. I think the chi=
pset should be mentioned because users are more likely to know it than =
the MAC chip. OTOH, nothing prevents us from mentioning both.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
