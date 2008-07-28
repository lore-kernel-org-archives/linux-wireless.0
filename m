Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbYG1QZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 12:25:00 -0400
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807280858o4020fec8k4c287567dff177ca@mail.gmail.com>
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de> <1217253397.6364.2.camel@localhost>
	 <200807281600.39103.mb@bu3sch.de>
	 <1217257174.28198.27.camel@localhost.localdomain>
	 <1217257628.15381.2.camel@johannes.berg>
	 <1217258040.28198.40.camel@localhost.localdomain>
	 <1ba2fa240807280858o4020fec8k4c287567dff177ca@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 12:22:38 -0400
Message-Id: <1217262158.28198.44.camel@localhost.localdomain> (sfid-20080728_182503_722483_E730663D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-28 at 18:58 +0300, Tomas Winkler wrote:
> On Mon, Jul 28, 2008 at 6:14 PM, Dan Williams <dcbw@redhat.com> wrote:
> > On Mon, 2008-07-28 at 17:07 +0200, Johannes Berg wrote:
> >> On Mon, 2008-07-28 at 10:59 -0400, Dan Williams wrote:
> >>
> >> > > If that's really a problem, yes. 01:00:00:00:00:00 is still better
> >> > > than a pseudo random MAC, IMO. It's immediately obvious to the user
> >> > > that the MAC currently is not set.
> >> >
> >> > How about 44:44:44:44:44:44 like orinoco uses for bogus BSSID?  If we
> >> > can, let's not keep creating yet more bogus MAC addresses.
> >>
> >> Either way, the problem is that these will confuse udev if you have two
> >> at the same time, no?
> >
> > the udev script I attached from Fedora 9 already ignores devices with
> > 00:00:00::: so I don't think we'd have a problem with that.  Screw the
> > Xerox thing, all zeros is just bogus and tons of stuff treats it that
> > way already.
> 
> So this won't conflict even if you have two or more devices that
> claims zero mac address?

Well, sane udev persistent name rules should be ignoring invalid MAC
addresses, and right now they just happen to ignore 00:00:00::: already
anyway.  Apparently the one I posted also handles the MAC changing later
and does the right thing.

So if you have two cards with the same MAC, they'll still get different
netdevs, just if they are both 00:00:00::: this udev script I posted
won't try to rename them at all, so everything is fine.

If you have two cards with the same MAC that's _valid_, then stuff gets
screwed up (*cough* libertas + mesh *cough*) but that's not our problem.

Dan


