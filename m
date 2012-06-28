Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2F1Jmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 05:42:39 -0400
Message-ID: <1340876555.4491.33.camel@jlt3.sipsolutions.net> (sfid-20120628_114242_564854_51879C03)
Subject: Re: [PATCH] mac80211: allow Rx in reconfig only after removing BA
 sessions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Jun 2012 11:42:35 +0200
In-Reply-To: <CA+XVXfcDNcy+RjdxraqJ6LnYWt3XdtF-X-Ah9FdP=ZibnYp15g@mail.gmail.com> (sfid-20120628_113828_388340_925DDFF5)
References: <1340821557-27009-1-git-send-email-arik@wizery.com>
	 <1340871433.4491.20.camel@jlt3.sipsolutions.net>
	 <CA+XVXfdKLeaHpLmqsXROH9VojHkB4EP-BpcFDLb8ZCtjb_XCbQ@mail.gmail.com>
	 <1340875844.4491.26.camel@jlt3.sipsolutions.net>
	 <CA+XVXfcDNcy+RjdxraqJ6LnYWt3XdtF-X-Ah9FdP=ZibnYp15g@mail.gmail.com>
	 (sfid-20120628_113828_388340_925DDFF5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 12:38 +0300, Arik Nemtsov wrote:
> On Thu, Jun 28, 2012 at 12:30 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-06-28 at 11:37 +0300, Arik Nemtsov wrote:
> >> On Thu, Jun 28, 2012 at 11:17 AM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >> > On Wed, 2012-06-27 at 21:25 +0300, Arik Nemtsov wrote:
> >> >> Previously, a connected STA/AP could send us some AMPDUs right after
> >> >> recovery, without the driver knowing anything about it.
> >> >
> >> > Huh, that description doesn't make a lot of sense? The STA/AP can send
> >> > us AMPDUs anyway without the driver knowing anything about it since it
> >> > has no idea we're restarting ...
> >>
> >> Well the point is to drop them early in the Rx path. Should I change
> >> the description or you don't like the patch in general?
> >
> > I don't mind the patch, I just don't quite understand it still.
> >
> > The driver is receiving the AMPDUs anyway, and if it's passing them up
> > why do we need to drop them?
> 
> Well if the de-aggregration is in HW, they won't make it as far as
> mac80211. So this patch is for SW de-aggregators.

I don't think there's anyone doing AMPDU SW deaggregation? There
definitely isn't any code in mac80211 to do it ;-)

> But come to think of it, if the de-aggregation is done in SW, I guess
> there's no real issue with accepting them, since mac80211 didn't
> really reboot.

Or are you thinking of the reorder buffer?

> I guess we can drop the patch? It just seemed more correct to put the
> in_reconfig to false there.

I don't see how it's more correct? We're done reconfiguring and then
decide to drop all BA sessions ;-)

In a way, heck, it seems more correct to leave as-is. If we send a BA
action frame and receive a response to it maybe (is there a response to
delBA?) we don't want to drop it. Or if we send delBA and the peer wants
to start right away again, ...?

johannes

