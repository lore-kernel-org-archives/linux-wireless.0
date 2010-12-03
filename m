Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42157 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab0LCGeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 01:34:25 -0500
Received: by qyk12 with SMTP id 12so11298293qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 22:34:24 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101203040300.GA2988@makis.mantri>
References: <20101203040300.GA2988@makis.mantri>
Date: Fri, 3 Dec 2010 07:34:24 +0100
Message-ID: <AANLkTi=0-fQWkp7eyUJiXsZNWMot+DkriH1sepw0cL66@mail.gmail.com>
Subject: Re: [PATCH 1/6] ath5k: Always write tx powertable on hw
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

On Fri, Dec 3, 2010 at 5:03 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  * By skipping tx power table calibration we also skip setting
>  tx power table on hw. Make sure we always write tx power table
>  on hw since it gets cleared on reset.
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |   33 +++++++++++++++++++++------------
>  1 files changed, 21 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index df5cd0f..f84afb4 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -2742,10 +2742,12 @@ ath5k_combine_pwr_to_pdadc_curves(struct ath5k_hw *ah,
>
>  /* Write PDADC values on hw */
>  static void
> -ath5k_setup_pwr_to_pdadc_table(struct ath5k_hw *ah,
> -                       u8 pdcurves, u8 *pdg_to_idx)
> +ath5k_setup_pwr_to_pdadc_table(struct ath5k_hw *ah, u8 ee_mode)
>  {
> +       struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
>        u8 *pdadc_out = ah->ah_txpower.txp_pd_table;
> +       u8 *pdg_to_idx = ee->ee_pdc_to_idx[ee_mode];
> +       u8 pdcurves = ee->ee_pd_gains[ee_mode];
>        u32 reg;
>        u8 i;
>
> @@ -2992,7 +2994,7 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
>                                                ee->ee_pd_gains[ee_mode]);
>
>                /* Write settings on hw */
> -               ath5k_setup_pwr_to_pdadc_table(ah, pdg, pdg_curve_to_idx);
> +               ath5k_setup_pwr_to_pdadc_table(ah, ee_mode);
>
>                /* Set txp.offset, note that table_min
>                 * can be negative */
> @@ -3114,12 +3116,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>                return -EINVAL;
>        }
>
> -       /* Reset TX power values */
> -       memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));
> -       ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
> -       ah->ah_txpower.txp_min_pwr = 0;
> -       ah->ah_txpower.txp_max_pwr = AR5K_TUNE_MAX_TXPOWER;
> -
>        /* Initialize TX power table */
>        switch (ah->ah_radio) {
>        case AR5K_RF5110:
> @@ -3146,11 +3142,24 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>         * so there is no need to recalculate the powertable, we 'll
>         * just use the cached one */
>        if (!fast) {
> +               /* Reset TX power values */
> +               memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));
> +               ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
> +               ah->ah_txpower.txp_min_pwr = 0;
> +               ah->ah_txpower.txp_max_pwr = AR5K_TUNE_MAX_TXPOWER;
> +
> +               /* Calculate the powertable */
>                ret = ath5k_setup_channel_powertable(ah, channel,
>                                                        ee_mode, type);
> -                       if (ret)
> -                               return ret;
> -       }
> +               if (ret)
> +                       return ret;
> +       /* Write cached table on hw */
> +       } else if (type == AR5K_PWRTABLE_PWR_TO_PDADC)
> +               ath5k_setup_pwr_to_pdadc_table(ah, ee_mode);
> +       else
> +               ath5k_setup_pcdac_table(ah);
> +
> +
>
>        /* Limit max power if we have a CTL available */
>        ath5k_get_max_ctl_power(ah, channel);
>
