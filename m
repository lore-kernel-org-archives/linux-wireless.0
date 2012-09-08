Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52731 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab2IHIIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2012 04:08:34 -0400
Message-ID: <504AFCE8.5010306@openwrt.org> (sfid-20120908_100840_491189_B3B96CAE)
Date: Sat, 08 Sep 2012 10:08:08 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 6/7] ath9k_hw: Program correct PLL value for AR9565
References: <20554.62374.945320.866841@gargle.gargle.HOWL>
In-Reply-To: <20554.62374.945320.866841@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-09-08 9:28 AM, Sujith Manoharan wrote:
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 063d724..07dd330 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -837,6 +837,9 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
>  		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
>  			      AR_CH0_BB_DPLL2_PLL_PWD, 0x0);
>  		udelay(1000);
> +
> +		if (AR_SREV_9565(ah))
> +			REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x4142c);
>  	} else if (AR_SREV_9330(ah)) {
>  		u32 ddr_dpll2, pll_control2, kd;
>  
> @@ -917,9 +920,10 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
>  		udelay(1000);
>  	}
>  
> -	pll = ath9k_hw_compute_pll_control(ah, chan);
> -
> -	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
> +	if (!AR_SREV_9565(ah)) {
> +		pll = ath9k_hw_compute_pll_control(ah, chan);
> +		REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
> +	}
That looks messed up, how about just:

	pll = ath9k_hw_compute_pll_control(ah, chan);
	if (AR_SREV_9565(ah))
		pll |= 0x40000;
	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);

Or alternatively move that OR mask into ath9k_hw_compute_pll_control

- Felix
