Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:54468 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752879AbdLMNqF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 08:46:05 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [v5 5/8] Bluetooth: btrsi: add new rsi bluetooth driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1513168977-2121-6-git-send-email-amitkarwar@gmail.com>
Date: Wed, 13 Dec 2017 14:46:02 +0100
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Message-Id: <117694D2-5C98-4C40-BF02-FC1EDBF41FE8@holtmann.org> (sfid-20171213_144634_813872_A2FBA895)
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
 <1513168977-2121-6-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,

> Redpine bluetooth driver is a thin driver which depends on
> 'rsi_91x' driver for transmitting and receiving packets
> to/from device. It creates hci interface when attach() is
> called from 'rsi_91x' module.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> ---
> v5: Addressed review comments from Marcel.
>    Removed reduntant switch case code from rsi_hci_recv_pkt()
>    Changed bt_cb(skb)->pkt_type to hci_skb_pkt_type(skb)
>    Removed reduntant '\n' from BT_ERR and redundant BT_INFO messages
>    Changed u8 *pkt to const u8 *pkt in rsi_hci_recv_pkt()
> v4: Removed rsi_hci.h file. Made the functions static(Marcel)
> v3: Made BT_RSI module by default off(Marcel)
>    Removed redundant exported function rsi_get_hci_ops()(Marcel)
> v2: Addressed review comments from Marcel
>    Removed unnecessary 'depends on BT && BT_RFOMM' line in Kconfig
>    Removed redundant BT_INFO messages
>    h_adapter initialization and declaration in a single line.
>    Removed unnecessary error checks for HCI_RUNNING and fsm_state
>    Allocated new skb with skb_realloc_headroom() API if headroom is not sufficient
>    Used get_unaligned_le16 helpers
>    Moved a structure and union from header file to btrsi.c file
> ---
> drivers/bluetooth/Kconfig  |  11 +++
> drivers/bluetooth/Makefile |   2 +
> drivers/bluetooth/btrsi.c  | 188 +++++++++++++++++++++++++++++++++++++++++++++
> include/linux/rsi_header.h |   4 +-
> 4 files changed, 204 insertions(+), 1 deletion(-)
> create mode 100644 drivers/bluetooth/btrsi.c
> 
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 60e1c7d..33d7514 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -378,4 +378,15 @@ config BT_QCOMSMD
> 	  Say Y here to compile support for HCI over Qualcomm SMD into the
> 	  kernel or say M to compile as a module.
> 
> +config BT_RSI
> +	tristate "Redpine HCI support"
> +	default n
> +	help
> +	  Redpine BT driver.
> +	  This driver handles BT traffic from upper layers and pass
> +	  to the RSI_91x coex module for further scheduling to device
> +
> +	  Say Y here to compile support for HCI over Redpine into the
> +	  kernel or say M to compile as a module.
> +
> endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index 4e4e44d..712af83a 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -28,6 +28,8 @@ obj-$(CONFIG_BT_QCA)		+= btqca.o
> 
> obj-$(CONFIG_BT_HCIUART_NOKIA)	+= hci_nokia.o
> 
> +obj-$(CONFIG_BT_RSI)		+= btrsi.o
> +

actually I never caught this before. Since this driver is doing the HCI portion, for consistency CONFIG_BT_HCIRSI would be better.

> btmrvl-y			:= btmrvl_main.o
> btmrvl-$(CONFIG_DEBUG_FS)	+= btmrvl_debugfs.o
> 
> diff --git a/drivers/bluetooth/btrsi.c b/drivers/bluetooth/btrsi.c
> new file mode 100644
> index 0000000..c9e92cc
> --- /dev/null
> +++ b/drivers/bluetooth/btrsi.c
> @@ -0,0 +1,188 @@
> +/**
> + * Copyright (c) 2017 Redpine Signals Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +#include <linux/version.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <net/bluetooth/bluetooth.h>
> +#include <net/bluetooth/hci_core.h>
> +#include <linux/unaligned/le_byteshift.h>
> +#include <linux/rsi_header.h>
> +#include <net/genetlink.h>
> +
> +#define RSI_HEADROOM_FOR_BT_HAL	16
> +#define RSI_FRAME_DESC_SIZE	16
> +
> +static struct rsi_hci_adapter {
> +	void *priv;
> +	struct rsi_proto_ops *proto_ops;
> +	struct hci_dev *hdev;
> +};
> +
> +static int rsi_hci_open(struct hci_dev *hdev)
> +{
> +	return 0;
> +}
> +
> +static int rsi_hci_close(struct hci_dev *hdev)
> +{
> +	return 0;
> +}
> +
> +static int rsi_hci_flush(struct hci_dev *hdev)
> +{
> +	return 0;
> +}
> +
> +static int rsi_hci_send_pkt(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct rsi_hci_adapter *h_adapter = hci_get_drvdata(hdev);
> +	struct sk_buff *new_skb = NULL;
> +
> +	switch (hci_skb_pkt_type(skb)) {
> +	case HCI_COMMAND_PKT:
> +		hdev->stat.cmd_tx++;
> +		break;
> +	case HCI_ACLDATA_PKT:
> +		hdev->stat.acl_tx++;
> +		break;
> +	case HCI_SCODATA_PKT:
> +		hdev->stat.sco_tx++;
> +		break;
> +	}
> +
> +	if (skb_headroom(skb) < RSI_HEADROOM_FOR_BT_HAL) {
> +		/* Insufficient skb headroom - allocate a new skb */
> +		new_skb = skb_realloc_headroom(skb, RSI_HEADROOM_FOR_BT_HAL);
> +		if (unlikely(!new_skb))
> +			return -ENOMEM;
> +		bt_cb(new_skb)->pkt_type = hci_skb_pkt_type(skb);
> +		kfree_skb(skb);
> +		skb = new_skb;
> +	}
> +
> +	return h_adapter->proto_ops->coex_send_pkt(h_adapter->priv, skb,
> +						   RSI_BT_Q);
> +}
> +
> +static int rsi_hci_recv_pkt(void *priv, const u8 *pkt)
> +{
> +	struct rsi_hci_adapter *h_adapter = priv;
> +	struct hci_dev *hdev = h_adapter->hdev;
> +	struct sk_buff *skb;
> +	int pkt_len = get_unaligned_le16(pkt) & 0x0fff;
> +
> +	skb = dev_alloc_skb(pkt_len);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	memcpy(skb->data, pkt + RSI_FRAME_DESC_SIZE, pkt_len);
> +	skb_put(skb, pkt_len);
> +	h_adapter->hdev->stat.byte_rx += skb->len;
> +
> +	hci_skb_pkt_type(skb) = pkt[14];
> +
> +	return hci_recv_frame(hdev, skb);
> +}
> +
> +static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
> +{
> +	struct rsi_hci_adapter *h_adapter = NULL;
> +	struct hci_dev *hdev;
> +	int err = 0;
> +
> +	h_adapter = kzalloc(sizeof(*h_adapter), GFP_KERNEL);
> +	if (!h_adapter)
> +		return -ENOMEM;
> +
> +	h_adapter->priv = priv;
> +	ops->set_bt_context(priv, h_adapter);
> +	h_adapter->proto_ops = ops;
> +
> +	hdev = hci_alloc_dev();
> +	if (!hdev) {
> +		BT_ERR("Failed to alloc HCI device");
> +		goto err;
> +	}
> +
> +	h_adapter->hdev = hdev;
> +
> +	if (ops->get_host_intf(priv) == RSI_HOST_INTF_SDIO)
> +		hdev->bus = HCI_SDIO;
> +	else
> +		hdev->bus = HCI_USB;
> +
> +	hci_set_drvdata(hdev, h_adapter);
> +	hdev->dev_type = HCI_PRIMARY;
> +	hdev->open = rsi_hci_open;
> +	hdev->close = rsi_hci_close;
> +	hdev->flush = rsi_hci_flush;
> +	hdev->send = rsi_hci_send_pkt;

this doesn’t have to be in this patch, but if you support hdev->set_bdaddr, hdev->set_diag etc. that would be good to add in a follow up.

> +
> +	err = hci_register_dev(hdev);
> +	if (err < 0) {
> +		BT_ERR("HCI registration failed with errcode %d", err);
> +		hci_free_dev(hdev);
> +		goto err;
> +	}
> +
> +	return 0;
> +err:
> +	h_adapter->hdev = NULL;
> +	kfree(h_adapter);
> +	return -EINVAL;
> +}
> +
> +static void rsi_hci_detach(void *priv)
> +{
> +	struct rsi_hci_adapter *h_adapter = priv;
> +	struct hci_dev *hdev;
> +
> +	if (!h_adapter)
> +		return;
> +
> +	hdev = h_adapter->hdev;
> +	if (hdev) {
> +		hci_unregister_dev(hdev);
> +		hci_free_dev(hdev);
> +		h_adapter->hdev = NULL;
> +	}
> +
> +	kfree(h_adapter);
> +}
> +
> +const struct rsi_mod_ops rsi_bt_ops = {
> +	.attach	= rsi_hci_attach,
> +	.detach	= rsi_hci_detach,
> +	.recv_pkt = rsi_hci_recv_pkt,
> +};
> +EXPORT_SYMBOL(rsi_bt_ops);
> +
> +static int rsi_91x_bt_module_init(void)
> +{
> +	return 0;
> +}
> +
> +static void rsi_91x_bt_module_exit(void)
> +{
> +	return;
> +}
> +
> +module_init(rsi_91x_bt_module_init);
> +module_exit(rsi_91x_bt_module_exit);
> +MODULE_AUTHOR("Redpine Signals Inc");
> +MODULE_DESCRIPTION("RSI BT driver");
> +MODULE_SUPPORTED_DEVICE("RSI-BT");
> +MODULE_LICENSE("Dual BSD/GPL”);

Acked-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: Marcel Holtmann <marcel@holtmann.org>

> diff --git a/include/linux/rsi_header.h b/include/linux/rsi_header.h
> index 737ab4e..040f07b 100644
> --- a/include/linux/rsi_header.h
> +++ b/include/linux/rsi_header.h
> @@ -49,6 +49,8 @@ struct rsi_proto_ops {
> struct rsi_mod_ops {
> 	int (*attach)(void *priv, struct rsi_proto_ops *ops);
> 	void (*detach)(void *priv);
> -	int (*recv_pkt)(void *priv, u8 *msg);
> +	int (*recv_pkt)(void *priv, const u8 *msg);

Think about if this is best done in this patch or one of the early patches before.

> };
> +
> +extern const struct rsi_mod_ops rsi_bt_ops;
> #endif

Regards

Marcel
