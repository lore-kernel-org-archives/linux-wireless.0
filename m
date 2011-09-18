Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33366 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab1IRIWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 04:22:30 -0400
Received: by gxk6 with SMTP id 6so2978623gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 01:22:30 -0700 (PDT)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v2 4/4 RESEND] NFC: driver for TI shared transport
Date: Sun, 18 Sep 2011 11:19:36 +0300
Message-Id: <1316333976-30388-5-git-send-email-ilane@ti.com> (sfid-20110918_102234_882088_F5C5ACC4)
In-Reply-To: <1316333976-30388-1-git-send-email-ilane@ti.com>
References: <1316333976-30388-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 drivers/nfc/Kconfig     |   11 ++
 drivers/nfc/Makefile    |    1 +
 drivers/nfc/nfcwilink.c |  342 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 354 insertions(+), 0 deletions(-)
 create mode 100644 drivers/nfc/nfcwilink.c

diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index 2acff43..8a56fd3 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -27,4 +27,15 @@ config NFC_PN533
 	  Say Y here to compile support for PN533 devices into the
 	  kernel or say M to compile it as module (pn533).
 
+config NFC_WILINK
+	tristate "Texas Instruments NFC WiLink driver"
+	depends on TI_ST
+	help
+	  This enables the NFC driver for Texas Instrument's BT/FM/GPS/NFC
+	  combo devices. This makes use of shared transport line discipline
+	  core driver to communicate with the NFC core of the combo chip.
+
+	  Say Y here to compile support for Texas Instrument's NFC WiLink driver
+	  into the kernel or say M to compile it as module.
+
 endmenu
diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index 8ef446d..ab99e85 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -4,5 +4,6 @@
 
 obj-$(CONFIG_PN544_NFC)		+= pn544.o
 obj-$(CONFIG_NFC_PN533)		+= pn533.o
+obj-$(CONFIG_NFC_WILINK)	+= nfcwilink.o
 
 ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
new file mode 100644
index 0000000..5b0f1ff
--- /dev/null
+++ b/drivers/nfc/nfcwilink.c
@@ -0,0 +1,342 @@
+/*
+ *  Texas Instrument's NFC Driver For Shared Transport.
+ *
+ *  NFC Driver acts as interface between NCI core and
+ *  TI Shared Transport Layer.
+ *
+ *  Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ *  Written by Ilan Elias <ilane@ti.com>
+ *
+ *  Acknowledgements:
+ *  This file is based on btwilink.c, which was written
+ *  by Raja Mani and Pavan Savoy.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+#include <linux/platform_device.h>
+#include <linux/nfc.h>
+#include <net/nfc/nci.h>
+#include <net/nfc/nci_core.h>
+#include <linux/ti_wilink_st.h>
+
+#define NFCWILINK_CHNL			12
+#define NFCWILINK_OPCODE		7
+#define NFCWILINK_MAX_FRAME_SIZE	300
+#define NFCWILINK_HDR_LEN		4
+#define NFCWILINK_OFFSET_LEN_IN_HDR	1
+#define NFCWILINK_LEN_SIZE		2
+#define NFCWILINK_REGISTER_TIMEOUT	8000	/* 8 sec */
+
+struct nfcwilink_hdr {
+	u8 chnl;
+	u8 opcode;
+	u16 len;
+} __packed;
+
+struct nfcwilink {
+	struct platform_device		*pdev;
+	struct nci_dev			*ndev;
+	unsigned long			flags;
+
+	char				st_register_cb_status;
+	long				(*st_write) (struct sk_buff *);
+	struct completion		st_register_completed;
+};
+
+/* NFCWILINK driver flags */
+enum {
+	NFCWILINK_RUNNING,
+};
+
+/* Called by ST when registration is complete */
+static void nfcwilink_register_complete(void *priv_data, char data)
+{
+	struct nfcwilink *drv = priv_data;
+
+	nfc_dev_dbg(&drv->pdev->dev, "register_complete entry");
+
+	/* store ST registration status */
+	drv->st_register_cb_status = data;
+
+	/* complete the wait in nfc_st_open() */
+	complete(&drv->st_register_completed);
+}
+
+/* Called by ST when receive data is available */
+static long nfcwilink_receive(void *priv_data, struct sk_buff *skb)
+{
+	struct nfcwilink *drv = priv_data;
+	int rc;
+
+	nfc_dev_dbg(&drv->pdev->dev, "receive entry, len %d", skb->len);
+
+	if (!skb)
+		return -EFAULT;
+
+	if (!drv) {
+		kfree_skb(skb);
+		return -EFAULT;
+	}
+
+	/* strip the ST header
+	(apart for the chnl byte, which is not received in the hdr) */
+	skb_pull(skb, (NFCWILINK_HDR_LEN-1));
+
+	skb->dev = (void *) drv->ndev;
+
+	/* Forward skb to NCI core layer */
+	rc = nci_recv_frame(skb);
+	if (rc < 0) {
+		nfc_dev_err(&drv->pdev->dev, "nci_recv_frame failed %d", rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+/* protocol structure registered with ST */
+static struct st_proto_s nfcwilink_proto = {
+	.chnl_id = NFCWILINK_CHNL,
+	.max_frame_size = NFCWILINK_MAX_FRAME_SIZE,
+	.hdr_len = (NFCWILINK_HDR_LEN-1),	/* not including chnl byte */
+	.offset_len_in_hdr = NFCWILINK_OFFSET_LEN_IN_HDR,
+	.len_size = NFCWILINK_LEN_SIZE,
+	.reserve = 0,
+	.recv = nfcwilink_receive,
+	.reg_complete_cb = nfcwilink_register_complete,
+	.write = NULL,
+};
+
+static int nfcwilink_open(struct nci_dev *ndev)
+{
+	struct nfcwilink *drv = nci_get_drvdata(ndev);
+	unsigned long comp_ret;
+	int rc;
+
+	nfc_dev_dbg(&drv->pdev->dev, "open entry");
+
+	if (test_and_set_bit(NFCWILINK_RUNNING, &drv->flags)) {
+		rc = -EBUSY;
+		goto exit;
+	}
+
+	nfcwilink_proto.priv_data = drv;
+
+	init_completion(&drv->st_register_completed);
+	drv->st_register_cb_status = -EINPROGRESS;
+
+	rc = st_register(&nfcwilink_proto);
+	if (rc < 0) {
+		if (rc == -EINPROGRESS) {
+			comp_ret = wait_for_completion_timeout(
+			&drv->st_register_completed,
+			msecs_to_jiffies(NFCWILINK_REGISTER_TIMEOUT));
+
+			nfc_dev_dbg(&drv->pdev->dev,
+			"wait_for_completion_timeout returned %ld",
+			comp_ret);
+
+			if (comp_ret == 0) {
+				/* timeout */
+				rc = -ETIMEDOUT;
+				goto clear_exit;
+			} else if (drv->st_register_cb_status != 0) {
+				rc = drv->st_register_cb_status;
+				nfc_dev_err(&drv->pdev->dev,
+				"st_register_cb failed %d", rc);
+				goto clear_exit;
+			}
+		} else {
+			nfc_dev_err(&drv->pdev->dev,
+				"st_register failed %d", rc);
+			goto clear_exit;
+		}
+	}
+
+	/* st_register MUST fill the write callback */
+	BUG_ON(nfcwilink_proto.write == NULL);
+	drv->st_write = nfcwilink_proto.write;
+
+	goto exit;
+
+clear_exit:
+	clear_bit(NFCWILINK_RUNNING, &drv->flags);
+
+exit:
+	return rc;
+}
+
+static int nfcwilink_close(struct nci_dev *ndev)
+{
+	struct nfcwilink *drv = nci_get_drvdata(ndev);
+	int rc;
+
+	nfc_dev_dbg(&drv->pdev->dev, "close entry");
+
+	if (!test_and_clear_bit(NFCWILINK_RUNNING, &drv->flags))
+		return 0;
+
+	rc = st_unregister(&nfcwilink_proto);
+	if (rc)
+		nfc_dev_err(&drv->pdev->dev, "st_unregister failed %d", rc);
+
+	drv->st_write = NULL;
+
+	return rc;
+}
+
+static int nfcwilink_send(struct sk_buff *skb)
+{
+	struct nci_dev *ndev = (struct nci_dev *)skb->dev;
+	struct nfcwilink *drv = nci_get_drvdata(ndev);
+	struct nfcwilink_hdr hdr = {NFCWILINK_CHNL, NFCWILINK_OPCODE, 0x0000};
+	long len;
+
+	nfc_dev_dbg(&drv->pdev->dev, "send entry, len %d", skb->len);
+
+	if (!test_bit(NFCWILINK_RUNNING, &drv->flags))
+		return -EBUSY;
+
+	/* add the ST hdr to the start of the buffer */
+	hdr.len = skb->len;
+	memcpy(skb_push(skb, NFCWILINK_HDR_LEN), &hdr, NFCWILINK_HDR_LEN);
+
+	/* Insert skb to shared transport layer's transmit queue.
+	 * Freeing skb memory is taken care in shared transport layer,
+	 * so don't free skb memory here.
+	 */
+	len = drv->st_write(skb);
+	if (len < 0) {
+		kfree_skb(skb);
+		nfc_dev_err(&drv->pdev->dev, "st_write failed %ld", len);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static struct nci_ops nfcwilink_ops = {
+	.open = nfcwilink_open,
+	.close = nfcwilink_close,
+	.send = nfcwilink_send,
+};
+
+static int nfcwilink_probe(struct platform_device *pdev)
+{
+	static struct nfcwilink *drv;
+	int rc;
+	u32 protocols;
+
+	nfc_dev_dbg(&pdev->dev, "probe entry");
+
+	drv = kzalloc(sizeof(struct nfcwilink), GFP_KERNEL);
+	if (!drv) {
+		rc = -ENOMEM;
+		goto exit;
+	}
+
+	drv->pdev = pdev;
+
+	protocols = NFC_PROTO_JEWEL_MASK
+			| NFC_PROTO_MIFARE_MASK | NFC_PROTO_FELICA_MASK
+			| NFC_PROTO_ISO14443_MASK
+			| NFC_PROTO_NFC_DEP_MASK;
+
+	drv->ndev = nci_allocate_device(&nfcwilink_ops,
+					protocols,
+					NFCWILINK_HDR_LEN,
+					0);
+	if (!drv->ndev) {
+		nfc_dev_err(&pdev->dev, "nci_allocate_device failed");
+		rc = -ENOMEM;
+		goto free_exit;
+	}
+
+	nci_set_parent_dev(drv->ndev, &pdev->dev);
+	nci_set_drvdata(drv->ndev, drv);
+
+	rc = nci_register_device(drv->ndev);
+	if (rc < 0) {
+		nfc_dev_err(&pdev->dev, "nci_register_device failed %d", rc);
+		goto free_dev_exit;
+	}
+
+	dev_set_drvdata(&pdev->dev, drv);
+
+	goto exit;
+
+free_dev_exit:
+	nci_free_device(drv->ndev);
+
+free_exit:
+	kfree(drv);
+
+exit:
+	return rc;
+}
+
+static int nfcwilink_remove(struct platform_device *pdev)
+{
+	struct nfcwilink *drv = dev_get_drvdata(&pdev->dev);
+	struct nci_dev *ndev;
+
+	nfc_dev_dbg(&pdev->dev, "remove entry");
+
+	if (!drv)
+		return -EFAULT;
+
+	ndev = drv->ndev;
+
+	nci_unregister_device(ndev);
+	nci_free_device(ndev);
+
+	kfree(drv);
+
+	dev_set_drvdata(&pdev->dev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver nfcwilink_driver = {
+	.probe = nfcwilink_probe,
+	.remove = nfcwilink_remove,
+	.driver = {
+		.name = "nfcwilink",
+		.owner = THIS_MODULE,
+	},
+};
+
+/* ------- Module Init/Exit interfaces ------ */
+static int __init nfcwilink_init(void)
+{
+	printk(KERN_INFO "NFC Driver for TI WiLink");
+
+	return platform_driver_register(&nfcwilink_driver);
+}
+
+static void __exit nfcwilink_exit(void)
+{
+	platform_driver_unregister(&nfcwilink_driver);
+}
+
+module_init(nfcwilink_init);
+module_exit(nfcwilink_exit);
+
+/* ------ Module Info ------ */
+
+MODULE_AUTHOR("Ilan Elias <ilane@ti.com>");
+MODULE_DESCRIPTION("NFC Driver for TI Shared Transport");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

