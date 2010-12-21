Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45593 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0LUOsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 09:48:45 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so4206709wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 06:48:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101221083032.8765.42449.stgit@localhost6.localdomain6>
References: <20101221083020.8765.16350.stgit@localhost6.localdomain6>
	<20101221083032.8765.42449.stgit@localhost6.localdomain6>
Date: Tue, 21 Dec 2010 16:48:44 +0200
Message-ID: <AANLkTi=e9oWG3Lt_p6OfzhcDdpq1qwcUcFb9o8yBnSDC@mail.gmail.com>
Subject: Re: [PATCH 3/5] ath5k: Track current TX power separately from max TX power
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/21 Bruno Randolf <br1@einfach.org>:
> Add a new variable to keep track of the currently configured tx power. Before
> max_pwr was re-used for keeping the maximum allowed power as well as the
> current configuration. Doing a min() on it allows you to lower the txpower, but
> how would you be able to make it higher again?
>
> This patch fixes that by adding a new variable ah_cur_pwr which is used instead
> of txp_max_pwr to keep the current configuration. txp_max_pwr is used to check
> if we are within the limits.
>
> Another problem fixed by this patch is that it avoids setting a zero txpower
> when things are initialized first and the current power is not yet set.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h |    1 +
>  drivers/net/wireless/ath/ath5k/phy.c   |    7 +++----
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index e6491bf..342da28 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1107,6 +1107,7 @@ struct ath5k_hw {
>                /* Values in 0.25dB units */
>                s16             txp_min_pwr;
>                s16             txp_max_pwr;
> +               s16             txp_cur_pwr;
>                /* Values in 0.5dB units */
>                s16             txp_offset;
>                s16             txp_ofdm;
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 6f0cf3a..18c58cd 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -3096,7 +3096,7 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
>
>        /* Min/max in 0.25dB units */
>        ah->ah_txpower.txp_min_pwr = 2 * rates[7];
> -       ah->ah_txpower.txp_max_pwr = 2 * rates[0];
> +       ah->ah_txpower.txp_cur_pwr = 2 * rates[0];
>        ah->ah_txpower.txp_ofdm = rates[7];
>  }
>
> @@ -3150,8 +3150,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>                /* Reset TX power values */
>                memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));
>                ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
> -               ah->ah_txpower.txp_min_pwr = 0;
> -               ah->ah_txpower.txp_max_pwr = AR5K_TUNE_MAX_TXPOWER;
>
>                /* Calculate the powertable */
>                ret = ath5k_setup_channel_powertable(ah, channel,
> @@ -3290,7 +3288,8 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>         * properly set curve indices.
>         */
>        ret = ath5k_hw_txpower(ah, channel, ee_mode,
> -                               ah->ah_txpower.txp_max_pwr / 2);
> +               ah->ah_txpower.txp_cur_pwr ?
> +                       ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
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
