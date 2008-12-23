Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:15566 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYLWMXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 07:23:50 -0500
Received: by yw-out-2324.google.com with SMTP id 9so846489ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 04:23:49 -0800 (PST)
Message-ID: <40f31dec0812230423j37087d86gca7a447698ab3575@mail.gmail.com> (sfid-20081223_132353_918542_4E06F312)
Date: Tue, 23 Dec 2008 14:23:49 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: sbrown@cortland.com
Subject: Re: [PATCH] ath5k: Correct usage of AR5K_CFG_ADHOC
Cc: linux-wireless@vger.kernel.org,
	"Bob Copeland" <bcopeland@gmail.com>
In-Reply-To: <4950B6E6.1090603@cortland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4950B6E6.1090603@cortland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/12/23 Steve Brown <sbrown@cortland.com>:
> This corrects usage of AR5K_CFG_ADHOC introduced in commit
> 731818f956854fa3866f14107867969cf6e9b0cb and restores beaconing in AP and
> mesh modes.
>
> Signed-off-by: Steve Brown <sbrown@cortland.com>
> ---
> diff --git a/drivers/net/wireless/ath5k/pcu.c
> b/drivers/net/wireless/ath5k/pcu.c
> index 0cac05c..b6e27a9 100644
> --- a/drivers/net/wireless/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath5k/pcu.c
> @@ -65,7 +65,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
>                if (ah->ah_version == AR5K_AR5210)
>                        pcu_reg |= AR5K_STA_ID1_NO_PSPOLL;
>                else
> -                       AR5K_REG_DISABLE_BITS(ah, AR5K_CFG, AR5K_CFG_ADHOC);
> +                       AR5K_REG_ENABLE_BITS(ah, AR5K_CFG, AR5K_CFG_ADHOC);
>                break;
>
>        case NL80211_IFTYPE_AP:
> @@ -75,7 +75,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
>                if (ah->ah_version == AR5K_AR5210)
>                        pcu_reg |= AR5K_STA_ID1_NO_PSPOLL;
>                else
> -                       AR5K_REG_ENABLE_BITS(ah, AR5K_CFG, AR5K_CFG_ADHOC);
> +                       AR5K_REG_DISABLE_BITS(ah, AR5K_CFG, AR5K_CFG_ADHOC);
>                break;
>
>        case NL80211_IFTYPE_STATION:
> diff --git a/drivers/net/wireless/ath5k/reg.h
> b/drivers/net/wireless/ath5k/reg.h
> index 91aaeaf..b709ad1 100644
> --- a/drivers/net/wireless/ath5k/reg.h
> +++ b/drivers/net/wireless/ath5k/reg.h
> @@ -73,7 +73,7 @@
> #define AR5K_CFG_SWRD           0x00000004      /* Byte-swap RX descriptor
> */
> #define AR5K_CFG_SWRB           0x00000008      /* Byte-swap RX buffer */
> #define AR5K_CFG_SWRG           0x00000010      /* Byte-swap Register access
> */
> -#define AR5K_CFG_ADHOC         0x00000020      /* AP/Adhoc indication
> [5211+] */
> +#define AR5K_CFG_ADHOC         0x00000020      /* 0-AP, 1-ADHOC [5211+] */
> #define AR5K_CFG_PHY_OK         0x00000100      /* [5211+] */
> #define AR5K_CFG_EEBS           0x00000200      /* EEPROM is busy */
> #define AR5K_CFG_CLKGD          0x00000400      /* Clock gated (Disable
> dynamic clock) */
>
>

Note: 0 is not only AP but also STA, i think we should rename this to
BSS/IBSS indicator, 0 is BSS and 1 is IBSS, also note that AR5K_CFG is
not a PCU register (it configures the host interface unit -HIU- and
these settings have to do with tx/rx descriptor setup, clock gating,
byteswaping and dma ops, i don't know how it affects beaconing) .
Sorry i missed that on one PCU patch, thanks a lot for the fix ;-)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
