Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:32161 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYIWWpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 18:45:34 -0400
Received: by ey-out-2122.google.com with SMTP id 6so690154eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2008 15:45:32 -0700 (PDT)
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -mm] rt2x00: fix Kconfig dependencies
Date: Wed, 24 Sep 2008 00:45:28 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	linville@tuxdriver.com, akpm <akpm@linux-foundation.org>
References: <48D82A43.7040604@oracle.com> <200809240009.32167.IvDoorn@gmail.com> <20080923153043.7aa806b8.randy.dunlap@oracle.com>
In-Reply-To: <20080923153043.7aa806b8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809240045.28976.IvDoorn@gmail.com> (sfid-20080924_004538_655871_62EC707B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 September 2008, Randy Dunlap wrote:
> On Wed, 24 Sep 2008 00:09:31 +0200 Ivo van Doorn wrote:
> 
> > On Tuesday 23 September 2008, Larry Finger wrote:
> > > Randy Dunlap wrote:
> > > > On Tue, 23 Sep 2008 19:51:00 +0200 Ivo van Doorn wrote:
> > > > 
> > > >> On Tuesday 23 September 2008, Randy Dunlap wrote:
> > > >>> Ivo van Doorn wrote:
> > > >>>> On Tuesday 23 September 2008, Randy Dunlap wrote:
> > > >>>>> From: Randy Dunlap <randy.dunlap@oracle.com>
> > > >>>>>
> > > >>>>> If RT2X00=y but RFKILL=m, these build errors happen:
> > > >>>>>
> > > >>>>> (.text+0x7c7d6): undefined reference to `rfkill_free'
> > > >>>>> rt2x00rfkill.c:(.text+0x7c830): undefined reference to `rfkill_force_state'
> > > >>>>> (.text+0x7c88d): undefined reference to `rfkill_unregister'
> > > >>>>> (.text+0x7c8cd): undefined reference to `rfkill_register'
> > > >>>>> (.text+0x7ca1a): undefined reference to `rfkill_allocate'
> > > >>>>>
> > > >>>>> so restrict RT2X00's RFKILL config level to that of the main RFKILL option.
> > > >>>>> This is done by making the former a tristate instead of a bool
> > > >>>>> config option.
> > > >>>>>
> > > >>>>>
> > > >>>>> If RT2X00=y but LEDS_CLASS=m, these build errors happen:
> > > >>>>>
> > > >>>>> (.text+0x11859f): undefined reference to `led_classdev_resume'
> > > >>>>> (.text+0x1185b3): undefined reference to `led_classdev_resume'
> > > >>>>> (.text+0x1185c7): undefined reference to `led_classdev_resume'
> > > >>>>> (.text+0x1185e4): undefined reference to `led_classdev_suspend'
> > > >>>>> (.text+0x1185f8): undefined reference to `led_classdev_suspend'
> > > >>>>> (.text+0x11860c): undefined reference to `led_classdev_suspend'
> > > >>>>> rt2x00leds.c:(.text+0x118620): undefined reference to `led_classdev_unregister'
> > > >>>>> rt2x00leds.c:(.text+0x118695): undefined reference to `led_classdev_register'
> > > >>>>>
> > > >>>>> so restrict RT2X00's LEDS config level to that of the main LEDS_CLASS option.
> > > >>>>> This is done by making the former a tristate instead of a bool
> > > >>>>> config option.
> > > >>>> Is that really going to work correctly?
> > > >>>> rfkill and leds support should be compiled into rt2x00lib.ko, which means that
> > > >>>> should become a module instead of the rfkill/leds support part only.
> > > >>> I wondered about that lib.ko.  Any working build fix is OK with me.
> > > >>> What do you suggest?
> > > >> Actually I was hoping that you answer to my question was going to be "yes it will be working correctly" ;)
> > > >>
> > > >> Would this work?
> > > >>
> > > >> config RT2X00_LIB_RFKILL
> > > >> 	tristate
> > > >>   	depends on RFKILL
> > > >>   	default y
> > > >>   
> > > >> config RT2X00_LIB_LEDS
> > > >> 	tristate
> > > >>   	depends on NEW_LEDS
> > > >>   	depends on LEDS_CLASS
> > > >> 	default y
> > > >>
> > > >> config RT2X00_LIB
> > > >> 	tristate
> > > >> 	depends on RT2X00_LIB_RFKILL if (RT2X00_LIB_RFKILL != n)
> > > >> 	depends on RT2X00_LIB_LEDS if (RT2X00_LIB_LEDS != n)
> > > >>
> > > >> It's ugly, and I can't test this right now, but perhaps you have an idea if this could do the trick?
> > > > 
> > > > I tried it:
> > > > 
> > > > drivers/net/wireless/rt2x00/Kconfig:22: invalid option
> > > > drivers/net/wireless/rt2x00/Kconfig:23: invalid option
> > > > 
> > > > "depends ... if ..." is invalid.  Would be nice to have that.
> > > > Maybe there is some other way to express that...
> > > 
> > > Wouldn't this do it?
> > > 
> > > depends on (RT2X00_LIB_RFKILL == m) || (RT2X00_LIB_RFKILL == y)
> > > 
> > > In b43, what I think is a similar configuration statement is written as
> > > 
> > > depends on B43 && (RFKILL = y || RFKILL = B43) && RFKILL_INPUT &&
> > > (INPUT_POLLDEV = y || INPUT_POLLDEV = B43)
> > 
> > Wouldn't that completely disable the config option when the rfkill is build
> > as module and b43 buildin? I think what you want in that scenario would be
> 
> Yes, it does.
> 
> > building b43 as module instead.
> > On the other hand, such Kconfig expression is apparently not possible,
> > which means your approach would be the closest match.
> 
> Ivo, please explain what rt2x00 module(s) you want to be built.  In English
> if possible, not in Kconfig language...

There are 3 kind of rt2x00 modules:
	rt2x00lib
	rt2x00pci/usb
	rt2x00 driver (rt2400pci, rt2500pci, rt61pci, rt2500usb, rt73usb)

When the user selects any of the rt2x00 drivers, the rt2x00pci/usb and rt2x00lib
are selected. For rt2x00lib there are some additional configuration options like
RT2X00_LIB_RFKILL and RT2X00_LIB_LEDS which will build into rt2x00lib.

This means that when rt2400pci is selected as module, rt2x00pci and rt2x00lib
must be built as modules as well and when rt2400pci is selected as buildin
rt2x00pci and rt2x00lib must be buildin as well.

But with the optional rt2x00lib configuration options the breakage you reported
is possible. So we either need:
	1) Force rt2x00lib / driver to be compiled as module when RFKILL/LEDS were
	    compiled as module
	2) Disable config option when invalid config combination is found

Personally I would favor 1), because 2) could lead to confusion to users
who think they selected everything they needed to enable support for it in
rt2x00.

Ivo
