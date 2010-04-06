Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:47721 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab0DFNSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 09:18:06 -0400
Received: by qyk9 with SMTP id 9so2143506qyk.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 06:18:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19387.1459.438884.832345@gargle.gargle.HOWL>
References: <19387.1459.438884.832345@gargle.gargle.HOWL>
Date: Tue, 6 Apr 2010 21:18:03 +0800
Message-ID: <p2od82e647a1004060618vc8b95400hbaf1cfaecc2defd3@mail.gmail.com>
Subject: Re: [PATCH 1/5] ath9k_htc: Protect RX stream variables
From: Ming Lei <tom.leiming@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/6 Sujith <Sujith.Manoharan@atheros.com>:
> Use a spin lock to prevent concurrent access
> to variables dealing with RX stream mode handling.

which variables are needed to be protected?

It seems hif_dev->rx_transfer_len, hif_dev->remain_skb
and hif_dev->rx_pkt_len are only accessed in ath9k_hif_usb_rx_stream,
which is only called in hard irq(urb->complete) context and now is
serialized strictly, so the protection is useless, isn't it?

> Currently, no protection is implemented - which
> causes problems in RX.

which problems? Could you describe them in detail?

Thanks,

>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c |    8 ++++++++
>  drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
>  2 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 3afc747..8838cdf 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -330,6 +330,8 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>        u16 pkt_len, pkt_tag, pool_index = 0;
>        u8 *ptr;
>
> +       spin_lock(&hif_dev->rx_lock);
> +
>        rx_remain_len = hif_dev->rx_remain_len;
>        rx_pkt_len = hif_dev->rx_transfer_len;
>
> @@ -356,6 +358,8 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>                }
>        }
>
> +       spin_unlock(&hif_dev->rx_lock);
> +
>        while (index < len) {
>                ptr = (u8 *) skb->data;
>
> @@ -373,6 +377,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>                        index = index + 4 + pkt_len + pad_len;
>
>                        if (index > MAX_RX_BUF_SIZE) {
> +                               spin_lock(&hif_dev->rx_lock);
>                                hif_dev->rx_remain_len = index - MAX_RX_BUF_SIZE;
>                                hif_dev->rx_transfer_len =
>                                        MAX_RX_BUF_SIZE - chk_idx - 4;
> @@ -384,6 +389,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>                                        dev_err(&hif_dev->udev->dev,
>                                        "ath9k_htc: RX memory allocation"
>                                        " error\n");
> +                                       spin_unlock(&hif_dev->rx_lock);
>                                        goto err;
>                                }
>                                skb_reserve(nskb, 32);
> @@ -394,6 +400,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>
>                                /* Record the buffer pointer */
>                                hif_dev->remain_skb = nskb;
> +                               spin_unlock(&hif_dev->rx_lock);
>                        } else {
>                                nskb = __dev_alloc_skb(pkt_len + 32, GFP_ATOMIC);
>                                if (!nskb) {
> @@ -612,6 +619,7 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
>        int i, ret;
>
>        init_usb_anchor(&hif_dev->rx_submitted);
> +       spin_lock_init(&hif_dev->rx_lock);
>
>        for (i = 0; i < MAX_RX_URB_NUM; i++) {
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
> index ea9257b..ed9708c 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.h
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
> @@ -93,6 +93,7 @@ struct hif_device_usb {
>        int rx_pkt_len;
>        int rx_transfer_len;
>        int rx_pad_len;
> +       spinlock_t rx_lock;
>        u8 flags; /* HIF_USB_* */
>  };
>
> --
> 1.7.0.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Lei Ming
