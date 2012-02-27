Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19148 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2B0RWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 12:22:49 -0500
Message-ID: <4F4BBBE5.4060101@qca.qualcomm.com> (sfid-20120227_182253_430429_239E0D6D)
Date: Mon, 27 Feb 2012 19:22:45 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Fix memory leak of rx packets in endpoint
 0
References: <1328886633-2823-1-git-send-email-vthiagar@qca.qualcomm.com> <1328886633-2823-2-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1328886633-2823-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/2012 05:10 PM, Vasanthakumar Thiagarajan wrote:
> htc_packet and htc_packet->buf_start are separately allocated
> for endpoint 0. This is different for other endpoints where
> packets are allocated as skb where htc_packet is skb->head
> and they are freed properly. Free htc_packet and htc_packet->buf_start
> separatly for endpoint 0.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/htc.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
> index c703ef9..e50cc8e 100644
> --- a/drivers/net/wireless/ath/ath6kl/htc.c
> +++ b/drivers/net/wireless/ath/ath6kl/htc.c
> @@ -2372,7 +2372,21 @@ void ath6kl_htc_flush_rx_buf(struct htc_target *target)
>  				   "htc rx flush pkt 0x%p  len %d  ep %d\n",
>  				   packet, packet->buf_len,
>  				   packet->endpoint);
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

I didn't look at the code, but my question would it be possible to use
skbs also with endpoint 0? That would be more consistent aproach than
testing for a particular endpoint.

And in the future we should get rid of that buf_start hack and use skbs
directly anyway.

Kalle
