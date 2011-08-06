Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:44930 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1HFLGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2011 07:06:52 -0400
Received: by iye16 with SMTP id 16so5344716iye.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Aug 2011 04:06:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110804124653.GB5739@redhat.com>
References: <20110804124653.GB5739@redhat.com>
Date: Sat, 6 Aug 2011 13:06:51 +0200
Message-ID: <CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com> (sfid-20110806_130658_252165_8D600797)
Subject: Re: [PATCH] rt2x00: rt2800usb: fix races in tx queue
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Aug 4, 2011 at 2:46 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> We can perform parallel putting new entries in a queue
> (rt2x00queue_write_tx_frame()) and removing entries after finishing
> transmitting (rt2800usb_work_txdone()). There are cases when txdone
> may process an entry that was not fully send and nullify entry->skb.
> What in a result crash the kernel in rt2800usb_write_tx_desc() or
> rt2800usb_get_txwi() or other place where entry->skb is used.
>
> To fix stop processing entries in txdone, which flags do not indicate
> transition was finished.
>
> Also change flags as soon as we get confirmation transmision is done.
>
> Reported-and-tested-by: Justin Piszcz <jpiszcz@lucidpixels.com>
> Cc: stable@kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   36 ++++++++++++++++++++++--------
>  drivers/net/wireless/rt2x00/rt2x00usb.c |    6 ++--
>  2 files changed, 29 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 5075593..edd0518 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -500,14 +500,14 @@ static bool rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
>        return true;
>  }
>
> -static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
> +static int rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>  {
>        struct data_queue *queue;
>        struct queue_entry *entry;
>        u32 reg;
>        u8 qid;
>
> -       while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
> +       while (kfifo_peek(&rt2x00dev->txstatus_fifo, &reg)) {

I'm not too sure about this change, why do you need to do kfifo_peek
and add gotos to the end of the while-loop to remove the item from the queue?
There is no condition in which the obtained value from kfifo-peek
will require it to be read again later (because when the value couldn't be
handled we are throwing it away anyway using kfifo_skip).

Ivo

>                /* TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus
>                 * qid is guaranteed to be one of the TX QIDs
> @@ -517,25 +517,39 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>                if (unlikely(!queue)) {
>                        WARNING(rt2x00dev, "Got TX status for an unavailable "
>                                           "queue %u, dropping\n", qid);
> -                       continue;
> +                       goto next_reg;
>                }
>
>                /*
>                 * Inside each queue, we process each entry in a chronological
>                 * order. We first check that the queue is not empty.
>                 */
> -               entry = NULL;
> -               while (!rt2x00queue_empty(queue)) {
> +               while (1) {
> +                       entry = NULL;
> +
> +                       if (rt2x00queue_empty(queue))
> +                               break;
> +
>                        entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
> +
> +                       if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
> +                           !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags)) {
> +                               WARNING(rt2x00dev, "Data pending for entry %u"
> +                                       "in queue %u\n", entry->entry_idx, qid);
> +                               return 1;
> +                       }
> +
>                        if (rt2800usb_txdone_entry_check(entry, reg))
>                                break;
>                }
>
> -               if (!entry || rt2x00queue_empty(queue))
> -                       break;
> -
> -               rt2800_txdone_entry(entry, reg);
> +               if (entry)
> +                       rt2800_txdone_entry(entry, reg);
> +next_reg:
> +               kfifo_skip(&rt2x00dev->txstatus_fifo);
>        }
> +
> +       return 0;
>  }
>
>  static void rt2800usb_work_txdone(struct work_struct *work)
> @@ -545,7 +559,8 @@ static void rt2800usb_work_txdone(struct work_struct *work)
>        struct data_queue *queue;
>        struct queue_entry *entry;
>
> -       rt2800usb_txdone(rt2x00dev);
> +       if (rt2800usb_txdone(rt2x00dev))
> +               goto out;
>
>        /*
>         * Process any trailing TX status reports for IO failures,
> @@ -569,6 +584,7 @@ static void rt2800usb_work_txdone(struct work_struct *work)
>                }
>        }
>
> +out:
>        /*
>         * The hw may delay sending the packet after DMA complete
>         * if the medium is busy, thus the TX_STA_FIFO entry is
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index b6b4542..46c6d36 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -265,14 +265,14 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
>        if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
>                return;
>
> -       if (rt2x00dev->ops->lib->tx_dma_done)
> -               rt2x00dev->ops->lib->tx_dma_done(entry);
> -
>        /*
>         * Report the frame as DMA done
>         */
>        rt2x00lib_dmadone(entry);
>
> +       if (rt2x00dev->ops->lib->tx_dma_done)
> +               rt2x00dev->ops->lib->tx_dma_done(entry);
> +
>        /*
>         * Check if the frame was correctly uploaded
>         */
> --
> 1.7.1
>
>
