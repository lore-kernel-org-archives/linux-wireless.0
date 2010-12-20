Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39069 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab0LTLpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 06:45:43 -0500
Received: by qyj19 with SMTP id 19so3886487qyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 03:45:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292833909-20138-2-git-send-email-ismael.luceno@gmail.com>
References: <1292833909-20138-1-git-send-email-ismael.luceno@gmail.com>
	<1292833909-20138-2-git-send-email-ismael.luceno@gmail.com>
Date: Mon, 20 Dec 2010 12:45:42 +0100
Message-ID: <AANLkTikFAU=V5d8mfq5jW4H75AkQ0-faVKYiNmGooJze@mail.gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Fix panic on frame padding for rt2800 usb
 devices (due to not enough skb tailroom)
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Ismael Luceno <ismael.luceno@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>

Please add a short description why this change is needed,
I only know why because of a discussion over private mail...

> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 85185de..d284e1e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -369,7 +369,8 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
>  static void rt2800usb_write_tx_data(struct queue_entry *entry,
>                                        struct txentry_desc *txdesc)
>  {
> -       u8 padding_len;
> +       unsigned int padding_len;
> +       int err;
>
>        /*
>         * pad(1~3 bytes) is added after each 802.11 payload.
> @@ -379,8 +380,14 @@ static void rt2800usb_write_tx_data(struct queue_entry *entry,
>         *                 |<------------- tx_pkt_len ------------->|
>         */
>        padding_len = roundup(entry->skb->len + 4, 4) - entry->skb->len;
> -       memset(skb_put(entry->skb, padding_len), 0, padding_len);
>
> +       err = skb_pad(entry->skb, padding_len);
> +       if (unlikely(err)) {
> +               WARNING(entry->queue->rt2x00dev, "TX SKB padding error, out of memory\n");
> +               return;
> +       }

Please use skb_padto instead, that will actually check if the padding
is needed or not...

Ivo
