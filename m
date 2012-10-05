Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42435 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2JEHJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 03:09:38 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so1411343oag.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2012 00:09:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349366701-23154-1-git-send-email-sven@narfation.org>
References: <1349366701-23154-1-git-send-email-sven@narfation.org>
Date: Fri, 5 Oct 2012 10:45:40 +0530
Message-ID: <CAD2nsn1BfAEQ+Y2nZ0nEdSfar7=R+2PmS2qWA3_r=WoAn7ybUQ@mail.gmail.com> (sfid-20121005_090941_930880_4BFF6C20)
Subject: Re: [PATCH] ath_hw: Use common REG_WRITE parameter order
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 4, 2012 at 9:35 PM, Sven Eckelmann <sven@narfation.org> wrote:
> All defines for REG_WRITE in Atheros wireless drivers use the order "ah",
> "register" and "value". hw.c is the only file using the order "ah", "value" and
> "register". This inconsistent definition can easily lead to implementation
> errors.

oh yes, once Raj and myself were reviewing cycle counters stuff and
was intially confused
with the slight variance in the REG_WRITE definition in ath9k/hw.h,
and ath/hw.c.
thanks to you now, as  it was gone and make our life easier.

>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> ---
>  drivers/net/wireless/ath/hw.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
> index 19befb3..39e8a59 100644
> --- a/drivers/net/wireless/ath/hw.c
> +++ b/drivers/net/wireless/ath/hw.c
> @@ -20,8 +20,8 @@
>  #include "ath.h"
>  #include "reg.h"
>
> -#define REG_READ       (common->ops->read)
> -#define REG_WRITE      (common->ops->write)
> +#define REG_READ                       (common->ops->read)
> +#define REG_WRITE(_ah, _reg, _val)     (common->ops->write)(_ah, _val, _reg)
>
>  /**
>   * ath_hw_set_bssid_mask - filter out bssids we listen
> @@ -119,8 +119,8 @@ void ath_hw_setbssidmask(struct ath_common *common)
>  {
>         void *ah = common->ah;
>
> -       REG_WRITE(ah, get_unaligned_le32(common->bssidmask), AR_BSSMSKL);
> -       REG_WRITE(ah, get_unaligned_le16(common->bssidmask + 4), AR_BSSMSKU);
> +       REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(common->bssidmask));
> +       REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(common->bssidmask + 4));
>  }
>  EXPORT_SYMBOL(ath_hw_setbssidmask);
>
> @@ -139,7 +139,7 @@ void ath_hw_cycle_counters_update(struct ath_common *common)
>         void *ah = common->ah;
>
>         /* freeze */
> -       REG_WRITE(ah, AR_MIBC_FMC, AR_MIBC);
> +       REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
>
>         /* read */
>         cycles = REG_READ(ah, AR_CCCNT);
> @@ -148,13 +148,13 @@ void ath_hw_cycle_counters_update(struct ath_common *common)
>         tx = REG_READ(ah, AR_TFCNT);
>
>         /* clear */
> -       REG_WRITE(ah, 0, AR_CCCNT);
> -       REG_WRITE(ah, 0, AR_RFCNT);
> -       REG_WRITE(ah, 0, AR_RCCNT);
> -       REG_WRITE(ah, 0, AR_TFCNT);
> +       REG_WRITE(ah, AR_CCCNT, 0);
> +       REG_WRITE(ah, AR_RFCNT, 0);
> +       REG_WRITE(ah, AR_RCCNT, 0);
> +       REG_WRITE(ah, AR_TFCNT, 0);
>
>         /* unfreeze */
> -       REG_WRITE(ah, 0, AR_MIBC);
> +       REG_WRITE(ah, AR_MIBC, 0);
>
>         /* update all cycle counters here */
>         common->cc_ani.cycles += cycles;
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
