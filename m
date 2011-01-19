Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54229 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1ASP4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 10:56:36 -0500
Received: by pva4 with SMTP id 4so172180pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 07:56:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092108.19628.43971.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092108.19628.43971.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 17:56:36 +0200
Message-ID: <AANLkTikOXqGhViqPkh7jssMUVGGDe+Xa38H0JuMJgTLC@mail.gmail.com>
Subject: Re: [PATCH 7/8] ath5k: Remove unused sc->curmode
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/19 Bruno Randolf <br1@einfach.org>:
> sc->curmode is set but never used. Remove it and the helper function. Also the
> ath5k_rate_update which is refered to in the comment does not exist (any more?)
> so we don't need to setup the band in that place.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   18 ------------------
>  drivers/net/wireless/ath/ath5k/base.h |    1 -
>  2 files changed, 0 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 6900543..a00cc11 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -439,18 +439,6 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
>        return ath5k_reset(sc, chan, true);
>  }
>
> -static void
> -ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
> -{
> -       sc->curmode = mode;
> -
> -       if (mode == AR5K_MODE_11A) {
> -               sc->curband = &sc->sbands[IEEE80211_BAND_5GHZ];
> -       } else {
> -               sc->curband = &sc->sbands[IEEE80211_BAND_2GHZ];
> -       }
> -}
> -
>  struct ath_vif_iter_data {
>        const u8        *hw_macaddr;
>        u8              mask[ETH_ALEN];
> @@ -2776,12 +2764,6 @@ ath5k_init(struct ieee80211_hw *hw)
>                goto err;
>        }
>
> -       /* NB: setup here so ath5k_rate_update is happy */
> -       if (test_bit(AR5K_MODE_11A, ah->ah_modes))
> -               ath5k_setcurmode(sc, AR5K_MODE_11A);
> -       else
> -               ath5k_setcurmode(sc, AR5K_MODE_11B);
> -
>        /*
>         * Allocate tx+rx descriptors and populate the lists.
>         */
> diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
> index 6d51147..58660e4 100644
> --- a/drivers/net/wireless/ath/ath5k/base.h
> +++ b/drivers/net/wireless/ath/ath5k/base.h
> @@ -202,7 +202,6 @@ struct ath5k_softc {
>  #define ATH_STAT_STARTED       4               /* opened & irqs enabled */
>
>        unsigned int            filter_flags;   /* HW flags, AR5K_RX_FILTER_* */
> -       unsigned int            curmode;        /* current phy mode */
>        struct ieee80211_channel *curchan;      /* current h/w channel */
>
>        u16                     nvifs;
>


Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
