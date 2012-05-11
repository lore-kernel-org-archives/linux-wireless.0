Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33128 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760632Ab2EKTPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 15:15:39 -0400
Message-ID: <1336763738.8739.5.camel@jlt3.sipsolutions.net> (sfid-20120511_211550_512342_42D00C99)
Subject: Re: [RFC 1/3] cfg80211: provide channel to join_mesh function
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Date: Fri, 11 May 2012 21:15:38 +0200
In-Reply-To: <CAG6hwVPgTOc_VtE2NaNcOTh6xTn_zBso7UOoN=_Tn4M7asG3dA@mail.gmail.com> (sfid-20120511_211142_933904_6314CEC0)
References: <20120511180817.974687689@sipsolutions.net>
	 <20120511181044.806226449@sipsolutions.net>
	 <CAG6hwVPgTOc_VtE2NaNcOTh6xTn_zBso7UOoN=_Tn4M7asG3dA@mail.gmail.com>
	 (sfid-20120511_211142_933904_6314CEC0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-11 at 12:10 -0700, Thomas Pedersen wrote:

> > +       if (!setup->channel) {
> > +               /* if we don't have that either, use the first usable channel */
> > +               enum ieee80211_band band;
> > +
> > +               for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> > +                       struct ieee80211_supported_band *sband;
> > +                       struct ieee80211_channel *chan;
> > +                       int i;
> > +
> > +                       sband = rdev->wiphy.bands[band];
> > +                       if (!sband)
> > +                               continue;
> > +
> > +                       for (i = 0; i < sband->n_channels; i++) {
> > +                               chan = &sband->channels[i];
> > +                               if (chan->flags & (IEEE80211_CHAN_NO_IBSS |
> > +                                                  IEEE80211_CHAN_PASSIVE_SCAN |
> > +                                                  IEEE80211_CHAN_DISABLED |
> > +                                                  IEEE80211_CHAN_RADAR))
> > +                                       continue;
> > +                               setup->channel = chan;
> > +                               break;
> > +                       }
> > +
> > +                       if (setup->channel)
> > +                               break;
> > +               }
> > +
> > +               /* no usable channel ... */
> > +               if (!setup->channel)
> > +                       return -EINVAL;
> > +
> > +               setup->channel_type = NL80211_CHAN_NO_HT;
> 
> Can we make the default channel type HT20 if the band supports it? The
> HT mixed-mode protection implementation in mesh currently only
> considers mesh peers, so maybe this isn't acceptable, but it would be
> nice.

I can't say I care. I even considered just removing this code, but I
suspect that somebody might try to join a mesh without ever setting any
channel, and mac80211 would assign one (essentially at random.)

johannes

