Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63760 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1L1Wkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 17:40:53 -0500
Received: by vcbfk14 with SMTP id fk14so9781906vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 14:40:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325033604-26469-6-git-send-email-gwingerde@gmail.com>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-2-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-3-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-4-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-5-git-send-email-gwingerde@gmail.com>
	<1325033604-26469-6-git-send-email-gwingerde@gmail.com>
Date: Wed, 28 Dec 2011 23:40:52 +0100
Message-ID: <CAOZOX0U4x8OaX=XLGbPy5wMMhm_=fiRqULoL2hh048QgaNGq6A@mail.gmail.com> (sfid-20111228_234056_043537_B9A2AAE5)
Subject: Re: [PATCH 5/7] rt2x00usb: Zero USB padding before sending URB
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	=?ISO-8859-2?Q?Jakub_Kici=F1ski?= <kubakici@wp.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 28, 2011 at 1:53 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> From: Jakub Kiciński <kubakici@wp.pl>
>
> When USB driver requires padding at the end of frame or URB it will report
> this need by increasing return value of get_tx_data_len callback. Common
> USB code uses that return value as desired URB length.
>
> Ensure that appropriate part of skb's tailroom exists and is zeroed.
>
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> --
>  drivers/net/wireless/rt2x00/rt2x00usb.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00usb.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index 1e31050..2eea386 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -298,12 +298,22 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void* data)
>                return false;
>
>        /*
> -        * USB devices cannot blindly pass the skb->len as the
> -        * length of the data to usb_fill_bulk_urb. Pass the skb
> -        * to the driver to determine what the length should be.
> +        * USB devices require certain padding at the end of each frame
> +        * and urb. Those paddings are not included in skbs. Pass entry
> +        * to the driver to determine what the overall length should be.
>         */
>        length = rt2x00dev->ops->lib->get_tx_data_len(entry);
>
> +       status = skb_padto(entry->skb, length);
> +       if (unlikely(status)) {
> +               /* TODO: report something more appropriate than IO_FAILED. */
> +               WARNING(rt2x00dev, "TX SKB padding error, out of memory\n");
> +               set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
> +               rt2x00lib_dmadone(entry);
> +
> +               return false;
> +       }
> +
>        usb_fill_bulk_urb(entry_priv->urb, usb_dev,
>                          usb_sndbulkpipe(usb_dev, entry->queue->usb_endpoint),
>                          entry->skb->data, length,
> --
> 1.7.7.4
>
