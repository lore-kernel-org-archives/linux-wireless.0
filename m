Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42960 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab2D3Scs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 14:32:48 -0400
Date: Mon, 30 Apr 2012 14:22:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Madhan Jaganathan <madhanj@qca.qualcomm.com>,
	Kai Shi <kaishi@qca.qualcomm.com>
Subject: Re: [PATCH] Revert "ath9k_hw: Fix incorrect spur_freq_sd for AR9003"
Message-ID: <20120430182200.GC2560@tuxdriver.com> (sfid-20120430_203251_706995_06BDA5A2)
References: <1335594521-1963-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1335594521-1963-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 28, 2012 at 11:58:41AM +0530, Rajkumar Manoharan wrote:
> This reverts commit a844adfd7bee4edc66d337de6c33b348e83552a8.
> 
> spur_freq_sd (for self-corr in AGC) is defined with respect to the
> center of each 20MHz channel while spur_phase_delta (for self-corr
> in Rx and spur data filter) is defined with respect to the center
> of current RF channel.
> 
> So in short, we need to subtract spur_freq_sd (for self-corr in AGC)
> by the offset between the center of primary20 and the center of RF
> channel in SW. This offset could be +/10 MHz for dynamic 40.
> 
> Cc: Madhan Jaganathan <madhanj@qca.qualcomm.com>
> Signed-off-by: Kai Shi <kaishi@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

What actual bug is this causing?  Should this be applied to 3.4?

> ---
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> index 5358553..11abb97 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -373,7 +373,7 @@ static void ar9003_hw_spur_ofdm_work(struct ath_hw *ah,
>  			else
>  				spur_subchannel_sd = 0;
>  
> -			spur_freq_sd = (freq_offset << 9) / 11;
> +			spur_freq_sd = ((freq_offset + 10) << 9) / 11;
>  
>  		} else {
>  			if (REG_READ_FIELD(ah, AR_PHY_GEN_CTRL,
> @@ -382,7 +382,7 @@ static void ar9003_hw_spur_ofdm_work(struct ath_hw *ah,
>  			else
>  				spur_subchannel_sd = 1;
>  
> -			spur_freq_sd = (freq_offset << 9) / 11;
> +			spur_freq_sd = ((freq_offset - 10) << 9) / 11;
>  
>  		}
>  
> -- 
> 1.7.10
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
