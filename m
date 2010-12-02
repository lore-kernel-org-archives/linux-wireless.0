Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56763 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab0LBLWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:22:54 -0500
Received: by iwn42 with SMTP id 42so837914iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:22:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291288031-3409-17-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com> <1291288031-3409-17-git-send-email-vasanth@atheros.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Dec 2010 22:22:33 +1100
Message-ID: <AANLkTi=Fb0HA1DbaRp21kOS3x4-s_Oh+UZok2jNK3-PG@mail.gmail.com>
Subject: Re: [PATCH V2 16/27] ath9k_hw: Read and configure antenna diversity
 control for AR9485
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small nit:

On Thu, Dec 2, 2010 at 22:07, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   24 ++++++++++++++++++++----
>  drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   10 ++++++++++
>  2 files changed, 30 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> index 02b6150..9ce6846 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> @@ -3512,11 +3514,25 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
>        value = ar9003_hw_ant_ctrl_chain_get(ah, 0, is2ghz);
>        REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_0, AR_SWITCH_TABLE_ALL, value);
>
> -       value = ar9003_hw_ant_ctrl_chain_get(ah, 1, is2ghz);
> -       REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_1, AR_SWITCH_TABLE_ALL, value);
> +       if (!AR_SREV_9485(ah)) {
> +               value = ar9003_hw_ant_ctrl_chain_get(ah, 1, is2ghz);
> +               REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_1, AR_SWITCH_TABLE_ALL,
> +                             value);
>
> -       value = ar9003_hw_ant_ctrl_chain_get(ah, 2, is2ghz);
> -       REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_2, AR_SWITCH_TABLE_ALL, value);
> +               value = ar9003_hw_ant_ctrl_chain_get(ah, 2, is2ghz);
> +               REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_2, AR_SWITCH_TABLE_ALL,
> +                             value);
> +       }

else?

> +       if (AR_SREV_9485(ah)) {
> +               value = ath9k_hw_ar9300_get_eeprom(ah, EEP_ANT_DIV_CTL1);
> +               REG_RMW_FIELD(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_CTRL_ALL,
> +                             value);
> +               REG_RMW_FIELD(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_ENABLE,
> +                             value >> 6);
> +               REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT, AR_FAST_DIV_ENABLE,
> +                             value >> 7);
> +       }
>  }
>
>  static void ar9003_hw_drive_strength_apply(struct ath_hw *ah)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
