Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51042 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424AbYLBPD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 10:03:29 -0500
Date: Tue, 2 Dec 2008 13:03:23 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: Re: iwlwifi - rfkill only works if the interface is up
Message-ID: <20081202150323.GF1668@khazad-dum.debian.net> (sfid-20081202_160334_414609_140C1548)
References: <200812011311.17346.helmut.schaa@gmail.com> <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com> <1228145453.31158.140.camel@violet.holtmann.net> <200812011634.37644.helmut.schaa@gmail.com> <1228147151.31158.142.camel@violet.holtmann.net> <20081202125959.GC1668@khazad-dum.debian.net> <1228223693.31158.240.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228223693.31158.240.camel@violet.holtmann.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Marcel,

On Tue, 02 Dec 2008, Marcel Holtmann wrote:
> > > if the hardware/firmware doesn't allow us to do so, we have no real
> > > option. I think that nobody thought about this use case so far. I am not
> > > sure if we should unregister it or just fix rfkill to add an invalid
> > > state. It is also possible to tie rfkill with ifup/ifdown.
> > 
> > Please don't register/unregister rfkill classes like that, it is extremely
> > broken from userspace's point-of-view, and it is not how the rfkill core
> > subsystem expects things to be used either.    If there is no way to avoid
> > register/unregister at interface up/down, it is better to never register any
> > rfkill classes at all, and remove the functionality.
> > 
> > Now, I hate when people use the term "rfkill switch" when dealing with the
> > kernel rfkill subsystem, because we can't really always be sure we
> > understood what the person means, so please bear with me...
> > 
> > Are you talking about the hardware rfkill line (the input pin where one
> > might have hooked an input device)?  Or about something else?
> 
> so this case is that we are not getting any updates about the rfkill
> line status if the firmware is not loaded (happens at ifdown case). How
> do you propose this should be handled?

The hardware rfkill line?  If it is the hardware rfkill line,  I have some
ideas.  Some are better for the user, but much harder to implement...

1. Poll it @1Hz or 0.5Hz while the firmware is down if it makes sense (i.e.
if the whole process needed to poll (which might well mean start the
firmware, poll, stop it) is not worse than keeping the firmware running all
the time in the first place).

2. Have a powersave firmware that you upload to the card instead of shutting
it down, and have that firmware still report hardware rfkill line changes.
This one is probably the ideal solution.

3. Consider alternate ways of power saving.  E.g. you could soft-rfkill the
radio (but you must HIDE this from the rfkill core!) every time no
interfaces that can cause data transmission are open, if that would save
power but still leave the firmware running to get events.

4. Provide the user with a runtime tunable, which lets him disable the
firmware shutdown when closed.  This is important for users of platforms
where the ipw card is the only way to get the status of the input device
driving hardware rfkill.

I expect many users will be able to run with the opportunistic firmware
shutdown optimization enabled without even noticing it much, as you often
can read the input device responsible for driving platform-wide hardware
rfkill lines from some other place (like vendor-specific ACPI nodes), and a
platform driver will take care of it.

Anyway, please make sure you manually poll and update the rfkill core state
through a call to rfkill_force_state() as soon as possible after you start
the firmware, if it was stopped for any reason and you might have lost
hardware rfkill line state change events.

I have also looked at the question from various povs, and my conclusion is
that, if we cannot avoid it at all, it is probably going to be annoying as
all heck to userspace but we may have to add a way for the rfkill core to
return -EBUSY when the current rfkill state is unknown.

I don't recommend adding a STATE_UKNOWN to rfkill.  It is useless for
anything else, and it will get in the way everywhere in the rfkill core and
userspace.  It is much better to just return a suitable error to userspace
when it queries the rfkill state.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
