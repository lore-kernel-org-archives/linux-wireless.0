Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:1580 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbYKCT1w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 14:27:52 -0500
Message-ID: <490F50AB.6080502@tpi.com> (sfid-20081103_202755_902646_EA939BB9)
Date: Mon, 03 Nov 2008 12:27:39 -0700
From: Tim Gardner <timg@tpi.com>
Reply-To: timg@tpi.com
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH] ath5k: ignore the return value of ath5k_hw_noise_floor_calibration
References: <490ED21A.9080508@openwrt.org>
In-Reply-To: <490ED21A.9080508@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Noise floor calibration occasionally fails on Atheros hardware.
> This is not fatal and can happen if there's simply too much 
> noise on the air. Ignoring the calibration error is the right
> thing to do here, because when the error is ignored, the hardware
> will still work, whereas if the error causes the driver to bail out
> of a bigger configuration function and does not configure the tx
> queues or the IMR (as is the case in reset.c), the hw no longer
> works properly until the next reset.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
> --- a/drivers/net/wireless/ath5k/phy.c
> +++ b/drivers/net/wireless/ath5k/phy.c
> @@ -2196,9 +2196,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
>  		return ret;
>  	}
>  
> -	ret = ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
> -	if (ret)
> -		return ret;
> +	ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
>  
>  	/*
>  	 * Re-enable RX/TX and beacons
> diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
> --- a/drivers/net/wireless/ath5k/reset.c
> +++ b/drivers/net/wireless/ath5k/reset.c
> @@ -842,9 +842,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>  	 *
>  	 * XXX: Find an interval that's OK for all cards...
>  	 */
> -	ret = ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
> -	if (ret)
> -		return ret;
> +	ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
>  
>  	/*
>  	 * Reset queues and start beacon timers at the end of the reset routine
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

ACK

While I'm not sure I agree with your theory on why noise floor
calibration fails, this patch certainly cuts down on log noise without
introducing any adverse side effects.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
