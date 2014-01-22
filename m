Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbaAVIwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 03:52:13 -0500
Message-ID: <1390380726.4334.4.camel@jlt4.sipsolutions.net> (sfid-20140122_095216_176361_260E4D90)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 09:52:06 +0100
In-Reply-To: <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com> (sfid-20140122_075114_139752_88E4FB38)
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 (sfid-20140122_075114_139752_88E4FB38)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 07:51 +0100, Michal Kazior wrote:

> > I mean this:
> >
> >> +       sdata->csa_chandef = params.chandef;
> >
> > doesn't seem to belong here.
> 
> I mistakenly left that while rebasing. I'll fix that. I think that's
> the only thing that shouldn't be in this patch?

It's the only thing I found, but ... :)

> > It would also be good to explain why you're doing this?
> 
> You mean the whole locking patch? Basically to be able safely assess
> CSA state. Taking a bunch of wdev->mtx seems like a bad idea. Due to
> how the locks are ordered and organized I've came up with using
> local->mtx as an extra CSA-related variable protection. Using
> local->mtx makes it possible to iterate over interfaces and check
> for/update CSA state in an atomic way.
> 
> Is this a satisfactory explanation?

Almost - where exactly do you need that? I'm just trying to weigh this
patch vs. the other that I didn't like to see if this is needed
regardless of the particular approach of how we switch channels later.

johannes

