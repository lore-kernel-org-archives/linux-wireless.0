Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64634 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2JLE7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 00:59:54 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so2537726oag.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2012 21:59:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121011162525.2643.85972.stgit@bob.linux.org.uk>
References: <20121011162505.2643.87138.stgit@bob.linux.org.uk>
	<20121011162525.2643.85972.stgit@bob.linux.org.uk>
Date: Fri, 12 Oct 2012 10:29:53 +0530
Message-ID: <CAD2nsn1TL5_EPtiUifKY831359huTiot-iJa-tQVzFoKwkgTQA@mail.gmail.com> (sfid-20121012_065959_425649_FE03083E)
Subject: Re: [PATCH 2/2] ath9k: Fix broken conditional
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alan Cox,

On Thu, Oct 11, 2012 at 9:55 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> From: Alan Cox <alan@linux.intel.com>
>
> One stray semicolon...

seems to be fixed by
https://patchwork.kernel.org/patch/1529211/
but I don't think it was there in wireless-testing.

>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> index 5bbe505..189aeb2 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> @@ -2989,7 +2989,7 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
>         case EEP_PAPRD:
>                 if (AR_SREV_9462(ah))
>                         return false;
> -               if (!ah->config.enable_paprd);
> +               if (!ah->config.enable_paprd)
>                         return false;
>                 return !!(pBase->featureEnable & BIT(5));
>         case EEP_CHAIN_MASK_REDUCE:
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
