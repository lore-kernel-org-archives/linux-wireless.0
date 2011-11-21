Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34480 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1KUFTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 00:19:01 -0500
Received: by wwe5 with SMTP id 5so9803471wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 21:19:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321836540-5325-5-git-send-email-mar.kolya@gmail.com>
References: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com>
	<1321836540-5325-5-git-send-email-mar.kolya@gmail.com>
Date: Mon, 21 Nov 2011 10:48:59 +0530
Message-ID: <CAD2nsn0uUH0HxnOmF9A0hJ8RVjmacb2Xn1277CNbyY7YUpNgMw@mail.gmail.com> (sfid-20111121_061905_953529_F994E0F1)
Subject: Re: [PATCH 4/4] ath9k: enable ani for 9100
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 6:19 AM, Nikolay Martynov <mar.kolya@gmail.com> wrote:
> ---
>  drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index d6a2568..79c4a0f 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -610,8 +610,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
>        if (!AR_SREV_9300_20_OR_LATER(ah))
>                ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
>
> -        //disable ANI for 9100 and 9340
> -        if (AR_SREV_9100(ah) || AR_SREV_9340(ah))
> +        //disable ANI for 9340

please change the comment style to
/*
*
*/

> +        if (AR_SREV_9340(ah))
>                 ah->config.enable_ani = false;

please mention in the commit log why we are enabling ANI for AR9100,
if there is some improvement performance in noisy environment, please
do mention it.
i assume if it is disabled we may not  have ANI support for AR9100
(or) the hardware code changes are missing.

>
>        ath9k_hw_init_mode_regs(ah);
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
