Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:36702 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762316AbZD1SPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 14:15:04 -0400
Received: by ewy24 with SMTP id 24so764738ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 11:15:01 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Synchronize initialization with rt2870 driver
Date: Tue, 28 Apr 2009 20:14:58 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904282014.59149.IvDoorn@gmail.com> (sfid-20090428_201510_593428_70A1C7E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ralink released a new rt2870 driver, these are the obvious
differences I could find. It doesn't same to make my device
work better, but neither does it seem to regress...

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   47 +++++++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2800usb.h |   11 +++++++
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9d967b0..7cb3653 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -984,9 +984,9 @@ static void rt2800usb_config_ps(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTOWAKE, 1);
 		rt2x00usb_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
 
-		rt2800usb_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0, 0);
+		rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 	} else {
-		rt2800usb_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 0);
+		rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 
 		rt2x00usb_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTO_LEAD_TIME, 0);
@@ -1171,7 +1171,9 @@ static int rt2800usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Check which section of the firmware we need.
 	 */
-	if ((chipset == 0x2860) || (chipset == 0x2872) || (chipset == 0x3070)) {
+	if ((chipset == 0x2860) ||
+	    (chipset == 0x2872) ||
+	    (chipset == 0x3070)) {
 		offset = 0;
 		length = 4096;
 	} else {
@@ -1218,6 +1220,22 @@ static int rt2800usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 		return status;
 	}
 
+	msleep(10);
+	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+
+	/*
+	 * Send signal to firmware during boot time.
+	 */
+	rt2800usb_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0xff, 0, 0);
+
+	if ((chipset == 0x3070) ||
+	    (chipset == 0x3071) ||
+	    (chipset == 0x3572)) {
+		udelay(200);
+		rt2800usb_mcu_request(rt2x00dev, MCU_CURRENT, 0, 0, 0);
+		udelay(10);
+	}
+
 	/*
 	 * Wait for device to stabilize.
 	 */
@@ -1566,6 +1584,14 @@ static int rt2800usb_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 	u8 value;
 
+	/*
+	 * BBP was enabled after firmware was loaded,
+	 * but we need to reactivate it now.
+	 */
+	rt2x00usb_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
+	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	msleep(1);
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2800usb_bbp_read(rt2x00dev, 0, &value);
 		if ((value != 0xff) && (value != 0x00))
@@ -1823,8 +1849,12 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN,
 			   (rt2x00dev->rx->usb_maxpacket == 512));
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_TIMEOUT, 128);
-	/* FIXME: Calculate this value based on Aggregation defines */
-	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_LIMIT, 21);
+	/*
+	 * Total room for RX frames in kilobytes, PBF might still exceed
+	 * this limit so reduce the number to prevent errors.
+	 */
+	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_LIMIT,
+			   ((RX_ENTRIES * DATA_FRAME_SIZE) / 1024) - 3);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_EN, 1);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_TX_BULK_EN, 1);
 	rt2x00usb_register_write(rt2x00dev, USB_DMA_CFG, reg);
@@ -1835,11 +1865,6 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
 	/*
-	 * Send signal to firmware during boot time.
-	 */
-	rt2800usb_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0xff, 0, 0);
-
-	/*
 	 * Initialize LED control
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED1, &word);
@@ -1879,8 +1904,6 @@ static void rt2800usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 static int rt2800usb_set_state(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
 {
-	rt2x00usb_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0);
-
 	if (state == STATE_AWAKE)
 		rt2800usb_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 0);
 	else
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
index 8e4291d..61a8be6 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -1375,6 +1375,10 @@ struct mac_iveiv_entry {
  * H2M_MAILBOX_CID:
  */
 #define H2M_MAILBOX_CID			0x7014
+#define H2M_MAILBOX_CID_CMD0		FIELD32(0x000000ff)
+#define H2M_MAILBOX_CID_CMD1		FIELD32(0x0000ff00)
+#define H2M_MAILBOX_CID_CMD2		FIELD32(0x00ff0000)
+#define H2M_MAILBOX_CID_CMD3		FIELD32(0xff000000)
 
 /*
  * H2M_MAILBOX_STATUS:
@@ -1715,6 +1719,7 @@ struct mac_iveiv_entry {
 #define MCU_SLEEP			0x30
 #define MCU_WAKEUP			0x31
 #define MCU_RADIO_OFF			0x35
+#define MCU_CURRENT			0x36
 #define MCU_LED				0x50
 #define MCU_LED_STRENGTH		0x51
 #define MCU_LED_1			0x52
@@ -1723,6 +1728,12 @@ struct mac_iveiv_entry {
 #define MCU_RADAR			0x60
 #define MCU_BOOT_SIGNAL			0x72
 #define MCU_BBP_SIGNAL			0x80
+#define MCU_POWER_SAVE			0x83
+
+/*
+ * MCU mailbox tokens
+ */
+#define TOKEN_WAKUP			3
 
 /*
  * DMA descriptor defines.
-- 
1.6.2.3

