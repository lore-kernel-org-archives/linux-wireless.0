Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42585 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab1AIAUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 19:20:54 -0500
Message-ID: <4D28FF57.9040706@openwrt.org>
Date: Sat, 08 Jan 2011 17:20:39 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Implement rx copy-break.
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294500800-29191-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-08 8:33 AM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> This saves us constantly allocating large, multi-page
> skbs.  It should fix the order-1 allocation errors reported,
> and in a 60-vif scenario, this significantly decreases CPU
> utilization, and latency, and increases bandwidth.
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
> :100644 100644 b2497b8... ea2f67c... M	drivers/net/wireless/ath/ath9k/recv.c
>   drivers/net/wireless/ath/ath9k/recv.c |   92 ++++++++++++++++++++++-----------
>   1 files changed, 61 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index b2497b8..ea2f67c 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1702,42 +1704,70 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>   		    unlikely(tsf_lower - rs.rs_tstamp>  0x10000000))
>   			rxs->mactime += 0x100000000ULL;
>
> -		/* Ensure we always have an skb to requeue once we are done
> -		 * processing the current buffer's skb */
> -		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
> -
> -		/* If there is no memory we ignore the current RX'd frame,
> -		 * tell hardware it can give us a new frame using the old
> -		 * skb and put it at the tail of the sc->rx.rxbuf list for
> -		 * processing. */
> -		if (!requeue_skb)
> -			goto requeue;
> -
> -		/* Unmap the frame */
> -		dma_unmap_single(sc->dev, bf->bf_buf_addr,
> -				 common->rx_bufsize,
> -				 dma_type);
> +		len = rs.rs_datalen + ah->caps.rx_status_len;
> +		if (use_copybreak) {
> +			skb = netdev_alloc_skb(NULL, len);
> +			if (!skb) {
> +				skb = bf->bf_mpdu;
> +				use_copybreak = false;
> +				goto non_copybreak;
> +			}
> +		} else {
I think this should be dependent on packet size, maybe even based on the 
architecture. Especially on embedded hardware, copying large frames is 
probably quite a bit more expensive than allocating large buffers. Cache 
sizes are small, memory access takes several cycles, especially during 
concurrent DMA.
Once I'm back home, I could try a few packet size threshold to find a 
sweet spot for the typical MIPS hardware that I'm playing with. I expect 
a visible performance regression from this patch when applied as-is.

- Felix
