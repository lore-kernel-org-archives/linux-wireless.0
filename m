Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f173.google.com ([209.85.210.173]:36580 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3EAUFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 16:05:37 -0400
Received: by mail-ia0-f173.google.com with SMTP id 21so1674558iay.4
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 13:05:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367421455-18463-2-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
	<1367421455-18463-2-git-send-email-juhosg@openwrt.org>
Date: Wed, 1 May 2013 22:05:35 +0200
Message-ID: <CAL1gcdPfKRu9tgs5Fcf_OSQw4vabkS6e4wpSphgYCih2tYbZXA@mail.gmail.com> (sfid-20130501_220540_963368_4C12B4C5)
Subject: Re: [PATCH 1/7] rt2x00: rt2x00dev: use rt2x00dev->tx->limit
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 1, 2013 at 5:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The TX data queue is initialized already when
> the rt2x00lib_probe_hw() function is called.
>
> Fetch the number of the queue entries from that
> instead of using the entry_num field of the data
> queue descriptor.
>
> The two values are the same, and the use of the
> rt2x00dev->tx->limit value allows us to get rid
> of a superfluous pointer dereference.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 90dc143..b287467 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1077,7 +1077,7 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
>                  */
>                 int kfifo_size =
>                         roundup_pow_of_two(rt2x00dev->ops->tx_queues *
> -                                          rt2x00dev->ops->tx->entry_num *
> +                                          rt2x00dev->tx->limit *
>                                            sizeof(u32));
>
>                 status = kfifo_alloc(&rt2x00dev->txstatus_fifo, kfifo_size,
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
---
Gertjan
