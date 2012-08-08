Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61011 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab2HHORQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 10:17:16 -0400
Received: by obbuo13 with SMTP id uo13so1178049obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 07:17:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344344772-49459-4-git-send-email-nbd@openwrt.org>
References: <1344344772-49459-1-git-send-email-nbd@openwrt.org>
	<1344344772-49459-2-git-send-email-nbd@openwrt.org>
	<1344344772-49459-3-git-send-email-nbd@openwrt.org>
	<1344344772-49459-4-git-send-email-nbd@openwrt.org>
Date: Wed, 8 Aug 2012 19:47:15 +0530
Message-ID: <CAD2nsn3wMOpVSJ+_man8cNwVF-jGAX6r1cWsx+H_TpQjzyKzKg@mail.gmail.com> (sfid-20120808_161722_074514_A0D0AFB5)
Subject: Re: [PATCH 3.6 4/4] ath9k_hw: enable PA linearization
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix!

On Tue, Aug 7, 2012 at 6:36 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> This feature had been disabled in ath9k because the code to support
> it was incomplete, but now the code is in sync with the internal QCA
> codebase, so it's time to enable it.

is it enabled for all AR9300 based chipsets ?

>
> On many newer devices, the calibration is assumed to be done with PA
> linearization enabled.
>
> Tests with a particular AR933x device showed that the signal emitted
> at full power was highly distorted and unreliable with PA linearization
> disabled. With this patch, the signal becomes clear and stability
> is improved.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index d95474e..bea864f 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -463,9 +463,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
>                 ah->config.spurchans[i][1] = AR_NO_SPUR;
>         }
>
> -       /* PAPRD needs some more work to be enabled */
> -       ah->config.paprd_disable = 1;
> -
>         ah->config.rx_intr_mitigation = true;
>         ah->config.pcieSerDesWrite = true;
>
> --
> 1.7.9.6 (Apple Git-31.1)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
