Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20721 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003AbZAPVJ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 16:09:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 13:09:59 -0800
Date: Fri, 16 Jan 2009 13:09:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/13] cfg80211: only export disable flag on channel
	disablement
Message-ID: <20090116210930.GL29609@tesla> (sfid-20090116_221006_106406_2615236E)
References: <1232064746-17134-2-git-send-email-lrodriguez@atheros.com> <1232064746-17134-3-git-send-email-lrodriguez@atheros.com> <1232064746-17134-4-git-send-email-lrodriguez@atheros.com> <1232064746-17134-5-git-send-email-lrodriguez@atheros.com> <1232064746-17134-6-git-send-email-lrodriguez@atheros.com> <1232064746-17134-7-git-send-email-lrodriguez@atheros.com> <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> <1232097827.3854.25.camel@johannes> <20090116163245.GF29609@tesla> <1232138101.3745.7.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232138101.3745.7.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 12:35:01PM -0800, Johannes Berg wrote:
> On Fri, 2009-01-16 at 08:32 -0800, Luis R. Rodriguez wrote:
> 
> > > > -	chan->flags = flags | map_regdom_flags(reg_rule->flags);
> > > > +	rule_flags = map_regdom_flags(reg_rule->flags);
> > > > +	if (flags & IEEE80211_CHAN_DISABLED)
> > > > +		chan->flags = IEEE80211_CHAN_DISABLED;
> > > > +	else
> > > > +		chan->flags = flags | rule_flags;
> > > 
> > > but why bother with more complicated code when adding a few more flags
> > > doesn't hurt?
> > 
> > I don't see these few lines as complicated really, but if you don't like them
> > that's fine. We can also fix this in userspace so that disable|radar|no-ibss
> > doesn't show up. I frankly think its pointless to keep them though.
> 
> It's not exactly complicated, but I bet at some point we'll scratch our
> heads why we did it ;)

I can put a note, if that helps, or are you strongly opposed to this? :)
Just an itch to scratch really, have you seen the output of iwlist on
disabled channels? It can get long on radar/no-ibss channels. We can also
handle this in userspace but seems pointles if the channels is disabled.

  Luis
