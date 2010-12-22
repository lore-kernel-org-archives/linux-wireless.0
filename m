Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:4681 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081Ab0LVTdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 14:33:03 -0500
Message-ID: <4D12526D.7080100@gmail.com>
Date: Wed, 22 Dec 2010 20:33:01 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ismael Luceno <ismael.luceno@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH v2] rt2x00: Fix panic on frame padding for rt2800 usb
 devices
References: <1292899311-20768-1-git-send-email-ismael.luceno@gmail.com>
In-Reply-To: <1292899311-20768-1-git-send-email-ismael.luceno@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/10 03:41, Ismael Luceno wrote:
> Backtrace:
>   rt2800usb_write_tx_data
>   rt2x00queue_write_tx_frame
>   rt2x00mac_tx
>   invoke_tx_handlers
>   __ieee80211_tx
>   ieee80211_tx
>   virt_to_head_page
>   ieee80211_xmit
>   ieee80211_tx_skb
>   ieee80211_scan_work
>   schedule
>   ieee80211_scan_work
>   process_one_work
>   ...
> 
> It tried to expand the skb past it's end using skb_put. So I replaced it
> with a call to skb_padto, which takes the issue into account.
> 
> Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 3e0205d..b97a4a5 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -369,7 +369,10 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
>  static void rt2800usb_write_tx_data(struct queue_entry *entry,
>  					struct txentry_desc *txdesc)
>  {
> -	u8 padding_len;
> +	unsigned int len;
> +	int err;
> +
> +	rt2800_write_tx_data(entry, txdesc);
>  
>  	/*
>  	 * pad(1~3 bytes) is added after each 802.11 payload.
> @@ -378,9 +381,14 @@ static void rt2800usb_write_tx_data(struct queue_entry *entry,
>  	 * | TXINFO | TXWI | 802.11 header | L2 pad | payload | pad | USB end pad |
>  	 *                 |<------------- tx_pkt_len ------------->|
>  	 */
> -        rt2800_write_tx_data(entry, txdesc);
> -        padding_len = roundup(entry->skb->len + 4, 4) - entry->skb->len;
> -        memset(skb_put(entry->skb, padding_len), 0, padding_len);
> +	len = roundup(entry->skb->len, 4) + 4;
> +	err = skb_padto(entry->skb, len);
> +	if (unlikely(err)) {
> +		WARNING(entry->queue->rt2x00dev, "TX SKB padding error, out of memory\n");
> +		return;
> +	}
> +
> +	entry->skb->len = len;
>  }
>  
>  /*

Why did you change the computation of the length?

To me, looking at the original code, the correct computation should be:

len = roundup(entry->skb->len + 4, 4);

Now it seems we sometimes include padding where we don't have to (and thus
potentially have to expand the buffer when we won't have to).

---
Gertjan.

