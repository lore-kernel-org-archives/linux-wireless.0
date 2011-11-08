Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1KHSA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 13:00:56 -0500
Subject: Re: [PATCH v6 1/2] wireless:  Support ht-capabilities over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB96A5C.8040606@candelatech.com>
References: <1320707676-17255-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_001449_233997_95FF19FA) <1320740099.4304.5.camel@jlt3.sipsolutions.net>
	 <4EB96A5C.8040606@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 19:00:51 +0100
Message-ID: <1320775251.24797.31.camel@jlt3.sipsolutions.net> (sfid-20111108_190059_779636_D3937BE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 09:43 -0800, Ben Greear wrote:

> >> +/*  Do a logical ht_capa&= ht_capa_mask.  */
> >> +static void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
> >> +			const struct ieee80211_ht_cap *ht_capa_mask)

> > I think you also need to call this in the cfg80211_connect() path.
> 
> I'll double check that...for some reason I thought everything
> eventually went through this code path.

Not for full-mac drivers, e.g. iwm.

> > Also, maybe we should reject this configuration if the device didn't
> > support it at all, ie. ht_capa_mask was NULL? It also seems a bit odd to
> > allow this on a device that doesn't even support HT.
> 
> I really don't like that.  It would mean that supplicant will
> have to selectively not add certain netlink attributes based on the
> driver and/or kernel version.  That means either probing
> to determine what the phy supports (and returning errors on
> up to user if they configure it for something not supported?)
> or just forcing the user to make all the decisions when writing
> the supplicant config file.
> 
> The truth is, my app auto-generates the supplicant config files,
> and I know what wifi driver I'm using etc, so it would be easy enough
> for me to live with this.  But, it seems like it will make life
> painful for anyone with less knowledge of the system.
> 
> > Also how would you feel about rejecting, instead of silently ignoring,
> > things that we do look at but don't support, e.g. a wrong A-MSDU
> > setting? Alternatively, cfg80211 could modify the settings in a way that
> > drivers don't have to worry about the "downgrade only" part.
> 
> I dislike that as well, for similar reasons.  Getting an -EINVAL back
> from a netlink call gives very little info to the user anyway...who
> knows what exactly was invalid?  Perhaps a printk warning coming out
> of mac80211 when it checks for the restrictions against what the
> driver supports would be more useful?

Fair enough. I think what I'm really after is having a way to know wtf
we're using when you requested something. That would probably be more
useful overall.

FWIW, I did talk to some people at the kernel summit about the -EINVAL
thing and maybe there's an idea to send back the invalid attribute at
least, but doesn't really matter here. I'm OK with just allowing it all
since it's not going to be used a lot anyway.

> > Finally, I think we need a tad more documentation about how this is
> > supposed to work in case somebody wants to implement it on non-mac80211.
> > The way it's done right now it seems fairly error prone, with all
> > restrictions that the driver needs to implement like not allowing the
> > a-MSDU size to be increased.
> 
> Well, who knows...in their driver maybe the restrictions are not
> the same.  I think that adding more info about what fields are
> currently supported for mac80211 might be useful, but trying to
> generalize restrictions for drivers that have not even implemented
> any of this seems like useless overhead.

Well, it goes both ways though, having more validation up front will
make it a lot easier for new drivers to implement it because they don't
have to bother with the validation, and I really don't see any way that
a driver might allow making the a-MPDU spacing *smaller*, if it could
deal with smaller it'd advertise that to start with.

OTOH, if you request a connect(), you don't even know the band and
technically a driver could have different capabilities on different
bands.

johannes

