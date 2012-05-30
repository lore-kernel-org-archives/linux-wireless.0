Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab2E3HDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 03:03:16 -0400
Message-ID: <1338361388.4511.3.camel@jlt3.sipsolutions.net> (sfid-20120530_090319_560667_20400CBF)
Subject: Re: [PATCH] mac80211:  Limit number of pending skbs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Wed, 30 May 2012 09:03:08 +0200
In-Reply-To: <4FC55BE7.7010807@candelatech.com> (sfid-20120530_012950_634296_DA1EEA8E)
References: <1338332576-26427-1-git-send-email-greearb@candelatech.com>
	 <4FC55A83.6030602@openwrt.org> <4FC55BE7.7010807@candelatech.com>
	 (sfid-20120530_012950_634296_DA1EEA8E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-29 at 16:29 -0700, Ben Greear wrote:
> On 05/29/2012 04:23 PM, Felix Fietkau wrote:
> > On 2012-05-30 1:02 AM, greearb@candelatech.com wrote:
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> Current code will allow any number of pending skbs, and
> >> this can OOM the system when used with something like
> >> the pktgen tool (which may not back off properly if
> >> queue is stopped).
> >>
> >> Possibly this is just a bug in our version of pktgen,
> >> but either way, it seems reasonable to add a limit
> >> so that it is not possible to go OOM in this manner.
> >>
> >> Signed-off-by: Ben Greear<greearb@candelatech.com>
> > Adding a module parameter in a workaround for a possibly broken module
> > seems a bit excessive to me.
> >
> > Also, I'm not sure adding such a silent packet drop is a good idea. At
> > the very least, it should complain loudly to encourage people to fix the
> > actual bug instead of just papering over it.
> >
> > When the driver cannot accept more packets, the queue stop should
> > prevent the network stack from spamming mac80211 with more packets. Your
> > pktgen seems to be ignoring this, so please fix it instead of adding
> > workarounds to mac80211.
> 
> Ok, I'll work on pktgen next time I get a chance.
> 
> I recall I had to add a hack (that was not wanted upstream)
> to get pktgen to even work with mac80211 interfaces w/out crashing
> the kernel, so probably no one else is using it anyway.

There used to be bugs in this area in mac80211 and/or pktgen, and I
remember crashing my machine very trivially. I don't think that this is
still a problem though, but I haven't tried in a long time. FWIW, the
time-frame of this must've been ~2-3 years ago.

johannes

