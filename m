Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36382 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbbBLNNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 08:13:22 -0500
Message-ID: <54DCA6F1.90909@candelatech.com> (sfid-20150212_141326_481578_3B401AE3)
Date: Thu, 12 Feb 2015 05:13:21 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Increase AST table SKID length limit
References: <1423733322-31113-1-git-send-email-sjegadee@qti.qualcomm.com>
In-Reply-To: <1423733322-31113-1-git-send-email-sjegadee@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/12/2015 01:28 AM, SenthilKumar Jegadeesan wrote:
> The current SKID length configuration causes firmware
> to reject peer creation for not able to allocate
> AST entries for peers. This issue is observed when
> least significant 3 bytes are used ramdomly to create
> client MAC addresses.
>
> AST table SKID length configuration is increased to
> maximum value to fix this issue.

If your firmware is like 10.1, then probably AST length should
really be same as config.num_peers?

10.1 firmware definitely has same or similar issue in it's
AST table handling, for what that is worth.

Thanks,
Ben


>
> Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/hw.h  | 1 +
>   drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index 460771f..b86996e 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -254,6 +254,7 @@ struct ath10k_pktlog_hdr {
>
>   /* 10.2 parameters */
>   #define TARGET_10_2_DMA_BURST_SIZE		1
> +#define TARGET_10_2_AST_SKID_LIMIT		128
>
>   /* Target specific defines for WMI-TLV firmware */
>   #define TARGET_TLV_NUM_VDEVS			3
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index aeea1c7..13290da 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -3920,7 +3920,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
>   	config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
>   	config.num_peer_keys = __cpu_to_le32(TARGET_10X_NUM_PEER_KEYS);
>   	config.num_tids = __cpu_to_le32(TARGET_10X_NUM_TIDS);
> -	config.ast_skid_limit = __cpu_to_le32(TARGET_10X_AST_SKID_LIMIT);
> +	config.ast_skid_limit = __cpu_to_le32(TARGET_10_2_AST_SKID_LIMIT);
>   	config.tx_chain_mask = __cpu_to_le32(TARGET_10X_TX_CHAIN_MASK);
>   	config.rx_chain_mask = __cpu_to_le32(TARGET_10X_RX_CHAIN_MASK);
>   	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
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
