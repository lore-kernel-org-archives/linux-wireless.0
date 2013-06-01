Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:32825
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752099Ab3FAMIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:08:47 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next] cw1200:  Rename 'sbus' to 'hwbus'
Date: Sat,  1 Jun 2013 08:08:42 -0400
Message-Id: <1370088522-21212-1-git-send-email-pizza@shaftnet.org> (sfid-20130601_140853_156932_6059F281)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This avoids problems when building on SPARC targets due to the driver 
calling the bus abstraction layer 'sbus'.  Not that any SBUS-sporting 
SPARC targets are likely to have an SDIO controller, but this is the
correct thing to do.

See http://kisskb.ellerman.id.au/kisskb/buildresult/8846508/

Signed-off-by:  Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/bh.c          | 20 +++++++-------
 drivers/net/wireless/cw1200/cw1200.h      | 10 +++----
 drivers/net/wireless/cw1200/cw1200_sdio.c | 44 +++++++++++++++----------------
 drivers/net/wireless/cw1200/cw1200_spi.c  | 38 +++++++++++++-------------
 drivers/net/wireless/cw1200/fwio.c        | 10 +++----
 drivers/net/wireless/cw1200/hwbus.h       | 33 +++++++++++++++++++++++
 drivers/net/wireless/cw1200/hwio.c        | 30 ++++++++++-----------
 drivers/net/wireless/cw1200/main.c        | 14 +++++-----
 drivers/net/wireless/cw1200/pm.c          |  6 ++---
 drivers/net/wireless/cw1200/sbus.h        | 33 -----------------------
 10 files changed, 119 insertions(+), 119 deletions(-)
 create mode 100644 drivers/net/wireless/cw1200/hwbus.h
 delete mode 100644 drivers/net/wireless/cw1200/sbus.h

diff --git a/drivers/net/wireless/cw1200/bh.c b/drivers/net/wireless/cw1200/bh.c
index c1bb0f5..c1ec2a4 100644
--- a/drivers/net/wireless/cw1200/bh.c
+++ b/drivers/net/wireless/cw1200/bh.c
@@ -23,7 +23,7 @@
 #include "bh.h"
 #include "hwio.h"
 #include "wsm.h"
-#include "sbus.h"
+#include "hwbus.h"
 #include "debug.h"
 #include "fwio.h"
 
@@ -104,7 +104,7 @@ void cw1200_irq_handler(struct cw1200_common *priv)
 	pr_debug("[BH] irq.\n");
 
 	/* Disable Interrupts! */
-	/* NOTE:  sbus_ops->lock already held */
+	/* NOTE:  hwbus_ops->lock already held */
 	__cw1200_irq_enable(priv, 0);
 
 	if (/* WARN_ON */(priv->bh_error))
@@ -268,8 +268,8 @@ static int cw1200_bh_rx_helper(struct cw1200_common *priv,
 	 */
 	read_len = read_len + 2;
 
-	alloc_len = priv->sbus_ops->align_size(
-		priv->sbus_priv, read_len);
+	alloc_len = priv->hwbus_ops->align_size(
+		priv->hwbus_priv, read_len);
 
 	/* Check if not exceeding CW1200 capabilities */
 	if (WARN_ON_ONCE(alloc_len > EFFECTIVE_BUF_SIZE)) {
@@ -387,8 +387,8 @@ static int cw1200_bh_tx_helper(struct cw1200_common *priv,
 
 	atomic_add(1, &priv->bh_tx);
 
-	tx_len = priv->sbus_ops->align_size(
-		priv->sbus_priv, tx_len);
+	tx_len = priv->hwbus_ops->align_size(
+		priv->hwbus_priv, tx_len);
 
 	/* Check if not exceeding CW1200 capabilities */
 	if (WARN_ON_ONCE(tx_len > EFFECTIVE_BUF_SIZE))
@@ -600,15 +600,15 @@ static int cw1200_bh(void *arg)
 
 	done:
 		/* Re-enable device interrupts */
-		priv->sbus_ops->lock(priv->sbus_priv);
+		priv->hwbus_ops->lock(priv->hwbus_priv);
 		__cw1200_irq_enable(priv, 1);
-		priv->sbus_ops->unlock(priv->sbus_priv);
+		priv->hwbus_ops->unlock(priv->hwbus_priv);
 	}
 
 	/* Explicitly disable device interrupts */
-	priv->sbus_ops->lock(priv->sbus_priv);
+	priv->hwbus_ops->lock(priv->hwbus_priv);
 	__cw1200_irq_enable(priv, 0);
-	priv->sbus_ops->unlock(priv->sbus_priv);
+	priv->hwbus_ops->unlock(priv->hwbus_priv);
 
 	if (!term) {
 		pr_err("[BH] Fatal error, exiting.\n");
diff --git a/drivers/net/wireless/cw1200/cw1200.h b/drivers/net/wireless/cw1200/cw1200.h
index ee233d3..a98019b 100644
--- a/drivers/net/wireless/cw1200/cw1200.h
+++ b/drivers/net/wireless/cw1200/cw1200.h
@@ -31,7 +31,7 @@
 #include "pm.h"
 
 /* Forward declarations */
-struct sbus_ops;
+struct hwbus_ops;
 struct task_struct;
 struct cw1200_debug_priv;
 struct firmware;
@@ -110,8 +110,8 @@ struct cw1200_common {
 	u8 mac_addr[ETH_ALEN];
 
 	/* Hardware interface */
-	const struct sbus_ops		*sbus_ops;
-	struct sbus_priv		*sbus_priv;
+	const struct hwbus_ops		*hwbus_ops;
+	struct hwbus_priv		*hwbus_priv;
 
 	/* Hardware information */
 	enum {
@@ -300,8 +300,8 @@ struct cw1200_sta_priv {
 };
 
 /* interfaces for the drivers */
-int cw1200_core_probe(const struct sbus_ops *sbus_ops,
-		      struct sbus_priv *sbus,
+int cw1200_core_probe(const struct hwbus_ops *hwbus_ops,
+		      struct hwbus_priv *hwbus,
 		      struct device *pdev,
 		      struct cw1200_common **pself,
 		      int ref_clk, const u8 *macaddr,
diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index 16deb87..0865f92 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -20,7 +20,7 @@
 #include <net/mac80211.h>
 
 #include "cw1200.h"
-#include "sbus.h"
+#include "hwbus.h"
 #include <linux/cw1200_platform.h>
 #include "hwio.h"
 
@@ -30,7 +30,7 @@ MODULE_LICENSE("GPL");
 
 #define SDIO_BLOCK_SIZE (512)
 
-struct sbus_priv {
+struct hwbus_priv {
 	struct sdio_func	*func;
 	struct cw1200_common	*core;
 	const struct cw1200_platform_data_sdio *pdata;
@@ -49,35 +49,35 @@ static const struct sdio_device_id cw1200_sdio_ids[] = {
 	{ /* end: all zeroes */			},
 };
 
-/* sbus_ops implemetation */
+/* hwbus_ops implemetation */
 
-static int cw1200_sdio_memcpy_fromio(struct sbus_priv *self,
+static int cw1200_sdio_memcpy_fromio(struct hwbus_priv *self,
 				     unsigned int addr,
 				     void *dst, int count)
 {
 	return sdio_memcpy_fromio(self->func, dst, addr, count);
 }
 
-static int cw1200_sdio_memcpy_toio(struct sbus_priv *self,
+static int cw1200_sdio_memcpy_toio(struct hwbus_priv *self,
 				   unsigned int addr,
 				   const void *src, int count)
 {
 	return sdio_memcpy_toio(self->func, addr, (void *)src, count);
 }
 
-static void cw1200_sdio_lock(struct sbus_priv *self)
+static void cw1200_sdio_lock(struct hwbus_priv *self)
 {
 	sdio_claim_host(self->func);
 }
 
-static void cw1200_sdio_unlock(struct sbus_priv *self)
+static void cw1200_sdio_unlock(struct hwbus_priv *self)
 {
 	sdio_release_host(self->func);
 }
 
 static void cw1200_sdio_irq_handler(struct sdio_func *func)
 {
-	struct sbus_priv *self = sdio_get_drvdata(func);
+	struct hwbus_priv *self = sdio_get_drvdata(func);
 
 	/* note:  sdio_host already claimed here. */
 	if (self->core)
@@ -91,7 +91,7 @@ static irqreturn_t cw1200_gpio_hardirq(int irq, void *dev_id)
 
 static irqreturn_t cw1200_gpio_irq(int irq, void *dev_id)
 {
-	struct sbus_priv *self = dev_id;
+	struct hwbus_priv *self = dev_id;
 
 	if (self->core) {
 		sdio_claim_host(self->func);
@@ -103,7 +103,7 @@ static irqreturn_t cw1200_gpio_irq(int irq, void *dev_id)
 	}
 }
 
-static int cw1200_request_irq(struct sbus_priv *self)
+static int cw1200_request_irq(struct hwbus_priv *self)
 {
 	int ret;
 	const struct resource *irq = self->pdata->irq;
@@ -141,7 +141,7 @@ err:
 	return ret;
 }
 
-static int cw1200_sdio_irq_subscribe(struct sbus_priv *self)
+static int cw1200_sdio_irq_subscribe(struct hwbus_priv *self)
 {
 	int ret = 0;
 
@@ -156,7 +156,7 @@ static int cw1200_sdio_irq_subscribe(struct sbus_priv *self)
 	return ret;
 }
 
-static int cw1200_sdio_irq_unsubscribe(struct sbus_priv *self)
+static int cw1200_sdio_irq_unsubscribe(struct hwbus_priv *self)
 {
 	int ret = 0;
 
@@ -238,7 +238,7 @@ static int cw1200_sdio_on(const struct cw1200_platform_data_sdio *pdata)
 	return 0;
 }
 
-static size_t cw1200_sdio_align_size(struct sbus_priv *self, size_t size)
+static size_t cw1200_sdio_align_size(struct hwbus_priv *self, size_t size)
 {
 	if (self->pdata->no_nptb)
 		size = round_up(size, SDIO_BLOCK_SIZE);
@@ -248,7 +248,7 @@ static size_t cw1200_sdio_align_size(struct sbus_priv *self, size_t size)
 	return size;
 }
 
-static int cw1200_sdio_pm(struct sbus_priv *self, bool suspend)
+static int cw1200_sdio_pm(struct hwbus_priv *self, bool suspend)
 {
 	int ret = 0;
 
@@ -257,9 +257,9 @@ static int cw1200_sdio_pm(struct sbus_priv *self, bool suspend)
 	return ret;
 }
 
-static struct sbus_ops cw1200_sdio_sbus_ops = {
-	.sbus_memcpy_fromio	= cw1200_sdio_memcpy_fromio,
-	.sbus_memcpy_toio	= cw1200_sdio_memcpy_toio,
+static struct hwbus_ops cw1200_sdio_hwbus_ops = {
+	.hwbus_memcpy_fromio	= cw1200_sdio_memcpy_fromio,
+	.hwbus_memcpy_toio	= cw1200_sdio_memcpy_toio,
 	.lock			= cw1200_sdio_lock,
 	.unlock			= cw1200_sdio_unlock,
 	.align_size		= cw1200_sdio_align_size,
@@ -270,7 +270,7 @@ static struct sbus_ops cw1200_sdio_sbus_ops = {
 static int cw1200_sdio_probe(struct sdio_func *func,
 				       const struct sdio_device_id *id)
 {
-	struct sbus_priv *self;
+	struct hwbus_priv *self;
 	int status;
 
 	pr_info("cw1200_wlan_sdio: Probe called\n");
@@ -281,7 +281,7 @@ static int cw1200_sdio_probe(struct sdio_func *func,
 
 	self = kzalloc(sizeof(*self), GFP_KERNEL);
 	if (!self) {
-		pr_err("Can't allocate SDIO sbus_priv.\n");
+		pr_err("Can't allocate SDIO hwbus_priv.\n");
 		return -ENOMEM;
 	}
 
@@ -296,7 +296,7 @@ static int cw1200_sdio_probe(struct sdio_func *func,
 
 	status = cw1200_sdio_irq_subscribe(self);
 
-	status = cw1200_core_probe(&cw1200_sdio_sbus_ops,
+	status = cw1200_core_probe(&cw1200_sdio_hwbus_ops,
 				   self, &func->dev, &self->core,
 				   self->pdata->ref_clk,
 				   self->pdata->macaddr,
@@ -319,7 +319,7 @@ static int cw1200_sdio_probe(struct sdio_func *func,
  */
 static void cw1200_sdio_disconnect(struct sdio_func *func)
 {
-	struct sbus_priv *self = sdio_get_drvdata(func);
+	struct hwbus_priv *self = sdio_get_drvdata(func);
 
 	if (self) {
 		cw1200_sdio_irq_unsubscribe(self);
@@ -340,7 +340,7 @@ static int cw1200_sdio_suspend(struct device *dev)
 {
 	int ret;
 	struct sdio_func *func = dev_to_sdio_func(dev);
-	struct sbus_priv *self = sdio_get_drvdata(func);
+	struct hwbus_priv *self = sdio_get_drvdata(func);
 
 	if (!cw1200_can_suspend(self->core))
 		return -EAGAIN;
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 976f3b5..22db584 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -25,7 +25,7 @@
 #include <linux/device.h>
 
 #include "cw1200.h"
-#include "sbus.h"
+#include "hwbus.h"
 #include <linux/cw1200_platform.h>
 #include "hwio.h"
 
@@ -36,7 +36,7 @@ MODULE_ALIAS("spi:cw1200_wlan_spi");
 
 /* #define SPI_DEBUG */
 
-struct sbus_priv {
+struct hwbus_priv {
 	struct spi_device	*func;
 	struct cw1200_common	*core;
 	const struct cw1200_platform_data_spi *pdata;
@@ -57,7 +57,7 @@ struct sbus_priv {
    B1 B0 B3 B2
 */
 
-static int cw1200_spi_memcpy_fromio(struct sbus_priv *self,
+static int cw1200_spi_memcpy_fromio(struct hwbus_priv *self,
 				     unsigned int addr,
 				     void *dst, int count)
 {
@@ -118,7 +118,7 @@ static int cw1200_spi_memcpy_fromio(struct sbus_priv *self,
 	return ret;
 }
 
-static int cw1200_spi_memcpy_toio(struct sbus_priv *self,
+static int cw1200_spi_memcpy_toio(struct hwbus_priv *self,
 				   unsigned int addr,
 				   const void *src, int count)
 {
@@ -186,7 +186,7 @@ static int cw1200_spi_memcpy_toio(struct sbus_priv *self,
 	return rval;
 }
 
-static void cw1200_spi_lock(struct sbus_priv *self)
+static void cw1200_spi_lock(struct hwbus_priv *self)
 {
 	unsigned long flags;
 
@@ -208,7 +208,7 @@ static void cw1200_spi_lock(struct sbus_priv *self)
 	return;
 }
 
-static void cw1200_spi_unlock(struct sbus_priv *self)
+static void cw1200_spi_unlock(struct hwbus_priv *self)
 {
 	unsigned long flags;
 
@@ -220,7 +220,7 @@ static void cw1200_spi_unlock(struct sbus_priv *self)
 
 static irqreturn_t cw1200_spi_irq_handler(int irq, void *dev_id)
 {
-	struct sbus_priv *self = dev_id;
+	struct hwbus_priv *self = dev_id;
 
 	if (self->core) {
 		cw1200_irq_handler(self->core);
@@ -230,7 +230,7 @@ static irqreturn_t cw1200_spi_irq_handler(int irq, void *dev_id)
 	}
 }
 
-static int cw1200_spi_irq_subscribe(struct sbus_priv *self)
+static int cw1200_spi_irq_subscribe(struct hwbus_priv *self)
 {
 	int ret;
 
@@ -254,7 +254,7 @@ exit:
 	return ret;
 }
 
-static int cw1200_spi_irq_unsubscribe(struct sbus_priv *self)
+static int cw1200_spi_irq_unsubscribe(struct hwbus_priv *self)
 {
 	int ret = 0;
 
@@ -330,19 +330,19 @@ static int cw1200_spi_on(const struct cw1200_platform_data_spi *pdata)
 	return 0;
 }
 
-static size_t cw1200_spi_align_size(struct sbus_priv *self, size_t size)
+static size_t cw1200_spi_align_size(struct hwbus_priv *self, size_t size)
 {
 	return size & 1 ? size + 1 : size;
 }
 
-static int cw1200_spi_pm(struct sbus_priv *self, bool suspend)
+static int cw1200_spi_pm(struct hwbus_priv *self, bool suspend)
 {
 	return irq_set_irq_wake(self->func->irq, suspend);
 }
 
-static struct sbus_ops cw1200_spi_sbus_ops = {
-	.sbus_memcpy_fromio	= cw1200_spi_memcpy_fromio,
-	.sbus_memcpy_toio	= cw1200_spi_memcpy_toio,
+static struct hwbus_ops cw1200_spi_hwbus_ops = {
+	.hwbus_memcpy_fromio	= cw1200_spi_memcpy_fromio,
+	.hwbus_memcpy_toio	= cw1200_spi_memcpy_toio,
 	.lock			= cw1200_spi_lock,
 	.unlock			= cw1200_spi_unlock,
 	.align_size		= cw1200_spi_align_size,
@@ -354,7 +354,7 @@ static int cw1200_spi_probe(struct spi_device *func)
 {
 	const struct cw1200_platform_data_spi *plat_data =
 		func->dev.platform_data;
-	struct sbus_priv *self;
+	struct hwbus_priv *self;
 	int status;
 
 	/* Sanity check speed */
@@ -388,7 +388,7 @@ static int cw1200_spi_probe(struct spi_device *func)
 
 	self = kzalloc(sizeof(*self), GFP_KERNEL);
 	if (!self) {
-		pr_err("Can't allocate SPI sbus_priv.");
+		pr_err("Can't allocate SPI hwbus_priv.");
 		return -ENOMEM;
 	}
 
@@ -400,7 +400,7 @@ static int cw1200_spi_probe(struct spi_device *func)
 
 	status = cw1200_spi_irq_subscribe(self);
 
-	status = cw1200_core_probe(&cw1200_spi_sbus_ops,
+	status = cw1200_core_probe(&cw1200_spi_hwbus_ops,
 				   self, &func->dev, &self->core,
 				   self->pdata->ref_clk,
 				   self->pdata->macaddr,
@@ -419,7 +419,7 @@ static int cw1200_spi_probe(struct spi_device *func)
 /* Disconnect Function to be called by SPI stack when device is disconnected */
 static int cw1200_spi_disconnect(struct spi_device *func)
 {
-	struct sbus_priv *self = spi_get_drvdata(func);
+	struct hwbus_priv *self = spi_get_drvdata(func);
 
 	if (self) {
 		cw1200_spi_irq_unsubscribe(self);
@@ -437,7 +437,7 @@ static int cw1200_spi_disconnect(struct spi_device *func)
 #ifdef CONFIG_PM
 static int cw1200_spi_suspend(struct device *dev, pm_message_t state)
 {
-	struct sbus_priv *self = spi_get_drvdata(to_spi_device(dev));
+	struct hwbus_priv *self = spi_get_drvdata(to_spi_device(dev));
 
 	if (!cw1200_can_suspend(self->core))
 		return -EAGAIN;
diff --git a/drivers/net/wireless/cw1200/fwio.c b/drivers/net/wireless/cw1200/fwio.c
index ad01cd2..427c9f2 100644
--- a/drivers/net/wireless/cw1200/fwio.c
+++ b/drivers/net/wireless/cw1200/fwio.c
@@ -22,7 +22,7 @@
 #include "cw1200.h"
 #include "fwio.h"
 #include "hwio.h"
-#include "sbus.h"
+#include "hwbus.h"
 #include "bh.h"
 
 static int cw1200_get_hw_type(u32 config_reg_val, int *major_revision)
@@ -489,9 +489,9 @@ int cw1200_load_firmware(struct cw1200_common *priv)
 	}
 
 	/* Enable interrupt signalling */
-	priv->sbus_ops->lock(priv->sbus_priv);
+	priv->hwbus_ops->lock(priv->hwbus_priv);
 	ret = __cw1200_irq_enable(priv, 1);
-	priv->sbus_ops->unlock(priv->sbus_priv);
+	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	if (ret < 0)
 		goto unsubscribe;
 
@@ -518,8 +518,8 @@ out:
 
 unsubscribe:
 	/* Disable interrupt signalling */
-	priv->sbus_ops->lock(priv->sbus_priv);
+	priv->hwbus_ops->lock(priv->hwbus_priv);
 	ret = __cw1200_irq_enable(priv, 0);
-	priv->sbus_ops->unlock(priv->sbus_priv);
+	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	return ret;
 }
diff --git a/drivers/net/wireless/cw1200/hwbus.h b/drivers/net/wireless/cw1200/hwbus.h
new file mode 100644
index 0000000..8b2fc83
--- /dev/null
+++ b/drivers/net/wireless/cw1200/hwbus.h
@@ -0,0 +1,33 @@
+/*
+ * Common hwbus abstraction layer interface for cw1200 wireless driver
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef CW1200_HWBUS_H
+#define CW1200_HWBUS_H
+
+struct hwbus_priv;
+
+void cw1200_irq_handler(struct cw1200_common *priv);
+
+/* This MUST be wrapped with hwbus_ops->lock/unlock! */
+int __cw1200_irq_enable(struct cw1200_common *priv, int enable);
+
+struct hwbus_ops {
+	int (*hwbus_memcpy_fromio)(struct hwbus_priv *self, unsigned int addr,
+					void *dst, int count);
+	int (*hwbus_memcpy_toio)(struct hwbus_priv *self, unsigned int addr,
+					const void *src, int count);
+	void (*lock)(struct hwbus_priv *self);
+	void (*unlock)(struct hwbus_priv *self);
+	size_t (*align_size)(struct hwbus_priv *self, size_t size);
+	int (*power_mgmt)(struct hwbus_priv *self, bool suspend);
+};
+
+#endif /* CW1200_HWBUS_H */
diff --git a/drivers/net/wireless/cw1200/hwio.c b/drivers/net/wireless/cw1200/hwio.c
index 1af7b3d..142f45ef 100644
--- a/drivers/net/wireless/cw1200/hwio.c
+++ b/drivers/net/wireless/cw1200/hwio.c
@@ -18,7 +18,7 @@
 
 #include "cw1200.h"
 #include "hwio.h"
-#include "sbus.h"
+#include "hwbus.h"
 
  /* Sdio addr is 4*spi_addr */
 #define SPI_REG_ADDR_TO_SDIO(spi_reg_addr) ((spi_reg_addr) << 2)
@@ -46,7 +46,7 @@ static int __cw1200_reg_read(struct cw1200_common *priv, u16 addr,
 	addr_sdio = SPI_REG_ADDR_TO_SDIO(addr);
 	sdio_reg_addr_17bit = SDIO_ADDR17BIT(buf_id, 0, 0, addr_sdio);
 
-	return priv->sbus_ops->sbus_memcpy_fromio(priv->sbus_priv,
+	return priv->hwbus_ops->hwbus_memcpy_fromio(priv->hwbus_priv,
 						  sdio_reg_addr_17bit,
 						  buf, buf_len);
 }
@@ -61,7 +61,7 @@ static int __cw1200_reg_write(struct cw1200_common *priv, u16 addr,
 	addr_sdio = SPI_REG_ADDR_TO_SDIO(addr);
 	sdio_reg_addr_17bit = SDIO_ADDR17BIT(buf_id, 0, 0, addr_sdio);
 
-	return priv->sbus_ops->sbus_memcpy_toio(priv->sbus_priv,
+	return priv->hwbus_ops->hwbus_memcpy_toio(priv->hwbus_priv,
 						sdio_reg_addr_17bit,
 						buf, buf_len);
 }
@@ -100,9 +100,9 @@ int cw1200_reg_read(struct cw1200_common *priv, u16 addr, void *buf,
 			size_t buf_len)
 {
 	int ret;
-	priv->sbus_ops->lock(priv->sbus_priv);
+	priv->hwbus_ops->lock(priv->hwbus_priv);
 	ret = __cw1200_reg_read(priv, addr, buf, buf_len, 0);
-	priv->sbus_ops->unlock(priv->sbus_priv);
+	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	return ret;
 }
 
@@ -110,9 +110,9 @@ int cw1200_reg_write(struct cw1200_common *priv, u16 addr, const void *buf,
 			size_t buf_len)
 {
 	int ret;
-	priv->sbus_ops->lock(priv->sbus_priv);
+	priv->hwbus_ops->lock(priv->hwbus_priv);
 	ret = __cw1200_reg_write(priv, addr, buf, buf_len, 0);
-	priv->sbus_ops->unlock(priv->sbus_priv);
+	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	return ret;
 }
 
@@ -121,7 +121,7 @@ int cw1200_data_read(struct cw1200_common *priv, void *buf, size_t buf_len)
 	int ret, retry = 1;
 	int buf_id_rx = priv->buf_id_rx;
 
-	priv->sbus_ops->lock(priv->sbus_priv);
+	priv->hwbus_ops->lock(priv->hwbus_priv);
 
 	while (retry <= MAX_RETRY) {
 		ret = __cw1200_reg_read(priv,
@@ -138,7 +138,7 @@ int cw1200_data_read(struct cw1200_common *priv, void *buf, size_t buf_len)
 		}
 	}
 
-	priv->sbus_ops->unlock(priv->sbus_priv);
+	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	return ret;
 }
 
@@ -148,7 +148,7 @@ int cw1200_data_write(struct cw1200_common *priv, const void *buf,
 	int ret, retry = 1;
 	int buf_id_tx = priv->buf_id_tx;
 
-	priv->sbus_ops->lock(priv->sbus_priv);
+	priv->hwbus_ops->lock(priv->hwbus_priv);
 
 	while (retry <= MAX_RETRY) {
 		ret = __cw1200_reg_write(priv,
@@ -165,7 +165,7 @@ int cw1200_data_write(struct cw1200_common *priv, const void *buf,
 		}
 	}
 
-	priv->sbus_ops->unlock(priv->sbus_priv);
+	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	return ret;
 }
 
@@ -181,7 +181,7 @@ int cw1200_indirect_read(struct cw1200_common *priv, u32 addr, void *buf,
 		goto out;
 	}
 
-	priv->sbus_ops->lock(priv->sbus_priv);
+	priv->hwbus_ops->lock(priv->hwbus_priv);
 	/* Write address */
 	ret = __cw1200_reg_write_32(priv, ST90TDS_SRAM_BASE_ADDR_REG_ID, addr);
 	if (ret < 0) {
@@ -230,7 +230,7 @@ int cw1200_indirect_read(struct cw1200_common *priv, u32 addr, void *buf,
 	}
 
 out:
-	priv->sbus_ops->unlock(priv->sbus_priv);
+	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	return ret;
 }
 
@@ -244,7 +244,7 @@ int cw1200_apb_write(struct cw1200_common *priv, u32 addr, const void *buf,
 		return -EINVAL;
 	}
 
-	priv->sbus_ops->lock(priv->sbus_priv);
+	priv->hwbus_ops->lock(priv->hwbus_priv);
 
 	/* Write address */
 	ret = __cw1200_reg_write_32(priv, ST90TDS_SRAM_BASE_ADDR_REG_ID, addr);
@@ -262,7 +262,7 @@ int cw1200_apb_write(struct cw1200_common *priv, u32 addr, const void *buf,
 	}
 
 out:
-	priv->sbus_ops->unlock(priv->sbus_priv);
+	priv->hwbus_ops->unlock(priv->hwbus_priv);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index ef4b0b9..2ea1bad 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
@@ -31,7 +31,7 @@
 
 #include "cw1200.h"
 #include "txrx.h"
-#include "sbus.h"
+#include "hwbus.h"
 #include "fwio.h"
 #include "hwio.h"
 #include "bh.h"
@@ -528,8 +528,8 @@ u32 cw1200_dpll_from_clk(u16 clk_khz)
 	}
 }
 
-int cw1200_core_probe(const struct sbus_ops *sbus_ops,
-		      struct sbus_priv *sbus,
+int cw1200_core_probe(const struct hwbus_ops *hwbus_ops,
+		      struct hwbus_priv *hwbus,
 		      struct device *pdev,
 		      struct cw1200_common **core,
 		      int ref_clk, const u8 *macaddr,
@@ -556,8 +556,8 @@ int cw1200_core_probe(const struct sbus_ops *sbus_ops,
 	if (cw1200_sdd_path)
 		priv->sdd_path = cw1200_sdd_path;
 
-	priv->sbus_ops = sbus_ops;
-	priv->sbus_priv = sbus;
+	priv->hwbus_ops = hwbus_ops;
+	priv->hwbus_priv = hwbus;
 	priv->pdev = pdev;
 	SET_IEEE80211_DEV(priv->hw, pdev);
 
@@ -616,9 +616,9 @@ EXPORT_SYMBOL_GPL(cw1200_core_probe);
 void cw1200_core_release(struct cw1200_common *self)
 {
 	/* Disable device interrupts */
-	self->sbus_ops->lock(self->sbus_priv);
+	self->hwbus_ops->lock(self->hwbus_priv);
 	__cw1200_irq_enable(self, 0);
-	self->sbus_ops->unlock(self->sbus_priv);
+	self->hwbus_ops->unlock(self->hwbus_priv);
 
 	/* And then clean up */
 	cw1200_unregister_common(self->hw);
diff --git a/drivers/net/wireless/cw1200/pm.c b/drivers/net/wireless/cw1200/pm.c
index 79edfb9..b37abb9 100644
--- a/drivers/net/wireless/cw1200/pm.c
+++ b/drivers/net/wireless/cw1200/pm.c
@@ -15,7 +15,7 @@
 #include "pm.h"
 #include "sta.h"
 #include "bh.h"
-#include "sbus.h"
+#include "hwbus.h"
 
 #define CW1200_BEACON_SKIPPING_MULTIPLIER 3
 
@@ -264,7 +264,7 @@ int cw1200_wow_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	pm_state->suspend_state = state;
 
 	/* Enable IRQ wake */
-	ret = priv->sbus_ops->power_mgmt(priv->sbus_priv, true);
+	ret = priv->hwbus_ops->power_mgmt(priv->hwbus_priv, true);
 	if (ret) {
 		wiphy_err(priv->hw->wiphy,
 			  "PM request failed: %d. WoW is disabled.\n", ret);
@@ -313,7 +313,7 @@ int cw1200_wow_resume(struct ieee80211_hw *hw)
 	pm_state->suspend_state = NULL;
 
 	/* Disable IRQ wake */
-	priv->sbus_ops->power_mgmt(priv->sbus_priv, false);
+	priv->hwbus_ops->power_mgmt(priv->hwbus_priv, false);
 
 	/* Scan.lock must be released before BH is resumed other way
 	 * in case when BSS_LOST command arrived the processing of the
diff --git a/drivers/net/wireless/cw1200/sbus.h b/drivers/net/wireless/cw1200/sbus.h
deleted file mode 100644
index 25f83b0..0000000
--- a/drivers/net/wireless/cw1200/sbus.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Common sbus abstraction layer interface for cw1200 wireless driver
- *
- * Copyright (c) 2010, ST-Ericsson
- * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef CW1200_SBUS_H
-#define CW1200_SBUS_H
-
-struct sbus_priv;
-
-void cw1200_irq_handler(struct cw1200_common *priv);
-
-/* This MUST be wrapped with sbus_ops->lock/unlock! */
-int __cw1200_irq_enable(struct cw1200_common *priv, int enable);
-
-struct sbus_ops {
-	int (*sbus_memcpy_fromio)(struct sbus_priv *self, unsigned int addr,
-					void *dst, int count);
-	int (*sbus_memcpy_toio)(struct sbus_priv *self, unsigned int addr,
-					const void *src, int count);
-	void (*lock)(struct sbus_priv *self);
-	void (*unlock)(struct sbus_priv *self);
-	size_t (*align_size)(struct sbus_priv *self, size_t size);
-	int (*power_mgmt)(struct sbus_priv *self, bool suspend);
-};
-
-#endif /* CW1200_SBUS_H */
-- 
1.8.2.1

