Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34747 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbcKNMTJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 07:19:09 -0500
Received: by mail-pg0-f66.google.com with SMTP id e9so8543333pgc.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 04:19:08 -0800 (PST)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 1/5] rsi: Device configuration bootup parameters updated
Date: Mon, 14 Nov 2016 17:45:50 +0530
Message-Id: <1479125750-2598-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161114_131913_562326_366705CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Switch clock info values are changed in the firmware for both 20MHZ
and 40MHZ modes. Hence these values which are configured through boot
parameters request frame are updated. Also three other power save
related parameters are added to boot up parameters.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c    | 30 +++++++++++++++++-------
 drivers/net/wireless/rsi/rsi_boot_params.h | 37 +++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 35c14cc..8db377b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -18,6 +18,7 @@
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 
+/* Bootup Parameters for 20MHz */
 static struct bootup_params boot_params_20 = {
 	.magic_number = cpu_to_le16(0x5aa5),
 	.crystal_good_time = 0x0,
@@ -28,6 +29,7 @@ static struct bootup_params boot_params_20 = {
 	.rtls_timestamp_en = 0x0,
 	.host_spi_intr_cfg = 0x0,
 	.device_clk_info = {{
+		/* WLAN params */
 		.pll_config_g = {
 			.tapll_info_g = {
 				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
@@ -45,12 +47,13 @@ static struct bootup_params boot_params_20 = {
 			}
 		},
 		.switch_clk_g = {
-			.switch_clk_info = cpu_to_le16(BIT(3)),
-			.bbp_lmac_clk_reg_val = cpu_to_le16(0x121),
-			.umac_clock_reg_config = 0x0,
-			.qspi_uart_clock_reg_config = 0x0
+			.switch_clk_info = cpu_to_le16(0xB),
+			.bbp_lmac_clk_reg_val = cpu_to_le16(0x111),
+			.umac_clock_reg_config = cpu_to_le16(0x48),
+			.qspi_uart_clock_reg_config = cpu_to_le16(0x1211)
 		}
 	},
+	/* Bluetooth params */
 	{
 		.pll_config_g = {
 			.tapll_info_g = {
@@ -75,6 +78,7 @@ static struct bootup_params boot_params_20 = {
 			.qspi_uart_clock_reg_config = 0x0
 		}
 	},
+	/* Zigbee params */
 	{
 		.pll_config_g = {
 			.tapll_info_g = {
@@ -99,6 +103,7 @@ static struct bootup_params boot_params_20 = {
 			.qspi_uart_clock_reg_config = 0x0
 		}
 	} },
+	/* ULP Params */
 	.buckboost_wakeup_cnt = 0x0,
 	.pmu_wakeup_wait = 0x0,
 	.shutdown_wait_time = 0x0,
@@ -106,9 +111,13 @@ static struct bootup_params boot_params_20 = {
 	.wdt_prog_value = 0x0,
 	.wdt_soc_rst_delay = 0x0,
 	.dcdc_operation_mode = 0x0,
-	.soc_reset_wait_cnt = 0x0
+	.soc_reset_wait_cnt = 0x0,
+	.waiting_time_at_fresh_sleep = 0x0,
+	.max_threshold_to_avoid_sleep = 0x0,
+	.beacon_resedue_alg_en = 0,
 };
 
+/* Bootup parameters for 40MHz */
 static struct bootup_params boot_params_40 = {
 	.magic_number = cpu_to_le16(0x5aa5),
 	.crystal_good_time = 0x0,
@@ -136,12 +145,13 @@ static struct bootup_params boot_params_40 = {
 			}
 		},
 		.switch_clk_g = {
-			.switch_clk_info = cpu_to_le16(0x09),
+			.switch_clk_info = cpu_to_le16(0xB),
 			.bbp_lmac_clk_reg_val = cpu_to_le16(0x1121),
 			.umac_clock_reg_config = cpu_to_le16(0x48),
-			.qspi_uart_clock_reg_config = 0x0
+			.qspi_uart_clock_reg_config = cpu_to_le16(0x1211) 
 		}
 	},
+	/* Bluetooth Params */
 	{
 		.pll_config_g = {
 			.tapll_info_g = {
@@ -190,6 +200,7 @@ static struct bootup_params boot_params_40 = {
 			.qspi_uart_clock_reg_config = 0x0
 		}
 	} },
+	/* ULP Params */
 	.buckboost_wakeup_cnt = 0x0,
 	.pmu_wakeup_wait = 0x0,
 	.shutdown_wait_time = 0x0,
@@ -197,7 +208,10 @@ static struct bootup_params boot_params_40 = {
 	.wdt_prog_value = 0x0,
 	.wdt_soc_rst_delay = 0x0,
 	.dcdc_operation_mode = 0x0,
-	.soc_reset_wait_cnt = 0x0
+	.soc_reset_wait_cnt = 0x0,
+	.waiting_time_at_fresh_sleep = 0x0,
+	.max_threshold_to_avoid_sleep = 0x0,
+	.beacon_resedue_alg_en = 0,
 };
 
 static u16 mcs[] = {13, 26, 39, 52, 78, 104, 117, 130};
diff --git a/drivers/net/wireless/rsi/rsi_boot_params.h b/drivers/net/wireless/rsi/rsi_boot_params.h
index 5e2721f..0d77aeb 100644
--- a/drivers/net/wireless/rsi/rsi_boot_params.h
+++ b/drivers/net/wireless/rsi/rsi_boot_params.h
@@ -99,11 +99,43 @@ struct device_clk_info {
 
 struct bootup_params {
 	__le16 magic_number;
+#define LOADED_TOKEN  0x5AA5   /* Bootup params are installed by host
+				* or OTP/FLASH (Bootloader)
+				*/
+#define ROM_TOKEN     0x55AA   /* Bootup params are taken from ROM
+				* itself in MCU mode.
+				*/
 	__le16 crystal_good_time;
 	__le32 valid;
+#define CRYSTAL_GOOD_TIME                BIT(0)
+#define BOOTUP_MODE_INFO                 BIT(1)
+#define DIGITAL_LOOP_BACK_PARAMS         BIT(2)
+#define RTLS_TIMESTAMP_EN                BIT(3)
+#define HOST_SPI_INTR_CFG                BIT(4)
+#define WIFI_TAPLL_CONFIGS               BIT(5)
+#define WIFI_PLL960_CONFIGS              BIT(6)
+#define WIFI_AFEPLL_CONFIGS              BIT(7)
+#define WIFI_SWITCH_CLK_CONFIGS          BIT(8)
+#define BT_TAPLL_CONFIGS                 BIT(9)
+#define BT_PLL960_CONFIGS                BIT(10)
+#define BT_AFEPLL_CONFIGS                BIT(11)
+#define BT_SWITCH_CLK_CONFIGS            BIT(12)
+#define ZB_TAPLL_CONFIGS                 BIT(13)
+#define ZB_PLL960_CONFIGS                BIT(14)
+#define ZB_AFEPLL_CONFIGS                BIT(15)
+#define ZB_SWITCH_CLK_CONFIGS            BIT(16)
+#define BUCKBOOST_WAIT_INFO              BIT(17)
+#define PMU_WAKEUP_SHUTDOWN_W            BIT(18)
+#define WDT_PROG_VALUES                  BIT(19)
+#define WDT_RESET_DELAY_VALUE            BIT(20)
+#define DCDC_OPERATION_MODE_VALID        BIT(21)
+#define PMU_SLP_CLKOUT_SEL               BIT(22)
+#define SOC_RESET_WAIT_CNT               BIT(23)
 	__le32 reserved_for_valids;
 	__le16 bootup_mode_info;
-	/* configuration used for digital loop back */
+#define BT_COEXIST                       BIT(0)
+#define BOOTUP_MODE                     (BIT(2) | BIT(1))
+#define CUR_DEV_MODE                    (bootup_params.bootup_mode_info >> 1)
 	__le16 digital_loop_back_params;
 	__le16 rtls_timestamp_en;
 	__le16 host_spi_intr_cfg;
@@ -122,5 +154,8 @@ struct bootup_params {
 	/* dcdc modes configs */
 	__le32 dcdc_operation_mode;
 	__le32 soc_reset_wait_cnt;
+	__le32 waiting_time_at_fresh_sleep;
+	__le32 max_threshold_to_avoid_sleep;
+	u8 beacon_resedue_alg_en;
 } __packed;
 #endif
-- 
2.4.11
