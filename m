Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:28448 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935860AbYCFSNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 13:13:09 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3928397ugc.16
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2008 10:13:06 -0800 (PST)
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [RFC] mac80211: handling Qdisc issues
Date: Thu, 6 Mar 2008 19:02:32 +0100
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	root <root@localhost.localdomain>
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
In-Reply-To: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803061902.33865.IvDoorn@gmail.com> (sfid-20080306_181338_164769_AF2874E1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

For the rt2x00 driver part of this patch I agree, it can be cleaned up here and there,
but that is something I will do after this patch is applied.

> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index 1960d93..54dbd74 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -53,7 +53,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
>  		ERROR(rt2x00dev,
>  		      "Arrived at non-free entry in the non-full queue %d.\n"
>  		      "Please file bug report to %s.\n",
> -		      control->queue, DRV_PROJECT);
> +		      skb_get_queue_mapping(skb), DRV_PROJECT);
>  		return -EINVAL;
>  	}
>  
> @@ -68,7 +68,10 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
>  	skbdesc->entry = entry;
>  
>  	memcpy(priv_tx->data, skb->data, skb->len);
> -	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
> +#if TODO
> +Is this correct??
> +#endif
> +	rt2x00lib_write_tx_desc(rt2x00dev, skb, control, queue->qid);

This is incorrect, even though it theoretically would work.
The qid != queue number, for most TX queues the value will be the same,
but the meaning of the field is different.
Resolving this issue will also be something I can fix relatively fast after this
patch is accepted and applied to wireless-testing.

>  	rt2x00queue_index_inc(queue, Q_INDEX);
>  
> @@ -175,10 +178,13 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
>  	 * If the data queue was full before the txdone handler
>  	 * we must make sure the packet queue in the mac80211 stack
>  	 * is reenabled when the txdone handler has finished.
> +	 *
> +	 * XXX: Is this correct wrt. the queue number?
>  	 */
> +#if TODO
> +#endif
>  	if (!rt2x00queue_full(entry->queue))
> -		ieee80211_wake_queue(rt2x00dev->hw, priv_tx->control.queue);
> -
> +		ieee80211_wake_queue(rt2x00dev->hw, entry->queue->qid);
>  }
>  EXPORT_SYMBOL_GPL(rt2x00pci_txdone);

See above.

> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index 063b167..604e64c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -164,9 +164,13 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
>  	 * If the data queue was full before the txdone handler
>  	 * we must make sure the packet queue in the mac80211 stack
>  	 * is reenabled when the txdone handler has finished.
> +	 *
> +	 * XXX: Is  this correct wrt. the queue number?
>  	 */
> +#if TODO
> +#endif
>  	if (!rt2x00queue_full(entry->queue))
> -		ieee80211_wake_queue(rt2x00dev->hw, priv_tx->control.queue);
> +		ieee80211_wake_queue(rt2x00dev->hw, entry->queue->qid);
>  }

See above.

>  int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
> @@ -186,7 +190,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
>  		ERROR(rt2x00dev,
>  		      "Arrived at non-free entry in the non-full queue %d.\n"
>  		      "Please file bug report to %s.\n",
> -		      control->queue, DRV_PROJECT);
> +		      skb_get_queue_mapping(skb), DRV_PROJECT);
>  		return -EINVAL;
>  	}
>  
> @@ -206,7 +210,8 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
>  	skbdesc->desc_len = queue->desc_size;
>  	skbdesc->entry = entry;
>  
> -	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
> +	rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
> +				skb_get_queue_mapping(skb));
>  
>  	/*
>  	 * USB devices cannot blindly pass the skb->len as the


