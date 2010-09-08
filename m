Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:48764 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab0IHXZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:25:56 -0400
Received: by pxi10 with SMTP id 10so254007pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:25:56 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 1/9] libertas_tf: Add a sdio driver to libertas_tf
Date: Wed,  8 Sep 2010 16:25:21 -0700
Message-Id: <1283988329-44549-2-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988329-44549-1-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for sdio-connected libertas chips with the
thin-firmware to libertas_tf.  This includes the sd8686 in the OLPC XO-1.5s,
as well as some Gumstix platforms.  Restructuring was necessary in libertas_tf
that will break libertas_tf_usb, which is fixed in a subsequent patch.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/Kconfig                   |    6 +
 drivers/net/wireless/libertas_tf/Makefile      |    2 +
 drivers/net/wireless/libertas_tf/cmd.c         |   10 +-
 drivers/net/wireless/libertas_tf/deb_defs.h    |    5 +-
 drivers/net/wireless/libertas_tf/if_sdio.c     | 1201 ++++++++++++++++++++++++
 drivers/net/wireless/libertas_tf/if_sdio.h     |   56 ++
 drivers/net/wireless/libertas_tf/libertas_tf.h |   19 +-
 drivers/net/wireless/libertas_tf/main.c        |  100 ++-
 8 files changed, 1379 insertions(+), 20 deletions(-)
 create mode 100644 drivers/net/wireless/libertas_tf/if_sdio.c
 create mode 100644 drivers/net/wireless/libertas_tf/if_sdio.h

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 174e344..fc6c713 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -45,6 +45,12 @@ config LIBERTAS_THINFIRM_DEBUG
 	---help---
 	  Debugging support.
 
+config LIBERTAS_THINFIRM_SDIO
+	tristate "Marvell Libertas 8686 SDIO 802.11b/g cards"
+	depends on LIBERTAS_THINFIRM && MMC
+	---help---
+	  A driver for Marvell Libertas 8686 SDIO devices.
+
 config LIBERTAS_THINFIRM_USB
 	tristate "Marvell Libertas 8388 USB 802.11b/g cards with thin firmware"
 	depends on LIBERTAS_THINFIRM && USB
diff --git a/drivers/net/wireless/libertas_tf/Makefile b/drivers/net/wireless/libertas_tf/Makefile
index ff5544d..1a44340 100644
--- a/drivers/net/wireless/libertas_tf/Makefile
+++ b/drivers/net/wireless/libertas_tf/Makefile
@@ -1,6 +1,8 @@
 libertas_tf-objs := main.o cmd.o
 
 libertas_tf_usb-objs += if_usb.o
+libertas_tf_sdio-objs += if_sdio.o
 
 obj-$(CONFIG_LIBERTAS_THINFIRM) += libertas_tf.o
 obj-$(CONFIG_LIBERTAS_THINFIRM_USB) += libertas_tf_usb.o
+obj-$(CONFIG_LIBERTAS_THINFIRM_SDIO) += libertas_tf_sdio.o
diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index 8945afd..738a2ff 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -101,7 +101,7 @@ int lbtf_update_hw_spec(struct lbtf_private *priv)
 	priv->fwrelease = (priv->fwrelease << 8) |
 		(priv->fwrelease >> 24 & 0xff);
 
-	printk(KERN_INFO "libertastf: %pM, fw %u.%u.%up%u, cap 0x%08x\n",
+	printk(KERN_INFO "libertas_tf: %pM, fw %u.%u.%up%u, cap 0x%08x\n",
 		cmd.permanentaddr,
 		priv->fwrelease >> 24 & 0xff,
 		priv->fwrelease >> 16 & 0xff,
@@ -252,7 +252,7 @@ static void lbtf_submit_command(struct lbtf_private *priv,
 
 	lbtf_deb_cmd("DNLD_CMD: command 0x%04x, seq %d, size %d\n",
 		     command, le16_to_cpu(cmd->seqnum), cmdsize);
-	lbtf_deb_hex(LBTF_DEB_CMD, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
+	lbtf_deb_hex(LBTF_DEB_CMD, "DNLD_CMD ", (void *) cmdnode->cmdbuf, cmdsize);
 
 	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmd, cmdsize);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -672,6 +672,12 @@ int __lbtf_cmd(struct lbtf_private *priv, uint16_t command,
 
 	lbtf_deb_enter(LBTF_DEB_HOST);
 
+	if (priv->surpriseremoved) {
+		lbtf_deb_host("CMD: card removed\n");
+		cmdnode = ERR_PTR(-ENOENT);
+		goto done;
+	}
+
 	cmdnode = __lbtf_cmd_async(priv, command, in_cmd, in_cmd_size,
 				  callback, callback_arg);
 	if (IS_ERR(cmdnode)) {
diff --git a/drivers/net/wireless/libertas_tf/deb_defs.h b/drivers/net/wireless/libertas_tf/deb_defs.h
index ae75396..e2f009c 100644
--- a/drivers/net/wireless/libertas_tf/deb_defs.h
+++ b/drivers/net/wireless/libertas_tf/deb_defs.h
@@ -11,6 +11,9 @@
 
 #include <linux/spinlock.h>
 
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #ifdef CONFIG_LIBERTAS_THINFIRM_DEBUG
 #define DEBUG
 #define PROC_DEBUG
@@ -82,7 +85,7 @@ do { if ((lbtf_debug & (grp)) == (grp)) \
 #define lbtf_deb_usbd(dev, fmt, args...) LBTF_DEB_LL(LBTF_DEB_USB, " usbd", "%s:" fmt, dev_name(dev), ##args)
 #define lbtf_deb_cs(fmt, args...)        LBTF_DEB_LL(LBTF_DEB_CS, " cs", fmt, ##args)
 #define lbtf_deb_thread(fmt, args...)    LBTF_DEB_LL(LBTF_DEB_THREAD, " thread", fmt, ##args)
-#define lbtf_deb_sdio(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_SDIO, " thread", fmt, ##args)
+#define lbtf_deb_sdio(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_SDIO, " sdio", fmt, ##args)
 #define lbtf_deb_macops(fmt, args...)      LBTF_DEB_LL(LBTF_DEB_MACOPS, " thread", fmt, ##args)
 
 #ifdef DEBUG
diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
new file mode 100644
index 0000000..fed5aff
--- /dev/null
+++ b/drivers/net/wireless/libertas_tf/if_sdio.c
@@ -0,0 +1,1201 @@
+/*
+ *  linux/drivers/net/wireless/libertas_tf/if_sdio.c
+ *
+ *  Copyright (C) 2010, cozybit Inc.
+ *
+ * Portions Copyright 2007-2008 Pierre Ossman
+ * Inspired by if_cs.c, Copyright 2007 Holger Schurig
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+#include <linux/firmware.h>
+#include <linux/netdevice.h>
+#include <linux/delay.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/host.h>
+
+#define DRV_NAME "lbtf_sdio"
+
+#include "deb_defs.h"
+#include "libertas_tf.h"
+#include "if_sdio.h"
+
+static char *lbtf_helper_name = NULL;
+module_param_named(helper_name, lbtf_helper_name, charp, 0644);
+
+static char *lbtf_fw_name = NULL;
+module_param_named(fw_name, lbtf_fw_name, charp, 0644);
+
+static const struct sdio_device_id if_sdio_ids[] = {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL,
+			SDIO_DEVICE_ID_MARVELL_LIBERTAS) },
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL,
+			SDIO_DEVICE_ID_MARVELL_8688WLAN) },
+	{ /* end: all zeroes */				},
+};
+
+MODULE_DEVICE_TABLE(sdio, if_sdio_ids);
+
+struct if_sdio_model {
+	int model;
+	const char *helper;
+	const char *firmware;
+};
+
+static struct if_sdio_model if_sdio_models[] = {
+	{
+		/* 8686 */
+		.model = IF_SDIO_MODEL_8686,
+		.helper = "sd8686_helper.bin",
+		.firmware = "sd8686tf.bin",
+	},
+};
+MODULE_FIRMWARE("sd8686_helper.bin");
+MODULE_FIRMWARE("sd8686tf.bin");
+
+struct if_sdio_packet {
+	struct if_sdio_packet	*next;
+	u16			nb;
+	u8			buffer[0] __attribute__((aligned(4)));
+};
+
+struct if_sdio_card {
+	struct sdio_func	*func;
+	struct lbtf_private	*priv;
+
+	int			model;
+	unsigned long		ioport;
+	unsigned int		scratch_reg;
+
+	const char		*helper;
+	const char		*firmware;
+
+	u8			buffer[65536];
+
+	spinlock_t		lock;
+	struct if_sdio_packet	*packets;
+
+	struct workqueue_struct	*workqueue;
+	struct work_struct	packet_worker;
+
+	u8			rx_unit;
+};
+
+static int if_sdio_enable_interrupts(struct lbtf_private *priv)
+{
+	struct if_sdio_card *card = priv->card;
+	int ret;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	sdio_claim_host(card->func);
+	sdio_writeb(card->func, 0x0f, IF_SDIO_H_INT_MASK, &ret);
+	sdio_release_host(card->func);
+
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+	return (ret);
+}
+
+static int if_sdio_disable_interrupts(struct lbtf_private *priv)
+{
+	struct if_sdio_card *card = priv->card;
+	int ret;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	sdio_claim_host(card->func);
+	sdio_writeb(card->func, 0x00, IF_SDIO_H_INT_MASK, &ret);
+	sdio_release_host(card->func);
+
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+	return (ret);
+}
+
+/*
+ *  For SD8385/SD8686, this function reads firmware status after
+ *  the image is downloaded, or reads RX packet length when
+ *  interrupt (with IF_SDIO_H_INT_UPLD bit set) is received.
+ */
+static u16 if_sdio_read_scratch(struct if_sdio_card *card, int *err)
+{
+	int ret;
+	u16 scratch;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	scratch = sdio_readb(card->func, card->scratch_reg, &ret);
+	if (!ret)
+		scratch |= sdio_readb(card->func, card->scratch_reg + 1,
+					&ret) << 8;
+
+	if (err)
+		*err = ret;
+
+	if (ret)
+		return 0xffff;
+
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "scratch %x", scratch);
+	return scratch;
+}
+
+/********************************************************************/
+/* I/O                                                              */
+/********************************************************************/
+static u16 if_sdio_read_rx_len(struct if_sdio_card *card, int *err)
+{
+	int ret;
+	u16 rx_len;
+
+	switch (card->model) {
+	case IF_SDIO_MODEL_8385:
+	case IF_SDIO_MODEL_8686:
+		rx_len = if_sdio_read_scratch(card, &ret);
+		break;
+	case IF_SDIO_MODEL_8688:
+	default: /* for newer chipsets */
+		rx_len = sdio_readb(card->func, IF_SDIO_RX_LEN, &ret);
+		if (!ret)
+			rx_len <<= card->rx_unit;
+		else
+			rx_len = 0xffff;	/* invalid length */
+
+		break;
+	}
+
+	if (err)
+		*err = ret;
+
+	return rx_len;
+}
+
+static int if_sdio_handle_cmd(struct if_sdio_card *card,
+		u8 *buffer, unsigned size)
+{
+	struct lbtf_private *priv = card->priv;
+	int ret;
+	unsigned long flags;
+	u8 i;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	if (size > LBS_CMD_BUFFER_SIZE) {
+		lbtf_deb_sdio("response packet too large (%d bytes)\n",
+			(int)size);
+		ret = -E2BIG;
+		goto out;
+	}
+
+	spin_lock_irqsave(&priv->driver_lock, flags);
+
+	memcpy(priv->cmd_resp_buff, buffer, size);
+	lbtf_cmd_response_rx(priv);
+
+	spin_unlock_irqrestore(&card->priv->driver_lock, flags);
+
+	ret = 0;
+
+out:
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+	return ret;
+}
+
+static int if_sdio_handle_data(struct if_sdio_card *card,
+		u8 *buffer, unsigned size)
+{
+	int ret;
+	struct sk_buff *skb;
+	char *data;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	if (size > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
+		lbtf_deb_sdio("response packet too large (%d bytes)\n",
+			(int)size);
+		ret = -E2BIG;
+		goto out;
+	}
+
+	skb = dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + NET_IP_ALIGN);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	skb_reserve(skb, NET_IP_ALIGN);
+
+	data = skb_put(skb, size);
+
+	memcpy(data, buffer, size);
+
+	lbtf_rx(card->priv, skb);
+
+	ret = 0;
+
+out:
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+}
+
+static int if_sdio_handle_event(struct if_sdio_card *card,
+		u8 *buffer, unsigned size)
+{
+	int ret = 0;
+	u32 event;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	if (card->model == IF_SDIO_MODEL_8385) {
+		event = sdio_readb(card->func, IF_SDIO_EVENT, &ret);
+		if (ret)
+			goto out;
+
+		/* right shift 3 bits to get the event id */
+		event >>= 3;
+	} else {
+		if (size < 4) {
+			lbtf_deb_sdio("event packet too small (%d bytes)\n",
+				(int)size);
+			ret = -EINVAL;
+			goto out;
+		}
+		event = buffer[3] << 24;
+		event |= buffer[2] << 16;
+		event |= buffer[1] << 8;
+		event |= buffer[0] << 0;
+	}
+
+	lbtf_deb_sdio("**EVENT** 0x%X\n", event);
+	ret = 0;
+
+out:
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+}
+
+static int if_sdio_wait_status(struct if_sdio_card *card, const u8 condition)
+{
+	u8 status;
+	unsigned long timeout;
+	int ret = 0;
+
+	timeout = jiffies + HZ;
+	while (1) {
+		status = sdio_readb(card->func, IF_SDIO_STATUS, &ret);
+		if (ret)
+			return ret;
+		if ((status & condition) == condition)
+			break;
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+		mdelay(1);
+	}
+
+	return ret;
+}
+
+static int if_sdio_card_to_host(struct if_sdio_card *card)
+{
+	int ret;
+	u16 size, type, chunk;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+
+	size = if_sdio_read_rx_len(card, &ret);
+	if (ret)
+		goto out;
+
+	if (size < 4) {
+		lbtf_deb_sdio("invalid packet size (%d bytes) from firmware\n",
+			(int)size);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = if_sdio_wait_status(card, IF_SDIO_IO_RDY);
+	if (ret)
+		goto out;
+
+	/*
+	 * The transfer must be in one transaction or the firmware
+	 * goes suicidal. There's no way to guarantee that for all
+	 * controllers, but we can at least try.
+	 */
+	chunk = sdio_align_size(card->func, size);
+
+	ret = sdio_readsb(card->func, card->buffer, card->ioport, chunk);
+	if (ret)
+		goto out;
+
+	chunk = card->buffer[0] | (card->buffer[1] << 8);
+	type = card->buffer[2] | (card->buffer[3] << 8);
+
+	lbtf_deb_sdio("packet of type %d and size %d bytes\n",
+		(int)type, (int)chunk);
+
+	if (chunk > size) {
+		lbtf_deb_sdio("packet fragment (%d > %d)\n",
+			(int)chunk, (int)size);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (chunk < size) {
+		lbtf_deb_sdio("packet fragment (%d < %d)\n",
+			(int)chunk, (int)size);
+	}
+
+	switch (type) {
+	case MVMS_CMD:
+		ret = if_sdio_handle_cmd(card, card->buffer + 4, chunk - 4);
+		if (ret)
+			goto out;
+		break;
+	case MVMS_DAT:
+		ret = if_sdio_handle_data(card, card->buffer + 4, chunk - 4);
+		if (ret)
+			goto out;
+		break;
+	case MVMS_EVENT:
+		ret = if_sdio_handle_event(card, card->buffer + 4, chunk - 4);
+		if (ret)
+			goto out;
+		break;
+	default:
+		lbtf_deb_sdio("invalid type (%d) from firmware\n",
+				(int)type);
+		ret = -EINVAL;
+		goto out;
+	}
+
+out:
+	if (ret)
+		pr_err("problem fetching packet from firmware\n");
+
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+}
+
+static void if_sdio_host_to_card_worker(struct work_struct *work)
+{
+	struct if_sdio_card *card;
+	struct if_sdio_packet *packet;
+	int ret;
+	unsigned long flags;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	card = container_of(work, struct if_sdio_card, packet_worker);
+
+	while (1) {
+		spin_lock_irqsave(&card->lock, flags);
+		packet = card->packets;
+		if (packet)
+			card->packets = packet->next;
+		spin_unlock_irqrestore(&card->lock, flags);
+
+		if (!packet)
+			break;
+
+		// Check for removed device
+		if (card->priv->surpriseremoved) {
+			lbtf_deb_sdio("Device removed\n");
+			kfree(packet);
+			break;
+		}
+
+		sdio_claim_host(card->func);
+
+		ret = if_sdio_wait_status(card, IF_SDIO_IO_RDY);
+		if (ret == 0) {
+			ret = sdio_writesb(card->func, card->ioport,
+					   packet->buffer, packet->nb);
+		}
+
+		if (ret)
+			pr_err("error %d sending packet to firmware\n", ret);
+
+		sdio_release_host(card->func);
+
+		kfree(packet);
+	}
+
+	lbtf_deb_leave(LBTF_DEB_SDIO);
+}
+
+/********************************************************************/
+/* Firmware                                                         */
+/********************************************************************/
+
+#define FW_DL_READY_STATUS (IF_SDIO_IO_RDY | IF_SDIO_DL_RDY)
+
+static int if_sdio_prog_helper(struct if_sdio_card *card)
+{
+	int ret;
+	const struct firmware *fw;
+	unsigned long timeout;
+	u8 *chunk_buffer;
+	u32 chunk_size;
+	const u8 *firmware;
+	size_t size;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	ret = request_firmware(&fw, card->helper, &card->func->dev);
+
+	if (ret) {
+		pr_err("failed to load helper firmware\n");
+		goto out;
+	}
+
+	chunk_buffer = kzalloc(64, GFP_KERNEL);
+	if (!chunk_buffer) {
+		ret = -ENOMEM;
+		goto release_fw;
+	}
+
+	sdio_claim_host(card->func);
+
+	ret = sdio_set_block_size(card->func, 32);
+	if (ret)
+		goto release;
+
+	firmware = fw->data;
+	size = fw->size;
+
+	lbtf_deb_sdio("Helper size: %d", size);
+
+	while (size) {
+		ret = if_sdio_wait_status(card, FW_DL_READY_STATUS);
+		if (ret)
+			goto release;
+
+		/* On some platforms (like Davinci) the chip needs more time
+		 * between helper blocks.
+		 */
+		mdelay(2);
+
+		chunk_size = min(size, (size_t)60);
+
+		*((__le32*)chunk_buffer) = cpu_to_le32(chunk_size);
+		memcpy(chunk_buffer + 4, firmware, chunk_size);
+
+		// lbtf_deb_sdio("sending %d bytes chunk\n", chunk_size);
+
+		ret = sdio_writesb(card->func, card->ioport,
+				chunk_buffer, 64);
+		if (ret)
+			goto release;
+
+		firmware += chunk_size;
+		size -= chunk_size;
+	}
+
+	/* an empty block marks the end of the transfer */
+	memset(chunk_buffer, 0, 4);
+	ret = sdio_writesb(card->func, card->ioport, chunk_buffer, 64);
+	if (ret)
+		goto release;
+
+	lbtf_deb_sdio("waiting for helper to boot...\n");
+
+	/* wait for the helper to boot by looking at the size register */
+	timeout = jiffies + HZ;
+	while (1) {
+		u16 req_size;
+
+		req_size = sdio_readb(card->func, IF_SDIO_RD_BASE, &ret);
+		if (ret)
+			goto release;
+
+		req_size |= sdio_readb(card->func, IF_SDIO_RD_BASE + 1, &ret) << 8;
+		if (ret)
+			goto release;
+
+		if (req_size != 0)
+			break;
+
+		if (time_after(jiffies, timeout)) {
+			ret = -ETIMEDOUT;
+			goto release;
+		}
+
+		msleep(10);
+	}
+
+	ret = 0;
+
+release:
+	sdio_release_host(card->func);
+	kfree(chunk_buffer);
+release_fw:
+	release_firmware(fw);
+
+out:
+	if (ret)
+		pr_err("failed to load helper firmware\n");
+
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+}
+
+static int if_sdio_prog_real(struct if_sdio_card *card)
+{
+	int ret;
+	const struct firmware *fw;
+	unsigned long timeout;
+	u8 *chunk_buffer;
+	u32 chunk_size;
+	const u8 *firmware;
+	size_t size, req_size;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	ret = request_firmware(&fw, card->firmware, &card->func->dev);
+	if (ret) {
+		pr_err("can't load firmware\n");
+		goto out;
+	}
+
+	chunk_buffer = kzalloc(512, GFP_KERNEL);
+	if (!chunk_buffer) {
+		ret = -ENOMEM;
+		goto release_fw;
+	}
+
+	sdio_claim_host(card->func);
+
+	ret = sdio_set_block_size(card->func, 32);
+	if (ret)
+		goto release;
+
+	firmware = fw->data;
+	size = fw->size;
+
+	lbtf_deb_sdio("Firmware size: %d", size);
+
+	while (size) {
+		ret = if_sdio_wait_status(card, FW_DL_READY_STATUS);
+		if (ret)
+			goto release;
+
+		req_size = sdio_readb(card->func, IF_SDIO_RD_BASE, &ret);
+		if (ret)
+			goto release;
+
+		req_size |= sdio_readb(card->func, IF_SDIO_RD_BASE + 1, &ret) << 8;
+		if (ret)
+			goto release;
+
+		if (req_size == 0) {
+			lbtf_deb_sdio("firmware helper gave up early\n");
+			ret = -EIO;
+			goto release;
+		}
+
+		if (req_size & 0x01) {
+			lbtf_deb_sdio("firmware helper signalled error\n");
+			ret = -EIO;
+			goto release;
+		}
+
+		if (req_size > size)
+			req_size = size;
+
+		while (req_size) {
+			chunk_size = min(req_size, (size_t)512);
+
+			memcpy(chunk_buffer, firmware, chunk_size);
+			ret = sdio_writesb(card->func, card->ioport,
+				chunk_buffer, roundup(chunk_size, 32));
+			if (ret)
+				goto release;
+
+			firmware += chunk_size;
+			size -= chunk_size;
+			req_size -= chunk_size;
+		}
+	}
+
+	ret = 0;
+
+	lbtf_deb_sdio("waiting for firmware to boot...\n");
+
+	/* wait for the firmware to boot */
+	timeout = jiffies + HZ;
+	while (1) {
+		u16 scratch;
+
+		scratch = if_sdio_read_scratch(card, &ret);
+		if (ret)
+			goto release;
+
+		if (scratch == IF_SDIO_FIRMWARE_OK)
+			break;
+
+		if (time_after(jiffies, timeout)) {
+			ret = -ETIMEDOUT;
+			goto release;
+		}
+
+		msleep(10);
+	}
+
+	ret = 0;
+
+release:
+	sdio_release_host(card->func);
+	kfree(chunk_buffer);
+release_fw:
+	release_firmware(fw);
+
+out:
+	if (ret)
+		pr_err("failed to load firmware\n");
+
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+}
+
+static int if_sdio_prog_firmware(struct if_sdio_card *card)
+{
+	int ret;
+	u16 scratch;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	/*
+	 * Disable interrupts
+	 */
+	ret = if_sdio_disable_interrupts(card->priv);
+	if (ret)
+		pr_warning("unable to disable interrupts: %d", ret);
+
+	sdio_claim_host(card->func);
+	scratch = if_sdio_read_scratch(card, &ret);
+	sdio_release_host(card->func);
+
+	if (ret)
+		goto out;
+
+	lbtf_deb_sdio("firmware status = %#x\n", scratch);
+
+	if (scratch == IF_SDIO_FIRMWARE_OK) {
+		lbtf_deb_sdio("firmware already loaded\n");
+		goto success;
+	} else if ((card->model == IF_SDIO_MODEL_8686) && (scratch > 0)) {
+		lbtf_deb_sdio("firmware may be running\n");
+		goto success;
+	}
+
+	ret = if_sdio_prog_helper(card);
+	if (ret)
+		goto out;
+
+	lbtf_deb_sdio("Helper firmware loaded\n");
+
+	ret = if_sdio_prog_real(card);
+	if (ret)
+		goto out;
+
+	lbtf_deb_sdio("Firmware loaded\n");
+
+success:
+	/*
+	 * Enable interrupts now that everything is set up
+	 */
+	ret = if_sdio_enable_interrupts(card->priv);
+	if (ret) {
+		pr_err("Error enabling interrupts: %d", ret);
+		goto out;
+	}
+
+	sdio_claim_host(card->func);
+	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
+	sdio_release_host(card->func);
+
+out:
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+}
+
+/*******************************************************************/
+/* Libertas callbacks                                              */
+/*******************************************************************/
+
+static int if_sdio_host_to_card(struct lbtf_private *priv,
+		u8 type, u8 *buf, u16 nb)
+{
+	int ret;
+	struct if_sdio_card *card;
+	struct if_sdio_packet *packet, *cur;
+	u16 size;
+	unsigned long flags;
+
+	lbtf_deb_enter_args(LBTF_DEB_SDIO, "type %d, bytes %d", type, nb);
+
+	card = priv->card;
+
+	if (nb > (65536 - sizeof(struct if_sdio_packet) - 4)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * The transfer must be in one transaction or the firmware
+	 * goes suicidal. There's no way to guarantee that for all
+	 * controllers, but we can at least try.
+	 */
+	size = sdio_align_size(card->func, nb + 4);
+
+	packet = kzalloc(sizeof(struct if_sdio_packet) + size,
+			GFP_ATOMIC);
+	if (!packet) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	packet->next = NULL;
+	packet->nb = size;
+
+	/*
+	 * SDIO specific header.
+	 */
+	packet->buffer[0] = (nb + 4) & 0xff;
+	packet->buffer[1] = ((nb + 4) >> 8) & 0xff;
+	packet->buffer[2] = type;
+	packet->buffer[3] = 0;
+
+	memcpy(packet->buffer + 4, buf, nb);
+
+	spin_lock_irqsave(&card->lock, flags);
+
+	if (!card->packets)
+		card->packets = packet;
+	else {
+		cur = card->packets;
+		while (cur->next)
+			cur = cur->next;
+		cur->next = packet;
+	}
+
+	/* TODO: the dndl_sent has to do with sleep stuff.
+	 * Commented out till we add that.
+	 */
+	switch (type) {
+	case MVMS_CMD:
+		/* priv->dnld_sent = DNLD_CMD_SENT;
+		break; */
+	case MVMS_DAT:
+		/*priv->dnld_sent = DNLD_DATA_SENT;*/
+		break;
+	default:
+		lbtf_deb_sdio("unknown packet type %d\n", (int)type);
+	}
+
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	queue_work(card->workqueue, &card->packet_worker);
+
+	ret = 0;
+
+out:
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+}
+
+static int if_sdio_enter_deep_sleep(struct lbtf_private *priv)
+{
+	int ret = -1;
+	return ret;
+}
+
+static int if_sdio_exit_deep_sleep(struct lbtf_private *priv)
+{
+	struct if_sdio_card *card = priv->card;
+	int ret = -1;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+	return ret;
+}
+
+static int if_sdio_reset_deep_sleep_wakeup(struct lbtf_private *priv)
+{
+	struct if_sdio_card *card = priv->card;
+	int ret = -1;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+	return ret;
+
+}
+
+static void if_sdio_reset_device(struct if_sdio_card *card)
+{
+	struct cmd_ds_802_11_reset cmd;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.command = cpu_to_le16(CMD_802_11_RESET);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_HALT);
+
+	if_sdio_host_to_card(card->priv, MVMS_CMD, (u8 *) &cmd, sizeof(cmd));
+
+	msleep(100);
+
+	lbtf_deb_leave(LBTF_DEB_SDIO);
+
+	return;
+}
+EXPORT_SYMBOL_GPL(if_sdio_reset_device);
+
+/*******************************************************************/
+/* SDIO callbacks                                                  */
+/*******************************************************************/
+
+static void if_sdio_interrupt(struct sdio_func *func)
+{
+	int ret;
+	struct if_sdio_card *card;
+	u8 cause;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	card = sdio_get_drvdata(func);
+
+	cause = sdio_readb(card->func, IF_SDIO_H_INT_STATUS, &ret);
+	if (ret)
+		goto out;
+
+	lbtf_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
+
+	sdio_writeb(card->func, ~cause, IF_SDIO_H_INT_STATUS, &ret);
+	if (ret)
+		goto out;
+
+	/*
+	 * Ignore the define name, this really means the card has
+	 * successfully received the command.
+	 */
+	if (cause & IF_SDIO_H_INT_DNLD)
+		lbtf_host_to_card_done(card->priv);
+
+
+	if (cause & IF_SDIO_H_INT_UPLD) {
+		ret = if_sdio_card_to_host(card);
+		if (ret)
+			goto out;
+	}
+
+	ret = 0;
+
+out:
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+}
+
+static int if_sdio_probe(struct sdio_func *func,
+		const struct sdio_device_id *id)
+{
+	struct if_sdio_card *card;
+	struct lbtf_private *priv;
+	int ret, i;
+	unsigned int model;
+	struct if_sdio_packet *packet;
+	struct mmc_host *host = func->card->host;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	for (i = 0;i < func->card->num_info;i++) {
+		if (sscanf(func->card->info[i],
+				"802.11 SDIO ID: %x", &model) == 1)
+			break;
+		if (sscanf(func->card->info[i],
+				"ID: %x", &model) == 1)
+			break;
+		if (!strcmp(func->card->info[i], "IBIS Wireless SDIO Card")) {
+			model = IF_SDIO_MODEL_8385;
+			break;
+		}
+	}
+
+	if (i == func->card->num_info) {
+		pr_err("unable to identify card model\n");
+		return -ENODEV;
+	}
+
+	lbtf_deb_sdio("Found model: 0x%x", model);
+
+	card = kzalloc(sizeof(struct if_sdio_card), GFP_KERNEL);
+	if (!card)
+		return -ENOMEM;
+
+	card->func = func;
+	card->model = model;
+
+	switch (card->model) {
+	case IF_SDIO_MODEL_8385:
+		card->scratch_reg = IF_SDIO_SCRATCH_OLD;
+		break;
+	case IF_SDIO_MODEL_8686:
+		lbtf_deb_sdio("Found Marvel 8686");
+		card->scratch_reg = IF_SDIO_SCRATCH;
+		break;
+	case IF_SDIO_MODEL_8688:
+	default: /* for newer chipsets */
+		card->scratch_reg = IF_SDIO_FW_STATUS;
+		break;
+	}
+
+	spin_lock_init(&card->lock);
+	card->workqueue = create_workqueue("libertas_tf_sdio");
+	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
+
+	for (i = 0;i < ARRAY_SIZE(if_sdio_models);i++) {
+		if (card->model == if_sdio_models[i].model)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(if_sdio_models)) {
+		pr_err("unknown card model 0x%x\n", card->model);
+		ret = -ENODEV;
+		goto free;
+	}
+
+	card->helper = if_sdio_models[i].helper;
+	card->firmware = if_sdio_models[i].firmware;
+
+	if (lbtf_helper_name) {
+		lbtf_deb_sdio("overriding helper firmware: %s\n",
+			lbtf_helper_name);
+		card->helper = lbtf_helper_name;
+	}
+
+	if (lbtf_fw_name) {
+		lbtf_deb_sdio("overriding firmware: %s\n", lbtf_fw_name);
+		card->firmware = lbtf_fw_name;
+	}
+
+	sdio_claim_host(func);
+
+	ret = sdio_enable_func(func);
+	if (ret)
+		goto release;
+
+	ret = sdio_claim_irq(func, if_sdio_interrupt);
+	if (ret)
+		goto disable;
+
+	/* For 1-bit transfers to the 8686 model, we need to enable the
+	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
+	 * bit to allow access to non-vendor registers. */
+	if ((card->model == IF_SDIO_MODEL_8686) &&
+	    (host->caps & MMC_CAP_SDIO_IRQ) &&
+	    (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
+		u8 reg;
+
+		func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
+		reg = sdio_f0_readb(func, SDIO_CCCR_IF, &ret);
+		if (ret)
+			goto release_int;
+
+		reg |= SDIO_BUS_ECSI;
+		sdio_f0_writeb(func, reg, SDIO_CCCR_IF, &ret);
+		if (ret)
+			goto release_int;
+	}
+
+	card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
+	if (ret)
+		goto release_int;
+
+	card->ioport |= sdio_readb(func, IF_SDIO_IOPORT + 1, &ret) << 8;
+	if (ret)
+		goto release_int;
+
+	card->ioport |= sdio_readb(func, IF_SDIO_IOPORT + 2, &ret) << 16;
+	if (ret)
+		goto release_int;
+
+	sdio_release_host(func);
+	sdio_set_drvdata(func, card);
+
+	lbtf_deb_sdio("class = 0x%X, vendor = 0x%X, "
+			"device = 0x%X, model = 0x%X, ioport = 0x%X\n",
+			func->class, func->vendor, func->device,
+			model, (unsigned)card->ioport);
+
+	priv = lbtf_add_card(card, &func->dev);
+	if (!priv) {
+		ret = -ENOMEM;
+		goto reclaim;
+	}
+
+	card->priv = priv;
+	priv->card = card;
+
+	priv->hw_host_to_card = if_sdio_host_to_card;
+	priv->hw_prog_firmware = if_sdio_prog_firmware;
+	priv->enter_deep_sleep = if_sdio_enter_deep_sleep;
+	priv->exit_deep_sleep = if_sdio_exit_deep_sleep;
+	priv->reset_deep_sleep_wakeup = if_sdio_reset_deep_sleep_wakeup;
+	priv->hw_reset_device = if_sdio_reset_device;
+	priv->enable_interrupts = if_sdio_enable_interrupts;
+	priv->disable_interrupts = if_sdio_disable_interrupts;
+
+	/* SD8385 & SD8686 do not have rx_unit.	*/
+	card->rx_unit = 0;
+
+out:
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+
+err_activate_card:
+	lbtf_deb_sdio("prob error jump: err_activate_card");
+	flush_workqueue(card->workqueue);
+	lbtf_remove_card(priv);
+reclaim:
+	lbtf_deb_sdio("prob error jump: reclaim");
+	sdio_claim_host(func);
+release_int:
+	lbtf_deb_sdio("prob error jump: release_int");
+	sdio_release_irq(func);
+disable:
+	lbtf_deb_sdio("prob error jump: disable");
+	sdio_disable_func(func);
+release:
+	lbtf_deb_sdio("prob error jump: release");
+	sdio_release_host(func);
+free:
+	lbtf_deb_sdio("prob error jump: free");
+	destroy_workqueue(card->workqueue);
+	while (card->packets) {
+		packet = card->packets;
+		card->packets = card->packets->next;
+		kfree(packet);
+	}
+
+	kfree(card);
+
+	goto out;
+}
+
+static void if_sdio_remove(struct sdio_func *func)
+{
+	struct if_sdio_card *card;
+	struct if_sdio_packet *packet;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	card = sdio_get_drvdata(func);
+
+	card->priv->surpriseremoved = 1;
+
+	lbtf_deb_sdio("call remove card\n");
+	lbtf_remove_card(card->priv);
+
+	flush_workqueue(card->workqueue);
+	destroy_workqueue(card->workqueue);
+
+	sdio_claim_host(func);
+	sdio_release_irq(func);
+	sdio_disable_func(func);
+	sdio_set_drvdata(func, NULL);
+	sdio_release_host(func);
+
+	while (card->packets) {
+		packet = card->packets;
+		card->packets = card->packets->next;
+		kfree(packet);
+	}
+
+	kfree(card);
+
+	lbtf_deb_leave(LBTF_DEB_SDIO);
+}
+
+static int if_sdio_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int if_sdio_resume(struct device *dev)
+{
+	return 0;
+}
+
+static struct dev_pm_ops if_sdio_pm_ops = {
+	.suspend	= if_sdio_suspend,
+	.resume		= if_sdio_resume,
+};
+
+static struct sdio_driver if_sdio_driver = {
+	.name		= "libertas_tf_sdio",
+	.id_table	= if_sdio_ids,
+	.probe		= if_sdio_probe,
+	.remove		= if_sdio_remove,
+	.drv = {
+		.pm = &if_sdio_pm_ops,
+	},
+};
+
+/*******************************************************************/
+/* Module functions                                                */
+/*******************************************************************/
+
+static int __init if_sdio_init_module(void)
+{
+	int ret = 0;
+
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+	printk(KERN_INFO "libertas_tf_sdio: Libertas Thinfirmware SDIO driver\n");
+	printk(KERN_INFO "libertas_tf_sdio: Copyright cozybit Inc.\n");
+	printk(KERN_INFO "libertas_tf_sdio: buildstamp: 6\n");
+
+	ret = sdio_register_driver(&if_sdio_driver);
+
+	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
+
+	return ret;
+}
+
+static void __exit if_sdio_exit_module(void)
+{
+	lbtf_deb_enter(LBTF_DEB_SDIO);
+
+
+	sdio_unregister_driver(&if_sdio_driver);
+
+	lbtf_deb_leave(LBTF_DEB_SDIO);
+}
+
+module_init(if_sdio_init_module);
+module_exit(if_sdio_exit_module);
+
+MODULE_DESCRIPTION("Libertas_tf SDIO WLAN Driver");
+MODULE_AUTHOR("Steve deRosier");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/libertas_tf/if_sdio.h b/drivers/net/wireless/libertas_tf/if_sdio.h
new file mode 100644
index 0000000..12179c1
--- /dev/null
+++ b/drivers/net/wireless/libertas_tf/if_sdio.h
@@ -0,0 +1,56 @@
+/*
+ *  linux/drivers/net/wireless/libertas/if_sdio.h
+ *
+ *  Copyright 2007 Pierre Ossman
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#ifndef _LBS_IF_SDIO_H
+#define _LBS_IF_SDIO_H
+
+#define IF_SDIO_MODEL_8385	0x04
+#define IF_SDIO_MODEL_8686	0x0b
+#define IF_SDIO_MODEL_8688	0x10
+
+#define IF_SDIO_IOPORT		0x00
+
+#define IF_SDIO_H_INT_MASK	0x04
+#define   IF_SDIO_H_INT_OFLOW	0x08
+#define   IF_SDIO_H_INT_UFLOW	0x04
+#define   IF_SDIO_H_INT_DNLD	0x02
+#define   IF_SDIO_H_INT_UPLD	0x01
+
+#define IF_SDIO_H_INT_STATUS	0x05
+#define IF_SDIO_H_INT_RSR	0x06
+#define IF_SDIO_H_INT_STATUS2	0x07
+
+#define IF_SDIO_RD_BASE		0x10
+
+#define IF_SDIO_STATUS		0x20
+#define   IF_SDIO_IO_RDY	0x08
+#define   IF_SDIO_CIS_RDY	0x04
+#define   IF_SDIO_UL_RDY	0x02
+#define   IF_SDIO_DL_RDY	0x01
+
+#define IF_SDIO_C_INT_MASK	0x24
+#define IF_SDIO_C_INT_STATUS	0x28
+#define IF_SDIO_C_INT_RSR	0x2C
+
+#define IF_SDIO_SCRATCH		0x34
+#define IF_SDIO_SCRATCH_OLD	0x80fe
+#define IF_SDIO_FW_STATUS	0x40
+#define   IF_SDIO_FIRMWARE_OK	0xfedc
+
+#define IF_SDIO_RX_LEN		0x42
+#define IF_SDIO_RX_UNIT		0x43
+
+#define IF_SDIO_EVENT           0x80fc
+
+#define IF_SDIO_BLOCK_SIZE	256
+#define CONFIGURATION_REG               0x03
+#define HOST_POWER_UP                   (0x1U << 1)
+#endif
diff --git a/drivers/net/wireless/libertas_tf/libertas_tf.h b/drivers/net/wireless/libertas_tf/libertas_tf.h
index ad77b92..078c52e 100644
--- a/drivers/net/wireless/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/libertas_tf/libertas_tf.h
@@ -190,9 +190,13 @@ struct lbtf_private {
 	struct work_struct tx_work;
 	/** Hardware access */
 	int (*hw_host_to_card) (struct lbtf_private *priv, u8 type, u8 *payload, u16 nb);
-	int (*hw_prog_firmware) (struct if_usb_card *cardp);
-	int (*hw_reset_device) (struct if_usb_card *cardp);
-
+	int (*hw_prog_firmware) (void *cardp);
+	int (*hw_reset_device) (void *cardp);
+	int (*enter_deep_sleep) (struct lbtf_private *priv);
+	int (*exit_deep_sleep) (struct lbtf_private *priv);
+	int (*reset_deep_sleep_wakeup) (struct lbtf_private *priv);
+	int (*enable_interrupts) (struct lbtf_private *priv);
+	int (*disable_interrupts) (struct lbtf_private *priv);
 
 	/** Wlan adapter data structure*/
 	/** STATUS variables */
@@ -256,6 +260,13 @@ struct lbtf_private {
 
 	/* Most recently reported noise in dBm */
 	s8 noise;
+	
+	/* Command responses sent from the hardware to the driver */
+	int cur_cmd_retcode;
+	u8 resp_idx;
+	u8 resp_buf[2][LBS_UPLD_SIZE];
+	u32 resp_len[2];
+
 };
 
 /* 802.11-related definitions */
@@ -488,9 +499,9 @@ struct chan_freq_power *lbtf_get_region_cfp_table(u8 region,
 	int *cfp_no);
 struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev);
 int lbtf_remove_card(struct lbtf_private *priv);
-int lbtf_start_card(struct lbtf_private *priv);
 int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb);
 void lbtf_send_tx_feedback(struct lbtf_private *priv, u8 retrycnt, u8 fail);
+void lbtf_host_to_card_done(struct lbtf_private *priv );
 void lbtf_bcn_sent(struct lbtf_private *priv);
 
 /* support functions for cmd.c */
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 5550755..90ef6c7 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -16,7 +16,7 @@
 #define DRIVER_RELEASE_VERSION "004.p0"
 /* thinfirm version: 5.132.X.pX */
 #define LBTF_FW_VER_MIN		0x05840300
-#define LBTF_FW_VER_MAX		0x0584ffff
+#define LBTF_FW_VER_MAX		0x0900ffff
 #define QOS_CONTROL_LEN		2
 
 /* Module parameters */
@@ -178,12 +178,12 @@ static void command_timer_fn(unsigned long data)
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	if (!priv->cur_cmd) {
-		printk(KERN_DEBUG "libertastf: command timer expired; "
+		printk(KERN_DEBUG "libertas_tf: command timer expired; "
 				  "no pending command\n");
 		goto out;
 	}
 
-	printk(KERN_DEBUG "libertas: command %x timed out\n",
+	printk(KERN_DEBUG "libertas_tf: command %x timed out\n",
 		le16_to_cpu(priv->cur_cmd->cmdbuf->command));
 
 	priv->cmd_timed_out = 1;
@@ -228,6 +228,8 @@ static int lbtf_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct lbtf_private *priv = hw->priv;
 
+	lbtf_deb_enter(LBTF_DEB_TX);
+
 	priv->skb_to_tx = skb;
 	queue_work(lbtf_wq, &priv->tx_work);
 	/*
@@ -235,6 +237,8 @@ static int lbtf_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * there are no buffered multicast frames to send
 	 */
 	ieee80211_stop_queues(priv->hw);
+
+	lbtf_deb_leave(LBTF_DEB_TX);
 	return NETDEV_TX_OK;
 }
 
@@ -250,9 +254,19 @@ static void lbtf_tx_work(struct work_struct *work)
 
 	lbtf_deb_enter(LBTF_DEB_MACOPS | LBTF_DEB_TX);
 
-	if ((priv->vif->type == NL80211_IFTYPE_AP) &&
-	    (!skb_queue_empty(&priv->bc_ps_buf)))
+	/* Below are some extra debugging prints that normally we don't want */
+	/* Change to 1 to reenable */
+#if 0
+	lbtf_deb_tx("priv: %p", priv);
+	lbtf_deb_tx("priv->vif: %p", priv->vif);
+	lbtf_deb_tx("&(priv->bc_ps_buf): %p", &priv->bc_ps_buf);
+#endif
+
+	if (priv->vif &&
+		 (priv->vif->type == NL80211_IFTYPE_AP) &&
+		 (!skb_queue_empty(&priv->bc_ps_buf))) {
 		skb = skb_dequeue(&priv->bc_ps_buf);
+	}
 	else if (priv->skb_to_tx) {
 		skb = priv->skb_to_tx;
 		priv->skb_to_tx = NULL;
@@ -281,8 +295,10 @@ static void lbtf_tx_work(struct work_struct *work)
 		ETH_ALEN);
 	txpd->tx_packet_length = cpu_to_le16(len);
 	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
-	lbtf_deb_hex(LBTF_DEB_TX, "TX Data", skb->data, min_t(unsigned int, skb->len, 100));
-	BUG_ON(priv->tx_skb);
+	lbtf_deb_hex(LBTF_DEB_TX, "TX Data ", skb->data, min_t(unsigned int, skb->len, 100));
+
+	WARN_ON(priv->tx_skb);
+
 	spin_lock_irq(&priv->driver_lock);
 	priv->tx_skb = skb;
 	err = priv->hw_host_to_card(priv, MVMS_DAT, skb->data, skb->len);
@@ -292,6 +308,7 @@ static void lbtf_tx_work(struct work_struct *work)
 		priv->tx_skb = NULL;
 		pr_err("TX error: %d", err);
 	}
+	lbtf_deb_tx("TX success");
 	lbtf_deb_leave(LBTF_DEB_MACOPS | LBTF_DEB_TX);
 }
 
@@ -303,12 +320,22 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
-	if (!priv->fw_ready)
+	if (!priv->fw_ready) {
+		lbtf_deb_main("Going to upload fw...");
 		/* Upload firmware */
 		if (priv->hw_prog_firmware(card))
 			goto err_prog_firmware;
+		else
+			priv->fw_ready = 1;
+	} else {
+		if (priv->enable_interrupts) {
+			priv->enable_interrupts(priv);
+		}
+		lbtf_deb_main("FW was already ready...");
+	}
 
 	/* poke the firmware */
+	lbtf_deb_main("Poking fw...");
 	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
 	priv->radioon = RADIO_ON;
 	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
@@ -322,12 +349,17 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 		goto err_prog_firmware;
 	}
 
-	printk(KERN_INFO "libertastf: Marvell WLAN 802.11 thinfirm adapter\n");
+	printk(KERN_INFO "libertas_tf: Marvell WLAN 802.11 thinfirm adapter\n");
+
+	SET_IEEE80211_PERM_ADDR(hw, priv->current_addr);
+
+	ieee80211_wake_queues(priv->hw);
+
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
 
 err_prog_firmware:
-	priv->hw_reset_device(card);
+//	priv->hw_reset_device(card);
 	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "error programing fw; ret=%d", ret);
 	return ret;
 }
@@ -342,6 +374,8 @@ static void lbtf_op_stop(struct ieee80211_hw *hw)
 
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
+	ieee80211_stop_queues(hw);
+
 	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
@@ -358,12 +392,17 @@ static void lbtf_op_stop(struct ieee80211_hw *hw)
 	priv->radioon = RADIO_OFF;
 	lbtf_set_radio_control(priv);
 
+	if (priv->disable_interrupts) {
+		priv->disable_interrupts(priv);
+	}
+
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 }
 
 static int lbtf_op_add_interface(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif)
 {
+	u8 null_addr[ETH_ALEN] = {0};
 	struct lbtf_private *priv = hw->priv;
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
 	if (priv->vif != NULL)
@@ -382,7 +421,12 @@ static int lbtf_op_add_interface(struct ieee80211_hw *hw,
 		priv->vif = NULL;
 		return -EOPNOTSUPP;
 	}
-	lbtf_set_mac_address(priv, (u8 *) vif->addr);
+
+	if (compare_ether_addr(null_addr, vif->addr) != 0) {
+		lbtf_deb_macops("Setting mac addr: %pM\n", vif->addr);
+		lbtf_set_mac_address(priv, (u8 *) vif->addr);
+	}
+
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
 }
@@ -596,7 +640,7 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 
 	lbtf_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
 	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
-	lbtf_deb_hex(LBTF_DEB_RX, "RX Data", skb->data,
+	lbtf_deb_hex(LBTF_DEB_RX, "RX Data ", skb->data,
 	             min_t(unsigned int, skb->len, 100));
 
 	ieee80211_rx_irqsafe(priv->hw, skb);
@@ -667,7 +711,6 @@ done:
 }
 EXPORT_SYMBOL_GPL(lbtf_add_card);
 
-
 int lbtf_remove_card(struct lbtf_private *priv)
 {
 	struct ieee80211_hw *hw = priv->hw;
@@ -709,6 +752,37 @@ void lbtf_send_tx_feedback(struct lbtf_private *priv, u8 retrycnt, u8 fail)
 }
 EXPORT_SYMBOL_GPL(lbtf_send_tx_feedback);
 
+void lbtf_host_to_card_done(struct lbtf_private *priv )
+{
+	lbtf_deb_enter(LBTF_DEB_MAIN);
+
+	/* Below are some extra debugging prints that normally we don't want */
+	/* Change to 1 to reenable */
+#if 0
+	lbtf_deb_main("priv: %p", priv);
+	lbtf_deb_main("priv->hw: %p", priv->hw);
+	lbtf_deb_main("priv->tx_skb: %p", priv->tx_skb);
+	lbtf_deb_main("priv->skb_to_tx: %p", priv->skb_to_tx);
+#endif
+
+	if (priv->tx_skb) {
+		ieee80211_tx_status_irqsafe(priv->hw, priv->tx_skb);
+		priv->tx_skb = NULL;
+		lbtf_deb_main("Got done on packet.");
+	} else {
+		lbtf_deb_main("Got done on command.");
+	}
+
+	if (!priv->skb_to_tx && skb_queue_empty(&priv->bc_ps_buf)) {
+		ieee80211_wake_queues(priv->hw);
+	} else {
+		queue_work(lbtf_wq, &priv->tx_work);
+	}
+
+	lbtf_deb_leave(LBTF_DEB_THREAD);
+}
+EXPORT_SYMBOL_GPL(lbtf_host_to_card_done);
+
 void lbtf_bcn_sent(struct lbtf_private *priv)
 {
 	struct sk_buff *skb = NULL;
-- 
1.7.0

