Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:57673 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbYHXQHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2008 12:07:43 -0400
Message-ID: <48B1874F.2050005@lwfinger.net> (sfid-20080824_180748_057215_C30E668C)
Date: Sun, 24 Aug 2008 11:07:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] p54: take tx_queue's lock in rx_frame_sent
References: <200808240315.07032.chunkeey@web.de>
In-Reply-To: <200808240315.07032.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> p54_rx_frame_sent will alter the tx_queue. Therefore we should hold
> the lock to protect against concurrent p54_assign_address calls.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> hmm,
> 
> (looking at [GIT]: Networking debate)
> linux-next. since there is no known regression that this patch could possibly fix...
> ---
> diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
> --- a/drivers/net/wireless/p54/p54common.c	2008-08-23 21:13:37.000000000 +0200
> +++ b/drivers/net/wireless/p54/p54common.c	2008-08-24 02:11:35.000000000 +0200
> @@ -432,7 +432,9 @@ static void p54_rx_frame_sent(struct iee
>  	struct memrecord *range = NULL;
>  	u32 freed = 0;
>  	u32 last_addr = priv->rx_start;
> +	unsigned long flags;
>  
> +	spin_lock_irqsave(&priv->tx_queue.lock, flags);
>  	while (entry != (struct sk_buff *)&priv->tx_queue) {
>  		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
>  		range = (void *)info->driver_data;
> @@ -453,6 +455,8 @@ static void p54_rx_frame_sent(struct iee
>  
>  			last_addr = range->end_addr;
>  			__skb_unlink(entry, &priv->tx_queue);
> +			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
> +
>  			memset(&info->status, 0, sizeof(info->status));
>  			entry_hdr = (struct p54_control_hdr *) entry->data;
>  			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
> @@ -470,12 +474,14 @@ static void p54_rx_frame_sent(struct iee
>  			info->status.ack_signal = le16_to_cpu(payload->ack_rssi);
>  			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
>  			ieee80211_tx_status_irqsafe(dev, entry);
> -			break;
> +			goto out;
>  		} else
>  			last_addr = range->end_addr;
>  		entry = entry->next;
>  	}
> +	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
>  
> +out:
>  	if (freed >= IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
>  	    sizeof(struct p54_control_hdr))
>  		p54_wake_free_queues(dev);

I have a question about this. The code is OK, but I wonder if it might 
not be clearer if the spin_unlock_irqrestore() in the second hunk were 
deleted, and the label for "out" in the third hunk were moved up one 
statement. That way the matching lock/unlock pair would be more obvious.

Larry
