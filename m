Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33176 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbcJEJjp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 05:39:45 -0400
Received: by mail-pf0-f193.google.com with SMTP id i85so4864185pfa.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 02:39:45 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH] rsi: update in boot parameters
Date: Wed,  5 Oct 2016 15:05:48 +0530
Message-Id: <1475660148-14087-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161005_113950_828750_BEB7733F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added more clock switch fields in boot parameters configured to device

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c    | 110 ++++++++++++++++++++---------
 drivers/net/wireless/rsi/rsi_boot_params.h | 101 ++++++++++++++++++--------
 2 files changed, 149 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 35c14cc..046b354 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -18,6 +18,7 @@
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 
+/* Bootup Parameters for 20MHz */
 static struct bootup_params boot_params_20 = {
 	.magic_number = cpu_to_le16(0x5aa5),
 	.crystal_good_time = 0x0,
@@ -28,14 +29,15 @@ static struct bootup_params boot_params_20 = {
 	.rtls_timestamp_en = 0x0,
 	.host_spi_intr_cfg = 0x0,
 	.device_clk_info = {{
+		/* WLAN params */
 		.pll_config_g = {
 			.tapll_info_g = {
-				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
-					      (TA_PLL_M_VAL_20)),
-				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_20),
+				.pll_reg_1 = cpu_to_le16((TAPLL_N_VAL_20 << 8) |
+							 (TAPLL_M_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(TAPLL_P_VAL_20),
 			},
 			.pll960_info_g = {
-				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8)|
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8) |
 							 (PLL960_N_VAL_20)),
 				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_20),
 				.pll_reg_3 = 0x0,
@@ -45,21 +47,27 @@ static struct bootup_params boot_params_20 = {
 			}
 		},
 		.switch_clk_g = {
-			.switch_clk_info = cpu_to_le16(BIT(3)),
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x1,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
 			.bbp_lmac_clk_reg_val = cpu_to_le16(0x121),
 			.umac_clock_reg_config = 0x0,
 			.qspi_uart_clock_reg_config = 0x0
 		}
 	},
+	/* Bluetooth params */
 	{
 		.pll_config_g = {
 			.tapll_info_g = {
-				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
-							 (TA_PLL_M_VAL_20)),
-				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_20),
+				.pll_reg_1 = cpu_to_le16((TAPLL_N_VAL_20 << 8) |
+							 (TAPLL_M_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(TAPLL_P_VAL_20),
 			},
 			.pll960_info_g = {
-				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8)|
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8) |
 							 (PLL960_N_VAL_20)),
 				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_20),
 				.pll_reg_3 = 0x0,
@@ -69,21 +77,27 @@ static struct bootup_params boot_params_20 = {
 			}
 		},
 		.switch_clk_g = {
-			.switch_clk_info = 0x0,
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x0,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
 			.bbp_lmac_clk_reg_val = 0x0,
 			.umac_clock_reg_config = 0x0,
 			.qspi_uart_clock_reg_config = 0x0
 		}
 	},
+	/* Zigbee params */
 	{
 		.pll_config_g = {
 			.tapll_info_g = {
-				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
-							 (TA_PLL_M_VAL_20)),
-				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_20),
+				.pll_reg_1 = cpu_to_le16((TAPLL_N_VAL_20 << 8) |
+							 (TAPLL_M_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(TAPLL_P_VAL_20),
 			},
 			.pll960_info_g = {
-				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8)|
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8) |
 							 (PLL960_N_VAL_20)),
 				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_20),
 				.pll_reg_3 = 0x0,
@@ -93,12 +107,18 @@ static struct bootup_params boot_params_20 = {
 			}
 		},
 		.switch_clk_g = {
-			.switch_clk_info = 0x0,
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x0,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
 			.bbp_lmac_clk_reg_val = 0x0,
 			.umac_clock_reg_config = 0x0,
 			.qspi_uart_clock_reg_config = 0x0
 		}
 	} },
+	/* ULP Params */
 	.buckboost_wakeup_cnt = 0x0,
 	.pmu_wakeup_wait = 0x0,
 	.shutdown_wait_time = 0x0,
@@ -106,9 +126,13 @@ static struct bootup_params boot_params_20 = {
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
@@ -119,14 +143,15 @@ static struct bootup_params boot_params_40 = {
 	.rtls_timestamp_en = 0x0,
 	.host_spi_intr_cfg = 0x0,
 	.device_clk_info = {{
+		/* WLAN params */
 		.pll_config_g = {
 			.tapll_info_g = {
-				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_40 << 8)|
-							 (TA_PLL_M_VAL_40)),
-				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_40),
+				.pll_reg_1 = cpu_to_le16((TAPLL_N_VAL_40 << 8) |
+							 (TAPLL_M_VAL_40)),
+				.pll_reg_2 = cpu_to_le16(TAPLL_P_VAL_40),
 			},
 			.pll960_info_g = {
-				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_40 << 8)|
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_40 << 8) |
 							 (PLL960_N_VAL_40)),
 				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_40),
 				.pll_reg_3 = 0x0,
@@ -136,21 +161,27 @@ static struct bootup_params boot_params_40 = {
 			}
 		},
 		.switch_clk_g = {
-			.switch_clk_info = cpu_to_le16(0x09),
+			.switch_umac_clk = 0x1,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x1,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
 			.bbp_lmac_clk_reg_val = cpu_to_le16(0x1121),
 			.umac_clock_reg_config = cpu_to_le16(0x48),
 			.qspi_uart_clock_reg_config = 0x0
 		}
 	},
+	/* Bluetooth Params */
 	{
 		.pll_config_g = {
 			.tapll_info_g = {
-				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_40 << 8)|
-							 (TA_PLL_M_VAL_40)),
-				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_40),
+				.pll_reg_1 = cpu_to_le16((TAPLL_N_VAL_40 << 8) |
+							 (TAPLL_M_VAL_40)),
+				.pll_reg_2 = cpu_to_le16(TAPLL_P_VAL_40),
 			},
 			.pll960_info_g = {
-				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_40 << 8)|
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_40 << 8) |
 							 (PLL960_N_VAL_40)),
 				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_40),
 				.pll_reg_3 = 0x0,
@@ -160,21 +191,27 @@ static struct bootup_params boot_params_40 = {
 			}
 		},
 		.switch_clk_g = {
-			.switch_clk_info = 0x0,
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x0,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
 			.bbp_lmac_clk_reg_val = 0x0,
 			.umac_clock_reg_config = 0x0,
 			.qspi_uart_clock_reg_config = 0x0
 		}
 	},
+	/* Zigbee Params */
 	{
 		.pll_config_g = {
 			.tapll_info_g = {
-				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_40 << 8)|
-							 (TA_PLL_M_VAL_40)),
-				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_40),
+				.pll_reg_1 = cpu_to_le16((TAPLL_N_VAL_40 << 8) |
+							 (TAPLL_M_VAL_40)),
+				.pll_reg_2 = cpu_to_le16(TAPLL_P_VAL_40),
 			},
 			.pll960_info_g = {
-				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_40 << 8)|
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_40 << 8) |
 							 (PLL960_N_VAL_40)),
 				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_40),
 				.pll_reg_3 = 0x0,
@@ -184,12 +221,18 @@ static struct bootup_params boot_params_40 = {
 			}
 		},
 		.switch_clk_g = {
-			.switch_clk_info = 0x0,
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x0,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
 			.bbp_lmac_clk_reg_val = 0x0,
 			.umac_clock_reg_config = 0x0,
 			.qspi_uart_clock_reg_config = 0x0
 		}
 	} },
+	/* ULP Params */
 	.buckboost_wakeup_cnt = 0x0,
 	.pmu_wakeup_wait = 0x0,
 	.shutdown_wait_time = 0x0,
@@ -197,7 +240,10 @@ static struct bootup_params boot_params_40 = {
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
index 5e2721f..9f5d61d 100644
--- a/drivers/net/wireless/rsi/rsi_boot_params.h
+++ b/drivers/net/wireless/rsi/rsi_boot_params.h
@@ -17,71 +17,77 @@
 #ifndef __RSI_BOOTPARAMS_HEADER_H__
 #define __RSI_BOOTPARAMS_HEADER_H__
 
-#define CRYSTAL_GOOD_TIME                BIT(0)
-#define BOOTUP_MODE_INFO                 BIT(1)
-#define WIFI_TAPLL_CONFIGS               BIT(5)
-#define WIFI_PLL960_CONFIGS              BIT(6)
-#define WIFI_AFEPLL_CONFIGS              BIT(7)
-#define WIFI_SWITCH_CLK_CONFIGS          BIT(8)
+#define CRYSTAL_GOOD_TIME		BIT(0)
+#define BOOTUP_MODE_INFO                BIT(1)
+#define WIFI_TAPLL_CONFIGS              BIT(5)
+#define WIFI_PLL960_CONFIGS             BIT(6)
+#define WIFI_AFEPLL_CONFIGS             BIT(7)
+#define WIFI_SWITCH_CLK_CONFIGS         BIT(8)
 
-#define TA_PLL_M_VAL_20                  8
-#define TA_PLL_N_VAL_20                  1
-#define TA_PLL_P_VAL_20                  4
+#define TAPLL_M_VAL_20			8
+#define TAPLL_N_VAL_20			1
+#define TAPLL_P_VAL_20			4
 
-#define PLL960_M_VAL_20                  0x14
-#define PLL960_N_VAL_20                  0
-#define PLL960_P_VAL_20                  5
+#define PLL960_M_VAL_20                 0x14
+#define PLL960_N_VAL_20                 0
+#define PLL960_P_VAL_20                 5
 
-#define UMAC_CLK_40MHZ                   40
+#define UMAC_CLK_40MHZ                  40
 
-#define TA_PLL_M_VAL_40                  46
-#define TA_PLL_N_VAL_40                  3
-#define TA_PLL_P_VAL_40                  3
+#define TAPLL_M_VAL_40                  46
+#define TAPLL_N_VAL_40                  3
+#define TAPLL_P_VAL_40                  3
 
-#define PLL960_M_VAL_40                  0x14
-#define PLL960_N_VAL_40                  0
-#define PLL960_P_VAL_40                  5
+#define PLL960_M_VAL_40                 0x14
+#define PLL960_N_VAL_40                 0
+#define PLL960_P_VAL_40                 5
 
 #define UMAC_CLK_20BW \
-	(((TA_PLL_M_VAL_20 + 1) * 40) / \
-	 ((TA_PLL_N_VAL_20 + 1) * (TA_PLL_P_VAL_20 + 1)))
+	(((TAPLL_M_VAL_20 + 1) * 40) / \
+	 ((TAPLL_N_VAL_20 + 1) * (TAPLL_P_VAL_20 + 1)))
 #define VALID_20 \
 	(WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | WIFI_SWITCH_CLK_CONFIGS)
 #define UMAC_CLK_40BW   \
-	(((TA_PLL_M_VAL_40 + 1) * 40) / \
-	 ((TA_PLL_N_VAL_40 + 1) * (TA_PLL_P_VAL_40 + 1)))
+	(((TAPLL_M_VAL_40 + 1) * 40) / \
+	 ((TAPLL_N_VAL_40 + 1) * (TAPLL_P_VAL_40 + 1)))
 #define VALID_40 \
 	(WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | WIFI_SWITCH_CLK_CONFIGS | \
 	 WIFI_TAPLL_CONFIGS | CRYSTAL_GOOD_TIME | BOOTUP_MODE_INFO)
 
-/* structure to store configs related to TAPLL programming */
+/* TAPLL programming configurations */
 struct tapll_info {
 	__le16 pll_reg_1;
 	__le16 pll_reg_2;
 } __packed;
 
-/* structure to store configs related to PLL960 programming */
+/* PLL960 programming configurations */
 struct pll960_info {
 	__le16 pll_reg_1;
 	__le16 pll_reg_2;
 	__le16 pll_reg_3;
 } __packed;
 
-/* structure to store configs related to AFEPLL programming */
+/* AFEPLL programming configurations */
 struct afepll_info {
 	__le16 pll_reg;
 } __packed;
 
-/* structure to store configs related to pll configs */
+/* PLL configurations */
 struct pll_config {
 	struct tapll_info tapll_info_g;
 	struct pll960_info pll960_info_g;
 	struct afepll_info afepll_info_g;
 } __packed;
 
-/* structure to store configs related to UMAC clk programming */
+/* UMAC clk programming configurations */
 struct switch_clk {
-	__le16 switch_clk_info;
+	__le16 switch_umac_clk : 1; /* If set rest is valid */
+	__le16 switch_qspi_clk : 1; /* If set qspi clk will be changed */
+	__le16 switch_slp_clk_2_32 : 1;
+	__le16 switch_bbp_lmac_clk_reg : 1;
+	__le16 switch_mem_ctrl_cfg : 1;
+	__le16 reserved : 11;
+
 	/* If switch_bbp_lmac_clk_reg is set then this value will be programmed
 	 * into reg
 	 */
@@ -99,11 +105,43 @@ struct device_clk_info {
 
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
@@ -122,5 +160,8 @@ struct bootup_params {
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
