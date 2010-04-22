Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56808.mail.re3.yahoo.com ([66.196.97.82]:47373 "HELO
	web56808.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752319Ab0DVJFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 05:05:03 -0400
Message-ID: <165038.86952.qm@web56808.mail.re3.yahoo.com>
Date: Thu, 22 Apr 2010 02:05:00 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [rt2x00] rt3070 fails to initialize with rt2800usb
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
In-Reply-To: <4BCF69BC.9040800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I think I spoke too early. Must have been a snarl up
> at my end, because even removing the "#" comment sign before
> "CONFIG_RT2800USB_RT30XX=y" in config.mk doesn't solve the
> detection problem.
> > 
> > I just concluded a test with today's compat-wireless
> /April 20/, enabled "CONFIG_RT2800USB_RT30XX=y" in
> config.mk, but rt2800usb doesn't detect the VIDs and
> subsequently fails to initialize the device. Adding, however
> the card's VIDs in the upper portion of code appears to
> solve the case. I welcome you to test yourself.
> > 
> > The good news is, once we get past the detection
> debacle the device seems to finally show some life.
> > 
> 
> I just checked with the compat-wireless of April 18, and
> with me removing the '#' sign in config.mk does the trick.
> I can't explain why it doesn't work for you, but I cannot
> see anything wrong with compat-wireless or with rt2x00
> inside compat-wireless.
> 
> --
> Gertjan.

The problem remains. I have two cards: rt3070 and rt3071, their respective VIDs are 148f:3070 and 148f:3071. They are both undetected. Just tried "compat-wireless-2010-04-21.tar.bz2" with enabled "CONFIG_RT2800PCI_RT30XX=y" in config.mk - no go.

The rt2800usb does not pick the VIDs, here is the log from modinfo rt2800usb:

filename:       /lib/modules/2.6.31-20-generic/updates/drivers/net/wireless/rt2x00/rt2800usb.ko
license:        GPL
firmware:       rt2870.bin
description:    Ralink RT2800 USB Wireless LAN driver.
version:        2.3.0
author:         http://rt2x00.serialmonkey.com
srcversion:     89BFEC74F4AE6DC8C4BA0E8
alias:          usb:v0586p3416d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v5A57p0282d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v5A57p0280d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CDEp0025d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CDEp0022d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v157Ep300Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v177Fp0302d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15A9p0006d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v083ApB522d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v083ApA618d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v083Ap8522d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v083Ap7522d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v083Ap7512d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v083Ap6618d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p003Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p003Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p003Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p0039d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p002Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p002Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p002Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p0017d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v129Bp1828d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04E8p2018d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2870d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2770d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2019pED06d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0471p200Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DB0p6899d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v100Dp9031d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0789p0164d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0789p0163d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0789p0162d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1737p0071d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1737p0070d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0E66p0003d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0E66p0001d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1044p800Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1740p9702d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1740p9701d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v7392p7718d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v7392p7717d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C11d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07D1p3C09d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07AAp003Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07AAp003Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07AAp002Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C28d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C27d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C25d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C23d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C09d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C07d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14B2p3C06d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0411p00E8d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp815Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp805Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp8053d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3247d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1742d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1732d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p1731d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1690p0740d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v15C5p0008d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1482p3C09d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8p2770d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8p2870d*dc*dsc*dp*ic*isc*ip*

no "3070" or "3071" at all.

The closest to my VIDs are these here:
alias:          usb:v148Fp2870d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp2770d*dc*dsc*dp*ic*isc*ip*

So basically the driver only works if I manually add them to code above. Config.mk doesn't seem to change anything.

The problem as I recall first occurred in late January or some time in February when  someone decided to remove large portion of the VIDs from the code because of driver collisions and I suppose the purpose of it was to reshuffle VID tables and insert some sort of order. Since then, compat-wireless does not automatically provide drivers for the rt307x via rt2800usb. To this point, only manual modification and inserting of the VIDs above solves the problem.

I'm a 100% certain of this. Even if your cards have different VIDs /not 148f:3070/, just install compat-wireless with enabled rt307X support and see if "modinfo rt2800usb |grep 3070" returns something. Then you'll be able to verify my reports.

Walter.


      
