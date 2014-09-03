Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34473 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbaICTMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:12:21 -0400
Message-ID: <1409771537.911.28.camel@jlt4.sipsolutions.net> (sfid-20140903_211225_480424_90924BC2)
Subject: Re: [PATCH v5 2/2] mac80211: support DTPC IE (from Cisco Client
 eXtensions)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Sep 2014 21:12:17 +0200
In-Reply-To: <20140903133328.GC18933@sesse.net> (sfid-20140903_153336_782556_14E19EF4)
References: <20140830184516.GA31497@sesse.net>
	 <E1XONJB-0005LB-O8@pannekake.samfundet.no>
	 <1409745636.911.13.camel@jlt4.sipsolutions.net>
	 <20140903133328.GC18933@sesse.net> (sfid-20140903_153336_782556_14E19EF4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-03 at 15:33 +0200, Steinar H. Gunderson wrote:
> On Wed, Sep 03, 2014 at 02:00:36PM +0200, Johannes Berg wrote:
> > I think for some vendors shipping our stack this might become
> > problematic. I think it would make sense to have a Kconfig option for
> > this, probably hidden away under "if EXPERT" and defaulting to yes, to
> > enable this code, it might be something that interferes with more CCX
> > implementations maybe?
> 
> Are there any CCX implementations for Linux at this time? Could you even do
> that from just userspace? (I sort of doubt it, but it's never easy to know
> what illustrious userspace programmers can do :-) )

I have no idea :-)

> I can make a config option, but it seems a bit odd, maybe. Are you thinking
> there would be problems since this is an undocumented protocol, or because of
> the possible conflict?

I'm just thinking it might be a problem for a vendor to ship an
(obviously incomplete) CCX implementation, even without advertising
such. Most vendors have some relationship with Cisco at least for other
drivers, so I'd prefer to avoid any possible conflict. You could argue
that we shouldn't care upstream, and I'm not really sure where I fall on
that question - it seems that vendors might then decide to patch it out
though (which would be easy enough to do as well.)

> >> +static bool ieee80211_find_cisco_dtpc(struct ieee80211_sub_if_data
> >> *sdata,
> > The return value is useless here, so it could be void?
> 
> It is useless indeed; I kept it this way for symmetry with the other _find_
> function and because it makes for slightly easier code around (you can set
> has_cisco_pwr = directly without needing an additional statement to make it
> true). But I've changed it so it's void.
> 
> I could also change it to use a return instead of an output parameter for
> pwr_level_cisco if you want, but I think it might become a bit confusing to
> have two so similar functions with different calling style.

Right, that makes sense.

> >> +                       if (pos[0] != 0x00 || pos[1] != 0x40 ||
> >> +                           pos[2] != 0x96 || pos[3] != 0x00) {
> >> +                               break;
> >> +                       }
> > Please remove those useless braces - maybe run ./scripts/checkpatch.pl?
> 
> Removed. But I've already run checkpatch and it didn't complain about this
> (the patch set is checkpatch-clean).

Hmmm, interesting. I thought it warned about that, oh well. Thanks :)

> I'm in a hotel room in Seattle right now whose Wi-Fi is not Cisco-based,
> so I can't test the new version as thoroughly as I'd like, but I'll at least
> give it a boot test and then send an updated patch series as reply to this
> message.

Great, thanks. Safe travels then :-)

It's getting late here, but I'll take a look tomorrow. Regarding the
Kconfig question, I'll make up my mind and just do whichever option I
decide for myself, if that's OK with you?

johannes

