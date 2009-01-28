Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12275 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZA1Oz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 09:55:27 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 06:55:27 -0800
Date: Wed, 28 Jan 2009 06:54:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Vivek Natarajan <vivek.natraj@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Enable MIB and TIM interrupts for station mode.
Message-ID: <20090128145443.GF6174@tesla> (sfid-20090128_155531_080659_6AB14FBD)
References: <20090128093538.GA5799@myhost.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090128093538.GA5799@myhost.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 01:35:39AM -0800, Vivek Natarajan wrote:
> Enable operating mode specific interrupts in ath9k_add_interface instead
> of ath9k_start.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath9k/main.c |   40 +++++++++++++++++++-----------------
>  1 files changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> index d8e8266..8b149ef 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -1957,25 +1957,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
>         if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
>                 sc->sc_imask |= ATH9K_INT_CST;
> 
> -       /*
> -        * Enable MIB interrupts when there are hardware phy counters.
> -        * Note we only do this (at the moment) for station mode.
> -        */
> -       if (ath9k_hw_phycounters(sc->sc_ah) &&
> -           ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) ||
> -            (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)))
> -               sc->sc_imask |= ATH9K_INT_MIB;
> -       /*
> -        * Some hardware processes the TIM IE and fires an
> -        * interrupt when the TIM bit is set.  For hardware
> -        * that does, if not overridden by configuration,
> -        * enable the TIM interrupt when operating as station.
> -        */
> -       if ((sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
> -           (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) &&
> -           !sc->sc_config.swBeaconProcess)
> -               sc->sc_imask |= ATH9K_INT_TIM;
> -
>         ath_cache_conf_rate(sc, &hw->conf);
> 
>         sc->sc_flags &= ~SC_OP_INVALID;
> @@ -2124,6 +2105,27 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
>         /* Set the device opmode */
>         sc->sc_ah->ah_opmode = ic_opmode;
> 
> +       /*
> +        * Enable MIB interrupts when there are hardware phy counters.
> +        * Note we only do this (at the moment) for station mode.
> +        */
> +       if (ath9k_hw_phycounters(sc->sc_ah) &&
> +           ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) ||
> +            (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)))

Please use conf->type == NL80211_IFTYPE_STATION as done
below instead of our own sc->sc_ah->ah_opmode. We want
to try to avoid duplicated data for configuration and eventually
remove it.

> +               sc->sc_imask |= ATH9K_INT_MIB;
> +       /*
> +        * Some hardware processes the TIM IE and fires an
> +        * interrupt when the TIM bit is set.  For hardware
> +        * that does, if not overridden by configuration,
> +        * enable the TIM interrupt when operating as station.
> +        */
> +       if ((sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
> +           (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) &&

Same here.

> +           !sc->sc_config.swBeaconProcess)
> +               sc->sc_imask |= ATH9K_INT_TIM;
> +
> +       ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask);
> +
>         if (conf->type == NL80211_IFTYPE_AP) {

Like this.

>                 /* TODO: is this a suitable place to start ANI for AP mode? */
>                 /* Start ANI */
> --

  Luis
