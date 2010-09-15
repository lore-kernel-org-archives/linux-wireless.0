Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58384 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0IOXbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 19:31:09 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-omap@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v6 5/7] wl1271: make ref_clock configurable by board
Date: Thu, 16 Sep 2010 01:31:51 +0200
Message-Id: <1284593511-30052-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl1271 device is using a reference clock that may change
between board to board.

Make the ref_clock parameter configurable by board settings
instead of having a hard coded value in the sources.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_boot.c |   11 +++++++----
 drivers/net/wireless/wl12xx/wl1271_boot.h |    1 -
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    1 +
 drivers/net/wireless/wl12xx/wl1271_spi.c  |    2 ++
 include/linux/wl12xx.h                    |    1 +
 6 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index faa5925..4134f44 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -330,6 +330,7 @@ struct wl1271 {
 
 	void (*set_power)(bool enable);
 	int irq;
+	int ref_clock;
 
 	spinlock_t wl_lock;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index f36430b..fc21db8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -457,17 +457,20 @@ int wl1271_boot(struct wl1271 *wl)
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
+	else
+		return -EINVAL;
 
-	if (REF_CLOCK != 0) {
+	if (ref_clock != 0) {
 		u16 val;
 		/* Set clock type (open drain) */
 		val = wl1271_top_reg_read(wl, OCP_REG_CLK_TYPE);
@@ -516,7 +519,7 @@ int wl1271_boot(struct wl1271 *wl)
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
index 987ecdc..f2f0466 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -234,6 +234,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	}
 
 	wl->irq = wlan_data->irq;
+	wl->ref_clock = wlan_data->board_ref_clock;
 
 	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index de56d8d..ced0a9e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -372,6 +372,8 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 		goto out_free;
 	}
 
+	wl->ref_clock = pdata->board_ref_clock;
+
 	wl->irq = spi->irq;
 	if (wl->irq < 0) {
 		wl1271_error("irq missing in platform data");
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index bd70563..95deae3 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -29,6 +29,7 @@ struct wl12xx_platform_data {
 	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
 	int irq;
 	bool use_eeprom;
+	int board_ref_clock;
 };
 
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
-- 
1.7.0.4

