Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:36837 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754808AbeDCHyI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 03:54:08 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 05/17] rtlwifi: halmac: describe number and size of chip functions
Date: Tue, 3 Apr 2018 15:53:20 +0800
Message-ID: <20180403075332.3344-6-pkshih@realtek.com> (sfid-20180403_100506_877476_122CFE9A)
In-Reply-To: <20180403075332.3344-1-pkshih@realtek.com>
References: <20180403075332.3344-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The number and size of chip fucntions are different, such as TX/RX FIFO
size, efuse size, etc. So they are defined in an individual file.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../halmac_88xx/halmac_8822b/halmac_8822b_cfg.h    | 68 ++++++++++++++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_88xx_cfg.h   | 40 +++++++++++++
 2 files changed, 108 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_8822b_cfg.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_88xx_cfg.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_8822b_cfg.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_8822b_cfg.h
new file mode 100644
index 000000000000..f6ed7b44549c
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_8822b_cfg.h
@@ -0,0 +1,68 @@
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
+#ifndef _HALMAC_8822B_CFG_H_
+#define _HALMAC_8822B_CFG_H_
+
+#include "../halmac_88xx_cfg.h"
+
+#define TX_FIFO_SIZE_8822B	262144
+#define RX_FIFO_SIZE_8822B	24576
+#define TRX_SHARE_SIZE_8822B	65536
+
+#define RX_DESC_DUMMY_SIZE_8822B	72 /* 8 * 9 Bytes */
+#define RX_FIFO_EXPANDING_MODE_PKT_SIZE_MAX_8822B	80 /* 8 Byte alignment*/
+
+/* should be 8 Byte alignment*/
+#if (HALMAC_RX_FIFO_EXPANDING_MODE_PKT_SIZE <= \
+	RX_FIFO_EXPANDING_MODE_PKT_SIZE_MAX_8822B)
+#define RX_FIFO_EXPANDING_UNIT_8822B	(RX_DESC_SIZE_88XX + \
+	RX_DESC_DUMMY_SIZE_8822B + HALMAC_RX_FIFO_EXPANDING_MODE_PKT_SIZE)
+#else
+#define RX_FIFO_EXPANDING_UNIT_8822B (RX_DESC_SIZE_88XX + \
+	RX_DESC_DUMMY_SIZE_8822B + RX_FIFO_EXPANDING_MODE_PKT_SIZE_MAX_8822B)
+#endif
+
+#define TX_FIFO_SIZE_LA_8822B	(TX_FIFO_SIZE_8822B >>  1)
+#define TX_FIFO_SIZE_RX_EXPAND_1BLK_8822B	\
+		(TX_FIFO_SIZE_8822B - TRX_SHARE_SIZE_8822B)
+#define RX_FIFO_SIZE_RX_EXPAND_1BLK_8822B	\
+		((((RX_FIFO_EXPANDING_UNIT_8822B << 8) - 1) >> 10) << 10)
+#define TX_FIFO_SIZE_RX_EXPAND_2BLK_8822B	\
+		(TX_FIFO_SIZE_8822B - (2 * TRX_SHARE_SIZE_8822B))
+#define RX_FIFO_SIZE_RX_EXPAND_2BLK_8822B	\
+		(RX_FIFO_SIZE_8822B +  (2 * TRX_SHARE_SIZE_8822B))
+#define TX_FIFO_SIZE_RX_EXPAND_3BLK_8822B	\
+		(TX_FIFO_SIZE_8822B - (3 * TRX_SHARE_SIZE_8822B))
+#define RX_FIFO_SIZE_RX_EXPAND_3BLK_8822B	\
+		(RX_FIFO_SIZE_8822B +  (3 * TRX_SHARE_SIZE_8822B))
+
+#define EFUSE_SIZE_8822B		1024
+#define EEPROM_SIZE_8822B		768
+#define BT_EFUSE_SIZE_8822B		128
+
+#define SEC_CAM_NUM_8822B		64
+
+#define OQT_ENTRY_AC_8822B		32
+#define OQT_ENTRY_NOAC_8822B		32
+#define MACID_MAX_8822B			128
+
+#define WLAN_FW_IRAM_MAX_SIZE_8822B	196608
+#define WLAN_FW_DRAM_MAX_SIZE_8822B	49152
+#define WLAN_FW_ERAM_MAX_SIZE_8822B	0
+#define WLAN_FW_MAX_SIZE_8822B		(WLAN_FW_IRAM_MAX_SIZE_8822B + \
+	WLAN_FW_DRAM_MAX_SIZE_8822B + WLAN_FW_ERAM_MAX_SIZE_8822B)
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_88xx_cfg.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_88xx_cfg.h
new file mode 100644
index 000000000000..22514ef4680d
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_88xx_cfg.h
@@ -0,0 +1,40 @@
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
+#ifndef _HALMAC_88XX_CFG_H_
+#define _HALMAC_88XX_CFG_H_
+
+#include "../halmac_api.h"
+
+#define TX_PAGE_SIZE_88XX		128
+#define TX_PAGE_SIZE_SHIFT_88XX		7 /* 128 = 2^7 */
+#define TX_ALIGN_SIZE_88XX		8
+#define SDIO_TX_MAX_SIZE_88XX		31744
+#define RX_BUF_FW_88XX			12288
+
+#define TX_DESC_SIZE_88XX		48
+#define RX_DESC_SIZE_88XX		24
+
+#define H2C_PKT_SIZE_88XX		32 /* Only support 32 byte packet now */
+#define H2C_PKT_HDR_SIZE_88XX		8
+#define C2H_DATA_OFFSET_88XX		10
+#define C2H_PKT_BUF_88XX		256
+
+/* HW memory address */
+#define OCPBASE_TXBUF_88XX		0x18780000
+#define OCPBASE_DMEM_88XX		0x00200000
+#define OCPBASE_EMEM_88XX		0x00100000
+
+#endif
-- 
2.15.1
