Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:51192 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbZHZOIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 10:08:54 -0400
Received: by vws33 with SMTP id 33so132023vws.33
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 07:08:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090825233827.GA10998@mosca>
References: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
	 <b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
	 <20090825185842.GA7357@mosca>
	 <b6c5339f0908251222h5fb281c3vf3ecea8b27eb02ed@mail.gmail.com>
	 <20090825233827.GA10998@mosca>
Date: Wed, 26 Aug 2009 10:08:55 -0400
Message-ID: <b6c5339f0908260708l38208046o43330d9eda808b1e@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 7:38 PM, Luis R. Rodriguez<lrodriguez@atheros.com>
> First thing I saw upon a quick review was we were relying on our own
> curband for RX instead of the cfg80211 hw->conf band. Now granted
> that *may* be updated properly, and it seems that may be the case,

Looks good at first glance, except it conflicts with changes I
recently posted.  I'm all for getting rid of driver copies of stuff
in the stack.

> -       /* NB: setup here so ath5k_rate_update is happy */
> -       if (test_bit(AR5K_MODE_11A, ah->ah_modes))
> -               ath5k_setcurmode(sc, AR5K_MODE_11A);
> -       else
> -               ath5k_setcurmode(sc, AR5K_MODE_11B);
> -

I take it ath5k_rate_update didn't really care?

>  ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
>  {
>        ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz)\n",
> -               sc->curchan->center_freq, chan->center_freq);
> +               sc->hw->conf.channel->center_freq, chan->center_freq);

So, does hw->conf.channel change before we're told to change channel,
or after?

> -       if (chan) {
> -               ath5k_hw_set_imr(ah, 0);
> -               ath5k_txq_cleanup(sc);
> -               ath5k_rx_stop(sc);
> -
> -               sc->curchan = chan;
> -               sc->curband = &sc->sbands[chan->band];
> -       }

Unless I missed something I think we still want:

    if (chan_change)
        ath5k_chan_set(...);

> -       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
> +       ret = ath5k_hw_reset(ah, sc->opmode, chan, chan_change);

There's just no synchronization of this stuff, not too surprising there
are races.

-- 
Bob Copeland %% www.bobcopeland.com
