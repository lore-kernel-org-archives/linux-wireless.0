Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56158 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaEORYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:24:32 -0400
Message-ID: <5374F84E.1090208@candelatech.com> (sfid-20140515_192448_404540_BCB54FFA)
Date: Thu, 15 May 2014 10:24:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: fix rssi and rate reporting
References: <1395692698-4745-1-git-send-email-janusz.dziedzic@tieto.com> <1395692698-4745-2-git-send-email-janusz.dziedzic@tieto.com>
In-Reply-To: <1395692698-4745-2-git-send-email-janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a few questions on this patch (long since accepted upstream).

First, why do you only memset the rx_status if START_VALID is set,
and why do you not set:

rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL

in an else clause if START_VALID is not set?

The patch definitely helps, but I'm still getting less accuracy than expected
(as compared to ath9k going through a similar rate vs range test).

Thanks,
Ben


> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index be25e16..f7ecc10 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -1154,8 +1154,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
>  
>  	lockdep_assert_held(&htt->rx_ring.lock);
>  
> -	memset(rx_status, 0, sizeof(*rx_status));
> -
>  	fw_desc_len = __le16_to_cpu(rx->prefix.fw_rx_desc_bytes);
>  	fw_desc = (u8 *)&rx->fw_desc;
>  
> @@ -1164,8 +1162,11 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
>  	mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
>  
>  	/* Fill this once, while this is per-ppdu */
> -	rx_status->signal  = ATH10K_DEFAULT_NOISE_FLOOR;
> -	rx_status->signal += rx->ppdu.combined_rssi;
> +	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_START_VALID) {
> +		memset(rx_status, 0, sizeof(*rx_status));
> +		rx_status->signal  = ATH10K_DEFAULT_NOISE_FLOOR +
> +				     rx->ppdu.combined_rssi;
> +	}
>  
>  	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
>  		/* TSF available only in 32-bit */
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

