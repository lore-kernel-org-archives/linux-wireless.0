Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47335 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZHZQ3k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 12:29:40 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 09:29:43 -0700
Date: Wed, 26 Aug 2009 09:29:41 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
Message-ID: <20090826162941.GA4417@mosca>
References: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
 <b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
 <20090825185842.GA7357@mosca>
 <b6c5339f0908251222h5fb281c3vf3ecea8b27eb02ed@mail.gmail.com>
 <20090825233827.GA10998@mosca>
 <b6c5339f0908260708l38208046o43330d9eda808b1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b6c5339f0908260708l38208046o43330d9eda808b1e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 07:08:55AM -0700, Bob Copeland wrote:
> On Tue, Aug 25, 2009 at 7:38 PM, Luis R. Rodriguez<lrodriguez@atheros.com>
> > First thing I saw upon a quick review was we were relying on our own
> > curband for RX instead of the cfg80211 hw->conf band. Now granted
> > that *may* be updated properly, and it seems that may be the case,
> 
> Looks good at first glance, except it conflicts with changes I
> recently posted.  I'm all for getting rid of driver copies of stuff
> in the stack.

I can rebase.

> > -       /* NB: setup here so ath5k_rate_update is happy */
> > -       if (test_bit(AR5K_MODE_11A, ah->ah_modes))
> > -               ath5k_setcurmode(sc, AR5K_MODE_11A);
> > -       else
> > -               ath5k_setcurmode(sc, AR5K_MODE_11B);
> > -
> 
> I take it ath5k_rate_update didn't really care?

Well I nuked ath5k_setcurmode() and didn't see anything relying on that
stuff.

> >  ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
> >  {
> >        ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz)\n",
> > -               sc->curchan->center_freq, chan->center_freq);
> > +               sc->hw->conf.channel->center_freq, chan->center_freq);
> 
> So, does hw->conf.channel change before we're told to change channel,
> or after?

Oh bummer, good thing you asked as I simply assumed it would be set *after*.
Turns out its done prior to the drv_config() call.

        if (chan != local->hw.conf.channel ||
            channel_type != local->hw.conf.channel_type) {
                local->hw.conf.channel = chan;
                local->hw.conf.channel_type = channel_type;
                changed |= IEEE80211_CONF_CHANGE_CHANNEL;
        }

	...

        if (changed && local->open_count) {
                ret = drv_config(local, changed);
		...
	}

I suppose we can just remove that printk ? :)

> > -       if (chan) {
> > -               ath5k_hw_set_imr(ah, 0);
> > -               ath5k_txq_cleanup(sc);
> > -               ath5k_rx_stop(sc);
> > -
> > -               sc->curchan = chan;
> > -               sc->curband = &sc->sbands[chan->band];
> > -       }
> 
> Unless I missed something I think we still want:
> 
>     if (chan_change)
>         ath5k_chan_set(...);

Not sure I follow. Let me explain the logic here a little better.
ath5k_reset() had a check to see if we switched channels. The check
is above, and I moved it ath5k_chan_set() called by the config callback.
Reason for this is channel change *only* occurs through the config callback
so we can be certain no other path will call reset with a channel change
request.

> > -       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
> > +       ret = ath5k_hw_reset(ah, sc->opmode, chan, chan_change);
> 
> There's just no synchronization of this stuff, not too surprising there
> are races.

config calls for reset seem to be with sc->lock. ath9k uses a mutex to
protect races between mac80211 callback calls, ath5k seems to use the
sc->lock *sometimes*, a good review of that may help but for channel
change this seems protected unless I missed something. Since channel
change goes through the config callback and since the callback protects
through sc->lock I can't see how we'd race against changing channels.

  Luis
