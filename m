Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:8759 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753436AbYBLJwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 04:52:24 -0500
From: bruno randolf <bruno@thinktube.com>
To: Nick Kossifidis <mick@madwifi.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Port to new bitrate/channel API
Date: Tue, 12 Feb 2008 18:51:54 +0900
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com,
	"Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
References: <20080130183824.GA7676@makis.domain.invalid>
In-Reply-To: <20080130183824.GA7676@makis.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802121851.55553.bruno@thinktube.com> (sfid-20080212_095231_497526_BD1825A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 31 January 2008 03:38:24 Nick Kossifidis wrote:
> Tested on 5211, 5213+5112, 5213A+2112A and it wors fine.
>
> Also i figured out a way to process rate vallue found on status
> descriptors, it's still buggy but we are getting closer (i think it
> improved stability a little).
> [...]
> +/*
> + * Match the hw provided rate index (through descriptors)
> + * to an index for sc->curband->bitrates, so it can be used
> + * by the stack.
> + *
> + * This one is a little bit tricky but i think i'm right
> + * about this...
> + *
> + * We have 4 rate tables in the following order:
> + * XR (4 rates)
> + * 802.11a (8 rates)
> + * 802.11b (4 rates)
> + * 802.11g (12 rates)
> + * that make the hw rate table.
> + *
> + * Lets take a 5211 for example that supports a and b modes only.
> + * First comes the 802.11a table and then 802.11b (total 12 rates).
> + * When hw returns eg. 11 it points to the last 802.11b rate (11Mbit),
> + * if it returns 2 it points to the second 802.11a rate etc.
> + *
> + * Same goes for 5212 who has xr/a/b/g support (total 28 rates).
> + * First comes the XR table, then 802.11a, 802.11b and 802.11g.
> + * When hw returns eg. 27 it points to the last 802.11g rate (54Mbits) etc
> + */
> +static void
> +ath5k_set_total_hw_rates(struct ath5k_softc *sc){
> +
> +	struct ath5k_hw *ah = sc->ah;
> +
> +	if(test_bit(AR5K_MODE_11A, ah->ah_modes))
> +		sc->a_rates = 8;
> +
> +	if(test_bit(AR5K_MODE_11B, ah->ah_modes))
> +		sc->b_rates = 4;
> +
> +	if(test_bit(AR5K_MODE_11G, ah->ah_modes))
> +		sc->g_rates = 12;
> +
> +	/* XXX: Need to see what what happens when
> +		xr disable bits in eeprom are set */
> +	if(ah->ah_version >= AR5K_AR5212)
> +		sc->xr_rates = 4;
> +
> +}
> +
> +static inline int
> +ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix){
> +
> +	int mac80211_rix;
> +
> +	if(sc->curband->band == IEEE80211_BAND_2GHZ){
> +		/* We setup a g ratetable for both b/g modes */
> +		mac80211_rix = hw_rix - sc->b_rates - sc->a_rates - sc->xr_rates;
> +	} else {
> +		mac80211_rix = hw_rix - sc->xr_rates;
> +	}
> +
> +	/* Something went wrong, fallback to basic rate for this band */
> +	if((mac80211_rix >= sc->curband->n_bitrates) ||
> +	(mac80211_rix <= 0 )){
> +		mac80211_rix = 1;
> +	}
> +
> +	return mac80211_rix;
> +}
> +

hi nick!

i don't think that works (for me / right now)... the reported rate on received 
frames is just all wrong. receiving a frame which was sent with 6Mbps (5GHz 
band) the hw rix is 0xb which translates to mac80211 rate index 7 = 54Mbps. 
looking at the dumped rate table it seems the hardware reports rates with a 
hw value which don't directly translate into indices (at least i can't see 
any pattern right now).

Band 5 GHz: channels 194, rates 8
 rates:
( rate hw )
    60 000b 0000 0000
    90 000f 0000 0000
   120 000a 0000 0000
   180 000e 0000 0000
   240 0009 0000 0000
   360 000d 0000 0000
   480 0008 0000 0000
   540 000c 0000 0000

i have verified that ds->ds_rxstat.rs_rate matches this table in 5GHz band on 
a AR5213 (meaning rs_rate 0xb == 6Mbps, 0xf == 9Mbps, etc...). i haven't done 
this on the 2GHz band, because it's just too noisy here.

bruno




