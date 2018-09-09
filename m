Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36413 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbeIJBXt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:49 -0400
Received: by mail-wm0-f67.google.com with SMTP id j192-v6so19387436wmj.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:32:55 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 01/11] mt76: move mt76x0 and mt76x2 mcu shared defs in mt76x02_mcu.h
Date: Sun,  9 Sep 2018 22:32:36 +0200
Message-Id: <20180909203246.21608-2-lorenzo.bianconi@redhat.com> (sfid-20180909_223259_040468_B6BFF2D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x0 and mt76x2 mcu shared definition in mt76x02_mcu.h
and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   |  8 +--
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   | 51 +------------
 .../net/wireless/mediatek/mt76/mt76x02_mcu.h  | 71 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2_mcu.h   | 49 +------------
 .../net/wireless/mediatek/mt76/mt76x2u_mcu.c  |  2 -
 5 files changed, 79 insertions(+), 102 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 29c0b3978af7..a9314753a2dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -81,7 +81,7 @@ mt76x0_mcu_calibrate(struct mt76x0_dev *dev, enum mcu_calibrate cal, u32 val)
 int mt76x0_write_reg_pairs(struct mt76x0_dev *dev, u32 base,
 			   const struct mt76_reg_pair *data, int n)
 {
-	const int max_vals_per_cmd = INBAND_PACKET_MAX_LEN / 8;
+	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
 	struct sk_buff *skb;
 	int cnt, i, ret;
 
@@ -111,7 +111,7 @@ int mt76x0_write_reg_pairs(struct mt76x0_dev *dev, u32 base,
 int mt76x0_read_reg_pairs(struct mt76x0_dev *dev, u32 base,
 			  struct mt76_reg_pair *data, int n)
 {
-	const int max_vals_per_cmd = INBAND_PACKET_MAX_LEN / 8;
+	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
 	struct mt76_usb *usb = &dev->mt76.usb;
 	struct sk_buff *skb;
 	int cnt, i, ret;
@@ -154,7 +154,7 @@ int mt76x0_read_reg_pairs(struct mt76x0_dev *dev, u32 base,
 int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 			     const u32 *data, int n)
 {
-	const int max_regs_per_cmd = INBAND_PACKET_MAX_LEN / 4 - 1;
+	const int max_regs_per_cmd = MT_INBAND_PACKET_MAX_LEN / 4 - 1;
 	struct sk_buff *skb;
 	int cnt, i, ret;
 
@@ -185,7 +185,7 @@ int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 static int mt76x0_burst_read_regs(struct mt76x0_dev *dev, u32 base,
 				  struct mt76_reg_pair *data, int n)
 {
-	const int max_vals_per_cmd = INBAND_PACKET_MAX_LEN / 4 - 1;
+	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 4 - 1;
 	struct mt76_usb *usb = &dev->mt76.usb;
 	struct sk_buff *skb;
 	int cnt, ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
index 010a7f2bbae9..a551ad5e3af4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
@@ -15,65 +15,18 @@
 #ifndef __MT76X0U_MCU_H
 #define __MT76X0U_MCU_H
 
-struct mt76x0_dev;
+#include "../mt76x02_mcu.h"
 
-/* Register definitions */
-#define MT_MCU_RESET_CTL		0x070C
-#define MT_MCU_INT_LEVEL		0x0718
-#define MT_MCU_COM_REG0			0x0730
-#define MT_MCU_COM_REG1			0x0734
-#define MT_MCU_COM_REG2			0x0738
-#define MT_MCU_COM_REG3			0x073C
+struct mt76x0_dev;
 
 #define MT_MCU_IVB_SIZE			0x40
 #define MT_MCU_DLM_OFFSET		0x80000
 
-#define MT_MCU_MEMMAP_WLAN		0x00410000
 /* We use same space for BBP as for MAC regs
  * #define MT_MCU_MEMMAP_BBP		0x40000000
  */
 #define MT_MCU_MEMMAP_RF		0x80000000
 
-#define INBAND_PACKET_MAX_LEN		192
-
-enum mcu_cmd {
-	CMD_FUN_SET_OP = 1,
-	CMD_LOAD_CR = 2,
-	CMD_INIT_GAIN_OP = 3,
-	CMD_DYNC_VGA_OP = 6,
-	CMD_TDLS_CH_SW = 7,
-	CMD_BURST_WRITE = 8,
-	CMD_READ_MODIFY_WRITE = 9,
-	CMD_RANDOM_READ = 10,
-	CMD_BURST_READ = 11,
-	CMD_RANDOM_WRITE = 12,
-	CMD_LED_MODE_OP = 16,
-	CMD_POWER_SAVING_OP = 20,
-	CMD_WOW_CONFIG = 21,
-	CMD_WOW_QUERY = 22,
-	CMD_WOW_FEATURE = 24,
-	CMD_CARRIER_DETECT_OP = 28,
-	CMD_RADOR_DETECT_OP = 29,
-	CMD_SWITCH_CHANNEL_OP = 30,
-	CMD_CALIBRATION_OP = 31,
-	CMD_BEACON_OP = 32,
-	CMD_ANTENNA_OP = 33,
-};
-
-enum mcu_function {
-	Q_SELECT = 1,
-	BW_SETTING = 2,
-	ATOMIC_TSSI_SETTING = 5,
-};
-
-enum mcu_power_mode {
-	RADIO_OFF = 0x30,
-	RADIO_ON = 0x31,
-	RADIO_OFF_AUTO_WAKEUP = 0x32,
-	RADIO_OFF_ADVANCE = 0x33,
-	RADIO_ON_ADVANCE = 0x34,
-};
-
 enum mcu_calibrate {
 	MCU_CAL_R = 1,
 	MCU_CAL_RXDCOC,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
new file mode 100644
index 000000000000..21181fddee98
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __MT76x02_MCU_H
+#define __MT76x0x_MCU_H
+
+#define MT_MCU_RESET_CTL		0x070C
+#define MT_MCU_INT_LEVEL		0x0718
+#define MT_MCU_COM_REG0			0x0730
+#define MT_MCU_COM_REG1			0x0734
+#define MT_MCU_COM_REG2			0x0738
+#define MT_MCU_COM_REG3			0x073C
+
+#define MT_INBAND_PACKET_MAX_LEN	192
+#define MT_MCU_MEMMAP_WLAN		0x410000
+
+enum mcu_cmd {
+	CMD_FUN_SET_OP = 1,
+	CMD_LOAD_CR = 2,
+	CMD_INIT_GAIN_OP = 3,
+	CMD_DYNC_VGA_OP = 6,
+	CMD_TDLS_CH_SW = 7,
+	CMD_BURST_WRITE = 8,
+	CMD_READ_MODIFY_WRITE = 9,
+	CMD_RANDOM_READ = 10,
+	CMD_BURST_READ = 11,
+	CMD_RANDOM_WRITE = 12,
+	CMD_LED_MODE_OP = 16,
+	CMD_POWER_SAVING_OP = 20,
+	CMD_WOW_CONFIG = 21,
+	CMD_WOW_QUERY = 22,
+	CMD_WOW_FEATURE = 24,
+	CMD_CARRIER_DETECT_OP = 28,
+	CMD_RADOR_DETECT_OP = 29,
+	CMD_SWITCH_CHANNEL_OP = 30,
+	CMD_CALIBRATION_OP = 31,
+	CMD_BEACON_OP = 32,
+	CMD_ANTENNA_OP = 33,
+};
+
+enum mcu_power_mode {
+	RADIO_OFF = 0x30,
+	RADIO_ON = 0x31,
+	RADIO_OFF_AUTO_WAKEUP = 0x32,
+	RADIO_OFF_ADVANCE = 0x33,
+	RADIO_ON_ADVANCE = 0x34,
+};
+
+enum mcu_function {
+	Q_SELECT = 1,
+	BW_SETTING = 2,
+	USB2_SW_DISCONNECT = 2,
+	USB3_SW_DISCONNECT = 3,
+	LOG_FW_DEBUG_MSG = 4,
+	GET_FW_VERSION = 5,
+};
+
+#endif /* __MT76x02_MCU_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
index e40293f21417..564bcac27401 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
@@ -17,15 +17,11 @@
 #ifndef __MT76x2_MCU_H
 #define __MT76x2_MCU_H
 
+#include "mt76x02_mcu.h"
+
 /* Register definitions */
 #define MT_MCU_CPU_CTL			0x0704
 #define MT_MCU_CLOCK_CTL		0x0708
-#define MT_MCU_RESET_CTL		0x070C
-#define MT_MCU_INT_LEVEL		0x0718
-#define MT_MCU_COM_REG0			0x0730
-#define MT_MCU_COM_REG1			0x0734
-#define MT_MCU_COM_REG2			0x0738
-#define MT_MCU_COM_REG3			0x073C
 #define MT_MCU_PCIE_REMAP_BASE1		0x0740
 #define MT_MCU_PCIE_REMAP_BASE2		0x0744
 #define MT_MCU_PCIE_REMAP_BASE3		0x0748
@@ -69,47 +65,6 @@
 #define MT_MCU_DLM_ADDR			0x90000
 #define MT_MCU_DLM_ADDR_E3		0x90800
 
-enum mcu_cmd {
-	CMD_FUN_SET_OP = 1,
-	CMD_LOAD_CR = 2,
-	CMD_INIT_GAIN_OP = 3,
-	CMD_DYNC_VGA_OP = 6,
-	CMD_TDLS_CH_SW = 7,
-	CMD_BURST_WRITE = 8,
-	CMD_READ_MODIFY_WRITE = 9,
-	CMD_RANDOM_READ = 10,
-	CMD_BURST_READ = 11,
-	CMD_RANDOM_WRITE = 12,
-	CMD_LED_MODE_OP = 16,
-	CMD_POWER_SAVING_OP = 20,
-	CMD_WOW_CONFIG = 21,
-	CMD_WOW_QUERY = 22,
-	CMD_WOW_FEATURE = 24,
-	CMD_CARRIER_DETECT_OP = 28,
-	CMD_RADOR_DETECT_OP = 29,
-	CMD_SWITCH_CHANNEL_OP = 30,
-	CMD_CALIBRATION_OP = 31,
-	CMD_BEACON_OP = 32,
-	CMD_ANTENNA_OP = 33,
-};
-
-enum mcu_function {
-	Q_SELECT = 1,
-	BW_SETTING = 2,
-	USB2_SW_DISCONNECT = 2,
-	USB3_SW_DISCONNECT = 3,
-	LOG_FW_DEBUG_MSG = 4,
-	GET_FW_VERSION = 5,
-};
-
-enum mcu_power_mode {
-	RADIO_OFF = 0x30,
-	RADIO_ON = 0x31,
-	RADIO_OFF_AUTO_WAKEUP = 0x32,
-	RADIO_OFF_ADVANCE = 0x33,
-	RADIO_ON_ADVANCE = 0x34,
-};
-
 enum mcu_calibration {
 	MCU_CAL_R = 1,
 	MCU_CAL_TEMP_SENSOR,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
index 31677e898427..a4302457cf5c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
@@ -20,8 +20,6 @@
 #include "mt76x2_eeprom.h"
 
 #define MT_CMD_HDR_LEN			4
-#define MT_INBAND_PACKET_MAX_LEN	192
-#define MT_MCU_MEMMAP_WLAN		0x410000
 
 #define MCU_FW_URB_MAX_PAYLOAD		0x3900
 #define MCU_ROM_PATCH_MAX_PAYLOAD	2048
-- 
2.18.0
