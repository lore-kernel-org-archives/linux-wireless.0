Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55900 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1HCJAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 05:00:40 -0400
Received: by yia27 with SMTP id 27so334444yia.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2011 02:00:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312359372-5586-1-git-send-email-lindner_marek@yahoo.de>
References: <1312359372-5586-1-git-send-email-lindner_marek@yahoo.de>
Date: Wed, 3 Aug 2011 17:00:38 +0800
Message-ID: <CAJ-Vmonbe_XNxy68mXZQdABT5tMWwXjJX_XqiNKU7d2CFv3VnQ@mail.gmail.com> (sfid-20110803_110047_756558_0A59862B)
Subject: Re: [PATCH] ath9k: remove eeprom txgain override for minor version < 19
From: Adrian Chadd <adrian@freebsd.org>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'd rather the description included why it needs changing, rather than
just what it does.

I'd add something like:

"This isn't needed for the AR9285; the check originated with the
AR9280 setup code which requires the EEPROM version check."


adrian

On 3 August 2011 16:16, Marek Lindner <lindner_marek@yahoo.de> wrote:
> ath9k_hw_4k_get_eeprom() overrides the eeprom value for txgain if the
> minor version is not 19 or above with a value of 0.
> ar9002_hw_init_mode_gain_regs() relies on this information to
> determine whether this is a high power wifi card or not. The override
> caused the driver to always use the 'normal' power tables even for
> high power devices if their minor version was not high enough. Thus
> leading to reduced power output.
>
> Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
> ---
>  drivers/net/wireless/ath/ath9k/eeprom_4k.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
> index 5b1e894..10f3072 100644
> --- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
> +++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
> @@ -237,10 +237,7 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
>        case EEP_ANT_DIV_CTL1:
>                return pModal->antdiv_ctl1;
>        case EEP_TXGAIN_TYPE:
> -               if (ver_minor >= AR5416_EEP_MINOR_VER_19)
> -                       return pBase->txGainType;
> -               else
> -                       return AR5416_EEP_TXGAIN_ORIGINAL;
> +               return pBase->txGainType;
>        default:
>                return 0;
>        }
> --
> 1.7.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
