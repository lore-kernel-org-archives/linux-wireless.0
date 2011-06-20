Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65149 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab1FTSMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 14:12:32 -0400
Received: by qyk9 with SMTP id 9so1246878qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 11:12:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110619174602.GB19934@localhost.localdomain>
References: <20110604144854.GA4865@localhost.localdomain>
	<20110604172940.GA10984@localhost.localdomain>
	<20110619174602.GB19934@localhost.localdomain>
Date: Mon, 20 Jun 2011 20:12:31 +0200
Message-ID: <BANLkTi=f6VnpVmt2Mr=83eve2M1vxpGSpw@mail.gmail.com> (sfid-20110620_201236_770517_11DE2476)
Subject: Re: [PATCH 1/2] rt2x00: fix possible memory corruption in case of
 invalid rxdesc.size
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 19, 2011 at 7:46 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> Sometimes rxdesc descriptor provided by hardware contains invalid
> (random) data. For example rxdesc.size can be bigger than actual
> size of the buffer. When this happen rt2x00crypto_rx_insert_iv()
> corrupt memory doing memmove outside of buffer boundaries.
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 939821b..0955c94 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -583,6 +583,18 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
>        rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
>
>        /*
> +        * Check for valid size in case we get corrupted descriptor from
> +        * hardware.
> +        */
> +       if (unlikely(rxdesc.size == 0 ||
> +                    rxdesc.size > entry->queue->data_size)) {
> +               WARNING(rt2x00dev, "Wrong frame size %d max %d.\n",
> +                       rxdesc.size, entry->queue->data_size);
> +               dev_kfree_skb(entry->skb);
> +               goto renew_skb;
> +       }
> +
> +       /*
>         * The data behind the ieee80211 header must be
>         * aligned on a 4 byte boundary.
>         */
> @@ -642,6 +654,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
>
>        ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
>
> +renew_skb:
>        /*
>         * Replace the skb with the freshly allocated one.
>         */
> --
> 1.7.4
>
>
