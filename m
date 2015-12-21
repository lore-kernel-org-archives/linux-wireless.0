Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11560 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbLUFRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:17:33 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 25/46] staging: wilc1000: linux_wlan_sdio.c: move all the codes to wilc_sdio.c
Date: Mon, 21 Dec 2015 14:18:29 +0900
Message-ID: <1450675130-17866-26-git-send-email-glen.lee@atmel.com> (sfid-20151221_063059_911257_8D4EFAF1)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To Combine linux_wlan_sdio.c and wilc_sdio.c as one file, move all the codes
in linux_wlan_sdio.c to wilc_sdio.c, and make functions static only.
No Modification has not been made except static, just moved them.
Function declaration in linux_wlan_sdio.h is needless, so just remove them.
linux_wlan_sdio.[ch] will be deleted in the next patch.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c | 160 ----------------------------
 drivers/staging/wilc1000/linux_wlan_sdio.h |   7 --
 drivers/staging/wilc1000/wilc_sdio.c       | 164 ++++++++++++++++++++++++++++-
 3 files changed, 163 insertions(+), 168 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 4b9cb55..67d99e9 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -8,163 +8,3 @@
 #include <linux/of_gpio.h>
 
 #include "linux_wlan_sdio.h"
-
-#define SDIO_MODALIAS "wilc1000_sdio"
-
-#define SDIO_VENDOR_ID_WILC 0x0296
-#define SDIO_DEVICE_ID_WILC 0x5347
-
-static const struct sdio_device_id wilc_sdio_ids[] = {
-	{ SDIO_DEVICE(SDIO_VENDOR_ID_WILC, SDIO_DEVICE_ID_WILC) },
-	{ },
-};
-
-
-static void wilc_sdio_interrupt(struct sdio_func *func)
-{
-	sdio_release_host(func);
-	wilc_handle_isr(sdio_get_drvdata(func));
-	sdio_claim_host(func);
-}
-
-int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd)
-{
-	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
-	int ret;
-	u8 data;
-
-	sdio_claim_host(func);
-
-	func->num = cmd->function;
-	if (cmd->read_write) {  /* write */
-		if (cmd->raw) {
-			sdio_writeb(func, cmd->data, cmd->address, &ret);
-			data = sdio_readb(func, cmd->address, &ret);
-			cmd->data = data;
-		} else {
-			sdio_writeb(func, cmd->data, cmd->address, &ret);
-		}
-	} else {        /* read */
-		data = sdio_readb(func, cmd->address, &ret);
-		cmd->data = data;
-	}
-
-	sdio_release_host(func);
-
-	if (ret)
-		dev_err(&func->dev, "wilc_sdio_cmd52..failed, err(%d)\n", ret);
-	return ret;
-}
-
-
-int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd)
-{
-	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
-	int size, ret;
-
-	sdio_claim_host(func);
-
-	func->num = cmd->function;
-	func->cur_blksize = cmd->block_size;
-	if (cmd->block_mode)
-		size = cmd->count * cmd->block_size;
-	else
-		size = cmd->count;
-
-	if (cmd->read_write) {  /* write */
-		ret = sdio_memcpy_toio(func, cmd->address,
-				       (void *)cmd->buffer, size);
-	} else {        /* read */
-		ret = sdio_memcpy_fromio(func, (void *)cmd->buffer,
-					 cmd->address,  size);
-	}
-
-	sdio_release_host(func);
-
-	if (ret)
-		dev_err(&func->dev, "wilc_sdio_cmd53..failed, err(%d)\n", ret);
-
-	return ret;
-}
-
-static int linux_sdio_probe(struct sdio_func *func,
-			    const struct sdio_device_id *id)
-{
-	struct wilc *wilc;
-	int gpio, ret;
-
-	gpio = -1;
-	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
-		gpio = of_get_gpio(func->dev.of_node, 0);
-		if (gpio < 0)
-			gpio = GPIO_NUM;
-	}
-
-	dev_dbg(&func->dev, "Initializing netdev\n");
-	ret = wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio,
-			     &wilc_hif_sdio);
-	if (ret) {
-		dev_err(&func->dev, "Couldn't initialize netdev\n");
-		return ret;
-	}
-	sdio_set_drvdata(func, wilc);
-	wilc->dev = &func->dev;
-
-	dev_info(&func->dev, "Driver Initializing success\n");
-	return 0;
-}
-
-static void linux_sdio_remove(struct sdio_func *func)
-{
-	wilc_netdev_cleanup(sdio_get_drvdata(func));
-}
-
-static struct sdio_driver wilc1000_sdio_driver = {
-	.name		= SDIO_MODALIAS,
-	.id_table	= wilc_sdio_ids,
-	.probe		= linux_sdio_probe,
-	.remove		= linux_sdio_remove,
-};
-module_driver(wilc1000_sdio_driver,
-	      sdio_register_driver,
-	      sdio_unregister_driver);
-MODULE_LICENSE("GPL");
-
-int wilc_sdio_enable_interrupt(struct wilc *dev)
-{
-	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
-	int ret = 0;
-
-	sdio_claim_host(func);
-	ret = sdio_claim_irq(func, wilc_sdio_interrupt);
-	sdio_release_host(func);
-
-	if (ret < 0) {
-		dev_err(&func->dev, "can't claim sdio_irq, err(%d)\n", ret);
-		ret = -EIO;
-	}
-	return ret;
-}
-
-void wilc_sdio_disable_interrupt(struct wilc *dev)
-{
-	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
-	int ret;
-
-	dev_dbg(&func->dev, "wilc_sdio_disable_interrupt IN\n");
-
-	sdio_claim_host(func);
-	ret = sdio_release_irq(func);
-	if (ret < 0)
-		dev_err(&func->dev, "can't release sdio_irq, err(%d)\n", ret);
-	sdio_release_host(func);
-
-	dev_info(&func->dev, "wilc_sdio_disable_interrupt OUT\n");
-}
-
-int wilc_sdio_init(void)
-{
-	return 1;
-}
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index 8d276c6..abb2312 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -1,8 +1 @@
 #include <linux/mmc/sdio_func.h>
-
-int wilc_sdio_init(void);
-int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd);
-int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd);
-
-int wilc_sdio_enable_interrupt(struct wilc *);
-void wilc_sdio_disable_interrupt(struct wilc *);
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index fa1adcf..e961b50 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -10,8 +10,23 @@
 #include <linux/string.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
-#include "linux_wlan_sdio.h"
 #include "wilc_wfi_netdevice.h"
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/host.h>
+#include <linux/of_gpio.h>
+
+#define SDIO_MODALIAS "wilc1000_sdio"
+
+#define SDIO_VENDOR_ID_WILC 0x0296
+#define SDIO_DEVICE_ID_WILC 0x5347
+
+static const struct sdio_device_id wilc_sdio_ids[] = {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_WILC, SDIO_DEVICE_ID_WILC) },
+	{ },
+};
 
 #define WILC_SDIO_BLOCK_SIZE 512
 
@@ -28,6 +43,153 @@ static wilc_sdio_t g_sdio;
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data);
 static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data);
 
+static void wilc_sdio_interrupt(struct sdio_func *func)
+{
+	sdio_release_host(func);
+	wilc_handle_isr(sdio_get_drvdata(func));
+	sdio_claim_host(func);
+}
+
+static int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd)
+{
+	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
+	int ret;
+	u8 data;
+
+	sdio_claim_host(func);
+
+	func->num = cmd->function;
+	if (cmd->read_write) {  /* write */
+		if (cmd->raw) {
+			sdio_writeb(func, cmd->data, cmd->address, &ret);
+			data = sdio_readb(func, cmd->address, &ret);
+			cmd->data = data;
+		} else {
+			sdio_writeb(func, cmd->data, cmd->address, &ret);
+		}
+	} else {        /* read */
+		data = sdio_readb(func, cmd->address, &ret);
+		cmd->data = data;
+	}
+
+	sdio_release_host(func);
+
+	if (ret)
+		dev_err(&func->dev, "wilc_sdio_cmd52..failed, err(%d)\n", ret);
+	return ret;
+}
+
+
+static int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd)
+{
+	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
+	int size, ret;
+
+	sdio_claim_host(func);
+
+	func->num = cmd->function;
+	func->cur_blksize = cmd->block_size;
+	if (cmd->block_mode)
+		size = cmd->count * cmd->block_size;
+	else
+		size = cmd->count;
+
+	if (cmd->read_write) {  /* write */
+		ret = sdio_memcpy_toio(func, cmd->address,
+				       (void *)cmd->buffer, size);
+	} else {        /* read */
+		ret = sdio_memcpy_fromio(func, (void *)cmd->buffer,
+					 cmd->address,  size);
+	}
+
+	sdio_release_host(func);
+
+	if (ret)
+		dev_err(&func->dev, "wilc_sdio_cmd53..failed, err(%d)\n", ret);
+
+	return ret;
+}
+
+static int linux_sdio_probe(struct sdio_func *func,
+			    const struct sdio_device_id *id)
+{
+	struct wilc *wilc;
+	int gpio, ret;
+
+	gpio = -1;
+	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
+		gpio = of_get_gpio(func->dev.of_node, 0);
+		if (gpio < 0)
+			gpio = GPIO_NUM;
+	}
+
+	dev_dbg(&func->dev, "Initializing netdev\n");
+	ret = wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio,
+			     &wilc_hif_sdio);
+	if (ret) {
+		dev_err(&func->dev, "Couldn't initialize netdev\n");
+		return ret;
+	}
+	sdio_set_drvdata(func, wilc);
+	wilc->dev = &func->dev;
+
+	dev_info(&func->dev, "Driver Initializing success\n");
+	return 0;
+}
+
+static void linux_sdio_remove(struct sdio_func *func)
+{
+	wilc_netdev_cleanup(sdio_get_drvdata(func));
+}
+
+static struct sdio_driver wilc1000_sdio_driver = {
+	.name		= SDIO_MODALIAS,
+	.id_table	= wilc_sdio_ids,
+	.probe		= linux_sdio_probe,
+	.remove		= linux_sdio_remove,
+};
+module_driver(wilc1000_sdio_driver,
+	      sdio_register_driver,
+	      sdio_unregister_driver);
+MODULE_LICENSE("GPL");
+
+static int wilc_sdio_enable_interrupt(struct wilc *dev)
+{
+	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
+	int ret = 0;
+
+	sdio_claim_host(func);
+	ret = sdio_claim_irq(func, wilc_sdio_interrupt);
+	sdio_release_host(func);
+
+	if (ret < 0) {
+		dev_err(&func->dev, "can't claim sdio_irq, err(%d)\n", ret);
+		ret = -EIO;
+	}
+	return ret;
+}
+
+static void wilc_sdio_disable_interrupt(struct wilc *dev)
+{
+	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
+	int ret;
+
+	dev_dbg(&func->dev, "wilc_sdio_disable_interrupt IN\n");
+
+	sdio_claim_host(func);
+	ret = sdio_release_irq(func);
+	if (ret < 0)
+		dev_err(&func->dev, "can't release sdio_irq, err(%d)\n", ret);
+	sdio_release_host(func);
+
+	dev_info(&func->dev, "wilc_sdio_disable_interrupt OUT\n");
+}
+
+static int wilc_sdio_init(void)
+{
+	return 1;
+}
+
 /********************************************
  *
  *      Function 0
-- 
1.9.1

