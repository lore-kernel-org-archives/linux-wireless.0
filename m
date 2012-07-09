Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53584 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2GIQiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 12:38:12 -0400
Received: by ghrr11 with SMTP id r11so10276565ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 09:38:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341847490-12573-1-git-send-email-sgruszka@redhat.com>
References: <1341847490-12573-1-git-send-email-sgruszka@redhat.com>
Date: Mon, 9 Jul 2012 18:38:11 +0200
Message-ID: <CAGXE3d8Y72wCOi2sA7YQTjFiGitkDcF5x4Ec0ETFZX92UBqWoA@mail.gmail.com> (sfid-20120709_183816_425900_A379AFBF)
Subject: Re: [PATCH] rt2x00: remove unused argument
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 5:24 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Data pointer on rt2x00queue_for_each_entry() is never used - remove it.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Good catch. This looks indeed unneeded ...
Helmut

> ---
>  drivers/net/wireless/rt2x00/rt2x00queue.c |   10 ++++------
>  drivers/net/wireless/rt2x00/rt2x00queue.h |    5 +----
>  drivers/net/wireless/rt2x00/rt2x00usb.c   |   20 +++++++-------------
>  3 files changed, 12 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index 2fd8301..f7e74a0 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -774,9 +774,7 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
>  bool rt2x00queue_for_each_entry(struct data_queue *queue,
>                                 enum queue_index start,
>                                 enum queue_index end,
> -                               void *data,
> -                               bool (*fn)(struct queue_entry *entry,
> -                                          void *data))
> +                               bool (*fn)(struct queue_entry *entry))
>  {
>         unsigned long irqflags;
>         unsigned int index_start;
> @@ -807,17 +805,17 @@ bool rt2x00queue_for_each_entry(struct data_queue *queue,
>          */
>         if (index_start < index_end) {
>                 for (i = index_start; i < index_end; i++) {
> -                       if (fn(&queue->entries[i], data))
> +                       if (fn(&queue->entries[i]))
>                                 return true;
>                 }
>         } else {
>                 for (i = index_start; i < queue->limit; i++) {
> -                       if (fn(&queue->entries[i], data))
> +                       if (fn(&queue->entries[i]))
>                                 return true;
>                 }
>
>                 for (i = 0; i < index_end; i++) {
> -                       if (fn(&queue->entries[i], data))
> +                       if (fn(&queue->entries[i]))
>                                 return true;
>                 }
>         }
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
> index 5f1392c..9b8c10a 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
> @@ -584,7 +584,6 @@ struct data_queue_desc {
>   * @queue: Pointer to @data_queue
>   * @start: &enum queue_index Pointer to start index
>   * @end: &enum queue_index Pointer to end index
> - * @data: Data to pass to the callback function
>   * @fn: The function to call for each &struct queue_entry
>   *
>   * This will walk through all entries in the queue, in chronological
> @@ -597,9 +596,7 @@ struct data_queue_desc {
>  bool rt2x00queue_for_each_entry(struct data_queue *queue,
>                                 enum queue_index start,
>                                 enum queue_index end,
> -                               void *data,
> -                               bool (*fn)(struct queue_entry *entry,
> -                                          void *data));
> +                               bool (*fn)(struct queue_entry *entry));
>
>  /**
>   * rt2x00queue_empty - Check if the queue is empty.
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index 74ecc33..40ea807 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -285,7 +285,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
>                 queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
>  }
>
> -static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void* data)
> +static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry)
>  {
>         struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>         struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
> @@ -390,7 +390,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
>         queue_work(rt2x00dev->workqueue, &rt2x00dev->rxdone_work);
>  }
>
> -static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void* data)
> +static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry)
>  {
>         struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>         struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
> @@ -427,18 +427,12 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
>         case QID_AC_BE:
>         case QID_AC_BK:
>                 if (!rt2x00queue_empty(queue))
> -                       rt2x00queue_for_each_entry(queue,
> -                                                  Q_INDEX_DONE,
> -                                                  Q_INDEX,
> -                                                  NULL,
> +                       rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
>                                                    rt2x00usb_kick_tx_entry);
>                 break;
>         case QID_RX:
>                 if (!rt2x00queue_full(queue))
> -                       rt2x00queue_for_each_entry(queue,
> -                                                  Q_INDEX,
> -                                                  Q_INDEX_DONE,
> -                                                  NULL,
> +                       rt2x00queue_for_each_entry(queue, Q_INDEX, Q_INDEX_DONE,
>                                                    rt2x00usb_kick_rx_entry);
>                 break;
>         default:
> @@ -447,7 +441,7 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
>  }
>  EXPORT_SYMBOL_GPL(rt2x00usb_kick_queue);
>
> -static bool rt2x00usb_flush_entry(struct queue_entry *entry, void* data)
> +static bool rt2x00usb_flush_entry(struct queue_entry *entry)
>  {
>         struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>         struct queue_entry_priv_usb *entry_priv = entry->priv_data;
> @@ -474,7 +468,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue, bool drop)
>         unsigned int i;
>
>         if (drop)
> -               rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX, NULL,
> +               rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
>                                            rt2x00usb_flush_entry);
>
>         /*
> @@ -565,7 +559,7 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
>         entry->flags = 0;
>
>         if (entry->queue->qid == QID_RX)
> -               rt2x00usb_kick_rx_entry(entry, NULL);
> +               rt2x00usb_kick_rx_entry(entry);
>  }
>  EXPORT_SYMBOL_GPL(rt2x00usb_clear_entry);
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
