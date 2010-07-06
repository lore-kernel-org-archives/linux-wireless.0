Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab0GFAk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 20:40:57 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Ohad Ben-Cohen <ohadb@ti.com>
Subject: [PATCH 13/15] wireless: wl1271: make ref_clock configurable by board
Date: Tue,  6 Jul 2010 03:37:44 +0300
Message-Id: <1278376666-3509-14-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-1-git-send-email-ohad@wizery.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ohad Ben-Cohen <ohadb@ti.com>

The wl1271 device is using a reference clock that may change
between board to board.

Make the ref_clock parameter configurable by the board
files that set up the device, instead of having a hard coded
value in the driver source itself.

Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_boot.c |   13 +++++++++----
 drivers/net/wireless/wl12xx/wl1271_boot.h |    1 -
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    2 ++
 drivers/net/wireless/wl12xx/wl1271_spi.c  |    2 ++
 include/linux/wl12xx.h                    |    1 +
 6 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 2df57cc..cb3126d 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -362,6 +362,7 @@ struct wl1271 {
 	void (*set_embedded_data)(void *priv);
 
 	int irq;
+	int ref_clock;
 
 	spinlock_t wl_lock;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 1a36d8a..fa1b8b9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -455,17 +455,22 @@ int wl1271_boot(struct wl1271 *wl)
 {
 	int ret = 0;
 	u32 tmp, clk, pause;
+	int ref_clock = wl->ref_clock;
 
 	wl1271_boot_hw_version(wl);
 
-	if (REF_CLOCK == 0 || REF_CLOCK == 2 || REF_CLOCK == 4)
+	if (ref_clock == 0 || ref_clock == 2 || ref_clock == 4)
 		/* ref clk: 19.2/38.4/38.4-XTAL */
 		clk = 0x3;
-	else if (REF_CLOCK == 1 || REF_CLOCK == 3)
+	else if (ref_clock == 1 || ref_clock == 3)
 		/* ref clk: 26/52 */
 		clk = 0x5;
+	else {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (REF_CLOCK != 0) {
+	if (ref_clock != 0) {
 		u16 val;
 		/* Set clock type (open drain) */
 		val = wl1271_top_reg_read(wl, OCP_REG_CLK_TYPE);
@@ -514,7 +519,7 @@ int wl1271_boot(struct wl1271 *wl)
 	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
 
 	/* 2 */
-	clk |= (REF_CLOCK << 1) << 4;
+	clk |= (ref_clock << 1) << 4;
 	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.h b/drivers/net/wireless/wl12xx/wl1271_boot.h
index f829699..f73b0b1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.h
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.h
@@ -46,7 +46,6 @@ struct wl1271_static_data {
 /* delay between retries */
 #define INIT_LOOP_DELAY 50
 
-#define REF_CLOCK            2
 #define WU_COUNTER_PAUSE_VAL 0x3FF
 #define WELP_ARM_COMMAND_VAL 0x4
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 0af0dce..4ed097f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -270,6 +270,8 @@ static int wl1271_plat_probe(struct platform_device *pdev)
 	wl->if_plat_priv = pdev;
 	platform_set_drvdata(pdev, wl);
 
+	wl->ref_clock = pdata->board_ref_clock;
+
 	wl->set_embedded_data = pdata->set_embedded_data;
 	if (!wl->set_embedded_data) {
 		wl1271_error("set embedded_data func missing in platform data");
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 85a167f..2cb125b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -373,6 +373,8 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 		goto out_free;
 	}
 
+	wl->ref_clock = pdata->ref_clock;
+
 	wl->irq = spi->irq;
 	if (wl->irq < 0) {
 		wl1271_error("irq missing in platform data");
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 4106184..9053d9c 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -31,6 +31,7 @@ struct wl12xx_platform_data {
 	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
 	int irq;
 	bool use_eeprom;
+	int board_ref_clock;
 };
 
 #endif
-- 
1.7.0.4

