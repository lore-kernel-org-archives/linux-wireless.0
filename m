Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:8234 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbbFRPQg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 11:16:36 -0400
Message-ID: <5582E0CF.1050804@neratec.com> (sfid-20150618_171639_575449_55F77990)
Date: Thu, 18 Jun 2015 17:16:31 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: mickflemm@gmail.com, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath9k: spectral - simplify max_index calculation
References: <1434626241-1334-1-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1434626241-1334-1-git-send-email-zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After further discussion with Nick, we better leave spectral as is.

Please ignore / drop this one.


On 06/18/2015 01:17 PM, Zefir Kurtisi wrote:
> The max_index value provided in the spectral data set
> has to be interpreted differently for HT20 and HT40.
> In HT40, the value is given as unsigned index and
> shall be taken as is, while in HT20 it is a signed
> value around bin index 28 and needs to be converted
> to an unsigned index.
> 
> This patch simplifies the previous correction and
> prepares the related functions to be shared with
> the DFS module.
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> ---
> 
> v2: fix conversion offset as reported by Nick Kossifidis
> 
>  drivers/net/wireless/ath/ath9k/common-spectral.c | 20 ++++++-------
>  drivers/net/wireless/ath/ath9k/common-spectral.h | 36 +++++++-----------------
>  2 files changed, 18 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
> index a876271..175193d 100644
> --- a/drivers/net/wireless/ath/ath9k/common-spectral.c
> +++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
> @@ -59,8 +59,8 @@ ath_cmn_max_idx_verify_ht20_fft(u8 *sample_end, int bytes_read)
>  
>  	sample = sample_end - SPECTRAL_HT20_SAMPLE_LEN + 1;
>  
> -	max_index = spectral_max_index(mag_info->all_bins,
> -				       SPECTRAL_HT20_NUM_BINS);
> +	/* in ht20, this is a 6-bit signed number => shift it to 0 */
> +	max_index = (spectral_max_index(mag_info->all_bins) ^ 0x20) - 4;
>  	max_magnitude = spectral_max_magnitude(mag_info->all_bins);
>  
>  	max_exp = mag_info->max_exp & 0xf;
> @@ -100,12 +100,10 @@ ath_cmn_max_idx_verify_ht20_40_fft(u8 *sample_end, int bytes_read)
>  	sample = sample_end - SPECTRAL_HT20_40_SAMPLE_LEN + 1;
>  
>  	lower_mag = spectral_max_magnitude(mag_info->lower_bins);
> -	lower_max_index = spectral_max_index(mag_info->lower_bins,
> -					     SPECTRAL_HT20_40_NUM_BINS);
> +	lower_max_index = spectral_max_index(mag_info->lower_bins);
>  
>  	upper_mag = spectral_max_magnitude(mag_info->upper_bins);
> -	upper_max_index = spectral_max_index(mag_info->upper_bins,
> -					     SPECTRAL_HT20_40_NUM_BINS);
> +	upper_max_index = spectral_max_index(mag_info->upper_bins);
>  
>  	max_exp = mag_info->max_exp & 0xf;
>  
> @@ -169,8 +167,8 @@ ath_cmn_process_ht20_fft(struct ath_rx_status *rs,
>  	magnitude = spectral_max_magnitude(mag_info->all_bins);
>  	fft_sample_20.max_magnitude = __cpu_to_be16(magnitude);
>  
> -	max_index = spectral_max_index(mag_info->all_bins,
> -					SPECTRAL_HT20_NUM_BINS);
> +	/* in ht20, this is a 6-bit signed number => shift it to 0 */
> +	max_index = (spectral_max_index(mag_info->all_bins) ^ 0x20) - 4;
>  	fft_sample_20.max_index = max_index;
>  
>  	bitmap_w = spectral_bitmap_weight(mag_info->all_bins);
> @@ -302,12 +300,10 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
>  	upper_mag = spectral_max_magnitude(mag_info->upper_bins);
>  	fft_sample_40.upper_max_magnitude = __cpu_to_be16(upper_mag);
>  
> -	lower_max_index = spectral_max_index(mag_info->lower_bins,
> -					SPECTRAL_HT20_40_NUM_BINS);
> +	lower_max_index = spectral_max_index(mag_info->lower_bins);
>  	fft_sample_40.lower_max_index = lower_max_index;
>  
> -	upper_max_index = spectral_max_index(mag_info->upper_bins,
> -					SPECTRAL_HT20_40_NUM_BINS);
> +	upper_max_index = spectral_max_index(mag_info->upper_bins);
>  	fft_sample_40.upper_max_index = upper_max_index;
>  
>  	lower_bitmap_w = spectral_bitmap_weight(mag_info->lower_bins);
> diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.h b/drivers/net/wireless/ath/ath9k/common-spectral.h
> index 998743b..7540835 100644
> --- a/drivers/net/wireless/ath/ath9k/common-spectral.h
> +++ b/drivers/net/wireless/ath/ath9k/common-spectral.h
> @@ -116,33 +116,17 @@ static inline u16 spectral_max_magnitude(u8 *bins)
>  	       (bins[2] & 0x03) << 10;
>  }
>  
> -/* return the max magnitude from the all/upper/lower bins */
> -static inline u8 spectral_max_index(u8 *bins, int num_bins)
> +/* return the max index from the all/upper/lower bins
> + *
> + * in HT20: 6-bit signed number of range -28 to +27
> + * in HT40: 6-bit unsigned number of range 0 to +63
> + *          (upper sub-channel index 0 is DC)
> + *
> + * Correct interpretation of the value has to be done at caller
> + */
> +static inline u8 spectral_max_index(u8 *bins)
>  {
> -	s8 m = (bins[2] & 0xfc) >> 2;
> -	u8 zero_idx = num_bins / 2;
> -
> -	/* It's a 5 bit signed int, remove its sign and use one's
> -	 * complement interpretation to add the sign back to the 8
> -	 * bit int
> -	 */
> -	if (m & 0x20) {
> -		m &= ~0x20;
> -		m |= 0xe0;
> -	}
> -
> -	/* Bring the zero point to the beginning
> -	 * instead of the middle so that we can use
> -	 * it for array lookup and that we don't deal
> -	 * with negative values later
> -	 */
> -	m += zero_idx;
> -
> -	/* Sanity check to make sure index is within bounds */
> -	if (m < 0 || m > num_bins - 1)
> -		m = 0;
> -
> -	return m;
> +	return (bins[2] & 0xfc) >> 2;
>  }
>  
>  /* return the bitmap weight from the all/upper/lower bins */
> 

