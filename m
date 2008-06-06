Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbYFFO17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 10:27:59 -0400
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
In-Reply-To: <20080606141419.GA3444@khazad-dum.debian.net>
References: <1212549017-30144-2-git-send-email-hmh@hmh.eng.br>
	 <1212611246.4018.12.camel@localhost.localdomain>
	 <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
	 <20080605003808.GA16599@khazad-dum.debian.net>
	 <1212667955.25730.29.camel@localhost.localdomain>
	 <20080605130323.GB3413@khazad-dum.debian.net>
	 <1212677207.28545.56.camel@localhost.localdomain>
	 <1212696826.13915.1256967905@webmail.messagingengine.com>
	 <1212722763.1026.17.camel@localhost.localdomain>
	 <1212758662.26514.5.camel@localhost.localdomain>
	 <20080606141419.GA3444@khazad-dum.debian.net>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:27:31 -0400
Message-Id: <1212762451.28631.3.camel@localhost.localdomain> (sfid-20080606_162819_632451_E9F2D1DD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-06 at 11:14 -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 06 Jun 2008, Dan Williams wrote:
> > Let me explain this a bit more.
> > 
> > - My original request was based on my flawed understanding of the
> > current scope of the rfkill system
> 
> Ok.  I am keeping that in mind.
> 
> > - If the rfkill system is _only_ supposed to handle switches that turn
> > the radio off automatically, then a "third state" for the rfkill class
> > really serves _no_ purpose at all, because the radio's already blocked
> > when the switch is thrown
> 
> Given these rules (not documented fully yet, I shall fix it when this
> thread quiesces):
> 
> 1. Every transmitter shall have ONE, and just ONE (not zero, not two,
> not more) rfkill class attached.  For those transmitters lacking support
> in hardware to make it block, the drivers shall quiesce them and avoid
> doing anything to cause transmissions, or even use bus tricks to power
> the device down (i.e. the driver will emulate a switch capable of doing
> the blocking).
> 
> Thus, rfkill class will give you the DEVICE (radio) rfkill block/unblock
> state on wireless devices (ignore switches for now, I will explain them
> in another email).
> 
> The information of whether a transmitter is currently blocked in a way
> you can request it to be unblocked (soft-kill) or currently blocked in a
> way you cannot request it to be unblocked (hard-kill) DOES belong in
> rfkill class.   Do you want/need that information, yes or no?

Yes, I want/need that information.

> > - There are drivers that implement rfkill (laptop-specific BIOS drivers)
> > that have _no_ associated transmitter device; thus the current 'struct
> > rfkill' can only be a representation of the _switch_; thus a "third
> > state" would be useless here as well (as is the toggle_radio() callback)
> 
> I haven't finished replying to your other email yet, because it is not a
> fast reply (and I am in a hurry in the next two days) and I need to look
> at hp-wmi itself to understand what the issue that is causing confusion
> is.  THAT reply will explain to you how it works with "pure read/write
> switches that are not in a wireless device".  THEN we shall be able to
> unravel the confusion, and I will finally understand what you are trying
> to tell me (or you will understand what I am trying to tell you).

Well, it's not just hp-wmi.

On a laptop with _no_ rfkill keys and only pure input keys that get
handled by userspace or whatever, there should still be "transmitter
sw-blocked/hw-blocked/unblocked" functionality available, even though
there is no hardware rfkill key present on the system.  That's another
thing I'm confused about.  It seems that the rfkill class is not
appropriate for that if it's trying to also handle actual rfkill keys
too.

They are two separate things, because there are examples of hardware
that are both ways.  And separating the switch bits from the transmitter
bits is the best way to accommodate both types of hardware.

Dan

> > - It just seems a lot clearer to me to have a separation between the
> > rfkill switch and the radio bits since there's no need to tie them
> > together
> 
> And this is part of the confusion.  So, for now, please just look at the
> question four paragraphs above, and tell me whether you want that
> information or not.  I'd think you would, since you want to gray out the
> "enable radio" button when the radio is blocked by some hardware signal
> you cannot override, but I could be confused about it...
> 

