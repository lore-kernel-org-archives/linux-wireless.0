Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61102 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab2J2IwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 04:52:24 -0400
Date: Mon, 29 Oct 2012 14:22:24 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k: Restore main and alternate antenna.
Message-ID: <20121029085223.GC28932@hemis.qca.qualcomm.com> (sfid-20121029_095230_757051_F438C2A1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Restore main to LNA1 and ALT to LNA2 for AR9565 only
> when shared LNA diversity is not enabled.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> index 105390a..672530c 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> @@ -3674,7 +3674,10 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
>  			regval &= ~AR_FAST_DIV_ENABLE;
>  		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
>  
> -		if (pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
> +		if ((AR_SREV_9485_11(ah) &&
> +		     pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) ||
> +		    (AR_SREV_9565(ah) &&
> +		     !ah->shared_chain_lnadiv)) {
>  			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
>  			/*
>  			 * clear bits 25-30 main_lnaconf, alt_lnaconf,
This is not needed. Its already taken care, when lna is disabled manually, we clear
everything properly via ath_ant_comb_update()

-Rajkumar
