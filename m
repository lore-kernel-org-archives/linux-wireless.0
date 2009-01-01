Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:52021 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZAABDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 20:03:48 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] p54spi: p54spi driver
Date: Thu, 1 Jan 2009 02:03:44 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901010203.45033.chunkeey@web.de> (sfid-20090101_020352_248759_B2B05F5D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the p54spi driver itself.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
--- a/drivers/net/wireless/p54/Kconfig	2009-01-01 01:01:06.000000000 +0100
+++ b/drivers/net/wireless/p54/Kconfig	2009-01-01 01:02:14.000000000 +0100
@@ -61,3 +61,12 @@ config P54_PCI
 	  http://prism54.org/
 
 	  If you choose to build a module, it'll be called p54pci.
+
+config P54_SPI
+	tristate "Prism54 SPI (stlc45xx) support"
+	depends on P54_COMMON && SPI_MASTER
+	---help---
+	  This driver is for stlc4550 or stlc4560 based wireless chips.
+	  This driver is experimental and untested.
+
+	  If you choose to build a module, it'll be called p54spi.
diff -Nurp a/drivers/net/wireless/p54/Makefile b/drivers/net/wireless/p54/Makefile
--- a/drivers/net/wireless/p54/Makefile	2009-01-01 01:01:01.000000000 +0100
+++ b/drivers/net/wireless/p54/Makefile	2009-01-01 01:02:14.000000000 +0100
@@ -1,3 +1,4 @@
 obj-$(CONFIG_P54_COMMON)	+= p54common.o
 obj-$(CONFIG_P54_USB)		+= p54usb.o
 obj-$(CONFIG_P54_PCI)		+= p54pci.o
+obj-$(CONFIG_P54_SPI)		+= p54spi.o
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-01-01 00:59:46.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-01-01 01:02:14.000000000 +0100
@@ -428,7 +428,7 @@ static int p54_parse_output_power_limits
 	return 0;
 }
 
-static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
+int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
 	struct eeprom_pda_wrap *wrap = NULL;
@@ -658,6 +658,7 @@ static int p54_parse_eeprom(struct ieee8
 		wiphy_name(dev->wiphy));
 	return err;
 }
+EXPORT_SYMBOL_GPL(p54_parse_eeprom);
 
 static int p54_rssi_to_dbm(struct ieee80211_hw *dev, int rssi)
 {
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2009-01-01 00:59:46.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2009-01-01 01:02:14.000000000 +0100
@@ -284,12 +284,6 @@ struct pda_custom_wrapper {
 #define PDR_COUNTRY_CERT_IODOOR_OUTDOOR	0x30
 #define PDR_COUNTRY_CERT_INDEX		0x0F
 
-/* stored in skb->cb */
-struct memrecord {
-	u32 start_addr;
-	u32 end_addr;
-};
-
 struct p54_eeprom_lm86 {
 	union {
 		struct {
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2009-01-01 00:59:46.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2009-01-01 01:02:14.000000000 +0100
@@ -84,6 +84,21 @@ struct p54_rssi_linear_approximation {
 #define FW_LM87 0x4c4d3837
 #define FW_LM20 0x4c4d3230
 
+enum fw_state {
+	FW_STATE_OFF,
+	FW_STATE_BOOTING,
+	FW_STATE_READY,
+	FW_STATE_RESET,
+	FW_STATE_RESETTING,
+};
+
+/* stored in skb->cb */
+struct memrecord {
+	u32 start_addr;
+	u32 end_addr;
+	u8 driver_data[16];
+};
+
 struct p54_common {
 	struct ieee80211_hw *hw;
 	u32 rx_start;
@@ -134,6 +149,7 @@ struct p54_common {
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
 void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb);
 int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw);
+int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len);
 int p54_read_eeprom(struct ieee80211_hw *dev);
 struct ieee80211_hw *p54_init_common(size_t priv_data_len);
 void p54_free_common(struct ieee80211_hw *dev);
diff -Nurp a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
--- a/drivers/net/wireless/p54/p54spi.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/net/wireless/p54/p54spi.c	2009-01-01 01:02:14.000000000 +0100
@@ -0,0 +1,774 @@
+/*
+ * Copyright (C) 2008 Christian Lamparter <chunkeey@web.de>
+ *
+ * This driver is a port from stlc45xx:
+ *	Copyright (C) 2008 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/spi/spi.h>
+#include <linux/etherdevice.h>
+#include <linux/gpio.h>
+
+#include "p54spi.h"
+#include "p54spi_eeprom.h"
+#include "p54.h"
+
+#include "p54common.h"
+
+MODULE_FIRMWARE("3826.arm");
+MODULE_ALIAS("stlc45xx");
+
+static void p54spi_spi_read(struct p54s_priv *priv, unsigned long addr,
+			      void *buf, size_t len)
+{
+	struct spi_transfer t[2];
+	struct spi_message m;
+
+	/* We first push the address */
+	addr = (addr << 8) | ADDR_READ_BIT_15;
+
+	spi_message_init(&m);
+	memset(t, 0, sizeof(t));
+
+	t[0].tx_buf = &addr;
+	t[0].len = 2;
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].rx_buf = buf;
+	t[1].len = len;
+	spi_message_add_tail(&t[1], &m);
+
+	spi_sync(priv->spi, &m);
+}
+
+
+static void p54spi_spi_write(struct p54s_priv *priv, unsigned long addr,
+			       void *buf, size_t len)
+{
+	struct spi_transfer t[3];
+	struct spi_message m;
+	u16 last_word;
+
+	/* We first push the address */
+	addr = addr << 8;
+
+	spi_message_init(&m);
+	memset(t, 0, sizeof(t));
+
+	t[0].tx_buf = &addr;
+	t[0].len = 2;
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].tx_buf = buf;
+	t[1].len = len;
+	spi_message_add_tail(&t[1], &m);
+
+	if (len % 2) {
+		last_word = ((u8 *)buf)[len - 1];
+
+		t[2].tx_buf = &last_word;
+		t[2].len = 2;
+		spi_message_add_tail(&t[2], &m);
+	}
+
+	spi_sync(priv->spi, &m);
+}
+
+static u16 p54spi_read16(struct p54s_priv *priv, unsigned long addr)
+{
+	u16 val;
+
+	p54spi_spi_read(priv, addr, &val, sizeof(val));
+
+	return val;
+}
+
+static u32 p54spi_read32(struct p54s_priv *priv, unsigned long addr)
+{
+	u32 val;
+
+	p54spi_spi_read(priv, addr, &val, sizeof(val));
+
+	return val;
+}
+
+static void p54spi_write16(struct p54s_priv *priv, unsigned long addr, u16 val)
+{
+	p54spi_spi_write(priv, addr, &val, sizeof(val));
+}
+
+static void p54spi_write32(struct p54s_priv *priv, unsigned long addr, u32 val)
+{
+	p54spi_spi_write(priv, addr, &val, sizeof(val));
+}
+
+struct p54spi_spi_reg {
+	u16 address;		/* __le16 ? */
+	u16 length;
+	char *name;
+};
+
+static const struct p54spi_spi_reg p54spi_registers_array[] =
+{
+	{ SPI_ADRS_ARM_INTERRUPTS,	32, "ARM_INT     " },
+	{ SPI_ADRS_ARM_INT_EN,		32, "ARM_INT_ENA " },
+	{ SPI_ADRS_HOST_INTERRUPTS,	32, "HOST_INT    " },
+	{ SPI_ADRS_HOST_INT_EN,		32, "HOST_INT_ENA" },
+	{ SPI_ADRS_HOST_INT_ACK,	32, "HOST_INT_ACK" },
+	{ SPI_ADRS_GEN_PURP_1,		32, "GP1_COMM    " },
+	{ SPI_ADRS_GEN_PURP_2,		32, "GP2_COMM    " },
+	{ SPI_ADRS_DEV_CTRL_STAT,	32, "DEV_CTRL_STA" },
+	{ SPI_ADRS_DMA_DATA,		16, "DMA_DATA    " },
+	{ SPI_ADRS_DMA_WRITE_CTRL,	16, "DMA_WR_CTRL " },
+	{ SPI_ADRS_DMA_WRITE_LEN,	16, "DMA_WR_LEN  " },
+	{ SPI_ADRS_DMA_WRITE_BASE,	32, "DMA_WR_BASE " },
+	{ SPI_ADRS_DMA_READ_CTRL,	16, "DMA_RD_CTRL " },
+	{ SPI_ADRS_DMA_READ_LEN,	16, "DMA_RD_LEN  " },
+	{ SPI_ADRS_DMA_WRITE_BASE,	32, "DMA_RD_BASE " }
+};
+
+static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, u32 mask,
+			     u32 expected)
+{
+	int i;
+	char buffer[4];
+
+	for (i = 0; i < 2000; i++) {
+		p54spi_spi_read(priv, reg, buffer, sizeof(buffer));
+		if (((*(u32 *) buffer) & mask) == expected)
+			return 1;
+
+		msleep(1);
+	}
+	return 0;
+}
+
+static int p54spi_request_firmware(struct ieee80211_hw *dev)
+{
+	struct p54s_priv *priv = dev->priv;
+	const struct firmware *fw;
+	int ret;
+
+	/* FIXME: should driver use it's own struct device? */
+	ret = request_firmware(&fw, "3826.arm", &priv->spi->dev);
+
+	if (ret < 0) {
+		dev_err(&priv->spi->dev, "request_firmware() failed: %d", ret);
+		return ret;
+	}
+
+	ret = p54_parse_firmware(dev, fw);
+	if (ret) {
+		release_firmware(fw);
+		return ret;
+	}
+
+	priv->fw = kmemdup(fw->data, fw->size, GFP_KERNEL);
+	if (!priv->fw) {
+		dev_err(&priv->spi->dev, "could not get memory for firmware");
+		release_firmware(fw);
+		return -ENOMEM;
+	}
+
+	priv->fw_len = fw->size;
+
+	release_firmware(fw);
+	return 0;
+}
+
+static int p54spi_request_eeprom(struct ieee80211_hw *dev)
+{
+	struct p54s_priv *priv = dev->priv;
+	const struct firmware *eeprom;
+	int ret;
+
+	/*
+	 * allow users to customize their eeprom.
+	 */
+
+	ret = request_firmware(&eeprom, "3826.eeprom", &priv->spi->dev);
+	if (ret < 0) {
+		dev_info(&priv->spi->dev, "loading default eeprom...\n");
+		ret = p54_parse_eeprom(dev, (void *) p54spi_eeprom,
+				       sizeof(p54spi_eeprom));
+	} else {
+		dev_info(&priv->spi->dev, "loading user eeprom...\n");
+		ret = p54_parse_eeprom(dev, (void *) eeprom->data,
+				       (int)eeprom->size);
+		release_firmware(eeprom);
+	}
+	return ret;
+}
+
+static int p54spi_upload_firmware(struct ieee80211_hw *dev)
+{
+	struct p54s_priv *priv = dev->priv;
+	struct s_dma_regs dma_regs;
+	unsigned long fw_len, fw_addr;
+	long _fw_len;
+	int ret;
+
+	if (!priv->fw) {
+		ret = p54spi_request_firmware(dev);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* stop the device */
+	p54spi_write16(priv, SPI_ADRS_DEV_CTRL_STAT,
+		       SPI_CTRL_STAT_HOST_OVERRIDE | SPI_CTRL_STAT_HOST_RESET |
+		       SPI_CTRL_STAT_START_HALTED);
+
+	msleep(TARGET_BOOT_SLEEP);
+
+	p54spi_write16(priv, SPI_ADRS_DEV_CTRL_STAT,
+			SPI_CTRL_STAT_HOST_OVERRIDE |
+			SPI_CTRL_STAT_START_HALTED);
+
+	msleep(TARGET_BOOT_SLEEP);
+
+	fw_addr = FIRMWARE_ADDRESS;
+	fw_len = priv->fw_len;
+
+	while (fw_len > 0) {
+		_fw_len = (fw_len > SPI_MAX_PACKET_SIZE)
+			? SPI_MAX_PACKET_SIZE : fw_len;
+		dma_regs.cmd = SPI_DMA_WRITE_CTRL_ENABLE;
+		dma_regs.len = cpu_to_le16(_fw_len);
+		dma_regs.addr = cpu_to_le32(fw_addr);
+
+		fw_len -= _fw_len;
+		fw_addr += _fw_len;
+
+		p54spi_write16(priv, SPI_ADRS_DMA_WRITE_CTRL, dma_regs.cmd);
+
+		if (p54spi_wait_bit(priv, SPI_ADRS_DMA_WRITE_CTRL,
+				      HOST_ALLOWED, HOST_ALLOWED) == 0) {
+			dev_err(&priv->spi->dev, "fw_upload not allowed "
+				"to DMA write.");
+			return -EAGAIN;
+		}
+
+		p54spi_write16(priv, SPI_ADRS_DMA_WRITE_LEN, dma_regs.len);
+		p54spi_write32(priv, SPI_ADRS_DMA_WRITE_BASE, dma_regs.addr);
+
+		p54spi_spi_write(priv, SPI_ADRS_DMA_DATA, priv->fw, _fw_len);
+
+		/* FIXME: I think this doesn't work if firmware is large,
+		 * this loop goes to second round. fw->data is not
+		 * increased at all! */
+	}
+
+	BUG_ON(fw_len != 0);
+
+	/* enable host interrupts */
+	p54spi_write32(priv, SPI_ADRS_HOST_INT_EN, SPI_HOST_INTS_DEFAULT);
+
+	/* boot the device */
+	p54spi_write16(priv, SPI_ADRS_DEV_CTRL_STAT,
+		       SPI_CTRL_STAT_HOST_OVERRIDE | SPI_CTRL_STAT_HOST_RESET |
+		       SPI_CTRL_STAT_RAM_BOOT);
+
+	msleep(TARGET_BOOT_SLEEP);
+
+	p54spi_write16(priv, SPI_ADRS_DEV_CTRL_STAT,
+		       SPI_CTRL_STAT_HOST_OVERRIDE | SPI_CTRL_STAT_RAM_BOOT);
+	msleep(TARGET_BOOT_SLEEP);
+	return 0;
+}
+
+static void p54spi_power_off(struct p54s_priv *priv)
+{
+	disable_irq(gpio_to_irq(priv->config->irq_gpio));
+	gpio_set_value(priv->config->power_gpio, 0);
+}
+
+static void p54spi_power_on(struct p54s_priv *priv)
+{
+	gpio_set_value(priv->config->power_gpio, 1);
+	enable_irq(gpio_to_irq(priv->config->irq_gpio));
+
+	/*
+	 * need to wait a while before device can be accessed, the lenght
+	 * is just a guess
+	 */
+	msleep(10);
+}
+
+static void p54spi_int_ack(struct p54s_priv *priv, u32 val)
+{
+	p54spi_write32(priv, SPI_ADRS_HOST_INT_ACK, val);
+}
+
+static void p54spi_wakeup(struct p54s_priv *priv)
+{
+	unsigned long timeout;
+	u32 ints;
+
+	/* wake the chip */
+	p54spi_write32(priv, SPI_ADRS_ARM_INTERRUPTS, SPI_TARGET_INT_WAKEUP);
+
+	/* And wait for the READY interrupt */
+	timeout = jiffies + HZ;
+
+	ints =  p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
+	while (!(ints & SPI_HOST_INT_READY)) {
+		if (time_after(jiffies, timeout))
+				goto out;
+		ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
+	}
+
+	p54spi_int_ack(priv, SPI_HOST_INT_READY);
+
+out:
+	return;
+}
+
+static void  p54spi_sleep(struct p54s_priv *priv)
+{
+	p54spi_write32(priv, SPI_ADRS_ARM_INTERRUPTS, SPI_TARGET_INT_SLEEP);
+}
+
+static void  p54spi_int_ready(struct p54s_priv *priv)
+{
+	p54spi_write32(priv, SPI_ADRS_HOST_INT_EN,
+			 SPI_HOST_INT_UPDATE | SPI_HOST_INT_SW_UPDATE);
+
+	switch (priv->fw_state) {
+	case FW_STATE_BOOTING:
+		priv->fw_state = FW_STATE_READY;
+		complete(&priv->fw_comp);
+		break;
+	case FW_STATE_RESETTING:
+		priv->fw_state = FW_STATE_READY;
+		/* TODO: reinitialize state */
+		break;
+	default:
+		break;
+	}
+}
+
+static int p54spi_rx(struct p54s_priv *priv)
+{
+	struct sk_buff *skb;
+	u16 len;
+
+	p54spi_wakeup(priv);
+
+	/* dummy read to flush SPI DMA controller bug */
+	p54spi_read16(priv, SPI_ADRS_GEN_PURP_1);
+
+	len = p54spi_read16(priv, SPI_ADRS_DMA_DATA);
+
+	if (len == 0) {
+		dev_err(&priv->spi->dev, "rx request of zero bytes");
+		return 0;
+	}
+
+	skb = dev_alloc_skb(len);
+	if (!skb) {
+		dev_err(&priv->spi->dev, "could not alloc skb");
+		return 0;
+	}
+
+	p54spi_spi_read(priv, SPI_ADRS_DMA_DATA, skb_put(skb, len), len);
+	p54spi_sleep(priv);
+
+	if (p54_rx(priv->hw, skb) == 0)
+		dev_kfree_skb(skb);
+
+	return 0;
+}
+
+
+static irqreturn_t p54spi_interrupt(int irq, void *config)
+{
+	struct spi_device *spi = config;
+	struct p54s_priv *priv = dev_get_drvdata(&spi->dev);
+
+	queue_work(priv->hw->workqueue, &priv->work);
+
+	return IRQ_HANDLED;
+}
+
+static int p54spi_tx_frame(struct p54s_priv *priv, struct sk_buff *skb)
+{
+	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
+	struct s_dma_regs dma_regs;
+	unsigned long timeout;
+	int ret = 0;
+	u32 ints;
+
+	p54spi_wakeup(priv);
+
+	dma_regs.cmd  = SPI_DMA_WRITE_CTRL_ENABLE;
+	dma_regs.len  = cpu_to_le16(skb->len);
+	dma_regs.addr = cpu_to_le32(hdr->req_id);
+
+	p54spi_spi_write(priv, SPI_ADRS_DMA_WRITE_CTRL, &dma_regs,
+			   sizeof(dma_regs));
+
+	p54spi_spi_write(priv, SPI_ADRS_DMA_DATA, skb->data, skb->len);
+
+	timeout = jiffies + 2 * HZ;
+	ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
+	while (!(ints & SPI_HOST_INT_WR_READY)) {
+		if (time_after(jiffies, timeout)) {
+			dev_err(&priv->spi->dev, "WR_READY timeout");
+			ret = -1;
+			goto out;
+		}
+		ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
+	}
+
+	p54spi_int_ack(priv, SPI_HOST_INT_WR_READY);
+	p54spi_sleep(priv);
+
+out:
+	if (FREE_AFTER_TX(skb))
+		p54_free_skb(priv->hw, skb);
+	return ret;
+}
+
+static int p54spi_wq_tx(struct p54s_priv *priv)
+{
+	struct p54s_tx_info *entry;
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
+	struct memrecord *range;
+	struct p54s_tx_info *dinfo;
+	int ret = 0;
+
+	spin_lock_bh(&priv->tx_lock);
+
+	while (!list_empty(&priv->tx_pending)) {
+		entry = list_entry(priv->tx_pending.next,
+				   struct p54s_tx_info, tx_list);
+
+		list_del_init(&entry->tx_list);
+
+		spin_unlock_bh(&priv->tx_lock);
+
+		dinfo = container_of((void *) entry, struct p54s_tx_info,
+				     tx_list);
+		range = container_of((void *) dinfo, struct memrecord,
+				     driver_data);
+		info = container_of((void *) range, struct ieee80211_tx_info,
+				    rate_driver_data);
+		skb = container_of((void *) info, struct sk_buff, cb);
+
+		ret = p54spi_tx_frame(priv, skb);
+
+		spin_lock_bh(&priv->tx_lock);
+
+		if (ret < 0) {
+			p54_free_skb(priv->hw, skb);
+			goto out;
+		}
+	}
+
+out:
+	spin_unlock_bh(&priv->tx_lock);
+	return ret;
+}
+
+static void p54spi_op_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
+{
+	struct p54s_priv *priv = dev->priv;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct memrecord *range = (struct memrecord *) info->rate_driver_data;
+	struct p54s_tx_info *dinfo = (struct p54s_tx_info *)
+					range->driver_data;
+
+	BUILD_BUG_ON(sizeof(*dinfo) > sizeof((range->driver_data)));
+
+	spin_lock_bh(&priv->tx_lock);
+	list_add_tail(&dinfo->tx_list, &priv->tx_pending);
+	spin_unlock_bh(&priv->tx_lock);
+
+	queue_work(priv->hw->workqueue, &priv->work);
+}
+
+static void p54spi_work(struct work_struct *work)
+{
+	struct p54s_priv *priv = container_of(work, struct p54s_priv, work);
+	u32 ints;
+	int ret;
+
+	mutex_lock(&priv->mutex);
+
+	if (priv->fw_state == FW_STATE_OFF &&
+	    priv->fw_state == FW_STATE_RESET)
+		goto out;
+
+	ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
+
+	if (ints & SPI_HOST_INT_READY) {
+		p54spi_int_ready(priv);
+		p54spi_int_ack(priv, SPI_HOST_INT_READY);
+	}
+
+	if (priv->fw_state != FW_STATE_READY)
+		goto out;
+
+	if (ints & SPI_HOST_INT_UPDATE) {
+		p54spi_int_ack(priv, SPI_HOST_INT_UPDATE);
+		ret = p54spi_rx(priv);
+		if (ret < 0)
+			goto out;
+	}
+	if (ints & SPI_HOST_INT_SW_UPDATE) {
+		p54spi_int_ack(priv, SPI_HOST_INT_SW_UPDATE);
+		ret = p54spi_rx(priv);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = p54spi_wq_tx(priv);
+	if (ret < 0)
+		goto out;
+
+	ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
+
+out:
+	mutex_unlock(&priv->mutex);
+}
+
+static int p54spi_op_start(struct ieee80211_hw *dev)
+{
+	struct p54s_priv *priv = dev->priv;
+	unsigned long timeout;
+	int ret = 0;
+
+	if (mutex_lock_interruptible(&priv->mutex)) {
+		ret = -EINTR;
+		goto out;
+	}
+
+	priv->fw_state = FW_STATE_BOOTING;
+
+	p54spi_power_on(priv);
+
+	ret = p54spi_upload_firmware(dev);
+	if (ret < 0) {
+		p54spi_power_off(priv);
+		goto out_unlock;
+	}
+
+	mutex_unlock(&priv->mutex);
+
+	timeout = msecs_to_jiffies(2000);
+	timeout = wait_for_completion_interruptible_timeout(&priv->fw_comp,
+							    timeout);
+	if (!timeout) {
+		dev_err(&priv->spi->dev, "firmware boot failed");
+		p54spi_power_off(priv);
+		ret = -1;
+		goto out;
+	}
+
+	if (mutex_lock_interruptible(&priv->mutex)) {
+		ret = -EINTR;
+		p54spi_power_off(priv);
+		goto out;
+	}
+
+	WARN_ON(priv->fw_state != FW_STATE_READY);
+
+out_unlock:
+	mutex_unlock(&priv->mutex);
+
+out:
+	return ret;
+}
+
+static void p54spi_op_stop(struct ieee80211_hw *dev)
+{
+	struct p54s_priv *priv = dev->priv;
+
+	if (mutex_lock_interruptible(&priv->mutex)) {
+		/* FIXME: how to handle this error? */
+		return;
+	}
+
+	WARN_ON(priv->fw_state != FW_STATE_READY);
+
+	cancel_work_sync(&priv->work);
+
+	p54spi_power_off(priv);
+	spin_lock_bh(&priv->tx_lock);
+	INIT_LIST_HEAD(&priv->tx_pending);
+	spin_unlock_bh(&priv->tx_lock);
+
+	priv->fw_state = FW_STATE_OFF;
+	mutex_unlock(&priv->mutex);
+}
+
+static int __devinit p54spi_probe(struct spi_device *spi)
+{
+	struct p54s_priv *priv = NULL;
+	struct ieee80211_hw *hw;
+	int ret = -EINVAL;
+
+	hw = p54_init_common(sizeof(*priv));
+	if (!hw) {
+		dev_err(&priv->spi->dev, "could not alloc ieee80211_hw");
+		return -ENOMEM;
+	}
+
+	priv = hw->priv;
+	priv->hw = hw;
+	dev_set_drvdata(&spi->dev, priv);
+	priv->spi = spi;
+
+	priv->config = omap_get_config(OMAP_TAG_WLAN_CX3110X,
+				       struct omap_wlan_cx3110x_config);
+
+	spi->bits_per_word = 16;
+	spi->max_speed_hz = 24000000;
+
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		dev_err(&priv->spi->dev, "spi_setup failed");
+		goto err_free_common;
+	}
+
+	ret = gpio_request(priv->config->power_gpio, "p54spi power");
+	if (ret < 0) {
+		dev_err(&priv->spi->dev, "power GPIO request failed: %d", ret);
+		goto err_free_common;
+	}
+
+	ret = gpio_request(priv->config->irq_gpio, "p54spi irq");
+	if (ret < 0) {
+		dev_err(&priv->spi->dev, "irq GPIO request failed: %d", ret);
+		goto err_free_common;
+	}
+
+	gpio_direction_output(priv->config->power_gpio, 0);
+	gpio_direction_input(priv->config->irq_gpio);
+
+	ret = request_irq(OMAP_GPIO_IRQ(priv->config->irq_gpio),
+			  p54spi_interrupt, IRQF_DISABLED, "p54spi",
+			  priv->spi);
+	if (ret < 0) {
+		dev_err(&priv->spi->dev, "request_irq() failed");
+		goto err_free_common;
+	}
+
+	set_irq_type(gpio_to_irq(priv->config->irq_gpio),
+		     IRQ_TYPE_EDGE_RISING);
+
+	disable_irq(gpio_to_irq(priv->config->irq_gpio));
+
+	INIT_WORK(&priv->work, p54spi_work);
+	init_completion(&priv->fw_comp);
+	INIT_LIST_HEAD(&priv->tx_pending);
+	mutex_init(&priv->mutex);
+	SET_IEEE80211_DEV(hw, &spi->dev);
+	priv->common.open = p54spi_op_start;
+	priv->common.stop = p54spi_op_stop;
+	priv->common.tx = p54spi_op_tx;
+
+	ret = p54spi_request_firmware(hw);
+	if (ret < 0)
+		goto err_free_common;
+
+	ret = p54spi_request_eeprom(hw);
+	if (ret)
+		goto err_free_common;
+
+	ret = ieee80211_register_hw(hw);
+	if (ret) {
+		dev_err(&priv->spi->dev, "unable to register "
+					 "mac80211 hw: %d", ret);
+		goto err_free_common;
+	}
+
+	dev_info(&priv->spi->dev, "device is bound to %s\n",
+		 wiphy_name(hw->wiphy));
+	return 0;
+
+err_free_common:
+	p54_free_common(priv->hw);
+	return ret;
+}
+
+static int __devexit p54spi_remove(struct spi_device *spi)
+{
+	struct p54s_priv *priv = dev_get_drvdata(&spi->dev);
+
+	ieee80211_unregister_hw(priv->hw);
+
+	free_irq(gpio_to_irq(priv->config->irq_gpio), spi);
+
+	gpio_free(priv->config->power_gpio);
+	gpio_free(priv->config->irq_gpio);
+	kfree(priv->fw);
+
+	mutex_destroy(&priv->mutex);
+
+	p54_free_common(priv->hw);
+	ieee80211_free_hw(priv->hw);
+
+	return 0;
+}
+
+
+static struct spi_driver p54spi_driver = {
+	.driver = {
+		/* use cx3110x name because board-n800.c uses that for the
+		 * SPI port */
+		.name		= "cx3110x",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= p54spi_probe,
+	.remove		= __devexit_p(p54spi_remove),
+};
+
+static int __init p54spi_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&p54spi_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "failed to register SPI driver: %d", ret);
+		goto out;
+	}
+
+ out:
+	return ret;
+}
+
+static void __exit p54spi_exit(void)
+{
+	spi_unregister_driver(&p54spi_driver);
+}
+
+module_init(p54spi_init);
+module_exit(p54spi_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christian Lamparter <chunkeey@web.de>");
diff -Nurp a/drivers/net/wireless/p54/p54spi.h b/drivers/net/wireless/p54/p54spi.h
--- a/drivers/net/wireless/p54/p54spi.h	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/net/wireless/p54/p54spi.h	2009-01-01 01:02:14.000000000 +0100
@@ -0,0 +1,134 @@
+/*
+ * Copyright (C) 2008 Christian Lamparter <chunkeey@web.de>
+ *
+ * This driver is a port from stlc45xx:
+ *	Copyright (C) 2008 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef P54SPI_H
+#define P54SPI_H
+
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <net/mac80211.h>
+#include <mach/board.h>
+
+#include "p54.h"
+
+/* Bit 15 is read/write bit; ON = READ, OFF = WRITE */
+#define ADDR_READ_BIT_15  0x8000
+
+#define SPI_ADRS_ARM_INTERRUPTS     0x00
+#define SPI_ADRS_ARM_INT_EN	    0x04
+
+#define SPI_ADRS_HOST_INTERRUPTS    0x08
+#define SPI_ADRS_HOST_INT_EN	    0x0c
+#define SPI_ADRS_HOST_INT_ACK	    0x10
+
+#define SPI_ADRS_GEN_PURP_1   	    0x14
+#define SPI_ADRS_GEN_PURP_2   	    0x18
+
+#define SPI_ADRS_DEV_CTRL_STAT      0x26    /* high word */
+
+#define SPI_ADRS_DMA_DATA      	    0x28
+
+#define SPI_ADRS_DMA_WRITE_CTRL     0x2c
+#define SPI_ADRS_DMA_WRITE_LEN      0x2e
+#define SPI_ADRS_DMA_WRITE_BASE     0x30
+
+#define SPI_ADRS_DMA_READ_CTRL      0x34
+#define SPI_ADRS_DMA_READ_LEN       0x36
+#define SPI_ADRS_DMA_READ_BASE      0x38
+
+#define SPI_CTRL_STAT_HOST_OVERRIDE 0x8000
+#define SPI_CTRL_STAT_START_HALTED  0x4000
+#define SPI_CTRL_STAT_RAM_BOOT      0x2000
+#define SPI_CTRL_STAT_HOST_RESET    0x1000
+#define SPI_CTRL_STAT_HOST_CPU_EN   0x0800
+
+#define SPI_DMA_WRITE_CTRL_ENABLE   0x0001
+#define SPI_DMA_READ_CTRL_ENABLE    0x0001
+#define HOST_ALLOWED                (1 << 7)
+
+#define FIRMWARE_ADDRESS                        0x20000
+
+#define SPI_TIMEOUT                             100         /* msec */
+
+#define SPI_MAX_TX_PACKETS                      32
+
+#define SPI_MAX_PACKET_SIZE                     32767
+
+#define SPI_TARGET_INT_WAKEUP                   0x00000001
+#define SPI_TARGET_INT_SLEEP                    0x00000002
+#define SPI_TARGET_INT_RDDONE                   0x00000004
+
+#define SPI_TARGET_INT_CTS                      0x00004000
+#define SPI_TARGET_INT_DR                       0x00008000
+
+#define SPI_HOST_INT_READY                      0x00000001
+#define SPI_HOST_INT_WR_READY                   0x00000002
+#define SPI_HOST_INT_SW_UPDATE                  0x00000004
+#define SPI_HOST_INT_UPDATE                     0x10000000
+
+/* clear to send */
+#define SPI_HOST_INT_CTS	                0x00004000
+
+/* data ready */
+#define SPI_HOST_INT_DR	                        0x00008000
+
+#define SPI_HOST_INTS_DEFAULT \
+	(SPI_HOST_INT_READY | SPI_HOST_INT_UPDATE | SPI_HOST_INT_SW_UPDATE)
+
+#define TARGET_BOOT_SLEEP 50
+
+/* unit is ms */
+#define TX_FRAME_LIFETIME 2000
+#define TX_TIMEOUT 4000
+
+struct s_dma_regs {
+	__le16 cmd;
+	__le16 len;
+	__le32 addr;
+};
+
+struct p54s_tx_info {
+	struct list_head tx_list;
+};
+
+struct p54s_priv {
+	/* p54_common has to be the first entry */
+	struct p54_common common;
+	struct ieee80211_hw *hw;
+	struct spi_device *spi;
+	const struct omap_wlan_cx3110x_config *config;
+
+	struct work_struct work;
+
+	struct mutex mutex;
+	struct completion fw_comp;
+
+	spinlock_t tx_lock;
+
+	/* protected by tx_lock */
+	struct list_head tx_pending;
+
+	enum fw_state fw_state;
+	u8 *fw;
+	int fw_len;
+};
+
+#endif /* P54SPI_H */
