Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33648 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdFBOPz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 10:15:55 -0400
Received: by mail-pf0-f193.google.com with SMTP id f27so11918746pfe.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 07:15:54 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 5/6] rsi: configure new boot parameters to device
Date: Fri,  2 Jun 2017 19:43:04 +0530
Message-Id: <1496412785-8720-6-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170602_161558_648201_4DA88428)
In-Reply-To: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Boot parameters are changed in new firmware. Also three
new sdio sleep parameters are added for ultra low power
save.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c    | 20 +++++++++++++-------
 drivers/net/wireless/rsi/rsi_boot_params.h | 15 +++++++++------
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index fac87c0..b2950aa 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -45,10 +45,10 @@ static struct bootup_params boot_params_20 = {
 			}
 		},
 		.switch_clk_g = {
-			.switch_clk_info = cpu_to_le16(BIT(3)),
-			.bbp_lmac_clk_reg_val = cpu_to_le16(0x121),
-			.umac_clock_reg_config = 0x0,
-			.qspi_uart_clock_reg_config = 0x0
+			.switch_clk_info = cpu_to_le16(0xb),
+			.bbp_lmac_clk_reg_val = cpu_to_le16(0x111),
+			.umac_clock_reg_config = cpu_to_le16(0x48),
+			.qspi_uart_clock_reg_config = cpu_to_le16(0x1211)
 		}
 	},
 	{
@@ -106,7 +106,10 @@ static struct bootup_params boot_params_20 = {
 	.wdt_prog_value = 0x0,
 	.wdt_soc_rst_delay = 0x0,
 	.dcdc_operation_mode = 0x0,
-	.soc_reset_wait_cnt = 0x0
+	.soc_reset_wait_cnt = 0x0,
+	.waiting_time_at_fresh_sleep = 0x0,
+	.max_threshold_to_avoid_sleep = 0x0,
+	.beacon_resedue_alg_en = 0,
 };
 
 static struct bootup_params boot_params_40 = {
@@ -139,7 +142,7 @@ static struct bootup_params boot_params_40 = {
 			.switch_clk_info = cpu_to_le16(0x09),
 			.bbp_lmac_clk_reg_val = cpu_to_le16(0x1121),
 			.umac_clock_reg_config = cpu_to_le16(0x48),
-			.qspi_uart_clock_reg_config = 0x0
+			.qspi_uart_clock_reg_config = cpu_to_le16(0x1211)
 		}
 	},
 	{
@@ -197,7 +200,10 @@ static struct bootup_params boot_params_40 = {
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
index 5e2721f..238ee96 100644
--- a/drivers/net/wireless/rsi/rsi_boot_params.h
+++ b/drivers/net/wireless/rsi/rsi_boot_params.h
@@ -24,19 +24,19 @@
 #define WIFI_AFEPLL_CONFIGS              BIT(7)
 #define WIFI_SWITCH_CLK_CONFIGS          BIT(8)
 
-#define TA_PLL_M_VAL_20                  8
-#define TA_PLL_N_VAL_20                  1
+#define TA_PLL_M_VAL_20                  9
+#define TA_PLL_N_VAL_20                  0
 #define TA_PLL_P_VAL_20                  4
 
 #define PLL960_M_VAL_20                  0x14
 #define PLL960_N_VAL_20                  0
 #define PLL960_P_VAL_20                  5
 
-#define UMAC_CLK_40MHZ                   40
+#define UMAC_CLK_40MHZ                   80
 
-#define TA_PLL_M_VAL_40                  46
-#define TA_PLL_N_VAL_40                  3
-#define TA_PLL_P_VAL_40                  3
+#define TA_PLL_M_VAL_40                  9
+#define TA_PLL_N_VAL_40                  0
+#define TA_PLL_P_VAL_40                  4
 
 #define PLL960_M_VAL_40                  0x14
 #define PLL960_N_VAL_40                  0
@@ -122,5 +122,8 @@ struct bootup_params {
 	/* dcdc modes configs */
 	__le32 dcdc_operation_mode;
 	__le32 soc_reset_wait_cnt;
+	__le32 waiting_time_at_fresh_sleep;
+	__le32 max_threshold_to_avoid_sleep;
+	u8 beacon_resedue_alg_en;
 } __packed;
 #endif
-- 
2.7.4
