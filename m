Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53230 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab3E1SAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 14:00:09 -0400
Date: Tue, 28 May 2013 13:45:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	felixb@qca.qualcomm.com
Subject: Re: [PATCH] ath9k_hw: fix PA predistortion miscalibration
Message-ID: <20130528174519.GH2084@tuxdriver.com> (sfid-20130528_200014_339026_32179159)
References: <1369757084-50141-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369757084-50141-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this a fix for 3.10?  Should it go to stable?

On Tue, May 28, 2013 at 06:04:44PM +0200, Felix Fietkau wrote:
> If any bins from the training data are skipped (i != max_index), the
> calculated compensation curve gets distorted, and the signal will be
> wildly overamplified. This may be the cause of the reported hardware
> damage that was caused by PA predistortion (because of which PAPRD was
> disabled by default).
> 
> When calculating the x_est, Y, theta values, the use of max_index and i
> was reversed. i points to the bin index whereas max_index refers to the
> index of the calculated arrays.
> 
> Note that PA predistortion is still disabled, it will be re-enabled
> after it has been properly validated.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_paprd.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
> index 09c1f9d..6343cc9 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
> @@ -454,6 +454,8 @@ static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
>  		if (accum_cnt <= thresh_accum_cnt)
>  			continue;
>  
> +		max_index++;
> +
>  		/* sum(tx amplitude) */
>  		accum_tx = ((data_L[i] >> 16) & 0xffff) |
>  		    ((data_U[i] & 0x7ff) << 16);
> @@ -468,20 +470,21 @@ static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
>  
>  		accum_tx <<= scale_factor;
>  		accum_rx <<= scale_factor;
> -		x_est[i + 1] = (((accum_tx + accum_cnt) / accum_cnt) + 32) >>
> -		    scale_factor;
> +		x_est[max_index] =
> +			(((accum_tx + accum_cnt) / accum_cnt) + 32) >>
> +			scale_factor;
>  
> -		Y[i + 1] = ((((accum_rx + accum_cnt) / accum_cnt) + 32) >>
> +		Y[max_index] =
> +			((((accum_rx + accum_cnt) / accum_cnt) + 32) >>
>  			    scale_factor) +
> -			    (1 << scale_factor) * max_index + 16;
> +			(1 << scale_factor) * i + 16;
>  
>  		if (accum_ang >= (1 << 26))
>  			accum_ang -= 1 << 27;
>  
> -		theta[i + 1] = ((accum_ang * (1 << scale_factor)) + accum_cnt) /
> -		    accum_cnt;
> -
> -		max_index++;
> +		theta[max_index] =
> +			((accum_ang * (1 << scale_factor)) + accum_cnt) /
> +			accum_cnt;
>  	}
>  
>  	/*
> -- 
> 1.8.0.2
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
