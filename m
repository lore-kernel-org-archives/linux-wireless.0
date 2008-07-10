Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:36586 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYGJT6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 15:58:18 -0400
Date: Thu, 10 Jul 2008 15:58:14 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] Add new regulatory framework for Linux wireless
Message-ID: <20080710195814.GO17936@ruslug.rutgers.edu> (sfid-20080710_215821_874305_58AFD72F)
References: <20080710152415.GK17936@ruslug.rutgers.edu> <1215706960.3483.37.camel@johannes.berg> <20080710193402.GL17936@ruslug.rutgers.edu> <1215718708.3483.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1215718708.3483.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 09:38:28PM +0200, Johannes Berg wrote:
> 
> > Its just a random number we use as a receipt. I was thinking of
> > having it to provide uniqueness on requests and to provide a cookie
> > to ensure it comes from the kernel but now that I think about this
> > a bit more its really unnecessary. 
> 
> > If we keep UUID we can remove the alpha2, you're right. But it seems
> > we may rather keep the alpha2 and just nuke the UUID.
> 
> ok, makes sense to me, yes.

Alright, death to UUID then.

> > > > +	reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] = {
> > > > +	[NL80211_ATTR_REG_RULE_FLAGS]		= { .type = NLA_U32 },
> > > 
> > > I thought we agreed to use actual NLA flags for the flags, in a nested
> > > attribute, instead of using bitmaps.
> > 
> > I forgot if we did. If we keep them as they are we can actually end
> > up using them to replace the channel flags themselves with these
> > though. What do you think? Also if we do use a nested attribut for
> > the flags what would be the benefit?
> 
> Mostly we wouldn't need to care about any space concerns like adding a
> "FLAGS2" attribute if we run out of the 32 bits we have there. I don't
> feel strongly, but it seems to me that using NLA flags is more natural
> in netlink and makes the separation clearer. Maybe.

I'll give it a shot then, but I'll leave it for last. So we'll end
up with two separate flags if we do this then -- one for the
channels for the wiphy and one for the channels as per regulatory.

Hm.

> > > > +/**
> > > > + * regulatory_hint - hint to wireless core a regulatory domain
> > > > + * @alpha2: the ISO-3166 alpha2 the driver thinks we're on
> > > > + * @wiphy: the driver's very own &struct wiphy
> > > > + *
> > > > + * Wireles drivers can use this function to hint to the wireles core
> > > 
> > > type in both instances :)
> > 
> > Hm? I don't get it.
> 
> Sorry, made a typo myself. typ_o_, not typ_e_. you wrote "wireles".

Danke.

> > > > +static int is_an_alpha2(char *alpha2)
> > > > +{
> > > > +	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
> > > > +		return 1;
> > > > +	return 0;
> > > 
> > > Why's that so important?
> > 
> > Its not, but we should want to pick one or the other to use. I
> > picked alpha_upper. Have some other ideas?
> 
> I'm just wondering whether we care at all. If userspace wants to call it
> "de" when we requested "DE", what do we care? OTOH, since we match this
> against 11d info I guess we do have to pick one or the other.

I do have to check whether the spec says "use upper" or not, I don't
recall. I just figured -- since we are calling userspace then well
we should expect userspace to give us the same chars back.

  Luis
