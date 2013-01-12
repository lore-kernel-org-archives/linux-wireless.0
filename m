Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:61577 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3ALOHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:07:01 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 13/15] cw1200: v3: SDIO and SPI glue code and platform definitions
Date: Sat, 12 Jan 2013 09:06:13 -0500
Message-Id: <1357999575-12838-14-git-send-email-pizza@shaftnet.org> (sfid-20130112_152322_436473_96EA1C41)
In-Reply-To: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
References: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/cw1200/cw1200_plat.h |  50 +++
 drivers/staging/cw1200/cw1200_sdio.c | 568 +++++++++++++++++++++++++++++++++++
 drivers/staging/cw1200/cw1200_spi.c  | 563 ++++++++++++++++++++++++++++++++++
 3 files changed, 1181 insertions(+)
 create mode 100644 drivers/staging/cw1200/cw1200_plat.h
 create mode 100644 drivers/staging/cw1200/cw1200_sdio.c
 create mode 100644 drivers/staging/cw1200/cw1200_spi.c

diff --git a/drivers/staging/cw1200/cw1200_plat.h b/drivers/staging/cw1200/cw1200_plat.h
new file mode 100644
index 0000000..1b4aabf
--- /dev/null
+++ b/drivers/staging/cw1200/cw1200_plat.h
@@ -0,0 +1,50 @@
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
+#include <linux/ioport.h>
+
+#include "hwio.h"  /* For DPLL init values */
+
+struct cw1200_platform_data_spi {
+	u8 spi_bits_per_word;           /* REQUIRED */
+	u16 ref_clk;                    /* REQUIRED (in KHz) */
+
+	/* All others are optional */
+
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
+	const char *mmc_id;             /* REQUIRED */
+	u16 ref_clk;                    /* REQUIRED (in KHz) */
+#ifdef CONFIG_CW1200_USE_GPIO_IRQ
+	const struct resource *irq;     /* REQUIRED */
+#endif
+
+	/* All others are optional */
+
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
+#endif /* CW1200_PLAT_H_INCLUDED */
diff --git a/drivers/staging/cw1200/cw1200_sdio.c b/drivers/staging/cw1200/cw1200_sdio.c
new file mode 100644
index 0000000..8850ee6
--- /dev/null
+++ b/drivers/staging/cw1200/cw1200_sdio.c
@@ -0,0 +1,568 @@
+/*
+ * Mac80211 SDIO driver for ST-Ericsson CW1200 device
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
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
+#include "cw1200_plat.h"
+#include "hwio.h"
+
+MODULE_AUTHOR("Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>");
+MODULE_DESCRIPTION("mac80211 ST-Ericsson CW1200 SDIO driver");
+MODULE_LICENSE("GPL");
+
+#define SDIO_BLOCK_SIZE (512)
+
+#define USE_INTERNAL_RESOURCE_LIST
+/* XXX The intent is that this info is part of the board platform data in arch/mach-xxxx/mach-yyyy.c -- listed here for convenience.. */
+
+/* Declaration only. Should be implemented in arch/xxx/mach-yyy */
+const struct cw1200_platform_data_sdio *cw1200_get_platform_data(void);
+
+#ifdef USE_INTERNAL_RESOURCE_LIST
+#if 0
+static struct resource cw1200_href_resources[] = {
+	{
+		.start = 215,  /* fix me as appropriate */
+		.end = 215,    /* ditto */
+		.flags = IORESOURCE_IO,
+		.name = "cw1200_wlan_reset",
+	},
+	{
+		.start = 216,  /* fix me as appropriate */
+		.end = 216,    /* ditto */
+		.flags = IORESOURCE_IO,
+		.name = "cw1200_wlan_powerup",
+	},
+
+#ifdef CONFIG_CW1200_USE_GPIO_IRQ
+	{
+		.start = NOMADIK_GPIO_TO_IRQ(216), /* fix me as appropriate */
+		.end = NOMADIK_GPIO_TO_IRQ(216),   /* ditto */
+		.flags = IORESOURCE_IRQ,
+		.name = "cw1200_wlan_irq",
+	},
+#endif /* CONFIG_CW1200_USE_GPIO_IRQ */
+};
+#endif
+
+static int cw1200_power_ctrl(const struct cw1200_platform_data_sdio *pdata,
+			     bool enable)
+{
+	/* Control 3v3 and 1v8 to hardware as appropriate */
+	/* Note this is not needed if it's controlled elsewhere or always on */
+
+	/* May require delay for power to stabilize */
+	return 0;
+}
+
+static int cw1200_clk_ctrl(const struct cw1200_platform_data_sdio *pdata,
+			   bool enable)
+{
+	/* Turn CLK_32K off and on as appropriate. */
+	/* Note this is not needed if it's always on */
+
+	/* May require delay for clock to stabilize */
+	return 0;
+}
+
+struct cw1200_platform_data_sdio cw1200_platform_data = {
+	.mmc_id = "mmc1",
+	.ref_clk = 38400,
+#if 0
+	.reset = &cw1200_href_resources[0],
+	.powerup = &cw1200_href_resources[1],
+#ifdef CONFIG_CW1200_USE_GPIO_IRQ
+	.irq = &cw1200_href_resources[2],
+#endif
+#endif
+	.power_ctrl = cw1200_power_ctrl,
+	.clk_ctrl = cw1200_clk_ctrl,
+/*	.macaddr = ??? */
+	.sdd_file = "sdd_sagrad_1091_1098.bin",
+};
+
+const struct cw1200_platform_data_sdio *cw1200_get_platform_data(void)
+{
+	return &cw1200_platform_data;
+}
+EXPORT_SYMBOL_GPL(cw1200_get_platform_data);
+#endif
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
+#ifndef CONFIG_CW1200_POLL_IRQ
+
+#ifndef CONFIG_CW1200_USE_GPIO_IRQ
+static void cw1200_sdio_irq_handler(struct sdio_func *func)
+{
+	struct sbus_priv *self = sdio_get_drvdata(func);
+
+	BUG_ON(!self);
+
+	/* note:  sdio_host already claimed here. */
+	cw1200_irq_handler(self->core);
+}
+static void cw1200_sdio_irq_enable(struct sbus_priv *self, int enable)
+{
+	__cw1200_irq_enable(self->core, enable);
+}
+
+#else /* CONFIG_CW1200_USE_GPIO_IRQ */
+static irqreturn_t cw1200_gpio_irq_handler(int irq, void *dev_id)
+{
+	struct sbus_priv *self = dev_id;
+
+	BUG_ON(!self);
+	cw1200_irq_handler(self->core);
+	return IRQ_HANDLED;
+}
+
+static int cw1200_request_irq(struct sbus_priv *self,
+			      irq_handler_t handler)
+{
+	int ret;
+	int func_num;
+	const struct resource *irq = self->pdata->irq;
+	u8 cccr;
+
+	ret = request_any_context_irq(irq->start, handler,
+			IRQF_TRIGGER_FALLING, irq->name, self);
+	if (WARN_ON(ret < 0))
+		goto exit;
+
+	/* Hack to access Fuction-0 */
+	func_num = self->func->num;
+	self->func->num = 0;
+
+	cccr = sdio_readb(self->func, SDIO_CCCR_IENx, &ret);
+	if (WARN_ON(ret))
+		goto set_func;
+
+	/* Master interrupt enable ... */
+	cccr |= BIT(0);
+
+	/* ... for our function */
+	cccr |= BIT(func_num);
+
+	sdio_writeb(self->func, cccr, SDIO_CCCR_IENx, &ret);
+	if (WARN_ON(ret))
+		goto set_func;
+
+#ifdef CONFIG_CW1200_PM
+	ret = enable_irq_wake(self->pdata->irq->start);
+	if (WARN_ON(ret))
+		goto set_func;
+#endif
+
+	/* Restore the WLAN function number */
+	self->func->num = func_num;
+	return 0;
+
+set_func:
+	self->func->num = func_num;
+	free_irq(irq->start, self);
+exit:
+	return ret;
+}
+#endif /* CONFIG_CW1200_USE_GPIO_IRQ */
+
+static int cw1200_sdio_irq_subscribe(struct sbus_priv *self)
+{
+	int ret = 0;
+
+	pr_debug("SW IRQ subscribe\n");
+	sdio_claim_host(self->func);
+#ifndef CONFIG_CW1200_USE_GPIO_IRQ
+	ret = sdio_claim_irq(self->func, cw1200_sdio_irq_handler);
+#else
+	ret = cw1200_request_irq(self, cw1200_gpio_irq_handler);
+#endif
+	sdio_release_host(self->func);
+	return ret;
+}
+
+static int cw1200_sdio_irq_unsubscribe(struct sbus_priv *self)
+{
+	int ret = 0;
+#ifdef CONFIG_CW1200_USE_GPIO_IRQ
+	const struct resource *irq = self->pdata->irq;
+#endif
+
+	pr_debug("SW IRQ unsubscribe\n");
+#ifndef CONFIG_CW1200_USE_GPIO_IRQ
+	sdio_claim_host(self->func);
+	ret = sdio_release_irq(self->func);
+	sdio_release_host(self->func);
+#else
+#ifdef CONFIG_CW1200_PM
+	disable_irq_wake(self->pdata->irq->start);
+#endif
+	free_irq(irq->start, self);
+#endif
+
+	return ret;
+}
+#endif
+
+static int cw1200_detect_card(const struct cw1200_platform_data_sdio *pdata)
+{
+	/* HACK!!!
+	 * Rely on mmc->class_dev.class set in mmc_alloc_host
+	 * Tricky part: a new mmc hook is being (temporary) created
+	 * to discover mmc_host class.
+	 * Do you know more elegant way how to enumerate mmc_hosts?
+	 */
+
+	struct mmc_host *mmc = NULL;
+	struct class_dev_iter iter;
+	struct device *dev;
+
+	mmc = mmc_alloc_host(0, NULL);
+	if (!mmc)
+		return -ENOMEM;
+
+	BUG_ON(!mmc->class_dev.class);
+	class_dev_iter_init(&iter, mmc->class_dev.class, NULL, NULL);
+	for (;;) {
+		dev = class_dev_iter_next(&iter);
+		if (!dev) {
+			pr_err("cw1200: %s is not found.\n",
+				pdata->mmc_id);
+			break;
+		} else {
+			struct mmc_host *host = container_of(dev,
+				struct mmc_host, class_dev);
+
+			if (dev_name(&host->class_dev) &&
+				strcmp(dev_name(&host->class_dev),
+					pdata->mmc_id))
+				continue;
+
+			mmc_detect_change(host, 10);
+			break;
+		}
+	}
+	mmc_free_host(mmc);
+	return 0;
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
+		cw1200_detect_card(pdata);
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
+static int cw1200_sdio_reset(struct sbus_priv *self)
+{
+	cw1200_sdio_off(self->pdata);
+	msleep(1000);
+	cw1200_sdio_on(self->pdata);
+	return 0;
+}
+
+static size_t cw1200_sdio_align_size(struct sbus_priv *self, size_t size)
+{
+#if defined(CONFIG_CW1200_NON_POWER_OF_TWO_BLOCKSIZES)
+	size = sdio_align_size(self->func, size);
+#else /* CONFIG_CW1200_NON_POWER_OF_TWO_BLOCKSIZES */
+	size = round_up(size, SDIO_BLOCK_SIZE);
+#endif /* CONFIG_CW1200_NON_POWER_OF_TWO_BLOCKSIZES */
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 2, 0))
+	/* A quirk to handle this was committed in 3.2-rc */
+	if (size == SDIO_BLOCK_SIZE)
+		size += SDIO_BLOCK_SIZE;  /* HW bug; force use of block mode */
+#endif
+
+	return size;
+}
+
+#ifdef CONFIG_CW1200_PM
+static int cw1200_sdio_pm(struct sbus_priv *self, bool suspend)
+{
+	int ret = 0;
+
+#ifdef CONFIG_CW1200_USE_GPIO_IRQ
+	ret = irq_set_irq_wake(self->pdata->irq->start, suspend);
+#endif
+	return ret;
+}
+#endif
+
+static struct sbus_ops cw1200_sdio_sbus_ops = {
+	.sbus_memcpy_fromio	= cw1200_sdio_memcpy_fromio,
+	.sbus_memcpy_toio	= cw1200_sdio_memcpy_toio,
+	.lock			= cw1200_sdio_lock,
+	.unlock			= cw1200_sdio_unlock,
+#ifndef CONFIG_CW1200_POLL_IRQ
+	.irq_subscribe		= cw1200_sdio_irq_subscribe,
+	.irq_unsubscribe	= cw1200_sdio_irq_unsubscribe,
+#ifndef CONFIG_CW1200_USE_GPIO_IRQ
+	.irq_enable             = cw1200_sdio_irq_enable,
+#endif
+#endif
+	.reset			= cw1200_sdio_reset,
+	.align_size		= cw1200_sdio_align_size,
+#ifdef CONFIG_CW1200_PM
+	.power_mgmt		= cw1200_sdio_pm,
+#endif
+};
+
+/* Probe Function to be called by SDIO stack when device is discovered */
+static int __devinit cw1200_sdio_probe(struct sdio_func *func,
+				       const struct sdio_device_id *id)
+{
+	struct sbus_priv *self;
+	int status;
+
+	pr_info("cw1200_wlan_sdio Probe called\n");
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
+	self->pdata = cw1200_get_platform_data();
+	self->func = func;
+	sdio_set_drvdata(func, self);
+	sdio_claim_host(func);
+	sdio_enable_func(func);
+	sdio_release_host(func);
+
+	status = cw1200_core_probe(&cw1200_sdio_sbus_ops,
+				   self, &func->dev, &self->core,
+				   self->pdata->ref_clk,
+				   self->pdata->macaddr,
+				   self->pdata->sdd_file);
+	if (status) {
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
+static void __devexit cw1200_sdio_disconnect(struct sdio_func *func)
+{
+	struct sbus_priv *self = sdio_get_drvdata(func);
+
+	if (self) {
+#ifndef CONFIG_CW1200_POLL_IRQ
+		cw1200_sdio_irq_unsubscribe(self);
+#endif
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
+	.remove		= __devexit_p(cw1200_sdio_disconnect),
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
diff --git a/drivers/staging/cw1200/cw1200_spi.c b/drivers/staging/cw1200/cw1200_spi.c
new file mode 100644
index 0000000..759753c
--- /dev/null
+++ b/drivers/staging/cw1200/cw1200_spi.c
@@ -0,0 +1,563 @@
+/*
+ * Mac80211 SPI driver for ST-Ericsson CW1200 device
+ *
+ * Copyright (c) 2011, Sagrad Inc.
+ * Author:  Solomon Peachy <speachy@sagrad.com>
+ *
+ * Based on cw1200_sdio.c
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
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
+#include <net/mac80211.h>
+
+#include <linux/spi/spi.h>
+#include <linux/device.h>
+
+#include "cw1200.h"
+#include "sbus.h"
+#include "cw1200_plat.h"
+#include "hwio.h"
+
+MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
+MODULE_DESCRIPTION("mac80211 ST-Ericsson CW1200 SPI driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:cw1200_wlan_spi");
+
+#if 0
+/* Note that this is an example of integrating into your board support file */
+static struct resource cw1200_href_resources[] = {
+	{
+		.start = GPIO_RF_RESET,
+		.end = GPIO_RF_RESET,
+		.flags = IORESOURCE_IO,
+		.name = "cw1200_wlan_reset",
+	},
+	{
+		.start = GPIO_RF_POWERUP,
+		.end = GPIO_RF_POWERUP,
+		.flags = IORESOURCE_IO,
+		.name = "cw1200_wlan_powerup",
+	},
+};
+
+static int cw1200_power_ctrl(const struct cw1200_platform_data_spi *pdata,
+			     bool enable)
+{
+	/* Control 3v3 and 1v8 to hardware as appropriate */
+	/* Note this is not needed if it's controlled elsewhere or always on */
+
+	/* May require delay for power to stabilize */
+	return 0;
+}
+static int cw1200_clk_ctrl(const struct cw1200_platform_data_spi *pdata,
+			   bool enable)
+{
+	/* Turn CLK_32K off and on as appropriate. */
+	/* Note this is not needed if it's always on */
+
+	/* May require delay for clock to stabilize */
+	return 0;
+}
+
+static struct cw1200_platform_data_spi cw1200_platform_data = {
+	.ref_clk = 38400,
+	.spi_bits_per_word = 16,
+	.reset = &cw1200_href_resources[0],
+	.powerup = &cw1200_href_resources[1],
+	.power_ctrl = cw1200_power_ctrl,
+	.clk_ctrl = cw1200_clk_ctrl,
+/*	.macaddr = ??? */
+	.sdd_file = "sdd_sagrad_1091_1098.bin",
+};
+static struct spi_board_info myboard_spi_devices[] __initdata = {
+	{
+		.modalias = "cw1200_wlan_spi",
+		.max_speed_hz = 10000000, /* 52MHz Max */
+		.bus_num = 0,
+		.irq = WIFI_IRQ,
+		.platform_data = &cw1200_platform_data,
+		.chip_select = 0,
+	},
+};
+#endif
+
+struct sbus_priv {
+	struct spi_device	*func;
+	struct cw1200_common	*core;
+	const struct cw1200_platform_data_spi *pdata;
+	spinlock_t		lock;
+	int claimed;
+};
+
+/* sbus_ops implemetation */
+
+#define SDIO_TO_SPI_ADDR(addr) ((addr & 0x1f)>>2)
+#define SET_WRITE 0x7FFF /* usage: and operation */
+#define SET_READ 0x8000  /* usage: or operation */
+
+/* Notes on byte ordering:
+   LE:  B0 B1 B2 B3
+   BE:  B3 B2 B1 B0
+
+   Hardware expects 32-bit data in this order:
+
+   B1 B0 B3 B2
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
+	/* pr_info("READ : %04d from 0x%02x (%04x)\n", count, addr, le16_to_cpu(regaddr)); */
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
+#if 0
+	pr_info("READ : ");
+	for (i = 0 ; i < t_addr.len ; i++)
+		printk("%02x ", ((u8 *)t_addr.tx_buf)[i]);
+	printk(" : ");
+	for (i = 0 ; i < t_msg.len ; i++)
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
+		for (i = 0 ; i < (count + 1) >> 1 ; i++) {
+			buf[i] = swab16(buf[i]);
+		}
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
+	/* pr_info("WRITE: %04d  to  0x%02x (%04x)\n", count, addr, le16_to_cpu(regaddr)); */
+
+#if defined(__LITTLE_ENDIAN)
+	/* We have to byteswap if the SPI bus is limited to 8b operation */
+	if (self->func->bits_per_word == 8)
+#endif
+	{
+		uint16_t *buf = (uint16_t *)src;
+		regaddr = swab16(regaddr);
+		for (i = 0 ; i < (count + 1) >> 1 ; i++)
+			buf[i] = swab16(buf[i]);
+	}
+
+#if 0
+	pr_info("WRITE: ");
+	for (i = 0 ; i < t_addr.len ; i++)
+		printk("%02x ", ((u8 *)t_addr.tx_buf)[i]);
+	printk(" : ");
+	for (i = 0 ; i < t_msg.len ; i++)
+		printk("%02x ", ((u8 *)t_msg.tx_buf)[i]);
+	printk("\n");
+#endif
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t_addr, &m);
+	spi_message_add_tail(&t_msg, &m);
+	rval = spi_sync(self->func, &m);
+
+#if 0
+	pr_info("WROTE: %d\n", m.actual_length);
+#endif
+
+#if defined(__LITTLE_ENDIAN)
+	/* We have to byteswap if the SPI bus is limited to 8b operation */
+	if (self->func->bits_per_word == 8)
+#endif
+	{
+		uint16_t *buf = (uint16_t *)src;
+		for (i = 0 ; i < (count + 1) >> 1 ; i++)
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
+#ifndef CONFIG_CW1200_POLL_IRQ
+static irqreturn_t cw1200_spi_irq_handler(int irq, void *dev_id)
+{
+	struct sbus_priv *self = dev_id;
+
+	BUG_ON(!self);
+	cw1200_irq_handler(self->core);
+	return IRQ_HANDLED;
+}
+
+static int cw1200_spi_irq_subscribe(struct sbus_priv *self)
+{
+	int ret;
+
+	pr_debug("SW IRQ subscribe\n");
+
+	ret = request_any_context_irq(self->func->irq, cw1200_spi_irq_handler,
+				      IRQF_TRIGGER_RISING,
+				      "cw1200_wlan_irq", self);
+	if (WARN_ON(ret < 0))
+		goto exit;
+
+#ifdef CONFIG_CW1200_PM
+	ret = enable_irq_wake(self->func->irq);
+	if (WARN_ON(ret))
+		goto free_irq;
+#endif
+
+	return 0;
+
+#ifdef CONFIG_CW1200_PM
+free_irq:
+	free_irq(self->func->irq, self);
+#endif
+exit:
+	return ret;
+}
+
+static int cw1200_spi_irq_unsubscribe(struct sbus_priv *self)
+{
+	int ret = 0;
+
+	pr_debug("SW IRQ unsubscribe\n");
+#ifdef CONFIG_CW1200_PM
+	disable_irq_wake(self->func->irq);
+#endif
+	free_irq(self->func->irq, self);
+
+	return ret;
+}
+#endif
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
+static int cw1200_spi_reset(struct sbus_priv *self)
+{
+	const struct resource *reset = self->pdata->reset;
+	const struct resource *powerup = self->pdata->reset;
+
+	if (!reset || !powerup) {
+		cw1200_spi_off(self->pdata);
+		msleep(500);
+		cw1200_spi_on(self->pdata);
+		return 0;
+	}
+
+	gpio_set_value(reset->start, 0);
+	gpio_set_value(powerup->start, 0);
+	msleep(50);
+	gpio_set_value(powerup->start, 1);
+	msleep(250);
+	gpio_set_value(reset->start, 1);
+	msleep(50);
+
+	return 0;
+}
+
+static size_t cw1200_spi_align_size(struct sbus_priv *self, size_t size)
+{
+	return size & 1 ? size + 1 : size;
+}
+
+#ifdef CONFIG_CW1200_PM
+static int cw1200_spi_pm(struct sbus_priv *self, bool suspend)
+{
+	return irq_set_irq_wake(self->func->irq, suspend);
+}
+#endif
+
+static struct sbus_ops cw1200_spi_sbus_ops = {
+	.sbus_memcpy_fromio	= cw1200_spi_memcpy_fromio,
+	.sbus_memcpy_toio	= cw1200_spi_memcpy_toio,
+	.lock			= cw1200_spi_lock,
+	.unlock			= cw1200_spi_unlock,
+#ifndef CONFIG_CW1200_POLL_IRQ
+	.irq_subscribe		= cw1200_spi_irq_subscribe,
+	.irq_unsubscribe	= cw1200_spi_irq_unsubscribe,
+#endif
+	.reset			= cw1200_spi_reset,
+	.align_size		= cw1200_spi_align_size,
+#ifdef CONFIG_CW1200_PM
+	.power_mgmt		= cw1200_spi_pm,
+#endif
+};
+
+/* Probe Function to be called by SPI stack when device is discovered */
+static int __devinit cw1200_spi_probe(struct spi_device *func)
+{
+	const struct cw1200_platform_data_spi *plat_data = func->dev.platform_data;
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
+	pr_info("cw1200_wlan_spi Probe called (CS %d M %d BPW %d CLK %d)\n",
+	       func->chip_select, func->mode, func->bits_per_word, func->max_speed_hz);
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
+	status = cw1200_core_probe(&cw1200_spi_sbus_ops,
+				   self, &func->dev, &self->core,
+				   self->pdata->ref_clk,
+				   self->pdata->macaddr,
+				   self->pdata->sdd_file);
+
+	if (status) {
+		cw1200_spi_off(plat_data);
+		kfree(self);
+	}
+
+	return status;
+}
+
+/* Disconnect Function to be called by SPI stack when device is disconnected */
+static int __devexit cw1200_spi_disconnect(struct spi_device *func)
+{
+	struct sbus_priv *self = spi_get_drvdata(func);
+
+	if (self) {
+#ifndef CONFIG_CW1200_POLL_IRQ
+		cw1200_spi_irq_unsubscribe(self);
+#endif
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
+	.remove		= __devexit_p(cw1200_spi_disconnect),
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
-- 
1.7.11.7

