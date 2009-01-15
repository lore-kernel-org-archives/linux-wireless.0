Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39320 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbZAOCQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 21:16:13 -0500
Date: Thu, 15 Jan 2009 00:16:09 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Werner Almesberger <werner@openmoko.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rfkill: how murderous can it be ?
Message-ID: <20090115021609.GA31256@khazad-dum.debian.net> (sfid-20090115_031619_909631_86676ABF)
References: <20090112191514.GA22112@almesberger.net> <20090113005401.GA7565@srcf.ucam.org> <20090113132159.GB27676@khazad-dum.debian.net> <1231854016.3671.29.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231854016.3671.29.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 13 Jan 2009, Johannes Berg wrote:
> On Tue, 2009-01-13 at 11:21 -0200, Henrique de Moraes Holschuh wrote:
> > But I DO heavily suggest that we inform userspace differently when state was
> > lost (i.e. when it absolutely HAS to reconfigure the device or there are no
> > chances of data passing through).
> > 
> > Right now, it HAS that information in a roundabout way: if the device
> > disappears (hotunplug), state was lost (duh! :-p)   If it stays around, no
> > state was lost...
> > 
> > And, as an user, I'd be rather annoyed if suddenly I couldn't easily and
> > cheaply just hit the rfkill hotkey (softswitch) to kill and unkill my WLAN
> > while browsing, and stopping a few minutes to read the screen... because
> > every time I unkilled, the system would churn, deassociate and reassociate
> > and be otherwise annoying doing a reconfiguration it didn't absolutely have
> > to do.
> > 
> > In other words: make it possible to be configurable!  From the kernel POV
> > that just means we need to have to publish to userspace the fact that it has
> > to reconfigure when there is not a full hotunplug/hotplug being done.
> 
> Way overkill. Anything more than a few seconds of rfkill will require
> the "churn" anyway.

Then don't corrupt the interface running state in the first place.

If you are going to detach the device, fine.  If you are going to NOT detach
the device but it also won't lose any state, fine.   These two situations
happen to describe the behaviour of *ALL* the current rfkill-enabled
drivers, AFAIK.

And since the driver that spawned this thread will detach the device instead
of doing something "new" (partially lose state), that hasn't changed yet...

But IMO, corrupting running state on rfkill is a rotten thing to do to the
user.  And telling userspace authors to EXPECT that every rfkill could have
that effect no matter the hardware, is not nice either.

Why the should I, as an user, have to tolerate userspace needing to reset
the entire interface for no good reason at all if my hardware and its
drivers do NOT require it?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
