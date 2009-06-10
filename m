Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49382 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbZFJHQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 03:16:17 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>, alan-jenkins@tuffmail.co.uk,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090610022227.GE593@khazad-dum.debian.net>
References: <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local>
	 <1243930703.3192.59.camel@localhost.localdomain>
	 <20090603040315.GA10464@khazad-dum.debian.net>
	 <1244008652.4145.7.camel@localhost.localdomain>
	 <20090603213340.GB22809@khazad-dum.debian.net>
	 <1244088806.4145.24.camel@localhost.localdomain>
	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
	 <1244389617.23850.102.camel@localhost.localdomain>
	 <1244394258.1846.3.camel@localhost.localdomain>
	 <20090610022227.GE593@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 09:16:08 +0200
Message-Id: <1244618168.3068.31.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > 3G cards have two ways of being killed:
> > 
> > 1) Put them to sleep; Sierra for example has code that does this
> > already, it will take the modem out of D3 sleep on startup.  No reason
> > why rfkill couldn't just stick it back there.  Drivers that implement
> > this method would be easy to integrate with rfkill if the BIOS/platform
> > module doesn't do it for them (hp-wmi will drop the 3G card off the bus
> > on the 2530p when you rfkill it, just like bluetooth, so nothing else is
> > needed there).
> 
> thinkpads will power down the card (and obviously kick it off-bus), as
> well.  This is how they disable bluetooth and 3G.
> 
> I have code in thinkpad-acpi that tells the fw to power these radios
> down during sleep, and resume with them powered off.  Needs to be
> unbroken to not do that on wake devices one of these days (_if_ the
> thinkpad supports bluetooth or wwan as wake devices, something I also
> have to find out).
> 
> BTW: please do send me a note of how you guys will want to do sleep/
> resume with the new core, I probably will have to adjust thinkpad-acpi
> to play well with it.
> 
> > 2) CFUN=0; that is supposed to shut down all radios, but of course that
> > requires the serial port of the card and the firmware to be loaded and
> > whatever.  And that should only be done by the daemon (if any, like
> > ModemManager or Wader or whatever) that is arbitrating the serial port.
> > That's not something that rfkilld should do.
> 
> And, to make matters worse, you are likely to find that lots of devices
> screw that up (probably by just ignoring it silently) :-(  The people
> writing the firmware for these modems do an even worse job than the
> people writing ACPI BIOSes...

I was talking about the external 3G cards. So besides the Option HSO,
that has a RFKILL switch, we have no control right now.

For all the built-in ones, I just expect that we have a platform RFKILL
switch that does the right thing. Naive, but good enough for now :(

Regards

Marcel


