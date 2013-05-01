Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60453 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3EAUHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 16:07:01 -0400
Received: by mail-ie0-f178.google.com with SMTP id aq17so2310950iec.37
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 13:07:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367421455-18463-5-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
	<1367421455-18463-5-git-send-email-juhosg@openwrt.org>
Date: Wed, 1 May 2013 22:07:00 +0200
Message-ID: <CAL1gcdMGnBCyqPofrhzb8EB13ejS5=Po4_UnDArpnStWV6Y+iQ@mail.gmail.com> (sfid-20130501_220704_545872_21C30237)
Subject: Re: [PATCH 4/7] rt2x00: rt2800usb: use rt2x00dev->rx->limit
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 1, 2013 at 5:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The RX data queue is initialized already when
> the rt2800_usb_enable_radio() function is called.
>
> Fetch the number of the queue entries from that
> instead of using the entry_num field of the data
> queue descriptor.
>
> The two values are the same, and the use of the
> rt2x00dev->rx->limit value allows us to get rid
> of a superfluous pointer dereference.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index ac854d7..c71a48d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -327,7 +327,7 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
>          * this limit so reduce the number to prevent errors.
>          */
>         rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_LIMIT,
> -                          ((rt2x00dev->ops->rx->entry_num * DATA_FRAME_SIZE)
> +                          ((rt2x00dev->rx->limit * DATA_FRAME_SIZE)
>                             / 1024) - 3);
>         rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_EN, 1);
>         rt2x00_set_field32(&reg, USB_DMA_CFG_TX_BULK_EN, 1);
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
