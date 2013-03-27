Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48055 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3C0PPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 11:15:46 -0400
Date: Wed, 27 Mar 2013 11:04:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Robert Shade <robert.shade@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Show actual timeout value in failed calibration
 messages.
Message-ID: <20130327150428.GB1868@tuxdriver.com> (sfid-20130327_161549_464434_B64CA2DE)
References: <CAMgrJ3YYZuR2oN9p4jMXvEd22aU+O69Bv-M5uOEO-FUZkdf_MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMgrJ3YYZuR2oN9p4jMXvEd22aU+O69Bv-M5uOEO-FUZkdf_MA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Missing a Signed-off-by line...

On Sun, Mar 24, 2013 at 02:25:02PM -0400, Robert Shade wrote:
> The messages are currently hard coding "1ms", which does not match
> the actual timeout being used.
> ---
>  drivers/net/wireless/ath/ath9k/ar9002_calib.c |    9 ++++++---
>  drivers/net/wireless/ath/ath9k/ar9003_calib.c |    3 ++-
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> index c55e5bb..9f58974 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> @@ -731,7 +731,8 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah,
> struct ath9k_channel *chan)
>  		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
>  				  AR_PHY_AGC_CONTROL_CAL, 0, AH_WAIT_TIMEOUT)) {
>  			ath_dbg(common, CALIBRATE,
> -				"offset calibration failed to complete in 1ms; noisy environment?\n");
> +				"offset calibration failed to complete in %d ms; noisy environment?\n",
> +				AH_WAIT_TIMEOUT / 1000);
>  			return false;
>  		}
>  		REG_CLR_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
> @@ -745,7 +746,8 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah,
> struct ath9k_channel *chan)
>  	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
>  			  0, AH_WAIT_TIMEOUT)) {
>  		ath_dbg(common, CALIBRATE,
> -			"offset calibration failed to complete in 1ms; noisy environment?\n");
> +			"offset calibration failed to complete in %d ms; noisy environment?\n",
> +			AH_WAIT_TIMEOUT / 1000);
>  		return false;
>  	}
> 
> @@ -841,7 +843,8 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah,
> struct ath9k_channel *chan)
>  				   AR_PHY_AGC_CONTROL_CAL,
>  				   0, AH_WAIT_TIMEOUT)) {
>  			ath_dbg(common, CALIBRATE,
> -				"offset calibration failed to complete in 1ms; noisy environment?\n");
> +				"offset calibration failed to complete in %d ms; noisy environment?\n",
> +				AH_WAIT_TIMEOUT / 1000);
>  			return false;
>  		}
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index f76c3ca..639ba7d 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -1126,7 +1126,8 @@ skip_tx_iqcal:
>  			ar9003_hw_rtt_disable(ah);
> 
>  		ath_dbg(common, CALIBRATE,
> -			"offset calibration failed to complete in 1ms; noisy environment?\n");
> +			"offset calibration failed to complete in %d ms; noisy environment?\n",
> +			AH_WAIT_TIMEOUT / 1000);
>  		return false;
>  	}
> 
> -- 
> 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
