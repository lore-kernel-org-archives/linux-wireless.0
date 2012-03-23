Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2CWJ0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 05:26:49 -0400
Message-ID: <1332494807.3506.22.camel@jlt3.sipsolutions.net> (sfid-20120323_102653_611488_9D030C71)
Subject: Re: [RFC 12/12] mac80211: return NULL from get_channel in
 multi-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82?= Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Mar 2012 10:26:47 +0100
In-Reply-To: <4F6C4034.4050802@tieto.com>
References: <892b9fb4-fb69-486f-b619-85d6336e5a31@FIVLA-EXHUB02.eu.tieto.com>
		 (sfid-20120320_155530_182045_07E4AF64) <1332492860.3506.8.camel@jlt3.sipsolutions.net>
	 <4F6C4034.4050802@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-23 at 10:19 +0100, Michał Kazior wrote:
> Johannes Berg wrote:
> > On Mon, 2012-03-19 at 13:57 +0100, Michal Kazior wrote:
> >> According to comment on cfg80211_ops/get_channel we should return NULL
> >> in case of concurrent multi-channel.
> >>
> >> Signed-off-by: Michal Kazior<michal.kazior@tieto.com>
> >> ---
> >>   net/mac80211/cfg.c |    3 +++
> >>   1 files changed, 3 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> >> index 88cc128..05f7022 100644
> >> --- a/net/mac80211/cfg.c
> >> +++ b/net/mac80211/cfg.c
> >> @@ -2680,6 +2680,9 @@ ieee80211_wiphy_get_channel(struct wiphy *wiphy)
> >>   	struct ieee80211_local *local = wiphy_priv(wiphy);
> >>   	struct ieee80211_channel_state *chan_state =&local->chan_state;
> >>
> >> +	if (local->hw.flags&  IEEE80211_HW_SUPPORTS_MULTI_CHANNEL)
> >> +		return NULL;
> >> +
> >
> > We should return NULL if we're actually using multiple channels :-)
> >
> > So clearly we need mac80211 do more work in tracking which channels are
> > used, compatible, etc.
> 
> Oh. So will it be enough to iterate through the interfaces that are up 
> and check if they have different operational channels?

Technically, yes. But again, I think we need to take a more involved
channel management approach in mac80211, managing compatible channels
etc.

You've also completely ignored the need to tell userspace about what
exactly the hardware supports, which was part of the original design of
the multi-vif feature listing.

But when you think about that, you'll soon notice that this minimal
approach won't work, what for example if a third interface gets added?
With this approach you won't even know if it's on a third channel or
not. Keep in mind that the driver only has limited ways of rejecting
such configuration.


(And as an aside that just crossed my mind: there's also the CSA
handling, but I'm happy to mostly ignore that for now too -- we'll have
to come up with a solution later.)

johannes

