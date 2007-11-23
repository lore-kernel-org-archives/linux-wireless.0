Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:49898 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbXKWLXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 06:23:50 -0500
Received: by an-out-0708.google.com with SMTP id d31so641410and
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 03:23:49 -0800 (PST)
Message-ID: <40f31dec0711230323t14e50032n891ad44153008345@mail.gmail.com> (sfid-20071123_112354_742952_29EB9FCE)
Date: Fri, 23 Nov 2007 13:23:49 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/3] ath5k: fix noise floor calibration
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
In-Reply-To: <1195815123-22375-2-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-2-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/23, Bruno Randolf <bruno@thinktube.com>:
> fix noise floor calibration by applying AR5K_PHY_NF_AVAL after
> AR5K_PHY_NF_RVAL. that way the XORed mask and value have the same length and we
> get a reasonable noise value in -dBm.
>
> move duplicate noise floor calibration code from two different places into one
> function ath5k_hw_noise_floor_calibration().
>
> the check for accepted noise_floor values (<= AR5K_TUNE_NOISE_FLOOR) should
> only happen when we have an active reading and a converted value, so move it up
> into the first if.
>
> Changes-licensed-under: ISC
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>  drivers/net/wireless/ath5k/ath5k.h |    1 +
>  drivers/net/wireless/ath5k/hw.c    |   36 +---------------
>  drivers/net/wireless/ath5k/phy.c   |   79 +++++++++++++++++++++--------------
>  3 files changed, 51 insertions(+), 65 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
> index 1b8ddd9..5bcbbf9 100644
> --- a/drivers/net/wireless/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath5k/ath5k.h
> @@ -1127,6 +1127,7 @@ extern int ath5k_hw_phy_disable(struct ath5k_hw *ah);
>  extern u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
>  extern void ath5k_hw_set_def_antenna(struct ath5k_hw *ah, unsigned int ant);
>  extern unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah);
> +extern int ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq);
>  /* TX power setup */
>  extern int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel, unsigned int txpower);
>  extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, unsigned int power);
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index 2a826a7..b42fc8f 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -593,7 +593,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>  {
>         struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
>         u32 data, s_seq, s_ant, s_led[3];
> -       s32 noise_floor;
>         unsigned int i, mode, freq, ee_mode, ant[2], driver_mode = -1;
>         int ret;
>
> @@ -916,38 +915,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                 return -EAGAIN;
>         }
>
> -       /*
> -        * Enable noise floor calibration and wait until completion
> -        */
> -       AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
> -                               AR5K_PHY_AGCCTL_NF);
> -
> -       if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
> -                       AR5K_PHY_AGCCTL_NF, 0, false)) {
> -               ATH5K_ERR(ah->ah_sc,
> -                       "noise floor calibration timeout (%uMHz)\n",
> -                       channel->freq);
> -               return -EAGAIN;
> -       }
> -
> -       /* Wait until the noise floor is calibrated and read the value */
> -       for (i = 20; i > 0; i--) {
> -               mdelay(1);
> -               noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
> -
> -               if (AR5K_PHY_NF_RVAL(noise_floor) & AR5K_PHY_NF_ACTIVE)
> -                       noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
> -
> -               if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
> -                       break;
> -       }
> -
> -       if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
> -               ATH5K_ERR(ah->ah_sc,
> -                       "noise floor calibration failed (%uMHz)\n",
> -                       channel->freq);
> -               return -EIO;
> -       }
> +       ret = ath5k_hw_noise_floor_calibration(ah, channel->freq);
> +       if (ret)
> +               return ret;
>
>         ah->ah_calibration = false;
>
> diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
> index 3c2a67c..9b91121 100644
> --- a/drivers/net/wireless/ath5k/phy.c
> +++ b/drivers/net/wireless/ath5k/phy.c
> @@ -1519,6 +1519,51 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
>  /*****************\
>    PHY calibration
>  \*****************/
> +int
> +ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
> +{
> +       int ret;
> +       unsigned int i;
> +       s32 noise_floor;
> +
> +       /*
> +        * Enable noise floor calibration and wait until completion
> +        */
> +       AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
> +                               AR5K_PHY_AGCCTL_NF);
> +
> +       ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
> +                       AR5K_PHY_AGCCTL_NF, 0, false);
> +       if (ret) {
> +               ATH5K_ERR(ah->ah_sc,
> +                       "noise floor calibration timeout (%uMHz)\n", freq);
> +               return ret;
> +       }
> +
> +       /* Wait until the noise floor is calibrated and read the value */
> +       for (i = 20; i > 0; i--) {
> +               mdelay(1);
> +               noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
> +               noise_floor = AR5K_PHY_NF_RVAL(noise_floor);
> +               if (noise_floor & AR5K_PHY_NF_ACTIVE) {
> +                       noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
> +
> +                       if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
> +                               break;
> +               }
> +       }
> +
> +       ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
> +               "noise floor %d, %d\n", noise_floor, AR5K_TUNE_NOISE_FLOOR);
> +
> +       if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
> +               ATH5K_ERR(ah->ah_sc,
> +                       "noise floor calibration failed (%uMHz)\n", freq);
> +               return -EIO;
> +       }
> +
> +       return 0;
> +}
>
>  /*
>   * Perform a PHY calibration on RF5110
> @@ -1529,8 +1574,6 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>                 struct ieee80211_channel *channel)
>  {
>         u32 phy_sig, phy_agc, phy_sat, beacon;
> -       s32 noise_floor;
> -       unsigned int i;
>         int ret;
>
>         /*
> @@ -1612,37 +1655,9 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>                 return ret;
>         }
>
> -       /*
> -        * Enable noise floor calibration and wait until completion
> -        */
> -       AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
> -
> -       ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
> -                       AR5K_PHY_AGCCTL_NF, 0, false);
> -       if (ret) {
> -               ATH5K_ERR(ah->ah_sc,
> -                       "noise floor calibration timeout (%uMHz)\n",
> -                       channel->freq);
> +       ret = ath5k_hw_noise_floor_calibration(ah, channel->freq);
> +       if (ret)
>                 return ret;
> -       }
> -
> -       /* Wait until the noise floor is calibrated */
> -       for (i = 20; i > 0; i--) {
> -               mdelay(1);
> -               noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
> -
> -               if (AR5K_PHY_NF_RVAL(noise_floor) & AR5K_PHY_NF_ACTIVE)
> -                       noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
> -
> -               if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
> -                       break;
> -       }
> -
> -       if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
> -               ATH5K_ERR(ah->ah_sc, "noise floor calibration failed (%uMHz)\n",
> -                       channel->freq);
> -               return -EIO;
> -       }
>
>         /*
>          * Re-enable RX/TX and beacons
> --
> 1.5.3.4
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
