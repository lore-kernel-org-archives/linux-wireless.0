Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYLNRG7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2008 12:06:59 -0500
Subject: Re: Fuijtsu Lifebook RFKILL support
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tony Vroon <tony@linx.net>, Len Brown <lenb@kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
In-Reply-To: <20081213132857.GA11428@khazad-dum.debian.net>
References: <1228957506.4045.11.camel@localhost>
	 <20081211165247.GA4844@khazad-dum.debian.net>
	 <1229016827.6446.6.camel@localhost>
	 <20081211194734.GA18132@khazad-dum.debian.net>
	 <1229046602.4030.13.camel@localhost>
	 <20081212195331.GA12679@khazad-dum.debian.net>
	 <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain>
	 <1229172465.4010.11.camel@localhost>
	 <20081213132857.GA11428@khazad-dum.debian.net>
Content-Type: text/plain
Date: Sun, 14 Dec 2008 12:05:43 -0500
Message-Id: <1229274343.6775.15.camel@localhost.localdomain> (sfid-20081214_180709_806588_E7992C51)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-12-13 at 11:28 -0200, Henrique de Moraes Holschuh wrote:
> On Sat, 13 Dec 2008, Tony Vroon wrote:
> > > What is the WLAN driver involved? Is it rfkill-aware?
> > 
> > The driver is iwlagn, which does indeed notice that it is killed.
> > This information does not reach NetworkManager. Relevant log
> > entries: Dec 12 00:59:01 amalthea iwlagn: Radio Frequency Kill
> > Switch is On: Dec 12 00:59:01 amalthea Kill switch must be turned
> > off for wireless networking to work.
> 
> Then, it is just a matter of time for it to be working correctly.  In
> fact, it might already be if you use wireless-testing and latest
> network manager.

If HAL's killswitch support doesn't know about the kernel killswitch
device, or it cannot get the state of the killswitch, then certainly
NetworkManager isn't going to know about it.

Dan

> Best not to mess with it, any workarounds one adds would just get in
> the way in the future.
> 
> > [cutting relevant pieces of text together]
> > > > 1. rfkill actualy is/looks like a hotplug/hotunplug operation
> > > >   1b. You cannot do it at will
> > > >       Attaching it to the rfkill core simply is not supported
> > 
> > Okay, both Bluetooth & WWAN are USB devices following this terminology.
> > So the rfkill framework is not an appropriate tool for this job,
> > understood.
> > 
> > Len, I would still like to export the 3 values learned about in this
> > event to userspace. Is it alright for me to create 3 read-only files on
> > the platform device? (docked, lid, radios)
> > It would if anything simplify the code.
> 
> FWIW, I think this is also the way to go.  It is much easier for
> userspace to deal with sysfs attributes.  HAL can deal with more
> complex stuff, but shell script writers often don't know how to, nor
> care to, deal with HAL.
> 
> BTW, this also means that it is helpful to shell script writers if you
> also export through read-only sysfs attributes the state of any input
> devices generating EV_SW.  The input layer makes it possible to query
> the switch state easily... through IOCTL after you find out the
> correct input device(s) to query.  Which ain't easy for shell script,
> and nobody wrote a "inputdev" helper in a proper language that can do
> it, for shell script writers to call.
> 

