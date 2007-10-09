Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbXJIPhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 11:37:13 -0400
Subject: Re: [PATCH] libertas: automatically re-associate
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200710091713.35595.hs4233@mail.mn-solutions.de>
References: <200710091404.31491.hs4233@mail.mn-solutions.de>
	 <1191939561.17254.12.camel@localhost.localdomain>
	 <200710091713.35595.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 11:37:36 -0400
Message-Id: <1191944257.20014.3.camel@localhost.localdomain> (sfid-20071009_163721_328347_B50E1B8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-09 at 17:13 +0200, Holger Schurig wrote:
> > Seriously though, even if other drivers don't do it, that
> > doesn't mean libertas shouldn't do it.  If the association
> > fails, doesn't this mean the card just keeps working and keeps
> > trying to associate forever?
> 
> Yes, with a HZ/4 rate.

I don't care how _fast_ it tries to reassociate.  I care that it doesn't
give up after some amount of time.

> Maybe in the meantime the user is configuring the right WEP key 
> into his AP?
> 
> 
> 
> > It's not that much more complicated to add an item to the
> > association structure for 'count' and to check that from the
> > disassociation event code, and just not reschedule association
> > if that's > 4.
> 
> And after this 4 tries the device is again stuck?  That's not 
> nice.
> 
> Therefore you need some heuristic (I don't dare to name this 
> logic) to reset this counter again. But when do you do it?  If 
> you say "5 Minutes", then I simply change my HZ/4 into HZ*60*5 
> and have the same effect.
> 
> So I see that my HZ/4 is as arbitrary as your 4, but my version 
> is fail-safe, because when you move away from a mis-configured 
> AP to a right on, the device will automatically re-associate. 
> You see, I aim for a roaming client, not for a device that stays 
> put at some office desktop.

That's fine.  The drivers should _not_ be trying to handle all roaming
cornercases themselves.  And I believe that includes forever trying
reassociating.  Userspace must come into the equation at some point,
especially with WPA!!  This reassociation trick _only_ works for WEP.
And that immediately makes it less useful.

My point is that the _driver_ should only go so far in trying to guess
the intentions of the user and userspace itself.  It's not the drivers
job to cover every conceivable use-case, especially where the heuristics
are quite fuzzy.  That sort of thing just doesn't belong in drivers.

Dan

> 
> We also get disassociated from an AP when we're away from the 
> channel for too long, busy scanning for a better AP. The case 
> where someone clicks on a "Deassociate Client") is neglibibly. 
> 
> But even when I want to have it work automatically, and without 
> any manual user interaction at the WLAN client.

