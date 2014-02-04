Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaBDLY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 06:24:57 -0500
Message-ID: <1391513092.4134.4.camel@jlt4.sipsolutions.net> (sfid-20140204_122500_168876_57CA087A)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 04 Feb 2014 12:24:52 +0100
In-Reply-To: <1391512311.26522.75.camel@porter.coelho.fi>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110356_335827_0A67B036) <1391434913.4488.24.camel@jlt4.sipsolutions.net>
	 <1391508433.26522.61.camel@porter.coelho.fi>
	 <1391509992.4134.1.camel@jlt4.sipsolutions.net>
	 <1391512311.26522.75.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 13:11 +0200, Luca Coelho wrote:

> > Well, what I was describing was really only the default policy if
> > userspace didn't do anything useful, which IMHO should really just be:
> > 
> >  * client receives CSA - disconnect if it can't be done
> >  * AP/GO wants CSA - refuse if it can't be done, let userspace sort it
> > out
> > 
> > In the first case, userspace still has the time between receiving the
> > CSA and actually acting on it to make another decision.
> 
> Right, this is okay, but the point is, what happens to the *other*
> interfaces?

Nothing! As far as that's permissible. Ilan's patchset might change
that, but that's mostly a regulatory thing, rather than a CSA thing.

> What does "it can't be done" mean for the client? If there's a GO in the
> same context and no free contexts for the switch, do we simply
> disconnect the client (and leave the GO hanging in the same channel)? We
> should probably tell the userspace and let it decide.

Yes, but we should only disconnect when the CSA actually needs to be
done, rather than immediately on receiving it.

> ...and, if the userspace doesn't react, we disconnect the GO.  I think
> it's safer this way for the GO-follows-STA case.

That would be a consequence of Ilan's work, yes.

This typically won't happen, since userspace will do something else, but
we need to have some default policy. I don't think anything else makes
much sense?

johannes

