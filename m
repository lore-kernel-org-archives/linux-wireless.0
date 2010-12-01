Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51441 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab0LAQj2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 11:39:28 -0500
Message-ID: <4CF67A3C.4060105@openwrt.org>
Date: Wed, 01 Dec 2010 17:39:24 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/26] ath9k: Configure pll control for AR9485
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com> <1291188775-13707-11-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-11-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-12-01 8:32 AM, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c |   16 ++++++++++------
>  drivers/net/wireless/ath/ath9k/hw.c         |    7 ++++++-
>  drivers/net/wireless/ath/ath9k/reg.h        |    2 ++
>  3 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> index b34a9e9..4e35bda 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -390,14 +390,18 @@ static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
>  {
>  	u32 pll;
>  
> -	pll = SM(0x5, AR_RTC_9300_PLL_REFDIV);
> +	if (AR_SREV_9485(ah))
> +		pll = 0x142c;
> +	else {
> +		pll = SM(0x5, AR_RTC_9300_PLL_REFDIV);
>  
> -	if (chan && IS_CHAN_HALF_RATE(chan))
> -		pll |= SM(0x1, AR_RTC_9300_PLL_CLKSEL);
> -	else if (chan && IS_CHAN_QUARTER_RATE(chan))
> -		pll |= SM(0x2, AR_RTC_9300_PLL_CLKSEL);
> +		if (chan && IS_CHAN_HALF_RATE(chan))
> +			pll |= SM(0x1, AR_RTC_9300_PLL_CLKSEL);
> +		else if (chan && IS_CHAN_QUARTER_RATE(chan))
> +			pll |= SM(0x2, AR_RTC_9300_PLL_CLKSEL);
>  
> -	pll |= SM(0x2c, AR_RTC_9300_PLL_DIV);
> +		pll |= SM(0x2c, AR_RTC_9300_PLL_DIV);
> +	}
>  
>  	return pll;
>  }
NACK for this part. Take a look at what gets set for the older chips:

0x5 << AR_RTC_9300_PLL_REFDIV_S == 0x1400
0x2c << AR_RTC_9300_PLL_DIV_S == 0x002c

Hint: it's exactly the same ;)

- Felix
