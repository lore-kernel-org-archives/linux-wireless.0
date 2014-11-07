Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56996 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKGB1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 20:27:19 -0500
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"sujith@msujith.org" <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] ath9k: Fix RTC_DERIVED_CLK usage
Date: Fri, 7 Nov 2014 01:27:03 +0000
Message-ID: <6ab906f08e04490696d056a5b9135f8b@NASANEXM01E.na.qualcomm.com> (sfid-20141107_022723_171365_ED0A9C3A)
References: <1415251343-17046-1-git-send-email-sujith@msujith.org>
 <20141106204208.GC4440@tuxdriver.com>
In-Reply-To: <20141106204208.GC4440@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It will cause TSF not accurate, the result is beacon interval not equal to the real time.

Thanks,
Miaoqing

-----Original Message-----
From: John W. Linville [mailto:linville@tuxdriver.com] 
Sent: Friday, November 07, 2014 4:42 AM
To: sujith@msujith.org
Cc: linux-wireless@vger.kernel.org; ath9k-devel; stable@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: Fix RTC_DERIVED_CLK usage

On Thu, Nov 06, 2014 at 10:52:23AM +0530, Sujith Manoharan wrote:
> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> 
> Based on the reference clock, which could be 25MHz or 40MHz, 
> AR_RTC_DERIVED_CLK is programmed differently for AR9340 and AR9550.
> But, when a chip reset is done, processing the initvals sets the 
> register back to the default value.
> 
> Fix this by moving the code in ath9k_hw_init_pll() to 
> ar9003_hw_override_ini(). Also, do this override for AR9531.

What is the effect of having the clock programmed incorrectly?


> Cc: stable@vger.kernel.org
> Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
> v2 - Fix author address.
> 
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c | 13 +++++++++++++
>  drivers/net/wireless/ath/ath9k/hw.c         | 13 -------------
>  2 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c 
> b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> index 9bdaa0a..2df6d2e 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -664,6 +664,19 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
>  		ah->enabled_cals |= TX_CL_CAL;
>  	else
>  		ah->enabled_cals &= ~TX_CL_CAL;
> +
> +	if (AR_SREV_9340(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah)) {
> +		if (ah->is_clk_25mhz) {
> +			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
> +			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
> +			REG_WRITE(ah, AR_SLP32_INC, 0x0001e7ae);
> +		} else {
> +			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x261 << 1);
> +			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f400);
> +			REG_WRITE(ah, AR_SLP32_INC, 0x0001e800);
> +		}
> +		udelay(100);
> +	}
>  }
>  
>  static void ar9003_hw_prog_ini(struct ath_hw *ah, diff --git 
> a/drivers/net/wireless/ath/ath9k/hw.c 
> b/drivers/net/wireless/ath/ath9k/hw.c
> index ee9fb52..04ae1f8 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -870,19 +870,6 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
>  	udelay(RTC_PLL_SETTLE_DELAY);
>  
>  	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
> -
> -	if (AR_SREV_9340(ah) || AR_SREV_9550(ah)) {
> -		if (ah->is_clk_25mhz) {
> -			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
> -			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
> -			REG_WRITE(ah,  AR_SLP32_INC, 0x0001e7ae);
> -		} else {
> -			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x261 << 1);
> -			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f400);
> -			REG_WRITE(ah,  AR_SLP32_INC, 0x0001e800);
> -		}
> -		udelay(100);
> -	}
>  }
>  
>  static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
> --
> 2.1.3
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
