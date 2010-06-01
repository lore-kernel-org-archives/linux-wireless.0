Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0FAUGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 16:06:46 -0400
Subject: Re: Path for fixed channel issue in aircrack-ng suite [V2]
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1275421989.2574.12.camel@maxim-laptop>
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
	 <1274775071.3635.4.camel@jlt3.sipsolutions.net>
	 <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>
	 <1274860275.3658.0.camel@jlt3.sipsolutions.net>
	 <4C000B68.9000305@gmail.com>  <1275416907.3778.11.camel@maxim-laptop>
	 <1275419973.3634.7.camel@jlt3.sipsolutions.net>
	 <1275421989.2574.12.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 22:06:43 +0200
Message-ID: <1275422803.3634.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-01 at 22:53 +0300, Maxim Levitsky wrote:

> > This won't quite work. monitor interfaces are always slaves in the sense
> > that their channel setting never takes precedence over anything, so if
> > you add another interface and do something there, the hardware will
> > happily channel switch away from the monitor channel, but it will still
> > report the old channel here that you set.
> > 
> > I have no idea how to _properly_ fix this though, since eventually we'll
> > have a situation where you can have multiple interfaces active on
> > different channels, so that monitors don't have a fixed channel anyway.
> > 
> > Maybe this patch is sufficient since it works in the case people care
> > about when they _only_ have a monitor interface, but I think it'd be
> > nicer if it wouldn't report anything in the other cases.
> 
> Why?
> 
> We don't have any wireless devices that actually support using 2
> channels independently.

ath9k already supports this with its virtual wiphy concept, and that
will be moved in the medium term to do channel switching between
multiple virtual interfaces. It's perfectly possible to do this with two
station interfaces, for instance, since you can pretend to be in
powersave while you go to the other channel. So we actually _do_ have
devices that support multiple channels independently, just not the way
you think of it.

> Therefore user should be aware that if he sets channel on one interface,
> and then on other, the last setting matters.

Like I said, this is not true.

> Of course the right fix would to make channel a global property of card
> rather that of interface.

No, see above ... my recent patches have moved exactly in the other
direction for this reason!

However, This obviously only works for certain special cases like 2
stations. Monitor interfaces are sort of a second class citizen, if you
have two stations on different channels and add a monitor interface, its
channel setting won't matter at all.

However, in that case, when you set a channel on the monitor interface,
with this patch it will report that channel, irregardless of what
channel it is currently on. And if you have 2 channel switching station
mode interfaces, there's no sensible channel to report at all.

Again however though, very likely you don't care about that situation.
But I still think we shouldn't report a bogus channel then. So maybe in
that situation we should just fall back to reporting nothing, i.e.
return -EINVAL?

johannes

