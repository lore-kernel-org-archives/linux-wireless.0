Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:4436 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYLWRQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 12:16:03 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1888445rnd.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 09:16:02 -0800 (PST)
Message-ID: <40f31dec0812230909r449e7155p385d82a03b3d84a4@mail.gmail.com> (sfid-20081223_181758_367272_6CA49B4B)
Date: Tue, 23 Dec 2008 19:09:40 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: sbrown@cortland.com
Subject: Re: [PATCH V2] ath5k: Correct usage of AR5K_CFG_ADHOC
Cc: linux-wireless@vger.kernel.org,
	"Bob Copeland" <bcopeland@gmail.com>
In-Reply-To: <4950E021.9000506@cortland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4950E021.9000506@cortland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/12/23 Steve Brown <sbrown@cortland.com>:
> This corrects usage of AR5K_CFG_ADHOC introduced in
> 731818f956854fa3866f14107867969cf6e9b0cb (Update PCU code). Also,
> the name of the indicator is changed to AR5K_CFG_IBSS to more
> accurately reflect its function. This change restores beaconing in AP and
> mesh modes.
>
> Signed-off-by: Steve Brown <sbrown@cortland.com>
> ---
>
> Nick,
>
> Is this what you had in mind?
>
> Steve
>
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
> +                       AR5K_REG_ENABLE_BITS(ah, AR5K_CFG, AR5K_CFG_IBSS);
>                break;
>
>        case NL80211_IFTYPE_AP:
> @@ -75,7 +75,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
>                if (ah->ah_version == AR5K_AR5210)
>                        pcu_reg |= AR5K_STA_ID1_NO_PSPOLL;
>                else
> -                       AR5K_REG_ENABLE_BITS(ah, AR5K_CFG, AR5K_CFG_ADHOC);
> +                       AR5K_REG_DISABLE_BITS(ah, AR5K_CFG, AR5K_CFG_IBSS);
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
> +#define AR5K_CFG_IBSS          0x00000020      /* 0-BSS, 1-IBSS [5211+] */
> #define AR5K_CFG_PHY_OK         0x00000100      /* [5211+] */
> #define AR5K_CFG_EEBS           0x00000200      /* EEPROM is busy */
> #define AR5K_CFG_CLKGD          0x00000400      /* Clock gated (Disable
> dynamic clock) */
>
>

Yup ;-)

Thanks a lot !


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
