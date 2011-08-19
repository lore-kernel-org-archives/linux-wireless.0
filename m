Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38610 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1HSOMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 10:12:16 -0400
Received: by yxj19 with SMTP id 19so2207869yxj.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 07:12:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110819134711.GB3319@sortiz-mobl>
References: <20110819134711.GB3319@sortiz-mobl>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Fri, 19 Aug 2011 11:11:56 -0300
Message-ID: <CAEsZsEj+04734PN2731iZi_G8PomjD35C4oWBuJB0E8Le7PtkQ@mail.gmail.com> (sfid-20110819_161221_895598_C92588F1)
Subject: Re: [PATCH] NFC: Reserve tx head and tail room
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

That's ok, nice work.

Regards,
Aloisio

On Fri, Aug 19, 2011 at 10:47 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>
> We can have the NFC core layer allocating the tx head and tail
> room for the drivers and avoid 1 or more SKBs copy on write on
> the Tx path.
>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/nfc/pn533.c |   17 +++--------------
>  include/linux/nfc.h |    2 ++
>  include/net/nfc.h   |    7 ++++++-
>  net/nfc/core.c      |    6 +++++-
>  net/nfc/rawsock.c   |   13 ++++++-------
>  5 files changed, 22 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
> index c77e054..f81a93e 100644
> --- a/drivers/nfc/pn533.c
> +++ b/drivers/nfc/pn533.c
> @@ -1246,7 +1246,6 @@ static int pn533_data_exchange_tx_frame(struct pn533 *dev, struct sk_buff *skb)
>  {
>        int payload_len = skb->len;
>        struct pn533_frame *out_frame;
> -       struct sk_buff *discarded;
>        u8 tg;
>
>        nfc_dev_dbg(&dev->interface->dev, "%s - Sending %d bytes", __func__,
> @@ -1260,18 +1259,6 @@ static int pn533_data_exchange_tx_frame(struct pn533 *dev, struct sk_buff *skb)
>                return -ENOSYS;
>        }
>
> -       /* Reserving header space */
> -       if (skb_cow_head(skb, PN533_CMD_DATAEXCH_HEAD_LEN)) {
> -               nfc_dev_err(&dev->interface->dev, "Error to add header data");
> -               return -ENOMEM;
> -       }
> -
> -       /* Reserving tail space, see pn533_tx_frame_finish */
> -       if (skb_cow_data(skb, PN533_FRAME_TAIL_SIZE, &discarded) < 0) {
> -               nfc_dev_err(&dev->interface->dev, "Error to add tail data");
> -               return -ENOMEM;
> -       }
> -
>        skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN);
>        out_frame = (struct pn533_frame *) skb->data;
>
> @@ -1536,7 +1523,9 @@ static int pn533_probe(struct usb_interface *interface,
>                        | NFC_PROTO_ISO14443_MASK
>                        | NFC_PROTO_NFC_DEP_MASK;
>
> -       dev->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols);
> +       dev->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
> +                                          PN533_CMD_DATAEXCH_HEAD_LEN,
> +                                          PN533_FRAME_TAIL_SIZE);
>        if (!dev->nfc_dev)
>                goto kill_tasklet;
>
> diff --git a/include/linux/nfc.h b/include/linux/nfc.h
> index 330a4c5..c525e0b 100644
> --- a/include/linux/nfc.h
> +++ b/include/linux/nfc.h
> @@ -123,4 +123,6 @@ struct sockaddr_nfc {
>  #define NFC_SOCKPROTO_RAW      0
>  #define NFC_SOCKPROTO_MAX      1
>
> +#define NFC_HEADER_SIZE 1
> +
>  #endif /*__LINUX_NFC_H */
> diff --git a/include/net/nfc.h b/include/net/nfc.h
> index cc01303..87b51fe 100644
> --- a/include/net/nfc.h
> +++ b/include/net/nfc.h
> @@ -82,6 +82,9 @@ struct nfc_dev {
>        struct nfc_genl_data genl_data;
>        u32 supported_protocols;
>
> +       int tx_headroom;
> +       int tx_tailroom;
> +
>        struct nfc_ops *ops;
>  };
>  #define to_nfc_dev(_dev) container_of(_dev, struct nfc_dev, dev)
> @@ -89,7 +92,9 @@ struct nfc_dev {
>  extern struct class nfc_class;
>
>  struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
> -                                       u32 supported_protocols);
> +                                       u32 supported_protocols,
> +                                       int tx_headroom,
> +                                       int tx_tailroom);
>
>  /**
>  * nfc_free_device - free nfc device
> diff --git a/net/nfc/core.c b/net/nfc/core.c
> index b6fd4e1..284e2f6 100644
> --- a/net/nfc/core.c
> +++ b/net/nfc/core.c
> @@ -322,7 +322,9 @@ struct nfc_dev *nfc_get_device(unsigned idx)
>  * @supported_protocols: NFC protocols supported by the device
>  */
>  struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
> -                                       u32 supported_protocols)
> +                                       u32 supported_protocols,
> +                                       int tx_headroom,
> +                                       int tx_tailroom)
>  {
>        static atomic_t dev_no = ATOMIC_INIT(0);
>        struct nfc_dev *dev;
> @@ -345,6 +347,8 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
>
>        dev->ops = ops;
>        dev->supported_protocols = supported_protocols;
> +       dev->tx_headroom = tx_headroom;
> +       dev->tx_tailroom = tx_tailroom;
>
>        spin_lock_init(&dev->targets_lock);
>        nfc_genl_data_init(&dev->genl_data);
> diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
> index 52de84a..9fd652a 100644
> --- a/net/nfc/rawsock.c
> +++ b/net/nfc/rawsock.c
> @@ -123,11 +123,7 @@ error:
>
>  static int rawsock_add_header(struct sk_buff *skb)
>  {
> -
> -       if (skb_cow_head(skb, 1))
> -               return -ENOMEM;
> -
> -       *skb_push(skb, 1) = 0;
> +       *skb_push(skb, NFC_HEADER_SIZE) = 0;
>
>        return 0;
>  }
> @@ -197,6 +193,7 @@ static int rawsock_sendmsg(struct kiocb *iocb, struct socket *sock,
>                                        struct msghdr *msg, size_t len)
>  {
>        struct sock *sk = sock->sk;
> +       struct nfc_dev *dev = nfc_rawsock(sk)->dev;
>        struct sk_buff *skb;
>        int rc;
>
> @@ -208,11 +205,13 @@ static int rawsock_sendmsg(struct kiocb *iocb, struct socket *sock,
>        if (sock->state != SS_CONNECTED)
>                return -ENOTCONN;
>
> -       skb = sock_alloc_send_skb(sk, len, msg->msg_flags & MSG_DONTWAIT,
> -                                                                       &rc);
> +       skb = sock_alloc_send_skb(sk, len + dev->tx_headroom + dev->tx_tailroom + NFC_HEADER_SIZE,
> +                                       msg->msg_flags & MSG_DONTWAIT, &rc);
>        if (!skb)
>                return rc;
>
> +       skb_reserve(skb, dev->tx_headroom + NFC_HEADER_SIZE);
> +
>        rc = memcpy_fromiovec(skb_put(skb, len), msg->msg_iov, len);
>        if (rc < 0) {
>                kfree_skb(skb);
> --
> 1.7.5.3
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
>
