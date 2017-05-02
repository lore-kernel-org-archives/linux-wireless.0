Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:23270 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751863AbdEBGFV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 May 2017 02:05:21 -0400
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <linux-wireless@vger.kernel.org>,
        <linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
        <sylvain.fidelis@st.com>, <raphael.collado@st.com>,
        <shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc][PATCH v1] 1/6] NFC: add generic UART support
Date: Tue, 2 May 2017 02:03:38 -0400
Message-ID: <1493705023-8710-2-git-send-email-shikha.singh@st.com> (sfid-20170502_080721_058560_4F4B270D)
In-Reply-To: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
References: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some NFC controller supports UART as host interface.
Such controllers which are direct implementation of
digital protocol can use this framework.
This patch add the generic support of UART and
provides some extension API for vendor specific needs.

This code is strongly inspired by the nci ldisc
implementation.
Digital UART drivers will have to register themselves
to this layer via digital_uart_register.

Underlying tty will have to be configured from user land
thanks to ioctl support.

Signed-off-by: Shikha Singh <shikha.singh@st.com>
---
 include/net/nfc/digital_uart.h | 105 +++++++++
 include/uapi/linux/tty.h       |   1 +
 net/nfc/Kconfig                |  12 +
 net/nfc/Makefile               |   3 +
 net/nfc/digital_uart.c         | 523 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 644 insertions(+)
 create mode 100644 include/net/nfc/digital_uart.h
 create mode 100644 net/nfc/digital_uart.c

diff --git a/include/net/nfc/digital_uart.h b/include/net/nfc/digital_uart.h
new file mode 100644
index 0000000..5d64e2d
--- /dev/null
+++ b/include/net/nfc/digital_uart.h
@@ -0,0 +1,105 @@
+/*
+ * NFC Digital UART Line Discipline Framework API
+ *
+ * Copyright (c) 2016, STMicroelectronics Pvt. Ltd.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef __NFC_DIGITAL_UART_H
+#define __NFC_DIGITAL_UART_H
+
+#include <linux/tty.h>
+#include <linux/skbuff.h>
+
+/**
+ * Drivers that can register with DIGITAL UART LDISC Framework
+ */
+enum digital_uart_driver {
+	DIGITAL_UART_DRIVER_ST = 0,
+	DIGITAL_UART_DRIVER_MAX,
+};
+
+enum digital_uart_stop_bits {
+	DIGITAL_UART_STOP_BIT_1 = 0,
+	DIGITAL_UART_STOP_BIT_2,
+};
+
+struct digital_uart;
+
+#define DIGITALUARTSETDRIVER	_IOW('V', 0, char *)
+
+/*
+ * DIGITAL UART LDISC Framework ops
+ */
+struct digital_uart_ops {
+	/* called when SETDRIVER IOCTL called on tty */
+	int (*open)(struct digital_uart *du);
+	/* called when ldisc of tty changed to other than N_DIGITAL */
+	void (*close)(struct digital_uart *du);
+	/* called after a frame is received */
+	int (*recv)(struct digital_uart *du, struct sk_buff *skb);
+	/* called by low level uart driver's tty layer when the data is
+	 * received at UART port.
+	 */
+	int (*recv_buff)(struct digital_uart *du, const u8 *data, char *flags,
+			 int count);
+	/* called for sending a frame through UART */
+	int (*send)(struct digital_uart *du, struct sk_buff *skb);
+	/* if required to do some special handling before starting the
+	 * transmission
+	 */
+	void (*tx_start)(struct digital_uart *du);
+	/* if required to do some special handling before ending the
+	 * transmission
+	 */
+	void (*tx_done)(struct digital_uart *du);
+	/* returns the received frame header for valid frames*/
+	/* called at the time of received frame processing */
+	int (*recv_fr_hdr_sz)(struct digital_uart *du,
+			      const u8 *data, int count);
+	/* returns the max size of frame that can be received*/
+	int (*recv_fr_max_sz)(struct digital_uart *du);
+	/* return payload size */
+	int (*recv_pl_sz)(struct digital_uart *du, const u8 *data, int count);
+};
+
+struct digital_uart {
+	struct module *owner;
+	struct digital_uart_ops ops;
+	const char *name;
+	enum digital_uart_driver driver;
+	/* Pointer of corresponding TTY */
+	struct tty_struct *tty;
+	/* worker for writing the frame */
+	struct work_struct write_work;
+	/* lock to serialize the frame read operation */
+	spinlock_t rx_lock;
+	unsigned long tx_state;
+	/* queue of frames to be written */
+	struct sk_buff_head tx_q;
+	/* current write frame */
+	struct sk_buff *tx_skb;
+	/* current read frame */
+	struct sk_buff *rx_skb;
+	/* store received pkt length in ldisc context */
+	int rx_packet_len;
+	/* store drive specific data */
+	void *drv_data;
+};
+
+/* exported helper functions */
+int digital_uart_register(struct digital_uart *du);
+void digital_uart_unregister(struct digital_uart *du);
+void digital_uart_set_config(struct digital_uart *du, int baudrate,
+			     int flow_ctrl,
+			     enum digital_uart_stop_bits stop_bits);
+
+#endif /* __NFC_DIGITAL_UART_H */
diff --git a/include/uapi/linux/tty.h b/include/uapi/linux/tty.h
index 01c4410..7c1fb70 100644
--- a/include/uapi/linux/tty.h
+++ b/include/uapi/linux/tty.h
@@ -35,5 +35,6 @@
 #define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
 #define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
 #define N_NCI		25	/* NFC NCI UART */
+#define N_DIGITAL	26	/* NFC DIGITAL UART */
 
 #endif /* _UAPI_LINUX_TTY_H */
diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 6e0fa0c..80cffcd 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -28,6 +28,18 @@ config NFC_DIGITAL
 	  To compile this support as a module, choose M here: the module will
 	  be called nfc_digital.
 
+config NFC_DIGITAL_UART
+	depends on NFC_DIGITAL && TTY
+	tristate "Digital over UART protocol support"
+	default n
+	help
+	  This implements an UART LDisc framework for digital core based
+	  drivers.
+
+	  Say Y if you use a digital driver that requires UART link layer.
+	  Choose M to build this support as a module.
+	  The module will be called nfc_digital_uart.
+
 source "net/nfc/nci/Kconfig"
 source "net/nfc/hci/Kconfig"
 
diff --git a/net/nfc/Makefile b/net/nfc/Makefile
index 2555ff8..c6bb8f9 100644
--- a/net/nfc/Makefile
+++ b/net/nfc/Makefile
@@ -6,8 +6,11 @@ obj-$(CONFIG_NFC) += nfc.o
 obj-$(CONFIG_NFC_NCI) += nci/
 obj-$(CONFIG_NFC_HCI) += hci/
 obj-$(CONFIG_NFC_DIGITAL) += nfc_digital.o
+obj-$(CONFIG_NFC_DIGITAL_UART) += nfc_digital_uart.o
 
 nfc-objs := core.o netlink.o af_nfc.o rawsock.o llcp_core.o llcp_commands.o \
 		llcp_sock.o
 
 nfc_digital-objs := digital_core.o digital_technology.o digital_dep.o
+
+nfc_digital_uart-objs := digital_uart.o
diff --git a/net/nfc/digital_uart.c b/net/nfc/digital_uart.c
new file mode 100644
index 0000000..a759203
--- /dev/null
+++ b/net/nfc/digital_uart.c
@@ -0,0 +1,523 @@
+/*
+ * NFC Digital UART Line Discipline Framework
+ *
+ * Copyright (C) 2016, STMicroelectronics Pvt. Ltd.
+ *
+ * This software file (the "File") is distributed by STMicroelectronics Pvt.
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available on the worldwide web at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+/* Inspired (hugely) by NCI LDISC implementation in NFC. */
+
+#include <linux/module.h>
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/poll.h>
+
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/ioctl.h>
+#include <linux/skbuff.h>
+
+#include <net/nfc/digital.h>
+#include <net/nfc/digital_uart.h>
+
+/* TX states  */
+#define DIGITAL_UART_SENDING	1
+#define DIGITAL_UART_TX_WAKEUP	2
+
+static struct digital_uart *digital_uart_drivers[DIGITAL_UART_DRIVER_MAX];
+
+static inline struct sk_buff *digital_uart_dequeue(struct digital_uart *du)
+{
+	struct sk_buff *skb = du->tx_skb;
+
+	if (!skb)
+		skb = skb_dequeue(&du->tx_q);
+	else
+		du->tx_skb = NULL;
+
+	return skb;
+}
+
+static inline int digital_uart_queue_empty(struct digital_uart *du)
+{
+	if (du->tx_skb)
+		return 0;
+
+	return skb_queue_empty(&du->tx_q);
+}
+
+static int digital_uart_tx_wakeup(struct digital_uart *du)
+{
+	if (test_and_set_bit(DIGITAL_UART_SENDING, &du->tx_state)) {
+		set_bit(DIGITAL_UART_TX_WAKEUP, &du->tx_state);
+		return 0;
+	}
+
+	schedule_work(&du->write_work);
+
+	return 0;
+}
+
+static void digital_uart_write_work(struct work_struct *work)
+{
+	struct digital_uart *du = container_of(work,
+					       struct digital_uart,
+					       write_work);
+	struct tty_struct *tty = du->tty;
+	struct sk_buff *skb;
+
+restart:
+	clear_bit(DIGITAL_UART_TX_WAKEUP, &du->tx_state);
+
+	if (du->ops.tx_start)
+		du->ops.tx_start(du);
+
+	while ((skb = digital_uart_dequeue(du))) {
+		int len;
+
+		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+		len = tty->ops->write(tty, skb->data, skb->len);
+		skb_pull(skb, len);
+		if (skb->len) {
+			du->tx_skb = skb;
+			break;
+		}
+		kfree_skb(skb);
+	}
+
+	if (test_bit(DIGITAL_UART_TX_WAKEUP, &du->tx_state))
+		goto restart;
+
+	if (du->ops.tx_done && digital_uart_queue_empty(du))
+		du->ops.tx_done(du);
+
+	clear_bit(DIGITAL_UART_SENDING, &du->tx_state);
+}
+
+static int digital_uart_set_driver(struct tty_struct *tty, unsigned int driver)
+{
+	struct digital_uart *du = NULL;
+	int ret;
+
+	if (driver >= DIGITAL_UART_DRIVER_MAX)
+		return -EINVAL;
+
+	if (!digital_uart_drivers[driver])
+		return -ENOENT;
+
+	du = kzalloc(sizeof(*du), GFP_KERNEL);
+	if (!du)
+		return -ENOMEM;
+
+	memcpy(du, digital_uart_drivers[driver], sizeof(struct digital_uart));
+	du->tty = tty;
+	tty->disc_data = du;
+	skb_queue_head_init(&du->tx_q);
+	INIT_WORK(&du->write_work, digital_uart_write_work);
+	spin_lock_init(&du->rx_lock);
+
+	ret = du->ops.open(du);
+	if (ret) {
+		tty->disc_data = NULL;
+		kfree(du);
+	} else if (!try_module_get(du->owner)) {
+		du->ops.close(du);
+		tty->disc_data = NULL;
+		kfree(du);
+		return -ENOENT;
+	}
+
+	tty->receive_room = du->ops.recv_fr_max_sz(du);
+
+	return ret;
+}
+
+/* ------ LDISC part ------ */
+
+/* digital_uart_tty_open
+ *
+ *     Called when line discipline changed to DIGITAL_UART.
+ *
+ * Arguments:
+ *     tty pointer to tty info structure
+ * Return Value:
+ *     0 if success, otherwise error code
+ */
+static int digital_uart_tty_open(struct tty_struct *tty)
+{
+	/* Error if the tty has no write op */
+	if (!tty->ops->write)
+		return -EOPNOTSUPP;
+
+	tty->disc_data = NULL;
+
+	/* Flush any pending characters in the driver and line discipline. */
+
+	/* Note don't use ldisc_ref here as the
+	 * open path is before the ldisc is referencable.
+	 */
+
+	if (tty->ldisc->ops->flush_buffer)
+		tty->ldisc->ops->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
+
+	return 0;
+}
+
+/* digital_uart_tty_close()
+ *
+ *    Called when the line discipline is changed to something
+ *    else, the tty is closed, or the tty detects a hangup.
+ */
+static void digital_uart_tty_close(struct tty_struct *tty)
+{
+	struct digital_uart *du = (void *)tty->disc_data;
+
+	/* Detach from the tty */
+	tty->disc_data = NULL;
+
+	if (!du)
+		return;
+
+	if (du->tx_skb)
+		kfree_skb(du->tx_skb);
+	if (du->rx_skb)
+		kfree_skb(du->rx_skb);
+
+	skb_queue_purge(&du->tx_q);
+
+	du->ops.close(du);
+	du->tty = NULL;
+	module_put(du->owner);
+
+	cancel_work_sync(&du->write_work);
+
+	kfree(du);
+}
+
+/* digital_uart_tty_wakeup()
+ *
+ *    Callback for transmit wakeup. Called when low level
+ *    device driver can accept more send data.
+ *
+ * Arguments:        tty    pointer to associated tty instance data
+ * Return Value:    None
+ */
+static void digital_uart_tty_wakeup(struct tty_struct *tty)
+{
+	struct digital_uart *du = (void *)tty->disc_data;
+
+	if (!du)
+		return;
+
+	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+
+	if (tty != du->tty)
+		return;
+
+	digital_uart_tx_wakeup(du);
+}
+
+/* digital_uart_tty_receive()
+ *
+ *     Called by tty low level driver when receive data is
+ *     available.
+ *
+ * Arguments:  tty          pointer to tty isntance data
+ *             data         pointer to received data
+ *             flags        pointer to flags for data
+ *             count        count of received data in bytes
+ *
+ * Return Value:    None
+ */
+static void digital_uart_tty_receive(struct tty_struct *tty, const u8 *data,
+				     char *flags, int count)
+{
+	struct digital_uart *du = (void *)tty->disc_data;
+
+	if (!du || tty != du->tty)
+		return;
+
+	spin_lock(&du->rx_lock);
+	du->ops.recv_buff(du, (void *)data, flags, count);
+	spin_unlock(&du->rx_lock);
+
+	tty_unthrottle(tty);
+}
+
+/* digital_uart_tty_ioctl()
+ *
+ *    Process IOCTL system call for the tty device.
+ *
+ * Arguments:
+ *
+ *    tty        pointer to tty instance data
+ *    file       pointer to open file object for device
+ *    cmd        IOCTL command code
+ *    arg        argument for IOCTL call (cmd dependent)
+ *
+ * Return Value:    Command dependent
+ */
+static int digital_uart_tty_ioctl(struct tty_struct *tty, struct file *file,
+				  unsigned int cmd, unsigned long arg)
+{
+	struct digital_uart *du = (void *)tty->disc_data;
+	int err = 0;
+
+	switch (cmd) {
+	case DIGITALUARTSETDRIVER:
+		if (!du)
+			return digital_uart_set_driver(tty, (unsigned int)arg);
+		else
+			return -EBUSY;
+		break;
+	default:
+		err = n_tty_ioctl_helper(tty, file, cmd, arg);
+		break;
+	}
+
+	return err;
+}
+
+/* We don't provide read/write/poll interface for user space. */
+static ssize_t digital_uart_tty_read(struct tty_struct *tty, struct file *file,
+				     unsigned char __user *buf, size_t nr)
+{
+	return 0;
+}
+
+static ssize_t digital_uart_tty_write(struct tty_struct *tty, struct file *file,
+				      const unsigned char *data, size_t count)
+{
+	return 0;
+}
+
+static unsigned int digital_uart_tty_poll(struct tty_struct *tty,
+					  struct file *filp, poll_table *wait)
+{
+	return 0;
+}
+
+static int digital_uart_send(struct digital_uart *du, struct sk_buff *skb)
+{
+	/* Queue TX packet */
+	skb_queue_tail(&du->tx_q, skb);
+
+	/* Try to start TX (if possible) */
+	digital_uart_tx_wakeup(du);
+
+	return 0;
+}
+
+/*  -- Default recv_buf handler --
+ *
+ * This handler receives the data from UART read the header to
+ * retrieve the frame length.
+ * This function can be hit multiple time to receive complete frame.
+ * Once complete frame is received, the frame is passed to the digital layer.
+ */
+static int digital_uart_default_recv_buf(struct digital_uart *du,
+					 const u8 *data,
+					 char *flags,
+					 int count)
+{
+	int chunk_len, err;
+	static int header_len;
+	unsigned int recv_fr_sz;
+
+	/* Decode all incoming data in packets
+	 * and enqueue then for processing.
+	 */
+	while (count > 0) {
+		/* If this is the first data of a packet, allocate a buffer */
+		if (!du->rx_skb) {
+			du->rx_packet_len = -1;
+			recv_fr_sz = du->ops.recv_fr_max_sz(du);
+			du->rx_skb = nfc_alloc_recv_skb(recv_fr_sz, GFP_KERNEL);
+			if (!du->rx_skb)
+				return -ENOMEM;
+			header_len = du->ops.recv_fr_hdr_sz(du, data, count);
+			if (header_len < 0) {
+				kfree_skb(du->rx_skb);
+				du->rx_skb = NULL;
+				return -EIO;
+			}
+		}
+
+		/* Eat byte after byte till full packet header is received */
+		if (du->rx_skb->len < header_len) {
+			*skb_put(du->rx_skb, 1) = *data++;
+			--count;
+			if (count)
+				continue;
+		}
+
+		/* if count is zero and hdr not fully received
+		 * continue, otherwise go ahead to check if
+		 * hdr is enough to complete the frame and
+		 * we will not receive any payload
+		 */
+		if (!count && du->rx_skb->len < header_len)
+			continue;
+
+		/* Header was received but packet len (if any) was not read */
+		if (du->rx_packet_len < 0) {
+			if (!header_len)
+				du->rx_packet_len =
+					du->ops.recv_pl_sz(du,
+							   data,
+							   count);
+			else
+				du->rx_packet_len = header_len +
+					du->ops.recv_pl_sz(du,
+							   du->rx_skb->data,
+							   du->rx_skb->len);
+		}
+
+		/* Compute how many bytes are missing and how many bytes can
+		 * be consumed.
+		 */
+		chunk_len = du->rx_packet_len - du->rx_skb->len;
+		if (count < chunk_len)
+			chunk_len = count;
+		if (chunk_len)
+			memcpy(skb_put(du->rx_skb, chunk_len), data, chunk_len);
+
+		/* if multiple frames are received, adjust data and count for
+		 * next frame, to be ready for next iterate of while (count > 0)
+		 */
+		data += chunk_len;
+		count -= chunk_len;
+
+		/* Check if packet is fully received */
+		if (du->rx_packet_len == du->rx_skb->len) {
+			/* Pass RX packet to driver */
+			err = du->ops.recv(du, du->rx_skb);
+			if (err)
+				nfc_err(du->tty->dev, "corrupted RX packet, err =%d\n",
+					err);
+			/* Next packet will be a new one */
+			du->rx_skb = NULL;
+		}
+	}
+
+	return 0;
+}
+
+int digital_uart_register(struct digital_uart *du)
+{
+	if (!du || !du->ops.open ||
+	    !du->ops.recv || !du->ops.close ||
+	    !du->ops.recv_fr_max_sz || !du->ops.recv_fr_hdr_sz ||
+	    !du->ops.recv_pl_sz)
+		return -EINVAL;
+
+	/* Set the send callback */
+	du->ops.send = digital_uart_send;
+
+	/* Install default handlers if not overridden */
+	if (!du->ops.recv_buff)
+		du->ops.recv_buff = digital_uart_default_recv_buf;
+
+	/* Add this driver in the driver list */
+	if (digital_uart_drivers[du->driver]) {
+		pr_err("driver %d is already registered\n", du->driver);
+		return -EBUSY;
+	}
+	digital_uart_drivers[du->driver] = du;
+
+	pr_info("DIGITAL uart driver '%s [%d]' registered\n",
+		du->name, du->driver);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(digital_uart_register);
+
+void digital_uart_unregister(struct digital_uart *du)
+{
+	pr_info("DIGITAL uart driver '%s [%d]' unregistered\n", du->name,
+		du->driver);
+
+	/* Remove this driver from the driver list */
+	digital_uart_drivers[du->driver] = NULL;
+}
+EXPORT_SYMBOL_GPL(digital_uart_unregister);
+
+void digital_uart_set_config(struct digital_uart *du,
+			     int baudrate,
+			     int flow_ctrl,
+			     enum digital_uart_stop_bits stop_bits)
+{
+	struct ktermios new_termios;
+
+	if (!du->tty)
+		return;
+
+	down_read(&du->tty->termios_rwsem);
+	new_termios = du->tty->termios;
+	up_read(&du->tty->termios_rwsem);
+	tty_termios_encode_baud_rate(&new_termios, baudrate, baudrate);
+
+	if (flow_ctrl)
+		new_termios.c_cflag |= CRTSCTS;
+	else
+		new_termios.c_cflag &= ~CRTSCTS;
+
+	if (stop_bits == DIGITAL_UART_STOP_BIT_2)
+		new_termios.c_cflag |= CSTOPB;
+
+	/* 8 bit data with no parity is default */
+	new_termios.c_cflag |= CS8;
+
+	tty_set_termios(du->tty, &new_termios);
+}
+EXPORT_SYMBOL_GPL(digital_uart_set_config);
+
+static struct tty_ldisc_ops digital_uart_ldisc = {
+	.magic		= TTY_LDISC_MAGIC,
+	.owner		= THIS_MODULE,
+	.name		= "n_digital",
+	.open		= digital_uart_tty_open,
+	.close		= digital_uart_tty_close,
+	.read		= digital_uart_tty_read,
+	.write		= digital_uart_tty_write,
+	.poll		= digital_uart_tty_poll,
+	.receive_buf	= digital_uart_tty_receive,
+	.write_wakeup	= digital_uart_tty_wakeup,
+	.ioctl		= digital_uart_tty_ioctl,
+};
+
+static int __init digital_uart_init(void)
+{
+	return tty_register_ldisc(N_DIGITAL, &digital_uart_ldisc);
+}
+
+static void __exit digital_uart_exit(void)
+{
+	tty_unregister_ldisc(N_DIGITAL);
+}
+
+module_init(digital_uart_init);
+module_exit(digital_uart_exit);
+
+MODULE_AUTHOR("Sudeep Biswas <sudeep.biswas@st.com>");
+MODULE_AUTHOR("Shikha Singh <shikha.singh@st.com>");
+MODULE_DESCRIPTION("NFC Digital UART driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_LDISC(N_DIGITAL);
-- 
1.8.2.1
