Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55309 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1L1UMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 15:12:10 -0500
Received: by vbbfc26 with SMTP id fc26so9835293vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 12:12:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325033604-26469-5-git-send-email-gwingerde@gmail.com>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-2-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-3-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-4-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-5-git-send-email-gwingerde@gmail.com>
Date: Wed, 28 Dec 2011 21:12:09 +0100
Message-ID: <CAOZOX0XauBTyaBR9j75de=BeTZ1v_rRfgdJc7BPYDsA9HYi-2w@mail.gmail.com> (sfid-20111228_211214_320529_9CD99373)
Subject: Re: [PATCH 4/7] rt2800usb: Let rt2x00usb handle USB padding
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	=?ISO-8859-2?Q?Jakub_Kici=F1ski?= <kubakici@wp.pl>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 28, 2011 at 1:53 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> From: Jakub Kiciñski <kubakici@wp.pl>
>
> Older USB drivers does not append end padding to skb but instead report
> it in size of data to be transmitted to HW. rt2800usb should follow that
> behaviour. Custom write_tx_data callback which was adding pad to skb
> is not be needed any more.
>
> Thanks to this patch frames handed back from rt2800usb to mac80211 will
> no longer contain end padding.

What happened to the reports that after this (and the next) patch, the
non-2800 USB
drivers are failing?

>
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   37 ++++++++----------------------
>  1 files changed, 10 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 313cc7f..b15c215 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -400,10 +400,10 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
>        /*
>         * The size of TXINFO_W0_USB_DMA_TX_PKT_LEN is
>         * TXWI + 802.11 header + L2 pad + payload + pad,
> -        * so need to decrease size of TXINFO and USB end pad.
> +        * so need to decrease size of TXINFO.
>         */
>        rt2x00_set_field32(&word, TXINFO_W0_USB_DMA_TX_PKT_LEN,
> -                          entry->skb->len - TXINFO_DESC_SIZE - 4);
> +                          roundup(entry->skb->len, 4) - TXINFO_DESC_SIZE);
>        rt2x00_set_field32(&word, TXINFO_W0_WIV,
>                           !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags));
>        rt2x00_set_field32(&word, TXINFO_W0_QSEL, 2);
> @@ -421,37 +421,20 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
>        skbdesc->desc_len = TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
>  }
>
> -static void rt2800usb_write_tx_data(struct queue_entry *entry,
> -                                       struct txentry_desc *txdesc)
> +/*
> + * TX data initialization
> + */
> +static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
>  {
> -       unsigned int len;
> -       int err;
> -
> -       rt2800_write_tx_data(entry, txdesc);
> -
>        /*
> -        * pad(1~3 bytes) is added after each 802.11 payload.
> -        * USB end pad(4 bytes) is added at each USB bulk out packet end.
> +        * pad(1~3 bytes) is needed after each 802.11 payload.
> +        * USB end pad(4 bytes) is needed at each USB bulk out packet end.
>         * TX frame format is :
>         * | TXINFO | TXWI | 802.11 header | L2 pad | payload | pad | USB end pad |
>         *                 |<------------- tx_pkt_len ------------->|
>         */
> -       len = roundup(entry->skb->len, 4) + 4;
> -       err = skb_padto(entry->skb, len);
> -       if (unlikely(err)) {
> -               WARNING(entry->queue->rt2x00dev, "TX SKB padding error, out of memory\n");
> -               return;
> -       }
>
> -       entry->skb->len = len;
> -}
> -
> -/*
> - * TX data initialization
> - */
> -static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
> -{
> -       return entry->skb->len;
> +       return roundup(entry->skb->len, 4) + 4;
>  }
>
>  /*
> @@ -807,7 +790,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
>        .flush_queue            = rt2x00usb_flush_queue,
>        .tx_dma_done            = rt2800usb_tx_dma_done,
>        .write_tx_desc          = rt2800usb_write_tx_desc,
> -       .write_tx_data          = rt2800usb_write_tx_data,
> +       .write_tx_data          = rt2800_write_tx_data,
>        .write_beacon           = rt2800_write_beacon,
>        .clear_beacon           = rt2800_clear_beacon,
>        .get_tx_data_len        = rt2800usb_get_tx_data_len,
> --
> 1.7.7.4
>
