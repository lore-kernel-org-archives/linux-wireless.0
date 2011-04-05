Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58542 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1DENkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 09:40:13 -0400
Message-ID: <4D9B1BB6.1090507@openwrt.org>
Date: Tue, 05 Apr 2011 15:40:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_hw: Fix instable target power control b/w CCK/OFDM
References: <1302008756-4757-1-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1302008756-4757-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-05 3:05 PM, Rajkumar Manoharan wrote:
> The problem is that when the attenuation is increased,
> the rate will start to drop from MCS7 ->  MCS6, and finally
> will see MCS1 ->  CCK_11Mbps. When the rate is changed b/w
> CCK and OFDM, it will use register desired_scale to calculate
> how much tx gain need to change.
>
> The output power with the same tx gain for CCK and OFDM modulated
> signals are different. This difference is constant for AR9280
> but not AR9285/AR9271. It has different PA architecture
> a constant. So it should be calibrated against this PA
> characteristic.
>
> The driver has to read the calibrated values from EEPROM and set
> the tx power registers accordingly.
>
> Signed-off-by: Rajkumar Manoharan<rmanoharan@atheros.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
> index bc77a30..8f0cd0e 100644
> --- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
> +++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
> @@ -781,6 +781,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
>   {
>   	struct modal_eep_4k_header *pModal;
>   	struct ar5416_eeprom_4k *eep =&ah->eeprom.map4k;
> +	struct base_eep_header_4k *pBase =&eep->baseEepHeader;
>   	u8 txRxAttenLocal;
>   	u8 ob[5], db1[5], db2[5];
>   	u8 ant_div_control1, ant_div_control2;
> @@ -1003,6 +1004,56 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
>   				      AR_PHY_SETTLING_SWITCH,
>   				      pModal->swSettleHt40);
>   	}
> +	if (AR_SREV_9271(ah) || AR_SREV_9285(ah)) {
> +		u8 bb_desired_scale = (pModal->bb_scale_smrt_antenna&
> +				EEP_4K_BB_DESIRED_SCALE_MASK);
> +		if ((pBase->txGainType == 0)&&  (bb_desired_scale != 0)) {
> +			u32 pwrctrl, pwrctrl_n;
> +
> +			/* AR_PHY_TX_PWRCTRL8 */
> +			pwrctrl_n = REG_READ(ah, AR_PHY_TX_PWRCTRL8);
> +			pwrctrl = (u32) bb_desired_scale;
> +			NSO(pwrctrl, 5, bb_desired_scale, 5);
I think the NSO macro is somewhat confusing. How about something like 
this instead, to make it more readable:

u32 mask;
mask = BIT(0) | BIT(5) | BIT(10) | BIT(15) | BIT(20);
pwrctl = mask * bb_desired_scale;

- Felix
