Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:36385 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbbCRQiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 12:38:55 -0400
Received: by wetk59 with SMTP id k59so36831338wet.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 09:38:53 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Luciano Coelho <luca@coelho.fi>
Subject: [PATCH v7 6/6] wlcore: remove wl12xx_platform_data
Date: Wed, 18 Mar 2015 18:38:30 +0200
Message-Id: <1426696710-6891-7-git-send-email-eliad@wizery.com> (sfid-20150318_173906_094251_8BA75C8B)
In-Reply-To: <1426696710-6891-1-git-send-email-eliad@wizery.com>
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we have wlcore device-tree bindings in place
(for both wl12xx and wl18xx), remove the legacy
wl12xx_platform_data struct, and move its members
into the platform device data (that is passed to wlcore)

Davinci 850 is the only platform that still set
the platform data in the legacy way (and doesn't
have DT bindings), so remove the relevant
code/Kconfig option from the board file (as suggested
by Sekhar Nori)

Since no one currently uses wlcore_spi, simply remove its
platform data support (DT bindings will have to be added
if someone actually needs it)

Signed-off-by: Luciano Coelho <luca@coelho.fi>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v7:
* fix spi compilation (Tony)
* remove irq/irq_trigger from wlcore_platdev_data (they are
  being passed separately)

 arch/arm/mach-davinci/Kconfig                  |  11 ---
 arch/arm/mach-davinci/board-da850-evm.c        | 113 -------------------------
 drivers/net/wireless/ti/wilink_platform_data.c |  25 ------
 drivers/net/wireless/ti/wl12xx/main.c          |  19 ++---
 drivers/net/wireless/ti/wlcore/boot.c          |   1 -
 drivers/net/wireless/ti/wlcore/main.c          |   4 +-
 drivers/net/wireless/ti/wlcore/sdio.c          |  76 +++++------------
 drivers/net/wireless/ti/wlcore/spi.c           |   6 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h      |   6 +-
 include/linux/wl12xx.h                         |  25 ------
 10 files changed, 35 insertions(+), 251 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index cd30f6f..dd8f531 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -200,17 +200,6 @@ config DA850_UI_SD_VIDEO_PORT
 
 endchoice
 
-config DA850_WL12XX
-	bool "AM18x wl1271 daughter board"
-	depends on MACH_DAVINCI_DA850_EVM
-	help
-	  The wl1271 daughter card for AM18x EVMs is a combo wireless
-	  connectivity add-on card, based on the LS Research TiWi module with
-	  Texas Instruments' wl1271 solution.
-	  Say Y if you want to use a wl1271 expansion card connected to the
-	  AM18x EVM.
-
-
 config MACH_MITYOMAPL138
 	bool "Critical Link MityDSP-L138/MityARM-1808 SoM"
 	depends on ARCH_DAVINCI_DA850
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 853b941..1ed545c 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -38,7 +38,6 @@
 #include <linux/regulator/fixed.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
-#include <linux/wl12xx.h>
 
 #include <mach/common.h>
 #include <mach/cp_intc.h>
@@ -60,9 +59,6 @@
 #define DA850_MMCSD_CD_PIN		GPIO_TO_PIN(4, 0)
 #define DA850_MMCSD_WP_PIN		GPIO_TO_PIN(4, 1)
 
-#define DA850_WLAN_EN			GPIO_TO_PIN(6, 9)
-#define DA850_WLAN_IRQ			GPIO_TO_PIN(6, 10)
-
 #define DA850_MII_MDIO_CLKEN_PIN	GPIO_TO_PIN(2, 6)
 
 static struct mtd_partition da850evm_spiflash_part[] = {
@@ -1343,110 +1339,6 @@ static __init void da850_vpif_init(void)
 static __init void da850_vpif_init(void) {}
 #endif
 
-#ifdef CONFIG_DA850_WL12XX
-
-static void wl12xx_set_power(int index, bool power_on)
-{
-	static bool power_state;
-
-	pr_debug("Powering %s wl12xx", power_on ? "on" : "off");
-
-	if (power_on == power_state)
-		return;
-	power_state = power_on;
-
-	if (power_on) {
-		/* Power up sequence required for wl127x devices */
-		gpio_set_value(DA850_WLAN_EN, 1);
-		usleep_range(15000, 15000);
-		gpio_set_value(DA850_WLAN_EN, 0);
-		usleep_range(1000, 1000);
-		gpio_set_value(DA850_WLAN_EN, 1);
-		msleep(70);
-	} else {
-		gpio_set_value(DA850_WLAN_EN, 0);
-	}
-}
-
-static struct davinci_mmc_config da850_wl12xx_mmc_config = {
-	.set_power	= wl12xx_set_power,
-	.wires		= 4,
-	.max_freq	= 25000000,
-	.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_NONREMOVABLE |
-			  MMC_CAP_POWER_OFF_CARD,
-};
-
-static const short da850_wl12xx_pins[] __initconst = {
-	DA850_MMCSD1_DAT_0, DA850_MMCSD1_DAT_1, DA850_MMCSD1_DAT_2,
-	DA850_MMCSD1_DAT_3, DA850_MMCSD1_CLK, DA850_MMCSD1_CMD,
-	DA850_GPIO6_9, DA850_GPIO6_10,
-	-1
-};
-
-static struct wl12xx_platform_data da850_wl12xx_wlan_data __initdata = {
-	.irq			= -1,
-	.irq_trigger		= IRQ_TYPE_EDGE_RISING,
-	.ref_clock_freq		= 38400000,
-	.ref_clock_xtal		= false,
-};
-
-static __init int da850_wl12xx_init(void)
-{
-	int ret;
-
-	ret = davinci_cfg_reg_list(da850_wl12xx_pins);
-	if (ret) {
-		pr_err("wl12xx/mmc mux setup failed: %d\n", ret);
-		goto exit;
-	}
-
-	ret = da850_register_mmcsd1(&da850_wl12xx_mmc_config);
-	if (ret) {
-		pr_err("wl12xx/mmc registration failed: %d\n", ret);
-		goto exit;
-	}
-
-	ret = gpio_request_one(DA850_WLAN_EN, GPIOF_OUT_INIT_LOW, "wl12xx_en");
-	if (ret) {
-		pr_err("Could not request wl12xx enable gpio: %d\n", ret);
-		goto exit;
-	}
-
-	ret = gpio_request_one(DA850_WLAN_IRQ, GPIOF_IN, "wl12xx_irq");
-	if (ret) {
-		pr_err("Could not request wl12xx irq gpio: %d\n", ret);
-		goto free_wlan_en;
-	}
-
-	da850_wl12xx_wlan_data.irq = gpio_to_irq(DA850_WLAN_IRQ);
-
-	ret = wl12xx_set_platform_data(&da850_wl12xx_wlan_data);
-	if (ret) {
-		pr_err("Could not set wl12xx data: %d\n", ret);
-		goto free_wlan_irq;
-	}
-
-	return 0;
-
-free_wlan_irq:
-	gpio_free(DA850_WLAN_IRQ);
-
-free_wlan_en:
-	gpio_free(DA850_WLAN_EN);
-
-exit:
-	return ret;
-}
-
-#else /* CONFIG_DA850_WL12XX */
-
-static __init int da850_wl12xx_init(void)
-{
-	return 0;
-}
-
-#endif /* CONFIG_DA850_WL12XX */
-
 #define DA850EVM_SATA_REFCLKPN_RATE	(100 * 1000 * 1000)
 
 static __init void da850_evm_init(void)
@@ -1503,11 +1395,6 @@ static __init void da850_evm_init(void)
 		if (ret)
 			pr_warn("%s: MMCSD0 registration failed: %d\n",
 				__func__, ret);
-
-		ret = da850_wl12xx_init();
-		if (ret)
-			pr_warn("%s: WL12xx initialization failed: %d\n",
-				__func__, ret);
 	}
 
 	davinci_serial_init(da8xx_serial_device);
diff --git a/drivers/net/wireless/ti/wilink_platform_data.c b/drivers/net/wireless/ti/wilink_platform_data.c
index a92bd3e..ea0e359 100644
--- a/drivers/net/wireless/ti/wilink_platform_data.c
+++ b/drivers/net/wireless/ti/wilink_platform_data.c
@@ -23,31 +23,6 @@
 #include <linux/err.h>
 #include <linux/wl12xx.h>
 
-static struct wl12xx_platform_data *wl12xx_platform_data;
-
-int __init wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
-{
-	if (wl12xx_platform_data)
-		return -EBUSY;
-	if (!data)
-		return -EINVAL;
-
-	wl12xx_platform_data = kmemdup(data, sizeof(*data), GFP_KERNEL);
-	if (!wl12xx_platform_data)
-		return -ENOMEM;
-
-	return 0;
-}
-
-struct wl12xx_platform_data *wl12xx_get_platform_data(void)
-{
-	if (!wl12xx_platform_data)
-		return ERR_PTR(-ENODEV);
-
-	return wl12xx_platform_data;
-}
-EXPORT_SYMBOL(wl12xx_get_platform_data);
-
 static struct wl1251_platform_data *wl1251_platform_data;
 
 int __init wl1251_set_platform_data(const struct wl1251_platform_data *data)
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index b3f751f..af0fe2e 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -24,8 +24,6 @@
 
 #include <linux/err.h>
 
-#include <linux/wl12xx.h>
-
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
 #include "../wlcore/io.h"
@@ -1808,7 +1806,6 @@ static int wl12xx_setup(struct wl1271 *wl)
 {
 	struct wl12xx_priv *priv = wl->priv;
 	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&wl->pdev->dev);
-	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 
 	BUILD_BUG_ON(WL12XX_MAX_LINKS > WLCORE_MAX_LINKS);
 	BUILD_BUG_ON(WL12XX_MAX_AP_STATIONS > WL12XX_MAX_LINKS);
@@ -1834,12 +1831,12 @@ static int wl12xx_setup(struct wl1271 *wl)
 
 	if (!fref_param) {
 		priv->ref_clock = wl12xx_get_clock_idx(wl12xx_refclock_table,
-						       pdata->ref_clock_freq,
-						       pdata->ref_clock_xtal);
+						pdev_data->ref_clock_freq,
+						pdev_data->ref_clock_xtal);
 		if (priv->ref_clock < 0) {
 			wl1271_error("Invalid ref_clock frequency (%d Hz, %s)",
-				     pdata->ref_clock_freq,
-				     pdata->ref_clock_xtal ?
+				     pdev_data->ref_clock_freq,
+				     pdev_data->ref_clock_xtal ?
 				     "XTAL" : "not XTAL");
 
 			return priv->ref_clock;
@@ -1861,13 +1858,13 @@ static int wl12xx_setup(struct wl1271 *wl)
 			wl1271_error("Invalid fref parameter %s", fref_param);
 	}
 
-	if (!tcxo_param && pdata->tcxo_clock_freq) {
+	if (!tcxo_param && pdev_data->tcxo_clock_freq) {
 		priv->tcxo_clock = wl12xx_get_clock_idx(wl12xx_tcxoclock_table,
-							pdata->tcxo_clock_freq,
-							true);
+						pdev_data->tcxo_clock_freq,
+						true);
 		if (priv->tcxo_clock < 0) {
 			wl1271_error("Invalid tcxo_clock frequency (%d Hz)",
-				     pdata->tcxo_clock_freq);
+				     pdev_data->tcxo_clock_freq);
 
 			return priv->tcxo_clock;
 		}
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 77752b0..19b7ec7 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/wl12xx.h>
 #include <linux/export.h>
 
 #include "debug.h"
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 67518f6..0be8079 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -25,7 +25,6 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
-#include <linux/wl12xx.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 
@@ -6390,7 +6389,6 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	struct wl1271 *wl = context;
 	struct platform_device *pdev = wl->pdev;
 	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&pdev->dev);
-	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 	struct resource *res;
 
 	int ret;
@@ -6446,7 +6444,7 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	if (!ret) {
 		wl->irq_wake_enabled = true;
 		device_init_wakeup(wl->dev, 1);
-		if (pdata->pwr_in_suspend)
+		if (pdev_data->pwr_in_suspend)
 			wl->hw->wiphy->wowlan = &wlcore_wowlan_support;
 	}
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index b55dc0e..ea7e07a 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -31,7 +31,6 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 #include <linux/gpio.h>
-#include <linux/wl12xx.h>
 #include <linux/pm_runtime.h>
 #include <linux/printk.h>
 #include <linux/of.h>
@@ -231,67 +230,37 @@ static const struct of_device_id wlcore_sdio_of_match_table[] = {
 	{ }
 };
 
-static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
+static int wlcore_probe_of(struct device *dev, int *irq,
+			   struct wlcore_platdev_data *pdev_data)
 {
 	struct device_node *np = dev->of_node;
-	struct wl12xx_platform_data *pdata;
 
 	if (!np || !of_match_node(wlcore_sdio_of_match_table, np))
-		return NULL;
+		return -ENODATA;
 
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return NULL;
-
-	pdata->irq = irq_of_parse_and_map(np, 0);
-	if (!pdata->irq) {
+	*irq = irq_of_parse_and_map(np, 0);
+	if (!*irq) {
 		dev_err(dev, "No irq in platform data\n");
-		kfree(pdata);
-		return NULL;
+		kfree(pdev_data);
+		return -EINVAL;
 	}
 
-	pdata->irq_trigger =
-		irqd_get_trigger_type(irq_get_irq_data(pdata->irq));
-
 	/* optional clock frequency params */
 	of_property_read_u32(np, "ref-clock-frequency",
-			     &pdata->ref_clock_freq);
+			     &pdev_data->ref_clock_freq);
 	of_property_read_u32(np, "tcxo-clock-frequency",
-			     &pdata->tcxo_clock_freq);
+			     &pdev_data->tcxo_clock_freq);
 
-	return pdata;
+	return 0;
 }
 #else
-static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
+static int wlcore_probe_of(struct device *dev, int *irq,
+			   struct wlcore_platdev_data *pdev_data)
 {
-	return NULL;
+	return -ENODATA;
 }
 #endif
 
-static struct wl12xx_platform_data *
-wlcore_get_platform_data(struct device *dev)
-{
-	struct wl12xx_platform_data *pdata;
-
-	/* first, look for DT data */
-	pdata = wlcore_probe_of(dev);
-	if (pdata)
-		return pdata;
-
-	/* if not found - fallback to static platform data */
-	pdata = wl12xx_get_platform_data();
-	if (!IS_ERR(pdata))
-		return kmemdup(pdata, sizeof(*pdata), GFP_KERNEL);
-
-	dev_err(dev, "No platform data set\n");
-	return NULL;
-}
-
-static void wlcore_del_platform_data(struct wl12xx_platform_data *pdata)
-{
-	kfree(pdata);
-}
-
 static int wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
@@ -300,6 +269,7 @@ static int wl1271_probe(struct sdio_func *func,
 	struct resource res[1];
 	mmc_pm_flag_t mmcflags;
 	int ret = -ENOMEM;
+	int irq;
 	const char *chip_family;
 
 	/* We are only able to handle the wlan function */
@@ -323,8 +293,7 @@ static int wl1271_probe(struct sdio_func *func,
 	/* Use block mode for transferring over one block size of data */
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
-	pdev_data.pdata = wlcore_get_platform_data(&func->dev);
-	if (!pdev_data.pdata)
+	if (wlcore_probe_of(&func->dev, &irq, &pdev_data))
 		goto out_free_glue;
 
 	/* if sdio can keep power while host is suspended, enable wow */
@@ -332,7 +301,7 @@ static int wl1271_probe(struct sdio_func *func,
 	dev_dbg(glue->dev, "sdio PM caps = 0x%x\n", mmcflags);
 
 	if (mmcflags & MMC_PM_KEEP_POWER)
-		pdev_data.pdata->pwr_in_suspend = true;
+		pdev_data.pwr_in_suspend = true;
 
 	sdio_set_drvdata(func, glue);
 
@@ -354,15 +323,16 @@ static int wl1271_probe(struct sdio_func *func,
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
-		goto out_free_pdata;
+		goto out_free_glue;
 	}
 
 	glue->core->dev.parent = &func->dev;
 
 	memset(res, 0x00, sizeof(res));
 
-	res[0].start = pdev_data.pdata->irq;
-	res[0].flags = IORESOURCE_IRQ | pdev_data.pdata->irq_trigger;
+	res[0].start = irq;
+	res[0].flags = IORESOURCE_IRQ |
+		       irqd_get_trigger_type(irq_get_irq_data(irq));
 	res[0].name = "irq";
 
 	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
@@ -388,9 +358,6 @@ static int wl1271_probe(struct sdio_func *func,
 out_dev_put:
 	platform_device_put(glue->core);
 
-out_free_pdata:
-	wlcore_del_platform_data(pdev_data.pdata);
-
 out_free_glue:
 	kfree(glue);
 
@@ -401,14 +368,11 @@ out:
 static void wl1271_remove(struct sdio_func *func)
 {
 	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
-	struct wlcore_platdev_data *pdev_data = glue->core->dev.platform_data;
-	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 
 	/* Undo decrement done above in wl1271_probe */
 	pm_runtime_get_noresume(&func->dev);
 
 	platform_device_unregister(glue->core);
-	wlcore_del_platform_data(pdata);
 	kfree(glue);
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 69601f6..f1ac283 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -331,11 +331,7 @@ static int wl1271_probe(struct spi_device *spi)
 
 	memset(&pdev_data, 0x00, sizeof(pdev_data));
 
-	pdev_data.pdata = dev_get_platdata(&spi->dev);
-	if (!pdev_data.pdata) {
-		dev_err(&spi->dev, "no platform data\n");
-		return -ENODEV;
-	}
+	/* TODO: add DT parsing when needed */
 
 	pdev_data.if_ops = &spi_ops;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 3396ce5..39efc6d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -201,8 +201,12 @@ struct wl1271_if_operations {
 };
 
 struct wlcore_platdev_data {
-	struct wl12xx_platform_data *pdata;
 	struct wl1271_if_operations *if_ops;
+
+	bool ref_clock_xtal;	/* specify whether the clock is XTAL or not */
+	u32 ref_clock_freq;	/* in Hertz */
+	u32 tcxo_clock_freq;	/* in Hertz, tcxo is always XTAL */
+	bool pwr_in_suspend;
 };
 
 #define MAX_NUM_KEYS 14
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index eea1e6d..95704cd 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -33,21 +33,8 @@ struct wl1251_platform_data {
 	bool use_eeprom;
 };
 
-struct wl12xx_platform_data {
-	int irq;
-	u32 irq_trigger;
-	bool ref_clock_xtal;	/* specify whether the clock is XTAL or not */
-	u32 ref_clock_freq;	/* in Hertz */
-	u32 tcxo_clock_freq;	/* in Hertz, tcxo is always XTAL */
-	bool pwr_in_suspend;
-};
-
 #ifdef CONFIG_WILINK_PLATFORM_DATA
 
-int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
-
-struct wl12xx_platform_data *wl12xx_get_platform_data(void);
-
 int wl1251_set_platform_data(const struct wl1251_platform_data *data);
 
 struct wl1251_platform_data *wl1251_get_platform_data(void);
@@ -55,18 +42,6 @@ struct wl1251_platform_data *wl1251_get_platform_data(void);
 #else
 
 static inline
-int wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
-{
-	return -ENOSYS;
-}
-
-static inline
-struct wl12xx_platform_data *wl12xx_get_platform_data(void)
-{
-	return ERR_PTR(-ENODATA);
-}
-
-static inline
 int wl1251_set_platform_data(const struct wl1251_platform_data *data)
 {
 	return -ENOSYS;
-- 
1.8.5.2.229.g4448466.dirty

