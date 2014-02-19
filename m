Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19511 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaBSPZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 10:25:34 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: set the mactime of ieee80211_rx_status
References: <1392197866-1261-1-git-send-email-yeohchunyeow@gmail.com>
Date: Wed, 19 Feb 2014 17:25:28 +0200
In-Reply-To: <1392197866-1261-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Wed, 12 Feb 2014 17:37:46 +0800")
Message-ID: <877g8rxgyf.fsf@kamboji.qca.qualcomm.com> (sfid-20140219_162537_685007_D5CD41E3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> Retrieve the mactime of ieee80211_rx_status based on received
> data frame. The value is obtained from the htt_rx_indication_ppdu
> structure and only available in 32-bit.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Why? Where do you need tsf exactly? And what bug are you actually fixing
here?

> --- a/drivers/net/wireless/ath/ath10k/txrx.c
> +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> @@ -258,6 +258,12 @@ void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
>  	status->band = ch->band;
>  	status->freq = ch->center_freq;
>  
> +	if (info->rate.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
> +		/* TSF available only in 32-bit */
> +		status->mactime = info->tsf & 0xffffffff;
> +		status->flag |= RX_FLAG_MACTIME_END;
> +	}

Do we get some regressions because of proving only a 32 bit TSF? Which
one is better, provide a 32-bit TSF or not at all?

-- 
Kalle Valo
