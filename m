Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:46499 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbXKANDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 09:03:24 -0400
Received: by py-out-1112.google.com with SMTP id u77so916918pyb
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 06:03:23 -0700 (PDT)
Message-ID: <40f31dec0711010603g55705ce5s6c923c26b7c7d9f5@mail.gmail.com> (sfid-20071101_130329_204048_36DD6C79)
Date: Thu, 1 Nov 2007 15:03:23 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/7] ath5k: Fix initval/eeprom/IQ calibration for G mode
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <20071101043424.GB21987@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071101043424.GB21987@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/1, Luis R. Rodriguez <mcgrof@gmail.com>:
> ath5k_hw_reset() was always setting initval and eeprom settings for B mode
> when using G mode. This is because a B channel was being picked up first. We
> should first instead check for G channel. This patch also introduces a
> driver_mode variable which should be used instead for determing
> more reliably the mode we're in.
>
> This fixing another bug where IQ calibration was not being run for
> G mode as CHANNEL_B was always being picked up first. We now instead
> check for driver_mode.
>
> Similar problem was occurring in ath5k_hw_rf5112_rfregs(), we fix this
> there too.
>
> Changes to phy.c, hw.c
> Changes-licensed-under: ISC
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/hw.c  |   27 +++++++++++++++++----------
>  drivers/net/wireless/ath5k/phy.c |    6 +++---
>  2 files changed, 20 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index 50ceab0..8ac88e7 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -538,7 +538,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>         struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
>         u32 data, s_seq, s_ant, s_led[3];
>         s32 noise_floor;
> -       unsigned int i, mode, freq, ee_mode, ant[2];
> +       unsigned int i, mode, freq, ee_mode, ant[2], driver_mode = -1;
>         int ret;
>
>         AR5K_TRACE;
> @@ -598,28 +598,32 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                         mode = AR5K_INI_VAL_11A;
>                         freq = AR5K_INI_RFGAIN_5GHZ;
>                         ee_mode = AR5K_EEPROM_MODE_11A;
> +                       driver_mode = MODE_IEEE80211A;
>                         break;
> -               case CHANNEL_B:
> -                       mode = AR5K_INI_VAL_11B;
> -                       freq = AR5K_INI_RFGAIN_2GHZ;
> -                       ee_mode = AR5K_EEPROM_MODE_11B;
> -                       break;
> -               /* Is this ok on 5211 too ? */
>                 case CHANNEL_G:
>                         mode = AR5K_INI_VAL_11G;
>                         freq = AR5K_INI_RFGAIN_2GHZ;
>                         ee_mode = AR5K_EEPROM_MODE_11G;
> +                       driver_mode = MODE_IEEE80211G;
> +                       break;
> +               case CHANNEL_B:
> +                       mode = AR5K_INI_VAL_11B;
> +                       freq = AR5K_INI_RFGAIN_2GHZ;
> +                       ee_mode = AR5K_EEPROM_MODE_11B;
> +                       driver_mode = MODE_IEEE80211B;
>                         break;
>                 case CHANNEL_T:
>                         mode = AR5K_INI_VAL_11A_TURBO;
>                         freq = AR5K_INI_RFGAIN_5GHZ;
>                         ee_mode = AR5K_EEPROM_MODE_11A;
> +                       driver_mode = MODE_ATHEROS_TURBO;
>                         break;
>                 /*Is this ok on 5211 too ?*/
>                 case CHANNEL_TG:
>                         mode = AR5K_INI_VAL_11G_TURBO;
>                         freq = AR5K_INI_RFGAIN_2GHZ;
>                         ee_mode = AR5K_EEPROM_MODE_11G;
> +                       driver_mode = MODE_ATHEROS_TURBOG;
>                         break;
>                 case CHANNEL_XR:
>                         if (ah->ah_version == AR5K_AR5211) {
> @@ -629,6 +633,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                         mode = AR5K_INI_VAL_XR;
>                         freq = AR5K_INI_RFGAIN_5GHZ;
>                         ee_mode = AR5K_EEPROM_MODE_11A;
> +                       driver_mode = MODE_IEEE80211A;
>                         break;
>                 default:
>                         AR5K_PRINTF("invalid channel: %d\n", channel->freq);
> @@ -662,7 +667,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                 if (ah->ah_version == AR5K_AR5212) {
>
>                         /*For 802.11b*/
> -                       if (!(channel->val & CHANNEL_B)) {
> +                       if (driver_mode == MODE_IEEE80211B) {
>
>                                 /*Get rate table for this operation mode*/
>                                 rt = ath5k_hw_get_rate_table(ah,
> @@ -773,7 +778,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                 /*Enable/disable 802.11b mode on 5111
>                 (enable 2111 frequency converter + CCK)*/
>                 if (ah->ah_radio == AR5K_RF5111) {
> -                       if (channel->val & CHANNEL_B)
> +                       if (driver_mode == MODE_IEEE80211B)
>                                 AR5K_REG_ENABLE_BITS(ah, AR5K_TXCFG,
>                                     AR5K_TXCFG_B_MODE);
>                         else
> @@ -957,7 +962,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>
>         ah->ah_calibration = false;
>
> -       if (!(channel->val & CHANNEL_B)) {
> +       /* A and G modes can use QAM modulation which requires enabling
> +        * I and Q calibration. Don't bother in B mode. */

Just a note, BPSK/QPSK also need /q calibration, so you'd better write
"A and G modes use OFDM modulation which...".

> +       if (!(driver_mode == MODE_IEEE80211B)) {
>                 ah->ah_calibration = true;
>                 AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ,
>                                 AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
> diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
> index d3735bc..14520cd 100644
> --- a/drivers/net/wireless/ath5k/phy.c
> +++ b/drivers/net/wireless/ath5k/phy.c
> @@ -870,10 +870,10 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
>
>         /* Modify bank 6 */
>         if (channel->val & CHANNEL_2GHZ) {
> -               if (channel->val & CHANNEL_B)
> -                       ee_mode = AR5K_EEPROM_MODE_11B;
> -               else
> +               if (channel->val & CHANNEL_G)
>                         ee_mode = AR5K_EEPROM_MODE_11G;
> +               else
> +                       ee_mode = AR5K_EEPROM_MODE_11B;
>                 obdb = 0;
>
>                 if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
> --
> 1.5.2.5
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
