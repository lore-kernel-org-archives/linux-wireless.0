Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52872 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab2J2InI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 04:43:08 -0400
Date: Mon, 29 Oct 2012 14:13:09 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath9k: Set force WLAN LNA diversity on bit for AR9565
Message-ID: <20121029084307.GB28932@hemis.qca.qualcomm.com> (sfid-20121029_094409_037855_15983212)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> When LNA diversity shared chain is enabled set force
> WLAN LNA diversity on bit and enable fast diversity m2flag
> for AR9565.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> index d2e44c3..105390a 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> @@ -3643,9 +3643,20 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
>  			    (value & AR_EEP_ANT_DIV_ENABLE)) {
>  				regval |= AR_ANT_DIV_ENABLE;
>  				regval |= (1 << AR_PHY_ANT_SW_RX_PROT_S);
> +				if (is2ghz) {
> +					REG_SET_BIT(ah,
> +					    AR_PHY_RESTART,
> +					    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
> +				}
> +				REG_SET_BIT(ah,
> +					    AR_BTCOEX_WL_LNADIV,
> +					    AR_BTCOEX_WL_LNADIV_FORCE_ON);
>  			} else {
>  				regval &= ~AR_ANT_DIV_ENABLE;
>  				regval &= ~(1 << AR_PHY_ANT_SW_RX_PROT_S);
> +				REG_CLR_BIT(ah,
> +					    AR_BTCOEX_WL_LNADIV,
> +					    AR_BTCOEX_WL_LNADIV_FORCE_ON);
NACK. These bits are already taken care in
ar9003_hw_antctrl_shared_chain_lnadiv.

-Rajkumar
