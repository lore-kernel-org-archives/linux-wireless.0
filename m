Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784Ab3E1Rgv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 13:36:51 -0400
Message-ID: <1369762649.1568.11.camel@dcbw.foobar.com> (sfid-20130528_193654_470769_7F547E5C)
Subject: Re: [PATCH] ath9k_hw: fix PA predistortion miscalibration
From: Dan Williams <dcbw@redhat.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, felixb@qca.qualcomm.com
Date: Tue, 28 May 2013 12:37:29 -0500
In-Reply-To: <1369757084-50141-1-git-send-email-nbd@openwrt.org>
References: <1369757084-50141-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-28 at 18:04 +0200, Felix Fietkau wrote:
> If any bins from the training data are skipped (i != max_index), the
> calculated compensation curve gets distorted, and the signal will be
> wildly overamplified. This may be the cause of the reported hardware
> damage that was caused by PA predistortion (because of which PAPRD was
> disabled by default).
> 
> When calculating the x_est, Y, theta values, the use of max_index and i
> was reversed. i points to the bin index whereas max_index refers to the
> index of the calculated arrays.

Maybe add a comment in the code about the meaning of max_index and i, if
there isn't one already?

Dan

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


