Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:65354 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab0CIMWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 07:22:53 -0500
Received: by ewy8 with SMTP id 8so655952ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 04:22:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100309075610.30616.82140.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
	 <20100309075610.30616.82140.stgit@void>
Date: Tue, 9 Mar 2010 14:22:51 +0200
Message-ID: <40f31dec1003090422m557092b2ybc471f74e7530f95@mail.gmail.com>
Subject: Re: [PATCH 11/13] ath5k: read eeprom IQ calibration values correctly
	for G mode
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/9 Bruno Randolf <br1@einfach.org>:
> we read the IQ correction values (i_cal and q_cal) for G mode from a wrong
> location (the same shifts as for A mode is applied which is incorrect). use
> correct locations, matching the docs and HAL sources.
>
> also we should write IQ correction only when we have that information in the
> EEPROM, starting from version 4. also write it in the same way as we do in the
> periodic recalibration (enable last), just to be sure.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/eeprom.c |    4 ++--
>  drivers/net/wireless/ath/ath5k/reset.c  |   15 +++++++++------
>  2 files changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
> index 6a3f4da..10b5226 100644
> --- a/drivers/net/wireless/ath/ath5k/eeprom.c
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.c
> @@ -429,8 +429,8 @@ static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
>                        ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
>
>                AR5K_EEPROM_READ(o++, val);
> -               ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
> -               ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
> +               ee->ee_i_cal[mode] = (val >> 5) & 0x3f;
> +               ee->ee_q_cal[mode] = val & 0x1f;
>
>                if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_2) {
>                        AR5K_EEPROM_READ(o++, val);
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index 6d9a1e8..e9e69dc 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -851,12 +851,15 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
>                                AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1,
>                                AR5K_INIT_CYCRSSI_THR1);
>
> -       /* I/Q correction
> -        * TODO: Per channel i/q infos ? */
> -       AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
> -               AR5K_PHY_IQ_CORR_ENABLE |
> -               (ee->ee_i_cal[ee_mode] << AR5K_PHY_IQ_CORR_Q_I_COFF_S) |
> -               ee->ee_q_cal[ee_mode]);
> +       /* I/Q correction (set enable bit last to match HAL sources) */
> +       /* TODO: Per channel i/q infos ? */
> +       if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
> +               AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_Q_I_COFF,
> +                           ee->ee_i_cal[ee_mode]);
> +               AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_Q_Q_COFF,
> +                           ee->ee_q_cal[ee_mode]);
> +               AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE);
> +       }
>
>        /* Heavy clipping -disable for now */
>        if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_5_1)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
