Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54026 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab0LNKsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 05:48:18 -0500
Message-ID: <4D074B67.9050309@openwrt.org>
Date: Tue, 14 Dec 2010 11:48:07 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Sujith.Manoharan@atheros.com
Subject: Re: [PATCH] ath9k_htc: Remove PCI specific configuration
References: <19718.55706.982211.137208@gargle.gargle.HOWL>
In-Reply-To: <19718.55706.982211.137208@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-12-14 3:42 AM, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> There is no need to configure PCI related registers for
> USB devices.
> 
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 0f373be..2662553 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -568,10 +568,12 @@ static int __ath9k_hw_init(struct ath_hw *ah)
>  	ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
>  			 AR_WA_ASPM_TIMER_BASED_DISABLE);
>  
> -	if (ah->is_pciexpress)
> +	if (ah->is_pciexpress) {
>  		ath9k_hw_configpcipowersave(ah, 0, 0);
> -	else
> -		ath9k_hw_disablepcie(ah);
> +	} else {
> +		if (common->bus_ops->ath_bus_type != ATH_USB)
> +			ath9k_hw_disablepcie(ah);
> +	}
I don't really see the point of this check, since (with my other patch)
ath9k_hw_disablepcie already checks for AR_SREV_5416, which won't return
true on any USB based device.

- Felix
