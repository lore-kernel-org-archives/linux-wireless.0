Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua1-f68.google.com ([209.85.222.68]:34872 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbeHaRX5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 13:23:57 -0400
MIME-Version: 1.0
References: <1535533111-18301-1-git-send-email-siva8118@gmail.com>
In-Reply-To: <1535533111-18301-1-git-send-email-siva8118@gmail.com>
From: Siva Rebbagondla <siva8118@gmail.com>
Date: Fri, 31 Aug 2018 18:50:27 +0530
Message-ID: <CANGSkXTRHFF7VYso5-X16OL=xJMBu2ELd_CLrcBtfoSP0KdSQg@mail.gmail.com> (sfid-20180831_151646_123833_FB333989)
Subject: Re: [PATCH] Bluetooth: btrsi: fix bt tx timeout issue
To: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc: linux-bluetooth@vger.kernel.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Sasidhar Mudigonda <sasidhar.mudigonda@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 29, 2018 at 2:24 PM Siva Rebbagondla <siva8118@gmail.com> wrote:
>
> From: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
>
> observed sometimes data is coming with unaligned address from kernel
> BT stack. If unaligned address is passed, some data in payload is
> stripped when packet is loading to firmware and this results, BT
> connection timeout is happening.
>
> sh# hciconfig hci0 up
> Can't init device hci0: hci0 command 0x0c03 tx timeout
>
> Fixed this by moving the data to aligned address.
>
> Signed-off-by: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> ---
>  drivers/bluetooth/btrsi.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/bluetooth/btrsi.c b/drivers/bluetooth/btrsi.c
> index 60d1419..3951f7b 100644
> --- a/drivers/bluetooth/btrsi.c
> +++ b/drivers/bluetooth/btrsi.c
> @@ -21,8 +21,9 @@
>  #include <net/rsi_91x.h>
>  #include <net/genetlink.h>
>
> -#define RSI_HEADROOM_FOR_BT_HAL        16
> +#define RSI_DMA_ALIGN  8
>  #define RSI_FRAME_DESC_SIZE    16
> +#define RSI_HEADROOM_FOR_BT_HAL        (RSI_FRAME_DESC_SIZE + RSI_DMA_ALIGN)
>
>  struct rsi_hci_adapter {
>         void *priv;
> @@ -70,6 +71,16 @@ static int rsi_hci_send_pkt(struct hci_dev *hdev, struct sk_buff *skb)
>                 bt_cb(new_skb)->pkt_type = hci_skb_pkt_type(skb);
>                 kfree_skb(skb);
>                 skb = new_skb;
> +               if (!IS_ALIGNED((unsigned long)skb->data, RSI_DMA_ALIGN)) {
> +                       u8 *skb_data = skb->data;
> +                       int skb_len = skb->len;
> +
> +                       skb_push(skb, RSI_DMA_ALIGN);
> +                       skb_pull(skb, PTR_ALIGN(skb->data,
> +                                               RSI_DMA_ALIGN) - skb->data);
> +                       memmove(skb->data, skb_data, skb_len);
> +                       skb_trim(skb, skb_len);
> +               }
>         }
>
>         return h_adapter->proto_ops->coex_send_pkt(h_adapter->priv, skb,
> --
> 2.7.4
>
Kindly ignore this.
Instead of adding linux-kernel@vger.kernel.org, I have added
linux-wireless@vger.kernel.org, which results, this
patch is showing in linux-wireless patch work.
I will resend this patch by removing, "linux-wireless" from mailing list.

Thanks,
Siva Rebbagondla.
