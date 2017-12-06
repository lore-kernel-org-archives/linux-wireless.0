Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:41355 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbdLFKBw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Dec 2017 05:01:52 -0500
MIME-Version: 1.0
In-Reply-To: <24DB6495-8CFF-401F-88A7-59BD03BC0C88@holtmann.org>
References: <1512114085-2615-1-git-send-email-amitkarwar@gmail.com>
 <1512114085-2615-6-git-send-email-amitkarwar@gmail.com> <24DB6495-8CFF-401F-88A7-59BD03BC0C88@holtmann.org>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Wed, 6 Dec 2017 15:31:50 +0530
Message-ID: <CAEhWJFkhxE1ykU1S0cEzUeDUPwwmR07dyhtSx2bHxuQ8xj6+aQ@mail.gmail.com> (sfid-20171206_110158_636461_764E9E67)
Subject: Re: [v3 5/8] Bluetooth: btrsi: add new rsi bluetooth driver
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 1, 2017 at 4:24 PM, Marcel Holtmann <marcel@holtmann.org> wrote=
:
> Hi Amitkumar,
>
>> Redpine bluetooth driver is a thin driver which depends on
>> 'rsi_91x' driver for transmitting and receiving packets
>> to/from device. It creates hci interface when attach() is
>> called from 'rsi_91x' module.
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>> ---
>> v3: Made BT_RSI module by default off(Marcel)
>>    Removed redundant exported function rsi_get_hci_ops()(Marcel)
>> v2: Addressed review comments from Marcel
>>    Removed unnecessary 'depends on BT && BT_RFOMM' line in Kconfig
>>    Removed redundant BT_INFO messages
>>    h_adapter initialization and declaration in a single line.
>>    Removed unnecessary error checks for HCI_RUNNING and fsm_state
>>    Allocated new skb with skb_realloc_headroom() API if headroom is not =
sufficient
>>    Used get_unaligned_le16 helpers
>>    Moved a structure and union from header file to btrsi.c file
>> ---
>> drivers/bluetooth/Kconfig   |  11 +++
>> drivers/bluetooth/Makefile  |   2 +
>> drivers/bluetooth/btrsi.c   | 211 ++++++++++++++++++++++++++++++++++++++=
++++++
>> drivers/bluetooth/rsi_hci.h |  40 +++++++++
>> include/linux/rsi_header.h  |   2 +
>> 5 files changed, 266 insertions(+)
>> create mode 100644 drivers/bluetooth/btrsi.c
>> create mode 100644 drivers/bluetooth/rsi_hci.h
>>
>> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
>> index 60e1c7d..33d7514 100644
>> --- a/drivers/bluetooth/Kconfig
>> +++ b/drivers/bluetooth/Kconfig
>> @@ -378,4 +378,15 @@ config BT_QCOMSMD
>>         Say Y here to compile support for HCI over Qualcomm SMD into the
>>         kernel or say M to compile as a module.
>>
>> +config BT_RSI
>> +     tristate "Redpine HCI support"
>> +     default n
>> +     help
>> +       Redpine BT driver.
>> +       This driver handles BT traffic from upper layers and pass
>> +       to the RSI_91x coex module for further scheduling to device
>> +
>> +       Say Y here to compile support for HCI over Redpine into the
>> +       kernel or say M to compile as a module.
>> +
>> endmenu
>> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
>> index 4e4e44d..712af83a 100644
>> --- a/drivers/bluetooth/Makefile
>> +++ b/drivers/bluetooth/Makefile
>> @@ -28,6 +28,8 @@ obj-$(CONFIG_BT_QCA)                +=3D btqca.o
>>
>> obj-$(CONFIG_BT_HCIUART_NOKIA)        +=3D hci_nokia.o
>>
>> +obj-$(CONFIG_BT_RSI)         +=3D btrsi.o
>> +
>> btmrvl-y                      :=3D btmrvl_main.o
>> btmrvl-$(CONFIG_DEBUG_FS)     +=3D btmrvl_debugfs.o
>>
>> diff --git a/drivers/bluetooth/btrsi.c b/drivers/bluetooth/btrsi.c
>> new file mode 100644
>> index 0000000..71f6f4e
>> --- /dev/null
>> +++ b/drivers/bluetooth/btrsi.c
>> @@ -0,0 +1,211 @@
>> +/**
>> + * Copyright (c) 2017 Redpine Signals Inc.
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software for=
 any
>> + * purpose with or without fee is hereby granted, provided that the abo=
ve
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRAN=
TIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE =
FOR
>> +e* ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAG=
ES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN A=
N
>> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT=
 OF
>> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
>> +#include <linux/version.h>
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include "rsi_hci.h"
>> +
>> +struct rsi_hci_adapter {
>> +     void *priv;
>> +     struct rsi_proto_ops *proto_ops;
>> +     struct hci_dev *hdev;
>> +};
>> +
>> +const struct rsi_mod_ops rsi_bt_ops =3D {
>> +     .attach =3D rsi_hci_attach,
>> +     .detach =3D rsi_hci_detach,
>> +     .recv_pkt =3D rsi_hci_recv_pkt,
>> +};
>> +EXPORT_SYMBOL(rsi_bt_ops);
>> +
>> +static int rsi_hci_open(struct hci_dev *hdev)
>> +{
>> +     return 0;
>> +}
>> +
>> +static int rsi_hci_close(struct hci_dev *hdev)
>> +{
>> +     return 0;
>> +}
>> +
>> +static int rsi_hci_flush(struct hci_dev *hdev)
>> +{
>> +     return 0;
>> +}
>> +
>> +static int rsi_hci_send_pkt(struct hci_dev *hdev, struct sk_buff *skb)
>> +{
>> +     struct rsi_hci_adapter *h_adapter =3D hci_get_drvdata(hdev);
>> +     struct sk_buff *new_skb =3D NULL;
>> +
>> +     switch (bt_cb(skb)->pkt_type) {
>> +     case HCI_COMMAND_PKT:
>> +             hdev->stat.cmd_tx++;
>> +             break;
>> +
>> +     case HCI_ACLDATA_PKT:
>> +             hdev->stat.acl_tx++;
>> +             break;
>> +
>> +     case HCI_SCODATA_PKT:
>> +             hdev->stat.sco_tx++;
>> +             break;
>> +     }
>> +
>> +     if (skb_headroom(skb) < RSI_HEADROOM_FOR_BT_HAL) {
>> +             /* Insufficient skb headroom - allocate a new skb */
>> +             new_skb =3D skb_realloc_headroom(skb, RSI_HEADROOM_FOR_BT_=
HAL);
>> +             if (unlikely(!new_skb))
>> +                     return -ENOMEM;
>> +             bt_cb(new_skb)->pkt_type =3D bt_cb(skb)->pkt_type;
>> +             kfree_skb(skb);
>> +             skb =3D new_skb;
>> +     }
>> +
>> +     return h_adapter->proto_ops->coex_send_pkt(h_adapter->priv, skb,
>> +                                                RSI_BT_Q);
>> +}
>> +
>> +int rsi_hci_recv_pkt(void *priv, u8 *pkt)
>> +{
>> +     struct rsi_hci_adapter *h_adapter =3D (struct rsi_hci_adapter *)pr=
iv;
>> +     struct hci_dev *hdev =3D h_adapter->hdev;
>> +     struct sk_buff *skb;
>> +
>> +     int pkt_len =3D get_unaligned_le16(pkt) & 0x0fff;
>> +     u8 queue_no =3D (get_unaligned_le16(pkt) & 0x7000) >> 12;
>> +
>> +     if (queue_no =3D=3D RSI_BT_MGMT_Q) {
>> +             u8 msg_type =3D pkt[14] & 0xFF;
>> +
>> +             switch (msg_type) {
>> +             case RSI_RESULT_CONFIRM:
>> +                     bt_dev_info(hdev, "BT Result Confirm");
>> +                     return 0;
>> +             case RSI_BT_BER:
>> +                     bt_dev_info(hdev, "BT Ber");
>> +                     return 0;
>> +             case RSI_BT_CW:
>> +                     bt_dev_info(hdev, "BT CW");
>> +                     return 0;
>> +             default:
>> +                     break;
>> +             }
>> +     }
>> +
>> +     skb =3D dev_alloc_skb(pkt_len);
>> +     if (!skb)
>> +             return -ENOMEM;
>> +
>> +     memcpy(skb->data, pkt + RSI_FRAME_DESC_SIZE, pkt_len);
>> +     skb_put(skb, pkt_len);
>> +     h_adapter->hdev->stat.byte_rx +=3D skb->len;
>> +
>> +     skb->dev =3D (void *)hdev;
>> +     bt_cb(skb)->pkt_type =3D pkt[14];
>> +
>> +     return hci_recv_frame(hdev, skb);
>> +}
>> +
>> +int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
>> +{
>> +     struct rsi_hci_adapter *h_adapter =3D NULL;
>> +     struct hci_dev *hdev;
>> +     int status =3D 0;
>> +
>> +     h_adapter =3D kzalloc(sizeof(*h_adapter), GFP_KERNEL);
>> +     if (!h_adapter)
>> +             return -ENOMEM;
>> +
>> +     h_adapter->priv =3D priv;
>> +     ops->set_bt_context(priv, h_adapter);
>> +     h_adapter->proto_ops =3D ops;
>> +
>> +     hdev =3D hci_alloc_dev();
>> +     if (!hdev) {
>> +             BT_ERR("Failed to alloc HCI device\n");
>> +             goto err;
>> +     }
>> +
>> +     h_adapter->hdev =3D hdev;
>> +
>> +     if (ops->get_host_intf(priv) =3D=3D RSI_HOST_INTF_SDIO)
>> +             hdev->bus =3D HCI_SDIO;
>> +     else
>> +             hdev->bus =3D HCI_USB;
>> +
>> +     hci_set_drvdata(hdev, h_adapter);
>> +     hdev->dev_type =3D HCI_PRIMARY;
>> +     hdev->open =3D rsi_hci_open;
>> +     hdev->close =3D rsi_hci_close;
>> +     hdev->flush =3D rsi_hci_flush;
>> +     hdev->send =3D rsi_hci_send_pkt;
>> +
>> +     status =3D hci_register_dev(hdev);
>> +     if (status < 0) {
>> +             BT_ERR("%s: HCI registration failed with errcode %d\n",
>> +                    __func__, status);
>> +             goto err;
>> +     }
>> +
>> +     return 0;
>> +err:
>> +     if (hdev) {
>> +             hci_unregister_dev(hdev);
>> +             hci_free_dev(hdev);
>> +             h_adapter->hdev =3D NULL;
>> +     }
>> +     kfree(h_adapter);
>> +
>> +     return -EINVAL;
>> +}
>> +
>> +void rsi_hci_detach(void *priv)
>> +{
>> +     struct rsi_hci_adapter *h_adapter =3D (struct rsi_hci_adapter *)pr=
iv;
>> +     struct hci_dev *hdev;
>> +
>> +     if (!h_adapter)
>> +             return;
>> +
>> +     hdev =3D h_adapter->hdev;
>> +     if (hdev) {
>> +             hci_unregister_dev(hdev);
>> +             hci_free_dev(hdev);
>> +             h_adapter->hdev =3D NULL;
>> +     }
>> +
>> +     kfree(h_adapter);
>> +}
>> +
>> +static int rsi_91x_bt_module_init(void)
>> +{
>> +     BT_INFO("%s: BT Module init called\n", __func__);
>> +
>> +     return 0;
>> +}
>> +
>> +static void rsi_91x_bt_module_exit(void)
>> +{
>> +     BT_INFO("%s: BT Module exit called\n", __func__);
>> +}
>> +
>> +module_init(rsi_91x_bt_module_init);
>> +module_exit(rsi_91x_bt_module_exit);
>> +MODULE_AUTHOR("Redpine Signals Inc");
>> +MODULE_DESCRIPTION("RSI BT driver");
>> +MODULE_SUPPORTED_DEVICE("RSI-BT");
>> +MODULE_LICENSE("Dual BSD/GPL");
>> diff --git a/drivers/bluetooth/rsi_hci.h b/drivers/bluetooth/rsi_hci.h
>> new file mode 100644
>> index 0000000..6fc7757
>> --- /dev/null
>> +++ b/drivers/bluetooth/rsi_hci.h
>> @@ -0,0 +1,40 @@
>> +/**
>> + * Copyright (c) 2017 Redpine Signals Inc.
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software for=
 any
>> + * purpose with or without fee is hereby granted, provided that the abo=
ve
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRAN=
TIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE =
FOR
>> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAG=
ES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN A=
N
>> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT=
 OF
>> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
>> +
>> +#ifndef __RSI_HCI_H__
>> +#define __RSI_HCI_H__
>> +
>> +#include <net/bluetooth/bluetooth.h>
>> +#include <net/bluetooth/hci_core.h>
>> +#include <linux/unaligned/le_byteshift.h>
>> +#include <linux/rsi_header.h>
>> +#include <net/genetlink.h>
>> +
>> +/* RX frame types */
>> +#define RSI_RESULT_CONFIRM                   0x80
>> +#define RSI_BT_PER                           0x10
>> +#define RSI_BT_BER                           0x11
>> +#define RSI_BT_CW                            0x12
>> +
>> +#define RSI_HEADROOM_FOR_BT_HAL      16
>
> I still like to see changes to the BT core that allows the driver to spec=
ify how headroom it needs. This can be follow up patches, but we should do =
that since reallocating the SKBs all the time is also pointless.

Ok. I will prepare follow up patch for this.

>
>> +
>> +#define RSI_FRAME_DESC_SIZE          16
>> +
>> +int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops);
>> +void rsi_hci_detach(void *priv);
>> +int rsi_hci_recv_pkt(void *data, u8 *pkt);
>> +
>> +#endif
>
> I have no idea why this header file is needed at all. Fold this into btrs=
i.c and make the rsi_hci_* functions static.

I will take care of this in v4.

>
>> diff --git a/include/linux/rsi_header.h b/include/linux/rsi_header.h
>> index 737ab4e..07d9574 100644
>> --- a/include/linux/rsi_header.h
>> +++ b/include/linux/rsi_header.h
>> @@ -51,4 +51,6 @@ struct rsi_mod_ops {
>>       void (*detach)(void *priv);
>>       int (*recv_pkt)(void *priv, u8 *msg);
>> };
>> +
>> +extern const struct rsi_mod_ops rsi_bt_ops;
>
> If you expose rsi_hci_attach via rsi_bt_ops, then there is no need for ma=
king rsi_hci_attach also public. I mentioned this in the first review as we=
ll. I do not get it. Either you expose rsi_bt_ops from this module or you e=
xpose the rsi_hci_* function, but both is totally pointless.
>

Got it. I will get rid of header file and make these functions static

Regards,
Amitkumar
