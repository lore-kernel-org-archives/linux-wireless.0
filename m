Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51936 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab2JCKDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 06:03:19 -0400
Received: by wgbdr13 with SMTP id dr13so5977749wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2012 03:03:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349202079-14115-1-git-send-email-linville@tuxdriver.com>
References: <1349202079-14115-1-git-send-email-linville@tuxdriver.com>
Date: Wed, 3 Oct 2012 12:03:17 +0200
Message-ID: <CAL1gcdMaVLwpZRY9n3qGBzg8WcYWkUKPiF+8xmS+D6y72EvxvQ@mail.gmail.com> (sfid-20121003_120838_952870_D9F7438C)
Subject: Re: [RFC] rt2x00: check return from dma_map_single
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 2, 2012 at 8:21 PM, John W. Linville <linville@tuxdriver.com> wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
>
> dma_map_single can fail, so it's return value needs to be checked and
> handled accordingly.  Failure to do so is akin to failing to check the
> return from a kmalloc.
>
> http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> Compile tested only...can the experts take a look at how the failures
> are handled?

Next to the comment sent by Ivo (which is a comment I had as well),
see below for an additional remark.

<snip>

> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index e488b94..75b233e 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -91,20 +91,32 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp)
>                                                   skb->data,
>                                                   skb->len,
>                                                   DMA_FROM_DEVICE);
> +               if (dma_mapping_error(rt2x00dev->dev, skbdesc->skb_dma)) {
> +                       dev_kfree_skb_any(skb);
> +                       return NULL;
> +               }

Could we use an unlikely() here for the check? This code has been in
rt2x00 for several years now, and we have no reports that dma mappings
failed, so the possibility of it failing seem truly unlikely.

>                 skbdesc->flags |= SKBDESC_DMA_MAPPED_RX;
>         }
>
>         return skb;
>  }
>
> -void rt2x00queue_map_txskb(struct queue_entry *entry)
> +int rt2x00queue_map_txskb(struct queue_entry *entry)
>  {
>         struct device *dev = entry->queue->rt2x00dev->dev;
>         struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>
>         skbdesc->skb_dma =
>             dma_map_single(dev, entry->skb->data, entry->skb->len, DMA_TO_DEVICE);
> +       if (dma_mapping_error(dev, skbdesc->skb_dma)) {
> +               ERROR(entry->queue->rt2x00dev,
> +                     "rt2x00queue_map_txskb(): can't map skb\n");
> +               return -EIO;
> +       }
> +

Same as above, please use unlikely().

---
Gertjan
