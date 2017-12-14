Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:43383 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdLNOWl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 09:22:41 -0500
MIME-Version: 1.0
In-Reply-To: <117694D2-5C98-4C40-BF02-FC1EDBF41FE8@holtmann.org>
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
 <1513168977-2121-6-git-send-email-amitkarwar@gmail.com> <117694D2-5C98-4C40-BF02-FC1EDBF41FE8@holtmann.org>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 14 Dec 2017 19:52:39 +0530
Message-ID: <CAEhWJFmg46_KGc0dTkg6iVbhSY-hko7jWt_XNEcptSCgk2xU4A@mail.gmail.com> (sfid-20171214_152246_622267_8995BC11)
Subject: Re: [v5 5/8] Bluetooth: btrsi: add new rsi bluetooth driver
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

On Wed, Dec 13, 2017 at 7:16 PM, Marcel Holtmann <marcel@holtmann.org> wrot=
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
>> v5: Addressed review comments from Marcel.
>>    Removed reduntant switch case code from rsi_hci_recv_pkt()
>>    Changed bt_cb(skb)->pkt_type to hci_skb_pkt_type(skb)
>>    Removed reduntant '\n' from BT_ERR and redundant BT_INFO messages
>>    Changed u8 *pkt to const u8 *pkt in rsi_hci_recv_pkt()
>> v4: Removed rsi_hci.h file. Made the functions static(Marcel)
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
>> drivers/bluetooth/Kconfig  |  11 +++
>> drivers/bluetooth/Makefile |   2 +
>> drivers/bluetooth/btrsi.c  | 188 +++++++++++++++++++++++++++++++++++++++=
++++++
>> include/linux/rsi_header.h |   4 +-
>> 4 files changed, 204 insertions(+), 1 deletion(-)
>> create mode 100644 drivers/bluetooth/btrsi.c
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
>
> actually I never caught this before. Since this driver is doing the HCI p=
ortion, for consistency CONFIG_BT_HCIRSI would be better.
>
>> btmrvl-y                      :=3D btmrvl_main.o
>> btmrvl-$(CONFIG_DEBUG_FS)     +=3D btmrvl_debugfs.o
>>
>> diff --git a/drivers/bluetooth/btrsi.c b/drivers/bluetooth/btrsi.c
>> new file mode 100644
>> index 0000000..c9e92cc
>> --- /dev/null
>> +++ b/drivers/bluetooth/btrsi.c
>> @@ -0,0 +1,188 @@
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
>> +#include <linux/version.h>
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <net/bluetooth/bluetooth.h>
>> +#include <net/bluetooth/hci_core.h>
>> +#include <linux/unaligned/le_byteshift.h>
>> +#include <linux/rsi_header.h>
>> +#include <net/genetlink.h>
>> +
>> +#define RSI_HEADROOM_FOR_BT_HAL      16
>> +#define RSI_FRAME_DESC_SIZE  16
>> +
>> +static struct rsi_hci_adapter {
>> +     void *priv;
>> +     struct rsi_proto_ops *proto_ops;
>> +     struct hci_dev *hdev;
>> +};
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
>> +     switch (hci_skb_pkt_type(skb)) {
>> +     case HCI_COMMAND_PKT:
>> +             hdev->stat.cmd_tx++;
>> +             break;
>> +     case HCI_ACLDATA_PKT:
>> +             hdev->stat.acl_tx++;
>> +             break;
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
>> +             bt_cb(new_skb)->pkt_type =3D hci_skb_pkt_type(skb);
>> +             kfree_skb(skb);
>> +             skb =3D new_skb;
>> +     }
>> +
>> +     return h_adapter->proto_ops->coex_send_pkt(h_adapter->priv, skb,
>> +                                                RSI_BT_Q);
>> +}
>> +
>> +static int rsi_hci_recv_pkt(void *priv, const u8 *pkt)
>> +{
>> +     struct rsi_hci_adapter *h_adapter =3D priv;
>> +     struct hci_dev *hdev =3D h_adapter->hdev;
>> +     struct sk_buff *skb;
>> +     int pkt_len =3D get_unaligned_le16(pkt) & 0x0fff;
>> +
>> +     skb =3D dev_alloc_skb(pkt_len);
>> +     if (!skb)
>> +             return -ENOMEM;
>> +
>> +     memcpy(skb->data, pkt + RSI_FRAME_DESC_SIZE, pkt_len);
>> +     skb_put(skb, pkt_len);
>> +     h_adapter->hdev->stat.byte_rx +=3D skb->len;
>> +
>> +     hci_skb_pkt_type(skb) =3D pkt[14];
>> +
>> +     return hci_recv_frame(hdev, skb);
>> +}
>> +
>> +static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
>> +{
>> +     struct rsi_hci_adapter *h_adapter =3D NULL;
>> +     struct hci_dev *hdev;
>> +     int err =3D 0;
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
>> +             BT_ERR("Failed to alloc HCI device");
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
>
> this doesn=E2=80=99t have to be in this patch, but if you support hdev->s=
et_bdaddr, hdev->set_diag etc. that would be good to add in a follow up.
>
>> +
>> +     err =3D hci_register_dev(hdev);
>> +     if (err < 0) {
>> +             BT_ERR("HCI registration failed with errcode %d", err);
>> +             hci_free_dev(hdev);
>> +             goto err;
>> +     }
>> +
>> +     return 0;
>> +err:
>> +     h_adapter->hdev =3D NULL;
>> +     kfree(h_adapter);
>> +     return -EINVAL;
>> +}
>> +
>> +static void rsi_hci_detach(void *priv)
>> +{
>> +     struct rsi_hci_adapter *h_adapter =3D priv;
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
>> +const struct rsi_mod_ops rsi_bt_ops =3D {
>> +     .attach =3D rsi_hci_attach,
>> +     .detach =3D rsi_hci_detach,
>> +     .recv_pkt =3D rsi_hci_recv_pkt,
>> +};
>> +EXPORT_SYMBOL(rsi_bt_ops);
>> +
>> +static int rsi_91x_bt_module_init(void)
>> +{
>> +     return 0;
>> +}
>> +
>> +static void rsi_91x_bt_module_exit(void)
>> +{
>> +     return;
>> +}
>> +
>> +module_init(rsi_91x_bt_module_init);
>> +module_exit(rsi_91x_bt_module_exit);
>> +MODULE_AUTHOR("Redpine Signals Inc");
>> +MODULE_DESCRIPTION("RSI BT driver");
>> +MODULE_SUPPORTED_DEVICE("RSI-BT");
>> +MODULE_LICENSE("Dual BSD/GPL=E2=80=9D);
>
> Acked-by: Marcel Holtmann <marcel@holtmann.org>
> Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
>

Thanks Marcel.
I will wait for Kalle's review and suggestions.
I will address your minor comments while preparing updated version
based on Kalle's feedback.

Regards,
Amitkumar
