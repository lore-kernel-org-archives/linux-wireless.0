Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2GFG7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 02:59:52 -0400
Message-ID: <1341557988.4462.6.camel@jlt3.sipsolutions.net> (sfid-20120706_085956_336969_930CC499)
Subject: Re: [RFC 2/4] cfg80211: support unused HT-cap-per-band configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2012 08:59:48 +0200
In-Reply-To: <CA+XVXfdwGAdxdmZTx+4pC4=6agM0SuvHV_xsF0gGCE_5NMB7YA@mail.gmail.com> (sfid-20120705_132546_765088_3B704243)
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
	 <1341417530-9062-3-git-send-email-arik@wizery.com>
	 <1341473996.4455.2.camel@jlt3.sipsolutions.net>
	 <CA+XVXfdwGAdxdmZTx+4pC4=6agM0SuvHV_xsF0gGCE_5NMB7YA@mail.gmail.com>
	 (sfid-20120705_132546_765088_3B704243)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-05 at 14:25 +0300, Arik Nemtsov wrote:

> > Yuck. Why use the union at all? You could just put the ht_cap_invalid
> > into the ht_cap struct, and it wouldn't even take space, there's
> > padding :-)
> 
> The point is - we still want to use ht_cap.ht_supported, even when
> ht_cap is invalid. I was afraid there would be some confusion, hence
> one can set:
> band.ht_supported = true;
> band.ht_cap_invalid = false;
> 
> And the union means we don't have to change old drivers.
> 
> Also putting ht_cap_invalid inside the struct creates strange corner
> cases. One could mark the vif ht_cap as invalid as well, but the code
> would just ignore it.

Good point. But then let's just move it out and change drivers ...
that's much cleaner I think.


> >> @@ -30,13 +31,16 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
> >>                chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
> >>               return NULL;
> >>
> >> -     ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
> >> +     sband = rdev->wiphy.bands[chan->band];
> >> +     ht_cap = &sband->ht_cap;
> >>
> >>       if (channel_type != NL80211_CHAN_NO_HT) {
> >> -             if (!ht_cap->ht_supported)
> >> +             if (!sband->ht_supported)
> >>                       return NULL;
> >>
> >> -             if (channel_type != NL80211_CHAN_HT20 &&
> >> +             /* this check is ignored when per-band HT caps are not used */
> >> +             if (!sband->ht_cap_invalid &&
> >> +                 channel_type != NL80211_CHAN_HT20 &&
> >
> > This is also major confusion, it seems you should roll 2/3 into one
> > patch?
> 
> I'm not sure that would help. rdev_freq_to_chan doesn't get the
> net_device, so it can't get the HT caps. I guess I can add the
> net_device as an optional argument where it is used and check the
> caps. OTOH it seem like a sanity check we can do without?

I don't think we should do without that check? If you request say AP
operation on 40 MHz then you absolutely rely on that happening or
returning an error, not randomly operating in legacy mode!

johannes

