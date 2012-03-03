Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54702 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2CCOkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 09:40:39 -0500
Received: by vbbff1 with SMTP id ff1so2295560vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Mar 2012 06:40:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
Date: Sat, 3 Mar 2012 20:10:38 +0530
Message-ID: <CAD2nsn1epfw=N=Np8Ts+G6yF5JTXZXSE4bOL7_jY9mCZG9Cg4Q@mail.gmail.com> (sfid-20120303_154043_094130_EBBAE977)
Subject: Re: [PATCH 1/5] ath9k_hw: use cold instead of warm reset on AR9280
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

On Sat, Mar 3, 2012 at 7:47 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Cold reset is more reliable for getting the hardware out of some specific
> stuck states.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 8c840ca..d582cf7 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -1386,10 +1386,16 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
>  static bool ath9k_hw_chip_reset(struct ath_hw *ah,
>                                struct ath9k_channel *chan)
>  {
> -       if (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)) {
> -               if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON))
> -                       return false;
> -       } else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
> +       int reset_type = ATH9K_RESET_WARM;
> +
> +       if (AR_SREV_9280(ah)) {
> +               if (ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
> +                       reset_type = ATH9K_RESET_POWER_ON;
> +               else
> +                       reset_type = ATH9K_RESET_COLD;
> +       }


cold reset seems to be applicable for older chip sets like AR9100,
should this be applicable to AR9280. won't there be any problem if we
perform cold reset in STA mode.

> +
> +       if (!ath9k_hw_set_reset_reg(ah, reset_type))
>                return false;
>
>        if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
