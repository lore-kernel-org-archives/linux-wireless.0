Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47068 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727AbZAPQdO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:33:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:33:14 -0800
Date: Fri, 16 Jan 2009 08:32:45 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/13] cfg80211: only export disable flag on channel
	disablement
Message-ID: <20090116163245.GF29609@tesla> (sfid-20090116_173319_950679_F7653420)
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com> <1232064746-17134-2-git-send-email-lrodriguez@atheros.com> <1232064746-17134-3-git-send-email-lrodriguez@atheros.com> <1232064746-17134-4-git-send-email-lrodriguez@atheros.com> <1232064746-17134-5-git-send-email-lrodriguez@atheros.com> <1232064746-17134-6-git-send-email-lrodriguez@atheros.com> <1232064746-17134-7-git-send-email-lrodriguez@atheros.com> <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> <1232097827.3854.25.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232097827.3854.25.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 01:23:47AM -0800, Johannes Berg wrote:
> On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> > When a channel is disabled there is no need to stuff it
> > with more flags.
> 
> > -	u32 flags;
> > +	u32 flags, rule_flags;
> >  	u32 max_bandwidth = 0;
> >  	const struct ieee80211_reg_rule *reg_rule = NULL;
> >  	const struct ieee80211_power_rule *power_rule = NULL;
> > @@ -913,15 +913,19 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
> >  					"Country IE\n",
> >  					chan->center_freq, wiphy_name(wiphy));
> >  #endif
> > -			flags |= IEEE80211_CHAN_DISABLED;
> > -			chan->flags = flags;
> > +			chan->flags = IEEE80211_CHAN_DISABLED;
> >  		}
> >  		return;
> >  	}
> >  
> >  	power_rule = &reg_rule->power_rule;
> >  
> > -	chan->flags = flags | map_regdom_flags(reg_rule->flags);
> > +	rule_flags = map_regdom_flags(reg_rule->flags);
> > +	if (flags & IEEE80211_CHAN_DISABLED)
> > +		chan->flags = IEEE80211_CHAN_DISABLED;
> > +	else
> > +		chan->flags = flags | rule_flags;
> 
> but why bother with more complicated code when adding a few more flags
> doesn't hurt?

I don't see these few lines as complicated really, but if you don't like them
that's fine. We can also fix this in userspace so that disable|radar|no-ibss
doesn't show up. I frankly think its pointless to keep them though.

  Luis
