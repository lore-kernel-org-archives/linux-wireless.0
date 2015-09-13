Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45295 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbbIMWI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 18:08:27 -0400
Message-ID: <55F5F3D9.8090005@candelatech.com> (sfid-20150914_000830_307523_9DE0070B)
Date: Sun, 13 Sep 2015 15:08:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
CC: kvalo@codeaurora.org
Subject: Re: [PATCH 4.3] ath10k: fix DMA related firmware crashes on multiple
 devices
References: <1442176540-34973-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1442176540-34973-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/13/2015 01:35 PM, Felix Fietkau wrote:
> Some platforms really don't like DMA bursts of 256 bytes, and this
> causes the firmware to crash when sending beacons.
> Also, changing this based on the firmware version does not seem to make
> much sense, so use 128 bytes for all versions.

Is there any good reason to allow users to enable this with
module-param or similar on platforms that do support it?

Like better performance perhaps?

Thanks,
Ben

>
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>   drivers/net/wireless/ath/ath10k/hw.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index 23afcda..678d72a 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -337,7 +337,7 @@ enum ath10k_hw_rate_cck {
>   #define TARGET_10X_MAX_FRAG_ENTRIES		0
>
>   /* 10.2 parameters */
> -#define TARGET_10_2_DMA_BURST_SIZE		1
> +#define TARGET_10_2_DMA_BURST_SIZE		0
>
>   /* Target specific defines for WMI-TLV firmware */
>   #define TARGET_TLV_NUM_VDEVS			4
> @@ -391,7 +391,7 @@ enum ath10k_hw_rate_cck {
>
>   #define TARGET_10_4_TX_DBG_LOG_SIZE		1024
>   #define TARGET_10_4_NUM_WDS_ENTRIES		32
> -#define TARGET_10_4_DMA_BURST_SIZE		1
> +#define TARGET_10_4_DMA_BURST_SIZE		0
>   #define TARGET_10_4_MAC_AGGR_DELIM		0
>   #define TARGET_10_4_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
>   #define TARGET_10_4_VOW_CONFIG			0
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
