Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54177 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab1GDKZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 06:25:43 -0400
Received: by yxi11 with SMTP id 11so1539851yxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 03:25:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309758467-1712-6-git-send-email-nbd@openwrt.org>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
	<1309758467-1712-2-git-send-email-nbd@openwrt.org>
	<1309758467-1712-3-git-send-email-nbd@openwrt.org>
	<1309758467-1712-4-git-send-email-nbd@openwrt.org>
	<1309758467-1712-5-git-send-email-nbd@openwrt.org>
	<1309758467-1712-6-git-send-email-nbd@openwrt.org>
Date: Mon, 4 Jul 2011 13:25:42 +0300
Message-ID: <CAFtRNNw6ebUwKD9Fg6bS9noq-4q4Mfc8s2X9acdTr6HQF1GB3Q@mail.gmail.com> (sfid-20110704_122547_352667_FC944B51)
Subject: Re: [PATCH 6/8] ath5k: fix reference clock usec duration setting restore
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/4 Felix Fietkau <nbd@openwrt.org>:
> enabling the sleep clock alters the AR5K_USEC_32 field, but disabling
> it didn't restore it.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath5k/reset.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index 1676a3e..55276ce 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -233,7 +233,7 @@ static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
>  static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
>  {
>        struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
> -       u32 scal, spending;
> +       u32 scal, spending, sclock;
>
>        /* Only set 32KHz settings if we have an external
>         * 32KHz crystal present */
> @@ -317,6 +317,15 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
>
>                /* Set up tsf increment on each cycle */
>                AR5K_REG_WRITE_BITS(ah, AR5K_TSF_PARM, AR5K_TSF_PARM_INC, 1);
> +
> +               if ((ah->ah_radio == AR5K_RF5112) ||
> +                       (ah->ah_radio == AR5K_RF5413) ||
> +                       (ah->ah_radio == AR5K_RF2316) ||
> +                       (ah->ah_radio == AR5K_RF2317))
> +                       sclock = 40 - 1;
> +               else
> +                       sclock = 32 - 1;
> +               AR5K_REG_WRITE_BITS(ah, AR5K_USEC_5211, AR5K_USEC_32, sclock);
>        }
>  }
>
> --
> 1.7.3.2
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
