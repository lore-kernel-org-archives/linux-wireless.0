Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaEGJH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:07:26 -0400
Message-ID: <1399453631.10517.10.camel@jlt4.sipsolutions.net> (sfid-20140507_110733_113510_437717FB)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 07 May 2014 11:07:11 +0200
In-Reply-To: <CA+BoTQnJ7N=UtDu_tySg8uYrQg9i+BvuYrwez7x-LUVinroWDw@mail.gmail.com> (sfid-20140507_110504_430475_F60563C9)
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	 <1399387345.4218.44.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com>
	 <1399449912.5038.7.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnJ7N=UtDu_tySg8uYrQg9i+BvuYrwez7x-LUVinroWDw@mail.gmail.com>
	 (sfid-20140507_110504_430475_F60563C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 11:05 +0200, Michal Kazior wrote:

> > I don't think that works for all drivers - only drivers that actually
> > generate and tx each beacon - but other drivers just update a template.
> > We actually have some pending patches to make that work correctly for
> > the CSA counters, but I'm not really sure what you want to happen in the
> > case that one is switching while the other hasn't yet? Should it stop
> > beaconing? Seems like clients would give up the switch then, no?
> 
> Ah, I completely forgot about the template-based approach.
> 
> But I don't think any beacons should be sent after cs_count=1 on the
> old channel either way. Thus, I would expect template-based drivers to
> stop beaconing after cs_count=1. cs_count=0 is a separate case as it
> means "i can disappear at any time now" and is a special case, not
> what happens after reaching cs_count=1 if I remember correctly.

I'm not really sure how this would work though - drivers that have
firmware generating beacons don't generally seem to be in a position to
just stop that aspect and continue operating otherwise, with active
clients and all that. It seems to me this might be really difficult to
implement.

> Clients should expect next beacon to appear on the new channel after
> seeing beacon with cs_count=1. In that case regular cqm for clients
> should apply.
> 
> Real-world multi-vif CSA will probably be off by up to 1 or 2 beacon
> intervals between vifs which should be disruptive for clients I guess.

"not be disruptive"?

Remind me why we're doing this - didn't you originally have something in
mind that was forcing them all to be synchronized with the switch?

johannes

