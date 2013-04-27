Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:38956 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3D0T2K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 15:28:10 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 12/14] cw1200: v6: Platform definitions, plus SDIO and SPI bus glue code.
Date: Sat, 27 Apr 2013 15:27:25 -0400
Message-Id: <1367090847-11937-13-git-send-email-pizza@shaftnet.org> (sfid-20130427_212935_892304_4D35BFA4)
In-Reply-To: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
References: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200_sdio.c | 409 +++++++++++++++++++++++++
 drivers/net/wireless/cw1200/cw1200_spi.c  | 480 ++++++++++++++++++++++++++++++
 include/linux/cw1200_platform.h           |  46 +++
 3 files changed, 935 insertions(+)
 create mode 100644 drivers/net/wireless/cw1200/cw1200_sdio.c
 create mode 100644 drivers/net/wireless/cw1200/cw1200_spi.c
 create mode 100644 include/linux/cw1200_platform.h

diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
new file mode 100644
index 0000000..f6e2219
--- /dev/null
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -0,0 +1,409 @@
+/*
+ * Mac80211 SDIO driver for ST-Ericsson CW1200 device
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio.h>
+#include <net/mac80211.h>
+
+#include "cw1200.h"
+#include "sbus.h"
+#include <linux/cw1200_platform.h>
+#include "hwio.h"
+
+MODULE_AUTHOR("Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>");
+MODULE_DESCRIPTION("mac80211 ST-Ericsson CW1200 SDIO driver");
+MODULE_LICENSE("GPL");
+
+#define SDIO_BLOCK_SIZE (512)
+
+struct sbus_priv {
+	struct sdio_func	*func;
+	struct cw1200_common	*core;
+	const struct cw1200_platform_data_sdio *pdata;
+};
+
+#ifndef SDIO_VENDOR_ID_STE
+#define SDIO_VENDOR_ID_STE		0x0020
+#endif
+
+#ifndef SDIO_DEVICE_ID_STE_CW1200
+#define SDIO_DEVICE_ID_STE_CW1200	0x2280
+#endif
+
+static const struct sdio_device_id cw1200_sdio_ids[] = {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_STE, SDIO_DEVICE_ID_STE_CW1200) },
+	{ /* end: all zeroes */			},
+};
+
+/* sbus_ops implemetation */
+
+static int cw1200_sdio_memcpy_fromio(struct sbus_priv *self,
+				     unsigned int addr,
+				     void *dst, int count)
+{
+	return sdio_memcpy_fromio(self->func, dst, addr, count);
+}
+
+static int cw1200_sdio_memcpy_toio(struct sbus_priv *self,
+				   unsigned int addr,
+				   const void *src, int count)
+{
+	return sdio_memcpy_toio(self->func, addr, (void *)src, count);
+}
+
+static void cw1200_sdio_lock(struct sbus_priv *self)
+{
+	sdio_claim_host(self->func);
+}
+
+static void cw1200_sdio_unlock(struct sbus_priv *self)
+{
+	sdio_release_host(self->func);
+}
+
+static void cw1200_sdio_irq_handler(struct sdio_func *func)
+{
+	struct sbus_priv *self = sdio_get_drvdata(func);
+
+	/* note:  sdio_host already claimed here. */
+	if (self->core)
+		cw1200_irq_handler(self->core);
+}
+
+static irqreturn_t cw1200_gpio_hardirq(int irq, void *dev_id)
+{
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t cw1200_gpio_irq(int irq, void *dev_id)
+{
+	struct sbus_priv *self = dev_id;
+
+	if (self->core) {
+		sdio_claim_host(self->func);
+		cw1200_irq_handler(self->core);
+		sdio_release_host(self->func);
+		return IRQ_HANDLED;
+	} else {
+		return IRQ_NONE;
+	}
+}
+
+static int cw1200_request_irq(struct sbus_priv *self)
+{
+	int ret;
+	const struct resource *irq = self->pdata->irq;
+	u8 cccr;
+
+	cccr = sdio_f0_readb(self->func, SDIO_CCCR_IENx, &ret);
+	if (WARN_ON(ret))
+		goto err;
+
+	/* Master interrupt enable ... */
+	cccr |= BIT(0);
+
+	/* ... for our function */
+	cccr |= BIT(self->func->num);
+
+	sdio_f0_writeb(self->func, cccr, SDIO_CCCR_IENx, &ret);
+	if (WARN_ON(ret))
+		goto err;
+
+	ret = enable_irq_wake(irq->start);
+	if (WARN_ON(ret))
+		goto err;
+
+	/* Request the IRQ */
+	ret =  request_threaded_irq(irq->start, cw1200_gpio_hardirq,
+				    cw1200_gpio_irq,
+				    IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				    irq->name, self);
+	if (WARN_ON(ret))
+		goto err;
+
+	return 0;
+
+err:
+	return ret;
+}
+
+static int cw1200_sdio_irq_subscribe(struct sbus_priv *self)
+{
+	int ret = 0;
+
+	pr_debug("SW IRQ subscribe\n");
+	sdio_claim_host(self->func);
+	if (self->pdata->irq)
+		ret = cw1200_request_irq(self);
+	else
+		ret = sdio_claim_irq(self->func, cw1200_sdio_irq_handler);
+
+	sdio_release_host(self->func);
+	return ret;
+}
+
+static int cw1200_sdio_irq_unsubscribe(struct sbus_priv *self)
+{
+	int ret = 0;
+
+	pr_debug("SW IRQ unsubscribe\n");
+
+	if (self->pdata->irq) {
+		disable_irq_wake(self->pdata->irq->start);
+		free_irq(self->pdata->irq->start, self);
+	} else {
+		sdio_claim_host(self->func);
+		ret = sdio_release_irq(self->func);
+		sdio_release_host(self->func);
+	}
+	return ret;
+}
+
+static int cw1200_sdio_off(const struct cw1200_platform_data_sdio *pdata)
+{
+	const struct resource *reset = pdata->reset;
+
+	if (reset) {
+		gpio_set_value(reset->start, 0);
+		msleep(30); /* Min is 2 * CLK32K cycles */
+		gpio_free(reset->start);
+	}
+
+	if (pdata->power_ctrl)
+		pdata->power_ctrl(pdata, false);
+	if (pdata->clk_ctrl)
+		pdata->clk_ctrl(pdata, false);
+
+	return 0;
+}
+
+static int cw1200_sdio_on(const struct cw1200_platform_data_sdio *pdata)
+{
+	const struct resource *reset = pdata->reset;
+	const struct resource *powerup = pdata->reset;
+
+	/* Ensure I/Os are pulled low */
+	if (reset) {
+		gpio_request(reset->start, reset->name);
+		gpio_direction_output(reset->start, 0);
+	}
+	if (powerup) {
+		gpio_request(powerup->start, powerup->name);
+		gpio_direction_output(powerup->start, 0);
+	}
+	if (reset || powerup)
+		msleep(50); /* Settle time */
+
+	/* Enable 3v3 and 1v8 to hardware */
+	if (pdata->power_ctrl) {
+		if (pdata->power_ctrl(pdata, true)) {
+			pr_err("power_ctrl() failed!\n");
+			return -1;
+		}
+	}
+
+	/* Enable CLK32K */
+	if (pdata->clk_ctrl) {
+		if (pdata->clk_ctrl(pdata, true)) {
+			pr_err("clk_ctrl() failed!\n");
+			return -1;
+		}
+		msleep(10); /* Delay until clock is stable for 2 cycles */
+	}
+
+	/* Enable POWERUP signal */
+	if (powerup) {
+		gpio_set_value(powerup->start, 1);
+		msleep(250); /* or more..? */
+	}
+	/* Enable RSTn signal */
+	if (reset) {
+		gpio_set_value(reset->start, 1);
+		msleep(50); /* Or more..? */
+	}
+	return 0;
+}
+
+static size_t cw1200_sdio_align_size(struct sbus_priv *self, size_t size)
+{
+	if (self->pdata->no_nptb)
+		size = round_up(size, SDIO_BLOCK_SIZE);
+	else
+		size = sdio_align_size(self->func, size);
+
+	return size;
+}
+
+static int cw1200_sdio_pm(struct sbus_priv *self, bool suspend)
+{
+	int ret = 0;
+
+	if (self->pdata->irq)
+		ret = irq_set_irq_wake(self->pdata->irq->start, suspend);
+	return ret;
+}
+
+static struct sbus_ops cw1200_sdio_sbus_ops = {
+	.sbus_memcpy_fromio	= cw1200_sdio_memcpy_fromio,
+	.sbus_memcpy_toio	= cw1200_sdio_memcpy_toio,
+	.lock			= cw1200_sdio_lock,
+	.unlock			= cw1200_sdio_unlock,
+	.align_size		= cw1200_sdio_align_size,
+	.power_mgmt		= cw1200_sdio_pm,
+};
+
+/* Probe Function to be called by SDIO stack when device is discovered */
+static int cw1200_sdio_probe(struct sdio_func *func,
+				       const struct sdio_device_id *id)
+{
+	struct sbus_priv *self;
+	int status;
+
+	pr_info("cw1200_wlan_sdio: Probe called\n");
+
+       /* We are only able to handle the wlan function */
+	if (func->num != 0x01)
+		return -ENODEV;
+
+	self = kzalloc(sizeof(*self), GFP_KERNEL);
+	if (!self) {
+		pr_err("Can't allocate SDIO sbus_priv.\n");
+		return -ENOMEM;
+	}
+
+	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
+
+	self->pdata = cw1200_get_platform_data();
+	self->func = func;
+	sdio_set_drvdata(func, self);
+	sdio_claim_host(func);
+	sdio_enable_func(func);
+	sdio_release_host(func);
+
+	status = cw1200_sdio_irq_subscribe(self);
+
+	status = cw1200_core_probe(&cw1200_sdio_sbus_ops,
+				   self, &func->dev, &self->core,
+				   self->pdata->ref_clk,
+				   self->pdata->macaddr,
+				   self->pdata->sdd_file,
+				   self->pdata->have_5ghz);
+	if (status) {
+		cw1200_sdio_irq_unsubscribe(self);
+		sdio_claim_host(func);
+		sdio_disable_func(func);
+		sdio_release_host(func);
+		sdio_set_drvdata(func, NULL);
+		kfree(self);
+	}
+
+	return status;
+}
+
+/* Disconnect Function to be called by SDIO stack when
+ * device is disconnected */
+static void cw1200_sdio_disconnect(struct sdio_func *func)
+{
+	struct sbus_priv *self = sdio_get_drvdata(func);
+
+	if (self) {
+		cw1200_sdio_irq_unsubscribe(self);
+		if (self->core) {
+			cw1200_core_release(self->core);
+			self->core = NULL;
+		}
+		sdio_claim_host(func);
+		sdio_disable_func(func);
+		sdio_release_host(func);
+		sdio_set_drvdata(func, NULL);
+		kfree(self);
+	}
+}
+
+static int cw1200_sdio_suspend(struct device *dev)
+{
+	int ret;
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct sbus_priv *self = sdio_get_drvdata(func);
+
+	if (!cw1200_can_suspend(self->core))
+		return -EAGAIN;
+
+	/* Notify SDIO that CW1200 will remain powered during suspend */
+	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	if (ret)
+		pr_err("Error setting SDIO pm flags: %i\n", ret);
+
+	return ret;
+}
+
+static int cw1200_sdio_resume(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops cw1200_pm_ops = {
+	.suspend = cw1200_sdio_suspend,
+	.resume = cw1200_sdio_resume,
+};
+
+static struct sdio_driver sdio_driver = {
+	.name		= "cw1200_wlan_sdio",
+	.id_table	= cw1200_sdio_ids,
+	.probe		= cw1200_sdio_probe,
+	.remove		= cw1200_sdio_disconnect,
+	.drv = {
+		.pm = &cw1200_pm_ops,
+	}
+};
+
+/* Init Module function -> Called by insmod */
+static int __init cw1200_sdio_init(void)
+{
+	const struct cw1200_platform_data_sdio *pdata;
+	int ret;
+
+	pdata = cw1200_get_platform_data();
+
+	if (cw1200_sdio_on(pdata)) {
+		ret = -1;
+		goto err;
+	}
+
+	ret = sdio_register_driver(&sdio_driver);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	cw1200_sdio_off(pdata);
+	return ret;
+}
+
+/* Called at Driver Unloading */
+static void __exit cw1200_sdio_exit(void)
+{
+	const struct cw1200_platform_data_sdio *pdata;
+	pdata = cw1200_get_platform_data();
+	sdio_unregister_driver(&sdio_driver);
+	cw1200_sdio_off(pdata);
+}
+
+
+module_init(cw1200_sdio_init);
+module_exit(cw1200_sdio_exit);
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
new file mode 100644
index 0000000..04af685
--- /dev/null
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -0,0 +1,480 @@
+/*
+ * Mac80211 SPI driver for ST-Ericsson CW1200 device
+ *
+ * Copyright (c) 2011, Sagrad Inc.
+ * Author:  Solomon Peachy <speachy@sagrad.com>
+ *
+ * Based on cw1200_sdio.c
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <net/mac80211.h>
+
+#include <linux/spi/spi.h>
+#include <linux/device.h>
+
+#include "cw1200.h"
+#include "sbus.h"
+#include <linux/cw1200_platform.h>
+#include "hwio.h"
+
+MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
+MODULE_DESCRIPTION("mac80211 ST-Ericsson CW1200 SPI driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:cw1200_wlan_spi");
+
+/* #define SPI_DEBUG */
+
+struct sbus_priv {
+	struct spi_device	*func;
+	struct cw1200_common	*core;
+	const struct cw1200_platform_data_spi *pdata;
+	spinlock_t		lock; /* Serialize all bus operations */
+	int claimed;
+};
+
+#define SDIO_TO_SPI_ADDR(addr) ((addr & 0x1f)>>2)
+#define SET_WRITE 0x7FFF /* usage: and operation */
+#define SET_READ 0x8000  /* usage: or operation */
+
+/*
+   Notes on byte ordering:
+   LE:  B0 B1 B2 B3
+   BE:  B3 B2 B1 B0
+
+   Hardware expects 32-bit data to be written as 16-bit BE words:
+
+   B1 B0 B3 B2
+
+*/
+
+static int cw1200_spi_memcpy_fromio(struct sbus_priv *self,
+				     unsigned int addr,
+				     void *dst, int count)
+{
+	int ret, i;
+	uint16_t regaddr;
+	struct spi_message      m;
+
+	struct spi_transfer     t_addr = {
+		.tx_buf         = &regaddr,
+		.len            = sizeof(regaddr),
+	};
+	struct spi_transfer     t_msg = {
+		.rx_buf         = dst,
+		.len            = count,
+	};
+
+	regaddr = (SDIO_TO_SPI_ADDR(addr))<<12;
+	regaddr |= SET_READ;
+	regaddr |= (count>>1);
+	regaddr = cpu_to_le16(regaddr);
+
+#ifdef SPI_DEBUG
+	pr_info("READ : %04d from 0x%02x (%04x)\n", count, addr,
+		le16_to_cpu(regaddr));
+#endif
+
+#if defined(__LITTLE_ENDIAN)
+	/* We have to byteswap if the SPI bus is limited to 8b operation */
+	if (self->func->bits_per_word == 8)
+#endif
+		regaddr = swab16(regaddr);
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t_addr, &m);
+	spi_message_add_tail(&t_msg, &m);
+	ret = spi_sync(self->func, &m);
+
+#ifdef SPI_DEBUG
+	pr_info("READ : ");
+	for (i = 0; i < t_addr.len; i++)
+		printk("%02x ", ((u8 *)t_addr.tx_buf)[i]);
+	printk(" : ");
+	for (i = 0; i < t_msg.len; i++)
+		printk("%02x ", ((u8 *)t_msg.rx_buf)[i]);
+	printk("\n");
+#endif
+
+#if defined(__LITTLE_ENDIAN)
+	/* We have to byteswap if the SPI bus is limited to 8b operation */
+	if (self->func->bits_per_word == 8)
+#endif
+	{
+		uint16_t *buf = (uint16_t *)dst;
+		for (i = 0; i < ((count + 1) >> 1); i++)
+			buf[i] = swab16(buf[i]);
+	}
+
+	return ret;
+}
+
+static int cw1200_spi_memcpy_toio(struct sbus_priv *self,
+				   unsigned int addr,
+				   const void *src, int count)
+{
+	int rval, i;
+	uint16_t regaddr;
+	struct spi_transfer     t_addr = {
+		.tx_buf         = &regaddr,
+		.len            = sizeof(regaddr),
+	};
+	struct spi_transfer     t_msg = {
+		.tx_buf         = src,
+		.len            = count,
+	};
+	struct spi_message      m;
+
+	regaddr = (SDIO_TO_SPI_ADDR(addr))<<12;
+	regaddr &= SET_WRITE;
+	regaddr |= (count>>1);
+	regaddr = cpu_to_le16(regaddr);
+
+#ifdef SPI_DEBUG
+	pr_info("WRITE: %04d  to  0x%02x (%04x)\n", count, addr,
+		le16_to_cpu(regaddr));
+#endif
+
+#if defined(__LITTLE_ENDIAN)
+	/* We have to byteswap if the SPI bus is limited to 8b operation */
+	if (self->func->bits_per_word == 8)
+#endif
+	{
+		uint16_t *buf = (uint16_t *)src;
+		regaddr = swab16(regaddr);
+		for (i = 0; i < ((count + 1) >> 1); i++)
+			buf[i] = swab16(buf[i]);
+	}
+
+#ifdef SPI_DEBUG
+	pr_info("WRITE: ");
+	for (i = 0; i < t_addr.len; i++)
+		printk("%02x ", ((u8 *)t_addr.tx_buf)[i]);
+	printk(" : ");
+	for (i = 0; i < t_msg.len; i++)
+		printk("%02x ", ((u8 *)t_msg.tx_buf)[i]);
+	printk("\n");
+#endif
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t_addr, &m);
+	spi_message_add_tail(&t_msg, &m);
+	rval = spi_sync(self->func, &m);
+
+#ifdef SPI_DEBUG
+	pr_info("WROTE: %d\n", m.actual_length);
+#endif
+
+#if defined(__LITTLE_ENDIAN)
+	/* We have to byteswap if the SPI bus is limited to 8b operation */
+	if (self->func->bits_per_word == 8)
+#endif
+	{
+		uint16_t *buf = (uint16_t *)src;
+		for (i = 0; i < ((count + 1) >> 1); i++)
+			buf[i] = swab16(buf[i]);
+	}
+	return rval;
+}
+
+static void cw1200_spi_lock(struct sbus_priv *self)
+{
+	unsigned long flags;
+
+	might_sleep();
+
+	spin_lock_irqsave(&self->lock, flags);
+	while (1) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!self->claimed)
+			break;
+		spin_unlock_irqrestore(&self->lock, flags);
+		schedule();
+		spin_lock_irqsave(&self->lock, flags);
+	}
+	set_current_state(TASK_RUNNING);
+	self->claimed = 1;
+	spin_unlock_irqrestore(&self->lock, flags);
+
+	return;
+}
+
+static void cw1200_spi_unlock(struct sbus_priv *self)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&self->lock, flags);
+	self->claimed = 0;
+	spin_unlock_irqrestore(&self->lock, flags);
+	return;
+}
+
+static irqreturn_t cw1200_spi_irq_handler(int irq, void *dev_id)
+{
+	struct sbus_priv *self = dev_id;
+
+	if (self->core) {
+		cw1200_irq_handler(self->core);
+		return IRQ_HANDLED;
+	} else {
+		return IRQ_NONE;
+	}
+}
+
+static int cw1200_spi_irq_subscribe(struct sbus_priv *self)
+{
+	int ret;
+
+	pr_debug("SW IRQ subscribe\n");
+
+	ret = request_any_context_irq(self->func->irq, cw1200_spi_irq_handler,
+				      IRQF_TRIGGER_HIGH,
+				      "cw1200_wlan_irq", self);
+	if (WARN_ON(ret < 0))
+		goto exit;
+
+	ret = enable_irq_wake(self->func->irq);
+	if (WARN_ON(ret))
+		goto free_irq;
+
+	return 0;
+
+free_irq:
+	free_irq(self->func->irq, self);
+exit:
+	return ret;
+}
+
+static int cw1200_spi_irq_unsubscribe(struct sbus_priv *self)
+{
+	int ret = 0;
+
+	pr_debug("SW IRQ unsubscribe\n");
+	disable_irq_wake(self->func->irq);
+	free_irq(self->func->irq, self);
+
+	return ret;
+}
+
+static int cw1200_spi_off(const struct cw1200_platform_data_spi *pdata)
+{
+	const struct resource *reset = pdata->reset;
+
+	if (reset) {
+		gpio_set_value(reset->start, 0);
+		msleep(30); /* Min is 2 * CLK32K cycles */
+		gpio_free(reset->start);
+	}
+
+	if (pdata->power_ctrl)
+		pdata->power_ctrl(pdata, false);
+	if (pdata->clk_ctrl)
+		pdata->clk_ctrl(pdata, false);
+
+	return 0;
+}
+
+static int cw1200_spi_on(const struct cw1200_platform_data_spi *pdata)
+{
+	const struct resource *reset = pdata->reset;
+	const struct resource *powerup = pdata->reset;
+
+	/* Ensure I/Os are pulled low */
+	if (reset) {
+		gpio_request(reset->start, reset->name);
+		gpio_direction_output(reset->start, 0);
+	}
+	if (powerup) {
+		gpio_request(powerup->start, powerup->name);
+		gpio_direction_output(powerup->start, 0);
+	}
+	if (reset || powerup)
+		msleep(10); /* Settle time? */
+
+	/* Enable 3v3 and 1v8 to hardware */
+	if (pdata->power_ctrl) {
+		if (pdata->power_ctrl(pdata, true)) {
+			pr_err("power_ctrl() failed!\n");
+			return -1;
+		}
+	}
+
+	/* Enable CLK32K */
+	if (pdata->clk_ctrl) {
+		if (pdata->clk_ctrl(pdata, true)) {
+			pr_err("clk_ctrl() failed!\n");
+			return -1;
+		}
+		msleep(10); /* Delay until clock is stable for 2 cycles */
+	}
+
+	/* Enable POWERUP signal */
+	if (powerup) {
+		gpio_set_value(powerup->start, 1);
+		msleep(250); /* or more..? */
+	}
+	/* Enable RSTn signal */
+	if (reset) {
+		gpio_set_value(reset->start, 1);
+		msleep(50); /* Or more..? */
+	}
+	return 0;
+}
+
+static size_t cw1200_spi_align_size(struct sbus_priv *self, size_t size)
+{
+	return size & 1 ? size + 1 : size;
+}
+
+static int cw1200_spi_pm(struct sbus_priv *self, bool suspend)
+{
+	return irq_set_irq_wake(self->func->irq, suspend);
+}
+
+static struct sbus_ops cw1200_spi_sbus_ops = {
+	.sbus_memcpy_fromio	= cw1200_spi_memcpy_fromio,
+	.sbus_memcpy_toio	= cw1200_spi_memcpy_toio,
+	.lock			= cw1200_spi_lock,
+	.unlock			= cw1200_spi_unlock,
+	.align_size		= cw1200_spi_align_size,
+	.power_mgmt		= cw1200_spi_pm,
+};
+
+/* Probe Function to be called by SPI stack when device is discovered */
+static int cw1200_spi_probe(struct spi_device *func)
+{
+	const struct cw1200_platform_data_spi *plat_data =
+		func->dev.platform_data;
+	struct sbus_priv *self;
+	int status;
+
+	/* Sanity check speed */
+	if (func->max_speed_hz > 52000000)
+		func->max_speed_hz = 52000000;
+	if (func->max_speed_hz < 1000000)
+		func->max_speed_hz = 1000000;
+
+	/* Fix up transfer size */
+	if (plat_data->spi_bits_per_word)
+		func->bits_per_word = plat_data->spi_bits_per_word;
+	if (!func->bits_per_word)
+		func->bits_per_word = 16;
+
+	/* And finally.. */
+	func->mode = SPI_MODE_0;
+
+	pr_info("cw1200_wlan_spi: Probe called (CS %d M %d BPW %d CLK %d)\n",
+		func->chip_select, func->mode, func->bits_per_word,
+		func->max_speed_hz);
+
+	if (cw1200_spi_on(plat_data)) {
+		pr_err("spi_on() failed!\n");
+		return -1;
+	}
+
+	if (spi_setup(func)) {
+		pr_err("spi_setup() failed!\n");
+		return -1;
+	}
+
+	self = kzalloc(sizeof(*self), GFP_KERNEL);
+	if (!self) {
+		pr_err("Can't allocate SPI sbus_priv.");
+		return -ENOMEM;
+	}
+
+	self->pdata = plat_data;
+	self->func = func;
+	spin_lock_init(&self->lock);
+
+	spi_set_drvdata(func, self);
+
+	status = cw1200_spi_irq_subscribe(self);
+
+	status = cw1200_core_probe(&cw1200_spi_sbus_ops,
+				   self, &func->dev, &self->core,
+				   self->pdata->ref_clk,
+				   self->pdata->macaddr,
+				   self->pdata->sdd_file,
+				   self->pdata->have_5ghz);
+
+	if (status) {
+		cw1200_spi_irq_unsubscribe(self);
+		cw1200_spi_off(plat_data);
+		kfree(self);
+	}
+
+	return status;
+}
+
+/* Disconnect Function to be called by SPI stack when device is disconnected */
+static int cw1200_spi_disconnect(struct spi_device *func)
+{
+	struct sbus_priv *self = spi_get_drvdata(func);
+
+	if (self) {
+		cw1200_spi_irq_unsubscribe(self);
+		if (self->core) {
+			cw1200_core_release(self->core);
+			self->core = NULL;
+		}
+		kfree(self);
+	}
+	cw1200_spi_off(func->dev.platform_data);
+
+	return 0;
+}
+
+static int cw1200_spi_suspend(struct device *dev, pm_message_t state)
+{
+	struct sbus_priv *self = spi_get_drvdata(to_spi_device(dev));
+
+	if (!cw1200_can_suspend(self->core))
+		return -EAGAIN;
+
+	/* XXX notify host that we have to keep CW1200 powered on? */
+	return 0;
+}
+
+static int cw1200_spi_resume(struct device *dev)
+{
+	return 0;
+}
+
+static struct spi_driver spi_driver = {
+	.probe		= cw1200_spi_probe,
+	.remove		= cw1200_spi_disconnect,
+	.driver = {
+		.name		= "cw1200_wlan_spi",
+		.bus            = &spi_bus_type,
+		.owner          = THIS_MODULE,
+		.suspend        = cw1200_spi_suspend,
+		.resume         = cw1200_spi_resume,
+	},
+};
+
+/* Init Module function -> Called by insmod */
+static int __init cw1200_spi_init(void)
+{
+	return spi_register_driver(&spi_driver);
+}
+
+/* Called at Driver Unloading */
+static void __exit cw1200_spi_exit(void)
+{
+	spi_unregister_driver(&spi_driver);
+}
+
+module_init(cw1200_spi_init);
+module_exit(cw1200_spi_exit);
diff --git a/include/linux/cw1200_platform.h b/include/linux/cw1200_platform.h
new file mode 100644
index 0000000..c168fa5
--- /dev/null
+++ b/include/linux/cw1200_platform.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ *
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef CW1200_PLAT_H_INCLUDED
+#define CW1200_PLAT_H_INCLUDED
+
+struct cw1200_platform_data_spi {
+	u8 spi_bits_per_word;           /* REQUIRED */
+	u16 ref_clk;                    /* REQUIRED (in KHz) */
+
+	/* All others are optional */
+	bool have_5ghz;
+	const struct resource *reset;   /* GPIO to RSTn signal */
+	const struct resource *powerup; /* GPIO to POWERUP signal */
+	int (*power_ctrl)(const struct cw1200_platform_data_spi *pdata,
+			  bool enable); /* Control 3v3 / 1v8 supply */
+	int (*clk_ctrl)(const struct cw1200_platform_data_spi *pdata,
+			bool enable); /* Control CLK32K */
+	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
+	const char *sdd_file;  /* if NULL, will use default for detected hw type */
+};
+
+struct cw1200_platform_data_sdio {
+	u16 ref_clk;                    /* REQUIRED (in KHz) */
+
+	/* All others are optional */
+	const struct resource *irq;     /* if using GPIO for IRQ */
+	bool have_5ghz;
+	bool no_nptb;                   /* SDIO hardware does not support non-power-of-2-blocksizes */
+	const struct resource *reset;   /* GPIO to RSTn signal */
+	const struct resource *powerup; /* GPIO to POWERUP signal */
+	int (*power_ctrl)(const struct cw1200_platform_data_sdio *pdata,
+			  bool enable); /* Control 3v3 / 1v8 supply */
+	int (*clk_ctrl)(const struct cw1200_platform_data_sdio *pdata,
+			bool enable); /* Control CLK32K */
+	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
+	const char *sdd_file;  /* if NULL, will use default for detected hw type */
+};
+
+const void *cw1200_get_platform_data(void);
+
+#endif /* CW1200_PLAT_H_INCLUDED */
-- 
1.8.1.4

