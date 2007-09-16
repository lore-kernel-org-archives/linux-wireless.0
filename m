Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:38346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbXIPMIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:04 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1643781wah
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:04 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 8/24] rt2x00: Reduce LNA flags
Date: Sun, 16 Sep 2007 14:18:27 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.29076.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because rt73usb has LNA in a single variable
and rt61pci has LNA for A and BG modes we currently
had 3 flags for LNA.

Reduce this by setting LNA_A and LNA_BG if rt73usb has
LNA enabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h  |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 40dd52b..02a5adf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -520,7 +520,7 @@ struct rt2x00_dev {
 #define DEVICE_SUPPORT_HW_BUTTON	12
 #define CONFIG_FRAME_TYPE		13
 #define CONFIG_RF_SEQUENCE		14
-#define CONFIG_EXTERNAL_LNA		15
+/* Hole: Add new Flag here */
 #define CONFIG_EXTERNAL_LNA_A		16
 #define CONFIG_EXTERNAL_LNA_BG		17
 #define CONFIG_DOUBLE_ANTENNA		18
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index feb211d..703e4e1 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -519,7 +519,7 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	rt73usb_register_read(rt2x00dev, PHY_CSR0, &reg);
 
 	if (rt2x00dev->curr_hwmode == HWMODE_A) {
-		if (test_bit(CONFIG_EXTERNAL_LNA, &rt2x00dev->flags)) {
+		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
 			rt73usb_bbp_write(rt2x00dev, 96, 0x78);
 			rt73usb_bbp_write(rt2x00dev, 104, 0x48);
 			rt73usb_bbp_write(rt2x00dev, 75, 0x80);
@@ -539,7 +539,7 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 0);
 		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 1);
 	} else {
-		if (test_bit(CONFIG_EXTERNAL_LNA, &rt2x00dev->flags)) {
+		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags)) {
 			rt73usb_bbp_write(rt2x00dev, 96, 0x68);
 			rt73usb_bbp_write(rt2x00dev, 104, 0x3c);
 			rt73usb_bbp_write(rt2x00dev, 75, 0x80);
@@ -792,7 +792,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 		low_bound = 0x28;
 		up_bound = 0x48;
 
-		if (test_bit(CONFIG_EXTERNAL_LNA, &rt2x00dev->flags)) {
+		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
 			low_bound += 0x10;
 			up_bound += 0x10;
 		}
@@ -808,7 +808,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 			up_bound = 0x1c;
 		}
 
-		if (test_bit(CONFIG_EXTERNAL_LNA, &rt2x00dev->flags)) {
+		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags)) {
 			low_bound += 0x14;
 			up_bound += 0x10;
 		}
@@ -1336,7 +1336,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 	}
 
 	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A) {
-		if (test_bit(CONFIG_EXTERNAL_LNA, &rt2x00dev->flags)) {
+		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
 			if (lna == 3 || lna == 2)
 				offset += 10;
 		} else {
@@ -1349,7 +1349,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_A, &eeprom);
 		offset -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_A_1);
 	} else {
-		if (test_bit(CONFIG_EXTERNAL_LNA, &rt2x00dev->flags))
+		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
 			offset += 14;
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_BG, &eeprom);
@@ -1544,8 +1544,10 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
 
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA))
-		__set_bit(CONFIG_EXTERNAL_LNA, &rt2x00dev->flags);
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA)) {
+		__set_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
+		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
+	}
 
 	/*
 	 * Store led settings, for correct led behaviour.
-- 
1.5.3
