Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43999 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab0HWR52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 13:57:28 -0400
Received: by mail-wy0-f174.google.com with SMTP id 32so7066669wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 10:57:27 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/8] rt2x00: Merge rt2800{pci/usb} radio enabling/disabling code to rt2800lib
Date: Mon, 23 Aug 2010 19:55:22 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008231953.40629.IvDoorn@gmail.com> <201008231954.42087.IvDoorn@gmail.com> <201008231955.02401.IvDoorn@gmail.com>
In-Reply-To: <201008231955.02401.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008231955.23348.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions rt2800pci_enable_radio and rt2800usb_disable_radio are
almost equal and can be merged into rt2800lib. This reduces the number
of functions which must be exported from rt2800lib to the drivers at
the same time.

Also rt2800pci_disable_radio and rt2800usb_disable_radio are almost
equal and can be merged into rt2800lib in a similar fashion.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  103 +++++++++++++++++++++++++++++--
 drivers/net/wireless/rt2x00/rt2800lib.h |    8 +-
 drivers/net/wireless/rt2x00/rt2800pci.c |   69 +--------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |   72 +---------------------
 4 files changed, 107 insertions(+), 145 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d3a5837..4ad2fe5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1655,7 +1655,7 @@ EXPORT_SYMBOL_GPL(rt2800_link_tuner);
 /*
  * Initialization functions.
  */
-int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
+static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 	u16 eeprom;
@@ -2025,7 +2025,6 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rt2800_init_registers);
 
 static int rt2800_wait_bbp_rf_ready(struct rt2x00_dev *rt2x00dev)
 {
@@ -2068,7 +2067,7 @@ static int rt2800_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 	return -EACCES;
 }
 
-int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
+static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
 	u16 eeprom;
@@ -2163,7 +2162,6 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rt2800_init_bbp);
 
 static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
 				bool bw40, u8 rfcsr24, u8 filter_target)
@@ -2225,7 +2223,7 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
 	return rfcsr24;
 }
 
-int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
+static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 {
 	u8 rfcsr;
 	u8 bbp;
@@ -2479,7 +2477,100 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rt2800_init_rfcsr);
+
+int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+	u16 word;
+
+	/*
+	 * Initialize all registers.
+	 */
+	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
+		     rt2800_init_registers(rt2x00dev) ||
+		     rt2800_init_bbp(rt2x00dev) ||
+		     rt2800_init_rfcsr(rt2x00dev)))
+		return -EIO;
+
+	/*
+	 * Send signal to firmware during boot time.
+	 */
+	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
+
+	if (rt2x00_is_usb(rt2x00dev) &&
+	    (rt2x00_rt(rt2x00dev, RT3070) ||
+	     rt2x00_rt(rt2x00dev, RT3071) ||
+	     rt2x00_rt(rt2x00dev, RT3572))) {
+		udelay(200);
+		rt2800_mcu_request(rt2x00dev, MCU_CURRENT, 0, 0, 0);
+		udelay(10);
+	}
+
+	/*
+	 * Enable RX.
+	 */
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+
+	udelay(50);
+
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 1);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 1);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 2);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+
+	/*
+	 * Initialize LED control
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED1, &word);
+	rt2800_mcu_request(rt2x00dev, MCU_LED_1, 0xff,
+			   word & 0xff, (word >> 8) & 0xff);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED2, &word);
+	rt2800_mcu_request(rt2x00dev, MCU_LED_2, 0xff,
+			   word & 0xff, (word >> 8) & 0xff);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED3, &word);
+	rt2800_mcu_request(rt2x00dev, MCU_LED_3, 0xff,
+			   word & 0xff, (word >> 8) & 0xff);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_enable_radio);
+
+void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+
+	/* Wait for DMA, ignore error */
+	rt2800_wait_wpdma_ready(rt2x00dev);
+
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 0);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0);
+	rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
+}
+EXPORT_SYMBOL_GPL(rt2800_disable_radio);
 
 int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 3b572c6..deb10b1 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -140,6 +140,8 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 command, const u8 token,
 			const u8 arg0, const u8 arg1);
 
+int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev);
+
 int rt2800_check_firmware(struct rt2x00_dev *rt2x00dev,
 			  const u8 *data, const size_t len);
 int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
@@ -176,10 +178,8 @@ void rt2800_reset_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual);
 void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count);
 
-int rt2800_init_registers(struct rt2x00_dev *rt2x00dev);
-int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev);
-int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev);
-int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev);
+int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev);
+void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev);
 void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index a5e5870..4d93204 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -399,78 +399,18 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
-	u16 word;
-
-	/*
-	 * Initialize all registers.
-	 */
 	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
-		     rt2800pci_init_queues(rt2x00dev) ||
-		     rt2800_init_registers(rt2x00dev) ||
-		     rt2800_wait_wpdma_ready(rt2x00dev) ||
-		     rt2800_init_bbp(rt2x00dev) ||
-		     rt2800_init_rfcsr(rt2x00dev)))
+		     rt2800pci_init_queues(rt2x00dev)))
 		return -EIO;
 
-	/*
-	 * Send signal to firmware during boot time.
-	 */
-	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
-
-	/*
-	 * Enable RX.
-	 */
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 1);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 1);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 2);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	/*
-	 * Initialize LED control
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED1, &word);
-	rt2800_mcu_request(rt2x00dev, MCU_LED_1, 0xff,
-			      word & 0xff, (word >> 8) & 0xff);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED2, &word);
-	rt2800_mcu_request(rt2x00dev, MCU_LED_2, 0xff,
-			      word & 0xff, (word >> 8) & 0xff);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED3, &word);
-	rt2800_mcu_request(rt2x00dev, MCU_LED_3, 0xff,
-			      word & 0xff, (word >> 8) & 0xff);
-
-	return 0;
+	return rt2800_enable_radio(rt2x00dev);
 }
 
 static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
-
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0);
-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-	rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
+	rt2800_disable_radio(rt2x00dev);
 
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001280);
 
@@ -486,9 +426,6 @@ static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
-
-	/* Wait for DMA, ignore error */
-	rt2800_wait_wpdma_ready(rt2x00dev);
 }
 
 static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 02f9589..82ae58e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -101,19 +101,6 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 	msleep(10);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
 
-	/*
-	 * Send signal to firmware during boot time.
-	 */
-	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
-
-	if (rt2x00_rt(rt2x00dev, RT3070) ||
-	    rt2x00_rt(rt2x00dev, RT3071) ||
-	    rt2x00_rt(rt2x00dev, RT3572)) {
-		udelay(200);
-		rt2800_mcu_request(rt2x00dev, MCU_CURRENT, 0, 0, 0);
-		udelay(10);
-	}
-
 	return 0;
 }
 
@@ -173,30 +160,10 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
-	u16 word;
 
-	/*
-	 * Initialize all registers.
-	 */
-	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
-		     rt2800_init_registers(rt2x00dev) ||
-		     rt2800_init_bbp(rt2x00dev) ||
-		     rt2800_init_rfcsr(rt2x00dev)))
+	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev)))
 		return -EIO;
 
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	udelay(50);
-
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 1);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 1);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
-
-
 	rt2800_register_read(rt2x00dev, USB_DMA_CFG, &reg);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN, 0);
@@ -211,45 +178,12 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, USB_DMA_CFG_TX_BULK_EN, 1);
 	rt2800_register_write(rt2x00dev, USB_DMA_CFG, reg);
 
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	/*
-	 * Initialize LED control
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED1, &word);
-	rt2800_mcu_request(rt2x00dev, MCU_LED_1, 0xff,
-			      word & 0xff, (word >> 8) & 0xff);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED2, &word);
-	rt2800_mcu_request(rt2x00dev, MCU_LED_2, 0xff,
-			      word & 0xff, (word >> 8) & 0xff);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED3, &word);
-	rt2800_mcu_request(rt2x00dev, MCU_LED_3, 0xff,
-			      word & 0xff, (word >> 8) & 0xff);
-
-	return 0;
+	return rt2800_enable_radio(rt2x00dev);
 }
 
 static void rt2800usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
-
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
-
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0);
-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-	rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
-
-	/* Wait for DMA, ignore error */
-	rt2800_wait_wpdma_ready(rt2x00dev);
-
+	rt2800_disable_radio(rt2x00dev);
 	rt2x00usb_disable_radio(rt2x00dev);
 }
 
-- 
1.7.2.1

