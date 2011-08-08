Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:1985 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418Ab1HHUz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 16:55:58 -0400
Message-ID: <4E404D5C.30401@gmail.com> (sfid-20110808_225602_104443_947320A1)
Date: Mon, 08 Aug 2011 22:55:56 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Ivo Van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: rt2800usb: fix races in tx queue
References: <20110804124653.GB5739@redhat.com> <CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com> <20110808092914.GA2168@redhat.com> <20110808093512.GB2168@redhat.com>
In-Reply-To: <20110808093512.GB2168@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On 08/08/11 11:35, Stanislaw Gruszka wrote:
> We can perform parallel putting new entries in a queue
> (rt2x00queue_write_tx_frame()) and removing entries after
> finishing transmitting (rt2800usb_work_txdone()). There are
> cases when txdone may process an entry that was not fully
> send and nullify entry->skb. What in a result crash the kernel
> in rt2800usb_write_tx_desc() or rt2800usb_get_txwi() or other
> place where entry->skb is used.
> 
> To fix stop processing entries in txdone, which flags do not
> indicate transition was finished.
> 
> Reported-and-tested-by: Justin Piszcz <jpiszcz@lucidpixels.com>
> Cc: stable@kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Sorry for responding this late. I just didn't find the bandwidth to look at this earlier :-(

First of all, I don't think stable should be cc-ed on this particular patch. Although the ideas
of the patch are certainly applicable to the stable trees, this patch will simply not apply to
3.0 or earlier, since the code you are patching has been moved around between 3.0 and 3.1.

Second, I think it would be appropriate to split the patch in 2, or maybe 3, parts:
	1. The hunk to rt2x00usb to reverse the entry flag handling and the tx dma done handling.
	2. The hunk that checks that the entry on which the TX status is being reported has
           already been properly completed its TX done handling.
	3. The remainder, i.e. the retrying of handling a TX status report if the entry hasn't been
           fully completed its TX done handling yet. 

The code in this area has been proven to be very fragile, so I prefer to make mini changes to it in
small steps, so that we can properly bisect which change exactly has caused a problem.

See further down for more thoughts.

> ---
> v1 -> v2: remove goto 
> 
>  drivers/net/wireless/rt2x00/rt2800usb.c |   33 +++++++++++++++++++++++-------
>  drivers/net/wireless/rt2x00/rt2x00usb.c |    6 ++--
>  2 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 5075593..670a30d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -500,14 +500,14 @@ static bool rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
>  	return true;
>  }
>  
> -static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
> +static int rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>  {
>  	struct data_queue *queue;
>  	struct queue_entry *entry;
>  	u32 reg;
>  	u8 qid;
>  
> -	while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
> +	while (kfifo_peek(&rt2x00dev->txstatus_fifo, &reg)) {
>  
>  		/* TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus
>  		 * qid is guaranteed to be one of the TX QIDs
> @@ -517,6 +517,7 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>  		if (unlikely(!queue)) {
>  			WARNING(rt2x00dev, "Got TX status for an unavailable "
>  					   "queue %u, dropping\n", qid);
> +			kfifo_skip(&rt2x00dev->txstatus_fifo);
>  			continue;
>  		}
>  
> @@ -524,18 +525,32 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>  		 * Inside each queue, we process each entry in a chronological
>  		 * order. We first check that the queue is not empty.
>  		 */
> -		entry = NULL;
> -		while (!rt2x00queue_empty(queue)) {
> +		while (1) {
> +			entry = NULL;
> +
> +			if (rt2x00queue_empty(queue))
> +				break;
> +

Do we really have to change this in a while (1) loop? I really hate those kind of
loops, as it is quite easy to make an uneducated change later on and create a never
ending loop. I don't think it is necessary to change the while loop conditions, if
you just move the entry = NULL assignment to the end of the loop. Then you can keep
the original while condition.

>  			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
> +
> +			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
> +			    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags)) {
> +				WARNING(rt2x00dev, "Data pending for entry %u"
> +					"in queue %u\n", entry->entry_idx, qid);
> +				return 1;
> +			}
> +

Do we have to do this check inside the while loop?
Wouldn't it be enough to keep the loop as-is and have this check done after the while
loop, on the found entry?

>  			if (rt2800usb_txdone_entry_check(entry, reg))
>  				break;
>  		}
>  
> -		if (!entry || rt2x00queue_empty(queue))
> -			break;
> +		if (entry)
> +			rt2800_txdone_entry(entry, reg);
>  
> -		rt2800_txdone_entry(entry, reg);
> +		kfifo_skip(&rt2x00dev->txstatus_fifo);
>  	}
> +
> +	return 0;
>  }
>  
>  static void rt2800usb_work_txdone(struct work_struct *work)
> @@ -545,7 +560,8 @@ static void rt2800usb_work_txdone(struct work_struct *work)
>  	struct data_queue *queue;
>  	struct queue_entry *entry;
>  
> -	rt2800usb_txdone(rt2x00dev);
> +	if (rt2800usb_txdone(rt2x00dev))
> +		goto out;
>  
>  	/*
>  	 * Process any trailing TX status reports for IO failures,
> @@ -569,6 +585,7 @@ static void rt2800usb_work_txdone(struct work_struct *work)
>  		}
>  	}
>  
> +out:
>  	/*
>  	 * The hw may delay sending the packet after DMA complete
>  	 * if the medium is busy, thus the TX_STA_FIFO entry is
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index b6b4542..46c6d36 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -265,14 +265,14 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
>  	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
>  		return;
>  
> -	if (rt2x00dev->ops->lib->tx_dma_done)
> -		rt2x00dev->ops->lib->tx_dma_done(entry);
> -
>  	/*
>  	 * Report the frame as DMA done
>  	 */
>  	rt2x00lib_dmadone(entry);
>  
> +	if (rt2x00dev->ops->lib->tx_dma_done)
> +		rt2x00dev->ops->lib->tx_dma_done(entry);
> +
>  	/*
>  	 * Check if the frame was correctly uploaded
>  	 */

---
Gertjan
