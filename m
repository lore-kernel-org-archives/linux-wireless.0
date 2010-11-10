Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49099 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756497Ab0KJQX0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 11:23:26 -0500
Message-ID: <4CDAC6FA.1000003@openwrt.org>
Date: Wed, 10 Nov 2010 17:23:22 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH 01/11] ath9k_hw: Fix a reset failure on AR9382 (2x2).
References: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
In-Reply-To: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-10 2:03 PM, Vasanthakumar Thiagarajan wrote:
> From: Senthil Balasubramanian <senthilkumar@atheros.com>
> 
> AR9382 needs to be configured for the correct chain mask before
> running AGC/TxIQ caliberation. Otherwise reset would fail.
> 
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_calib.c |    7 +++++++
>  drivers/net/wireless/ath/ath9k/reg.h          |    2 ++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index 9e6edff..ba898f2 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -718,7 +718,14 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
>  			       struct ath9k_channel *chan)
>  {
>  	struct ath_common *common = ath9k_hw_common(ah);
> +	int val;
>  
> +	val = REG_READ(ah, AR_ENT_OTP);
> +	ath_print(common, ATH_DBG_CALIBRATE, "ath9k: AR_ENT_OTP 0x%x\n", val);
> +
> +	if (val & AR_ENT_OTP_CHAIN2_DISABLE)
> +		ar9003_hw_set_chain_masks(ah, 0x3, 0x3);
> +	else
>  	/*
>  	 * 0x7 = 0b111 , AR9003 needs to be configured for 3-chain mode before
>  	 * running AGC/TxIQ cals
This messes up the code formatting, the lines after that need some
indenting.

- Felix
