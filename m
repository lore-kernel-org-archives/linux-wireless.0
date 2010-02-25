Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:63002 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932947Ab0BYRWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 12:22:34 -0500
Message-ID: <4B86B1D8.6090802@gmail.com>
Date: Thu, 25 Feb 2010 18:22:32 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: prahal@yahoo.com
CC: John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/2] rt2x00 : hw support txdone implementation. (without
 fallback change)
References: <4B85FA66.2020503@yahoo.com>
In-Reply-To: <4B85FA66.2020503@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/10 05:19, Alban Browaeys wrote:
> This is an implementation that support WCID being the key_index coming
> from benoit without the change in the meaning of the tx fallback flag.
> 
> Ivo: in previous patch I forgot about your comment months ago against the
> fallback meaning change. This version thus avoid this change.
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---

Your commit message does not seem to explain what this change is for, and
why this change is being made (and the original patch submission doesn't
explain this as well)
What problem with the original code is being fixed with your patch?

Please include a commit message that explains these things.

>  drivers/net/wireless/rt2x00/rt2800pci.c |   86
> +++++++++++++------------------
>  1 files changed, 36 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c
> b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 7899789..46b06af 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -920,76 +920,61 @@ static void rt2800pci_txdone(struct rt2x00_dev
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
> -    u32 old_reg;
> -    unsigned int type;
> -    unsigned int index;
> -    u16 mcs, real_mcs;
> -
> +    int i;
> +    int wcid, ack, pid, tx_wcid, tx_ack, tx_pid;
> +    u16 mcs, tx_mcs;
> +   
>      /*
> -     * During each loop we will compare the freshly read
> -     * TX_STA_FIFO register value with the value read from
> -     * the previous loop. If the 2 values are equal then
> -     * we should stop processing because the chance it
> -     * quite big that the device has been unplugged and
> -     * we risk going into an endless loop.
> +     * To avoid an endlees loop, we only read the TX_STA_FIFO register up
> +     * to 256 times (this is enought to get all values from the FIFO). In
> +     * normal situation, the loop is terminated when we reach a value with
> +     * TX_STA_FIFO_VALID bit is 0.
>       */
> -    old_reg = 0;
> -
> -    while (1) {
> +   
> +    for (i=0; i<256; i++) {

Why this magical change to only try 256 times?

>          rt2800_register_read(rt2x00dev, TX_STA_FIFO, &reg);
>          if (!rt2x00_get_field32(reg, TX_STA_FIFO_VALID))
>              break;
>  
> -        if (old_reg == reg)
> -            break;
> -        old_reg = reg;
> +        wcid    = rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
> +        ack     = rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
> +        pid     = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
>  
>          /*
>           * Skip this entry when it contains an invalid
>           * queue identication number.
>           */
> -        type = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE) - 1;
> -        if (type >= QID_RX)
> +        if (pid < 1)
>              continue;
>  
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
> +                  rt2x00dev->hw->extra_tx_headroom);
> +
> +        rt2x00_desc_read(txwi, 1, &word);
> +        tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
> +        tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
> +        tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
> +
> +        if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
> +            WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");
>  

You're patch seems to remove the protection we had to detect transmitted frames
for which we didn't get a TX status confirmation. This had been added in the
past for the other rt2x00 drivers to handle real issues with the rt2x00 devices.
Why is this being removed?

>          /*
>           * Obtain the status about this packet.
> @@ -1010,10 +995,11 @@ static void rt2800pci_txdone(struct rt2x00_dev
> *rt2x00dev)
>           * we have mcs = tx_mcs - 1. So the number of
>           * retry is (tx_mcs - mcs).
>           */
> -        mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
> -        real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
> +        mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
> +        rt2x00_desc_read(txwi, 0, &word);
> +        tx_mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
>          __set_bit(TXDONE_FALLBACK, &txdesc.flags);
> -        txdesc.retry = mcs - min(mcs, real_mcs);
> +        txdesc.retry = tx_mcs - min(tx_mcs, mcs);
>  
>          rt2x00lib_txdone(entry, &txdesc);
>      }

