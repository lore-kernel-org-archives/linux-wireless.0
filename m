Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:43443 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbYDLUvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 16:51:45 -0400
Received: by ug-out-1314.google.com with SMTP id z38so160273ugc.16
        for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 13:51:42 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2x00: cleanup Kconfig help
Date: Sat, 12 Apr 2008 22:53:16 +0200
Cc: Filipus Klutiero <chealer@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200804121509.56291.chealer@gmail.com> <200804122128.11521.IvDoorn@gmail.com> <200804121610.59971.chealer@gmail.com>
In-Reply-To: <200804121610.59971.chealer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804122253.16920.IvDoorn@gmail.com> (sfid-20080412_215150_257822_5919984A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > -	  These drivers will make use of the Devicescape ieee80211 stack.
> > > +	  These drivers use the mac80211 stack.
> > 
> > Against what tree did you create this patch?
> 2.6.24, as I wrote.

Hmm the patch doesn't seem to be completely upstream yet..
Probably pending somewhere in wireless-2.6 or wireless-testing.

Doesn't really matter.

> > I send a patch that fixed this line several weeks/months ago upstream.
> > 
> > >  	  When building one of the individual drivers, the rt2x00 library
> > >  	  will also be created. That library (when the driver is built as
> > > @@ -38,12 +38,12 @@
> > >  	select INPUT_POLLDEV
> > >  
> > >  config RT2400PCI
> > > -	tristate "Ralink rt2400 pci/pcmcia support"
> > > +	tristate "Ralink RT2400 (PCI/PCMCIA) support"
> > 
> > Can't see a real reason for either capatilizing RT or PCI/PCMCIA ...
> rtxxxx refer to the drivers. "rt" is capitalized in the name of the chips. For PCI and PCMCIA, these are abbreviations.

Well the names of the drivers are after the names of the chipset. So the rt can stay as it is now.

Convention seems to be that PCI, PCMCIA and USB are capilitized so that change is fine,
but please make it consistent for all drivers like it currently is. So either put them all between braces or none of them.

> > >  config RT61PCI
> > > -	tristate "Ralink rt61 pci/pcmcia support"
> > > +	tristate "Ralink RT2561, RT2661 support"
> > 
> > Since we are setting the bus type clearly everywhere else,
> > we shouldn't remove it here...
> The reason I changed it is because the abbreviations weren't capitalized, but I simply removed it since RT2561 and RT2661 are only used in PCI (or PCMCIA) devices.

So? rt2400 is only for PCI and rt73 is only for USB. That doesn't matter.
This way it is clearer to everybody what kind of device we are talking about.
It is also consistent with the other rt2x00 driver entries.

> > tristate "Ralink rt2561 & rt2661 pci/pcmcia support"
> > 
> > >  	depends on RT2X00 && PCI
> > >  	select RT2X00_LIB_PCI
> > >  	select RT2X00_LIB_FIRMWARE
> > >  	select EEPROM_93CX6
> > >  	---help---
> > > -	  This is an experimental driver for the Ralink rt61 wireless chip.
> > > +	  This is an experimental driver for the Ralink RT2600 and RT2501 [Turbo] (PCI) wireless chipsets.
> > 
> > This is an experimental driver for the Ralink rt2600 andrt2501(Turbo) wireless chipsets.
> There is "RT2501" and "RT2501 Turbo". The brackets mean that both are supported.

Fine.

> > >  	  When compiled as a module, this driver will be called "rt61pci.ko".
> > >  
> > > @@ -91,26 +91,26 @@
> > >  	depends on RT61PCI
> > >  	select RT2X00_LIB_RFKILL
> > >  	---help---
> > > -	  This adds support for integrated rt61 devices that feature a
> > > +	  This adds support for integrated RT2600 and RT2501 devices that feature a
> > 
> > Minus capitilization sounds fine
> > 
> > >  	  hardware button to control the radio state.
> > >  	  This feature depends on the RF switch subsystem rfkill.
> > >  
> > >  config RT2500USB
> > > -	tristate "Ralink rt2500 usb support"
> > > +	tristate "Ralink RT2500USB support"
> > 
> > Original version was fine since it is consistent with the rest...
> See bug #10440. "RT2500" refers to the RT2500 (PCI or PCMCIA) chipset.

So you mean that stating "rt2500 usb" makes people confused to think it is a pci device?
The usb label is already mentioned in the subject....

rt2500 is _not_ PCI only, the USB version is the same chipset pasted on a different busconnector.

> > >  	depends on RT2X00 && USB
> > >  	select RT2X00_LIB_USB
> > >  	---help---
> > > -	  This is an experimental driver for the Ralink rt2500 wireless chip.
> > > +	  This is an experimental driver for the Ralink RT2500USB wireless chipset.
> > 
> > See no point in changing this, the config title already states we are talking about USB.
> Same as above.

And my  comment remains the same.

> > 
> > >  	  When compiled as a module, this driver will be called "rt2500usb.ko".
> > >  
> > >  config RT73USB
> > > -	tristate "Ralink rt73 usb support"
> > > +	tristate "Ralink RT2571W (USB) support"
> > 
> > consistency and don't forget to add all types.
> > tristate "Ralink rt2571W & rt2671 usb support"
> You must know better than me if RT2671 is also supported. I didn't mean that my patch fixed everything.

I just added it so you can add it when you rebase your patch based on my comments.
It is just for completeness.

> > >  	depends on RT2X00 && USB
> > >  	select RT2X00_LIB_USB
> > >  	select RT2X00_LIB_FIRMWARE
> > >  	---help---
> > > -	  This is an experimental driver for the Ralink rt73 wireless chip.
> > > +	  This is an experimental driver for the Ralink RT2501USB and RT5201USB wireless chipsets.
> > 
> > Those devices doesn't match the config title, so it should be something like:
> > 
> > This is an experimental driver for the Ralink rt2571W and rt2671 wireless chipsets.
> Other extended descriptions only refer to the chipsets. I think the chipset should be mentioned because users are more likely to know it than the MAC chip. OTOH, nothing prevents us from mentioning both.

What I am saying is that it will be confusing when the config option subject mentions chip A while
the help text mentions chip B. And this patch was focussed on making the text more clear.

Ivo
