Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5872 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2BNHYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 02:24:05 -0500
Message-ID: <4F3A0C07.5030508@qca.qualcomm.com> (sfid-20120214_082409_452556_23E7299A)
Date: Tue, 14 Feb 2012 12:53:51 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Fix memory leak of rx packets in endpoint
 0
References: <1328886633-2823-1-git-send-email-vthiagar@qca.qualcomm.com> <1328886633-2823-2-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1328886633-2823-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 February 2012 08:40 PM, Vasanthakumar Thiagarajan wrote:
> htc_packet and htc_packet->buf_start are separately allocated
> for endpoint 0. This is different for other endpoints where
> packets are allocated as skb where htc_packet is skb->head
> and they are freed properly. Free htc_packet and htc_packet->buf_start
> separatly for endpoint 0.
>
> Signed-off-by: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath6kl/htc.c |   16 +++++++++++++++-
>   1 files changed, 15 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
> index c703ef9..e50cc8e 100644
> --- a/drivers/net/wireless/ath/ath6kl/htc.c
> +++ b/drivers/net/wireless/ath/ath6kl/htc.c
> @@ -2372,7 +2372,21 @@ void ath6kl_htc_flush_rx_buf(struct htc_target *target)
>   				   "htc rx flush pkt 0x%p  len %d  ep %d\n",
>   				   packet, packet->buf_len,
>   				   packet->endpoint);
> -			dev_kfree_skb(packet->pkt_cntxt);
> +			/*
> +			 * packets in rx_bufq of endpoint 0 have originally
> +			 * been queued from target->free_ctrl_rxbuf where
> +			 * packet and packet->buf_start are allocated
> +			 * separately using kmalloc(). For other endpoint
> +			 * rx_bufq, it is allocated as skb where packet is
> +			 * skb->head. Take care of this difference while freeing
> +			 * the memory.
> +			 */
> +			if (packet->endpoint == ENDPOINT_0) {
> +				kfree(packet->buf_start);
> +				kfree(packet);
> +			} else {
> +				dev_kfree_skb(packet->pkt_cntxt);
> +			}

Vasanth,

My system is freezing with this patch when i tried to unload
ath6kl_sdio.ko. Could you double check this change once again?

>   			spin_lock_bh(&target->rx_lock);
>   		}
>   		spin_unlock_bh(&target->rx_lock);
