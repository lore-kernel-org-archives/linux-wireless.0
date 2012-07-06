Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab2GFHel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 03:34:41 -0400
Message-ID: <1341560078.4462.11.camel@jlt3.sipsolutions.net> (sfid-20120706_093446_334751_3200C42E)
Subject: Re: [RFC 2/4] cfg80211: support unused HT-cap-per-band configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2012 09:34:38 +0200
In-Reply-To: <CA+XVXff3_ugusQ=HPVeg3YSp3OBjWwpCVHTxd+Tnxg5Rf_5W3w@mail.gmail.com> (sfid-20120706_093100_730065_1B87DFED)
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
	 <1341417530-9062-3-git-send-email-arik@wizery.com>
	 <1341473996.4455.2.camel@jlt3.sipsolutions.net>
	 <CA+XVXfdwGAdxdmZTx+4pC4=6agM0SuvHV_xsF0gGCE_5NMB7YA@mail.gmail.com>
	 <1341557988.4462.6.camel@jlt3.sipsolutions.net>
	 <CA+XVXff3_ugusQ=HPVeg3YSp3OBjWwpCVHTxd+Tnxg5Rf_5W3w@mail.gmail.com>
	 (sfid-20120706_093100_730065_1B87DFED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-06 at 10:30 +0300, Arik Nemtsov wrote:

> >> Also putting ht_cap_invalid inside the struct creates strange corner
> >> cases. One could mark the vif ht_cap as invalid as well, but the code
> >> would just ignore it.
> >
> > Good point. But then let's just move it out and change drivers ...
> > that's much cleaner I think.
> 
> You mean move out ht_supported?

Yeah, I think that'd make more sense? Have it in the sband directly.


> >> >> @@ -30,13 +31,16 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
> >> >>                chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
> >> >>               return NULL;
> >> >>
> >> >> -     ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
> >> >> +     sband = rdev->wiphy.bands[chan->band];
> >> >> +     ht_cap = &sband->ht_cap;
> >> >>
> >> >>       if (channel_type != NL80211_CHAN_NO_HT) {
> >> >> -             if (!ht_cap->ht_supported)
> >> >> +             if (!sband->ht_supported)
> >> >>                       return NULL;
> >> >>
> >> >> -             if (channel_type != NL80211_CHAN_HT20 &&
> >> >> +             /* this check is ignored when per-band HT caps are not used */
> >> >> +             if (!sband->ht_cap_invalid &&
> >> >> +                 channel_type != NL80211_CHAN_HT20 &&
> >> >
> >> > This is also major confusion, it seems you should roll 2/3 into one
> >> > patch?
> >>
> >> I'm not sure that would help. rdev_freq_to_chan doesn't get the
> >> net_device, so it can't get the HT caps. I guess I can add the
> >> net_device as an optional argument where it is used and check the
> >> caps. OTOH it seem like a sanity check we can do without?
> >
> > I don't think we should do without that check? If you request say AP
> > operation on 40 MHz then you absolutely rely on that happening or
> > returning an error, not randomly operating in legacy mode!
> 
> Sure. I'll send the netdev to the function where possible (I think
> everywhere except the virtual monitor).

I think the function should restrict to NO_HT in case it doesn't have
caps, otherwise it can't properly restrict. I suppose that means you
won't be able to do HT monitoring with your device, but I can live with
that.

johannes

