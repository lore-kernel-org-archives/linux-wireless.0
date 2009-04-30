Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54840 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763886AbZD3OLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 10:11:08 -0400
Date: Thu, 30 Apr 2009 11:11:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC v6] rfkill: rewrite
Message-ID: <20090430141104.GB28027@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local> <1239745712.4205.17.camel@johannes.local> <1239750483.4205.28.camel@johannes.local> <20090430031903.GD18827@khazad-dum.debian.net> <1241081621.27613.14.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241081621.27613.14.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 30 Apr 2009, Johannes Berg wrote:
> On Thu, 2009-04-30 at 00:19 -0300, Henrique de Moraes Holschuh wrote:
> > I am halfway on the thinkpad-acpi conversion. It is going slow because
> > I have to cleanup the entire thing to have the code look even remotely
> > sane now that HW and SW states are to be tracked separately by the
> > backend driver, and I lost the RFKILL_STATE_* stuff.
> 
> Hmm. I didn't think it was that much of a problem for the other drivers
> at least.

I will cope, it just slows things down.  What is really annoying me is that
I have to find a way to get the new rfkill running on 2.6.28 to be able to
test the code properly.  Fortunately, that just means net/rfkill, as the
only module I need that connects to rfkill is thinkpad-acpi itself.

> > Also, due to races, it is _impossible_ to assure the backend driver
> > that the set_block hook will never be called when the radio is
> > hard-blocked.  Best to change the description of that hook to make it
> > clear that it could happen, but that the rfkill core will try to
> > optimize away such changes.  Here's the race:
> > 
> >            A                                  B
> > rfkill_set_block
> >     saves state in "prev"
> >     ...                            rfkill_set_hw_state(true)
> >     call set_block hook
> >       but radio IS hard-blocked
> >       and the core WAS informed
> >       of this
> 
> Good point. I wonder what's more important -- it would be almost trivial
> to change this by using a spinlock instead of atomic bit operations.

Yeah, as long as it is a spinlock variant that can be used safely in any
context, it should work fine, as contention would be quite rare (unless
there is a pathological case in one driver that makes it always call some
set_foo just when the core is going to call it back...)

> > If I am not wrong, one could change rfkill_set_sw_state and
> > rfkill_set_states to return an error if rfkill_set_block is on the way
> > (that can be done lockless).  For rfkill_set_states, document that the
> > hw state WILL be updated regardless, but that the sw state might not
> > be.
> > 
> > Or one could kick the problem to the backend driver (which will have
> > any required locking anyway), by giving the set_block hook the duty of
> > calling set_sw_state when it succeeds.  The return status might be
> > kept should we ever start passing it down to other layers like
> > userspace, or you can remove it.
> 
> Thanks for your analysis. It does seem like a problem, and even locking
> in rfkill can't really avoid the problem [1]. However, why would we
> require the driver to postpone that? Your idea is sound, but I think we
> can do it in the core. It might require a spinlock there, but that's
> acceptable, I didn't use atomic operations to make it faster but to make
> it simpler.

Well, as long as the race is closed, and the kernel doesn't stay around
spinning with interrupts disabled for long periods, I'm fine :-)

>  * rfkill_set_block can set a flag "I'm in an update"
>  * a concurrent rfkill_set_sw_state will check that flag, and update the
>    "prev" variable instead of the real variable
>  * on errors, rfkill_set_block will then revert to whatever the last
>    set_sw_state said

That could work.  It is still required to make it clear that the set_block
hook can be called with a hardware block active, even if it normally won't
be, so that backend drivers are aware of the possibility.

> That way, if the driver returns an error from ops->set_block, we will
> really revert to what the driver last told us with set_sw_state. It
> would seem to get this prev/in-update handling correct we need to add a
> spinlock, but concurrent rfkill_set_block()s are already prevented by
> the mutex so no additional locking would be needed there.
> 
> Does that sound correct/acceptable?

I think so, but I'd need to look at the finished patch to be even remotely
sure. I am not very good at Linux locking yet, in particular I am quite weak
at the more esotheric (but really useful) readers/writers locks, RCU, and
other such stuff.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
