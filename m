Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37054 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1DHWs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 18:48:26 -0400
Received: by qwk3 with SMTP id 3so2364671qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 15:48:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302288556-69156-1-git-send-email-nbd@openwrt.org>
References: <1302288556-69156-1-git-send-email-nbd@openwrt.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 9 Apr 2011 00:48:06 +0200
Message-ID: <BANLkTi=dEnukztxRXQ5X0FaVCfk4pChAjQ@mail.gmail.com>
Subject: Re: [PATCH] ath9k_hw: remove unnecessary parts of the AR9380 SREV check
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 8, 2011 at 8:49 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Older versions have not been sold and the driver does not explicitly
> check for them anyway, so we can simply ignore the macRev here.
> Reduces ath9k_hw size on mips by more than 2 KB.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/reg.h |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
> index 693d543..2fbbe88 100644
> --- a/drivers/net/wireless/ath/ath9k/reg.h
> +++ b/drivers/net/wireless/ath/ath9k/reg.h
> @@ -858,9 +858,7 @@
>  #define AR_SREV_9300(_ah) \
>        (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300))
>  #define AR_SREV_9300_20_OR_LATER(_ah) \
> -       (((_ah)->hw_version.macVersion > AR_SREV_VERSION_9300) || \
> -        (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300) && \
> -         ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9300_20)))
> +       ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9300)

Shouldn't this entire check be removed and replaced with AR_SREV_9300
everywhere? (BTW, the definition of AR_SREV_9300 has superfluous
parentheses around it.)

>
>  #define AR_SREV_9485(_ah) \
>        (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485))
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
