Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:34490 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752674AbeC3HTr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 03:19:47 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/17] rtlwifi: halmac: add GPIO pin/pinmux definitions
Date: Fri, 30 Mar 2018 15:19:07 +0800
Message-ID: <20180330071916.23360-9-pkshih@realtek.com> (sfid-20180330_091959_648829_97BAA4F6)
In-Reply-To: <20180330071916.23360-1-pkshih@realtek.com>
References: <20180330071916.23360-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

GPIO with pinmux can switch to many functions such as LED, UART, JTAG,
WoWLAN, etc.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../halmac_88xx/halmac_8822b/halmac_gpio_8822b.c   | 847 +++++++++++++++++++++
 .../halmac_88xx/halmac_8822b/halmac_gpio_8822b.h   |  34 +
 .../rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.c  | 415 ++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.h  |  55 ++
 .../realtek/rtlwifi/halmac/halmac_gpio_cmd.h       |  84 ++
 5 files changed, 1435 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_gpio_cmd.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.c
new file mode 100644
index 000000000000..3d43de98bb46
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.c
@@ -0,0 +1,847 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#include "halmac_gpio_8822b.h"
+#include "../halmac_gpio_88xx.h"
+
+/* GPIO0 definition */
+#define GPIO0_BT_GPIO0_8822B	\
+	{HALMAC_BT_GPIO, HALMAC_GPIO0, HALMAC_GPIO_IN_OUT, \
+	 0x66, BIT(2), BIT(2)}
+#define GPIO0_BT_ACT_8822B	\
+	{HALMAC_BT_PTA, HALMAC_GPIO0, HALMAC_GPIO_IN_OUT, \
+	 0x41, BIT(1), 0}
+#define GPIO0_WL_ACT_8822B	\
+	{HALMAC_WL_PTA, HALMAC_GPIO0, HALMAC_GPIO_IN_OUT, \
+	 0x41, BIT(2), BIT(2)}
+#define GPIO0_WLMAC_DBG_GPIO0_8822B	\
+	{HALMAC_WLMAC_DBG, HALMAC_GPIO0, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0)}
+#define GPIO0_WLPHY_DBG_GPIO0_8822B	\
+	{HALMAC_WLPHY_DBG, HALMAC_GPIO0, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(1)}
+#define GPIO0_BT_DBG_GPIO0_8822B	\
+	{HALMAC_BT_DBG, HALMAC_GPIO0, HALMAC_GPIO_OUT, \
+	0x40, BIT(1) | BIT(0), BIT(0) | BIT(1)}
+#define GPIO0_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO0, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO1 definition */
+#define GPIO1_BT_GPIO1_8822B	\
+	{HALMAC_BT_GPIO, HALMAC_GPIO1, HALMAC_GPIO_IN_OUT, \
+	 0x66, BIT(2), BIT(2)}
+#define GPIO1_BT_3DD_SYNC_A_8822B	\
+	{HALMAC_BT_3DDLS_A, HALMAC_GPIO1, HALMAC_GPIO_IN, \
+	 0x66, BIT(2), BIT(2)}
+#define GPIO1_WL_CK_8822B	\
+	{HALMAC_BT_PTA, HALMAC_GPIO1, HALMAC_GPIO_OUT, \
+	 0x41, BIT(1), 0}
+#define GPIO1_BT_CK_8822B	\
+	{HALMAC_WL_PTA, HALMAC_GPIO1, HALMAC_GPIO_OUT, \
+	 0x41, BIT(2), BIT(2)}
+#define GPIO1_WLMAC_DBG_GPIO1_8822B	\
+	{HALMAC_WLMAC_DBG, HALMAC_GPIO1, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0)}
+#define GPIO1_WLPHY_DBG_GPIO1_8822B	\
+	{HALMAC_WLPHY_DBG, HALMAC_GPIO1, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(1)}
+#define GPIO1_BT_DBG_GPIO1_8822B	\
+	{HALMAC_BT_DBG, HALMAC_GPIO1, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0) | BIT(1)}
+#define GPIO1_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO1, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO2 definition */
+#define GPIO2_BT_GPIO2_8822B	\
+	{HALMAC_BT_GPIO, HALMAC_GPIO2, HALMAC_GPIO_IN_OUT, \
+	 0x66, BIT(2), BIT(2)}
+#define GPIO2_WL_STATE_8822B	\
+	{HALMAC_BT_PTA, HALMAC_GPIO2, HALMAC_GPIO_OUT, \
+	 0x41, BIT(1), 0}
+#define GPIO2_BT_STATE_8822B	\
+	{HALMAC_WL_PTA, HALMAC_GPIO2, HALMAC_GPIO_OUT, \
+	 0x41, BIT(2), BIT(2)}
+#define GPIO2_WLMAC_DBG_GPIO2_8822B	\
+	{HALMAC_WLMAC_DBG, HALMAC_GPIO2, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0)}
+#define GPIO2_WLPHY_DBG_GPIO2_8822B	\
+	{HALMAC_WLPHY_DBG, HALMAC_GPIO2, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(1)}
+#define GPIO2_BT_DBG_GPIO2_8822B	\
+	{HALMAC_BT_DBG, HALMAC_GPIO2, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0) | BIT(1)}
+#define GPIO2_RFE_CTRL_5_8822B	\
+	{HALMAC_WLPHY_RFE_CTRL2GPIO, HALMAC_GPIO2, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(2), BIT(2)}
+#define GPIO2_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO2, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO3 definition */
+#define GPIO3_BT_GPIO3_8822B	\
+	{HALMAC_BT_GPIO, HALMAC_GPIO3, HALMAC_GPIO_IN_OUT, \
+	 0x66, BIT(2), BIT(2)}
+#define GPIO3_WL_PRI_8822B	\
+	{HALMAC_BT_PTA, HALMAC_GPIO3, HALMAC_GPIO_OUT, \
+	 0x41, BIT(1), 0}
+#define GPIO3_BT_PRI_8822B	\
+	{HALMAC_WL_PTA, HALMAC_GPIO3, HALMAC_GPIO_OUT, \
+	 0x41, BIT(2), BIT(2)}
+#define GPIO3_WLMAC_DBG_GPIO3_8822B	\
+	{HALMAC_WLMAC_DBG, HALMAC_GPIO3, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0)}
+#define GPIO3_WLPHY_DBG_GPIO3_8822B	\
+	{HALMAC_WLPHY_DBG, HALMAC_GPIO3, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(1)}
+#define GPIO3_BT_DBG_GPIO3_8822B	\
+	{HALMAC_BT_DBG, HALMAC_GPIO3, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0) | BIT(1)}
+#define GPIO3_RFE_CTRL_4_8822B	\
+	{HALMAC_WLPHY_RFE_CTRL2GPIO, HALMAC_GPIO3, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(2), BIT(2)}
+#define GPIO3_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO3, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO4 definition */
+#define GPIO4_BT_SPI_D0_8822B	\
+	{HALMAC_BT_SFLASH, HALMAC_GPIO4, HALMAC_GPIO_IN_OUT, \
+	 0x66, BIT(4), BIT(4)}
+#define GPIO4_WL_SPI_D0_8822B	\
+	{HALMAC_WL_SFLASH, HALMAC_GPIO4, HALMAC_GPIO_IN_OUT, \
+	 0x42, BIT(3), BIT(3)}
+#define GPIO4_SDIO_INT_8822B	\
+	{HALMAC_SDIO_INT, HALMAC_GPIO4, HALMAC_GPIO_OUT, \
+	 0x72, BIT(2), BIT(2)}
+#define GPIO4_JTAG_TRST_8822B	\
+	{HALMAC_JTAG, HALMAC_GPIO4, HALMAC_GPIO_IN, \
+	 0x67, BIT(0), BIT(0)}
+#define GPIO4_DBG_GNT_WL_8822B	\
+	{HALMAC_DBG_GNT_WL_BT, HALMAC_GPIO4, HALMAC_GPIO_OUT, \
+	 0x73, BIT(3), BIT(3)}
+#define GPIO4_WLMAC_DBG_GPIO4_8822B	\
+	{HALMAC_WLMAC_DBG, HALMAC_GPIO4, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0)}
+#define GPIO4_WLPHY_DBG_GPIO4_8822B	\
+	{HALMAC_WLPHY_DBG, HALMAC_GPIO4, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(1)}
+#define GPIO4_BT_DBG_GPIO4_8822B	\
+	{HALMAC_BT_DBG, HALMAC_GPIO4, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0) | BIT(1)}
+#define GPIO4_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO4, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO5 definition */
+#define GPIO5_BT_SPI_D1_8822B	\
+	{HALMAC_BT_SFLASH, HALMAC_GPIO5, HALMAC_GPIO_IN_OUT, \
+	 0x66, BIT(4), BIT(4)}
+#define GPIO5_WL_SPI_D1_8822B	\
+	{HALMAC_WL_SFLASH, HALMAC_GPIO5, HALMAC_GPIO_IN_OUT, \
+	 0x42, BIT(3), BIT(3)}
+#define GPIO5_JTAG_TDI_8822B	\
+	{HALMAC_JTAG, HALMAC_GPIO5, HALMAC_GPIO_IN, \
+	 0x67, BIT(0), BIT(0)}
+#define GPIO5_DBG_GNT_BT_8822B	\
+	{HALMAC_DBG_GNT_WL_BT, HALMAC_GPIO5, HALMAC_GPIO_OUT, \
+	 0x73, BIT(3), BIT(3)}
+#define GPIO5_WLMAC_DBG_GPIO5_8822B	\
+	{HALMAC_WLMAC_DBG, HALMAC_GPIO5, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0)}
+#define GPIO5_WLPHY_DBG_GPIO5_8822B	\
+	{HALMAC_WLPHY_DBG, HALMAC_GPIO5, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(1)}
+#define GPIO5_BT_DBG_GPIO5_8822B	\
+	{HALMAC_BT_DBG, HALMAC_GPIO5, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0) | BIT(1)}
+#define GPIO5_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO5, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO6 definition */
+#define GPIO6_BT_SPI_D2_8822B	\
+	{HALMAC_BT_SFLASH, HALMAC_GPIO6, HALMAC_GPIO_IN_OUT, \
+	 0x66, BIT(4), BIT(4)}
+#define GPIO6_WL_SPI_D2_8822B	\
+	{HALMAC_WL_SFLASH, HALMAC_GPIO6, HALMAC_GPIO_IN_OUT, \
+	 0x42, BIT(3), BIT(3)}
+#define GPIO6_EEDO_8822B	\
+	{HALMAC_EEPROM, HALMAC_GPIO6, HALMAC_GPIO_IN, \
+	 0x40, BIT(4), BIT(4)}
+#define GPIO6_JTAG_TDO_8822B	\
+	{HALMAC_JTAG, HALMAC_GPIO6, HALMAC_GPIO_OUT, \
+	 0x67, BIT(0), BIT(0)}
+#define GPIO6_BT_3DD_SYNC_B_8822B	\
+	{HALMAC_BT_3DDLS_B, HALMAC_GPIO6, HALMAC_GPIO_IN, \
+	 0x67, BIT(1), BIT(1)}
+#define GPIO6_BT_GPIO18_8822B	\
+	{HALMAC_BT_GPIO, HALMAC_GPIO6, HALMAC_GPIO_IN_OUT, \
+	 0x67, BIT(1), BIT(1)}
+#define GPIO6_SIN_8822B	\
+	{HALMAC_WL_UART, HALMAC_GPIO6, HALMAC_GPIO_IN, \
+	 0x41, BIT(0), BIT(0)}
+#define GPIO6_WLMAC_DBG_GPIO6_8822B	\
+	{HALMAC_WLMAC_DBG, HALMAC_GPIO6, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0)}
+#define GPIO6_WLPHY_DBG_GPIO6_8822B	\
+	{HALMAC_WLPHY_DBG, HALMAC_GPIO6, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(1)}
+#define GPIO6_BT_DBG_GPIO6_8822B	\
+	{HALMAC_BT_DBG, HALMAC_GPIO6, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0) | BIT(1)}
+#define GPIO6_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO6, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO7 definition */
+#define GPIO7_BT_SPI_D3_8822B	\
+	{HALMAC_BT_SFLASH, HALMAC_GPIO7, HALMAC_GPIO_IN_OUT, \
+	 0x66, BIT(4), BIT(4)}
+#define GPIO7_WL_SPI_D3_8822B	\
+	{HALMAC_WL_SFLASH, HALMAC_GPIO7, HALMAC_GPIO_IN_OUT, \
+	 0x42, BIT(3), BIT(3)}
+#define GPIO7_EEDI_8822B	\
+	{HALMAC_EEPROM, HALMAC_GPIO7, HALMAC_GPIO_OUT, \
+	 0x40, BIT(4), BIT(4)}
+#define GPIO7_JTAG_TMS_8822B	\
+	{HALMAC_JTAG, HALMAC_GPIO7, HALMAC_GPIO_IN, \
+	 0x67, BIT(0), BIT(0)}
+#define GPIO7_BT_GPIO16_8822B	\
+	{HALMAC_BT_GPIO, HALMAC_GPIO7, HALMAC_GPIO_IN_OUT, \
+	 0x67, BIT(2), BIT(2)}
+#define GPIO7_SOUT_8822B	\
+	{HALMAC_WL_UART, HALMAC_GPIO7, HALMAC_GPIO_OUT, \
+	 0x41, BIT(0), BIT(0)}
+#define GPIO7_WLMAC_DBG_GPIO7_8822B	\
+	{HALMAC_WLMAC_DBG, HALMAC_GPIO7, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0)}
+#define GPIO7_WLPHY_DBG_GPIO7_8822B	\
+	{HALMAC_WLPHY_DBG, HALMAC_GPIO7, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(1)}
+#define GPIO7_BT_DBG_GPIO7_8822B	\
+	{HALMAC_BT_DBG, HALMAC_GPIO7, HALMAC_GPIO_OUT, \
+	 0x40, BIT(1) | BIT(0), BIT(0) | BIT(1)}
+#define GPIO7_SW_IO_8822B \
+	{HALMAC_SW_IO, HALMAC_GPIO7, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO8 definition */
+#define GPIO8_WL_EXT_WOL_8822B	\
+	{HALMAC_WL_HW_EXTWOL, HALMAC_GPIO8, HALMAC_GPIO_IN, \
+	 0x4a, BIT(0) | BIT(1), BIT(0) | BIT(1)}
+#define GPIO8_WL_LED_8822B	\
+	{HALMAC_WL_LED, HALMAC_GPIO8, HALMAC_GPIO_OUT, \
+	 0x4e, BIT(5), BIT(5)}
+#define GPIO8_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO8, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO9 definition */
+#define GPIO9_DIS_WL_N_8822B	\
+	{HALMAC_WL_HWPDN, HALMAC_GPIO9, HALMAC_GPIO_IN, \
+	 0x68, BIT(3) | BIT(0), BIT(3) | BIT(0)}
+#define GPIO9_WL_EXT_WOL_8822B	\
+	{HALMAC_WL_HW_EXTWOL, HALMAC_GPIO9, HALMAC_GPIO_IN, \
+	 0x4a, BIT(0) | BIT(1), BIT(0)}
+#define GPIO9_USCTS0_8822B	\
+	{HALMAC_UART0, HALMAC_GPIO9, HALMAC_GPIO_IN, \
+	 0x66, BIT(6), BIT(6)}
+#define GPIO9_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO9, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO10 definition */
+#define GPIO10_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO10, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO11 definition */
+#define GPIO11_DIS_BT_N_8822B	\
+	{HALMAC_BT_HWPDN, HALMAC_GPIO11, HALMAC_GPIO_IN, \
+	 0x6a, BIT(0), BIT(0)}
+#define GPIO11_USOUT0_8822B	\
+	{HALMAC_UART0, HALMAC_GPIO11, HALMAC_GPIO_OUT, \
+	 0x66, BIT(6), BIT(6)}
+#define GPIO11_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO11, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO12 definition */
+#define GPIO12_USIN0_8822B	\
+	{HALMAC_UART0, HALMAC_GPIO12, HALMAC_GPIO_IN, \
+	 0x66, BIT(6), BIT(6)}
+#define GPIO12_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO12, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO13 definition */
+#define GPIO13_BT_WAKE_8822B	\
+	{HALMAC_GPIO13_14_WL_CTRL_EN, HALMAC_GPIO13, HALMAC_GPIO_IN, \
+	 0x4e, BIT(6), BIT(6)}
+#define GPIO13_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO13, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO14 definition */
+#define GPIO14_UART_WAKE_8822B	\
+	{HALMAC_GPIO13_14_WL_CTRL_EN, HALMAC_GPIO14, HALMAC_GPIO_OUT, \
+	 0x4e, BIT(6), BIT(6)}
+#define GPIO14_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO14, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+/* GPIO15 definition */
+#define GPIO15_EXT_XTAL_8822B	\
+	{HALMAC_EXT_XTAL, HALMAC_GPIO15, HALMAC_GPIO_OUT, \
+	 0x66, BIT(7), BIT(7)}
+#define GPIO15_SW_IO_8822B	\
+	{HALMAC_SW_IO, HALMAC_GPIO15, HALMAC_GPIO_IN_OUT, \
+	 0x40, BIT(1) | BIT(0), 0}
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO0_8822B[] = {
+	GPIO0_BT_GPIO0_8822B,
+	GPIO0_BT_ACT_8822B,
+	GPIO0_WL_ACT_8822B,
+	GPIO0_WLMAC_DBG_GPIO0_8822B,
+	GPIO0_WLPHY_DBG_GPIO0_8822B,
+	GPIO0_BT_DBG_GPIO0_8822B,
+	GPIO0_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO1_8822B[] = {
+	GPIO1_BT_GPIO1_8822B,
+	GPIO1_BT_3DD_SYNC_A_8822B,
+	GPIO1_WL_CK_8822B,
+	GPIO1_BT_CK_8822B,
+	GPIO1_WLMAC_DBG_GPIO1_8822B,
+	GPIO1_WLPHY_DBG_GPIO1_8822B,
+	GPIO1_BT_DBG_GPIO1_8822B,
+	GPIO1_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO2_8822B[] = {
+	GPIO2_BT_GPIO2_8822B,
+	GPIO2_WL_STATE_8822B,
+	GPIO2_BT_STATE_8822B,
+	GPIO2_WLMAC_DBG_GPIO2_8822B,
+	GPIO2_WLPHY_DBG_GPIO2_8822B,
+	GPIO2_BT_DBG_GPIO2_8822B,
+	GPIO2_RFE_CTRL_5_8822B,
+	GPIO2_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO3_8822B[] = {
+	GPIO3_BT_GPIO3_8822B,
+	GPIO3_WL_PRI_8822B,
+	GPIO3_BT_PRI_8822B,
+	GPIO3_WLMAC_DBG_GPIO3_8822B,
+	GPIO3_WLPHY_DBG_GPIO3_8822B,
+	GPIO3_BT_DBG_GPIO3_8822B,
+	GPIO3_RFE_CTRL_4_8822B,
+	GPIO3_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO4_8822B[] = {
+	GPIO4_BT_SPI_D0_8822B,
+	GPIO4_WL_SPI_D0_8822B,
+	GPIO4_SDIO_INT_8822B,
+	GPIO4_JTAG_TRST_8822B,
+	GPIO4_DBG_GNT_WL_8822B,
+	GPIO4_WLMAC_DBG_GPIO4_8822B,
+	GPIO4_WLPHY_DBG_GPIO4_8822B,
+	GPIO4_BT_DBG_GPIO4_8822B,
+	GPIO4_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO5_8822B[] = {
+	GPIO5_BT_SPI_D1_8822B,
+	GPIO5_WL_SPI_D1_8822B,
+	GPIO5_JTAG_TDI_8822B,
+	GPIO5_DBG_GNT_BT_8822B,
+	GPIO5_WLMAC_DBG_GPIO5_8822B,
+	GPIO5_WLPHY_DBG_GPIO5_8822B,
+	GPIO5_BT_DBG_GPIO5_8822B,
+	GPIO5_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO6_8822B[] = {
+	GPIO6_BT_SPI_D2_8822B,
+	GPIO6_WL_SPI_D2_8822B,
+	GPIO6_EEDO_8822B,
+	GPIO6_JTAG_TDO_8822B,
+	GPIO6_BT_3DD_SYNC_B_8822B,
+	GPIO6_BT_GPIO18_8822B,
+	GPIO6_SIN_8822B,
+	GPIO6_WLMAC_DBG_GPIO6_8822B,
+	GPIO6_WLPHY_DBG_GPIO6_8822B,
+	GPIO6_BT_DBG_GPIO6_8822B,
+	GPIO6_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO7_8822B[] = {
+	GPIO7_BT_SPI_D3_8822B,
+	GPIO7_WL_SPI_D3_8822B,
+	GPIO7_EEDI_8822B,
+	GPIO7_JTAG_TMS_8822B,
+	GPIO7_BT_GPIO16_8822B,
+	GPIO7_SOUT_8822B,
+	GPIO7_WLMAC_DBG_GPIO7_8822B,
+	GPIO7_WLPHY_DBG_GPIO7_8822B,
+	GPIO7_BT_DBG_GPIO7_8822B,
+	GPIO7_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO8_8822B[] = {
+	GPIO8_WL_EXT_WOL_8822B,
+	GPIO8_WL_LED_8822B,
+	GPIO8_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO9_8822B[] = {
+	GPIO9_DIS_WL_N_8822B,
+	GPIO9_WL_EXT_WOL_8822B,
+	GPIO9_USCTS0_8822B,
+	GPIO9_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO10_8822B[] = {
+	GPIO10_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO11_8822B[] = {
+	GPIO11_DIS_BT_N_8822B,
+	GPIO11_USOUT0_8822B,
+	GPIO11_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO12_8822B[] = {
+	GPIO12_USIN0_8822B,
+	GPIO12_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO13_8822B[] = {
+	GPIO13_BT_WAKE_8822B,
+	GPIO13_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO14_8822B[] = {
+	GPIO14_UART_WAKE_8822B,
+	GPIO14_SW_IO_8822B
+};
+
+static const struct halmac_gpio_pimux_list PINMUX_LIST_GPIO15_8822B[] = {
+	GPIO15_EXT_XTAL_8822B,
+	GPIO15_SW_IO_8822B
+};
+
+static enum halmac_ret_status
+get_pinmux_list_8822b(struct halmac_adapter *adapter,
+		      enum halmac_gpio_func gpio_func,
+		      const struct halmac_gpio_pimux_list **list,
+		      u32 *list_size, u32 *gpio_id);
+
+static enum halmac_ret_status
+chk_pinmux_valid_8822b(struct halmac_adapter *adapter,
+		       enum halmac_gpio_func gpio_func);
+
+/**
+ * pinmux_get_func_8822b() -get current gpio status
+ * @adapter : the adapter of halmac
+ * @gpio_func : gpio function
+ * @enable : function is enable(1) or disable(0)
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pinmux_get_func_8822b(struct halmac_adapter *adapter,
+		      enum halmac_gpio_func gpio_func, u8 *enable)
+{
+	u32 list_size;
+	u32 cur_func;
+	u32 gpio_id;
+	enum halmac_ret_status status;
+	const struct halmac_gpio_pimux_list *list = NULL;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	status = get_pinmux_list_8822b(adapter, gpio_func, &list, &list_size,
+				       &gpio_id);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	status = pinmux_parser_88xx(adapter, list, list_size, gpio_id,
+				    &cur_func);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	switch (gpio_func) {
+	case HALMAC_GPIO_FUNC_WL_LED:
+		*enable = (cur_func == HALMAC_WL_LED) ? 1 : 0;
+		break;
+	case HALMAC_GPIO_FUNC_SDIO_INT:
+		*enable = (cur_func == HALMAC_SDIO_INT) ? 1 : 0;
+		break;
+	case HALMAC_GPIO_FUNC_BT_HOST_WAKE1:
+	case HALMAC_GPIO_FUNC_BT_DEV_WAKE1:
+		*enable = (cur_func == HALMAC_GPIO13_14_WL_CTRL_EN) ? 1 : 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_0:
+	case HALMAC_GPIO_FUNC_SW_IO_1:
+	case HALMAC_GPIO_FUNC_SW_IO_2:
+	case HALMAC_GPIO_FUNC_SW_IO_3:
+	case HALMAC_GPIO_FUNC_SW_IO_4:
+	case HALMAC_GPIO_FUNC_SW_IO_5:
+	case HALMAC_GPIO_FUNC_SW_IO_6:
+	case HALMAC_GPIO_FUNC_SW_IO_7:
+	case HALMAC_GPIO_FUNC_SW_IO_8:
+	case HALMAC_GPIO_FUNC_SW_IO_9:
+	case HALMAC_GPIO_FUNC_SW_IO_10:
+	case HALMAC_GPIO_FUNC_SW_IO_11:
+	case HALMAC_GPIO_FUNC_SW_IO_12:
+	case HALMAC_GPIO_FUNC_SW_IO_13:
+	case HALMAC_GPIO_FUNC_SW_IO_14:
+	case HALMAC_GPIO_FUNC_SW_IO_15:
+		*enable = (cur_func == HALMAC_SW_IO) ? 1 : 0;
+		break;
+	default:
+		*enable = 0;
+		return HALMAC_RET_GET_PINMUX_ERR;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * pinmux_set_func_8822b() -set gpio function
+ * @adapter : the adapter of halmac
+ * @gpio_func : gpio function
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pinmux_set_func_8822b(struct halmac_adapter *adapter,
+		      enum halmac_gpio_func gpio_func)
+{
+	u32 list_size;
+	u32 gpio_id;
+	enum halmac_ret_status status;
+	const struct halmac_gpio_pimux_list *list = NULL;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "func name : %d\n", gpio_func);
+
+	status = chk_pinmux_valid_8822b(adapter, gpio_func);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	status = get_pinmux_list_8822b(adapter, gpio_func, &list, &list_size,
+				       &gpio_id);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	status = pinmux_switch_88xx(adapter, list, list_size, gpio_id,
+				    gpio_func);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	status = pinmux_record_88xx(adapter, gpio_func, 1);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * pinmux_free_func_8822b() -free locked gpio function
+ * @adapter : the adapter of halmac
+ * @gpio_func : gpio function
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pinmux_free_func_8822b(struct halmac_adapter *adapter,
+		       enum halmac_gpio_func gpio_func)
+{
+	struct halmac_pinmux_info *info = &adapter->pinmux_info;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	switch (gpio_func) {
+	case HALMAC_GPIO_FUNC_SW_IO_0:
+		info->sw_io_0 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_1:
+		info->sw_io_1 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_2:
+		info->sw_io_2 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_3:
+		info->sw_io_3 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_4:
+	case HALMAC_GPIO_FUNC_SDIO_INT:
+		info->sw_io_4 = 0;
+		info->sdio_int = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_5:
+		info->sw_io_5 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_6:
+		info->sw_io_6 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_7:
+		info->sw_io_7 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_8:
+	case HALMAC_GPIO_FUNC_WL_LED:
+		info->sw_io_8 = 0;
+		info->wl_led = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_9:
+		info->sw_io_9 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_10:
+		info->sw_io_10 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_11:
+		info->sw_io_11 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_12:
+		info->sw_io_12 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_13:
+	case HALMAC_GPIO_FUNC_BT_DEV_WAKE1:
+		info->bt_dev_wake = 0;
+		info->sw_io_13 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_14:
+	case HALMAC_GPIO_FUNC_BT_HOST_WAKE1:
+		info->bt_host_wake = 0;
+		info->sw_io_14 = 0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_15:
+		info->sw_io_15 = 0;
+		break;
+	default:
+		return HALMAC_RET_SWITCH_CASE_ERROR;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "func : %X\n",
+		 gpio_func);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+get_pinmux_list_8822b(struct halmac_adapter *adapter,
+		      enum halmac_gpio_func gpio_func,
+		      const struct halmac_gpio_pimux_list **list,
+		      u32 *list_size, u32 *gpio_id)
+{
+	switch (gpio_func) {
+	case HALMAC_GPIO_FUNC_SW_IO_0:
+		*list = PINMUX_LIST_GPIO0_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO0_8822B);
+		*gpio_id = HALMAC_GPIO0;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_1:
+		*list = PINMUX_LIST_GPIO1_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO1_8822B);
+		*gpio_id = HALMAC_GPIO1;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_2:
+		*list = PINMUX_LIST_GPIO2_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO2_8822B);
+		*gpio_id = HALMAC_GPIO2;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_3:
+		*list = PINMUX_LIST_GPIO3_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO3_8822B);
+		*gpio_id = HALMAC_GPIO3;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_4:
+	case HALMAC_GPIO_FUNC_SDIO_INT:
+		*list = PINMUX_LIST_GPIO4_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO4_8822B);
+		*gpio_id = HALMAC_GPIO4;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_5:
+		*list = PINMUX_LIST_GPIO5_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO5_8822B);
+		*gpio_id = HALMAC_GPIO5;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_6:
+		*list = PINMUX_LIST_GPIO6_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO6_8822B);
+		*gpio_id = HALMAC_GPIO6;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_7:
+		*list = PINMUX_LIST_GPIO7_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO7_8822B);
+		*gpio_id = HALMAC_GPIO7;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_8:
+	case HALMAC_GPIO_FUNC_WL_LED:
+		*list = PINMUX_LIST_GPIO8_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO8_8822B);
+		*gpio_id = HALMAC_GPIO8;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_9:
+		*list = PINMUX_LIST_GPIO9_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO9_8822B);
+		*gpio_id = HALMAC_GPIO9;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_10:
+		*list = PINMUX_LIST_GPIO10_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO10_8822B);
+		*gpio_id = HALMAC_GPIO10;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_11:
+		*list = PINMUX_LIST_GPIO11_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO11_8822B);
+		*gpio_id = HALMAC_GPIO11;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_12:
+		*list = PINMUX_LIST_GPIO12_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO12_8822B);
+		*gpio_id = HALMAC_GPIO12;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_13:
+	case HALMAC_GPIO_FUNC_BT_DEV_WAKE1:
+		*list = PINMUX_LIST_GPIO13_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO13_8822B);
+		*gpio_id = HALMAC_GPIO13;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_14:
+	case HALMAC_GPIO_FUNC_BT_HOST_WAKE1:
+		*list = PINMUX_LIST_GPIO14_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO14_8822B);
+		*gpio_id = HALMAC_GPIO14;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_15:
+		*list = PINMUX_LIST_GPIO15_8822B;
+		*list_size = ARRAY_SIZE(PINMUX_LIST_GPIO15_8822B);
+		*gpio_id = HALMAC_GPIO15;
+		break;
+	default:
+		return HALMAC_RET_SWITCH_CASE_ERROR;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+chk_pinmux_valid_8822b(struct halmac_adapter *adapter,
+		       enum halmac_gpio_func gpio_func)
+{
+	struct halmac_pinmux_info *info = &adapter->pinmux_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	switch (gpio_func) {
+	case HALMAC_GPIO_FUNC_SW_IO_0:
+		if (info->sw_io_0 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_1:
+		if (info->sw_io_1 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_2:
+		if (info->sw_io_2 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_3:
+		if (info->sw_io_3 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_4:
+	case HALMAC_GPIO_FUNC_SDIO_INT:
+		if (info->sw_io_4 == 1 || info->sdio_int == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_5:
+		if (info->sw_io_5 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_6:
+		if (info->sw_io_6 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_7:
+		if (info->sw_io_7 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_8:
+	case HALMAC_GPIO_FUNC_WL_LED:
+		if (info->sw_io_8 == 1 || info->wl_led == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_9:
+		if (info->sw_io_9 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_10:
+		if (info->sw_io_10 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_11:
+		if (info->sw_io_11 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_12:
+		if (info->sw_io_12 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_13:
+	case HALMAC_GPIO_FUNC_BT_DEV_WAKE1:
+		if (info->sw_io_13 == 1 || info->bt_dev_wake == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_14:
+	case HALMAC_GPIO_FUNC_BT_HOST_WAKE1:
+		if (info->sw_io_14 == 1 || info->bt_host_wake == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_15:
+		if (info->sw_io_15 == 1)
+			status = HALMAC_RET_PINMUX_USED;
+		break;
+	default:
+		return HALMAC_RET_SWITCH_CASE_ERROR;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "chk_pinmux_valid func : %X status : %X\n", gpio_func, status);
+
+	return status;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.h
new file mode 100644
index 000000000000..f5d6d315ac3c
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.h
@@ -0,0 +1,34 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_GPIO_8822B_H_
+#define _HALMAC_GPIO_8822B_H_
+
+#include "../../halmac_api.h"
+#include "../../halmac_gpio_cmd.h"
+
+enum halmac_ret_status
+pinmux_get_func_8822b(struct halmac_adapter *adapter,
+		      enum halmac_gpio_func gpio_func, u8 *enable);
+
+enum halmac_ret_status
+pinmux_set_func_8822b(struct halmac_adapter *adapter,
+		      enum halmac_gpio_func gpio_func);
+
+enum halmac_ret_status
+pinmux_free_func_8822b(struct halmac_adapter *adapter,
+		       enum halmac_gpio_func gpio_func);
+
+#endif/* _HALMAC_GPIO_8822B_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.c
new file mode 100644
index 000000000000..f95add244d47
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.c
@@ -0,0 +1,415 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#include "halmac_gpio_88xx.h"
+
+/**
+ * pinmux_wl_led_mode_88xx() -control wlan led gpio function
+ * @adapter : the adapter of halmac
+ * @mode : wlan led mode
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pinmux_wl_led_mode_88xx(struct halmac_adapter *adapter,
+			enum halmac_wlled_mode mode)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	value8 = HALMAC_REG_R8(REG_LED_CFG + 2);
+	value8 &= ~(BIT(6));
+	value8 |= BIT(3);
+	value8 &= ~(BIT(0) | BIT(1) | BIT(2));
+
+	switch (mode) {
+	case HALMAC_WLLED_MODE_TRX:
+		value8 |= 2;
+		break;
+	case HALMAC_WLLED_MODE_TX:
+		value8 |= 4;
+		break;
+	case HALMAC_WLLED_MODE_RX:
+		value8 |= 6;
+		break;
+	case HALMAC_WLLED_MODE_SW_CTRL:
+		value8 |= 0;
+		break;
+	default:
+		return HALMAC_RET_SWITCH_CASE_ERROR;
+	}
+
+	HALMAC_REG_W8(REG_LED_CFG + 2, value8);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * pinmux_wl_led_sw_ctrl_88xx() -control wlan led on/off
+ * @adapter : the adapter of halmac
+ * @on : on(1), off(0)
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+void
+pinmux_wl_led_sw_ctrl_88xx(struct halmac_adapter *adapter, u8 on)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	value8 = HALMAC_REG_R8(REG_LED_CFG + 2);
+	value8 = (on == 0) ? value8 | BIT(3) : value8 & ~(BIT(3));
+
+	HALMAC_REG_W8(REG_LED_CFG + 2, value8);
+}
+
+/**
+ * pinmux_sdio_int_polarity_88xx() -control sdio int polarity
+ * @adapter : the adapter of halmac
+ * @low_active : low active(1), high active(0)
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+void
+pinmux_sdio_int_polarity_88xx(struct halmac_adapter *adapter, u8 low_active)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	value8 = HALMAC_REG_R8(REG_SYS_SDIO_CTRL + 2);
+	value8 = (low_active == 0) ? value8 | BIT(3) : value8 & ~(BIT(3));
+
+	HALMAC_REG_W8(REG_SYS_SDIO_CTRL + 2, value8);
+}
+
+/**
+ * pinmux_gpio_mode_88xx() -control gpio io mode
+ * @adapter : the adapter of halmac
+ * @gpio_id : gpio0~15(0~15)
+ * @output : output(1), input(0)
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pinmux_gpio_mode_88xx(struct halmac_adapter *adapter, u8 gpio_id, u8 output)
+{
+	u16 value16;
+	u8 in_out;
+	u32 offset;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (gpio_id <= 7)
+		offset = REG_GPIO_PIN_CTRL + 2;
+	else if (gpio_id >= 8 && gpio_id <= 15)
+		offset = REG_GPIO_EXT_CTRL + 2;
+	else
+		return HALMAC_RET_WRONG_GPIO;
+
+	in_out = (output == 0) ? 0 : 1;
+	gpio_id &= (8 - 1);
+
+	value16 = HALMAC_REG_R16(offset);
+	value16 &= ~((1 << gpio_id) | (1 << gpio_id << 8));
+	value16 |= (in_out << gpio_id);
+	HALMAC_REG_W16(offset, value16);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * pinmux_gpio_output_88xx() -control gpio output high/low
+ * @adapter : the adapter of halmac
+ * @gpio_id : gpio0~15(0~15)
+ * @high : high(1), low(0)
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pinmux_gpio_output_88xx(struct halmac_adapter *adapter, u8 gpio_id, u8 high)
+{
+	u8 value8;
+	u8 hi_low;
+	u32 offset;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (gpio_id <= 7)
+		offset = REG_GPIO_PIN_CTRL + 1;
+	else if (gpio_id >= 8 && gpio_id <= 15)
+		offset = REG_GPIO_EXT_CTRL + 1;
+	else
+		return HALMAC_RET_WRONG_GPIO;
+
+	hi_low = (high == 0) ? 0 : 1;
+	gpio_id &= (8 - 1);
+
+	value8 = HALMAC_REG_R8(offset);
+	value8 &= ~(1 << gpio_id);
+	value8 |= (hi_low << gpio_id);
+	HALMAC_REG_W8(offset, value8);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_pinmux_status_88xx() -get current gpio status(high/low)
+ * @adapter : the adapter of halmac
+ * @pin_id : 0~15(0~15)
+ * @phigh : high(1), low(0)
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pinmux_pin_status_88xx(struct halmac_adapter *adapter, u8 pin_id, u8 *high)
+{
+	u8 value8;
+	u32 offset;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (pin_id <= 7)
+		offset = REG_GPIO_PIN_CTRL;
+	else if (pin_id >= 8 && pin_id <= 15)
+		offset = REG_GPIO_EXT_CTRL;
+	else
+		return HALMAC_RET_WRONG_GPIO;
+
+	pin_id &= (8 - 1);
+
+	value8 = HALMAC_REG_R8(offset);
+	*high = (value8 & (1 << pin_id)) >> pin_id;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+pinmux_parser_88xx(struct halmac_adapter *adapter,
+		   const struct halmac_gpio_pimux_list *list, u32 size,
+		   u32 gpio_id, u32 *cur_func)
+{
+	u32 i;
+	u8 value8;
+	const struct halmac_gpio_pimux_list *cur_list = list;
+	enum halmac_gpio_cfg_state *state;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	state = &adapter->halmac_state.gpio_cfg_state;
+
+	if (*state == HALMAC_GPIO_CFG_STATE_BUSY)
+		return HALMAC_RET_BUSY_STATE;
+
+	*state = HALMAC_GPIO_CFG_STATE_BUSY;
+
+	for (i = 0; i < size; i++) {
+		if (gpio_id != cur_list->id) {
+			pr_err("offset:%X, value:%X, func:%X\n",
+			       cur_list->offset, cur_list->value,
+			       cur_list->func);
+			pr_err("id1 : %X, id2 : %X\n", gpio_id, cur_list->id);
+			*state = HALMAC_GPIO_CFG_STATE_IDLE;
+			return HALMAC_RET_GET_PINMUX_ERR;
+		}
+		value8 = HALMAC_REG_R8(cur_list->offset);
+		value8 &= cur_list->msk;
+		if (value8 == cur_list->value) {
+			*cur_func = cur_list->func;
+			break;
+		}
+		cur_list++;
+	}
+
+	*state = HALMAC_GPIO_CFG_STATE_IDLE;
+
+	if (i == size)
+		return HALMAC_RET_GET_PINMUX_ERR;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+pinmux_switch_88xx(struct halmac_adapter *adapter,
+		   const struct halmac_gpio_pimux_list *list, u32 size,
+		   u32 gpio_id, enum halmac_gpio_func gpio_func)
+{
+	u32 i;
+	u8 value8;
+	u16 switch_func;
+	const struct halmac_gpio_pimux_list *cur_list = list;
+	enum halmac_gpio_cfg_state *state;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	state = &adapter->halmac_state.gpio_cfg_state;
+
+	if (*state == HALMAC_GPIO_CFG_STATE_BUSY)
+		return HALMAC_RET_BUSY_STATE;
+
+	switch (gpio_func) {
+	case HALMAC_GPIO_FUNC_WL_LED:
+		switch_func = HALMAC_WL_LED;
+		break;
+	case HALMAC_GPIO_FUNC_SDIO_INT:
+		switch_func = HALMAC_SDIO_INT;
+		break;
+	case HALMAC_GPIO_FUNC_BT_HOST_WAKE1:
+	case HALMAC_GPIO_FUNC_BT_DEV_WAKE1:
+		switch_func = HALMAC_GPIO13_14_WL_CTRL_EN;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_0:
+	case HALMAC_GPIO_FUNC_SW_IO_1:
+	case HALMAC_GPIO_FUNC_SW_IO_2:
+	case HALMAC_GPIO_FUNC_SW_IO_3:
+	case HALMAC_GPIO_FUNC_SW_IO_4:
+	case HALMAC_GPIO_FUNC_SW_IO_5:
+	case HALMAC_GPIO_FUNC_SW_IO_6:
+	case HALMAC_GPIO_FUNC_SW_IO_7:
+	case HALMAC_GPIO_FUNC_SW_IO_8:
+	case HALMAC_GPIO_FUNC_SW_IO_9:
+	case HALMAC_GPIO_FUNC_SW_IO_10:
+	case HALMAC_GPIO_FUNC_SW_IO_11:
+	case HALMAC_GPIO_FUNC_SW_IO_12:
+	case HALMAC_GPIO_FUNC_SW_IO_13:
+	case HALMAC_GPIO_FUNC_SW_IO_14:
+	case HALMAC_GPIO_FUNC_SW_IO_15:
+		switch_func = HALMAC_SW_IO;
+		break;
+	default:
+		return HALMAC_RET_SWITCH_CASE_ERROR;
+	}
+
+	for (i = 0; i < size; i++) {
+		if (gpio_id != cur_list->id) {
+			pr_err("offset:%X, value:%X, func:%X\n",
+			       cur_list->offset, cur_list->value,
+			       cur_list->func);
+			pr_err("id1 : %X, id2 : %X\n", gpio_id, cur_list->id);
+			return HALMAC_RET_GET_PINMUX_ERR;
+		}
+
+		if (switch_func == cur_list->func)
+			break;
+
+		cur_list++;
+	}
+
+	if (i == size) {
+		pr_err("gpio func error:%X %X\n", gpio_id, cur_list->id);
+		return HALMAC_RET_GET_PINMUX_ERR;
+	}
+
+	*state = HALMAC_GPIO_CFG_STATE_BUSY;
+
+	cur_list = list;
+	for (i = 0; i < size; i++) {
+		value8 = HALMAC_REG_R8(cur_list->offset);
+		value8 &= ~(cur_list->msk);
+
+		if (switch_func == cur_list->func) {
+			value8 |= (cur_list->value & cur_list->msk);
+			HALMAC_REG_W8(cur_list->offset, value8);
+			break;
+		}
+
+		value8 |= (~cur_list->value & cur_list->msk);
+		HALMAC_REG_W8(cur_list->offset, value8);
+
+		cur_list++;
+	}
+
+	*state = HALMAC_GPIO_CFG_STATE_IDLE;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+pinmux_record_88xx(struct halmac_adapter *adapter,
+		   enum halmac_gpio_func gpio_func, u8 val)
+{
+	switch (gpio_func) {
+	case HALMAC_GPIO_FUNC_WL_LED:
+		adapter->pinmux_info.wl_led = val;
+		break;
+	case HALMAC_GPIO_FUNC_SDIO_INT:
+		adapter->pinmux_info.sdio_int = val;
+		break;
+	case HALMAC_GPIO_FUNC_BT_HOST_WAKE1:
+		adapter->pinmux_info.bt_host_wake = val;
+		break;
+	case HALMAC_GPIO_FUNC_BT_DEV_WAKE1:
+		adapter->pinmux_info.bt_dev_wake = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_0:
+		adapter->pinmux_info.sw_io_0 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_1:
+		adapter->pinmux_info.sw_io_1 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_2:
+		adapter->pinmux_info.sw_io_2 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_3:
+		adapter->pinmux_info.sw_io_3 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_4:
+		adapter->pinmux_info.sw_io_4 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_5:
+		adapter->pinmux_info.sw_io_5 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_6:
+		adapter->pinmux_info.sw_io_6 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_7:
+		adapter->pinmux_info.sw_io_7 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_8:
+		adapter->pinmux_info.sw_io_8 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_9:
+		adapter->pinmux_info.sw_io_9 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_10:
+		adapter->pinmux_info.sw_io_10 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_11:
+		adapter->pinmux_info.sw_io_11 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_12:
+		adapter->pinmux_info.sw_io_12 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_13:
+		adapter->pinmux_info.sw_io_13 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_14:
+		adapter->pinmux_info.sw_io_14 = val;
+		break;
+	case HALMAC_GPIO_FUNC_SW_IO_15:
+		adapter->pinmux_info.sw_io_15 = val;
+		break;
+	default:
+		return HALMAC_RET_GET_PINMUX_ERR;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.h
new file mode 100644
index 000000000000..2b6b5ce345f4
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_gpio_88xx.h
@@ -0,0 +1,55 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_GPIO_88XX_H_
+#define _HALMAC_GPIO_88XX_H_
+
+#include "../halmac_api.h"
+#include "../halmac_gpio_cmd.h"
+
+enum halmac_ret_status
+pinmux_wl_led_mode_88xx(struct halmac_adapter *adapter,
+			enum halmac_wlled_mode mode);
+
+void
+pinmux_wl_led_sw_ctrl_88xx(struct halmac_adapter *adapter, u8 on);
+
+void
+pinmux_sdio_int_polarity_88xx(struct halmac_adapter *adapter, u8 low_active);
+
+enum halmac_ret_status
+pinmux_gpio_mode_88xx(struct halmac_adapter *adapter, u8 gpio_id, u8 output);
+
+enum halmac_ret_status
+pinmux_gpio_output_88xx(struct halmac_adapter *adapter, u8 gpio_id, u8 high);
+
+enum halmac_ret_status
+pinmux_pin_status_88xx(struct halmac_adapter *adapter, u8 pin_id, u8 *high);
+
+enum halmac_ret_status
+pinmux_parser_88xx(struct halmac_adapter *adapter,
+		   const struct halmac_gpio_pimux_list *list, u32 size,
+		   u32 gpio_id, u32 *cur_func);
+
+enum halmac_ret_status
+pinmux_switch_88xx(struct halmac_adapter *adapter,
+		   const struct halmac_gpio_pimux_list *list, u32 size,
+		   u32 gpio_id, enum halmac_gpio_func gpio_func);
+
+enum halmac_ret_status
+pinmux_record_88xx(struct halmac_adapter *adapter,
+		   enum halmac_gpio_func gpio_func, u8 val);
+
+#endif/* _HALMAC_GPIO_88XX_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_gpio_cmd.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_gpio_cmd.h
new file mode 100644
index 000000000000..92283350083a
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_gpio_cmd.h
@@ -0,0 +1,84 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef HALMAC_GPIO_CMD
+#define HALMAC_GPIO_CMD
+
+#include "../wifi.h"
+
+/* GPIO ID */
+#define HALMAC_GPIO0		0
+#define HALMAC_GPIO1		1
+#define HALMAC_GPIO2		2
+#define HALMAC_GPIO3		3
+#define HALMAC_GPIO4		4
+#define HALMAC_GPIO5		5
+#define HALMAC_GPIO6		6
+#define HALMAC_GPIO7		7
+#define HALMAC_GPIO8		8
+#define HALMAC_GPIO9		9
+#define HALMAC_GPIO10		10
+#define HALMAC_GPIO11		11
+#define HALMAC_GPIO12		12
+#define HALMAC_GPIO13		13
+#define HALMAC_GPIO14		14
+#define HALMAC_GPIO15		15
+#define HALMAC_GPIO_NUM		16
+
+/* GPIO type */
+#define HALMAC_GPIO_IN		0
+#define HALMAC_GPIO_OUT		1
+#define HALMAC_GPIO_IN_OUT	2
+
+/* Function name */
+#define HALMAC_WL_HWPDN			0
+#define HALMAC_BT_HWPDN			1
+#define HALMAC_BT_GPIO			2
+#define HALMAC_WL_HW_EXTWOL		3
+#define HALMAC_BT_HW_EXTWOL		4
+#define HALMAC_BT_SFLASH		5
+#define HALMAC_WL_SFLASH		6
+#define HALMAC_WL_LED			7
+#define HALMAC_SDIO_INT			8
+#define HALMAC_UART0			9
+#define HALMAC_EEPROM			10
+#define HALMAC_JTAG			11
+#define HALMAC_LTE_COEX_UART		12
+#define HALMAC_3W_LTE_WL_GPIO		13
+#define HALMAC_GPIO2_3_WL_CTRL_EN	14
+#define HALMAC_GPIO13_14_WL_CTRL_EN	15
+#define HALMAC_DBG_GNT_WL_BT		16
+#define HALMAC_BT_3DDLS_A		17
+#define HALMAC_BT_3DDLS_B		18
+#define HALMAC_BT_PTA			19
+#define HALMAC_WL_PTA			20
+#define HALMAC_WL_UART			21
+#define HALMAC_WLMAC_DBG		22
+#define HALMAC_WLPHY_DBG		23
+#define HALMAC_BT_DBG			24
+#define HALMAC_WLPHY_RFE_CTRL2GPIO	25
+#define HALMAC_EXT_XTAL			26
+#define HALMAC_SW_IO			27
+
+struct halmac_gpio_pimux_list {
+	u16 func;
+	u8 id;
+	u8 type;
+	u16 offset;
+	u8 msk;
+	u8 value;
+};
+
+#endif
-- 
2.15.1
