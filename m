Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11079 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab2CEEED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 23:04:03 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20308.15129.941982.125893@gargle.gargle.HOWL> (sfid-20120305_050423_693552_7DE51CB0)
Date: Mon, 5 Mar 2012 09:33:37 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: [PATCH 1/5] ath9k_hw: use cold instead of warm reset on AR9280
In-Reply-To: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Cold reset is more reliable for getting the hardware out of some specific
> stuck states.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 8c840ca..d582cf7 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -1386,10 +1386,16 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
>  static bool ath9k_hw_chip_reset(struct ath_hw *ah,
>  				struct ath9k_channel *chan)
>  {
> -	if (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)) {
> -		if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON))
> -			return false;
> -	} else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
> +	int reset_type = ATH9K_RESET_WARM;
> +
> +	if (AR_SREV_9280(ah)) {
> +		if (ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
> +			reset_type = ATH9K_RESET_POWER_ON;
> +		else
> +			reset_type = ATH9K_RESET_COLD;
> +	}
> +
> +	if (!ath9k_hw_set_reset_reg(ah, reset_type))
>  		return false;
>  
>  	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))

I think this needs to be verified a bit more thoroughly, since AR7010+AR9280 USB
devices would also be affected by this change. What issue is exactly fixed by this
change ? More background, etc. would be helpful.

Sujith
