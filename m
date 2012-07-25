Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56392 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2GYTWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 15:22:16 -0400
Received: by obbuo13 with SMTP id uo13so1489735obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 12:22:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
Date: Wed, 25 Jul 2012 22:22:15 +0300
Message-ID: <CAFtRNNwY-1JLEJa_qZpUfsyQVdUQLO3CWcEB9xef-g5jPzndNQ@mail.gmail.com> (sfid-20120725_212233_426610_E577D33D)
Subject: Re: [PATCH 2/2] ath5k: fix phy_init() to respect user txpower changes
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/23 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> In such cases where phy_init() function got called, tx_power is always
> set to ah->ah_txpower.txp_cur_pwr which is never updated with txpower
> specified by the user instead it equale max chan power and got
> potentially incremented by ah_txpower.txp_offset.

Never updated ?

It gets updated when setting the rate powertable (the final step of
the whole process):

ath5k_setup_rate_powertable:
3577         ah->ah_txpower.txp_cur_pwr = 2 * rates[0];

> In any case the card was switching to a txpower level higher that
> someone specified to use. This patch fix this by introducing
> ah_txpower.txp_user_pwr which holds the tx_power specified at userland.
> Function ath5k_hw_txpower is restructured and uses the value at
>  directly.
>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
> restructure of ath5k_hw_txpower as suggested by Felix Fietkau.
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h |  1 +
>  drivers/net/wireless/ath/ath5k/base.c  |  3 +++
>  drivers/net/wireless/ath/ath5k/phy.c   | 27 ++++++++++++++-------------
>  3 files changed, 18 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index 64a453a..89d9ac54 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1418,6 +1418,7 @@ struct ath5k_hw {
>                 s16             txp_min_pwr;
>                 s16             txp_max_pwr;
>                 s16             txp_cur_pwr;
> +               s16             txp_user_pwr;
>                 /* Values in 0.5dB units */
>                 s16             txp_offset;
>                 s16             txp_ofdm;

We already have
1334         int                     power_level;    /* Requested tx
power in dBm */

and
s16             txp_cur_pwr;

What's the reason to use another one ? If you want a different
type/name just change power_pevel.

We use power_level on ath5k_config when someone updates txpower:

209         if ((changed & IEEE80211_CONF_CHANGE_POWER) &&
210         (ah->power_level != conf->power_level)) {
211                 ah->power_level = conf->power_level;
212
213                 /* Half dB steps */
214                 ath5k_hw_set_txpower_limit(ah, (conf->power_level * 2));
215         }

And on each descriptor (it's ignored for now by hardware since we
haven't enabled TPC):

723         ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
724                 ieee80211_get_hdrlen_from_skb(skb), padsize,
725                 get_hw_packet_type(skb),
726                 (ah->power_level * 2),
727                 hw_rate,
728                 info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
729                 cts_rate, duration);


We use txp_cur_pwr when setting txpower level on ath5k_setup_rate_powertable

3577         ah->ah_txpower.txp_cur_pwr = 2 * rates[0];

as I mentioned above, and in ath5k_hw_phy_init to preserve this
setting across resets

3792         ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
3793                         ah->ah_txpower.txp_cur_pwr / 2 :
AR5K_TUNE_MAX_TXPOWER);

To give you an idea why we already have 2 places to keep tx power
setting, base.c/mac80211-ops.c should use power_level thats in 1db
steps (and makes sense to someone reading the driver part and doesn't
want to understand why we use 0.5 and 0.25db steps on the hw
functions), and ah->ah_txpower.txp_cur_pwr on phy.c functions
internally.

I find this to be clean and simple and I don't see any problem with
it, if I did some cleanup that would be maybe to change power_level to
ah_tx_power_level and from int to s16 to match the rest but other than
that I think it's O.K. the way it is..

> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 8c4c040..e831f69 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2951,6 +2951,9 @@ ath5k_init(struct ieee80211_hw *hw)
>                 hw->queues = 1;
>         }
>
> +       /* init tx_power setting to maximum */
> +       ah->ah_txpower.txp_user_pwr = AR5K_TUNE_MAX_TXPOWER;
> +
>         tasklet_init(&ah->rxtq, ath5k_tasklet_rx, (unsigned long)ah);
>         tasklet_init(&ah->txtq, ath5k_tasklet_tx, (unsigned long)ah);
>         tasklet_init(&ah->beacontq, ath5k_tasklet_beacon, (unsigned long)ah);

No need to do that, if txpower is not initialized we use max power
anyway on phy_init

3792         ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
3793                         ah->ah_txpower.txp_cur_pwr / 2 :
AR5K_TUNE_MAX_TXPOWER);

> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 8b71a2d..728ff07 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -3583,14 +3583,12 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
>   * ath5k_hw_txpower() - Set transmission power limit for a given channel
>   * @ah: The &struct ath5k_hw
>   * @channel: The &struct ieee80211_channel
> - * @txpower: Requested tx power in 0.5dB steps
>   *
>   * Combines all of the above to set the requested tx power limit
> - * on hw.
> + * on hw to ah->ah_txpower.txp_user_pwr.
>   */
>  static int
> -ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
> -                u8 txpower)
> +ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel)
>  {
>         struct ath5k_rate_pcal_info rate_info;
>         struct ieee80211_channel *curr_channel = ah->ah_current_channel;
> @@ -3598,11 +3596,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>         u8 type;
>         int ret;
>
> -       if (txpower > AR5K_TUNE_MAX_TXPOWER) {
> -               ATH5K_ERR(ah, "invalid tx power: %u\n", txpower);
> -               return -EINVAL;
> -       }
> -
>         ee_mode = ath5k_eeprom_mode_from_channel(channel);
>         if (ee_mode < 0) {
>                 ATH5K_ERR(ah,
> @@ -3667,7 +3660,7 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>         ath5k_get_rate_pcal_data(ah, channel, &rate_info);
>
>         /* Setup rate power table */
> -       ath5k_setup_rate_powertable(ah, txpower, &rate_info, ee_mode);
> +       ath5k_setup_rate_powertable(ah, ah->ah_txpower.txp_user_pwr, &rate_info, ee_mode);
>

txpower here comes from above in 0.5db steps as the kerneldoc says,
that's what ath5k_setup_rate_powertable expects, by passing
ah->ah_txpower.txp_user_pwr directly to  ath5k_setup_rate_powertable,
it would result getting half the power requested because hw expects
this to be an index to the channel powertable (check the
implementation of ath5k_setup_rate_powertable) that uses 0.5db steps.

>         /* Write rate power table on hw */
>         ath5k_hw_reg_write(ah, AR5K_TXPOWER_OFDM(3, 24) |
> @@ -3717,8 +3710,16 @@ ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
>  {
>         ATH5K_DBG(ah, ATH5K_DEBUG_TXPOWER,
>                 "changing txpower to %d\n", txpower);
> +       if (txpower) {
> +               ah->ah_txpower.txp_user_pwr = txpower;
> +
> +               if (ah->ah_txpower.txp_user_pwr > AR5K_TUNE_MAX_TXPOWER) {
> +                       ATH5K_ERR(ah, "invalid tx power: %u\n", ah->ah_txpower.txp_user_pwr);
> +                       return -EINVAL;
> +               }
> +       }
>

Again this would result getting half the power requested, you should
*2 this if you want it to be used directly by
ath5k_setup_rate_powertable later.

> -       return ath5k_hw_txpower(ah, ah->ah_current_channel, txpower);
> +       return ath5k_hw_txpower(ah, ah->ah_current_channel);
>  }
>
>
> @@ -3789,8 +3790,8 @@ ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>          * RF buffer settings on 5211/5212+ so that we
>          * properly set curve indices.
>          */
> -       ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
> -                       ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
> +       ret = ath5k_hw_txpower(ah, channel);
> +
>         if (ret)
>                 return ret;
>
> --
> 1.7.11.1
>

To summarize IMHO this patch doesn't fix anything and breaks current
txpower setting so from my point of view it's a NACK.

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
