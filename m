Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:3278 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213Ab0ESP0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 11:26:16 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 5/7] rt2x00: Move PCI/USB specific register initializations to rt2800{pci,usb}.
Date: Wed, 19 May 2010 17:26:07 +0200
Message-Id: <1274282769-19244-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents us having common code depend on PCI or USB specific code.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   61 ++-----------------------------
 drivers/net/wireless/rt2x00/rt2800lib.h |    9 +++++
 drivers/net/wireless/rt2x00/rt2800pci.c |   34 +++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800usb.c |   40 ++++++++++++++++++++
 4 files changed, 87 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d46d1b8..8ffbc3c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -37,12 +37,8 @@
 #include <linux/module.h>
 
 #include "rt2x00.h"
-#if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
-#include "rt2x00usb.h"
-#endif
 #include "rt2800lib.h"
 #include "rt2800.h"
-#include "rt2800usb.h"
 
 MODULE_AUTHOR("Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("rt2800 library");
@@ -1271,6 +1267,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 	u16 eeprom;
 	unsigned int i;
+	int ret;
 
 	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
@@ -1280,59 +1277,9 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
 	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
-	if (rt2x00_is_usb(rt2x00dev)) {
-		/*
-		 * Wait until BBP and RF are ready.
-		 */
-		for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-			rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-			if (reg && reg != ~0)
-				break;
-			msleep(1);
-		}
-
-		if (i == REGISTER_BUSY_COUNT) {
-			ERROR(rt2x00dev, "Unstable hardware.\n");
-			return -EBUSY;
-		}
-
-		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
-		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL,
-				      reg & ~0x00002000);
-	} else if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
-		/*
-		 * Reset DMA indexes
-		 */
-		rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
-		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
-		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
-		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
-		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
-		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
-		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
-		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
-		rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
-
-		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
-		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
-
-		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
-	}
-
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	if (rt2x00_is_usb(rt2x00dev)) {
-		rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
-#if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
-		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
-					    USB_MODE_RESET, REGISTER_TIMEOUT);
-#endif
-	}
-
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+	ret = rt2800_drv_init_registers(rt2x00dev);
+	if (ret)
+		return ret;
 
 	rt2800_register_read(rt2x00dev, BCN_OFFSET0, &reg);
 	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0, 0xe0); /* 0x3800 */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index b16fd6d..8313dbf 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -40,6 +40,8 @@ struct rt2800_ops {
 	int (*regbusy_read)(struct rt2x00_dev *rt2x00dev,
 			    const unsigned int offset,
 			    const struct rt2x00_field32 field, u32 *reg);
+
+	int (*drv_init_registers)(struct rt2x00_dev *rt2x00dev);
 };
 
 static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
@@ -107,6 +109,13 @@ static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
 	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
 }
 
+static inline int rt2800_drv_init_registers(struct rt2x00_dev *rt2x00dev)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	return rt2800ops->drv_init_registers(rt2x00dev);
+}
+
 void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 command, const u8 token,
 			const u8 arg0, const u8 arg1);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index f271836..846600f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -446,6 +446,38 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
 }
 
+static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	/*
+	 * Reset DMA indexes
+	 */
+	rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
+	rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
+
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
+
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+
+	return 0;
+}
+
 static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -944,6 +976,8 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 	.register_multiwrite	= rt2x00pci_register_multiwrite,
 
 	.regbusy_read		= rt2x00pci_regbusy_read,
+
+	.drv_init_registers	= rt2800pci_init_registers,
 };
 
 static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 8a15ffb..6a2ed50 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -243,6 +243,44 @@ static void rt2800usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 }
 
+static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+	int i;
+
+	/*
+	 * Wait until BBP and RF are ready.
+	 */
+	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
+		if (reg && reg != ~0)
+			break;
+		msleep(1);
+	}
+
+	if (i == REGISTER_BUSY_COUNT) {
+		ERROR(rt2x00dev, "Unstable hardware.\n");
+		return -EBUSY;
+	}
+
+	rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
+
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+
+	rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
+
+	rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
+				    USB_MODE_RESET, REGISTER_TIMEOUT);
+
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+
+	return 0;
+}
+
 static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -549,6 +587,8 @@ static const struct rt2800_ops rt2800usb_rt2800_ops = {
 	.register_multiwrite	= rt2x00usb_register_multiwrite,
 
 	.regbusy_read		= rt2x00usb_regbusy_read,
+
+	.drv_init_registers	= rt2800usb_init_registers,
 };
 
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
-- 
1.7.1

