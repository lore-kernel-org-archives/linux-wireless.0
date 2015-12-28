Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:39631 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750998AbbL1R4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2015 12:56:55 -0500
Message-ID: <1451325412.3219.12.camel@perches.com> (sfid-20151228_185731_316866_E8359B51)
Subject: Re: [PATCH] /drivers/net/wireless/ath/ath9k remove unnecessary ?:
 operator
From: Joe Perches <joe@perches.com>
To: Ivan Safonov <insafonov@gmail.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Mon, 28 Dec 2015 09:56:52 -0800
In-Reply-To: <20151228134852.GA10572@alpha.sfu-kras.ru>
References: <20151228134852.GA10572@alpha.sfu-kras.ru>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-12-28 at 20:48 +0700, Ivan Safonov wrote:
> ((thermometer < 0) ? 0 : (thermometer == X)) and (thermometer == X) are equal for X >= 0.

X is not guaranteed to be >= 0 here

> Signed-off-by: Ivan Safonov <insafonov@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
[]
> @@ -4097,16 +4097,16 @@ static void ar9003_hw_thermometer_apply(struct ath_hw *ah)
>  		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
>  			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
>  
> -	therm_on = (thermometer < 0) ? 0 : (thermometer == 0);
> +	therm_on = thermometer == 0;

This code is not equivalent.

Check what happens when thermometer is -1.

>  	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
>  		      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
>  	if (pCap->chip_chainmask & BIT(1)) {
> -		therm_on = (thermometer < 0) ? 0 : (thermometer == 1);
> +		therm_on = thermometer == 1;
>  		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
>  			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
>  	}
>  	if (pCap->chip_chainmask & BIT(2)) {
> -		therm_on = (thermometer < 0) ? 0 : (thermometer == 2);
> +		therm_on = thermometer == 2;
>  		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
>  			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
>  	}

