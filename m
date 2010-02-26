Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:50231 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965829Ab0BZTU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 14:20:28 -0500
Message-ID: <4B881EF9.2040306@gmail.com>
Date: Fri, 26 Feb 2010 20:20:25 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: prahal@yahoo.com
CC: John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2x00: txdone implementation supporting hw encryption.
References: <4B871EA6.9050105@yahoo.com>
In-Reply-To: <4B871EA6.9050105@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/10 02:06, Alban Browaeys wrote:
> This is an implementation that support WCID being the encryption key.
> Wireless Cli Id was set to be the encryption key in rt2800pci_write_tx_desc
> and read (TX_STA_FIFO_WCID) as the current queue entry index.
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---

Thanks for bearing with us. I just have a few style issues that need to be resolved.

>  drivers/net/wireless/rt2x00/rt2800pci.c |   57
> +++++++++++++-----------------
>  1 files changed, 25 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c
> b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 0e4c417..841f973 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -907,14 +907,12 @@ static void rt2800pci_txdone(struct rt2x00_dev
> *rt2x00dev)
>  {
>      struct data_queue *queue;
>      struct queue_entry *entry;
> -    struct queue_entry *entry_done;
> -    struct queue_entry_priv_pci *entry_priv;
> +    __le32 *txwi;
>      struct txdone_entry_desc txdesc;
>      u32 word;
>      u32 reg;
>      u32 old_reg;
> -    unsigned int type;
> -    unsigned int index;
> +    int wcid, ack, pid, tx_wcid, tx_ack, tx_pid;
>      u16 mcs, real_mcs;
>  
>      /*
> @@ -936,47 +934,41 @@ static void rt2800pci_txdone(struct rt2x00_dev
> *rt2x00dev)
>              break;
>          old_reg = reg;
>  
> +        wcid    = rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
> +        ack     = rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
> +        pid     = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
> +
>          /*
>           * Skip this entry when it contains an invalid
>           * queue identication number.
>           */
> -        type = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE) - 1;
> -        if (type >= QID_RX)
> +        if (pid - 1 < 0 || pid - 1 >= QID_RX)
>              continue;
>  

How about using:
	if (pid <= 0 || pid > QID_RX)

That's a lot more readable than the current expression.


> -        queue = rt2x00queue_get_queue(rt2x00dev, type);
> +        queue = rt2x00queue_get_queue(rt2x00dev, pid - 1);
>          if (unlikely(!queue))
>              continue;
>  
>          /*
> -         * Skip this entry when it contains an invalid
> -         * index number.
> +         * Inside each queue, we process each entry in a chronological
> +         * order. We first check that the queue is not empty.
>           */
> -        index = rt2x00_get_field32(reg, TX_STA_FIFO_WCID) - 1;
> -        if (unlikely(index >= queue->limit))
> +        if (queue->length == 0)
>              continue;

Please use the rt2x00queue_empty utility function here. It's there exactly for this purpose.

> +        entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
>  
> -        entry = &queue->entries[index];
> -        entry_priv = entry->priv_data;
> -        rt2x00_desc_read((__le32 *)entry->skb->data, 0, &word);
> -
> -        entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
> -        while (entry != entry_done) {
> -            /*
> -             * Catch up.
> -             * Just report any entries we missed as failed.
> -             */
> -            WARNING(rt2x00dev,
> -                "TX status report missed for entry %d\n",
> -                entry_done->entry_idx);
> -
> -            txdesc.flags = 0;
> -            __set_bit(TXDONE_UNKNOWN, &txdesc.flags);
> -            txdesc.retry = 0;
> -
> -            rt2x00lib_txdone(entry_done, &txdesc);
> -            entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
> -        }
> +        /* Check if we got a match by looking at WCID/ACK/PID
> +         * fields */
> +        txwi = (__le32 *)(entry->skb->data -
> +                  rt2x00dev->ops->extra_tx_headroom);
> +
> +        rt2x00_desc_read(txwi, 1, &word);
> +        tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
> +        tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
> +        tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
> +
> +        if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
> +            WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");
>  
>          /*
>           * Obtain the status about this packet.
> @@ -997,6 +989,7 @@ static void rt2800pci_txdone(struct rt2x00_dev
> *rt2x00dev)
>           * we have mcs = tx_mcs - 1. So the number of
>           * retry is (tx_mcs - mcs).
>           */
> +        rt2x00_desc_read(txwi, 0, &word);
>          mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
>          real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
>          __set_bit(TXDONE_FALLBACK, &txdesc.flags);

