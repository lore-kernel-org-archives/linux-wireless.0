Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39017 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0LUOsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 09:48:01 -0500
Received: by wyb28 with SMTP id 28so4018874wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 06:47:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101221083020.8765.16350.stgit@localhost6.localdomain6>
References: <20101221083020.8765.16350.stgit@localhost6.localdomain6>
Date: Tue, 21 Dec 2010 16:47:59 +0200
Message-ID: <AANLkTinQun2war6TAfLACn+JRz=Hhaps-bJ=qv1WhTGg@mail.gmail.com>
Subject: Re: [PATCH 1/5] ath5k: Simplify powertable recalculation
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/21 Bruno Randolf <br1@einfach.org>:
> Let ath5k_hw_txpower() decide if it can re-use the powertable or if it has to
> be recalculated instead of passing a 'fast' flag from the outside.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h |    1 +
>  drivers/net/wireless/ath/ath5k/phy.c   |   35 ++++++++++++--------------------
>  2 files changed, 14 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index d6e7440..e6491bf 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1113,6 +1113,7 @@ struct ath5k_hw {
>                s16             txp_cck_ofdm_gainf_delta;
>                /* Value in dB units */
>                s16             txp_cck_ofdm_pwr_delta;
> +               bool            txp_setup;
>        } ah_txpower;
>
>        struct {
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index f84afb4..7c6d7dc 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -3004,6 +3004,8 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
>                return -EINVAL;
>        }
>
> +       ah->ah_txpower.txp_setup = true;
> +
>        return 0;
>  }
>
> @@ -3105,9 +3107,10 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
>  */
>  static int
>  ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
> -               u8 ee_mode, u8 txpower, bool fast)
> +               u8 ee_mode, u8 txpower)
>  {
>        struct ath5k_rate_pcal_info rate_info;
> +       struct ieee80211_channel *curr_channel = ah->ah_current_channel;
>        u8 type;
>        int ret;
>
> @@ -3138,10 +3141,13 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>                return -EINVAL;
>        }
>
> -       /* If fast is set it means we are on the same channel/mode
> -        * so there is no need to recalculate the powertable, we 'll
> -        * just use the cached one */
> -       if (!fast) {
> +       /*
> +        * If we don't change channel/mode skip tx powertable calculation
> +        * and use the cached one.
> +        */
> +       if (!ah->ah_txpower.txp_setup ||
> +           (channel->hw_value != curr_channel->hw_value) ||
> +           (channel->center_freq != curr_channel->center_freq)) {
>                /* Reset TX power values */
>                memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));
>                ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
> @@ -3159,8 +3165,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>        else
>                ath5k_setup_pcdac_table(ah);
>
> -
> -
>        /* Limit max power if we have a CTL available */
>        ath5k_get_max_ctl_power(ah, channel);
>
> @@ -3238,7 +3242,7 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
>        ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_TXPOWER,
>                "changing txpower to %d\n", txpower);
>
> -       return ath5k_hw_txpower(ah, channel, ee_mode, txpower, true);
> +       return ath5k_hw_txpower(ah, channel, ee_mode, txpower);
>  }
>
>  /*************\
> @@ -3251,7 +3255,6 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>        struct ieee80211_channel *curr_channel;
>        int ret, i;
>        u32 phy_tst1;
> -       bool fast_txp;
>        ret = 0;
>
>        /*
> @@ -3282,17 +3285,6 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>        }
>
>        /*
> -        * If we don't change channel/mode skip
> -        * tx powertable calculation and use the
> -        * cached one.
> -        */
> -       if ((channel->hw_value == curr_channel->hw_value) &&
> -       (channel->center_freq == curr_channel->center_freq))
> -               fast_txp = true;
> -       else
> -               fast_txp = false;
> -
> -       /*
>         * Set TX power
>         *
>         * Note: We need to do that before we set
> @@ -3300,8 +3292,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>         * properly set curve indices.
>         */
>        ret = ath5k_hw_txpower(ah, channel, ee_mode,
> -                               ah->ah_txpower.txp_max_pwr / 2,
> -                               fast_txp);
> +                               ah->ah_txpower.txp_max_pwr / 2);
>        if (ret)
>                return ret;
>
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
