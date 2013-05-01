Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f176.google.com ([209.85.210.176]:35005 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3EAUGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 16:06:37 -0400
Received: by mail-ia0-f176.google.com with SMTP id l27so1654044iae.21
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 13:06:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367421455-18463-4-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
	<1367421455-18463-4-git-send-email-juhosg@openwrt.org>
Date: Wed, 1 May 2013 22:06:37 +0200
Message-ID: <CAL1gcdNwPNCnFTQY3=Tjr3nO+mvqgdbt+en=Bk_Wpo5mvZ+R4A@mail.gmail.com> (sfid-20130501_220654_387523_8B8E9C42)
Subject: Re: [PATCH 3/7] rt2x00: rt2800pci: use rt2x00dev->tx->limit
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
> the rt2800pci_txstatus_interrupt() function is
> called.
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
>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 6f4a861..330f1d2 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1014,7 +1014,7 @@ static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
>          * Since we have only one producer and one consumer we don't
>          * need to lock the kfifo.
>          */
> -       for (i = 0; i < rt2x00dev->ops->tx->entry_num; i++) {
> +       for (i = 0; i < rt2x00dev->tx->limit; i++) {
>                 rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO, &status);
>
>                 if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
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
