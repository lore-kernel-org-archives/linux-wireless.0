Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61517 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3EAUGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 16:06:07 -0400
Received: by mail-ie0-f171.google.com with SMTP id e11so2356681iej.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 13:06:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367421455-18463-3-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
	<1367421455-18463-3-git-send-email-juhosg@openwrt.org>
Date: Wed, 1 May 2013 22:06:06 +0200
Message-ID: <CAL1gcdM64iP5sQmrjxy1-pstPK1R4i0K-hy7XituqjU_3MbUmw@mail.gmail.com> (sfid-20130501_220610_578054_B4DD65F5)
Subject: Re: [PATCH 2/7] rt2x00: rt61pci: use rt2x00dev->tx->limit
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
> the rt61pci_txdone() function is called.
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
>  drivers/net/wireless/rt2x00/rt61pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 0dc8180..7e1759b 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2175,7 +2175,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
>          * that the TX_STA_FIFO stack has a size of 16. We stick to our
>          * tx ring size for now.
>          */
> -       for (i = 0; i < rt2x00dev->ops->tx->entry_num; i++) {
> +       for (i = 0; i < rt2x00dev->tx->limit; i++) {
>                 rt2x00mmio_register_read(rt2x00dev, STA_CSR4, &reg);
>                 if (!rt2x00_get_field32(reg, STA_CSR4_VALID))
>                         break;
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
