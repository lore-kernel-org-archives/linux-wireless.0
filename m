Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50746 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbZC1AwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 20:52:20 -0400
Date: Fri, 27 Mar 2009 21:52:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rfkill-input madness
Message-ID: <20090328005214.GA7439@khazad-dum.debian.net> (sfid-20090328_015223_986134_1D57339D)
References: <1238159196.4452.1.camel@johannes.local> <20090327143007.GA24288@khazad-dum.debian.net> <1238188237.4452.17.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238188237.4452.17.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Mar 2009, Johannes Berg wrote:
> On Fri, 2009-03-27 at 11:30 -0300, Henrique de Moraes Holschuh wrote:
> > I think rephrasing that warning to: "set user_claim to 1 on any switches
> > that you're going to mess with in response to rfkill input events" would be
> > a LOT better.  I should have written it that way.
> 
> Indeed, but that's useless since almost all drivers disable userspace
> claiming... I'll re-implement it later for only the software state.

I think we can remove the "disable userspace claiming" stuff entirely,
and retain user_claim.  user_claim just means rfkill_input won't touch
a rfkill controller, there is no problem if the state changes because
the rfkill controller's driver had to do a rfkill_force_state() for
some reason.

> > The truth is that userspace doestn't have to care about
> > rfkill-input, unless it is trying to do what rfkill-input is
> > supposed to (i.e. listening to input events and then trying to
> > update switches), and if it is going to do that, it needs stuff
> > that I never sent in for review.
> 
> Care to explain?

Sure: all that matters is that you won't have two different actors
trying to implement handling for, e.g. EV_KEY KEY_BLUETOOTH, by
complementing the state of a rfkill switch.  If you do, actor A
complements, then B complements, and the net effect is that no change
happened :)

> > Anyway, I got sidetracked because I was Not Happy with the userspace ABI but
> > couldn't come up with anything better.  
> 
> It's not like we can change it now...

I don't mean the rfkill core API that is already in place...  I mean
the new one in the "RFC" patchset I just posted.

> > The problem is that X.org will exclusive-grab any input devices
> > you let it touch, and rfkill_input will never see any events,
> > anyway.   So, right now, for the vast majority of the users,
> > either an input device is not in use, or it is in exclusive-grab
> > mode feeding X.org evdev.

...

> Indeed, but that means *X* needs to implement all this, or something
> running in X, which is undesirable... Other things are sure to run
> afoul of this too, for example some hal button handlers.

Yes.  But the exclusive grab _is_ needed for regular keyboards,
otherwise anyone can snoop on what you type.  But it is not what one
would like to happen to hotkey input devices... most of the time.
It is confusing as heck.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
