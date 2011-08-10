Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50261 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab1HJSbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 14:31:11 -0400
Received: by mail-gy0-f174.google.com with SMTP id 6so844248gya.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 11:31:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312983144-16156-2-git-send-email-sgruszka@redhat.com>
References: <1312983144-16156-1-git-send-email-sgruszka@redhat.com>
	<1312983144-16156-2-git-send-email-sgruszka@redhat.com>
Date: Wed, 10 Aug 2011 20:31:10 +0200
Message-ID: <CAOZOX0Vq0oWQnUuF0+k4BJNoA5CAfCa=KJZQG7KYMDfuY0iChg@mail.gmail.com> (sfid-20110810_203114_968953_33879BF4)
Subject: Re: [PATCH 2/3] rt2x00: fix order of entry flags modification
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 3:32 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> In rt2800usb_work_txdone we check flags in order:
>
> - ENTRY_OWNER_DEVICE_DATA
> - ENTRY_DATA_STATUS_PENDING
> - ENTRY_DATA_IO_FAILED
>
> Modify flags in separate order in rt2x00usb_interrupt_txdone, to avoid
> processing entries in _txdone with wrong flags or skip processing
> ready entries.
>
> Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
> Cc: stable@kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00usb.c |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index b6b4542..7fbb55c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -262,23 +262,20 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
>        struct queue_entry *entry = (struct queue_entry *)urb->context;
>        struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>
> -       if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
> +       if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
>                return;
> -
> -       if (rt2x00dev->ops->lib->tx_dma_done)
> -               rt2x00dev->ops->lib->tx_dma_done(entry);
> -
> -       /*
> -        * Report the frame as DMA done
> -        */
> -       rt2x00lib_dmadone(entry);
> -
>        /*
>         * Check if the frame was correctly uploaded
>         */
>        if (urb->status)
>                set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
> +       /*
> +        * Report the frame as DMA done
> +        */
> +       rt2x00lib_dmadone(entry);
>
> +       if (rt2x00dev->ops->lib->tx_dma_done)
> +               rt2x00dev->ops->lib->tx_dma_done(entry);
>        /*
>         * Schedule the delayed work for reading the TX status
>         * from the device.
> --
> 1.7.1
>
>
