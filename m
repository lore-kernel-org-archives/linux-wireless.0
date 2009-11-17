Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60658 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZKQQF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:05:58 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v2] rx51: add wl1251 wlan driver support
To: linux-omap@vger.kernel.org
Cc: aaro.koskinen@nokia.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:05:50 +0200
Message-ID: <20091117160549.19011.79696.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

wl1251 is connected to the SPI bus in rx51, add support for this.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 arch/arm/mach-omap2/board-rx51-peripherals.c |   85 ++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index e34d96a..2417193 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -14,6 +14,7 @@
 #include <linux/input.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/spi/spi.h>
+#include <linux/spi/wl12xx.h>
 #include <linux/i2c.h>
 #include <linux/i2c/twl4030.h>
 #include <linux/clk.h>
@@ -36,6 +37,37 @@
 #define SYSTEM_REV_B_USES_VAUX3	0x1699
 #define SYSTEM_REV_S_USES_VAUX3 0x8
 
+#define RX51_WL1251_POWER_GPIO		87
+#define RX51_WL1251_IRQ_GPIO		42
+
+static void rx51_wl1251_set_power(bool enable);
+
+static struct wl12xx_platform_data wl1251_pdata = {
+	.set_power = rx51_wl1251_set_power,
+};
+
+static struct omap2_mcspi_device_config wl1251_mcspi_config = {
+	.turbo_mode	= 0,
+	.single_channel	= 1,
+};
+
+/* list all spi devices here */
+enum {
+	RX51_SPI_WL1251,
+};
+
+static struct spi_board_info rx51_peripherals_spi_board_info[] __initdata = {
+	[RX51_SPI_WL1251] = {
+		.modalias		= "wl1251",
+		.bus_num		= 4,
+		.chip_select		= 0,
+		.max_speed_hz   	= 48000000,
+		.mode                   = SPI_MODE_2,
+		.controller_data	= &wl1251_mcspi_config,
+		.platform_data		= &wl1251_pdata,
+	},
+};
+
 static int board_keymap[] = {
 	KEY(0, 0, KEY_Q),
 	KEY(0, 1, KEY_O),
@@ -257,6 +289,55 @@ static struct regulator_init_data rx51_vdac = {
 	},
 };
 
+static void rx51_wl1251_set_power(bool enable)
+{
+	gpio_set_value(RX51_WL1251_POWER_GPIO, enable);
+}
+
+static void __init rx51_init_wl1251(void)
+{
+	int irq, ret;
+
+	ret = gpio_request(RX51_WL1251_POWER_GPIO, "wl1251 power");
+	if (ret < 0)
+		goto error;
+
+	ret = gpio_direction_output(RX51_WL1251_POWER_GPIO, 0);
+	if (ret < 0)
+		goto err_power;
+
+	ret = gpio_request(RX51_WL1251_IRQ_GPIO, "wl1251 irq");
+	if (ret < 0)
+		goto err_power;
+
+	ret = gpio_direction_input(RX51_WL1251_IRQ_GPIO);
+	if (ret < 0)
+		goto err_irq;
+
+	irq = gpio_to_irq(RX51_WL1251_IRQ_GPIO);
+	if (irq < 0)
+		goto err_irq;
+
+	rx51_peripherals_spi_board_info[RX51_SPI_WL1251].irq = irq;
+
+	return;
+
+err_irq:
+	gpio_free(RX51_WL1251_IRQ_GPIO);
+
+err_power:
+	gpio_free(RX51_WL1251_POWER_GPIO);
+
+error:
+	printk(KERN_ERR "wl1251 board initialisation failed\n");
+	wl1251_pdata.set_power = NULL;
+
+	/*
+	 * Now rx51_peripherals_spi_board_info[1].irq is zero and
+	 * set_power is null, and wl1251_probe() will fail.
+	 */
+}
+
 static int rx51_twlgpio_setup(struct device *dev, unsigned gpio, unsigned n)
 {
 	/* FIXME this gpio setup is just a placeholder for now */
@@ -538,6 +619,10 @@ static inline void board_smc91x_init(void)
 
 void __init rx51_peripherals_init(void)
 {
+	rx51_init_wl1251();
+
+	spi_register_board_info(rx51_peripherals_spi_board_info,
+				ARRAY_SIZE(rx51_peripherals_spi_board_info));
 	rx51_i2c_init();
 	board_onenand_init();
 	board_smc91x_init();

