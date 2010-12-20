Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:41300 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab0LTI4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 03:56:38 -0500
Received: by bwz16 with SMTP id 16so3053553bwz.4
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 00:56:37 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ismael Luceno <ismael.luceno@gmail.com>
Subject: Re: [PATCH 1/2] rt2x00: Write the frame *after* padding (rt2800 usb devices)
Date: Mon, 20 Dec 2010 09:55:21 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <1292833909-20138-1-git-send-email-ismael.luceno@gmail.com>
In-Reply-To: <1292833909-20138-1-git-send-email-ismael.luceno@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012200955.22087.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Montag, 20. Dezember 2010 schrieb Ismael Luceno:
> Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 3e0205d..85185de 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -378,9 +378,10 @@ static void rt2800usb_write_tx_data(struct queue_entry *entry,
>  	 * | TXINFO | TXWI | 802.11 header | L2 pad | payload | pad | USB end pad |
>  	 *                 |<------------- tx_pkt_len ------------->|
>  	 */
> -        rt2800_write_tx_data(entry, txdesc);
> -        padding_len = roundup(entry->skb->len + 4, 4) - entry->skb->len;
> -        memset(skb_put(entry->skb, padding_len), 0, padding_len);
> +	padding_len = roundup(entry->skb->len + 4, 4) - entry->skb->len;
> +	memset(skb_put(entry->skb, padding_len), 0, padding_len);
> +
> +	rt2800_write_tx_data(entry, txdesc);

Could you please explain this change in more detail please?
Why is it needed? rt2800_write_tx_data only adds the TXWI to the front of the
buffer, doing that before or after the padding doesn't make a difference, no?

Thanks,
Helmut
