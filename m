Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47015 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab1CFO2L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:11 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESAXi015812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:10 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 02/15] wl12xx: 1281/1283 support - Add Definitions
Date: Sun,  6 Mar 2011 16:32:07 +0200
Message-Id: <1299421940-26292-3-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Definitions to support wl128x:
  - New FW file name
  - Chip ID
  - New PLL Configuration Algorithm macros that will be used at wl128x
    boot stage
  - Rename NVS macro name: wl127x and wl128x are using the same NVS
    file name. However, the ini parameters between of them are
    different. The driver will validate the correct NVS size in
    wl1271_boot_upload_nvs().

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/boot.h      |   59 +++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/conf.h      |    4 ++-
 drivers/net/wireless/wl12xx/main.c      |    2 +-
 drivers/net/wireless/wl12xx/reg.h       |   15 +-------
 drivers/net/wireless/wl12xx/sdio.c      |    1 +
 drivers/net/wireless/wl12xx/sdio_test.c |    2 +-
 drivers/net/wireless/wl12xx/spi.c       |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h    |    8 ++++-
 8 files changed, 75 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index 17229b8..daaf0e7 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -74,4 +74,63 @@ struct wl1271_static_data {
 #define FREF_CLK_POLARITY_BITS 0xfffff8ff
 #define CLK_REQ_OUTN_SEL       0x700
 
+/* PLL configuration algorithm for wl128x */
+#define CLOCK_TCXO_19_2_M      0
+#define CLOCK_TCXO_26_M        1
+#define CLOCK_TCXO_38_4_M      2
+#define CLOCK_TCXO_52_M        3
+#define CLOCK_TCXO_16_368_M    4
+#define CLOCK_TCXO_32_736_M    5
+#define CLOCK_TCXO_16_8_M      6
+#define CLOCK_TCXO_33_6_M      7
+
+
+#define SYS_CLK_CFG_REG              0x2200
+/* Bit[0]   -  0-TCXO,  1-FREF */
+#define MCS_PLL_CLK_SEL_FREF         BIT(0)
+/* Bit[3:2] - 01-TCXO, 10-FREF */
+#define WL_CLK_REQ_TYPE_FREF         BIT(3)
+#define WL_CLK_REQ_TYPE_PG2          (BIT(3) | BIT(2))
+/* Bit[4]   -  0-TCXO,  1-FREF */
+#define PRCM_CM_EN_MUX_WLAN_FREF     BIT(4)
+
+
+#define TCXO_ILOAD_INT_REG           0x2264
+#define TCXO_CLK_DETECT_REG          0x2266
+
+#define TCXO_DET_FAILED              BIT(4)
+
+#define FREF_ILOAD_INT_REG           0x2084
+#define FREF_CLK_DETECT_REG          0x2086
+#define FREF_CLK_DETECT_FAIL         BIT(4)
+
+/* Use this reg for masking during driver access */
+#define WL_SPARE_REG                 0x2320
+#define WL_SPARE_VAL                 BIT(2)
+/* Bit[6:5:3] -  mask wl write SYS_CLK_CFG[8:5:2:4] */
+#define WL_SPARE_MASK_8526           (BIT(6) | BIT(5) | BIT(3))
+
+#define PLL_LOCK_COUNTERS_REG        0xD8C
+#define PLL_LOCK_COUNTERS_COEX       0x0F
+#define PLL_LOCK_COUNTERS_MCS        0xF0
+#define MCS_PLL_OVERRIDE_REG         0xD90
+#define MCS_PLL_CONFIG_REG           0xD92
+#define MCS_SEL_IN_FREQ_MASK         0x0070
+#define MCS_SEL_IN_FREQ_SHIFT        4
+#define MCS_PLL_CONFIG_REG_VAL       0x73
+
+#define MCS_PLL_M_REG                0xD94
+#define MCS_PLL_N_REG                0xD96
+#define MCS_PLL_M_REG_VAL            0xC8
+#define MCS_PLL_N_REG_VAL            0x07
+
+#define SDIO_IO_DS                   0xd14
+#define HCI_IO_DS_6MA                2
+
+#define HW_CONFIG_19_2_M             1
+#define HW_CONFIG_26_M               2
+#define HW_CONFIG_38_4_M             3
+#define HW_CONFIG_52_M               4
+/* end PLL configuration algorithm for wl128x */
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 856a8a2..a00f22c 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1004,7 +1004,9 @@ enum {
 	CONF_REF_CLK_19_2_E,
 	CONF_REF_CLK_26_E,
 	CONF_REF_CLK_38_4_E,
-	CONF_REF_CLK_52_E
+	CONF_REF_CLK_52_E,
+	CONF_REF_CLK_38_4_M_XTAL,
+	CONF_REF_CLK_26_M_XTAL,
 };
 
 enum single_dual_band_enum {
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8b3c8d1..b0c4935 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -838,7 +838,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, WL1271_NVS_NAME, wl1271_wl_to_dev(wl));
+	ret = request_firmware(&fw, WL12XX_NVS_NAME, wl1271_wl_to_dev(wl));
 
 	if (ret < 0) {
 		wl1271_error("could not get nvs file: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/reg.h b/drivers/net/wireless/wl12xx/reg.h
index 9909607..440a4ee 100644
--- a/drivers/net/wireless/wl12xx/reg.h
+++ b/drivers/net/wireless/wl12xx/reg.h
@@ -207,6 +207,8 @@
 
 #define CHIP_ID_1271_PG10              (0x4030101)
 #define CHIP_ID_1271_PG20              (0x4030111)
+#define CHIP_ID_1283_PG10              (0x05030101)
+#define CHIP_ID_1283_PG20              (0x05030111)
 
 #define ENABLE                         (REGISTERS_BASE + 0x5450)
 
@@ -452,24 +454,11 @@
 #define HI_CFG_UART_TX_OUT_GPIO_14  0x00000200
 #define HI_CFG_UART_TX_OUT_GPIO_7   0x00000400
 
-/*
- * NOTE: USE_ACTIVE_HIGH compilation flag should be defined in makefile
- *       for platforms using active high interrupt level
- */
-#ifdef USE_ACTIVE_HIGH
 #define HI_CFG_DEF_VAL              \
 	(HI_CFG_UART_ENABLE |        \
 	HI_CFG_RST232_ENABLE |      \
 	HI_CFG_CLOCK_REQ_SELECT |   \
 	HI_CFG_HOST_INT_ENABLE)
-#else
-#define HI_CFG_DEF_VAL              \
-	(HI_CFG_UART_ENABLE |        \
-	HI_CFG_RST232_ENABLE |      \
-	HI_CFG_CLOCK_REQ_SELECT |   \
-	HI_CFG_HOST_INT_ENABLE)
-
-#endif
 
 #define REF_FREQ_19_2                       0
 #define REF_FREQ_26_0                       1
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 5b9dbea..58d0208 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -343,4 +343,5 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
+MODULE_FIRMWARE(WL128X_FW_NAME);
 MODULE_FIRMWARE(WL1271_AP_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
index 9fcbd3d..01adf1b 100644
--- a/drivers/net/wireless/wl12xx/sdio_test.c
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -227,7 +227,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, WL1271_NVS_NAME, wl1271_wl_to_dev(wl));
+	ret = request_firmware(&fw, WL12XX_NVS_NAME, wl1271_wl_to_dev(wl));
 
 	if (ret < 0) {
 		wl1271_error("could not get nvs file: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 18cf017..2993715 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -490,5 +490,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL1271_FW_NAME);
+MODULE_FIRMWARE(WL128X_FW_NAME);
 MODULE_FIRMWARE(WL1271_AP_FW_NAME);
 MODULE_ALIAS("spi:wl1271");
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 86be83e..7adb856 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -131,9 +131,15 @@ extern u32 wl12xx_debug_level;
 
 
 #define WL1271_FW_NAME "ti-connectivity/wl1271-fw-2.bin"
+#define WL128X_FW_NAME "ti-connectivity/wl128x-fw.bin"
 #define WL1271_AP_FW_NAME "ti-connectivity/wl1271-fw-ap.bin"
 
-#define WL1271_NVS_NAME "ti-connectivity/wl1271-nvs.bin"
+/*
+ * wl127x and wl128x are using the same NVS file name. However, the ini
+ * parameters between of them are different.
+ * The driver validate the correct NVS size in wl1271_boot_upload_nvs().
+ */
+#define WL12XX_NVS_NAME "ti-connectivity/wl1271-nvs.bin"
 
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
 #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
-- 
1.7.0.4

