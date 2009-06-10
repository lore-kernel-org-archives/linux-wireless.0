Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39497 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbZFJCW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 22:22:29 -0400
Date: Tue, 9 Jun 2009 23:22:27 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, alan-jenkins@tuffmail.co.uk,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090610022227.GE593@khazad-dum.debian.net>
References: <1243928308.3192.38.camel@localhost.localdomain> <1243929706.20064.7.camel@johannes.local> <1243930703.3192.59.camel@localhost.localdomain> <20090603040315.GA10464@khazad-dum.debian.net> <1244008652.4145.7.camel@localhost.localdomain> <20090603213340.GB22809@khazad-dum.debian.net> <1244088806.4145.24.camel@localhost.localdomain> <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com> <1244389617.23850.102.camel@localhost.localdomain> <1244394258.1846.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244394258.1846.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 07 Jun 2009, Dan Williams wrote:
> 3G cards have two ways of being killed:
> 
> 1) Put them to sleep; Sierra for example has code that does this
> already, it will take the modem out of D3 sleep on startup.  No reason
> why rfkill couldn't just stick it back there.  Drivers that implement
> this method would be easy to integrate with rfkill if the BIOS/platform
> module doesn't do it for them (hp-wmi will drop the 3G card off the bus
> on the 2530p when you rfkill it, just like bluetooth, so nothing else is
> needed there).

thinkpads will power down the card (and obviously kick it off-bus), as
well.  This is how they disable bluetooth and 3G.

I have code in thinkpad-acpi that tells the fw to power these radios
down during sleep, and resume with them powered off.  Needs to be
unbroken to not do that on wake devices one of these days (_if_ the
thinkpad supports bluetooth or wwan as wake devices, something I also
have to find out).

BTW: please do send me a note of how you guys will want to do sleep/
resume with the new core, I probably will have to adjust thinkpad-acpi
to play well with it.

> 2) CFUN=0; that is supposed to shut down all radios, but of course that
> requires the serial port of the card and the firmware to be loaded and
> whatever.  And that should only be done by the daemon (if any, like
> ModemManager or Wader or whatever) that is arbitrating the serial port.
> That's not something that rfkilld should do.

And, to make matters worse, you are likely to find that lots of devices
screw that up (probably by just ignoring it silently) :-(  The people
writing the firmware for these modems do an even worse job than the
people writing ACPI BIOSes...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
