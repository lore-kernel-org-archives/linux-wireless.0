Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24BBECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 10:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFFD42083A
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 10:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFFD42083A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbeJQSVo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 14:21:44 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:59090 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbeJQSVn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 14:21:43 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2018 14:21:41 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 2B5B323F4E5;
        Wed, 17 Oct 2018 12:21:04 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NQdFzqJjHCqv; Wed, 17 Oct 2018 12:21:02 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPSA id EFE58242AAD;
        Wed, 17 Oct 2018 12:21:01 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH 1/3] nfc: pn533: add UART phy driver
Date:   Wed, 17 Oct 2018 12:20:35 +0200
Message-Id: <20181017102037.28537-1-poeschel@lemonage.de>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds the UART phy interface for the pn533 driver.
The pn533 driver can be used through UART interface this way.
It is implemented as a tty line discipline.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/nfc/pn533/Kconfig  |  10 +
 drivers/nfc/pn533/Makefile |   2 +
 drivers/nfc/pn533/pn533.h  |   8 +
 drivers/nfc/pn533/uart.c   | 399 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tty.h   |   1 +
 5 files changed, 420 insertions(+)
 create mode 100644 drivers/nfc/pn533/uart.c

diff --git a/drivers/nfc/pn533/Kconfig b/drivers/nfc/pn533/Kconfig
index d94122dd30e4..da3ea2dbaa8a 100644
--- a/drivers/nfc/pn533/Kconfig
+++ b/drivers/nfc/pn533/Kconfig
@@ -25,3 +25,13 @@ config NFC_PN533_I2C
 
 	  If you choose to build a module, it'll be called pn533_i2c.
 	  Say N if unsure.
+
+config NFC_PN532_UART
+	tristate "NFC PN532 device support (UART)"
+	select NFC_PN533
+	---help---
+	  This module adds support for the NXP pn532 UART interface.
+	  Select this if your platform is using the UART bus.
+
+	  If you choose to build a module, it'll be called pn532_uart.
+	  Say N if unsure.
diff --git a/drivers/nfc/pn533/Makefile b/drivers/nfc/pn533/Makefile
index 51d24c622fcb..bdfd6860d5e4 100644
--- a/drivers/nfc/pn533/Makefile
+++ b/drivers/nfc/pn533/Makefile
@@ -3,7 +3,9 @@
 #
 pn533_usb-objs  = usb.o
 pn533_i2c-objs  = i2c.o
+pn532_uart-objs  = uart.o
 
 obj-$(CONFIG_NFC_PN533)     += pn533.o
 obj-$(CONFIG_NFC_PN533_USB) += pn533_usb.o
 obj-$(CONFIG_NFC_PN533_I2C) += pn533_i2c.o
+obj-$(CONFIG_NFC_PN532_UART) += pn532_uart.o
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 88d569666c51..ca00508eefff 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -55,6 +55,11 @@
 
 /* Preamble (1), SoPC (2), ACK Code (2), Postamble (1) */
 #define PN533_STD_FRAME_ACK_SIZE 6
+/*
+ * Preamble (1), SoPC (2), Packet Length (1), Packet Length Checksum (1),
+ * Specific Application Level Error Code (1) , Postamble (1)
+ */
+#define PN533_STD_ERROR_FRAME_SIZE 8
 #define PN533_STD_FRAME_CHECKSUM(f) (f->data[f->datalen])
 #define PN533_STD_FRAME_POSTAMBLE(f) (f->data[f->datalen + 1])
 /* Half start code (3), LEN (4) should be 0xffff for extended frame */
@@ -96,6 +101,9 @@
 #define PN533_CMD_MI_MASK 0x40
 #define PN533_CMD_RET_SUCCESS 0x00
 
+#define PN533_FRAME_DATALEN_ACK 0x00
+#define PN533_FRAME_DATALEN_ERROR 0x01
+#define PN533_FRAME_DATALEN_EXTENDED 0xFF
 
 enum  pn533_protocol_type {
 	PN533_PROTO_REQ_ACK_RESP = 0,
diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
new file mode 100644
index 000000000000..b5f995988cae
--- /dev/null
+++ b/drivers/nfc/pn533/uart.c
@@ -0,0 +1,399 @@
+/*
+ * Driver for NXP PN532 NFC Chip - UART transport layer
+ *
+ * Copyright (C) 2018 Lemonage Software GmbH
+ * Author: Lars Poeschel <poeschel@lemonage.de>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/nfc.h>
+#include <linux/netdevice.h>
+#include <net/nfc/nfc.h>
+#include "pn533.h"
+
+#define VERSION "0.1"
+
+#define PN532_I2C_DRIVER_NAME "pn532_uart"
+
+#define PN532_MAGIC		0x162f
+#define PN532_UART_SKB_BUFF_LEN	(PN533_CMD_DATAEXCH_DATA_MAXLEN * 2)
+
+struct pn532_uart_phy {
+	int magic;
+	struct tty_struct *tty;
+	struct sk_buff *recv_skb;
+	struct pn533 *priv;
+	int send_wakeup;
+	struct timer_list cmd_timeout;
+	struct sk_buff *cur_out_buf;
+	struct workqueue_struct *wq_open_tty;
+	struct work_struct open_tty_work;
+	struct completion init_done;
+};
+
+static int pn532_uart_send_frame(struct pn533 *dev,
+				struct sk_buff *out)
+{
+	static const u8 wakeup[] = {
+		0x55, 0x55, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	/* wakeup sequence and dummy bytes for waiting time */
+	struct pn532_uart_phy *pn532 = dev->phy;
+	struct tty_struct *tty = pn532->tty;
+	int count;
+
+	if (pn532->priv == NULL)
+		pn532->priv = dev;
+
+	print_hex_dump_debug("PN532_uart TX: ", DUMP_PREFIX_NONE, 16, 1,
+			     out->data, out->len, false);
+
+	pn532->cur_out_buf = out;
+	set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+	if (pn532->send_wakeup)
+		count = tty->ops->write(tty, wakeup, sizeof(wakeup));
+
+	count = tty->ops->write(tty, out->data, out->len);
+	if (PN533_FRAME_CMD(((struct pn533_std_frame *)out->data)) ==
+			PN533_CMD_SAM_CONFIGURATION)
+		pn532->send_wakeup = 0;
+
+	mod_timer(&pn532->cmd_timeout, HZ / 40 + jiffies);
+	return 0;
+}
+
+static int pn532_uart_send_ack(struct pn533 *dev, gfp_t flags)
+{
+	struct pn532_uart_phy *phy = dev->phy;
+	static const u8 ack[PN533_STD_FRAME_ACK_SIZE] = {
+			0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
+	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
+	int rc;
+
+	set_bit(TTY_DO_WRITE_WAKEUP, &phy->tty->flags);
+	rc = phy->tty->ops->write(phy->tty, ack, sizeof(ack));
+
+	return 0;
+}
+
+static void pn532_uart_abort_cmd(struct pn533 *dev, gfp_t flags)
+{
+	/* An ack will cancel the last issued command */
+	pn532_uart_send_ack(dev, flags);
+
+	/* schedule cmd_complete_work to finish current command execution */
+	pn533_recv_frame(dev, NULL, -ENOENT);
+}
+
+static struct pn533_phy_ops uart_phy_ops = {
+	.send_frame = pn532_uart_send_frame,
+	.send_ack = pn532_uart_send_ack,
+	.abort_cmd = pn532_uart_abort_cmd,
+};
+
+static void pn532_cmd_timeout(struct timer_list *t)
+{
+	struct pn532_uart_phy *dev = from_timer(dev, t, cmd_timeout);
+
+	pn532_uart_send_frame(dev->priv, dev->cur_out_buf);
+}
+
+static void pn532_finalize_setup(struct work_struct *work)
+{
+	struct pn532_uart_phy *pn532 =
+		container_of(work, struct pn532_uart_phy, open_tty_work);
+	int err;
+
+	err = pn533_finalize_setup(pn532->priv);
+	if (err) {
+		complete_all(&pn532->init_done);
+		return;
+	}
+
+	pn532->magic = PN532_MAGIC;
+	complete_all(&pn532->init_done);
+}
+
+static int pn532_open(struct tty_struct *tty)
+{
+	struct pn532_uart_phy *pn532;
+	struct pn533 *priv;
+	int err;
+
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
+	pn532 = tty->disc_data;
+	err = -EEXIST;
+	/* First make sure we're not already connected. */
+	if (pn532 && pn532->magic == PN532_MAGIC)
+		goto err_exit;
+
+	err = -ENOMEM;
+	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
+	if (pn532 == NULL)
+		goto err_exit;
+
+	pn532->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
+	if (pn532->recv_skb == NULL)
+		goto err_free;
+
+	pn532->tty = tty;
+	INIT_WORK(&pn532->open_tty_work, pn532_finalize_setup);
+	pn532->wq_open_tty = alloc_workqueue("pn532_uart_finalize_setup", 0, 0);
+	if (pn532->wq_open_tty == NULL)
+		goto err_skb;
+
+	priv = pn533_register_device(PN533_DEVICE_PN532,
+				     PN533_NO_TYPE_B_PROTOCOLS,
+				     PN533_PROTO_REQ_ACK_RESP,
+				     pn532, &uart_phy_ops, NULL,
+				     pn532->tty->dev,
+				     tty->dev);
+
+	if (IS_ERR(priv)) {
+		err = PTR_ERR(priv);
+		goto err_wq;
+	}
+
+	pn532->priv = priv;
+	tty->disc_data = pn532;
+	init_completion(&pn532->init_done);
+
+	/* Done.  We have linked the TTY line to a channel. */
+	pn532->tty->receive_room = 262 * 2;
+	pn532->send_wakeup = 1;
+	timer_setup(&pn532->cmd_timeout, pn532_cmd_timeout, 0);
+	queue_work(pn532->wq_open_tty, &pn532->open_tty_work);
+	/* TTY layer expects 0 on success */
+	return 0;
+
+err_wq:
+	destroy_workqueue(pn532->wq_open_tty);
+err_skb:
+	kfree_skb(pn532->recv_skb);
+err_free:
+	kfree(pn532);
+err_exit:
+	/* Count references from TTY module */
+	return err;
+}
+
+static void pn532_close(struct tty_struct *tty)
+{
+	struct pn532_uart_phy *pn532 = (struct pn532_uart_phy *) tty->disc_data;
+
+	/* First make sure we're connected. */
+	if (!pn532 || pn532->magic != PN532_MAGIC || pn532->tty != tty)
+		return;
+
+	flush_workqueue(pn532->wq_open_tty);
+	destroy_workqueue(pn532->wq_open_tty);
+	pn533_unregister_device(pn532->priv);
+
+	kfree_skb(pn532->recv_skb);
+	kfree(pn532);
+}
+
+static int pn532_hangup(struct tty_struct *tty)
+{
+	pn532_close(tty);
+	return 0;
+}
+
+/* Perform I/O control on an active PN532 line discipline channel. */
+static int pn532_ioctl(struct tty_struct *tty, struct file *file,
+		       unsigned int cmd, unsigned long arg)
+{
+	struct pn532_uart_phy *pn532 = (struct pn532_uart_phy *) tty->disc_data;
+	unsigned int tmp;
+
+	wait_for_completion(&pn532->init_done);
+	flush_workqueue(pn532->wq_open_tty);
+	/* First make sure we're connected. */
+	if (!pn532 || pn532->magic != PN532_MAGIC)
+		return -EINVAL;
+
+	switch (cmd) {
+	case SIOCGIFNAME:
+		if (!pn532->priv->nfc_dev) {
+			dev_err(tty->dev, "The device was not (successfully) connected before.\n");
+			return -EINVAL;
+		}
+		tmp = strlen(nfc_device_name(pn532->priv->nfc_dev)) + 1;
+		if (copy_to_user((void __user *)arg,
+				nfc_device_name(pn532->priv->nfc_dev), tmp))
+			return -EFAULT;
+
+		return 0;
+
+	case SIOCSIFHWADDR:
+		return -EINVAL;
+
+	default:
+		return tty_mode_ioctl(tty, file, cmd, arg);
+	}
+}
+
+/*
+ * scans the buffer if it contains a pn532 frame. It is not checked if the
+ * frame is really valid. This is later done with pn533_rx_frame_is_valid.
+ * This is useful for malformed or errornous transmitted frames. Adjusts the
+ * bufferposition where the frame starts, since pn533_recv_frame expects a
+ * well formed frame.
+ */
+static int pn532_uart_rx_is_frame(struct sk_buff *skb, struct tty_struct *tty)
+{
+	int i;
+	u16 frame_len;
+	struct pn533_std_frame *std;
+	struct pn533_ext_frame *ext;
+
+	for (i = 0; i + PN533_STD_FRAME_ACK_SIZE <= skb->len; i++) {
+		std = (struct pn533_std_frame *)&skb->data[i];
+		/* search start code */
+		if (std->start_frame != cpu_to_be16(PN533_STD_FRAME_SOF))
+			continue;
+
+		/* frame type */
+		switch (std->datalen) {
+		case PN533_FRAME_DATALEN_ACK:
+			dev_dbg(tty->dev, "ack frame");
+			if (std->datalen_checksum == 0xff) {
+				skb_pull(skb, i);
+				return 1;
+			}
+
+			break;
+		case PN533_FRAME_DATALEN_ERROR:
+			dev_dbg(tty->dev, "error frame");
+			if ((std->datalen_checksum == 0xff) &&
+					(skb->len >=
+					 PN533_STD_ERROR_FRAME_SIZE)) {
+				skb_pull(skb, i);
+				return 1;
+			}
+
+			break;
+		case PN533_FRAME_DATALEN_EXTENDED:
+			dev_dbg(tty->dev, "extended frame");
+			ext = (struct pn533_ext_frame *)&skb->data[i];
+			frame_len = ext->datalen;
+			if (skb->len >= frame_len +
+					sizeof(struct pn533_ext_frame) +
+					2 /* CKS + Postamble */) {
+				skb_pull(skb, i);
+				return 1;
+			}
+
+			break;
+		default: /* normal information frame */
+			frame_len = std->datalen;
+			if (skb->len >= frame_len +
+					sizeof(struct pn533_std_frame) +
+					2 /* CKS + Postamble */) {
+				skb_pull(skb, i);
+				return 1;
+			}
+
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static void pn532_receive_buf(struct tty_struct *tty,
+			      const unsigned char *cp, char *fp, int count)
+{
+	struct pn532_uart_phy *dev = (struct pn532_uart_phy *)tty->disc_data;
+
+	if (!dev)
+		return;
+
+	del_timer(&dev->cmd_timeout);
+	while (count-- && (skb_end_offset(dev->recv_skb) > 1)) {
+		if (fp && *fp++) {
+			cp++;
+			continue;
+		}
+
+		skb_put_u8(dev->recv_skb, *cp++);
+		if (!pn532_uart_rx_is_frame(dev->recv_skb, tty))
+			continue;
+
+		pn533_recv_frame(dev->priv, dev->recv_skb, 0);
+		dev->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
+		if (dev->recv_skb == NULL)
+			return;
+	}
+}
+
+static void pn532_write_wakeup(struct tty_struct *tty)
+{
+	struct pn532_uart_phy *pn532 = (struct pn532_uart_phy *)tty->disc_data;
+
+	if (!pn532 || pn532->magic != PN532_MAGIC)
+		return;
+
+	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+}
+
+static struct tty_ldisc_ops pn532_ldisc = {
+	.owner		= THIS_MODULE,
+	.magic		= TTY_LDISC_MAGIC,
+	.name		= "pn532",
+	.open		= pn532_open,
+	.close		= pn532_close,
+	.hangup		= pn532_hangup,
+	.ioctl		= pn532_ioctl,
+	.receive_buf	= pn532_receive_buf,
+	.write_wakeup	= pn532_write_wakeup,
+};
+
+static int __init pn532_init(void)
+{
+	int ret;
+
+	ret = tty_register_ldisc(N_PN532, &pn532_ldisc);
+	if (ret)
+		pr_err("pn532: can not register line discipline\n");
+
+	return ret;
+}
+
+static void __exit pn532_exit(void)
+{
+	int ret;
+
+	ret = tty_unregister_ldisc(N_PN532);
+	if (ret)
+		pr_err("pn532: can not unregister ldisc (err %d)\n", ret);
+}
+
+module_init(pn532_init);
+module_exit(pn532_exit);
+
+MODULE_ALIAS_LDISC(N_PN532);
+MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
+MODULE_DESCRIPTION("PN532 UART driver ver " VERSION);
+MODULE_VERSION(VERSION);
+MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/tty.h b/include/uapi/linux/tty.h
index 376cccf397be..0517b5354488 100644
--- a/include/uapi/linux/tty.h
+++ b/include/uapi/linux/tty.h
@@ -38,5 +38,6 @@
 #define N_NCI		25	/* NFC NCI UART */
 #define N_SPEAKUP	26	/* Speakup communication with synths */
 #define N_NULL		27	/* Null ldisc used for error handling */
+#define N_PN532		28	/* NXP PN532 NFC chip */
 
 #endif /* _UAPI_LINUX_TTY_H */
-- 
2.19.1

