Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52763 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaBDLmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 06:42:47 -0500
Message-ID: <1391514164.26522.89.camel@porter.coelho.fi> (sfid-20140204_124250_138209_B8A6B22E)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 04 Feb 2014 13:42:44 +0200
In-Reply-To: <1391513092.4134.4.camel@jlt4.sipsolutions.net>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110356_335827_0A67B036) <1391434913.4488.24.camel@jlt4.sipsolutions.net>
	 <1391508433.26522.61.camel@porter.coelho.fi>
	 <1391509992.4134.1.camel@jlt4.sipsolutions.net>
	 <1391512311.26522.75.camel@porter.coelho.fi>
	 <1391513092.4134.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 12:24 +0100, Johannes Berg wrote:
> On Tue, 2014-02-04 at 13:11 +0200, Luca Coelho wrote:
> 
> > > Well, what I was describing was really only the default policy if
> > > userspace didn't do anything useful, which IMHO should really just be:
> > > 
> > >  * client receives CSA - disconnect if it can't be done
> > >  * AP/GO wants CSA - refuse if it can't be done, let userspace sort it
> > > out
> > > 
> > > In the first case, userspace still has the time between receiving the
> > > CSA and actually acting on it to make another decision.
> > 
> > Right, this is okay, but the point is, what happens to the *other*
> > interfaces?
> 
> Nothing! As far as that's permissible. Ilan's patchset might change
> that, but that's mostly a regulatory thing, rather than a CSA thing.

Ah, you have some insider information! :P



> > What does "it can't be done" mean for the client? If there's a GO in the
> > same context and no free contexts for the switch, do we simply
> > disconnect the client (and leave the GO hanging in the same channel)? We
> > should probably tell the userspace and let it decide.
> 
> Yes, but we should only disconnect when the CSA actually needs to be
> done, rather than immediately on receiving it.

Sure, but how does the userspace know that the other interface *needs*
to be moved, regardless of regulatory problems? It needs to know that
there are not enough contexts to keep the interfaces in different
channels...


> > ...and, if the userspace doesn't react, we disconnect the GO.  I think
> > it's safer this way for the GO-follows-STA case.
> 
> That would be a consequence of Ilan's work, yes.

Okay, if that's going to be guaranteed, I'm fine with it.


> This typically won't happen, since userspace will do something else, but
> we need to have some default policy. I don't think anything else makes
> much sense?

My point was that a CSA could have been triggered due to regulatory
(which the AP/GO is monitoring), so the safest would be to move everyone
out of the channel by default.

But now I agree that this is an unrelated feature that also needs to be
handled when we do have free contexts to make the switch (and keep the
two interfaces in different channels).

--
Luca.

