Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42280 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0LUOtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 09:49:32 -0500
Received: by wwa36 with SMTP id 36so4207697wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 06:49:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101221083042.8765.42404.stgit@localhost6.localdomain6>
References: <20101221083020.8765.16350.stgit@localhost6.localdomain6>
	<20101221083042.8765.42404.stgit@localhost6.localdomain6>
Date: Tue, 21 Dec 2010 16:49:31 +0200
Message-ID: <AANLkTikzsikgfDkE5XMsERhKAV+P+H55D3rwhKUDbfTe@mail.gmail.com>
Subject: Re: [PATCH 5/5] ath5k: Use helper function to get eeprom mode from channel
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/21 Bruno Randolf <br1@einfach.org>:
> Introduce a helper function to get the EEPROM mode from channel and remove
> multiple similar switch statements. Also since it's now easy to get the EEPROM
> mode from the channel, use them inside the functions which need it, instead of
> passing a redundant ee_mode parameter.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k.h  |    2 -
>  drivers/net/wireless/ath/ath5k/eeprom.c |   16 +++++++
>  drivers/net/wireless/ath/ath5k/eeprom.h |    2 +
>  drivers/net/wireless/ath/ath5k/phy.c    |   68 +++++++------------------------
>  drivers/net/wireless/ath/ath5k/reset.c  |   19 ++++-----
>  5 files changed, 42 insertions(+), 65 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index 5de8520..407e39c 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1318,7 +1318,7 @@ void ath5k_hw_set_antenna_switch(struct ath5k_hw *ah, u8 ee_mode);
>  int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
>  /* Init function */
>  int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
> -                               u8 mode, u8 ee_mode, bool fast);
> +                               u8 mode, bool fast);
>
>  /*
>  * Functions used internaly
> diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
> index 97eaa9a..80e6256 100644
> --- a/drivers/net/wireless/ath/ath5k/eeprom.c
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.c
> @@ -1802,3 +1802,19 @@ ath5k_eeprom_detach(struct ath5k_hw *ah)
>        for (mode = AR5K_EEPROM_MODE_11A; mode <= AR5K_EEPROM_MODE_11G; mode++)
>                ath5k_eeprom_free_pcal_info(ah, mode);
>  }
> +
> +int
> +ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
> +{
> +       switch (channel->hw_value & CHANNEL_MODES) {
> +       case CHANNEL_A:
> +       case CHANNEL_XR:
> +               return AR5K_EEPROM_MODE_11A;
> +       case CHANNEL_G:
> +               return AR5K_EEPROM_MODE_11G;
> +       case CHANNEL_B:
> +               return AR5K_EEPROM_MODE_11B;
> +       default:
> +               return -1;
> +       }
> +}
> diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
> index 0017006..7c09e15 100644
> --- a/drivers/net/wireless/ath/ath5k/eeprom.h
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.h
> @@ -517,3 +517,5 @@ struct ath5k_eeprom_info {
>        u32     ee_antenna[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
>  };
>
> +int
> +ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel);
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index b6e9621..9306d5f 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1355,20 +1355,7 @@ void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
>                return;
>        }
>
> -       switch (ah->ah_current_channel->hw_value & CHANNEL_MODES) {
> -       case CHANNEL_A:
> -       case CHANNEL_XR:
> -               ee_mode = AR5K_EEPROM_MODE_11A;
> -               break;
> -       case CHANNEL_G:
> -               ee_mode = AR5K_EEPROM_MODE_11G;
> -               break;
> -       default:
> -       case CHANNEL_B:
> -               ee_mode = AR5K_EEPROM_MODE_11B;
> -               break;
> -       }
> -
> +       ee_mode = ath5k_eeprom_mode_from_channel(ah->ah_current_channel);
>
>        /* completed NF calibration, test threshold */
>        nf = ath5k_hw_read_measured_noise_floor(ah);
> @@ -1941,18 +1928,8 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
>
>        def_ant = ah->ah_def_ant;
>
> -       switch (channel->hw_value & CHANNEL_MODES) {
> -       case CHANNEL_A:
> -       case CHANNEL_XR:
> -               ee_mode = AR5K_EEPROM_MODE_11A;
> -               break;
> -       case CHANNEL_G:
> -               ee_mode = AR5K_EEPROM_MODE_11G;
> -               break;
> -       case CHANNEL_B:
> -               ee_mode = AR5K_EEPROM_MODE_11B;
> -               break;
> -       default:
> +       ee_mode = ath5k_eeprom_mode_from_channel(channel);
> +       if (ee_mode < 0) {
>                ATH5K_ERR(ah->ah_sc,
>                        "invalid channel: %d\n", channel->center_freq);
>                return;
> @@ -3100,11 +3077,11 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
>  */
>  static int
>  ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
> -               u8 ee_mode, u8 txpower)
> +                u8 txpower)
>  {
>        struct ath5k_rate_pcal_info rate_info;
>        struct ieee80211_channel *curr_channel = ah->ah_current_channel;
> -       u8 type;
> +       u8 type, ee_mode;
>        int ret;
>
>        if (txpower > AR5K_TUNE_MAX_TXPOWER) {
> @@ -3112,6 +3089,13 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>                return -EINVAL;
>        }
>
> +       ee_mode = ath5k_eeprom_mode_from_channel(channel);
> +       if (ee_mode < 0) {
> +               ATH5K_ERR(ah->ah_sc,
> +                       "invalid channel: %d\n", channel->center_freq);
> +               return -EINVAL;
> +       }
> +
>        /* Initialize TX power table */
>        switch (ah->ah_radio) {
>        case AR5K_RF5110:
> @@ -3208,31 +3192,10 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>
>  int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
>  {
> -       /*Just a try M.F.*/
> -       struct ieee80211_channel *channel = ah->ah_current_channel;
> -       u8 ee_mode;
> -
> -       switch (channel->hw_value & CHANNEL_MODES) {
> -       case CHANNEL_A:
> -       case CHANNEL_XR:
> -               ee_mode = AR5K_EEPROM_MODE_11A;
> -               break;
> -       case CHANNEL_G:
> -               ee_mode = AR5K_EEPROM_MODE_11G;
> -               break;
> -       case CHANNEL_B:
> -               ee_mode = AR5K_EEPROM_MODE_11B;
> -               break;
> -       default:
> -               ATH5K_ERR(ah->ah_sc,
> -                       "invalid channel: %d\n", channel->center_freq);
> -               return -EINVAL;
> -       }
> -
>        ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_TXPOWER,
>                "changing txpower to %d\n", txpower);
>
> -       return ath5k_hw_txpower(ah, channel, ee_mode, txpower);
> +       return ath5k_hw_txpower(ah, ah->ah_current_channel, txpower);
>  }
>
>  /*************\
> @@ -3240,7 +3203,7 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
>  \*************/
>
>  int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
> -                               u8 mode, u8 ee_mode, bool fast)
> +                     u8 mode, bool fast)
>  {
>        struct ieee80211_channel *curr_channel;
>        int ret, i;
> @@ -3281,8 +3244,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>         * RF buffer settings on 5211/5212+ so that we
>         * properly set curve indices.
>         */
> -       ret = ath5k_hw_txpower(ah, channel, ee_mode,
> -               ah->ah_txpower.txp_cur_pwr ?
> +       ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
>                        ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
>        if (ret)
>                return ret;
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index 4b8b987..3c962f7 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -866,15 +866,18 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
>  }
>
>  static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
> -               struct ieee80211_channel *channel, u8 ee_mode)
> +               struct ieee80211_channel *channel)
>  {
>        struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
>        s16 cck_ofdm_pwr_delta;
> +       u8 ee_mode;
>
>        /* TODO: Add support for AR5210 EEPROM */
>        if (ah->ah_version == AR5K_AR5210)
>                return;
>
> +       ee_mode = ath5k_eeprom_mode_from_channel(channel);
> +
>        /* Adjust power delta for channel 14 */
>        if (channel->center_freq == 2484)
>                cck_ofdm_pwr_delta =
> @@ -1020,10 +1023,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>                struct ieee80211_channel *channel, bool fast, bool skip_pcu)
>  {
>        u32 s_seq[10], s_led[3], tsf_up, tsf_lo;
> -       u8 mode, ee_mode;
> +       u8 mode;
>        int i, ret;
>
> -       ee_mode = 0;
>        tsf_up = 0;
>        tsf_lo = 0;
>        mode = 0;
> @@ -1070,7 +1072,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>        switch (channel->hw_value & CHANNEL_MODES) {
>        case CHANNEL_A:
>                mode = AR5K_MODE_11A;
> -               ee_mode = AR5K_EEPROM_MODE_11A;
>                break;
>        case CHANNEL_G:
>
> @@ -1081,7 +1082,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>                }
>
>                mode = AR5K_MODE_11G;
> -               ee_mode = AR5K_EEPROM_MODE_11G;
>                break;
>        case CHANNEL_B:
>
> @@ -1092,7 +1092,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>                }
>
>                mode = AR5K_MODE_11B;
> -               ee_mode = AR5K_EEPROM_MODE_11B;
>                break;
>        case CHANNEL_XR:
>                if (ah->ah_version == AR5K_AR5211) {
> @@ -1101,7 +1100,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>                        return -EINVAL;
>                }
>                mode = AR5K_MODE_XR;
> -               ee_mode = AR5K_EEPROM_MODE_11A;
>                break;
>        default:
>                ATH5K_ERR(ah->ah_sc,
> @@ -1114,8 +1112,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>         * go on. If it fails continue with a normal reset.
>         */
>        if (fast) {
> -               ret = ath5k_hw_phy_init(ah, channel, mode,
> -                                       ee_mode, true);
> +               ret = ath5k_hw_phy_init(ah, channel, mode, true);
>                if (ret) {
>                        ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_RESET,
>                                "fast chan change failed, falling back to normal reset\n");
> @@ -1212,7 +1209,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>        ath5k_hw_tweak_initval_settings(ah, channel);
>
>        /* Commit values from EEPROM */
> -       ath5k_hw_commit_eeprom_settings(ah, channel, ee_mode);
> +       ath5k_hw_commit_eeprom_settings(ah, channel);
>
>
>        /*
> @@ -1251,7 +1248,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>        /*
>         * Initialize PHY
>         */
> -       ret = ath5k_hw_phy_init(ah, channel, mode, ee_mode, false);
> +       ret = ath5k_hw_phy_init(ah, channel, mode, false);
>        if (ret) {
>                ATH5K_ERR(ah->ah_sc,
>                        "failed to initialize PHY (%i) !\n", ret);
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
