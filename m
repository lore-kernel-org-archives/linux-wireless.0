Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56607 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbbBRUXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 15:23:18 -0500
Message-ID: <54E4F4B4.4080904@candelatech.com> (sfid-20150218_212336_586027_E75717E2)
Date: Wed, 18 Feb 2015 12:23:16 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Increase AST table SKID length limit
References: <1423841776-16288-1-git-send-email-sjegadee@qti.qualcomm.com>
In-Reply-To: <1423841776-16288-1-git-send-email-sjegadee@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have you tried testing this with 30+ stations
associated and streaming data, and with other traffic on
nearby channels (say, channel 1 and 6)?

We see bad performance drop-off when we set number-of-peers above
100 (with CT firmware).  My kernel will set AST skid limit to number-of-peers + number-of-vdevs.

Performance is best at 32 peers or less (so skid is about 40).

I am wondering if the root cause is firmware/hardware walking the full skid-length for pkts
from un-associated peers on same (or neighbouring) channels, or maybe unlucky hash distribution
in existing peers?

Thanks,
Ben


On 02/13/2015 07:36 AM, SenthilKumar Jegadeesan wrote:
> The current SKID length configuration causes firmware
> to reject peer creation for not able to allocate
> AST entries for peers. This issue is observed when
> least significant 3 bytes are used ramdomly to create
> client MAC addresses.
> 
> AST table SKID length configuration is increased to
> maximum value to fix this issue.
> 
> Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/hw.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index 460771f..7f04645 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -223,7 +223,7 @@ struct ath10k_pktlog_hdr {
>  #define TARGET_10X_NUM_WDS_ENTRIES		32
>  #define TARGET_10X_DMA_BURST_SIZE		0
>  #define TARGET_10X_MAC_AGGR_DELIM		0
> -#define TARGET_10X_AST_SKID_LIMIT		16
> +#define TARGET_10X_AST_SKID_LIMIT		128
>  #define TARGET_10X_NUM_STATIONS			128
>  #define TARGET_10X_NUM_PEERS			((TARGET_10X_NUM_STATIONS) + \
>  						 (TARGET_10X_NUM_VDEVS))
> --
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

