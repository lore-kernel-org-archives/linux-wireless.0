Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50392 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbbEVIeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 04:34:13 -0400
Message-ID: <1432283651.3493.7.camel@sipsolutions.net> (sfid-20150522_103419_805508_6C99377C)
Subject: Re: [PATCH 1/2] cfg80211: ignore netif running state when changing
 iftype
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 May 2015 10:34:11 +0200
In-Reply-To: <CA+BoTQmyY35mY_CVVK7kDr=DTaLLyATo20nB34es7Q=dTSEDCQ@mail.gmail.com> (sfid-20150521_094410_172003_61254FCB)
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
	 <1432127874.19214.13.camel@sipsolutions.net>
	 <1432127990.19214.14.camel@sipsolutions.net>
	 <CA+BoTQmyY35mY_CVVK7kDr=DTaLLyATo20nB34es7Q=dTSEDCQ@mail.gmail.com>
	 (sfid-20150521_094410_172003_61254FCB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-21 at 09:44 +0200, Michal Kazior wrote:
> On 20 May 2015 at 15:19, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2015-05-20 at 15:17 +0200, Johannes Berg wrote:
> >
> >> > -   if (ntype != otype && netif_running(dev)) {
> >> > +   if (ntype != otype) {
> >> >             dev->ieee80211_ptr->use_4addr = false;
> >> >             dev->ieee80211_ptr->mesh_id_up_len = 0;
> >> >             wdev_lock(dev->ieee80211_ptr);
> >>
> >> I don't think that makes much sense - the code within this block really
> >> only makes sense when the interface *is* running, like disconnecting
> >> etc. Doing that when it's *not* would be entirely unexpected to the
> >> drivers, no?
> 
> The netif_running() was originally introduced in f8cdddb8d61d which
> did in for entirely different purpose. Hence stripping netif_running()
> shouldn't be a problem for drivers, can it? The patch was also made
> kind of obsolete by b6a550156bc. Perhaps there are some other
> behavioral changes that I'm unaware of in stuff that gets called upon
> entering this condition down the stack..?

Perhaps it doesn't matter actually, since all the functions that are
called here will double-check things before calling the driver?

> Maybe it's just safer to move use_4addr/mesh_id_up_len clearing into a
> separate `oftype != ntype` condition. What do you think?

Or maybe we should just look at the functions we call in more detail :)

> > The real problem here might be the assignment to use_4addr *before*
> > we've actually disconnected or anything, perhaps that should be moved?
> >
> > Similarly, the mesh_id_up_len should probably be moved into the mesh
> > point switch case...
> 
> The problem isn't use_4addr clearing ordering per se. The problem is
> it wasn't cleared at all on interface changes. 

Ah.

> Do you want me to put the above into the commit log? Should I put a
> copy into the mac80211 patch as well?

I think just noting (more explicitly) that it was *missing* a clearing
in these cases would have been helpful.

johannes

