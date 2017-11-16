Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:45121 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933665AbdKPFQa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 00:16:30 -0500
MIME-Version: 1.0
In-Reply-To: <6E0D3434-F2E9-4B4D-B66E-78DE921BB2CF@holtmann.org>
References: <1510730444-3237-1-git-send-email-amitkarwar@gmail.com>
 <1510730444-3237-6-git-send-email-amitkarwar@gmail.com> <6E0D3434-F2E9-4B4D-B66E-78DE921BB2CF@holtmann.org>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 16 Nov 2017 10:46:28 +0530
Message-ID: <CAEhWJFk8eMQ22_PiyzSwn3gOJBbtSNCM5qFyiVdKSGbFB0gJTQ@mail.gmail.com> (sfid-20171116_061647_882553_4120BC27)
Subject: Re: [PATCH 5/8] Bluetooth: btrsi: add new rsi bluetooth driver
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 15, 2017 at 9:07 PM, Marcel Holtmann <marcel@holtmann.org> wrot=
e:
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
>> drivers/bluetooth/Kconfig   |  12 ++
>> drivers/bluetooth/Makefile  |   2 +
>> drivers/bluetooth/btrsi.c   | 268 ++++++++++++++++++++++++++++++++++++++=
++++++
>> drivers/bluetooth/rsi_hci.h |  51 +++++++++
>> 4 files changed, 333 insertions(+)
>> create mode 100644 drivers/bluetooth/btrsi.c
>> create mode 100644 drivers/bluetooth/rsi_hci.h
>>
>> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
>> index 60e1c7d..ca58d74 100644
>> --- a/drivers/bluetooth/Kconfig
>> +++ b/drivers/bluetooth/Kconfig
>> @@ -378,4 +378,16 @@ config BT_QCOMSMD
>>         Say Y here to compile support for HCI over Qualcomm SMD into the
>>         kernel or say M to compile as a module.
>>
>> +config BT_RSI
>> +     tristate "Redpine HCI support"
>> +     depends on BT && BT_RFCOMM
>
> the depends on BT_RFCOMM is wrong. And even the depends on BT is unneeded=
 since that is already covered with the above menu clause.
>
>
>> +     default m
>
> No. New drivers are by default off.
>
>> +     help
>> +       Redpine BT driver.
>> +       This driver handles BT traffic from upper layers and pass
>> +       to the RSI_91x coex module for further scheduling to device
>> +
>> +       Say Y here to compile support for HCI over Qualcomm SMD into the
>> +       kernel or say M to compile as a module.
>> +
>
> What I am missing is the depends on the RSI core piece that is needed.
>
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
>> index 0000000..c52f418
>> --- /dev/null
>> +++ b/drivers/bluetooth/btrsi.c
>> @@ -0,0 +1,268 @@
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
>> +static struct rsi_mod_ops rsi_bt_ops =3D {
>> +     .attach =3D rsi_hci_attach,
>> +     .detach =3D rsi_hci_detach,
>> +     .recv_pkt =3D rsi_hci_recv_pkt,
>> +};
>> +
>> +static int rsi_hci_open(struct hci_dev *hdev)
>> +{
>> +     BT_INFO("%s open\n", hdev->name);
>
> No BT_INFO here. We are not spamming dmesg with pointless information. An=
d this applies to all of these.
>
>> +
>> +     return 0;
>> +}
>> +
>> +static int rsi_hci_close(struct hci_dev *hdev)
>> +{
>> +     BT_INFO("%s closed\n", hdev->name);
>> +
>> +     return 0;
>> +}
>> +
>> +static int rsi_hci_flush(struct hci_dev *hdev)
>> +{
>> +     BT_ERR("%s flush\n", hdev->name);
>> +
>> +     return 0;
>> +}
>> +
>> +static int rsi_hci_send_pkt(struct hci_dev *hdev, struct sk_buff *skb)
>> +{
>> +     struct rsi_hci_adapter *h_adapter;
>
>                                         =3D hci_get_drvdata(dev);
>
> There is no need to do that separate.
>
>> +     struct sk_buff *new_skb =3D NULL;
>> +
>> +     int status =3D 0;
>> +
>> +     h_adapter =3D hci_get_drvdata(hdev);
>> +     if (!h_adapter) {
>> +             status =3D -EFAULT;
>> +             goto fail;
>> +     }
>
> And this error check seems unneeded since the Bluetooth core will never c=
all ->send unless it is all correctly set up.
>
>> +
>> +     if (h_adapter->fsm_state !=3D RSI_BT_FSM_DEVICE_READY) {
>> +             BT_INFO("BT Device not ready\n");
>> +             status =3D -ENODEV;
>> +             goto fail;
>> +     }
>
> Why are we registering a HCI device that might not be ready. This will be=
 a massive bug in the whole system. Also one that is not recoverable. If so=
mething goes wrong, then lets unregister the HCI device.
>
>> +
>> +     if (!test_bit(HCI_RUNNING, &hdev->flags)) {
>> +             status =3D -EBUSY;
>> +             goto fail;
>> +     }
>
> This should no longer be needed. We moved this into the core and besides =
some old USB drivers, nobody is using this anymore.
>
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
>> +
>> +     default:
>> +             dev_kfree_skb(skb);
>
> Don=E2=80=99t use dev_kfree_skb() here. I think the Bluetooth subsystem i=
s not ready for that.
>
>> +             status =3D -EILSEQ;
>> +             goto fail;
>> +     }
>> +
>> +     if (skb_headroom(skb) < RSI_HEADROOM_FOR_BT_HAL) {
>> +             /* Re-allocate one more skb with sufficent headroom */
>> +             /* Space for Descriptor (16 bytes) is required in head roo=
m */
>> +             u16 new_len =3D skb->len + RSI_HEADROOM_FOR_BT_HAL;
>> +
>> +             new_skb =3D dev_alloc_skb(new_len);
>> +             if (!new_skb) {
>> +                     dev_kfree_skb(skb);
>> +                     return -ENOMEM;
>> +             }
>> +             skb_reserve(new_skb, RSI_HEADROOM_FOR_BT_HAL);
>> +             skb_put(new_skb, skb->len);
>> +             memcpy(new_skb->data, skb->data, skb->len);
>> +             bt_cb(new_skb)->pkt_type =3D bt_cb(skb)->pkt_type;
>> +             dev_kfree_skb(skb);
>> +             skb =3D new_skb;
>
> Just allocate a new skb with proper headroom. The data part can be shared=
. Doing this fully manual is just a bad idea.
>
> I also get the feeling that long term we want to change the Bluetooth dri=
vers to specify the required SKB headroom so that they always get SKBs that=
 are large enough for their needs.
>
>> +     }
>> +     if (h_adapter->proto_ops->coex_send_pkt)
>> +             return h_adapter->proto_ops->coex_send_pkt(h_adapter->priv=
, skb,
>> +                                                       RSI_BT_Q);
>
> This is worrisome. You need to send. If this callback is not available, t=
hen better not register the HCI device at all.
>
>> +
>> +fail:
>> +     dev_kfree_skb(skb);
>> +     return status;
>> +}
>> +
>> +int rsi_hci_recv_pkt(void *priv, u8 *pkt)
>> +{
>> +     struct rsi_hci_adapter *h_adapter =3D (struct rsi_hci_adapter *)pr=
iv;
>> +     struct hci_dev *hdev =3D NULL;
>> +     struct sk_buff *skb;
>> +     int pkt_len =3D (le16_to_cpu(*(__le16 *)pkt)) & 0x0fff;
>> +     u8 queue_no =3D (le16_to_cpu(*(__le16 *)pkt) & 0x7000) >> 12;
>
> We have get_unaligned_le16 helpers for this.
>
>> +
>> +     if (h_adapter->fsm_state !=3D RSI_BT_FSM_DEVICE_READY) {
>> +             BT_INFO("BT Device not ready\n");
>> +             return 0;
>> +     }
>
> Why call this function if the device is not ready? Can that not be checke=
d and the HCI device not be registered.
>
>> +
>> +     if (queue_no =3D=3D RSI_BT_MGMT_Q) {
>> +             u8 msg_type =3D pkt[14] & 0xFF;
>> +
>> +             switch (msg_type) {
>> +             case RSI_RESULT_CONFIRM:
>> +                     BT_INFO("BT Result Confirm\n");
>> +                     return 0;
>> +             case RSI_BT_BER:
>> +                     BT_INFO("BT Ber\n");
>> +                     return 0;
>> +             case RSI_BT_CW:
>> +                     BT_INFO("BT CW\n");
>> +                     return 0;
>> +             default:
>> +                     break;
>> +             }
>> +     }
>
> How noisy is this? Also no \n required for the BT_INFO functions. And her=
e bt_dev_info is preferred anyway.
>
>> +
>> +     skb =3D dev_alloc_skb(pkt_len);
>> +     if (!skb)
>> +             return -ENOMEM;
>> +
>> +     hdev =3D h_adapter->hdev;
>> +     memcpy(skb->data, pkt + RSI_FRAME_DESC_SIZE, pkt_len);
>> +     skb_put(skb, pkt_len);
>> +     h_adapter->hdev->stat.byte_rx +=3D skb->len;
>> +
>> +     skb->dev =3D (void *)hdev;
>> +     bt_cb(skb)->pkt_type =3D pkt[14];
>> +
>> +     return hci_recv_frame(hdev, skb);
>> +}
>> +EXPORT_SYMBOL_GPL(rsi_hci_recv_pkt);
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
>> +     ops->bt_ops =3D &rsi_bt_ops;
>> +     h_adapter->fsm_state =3D RSI_BT_FSM_DEVICE_READY;
>> +
>> +     hdev =3D hci_alloc_dev();
>> +     if (!hdev) {
>> +             BT_ERR("Failed to alloc HCI device\n");
>> +             goto err;
>> +     }
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
>> +     BT_INFO("%s interface created\n", hdev->name);
>> +
>> +     h_adapter->fsm_state =3D RSI_BT_FSM_DEVICE_READY;
>> +
>> +     return 0;
>> +
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
>> +
>> +     BT_INFO("Detaching %s\n", hdev->name);
>> +
>> +     if (hdev) {
>> +             hci_unregister_dev(hdev);
>> +             hci_free_dev(hdev);
>> +             h_adapter->hdev =3D NULL;
>> +     }
>> +
>> +     kfree(h_adapter);
>> +     h_adapter->fsm_state =3D RSI_BT_FSM_DEVICE_NOT_READY;
>> +}
>> +
>> +struct rsi_mod_ops *rsi_get_hci_ops(void)
>> +{
>> +     return &rsi_bt_ops;
>> +};
>> +EXPORT_SYMBOL_GPL(rsi_get_hci_ops);
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
>> index 0000000..6f44231
>> --- /dev/null
>> +++ b/drivers/bluetooth/rsi_hci.h
>> @@ -0,0 +1,51 @@
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
>> +
>> +enum bt_fsm_state {
>> +     RSI_BT_FSM_DEVICE_NOT_READY =3D 0,
>> +     RSI_BT_FSM_DEVICE_READY,
>> +};
>> +
>> +struct rsi_hci_adapter {
>> +     void *priv;
>> +     struct rsi_proto_ops *proto_ops;
>> +     enum bt_fsm_state fsm_state;
>> +     struct hci_dev *hdev;
>> +};
>
> If they are btrsi.c specific, they should be in btrsi.c and not in a head=
er file.
>
>> +
>> +#define RSI_FRAME_DESC_SIZE          16
>> +
>> +int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops);
>> +void rsi_hci_detach(void *priv);
>> +int rsi_hci_recv_pkt(void *data, u8 *pkt);
>
> And this is the part I do not get. What is the deal with the rsi_bt_ops. =
Having both exported is pointless.

Thanks for your review.
We will prepare updated version which addresses these comments.

Regards,
Amitkumar Karwar
