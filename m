Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57801 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab1COQeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 12:34:09 -0400
Received: by gwaa18 with SMTP id a18so303934gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 09:34:08 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19839.38108.516103.285131@gargle.gargle.HOWL>
Date: Tue, 15 Mar 2011 22:03:32 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ath9k_hw: Speedup register ops for HTC driver
In-Reply-To: <1300199138-11851-3-git-send-email-rmanoharan@atheros.com>
References: <1300199138-11851-1-git-send-email-rmanoharan@atheros.com>
	<1300199138-11851-3-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
> index fccd87d..995949d 100644
> --- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
> +++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
> @@ -799,6 +799,8 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
>  							   pwr_table_offset,
>  							   &diff);
>  
> +			ENABLE_REGWRITE_BUFFER(ah);
> +
>  			if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
>  				if (OLC_FOR_AR9280_20_LATER) {
>  					REG_WRITE(ah,
> @@ -847,6 +849,7 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
>  
>  				regOffset += 4;
>  			}
> +			REGWRITE_BUFFER_FLUSH(ah);
>  		}
>  	}
>  
> @@ -1205,6 +1208,8 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
>  		}
>  	}
>  
> +	ENABLE_REGWRITE_BUFFER(ah);
> +
>  	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
>  		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
>  		  | ATH9K_POW_SM(ratesArray[rate12mb], 16)
> @@ -1291,6 +1296,8 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
>  	REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
>  		  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
>  		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
> +
> +	REGWRITE_BUFFER_FLUSH(ah);
>  }
>  

Since this issue was observed in UB95, shouldn't eeprom_9287 be fixed ?

Sujith
