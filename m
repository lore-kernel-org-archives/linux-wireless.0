Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62637 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0KCWOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 18:14:01 -0400
Received: by ewy7 with SMTP id 7so683241ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 15:14:00 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 3/3] wl1251: use wl12xx_platform_data to pass data
Date: Thu,  4 Nov 2010 00:13:49 +0200
Message-Id: <1288822429-24541-4-git-send-email-notasas@gmail.com>
In-Reply-To: <1288822429-24541-1-git-send-email-notasas@gmail.com>
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use the newly added method to pass platform data for wl1251 too.
This allows to eliminate some redundant code.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
This touches arch/arm/mach-omap2/* but I think it should go through
the wireless tree to avoid cross-tree dependencies, if Tony and others
are ok with this.

 arch/arm/mach-omap2/board-omap3pandora.c |   32 +++++++-------------------
 drivers/net/wireless/wl1251/sdio.c       |   35 +----------------------------
 drivers/net/wireless/wl12xx/Kconfig      |    2 +-
 3 files changed, 12 insertions(+), 57 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 89ed1be..8be2615 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -642,31 +642,13 @@ static void __init omap3pandora_init_irq(void)
 	omap_gpio_init();
 }
 
-static void pandora_wl1251_set_power(bool enable)
-{
-	/*
-	 * Keep power always on until wl1251_sdio driver learns to re-init
-	 * the chip after powering it down and back up.
-	 */
-}
-
-static struct wl12xx_platform_data pandora_wl1251_pdata = {
-	.set_power	= pandora_wl1251_set_power,
-	.use_eeprom	= true,
-};
-
-static struct platform_device pandora_wl1251_data = {
-	.name           = "wl1251_data",
-	.id             = -1,
-	.dev		= {
-		.platform_data	= &pandora_wl1251_pdata,
-	},
-};
-
-static void pandora_wl1251_init(void)
+static void __init pandora_wl1251_init(void)
 {
+	struct wl12xx_platform_data pandora_wl1251_pdata;
 	int ret;
 
+	memset(&pandora_wl1251_pdata, 0, sizeof(pandora_wl1251_pdata));
+
 	ret = gpio_request(PANDORA_WIFI_IRQ_GPIO, "wl1251 irq");
 	if (ret < 0)
 		goto fail;
@@ -679,6 +661,11 @@ static void pandora_wl1251_init(void)
 	if (pandora_wl1251_pdata.irq < 0)
 		goto fail_irq;
 
+	pandora_wl1251_pdata.use_eeprom = true;
+	ret = wl12xx_set_platform_data(&pandora_wl1251_pdata);
+	if (ret < 0)
+		goto fail_irq;
+
 	return;
 
 fail_irq:
@@ -691,7 +678,6 @@ static struct platform_device *omap3pandora_devices[] __initdata = {
 	&pandora_leds_gpio,
 	&pandora_keys_gpio,
 	&pandora_dss_device,
-	&pandora_wl1251_data,
 	&pandora_vwlan_device,
 };
 
diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl1251/sdio.c
index 0a5db21..c27cc8c 100644
--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -43,8 +43,6 @@ struct wl1251_sdio {
 	u32 elp_val;
 };
 
-static struct wl12xx_platform_data *wl12xx_board_data;
-
 static struct sdio_func *wl_to_func(struct wl1251 *wl)
 {
 	struct wl1251_sdio *wl_sdio = wl->if_priv;
@@ -215,30 +213,6 @@ static struct wl1251_if_operations wl1251_sdio_ops = {
 	.power = wl1251_sdio_set_power,
 };
 
-static int wl1251_platform_probe(struct platform_device *pdev)
-{
-	if (pdev->id != -1) {
-		wl1251_error("can only handle single device");
-		return -ENODEV;
-	}
-
-	wl12xx_board_data = pdev->dev.platform_data;
-	return 0;
-}
-
-/*
- * Dummy platform_driver for passing platform_data to this driver,
- * until we have a way to pass this through SDIO subsystem or
- * some other way.
- */
-static struct platform_driver wl1251_platform_driver = {
-	.driver = {
-		.name	= "wl1251_data",
-		.owner	= THIS_MODULE,
-	},
-	.probe	= wl1251_platform_probe,
-};
-
 static int wl1251_sdio_probe(struct sdio_func *func,
 			     const struct sdio_device_id *id)
 {
@@ -246,6 +220,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	struct wl1251 *wl;
 	struct ieee80211_hw *hw;
 	struct wl1251_sdio *wl_sdio;
+	const struct wl12xx_platform_data *wl12xx_board_data;
 
 	hw = wl1251_alloc_hw();
 	if (IS_ERR(hw))
@@ -272,6 +247,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	wl->if_priv = wl_sdio;
 	wl->if_ops = &wl1251_sdio_ops;
 
+	wl12xx_board_data = wl12xx_get_platform_data();
 	if (wl12xx_board_data != NULL) {
 		wl->set_power = wl12xx_board_data->set_power;
 		wl->irq = wl12xx_board_data->irq;
@@ -376,12 +352,6 @@ static int __init wl1251_sdio_init(void)
 {
 	int err;
 
-	err = platform_driver_register(&wl1251_platform_driver);
-	if (err) {
-		wl1251_error("failed to register platform driver: %d", err);
-		return err;
-	}
-
 	err = sdio_register_driver(&wl1251_sdio_driver);
 	if (err)
 		wl1251_error("failed to register sdio driver: %d", err);
@@ -391,7 +361,6 @@ static int __init wl1251_sdio_init(void)
 static void __exit wl1251_sdio_exit(void)
 {
 	sdio_unregister_driver(&wl1251_sdio_driver);
-	platform_driver_unregister(&wl1251_platform_driver);
 	wl1251_notice("unloaded");
 }
 
diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index b447559..1f4d73f 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -42,5 +42,5 @@ config WL1271_SDIO
 
 config WL12XX_PLATFORM_DATA
 	bool
-	depends on WL1271_SDIO != n
+	depends on WL1271_SDIO != n || WL1251_SDIO != n
 	default y
-- 
1.6.3.3

