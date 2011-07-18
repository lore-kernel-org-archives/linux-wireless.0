Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1GRHe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 03:34:29 -0400
Subject: Re: [PATCH 1/5] mac80211: give if_mesh a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAG6hwVOVJGBF87jqY-K4xnjDWcVD-RTYXfV-N9=T-5Ty1U2TdQ@mail.gmail.com> (sfid-20110717_193702_895186_F8D25DFA)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-2-git-send-email-thomas@cozybit.com>
	 <1310723669.4164.18.camel@jlt3.sipsolutions.net>
	 <CAG6hwVONFH+vkSasF7AaSaqvHK78wwNtZesi0RSUnuCi17d9Fw@mail.gmail.com>
	 <1310763624.4164.29.camel@jlt3.sipsolutions.net>
	 <CAG6hwVOVJGBF87jqY-K4xnjDWcVD-RTYXfV-N9=T-5Ty1U2TdQ@mail.gmail.com>
	 (sfid-20110717_193702_895186_F8D25DFA)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 09:34:24 +0200
Message-ID: <1310974464.3942.1.camel@jlt3.sipsolutions.net> (sfid-20110718_093432_150861_352ECF48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-07-17 at 12:36 -0500, Thomas Pedersen wrote:

> >> > Also ... since you'll need PS support eventually anyway, maybe you
> >> > should refactor "struct ieee80211_if_ap" into something AP-specific
> >> > (currently only VLANs) and the rest, and then use "the rest" in mesh as
> >> > well to make all this code more unified.
> >>
> >> I like this approach much better. Are you suggesting just factoring
> >> out the PS data, or taking it further and creating a generic "if which
> >> beacons"?
> >
> > Well, I don't think "iface which beacons" is really what we need here --
> > IBSS sends beacons as well but we don't really have PS support there and
> > it'd be different anyway. But on the other hand, if you also factor out
> > the beacon pointer, you can embed that into both. Like I said, I think
> > from struct ..._if_ap you only have the vlan list that you don't want?
> 
> I'd rather just factor all the PS data out for now, and maintain the
> beacon separately. Is there Is there any good reason we'd want to lump
> these two together? ieee80211_beacon_add_tim() for example already
> treats these as separate.

No that's fine, I see no particular reason to do one or the other. Or
maybe actually I do -- beacon handling requires TX PS handling for the
TIM IE?

johannes

