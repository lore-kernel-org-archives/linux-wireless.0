Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbXIPMIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:06 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:06 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 9/24] rt2x00: Rework RT61 and RT73 Antenna handling
Date: Sun, 16 Sep 2007 14:18:31 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.33490.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework rt61 and rt73 antenna handling because in case
of rt73 it looked ugly, and in case of rt61 it looked worse
and didn't contain all code for rf2529 chips.

Split the code up over several functions, and make it
a bit more manageble.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   24 ++-
 drivers/net/wireless/rt2x00/rt2500pci.c |   23 ++-
 drivers/net/wireless/rt2x00/rt2500usb.c |   23 ++-
 drivers/net/wireless/rt2x00/rt2x00reg.h |    3 +-
 drivers/net/wireless/rt2x00/rt61pci.c   |  321 ++++++++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt61pci.h   |    8 +-
 drivers/net/wireless/rt2x00/rt73usb.c   |  224 ++++++++++++----------
 drivers/net/wireless/rt2x00/rt73usb.h   |    3 +-
 8 files changed, 417 insertions(+), 212 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 22834a5..5a7fc18 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -494,22 +494,34 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Configure the TX antenna.
 	 */
-	if (antenna_tx == ANTENNA_DIVERSITY)
+	switch (antenna_tx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r1, BBP_R1_TX_ANTENNA, 1);
-	else if (antenna_tx == ANTENNA_A)
+		break;
+	case ANTENNA_A:
 		rt2x00_set_field8(&r1, BBP_R1_TX_ANTENNA, 0);
-	else if (antenna_tx == ANTENNA_B)
+		break;
+	case ANTENNA_B:
 		rt2x00_set_field8(&r1, BBP_R1_TX_ANTENNA, 2);
+		break;
+	}
 
 	/*
 	 * Configure the RX antenna.
 	 */
-	if (antenna_rx == ANTENNA_DIVERSITY)
+	switch (antenna_rx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-	else if (antenna_rx == ANTENNA_A)
+		break;
+	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 0);
-	else if (antenna_rx == ANTENNA_B)
+		break;
+	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		break;
+	}
 
 	rt2400pci_bbp_write(rt2x00dev, 4, r4);
 	rt2400pci_bbp_write(rt2x00dev, 1, r1);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index be82f2d..d24ea61 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -532,29 +532,40 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Configure the TX antenna.
 	 */
-	if (antenna_tx == ANTENNA_DIVERSITY) {
+	switch (antenna_tx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 2);
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 2);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 2);
-	} else if (antenna_tx == ANTENNA_A) {
+		break;
+	case ANTENNA_A:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 0);
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 0);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 0);
-	} else if (antenna_tx == ANTENNA_B) {
+		break;
+	case ANTENNA_B:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 2);
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 2);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 2);
+		break;
 	}
 
 	/*
 	 * Configure the RX antenna.
 	 */
-	if (antenna_rx == ANTENNA_DIVERSITY)
+	switch (antenna_rx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 2);
-	else if (antenna_rx == ANTENNA_A)
+		break;
+	case ANTENNA_A:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 0);
-	else if (antenna_rx == ANTENNA_B)
+		break;
+	case ANTENNA_B:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 2);
+		break;
+	}
 
 	/*
 	 * RT2525E and RT5222 need to flip TX I/Q
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c4f12cd..f344c2a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -494,29 +494,40 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Configure the TX antenna.
 	 */
-	if (antenna_tx == ANTENNA_DIVERSITY) {
+	switch (antenna_tx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 1);
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK, 1);
 		rt2x00_set_field16(&csr6, PHY_CSR6_OFDM, 1);
-	} else if (antenna_tx == ANTENNA_A) {
+		break;
+	case ANTENNA_A:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 0);
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK, 0);
 		rt2x00_set_field16(&csr6, PHY_CSR6_OFDM, 0);
-	} else if (antenna_tx == ANTENNA_B) {
+		break;
+	case ANTENNA_B:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 2);
 		rt2x00_set_field16(&csr5, PHY_CSR5_CCK, 2);
 		rt2x00_set_field16(&csr6, PHY_CSR6_OFDM, 2);
+		break;
 	}
 
 	/*
 	 * Configure the RX antenna.
 	 */
-	if (antenna_rx == ANTENNA_DIVERSITY)
+	switch (antenna_rx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 1);
-	else if (antenna_rx == ANTENNA_A)
+		break;
+	case ANTENNA_A:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 0);
-	else if (antenna_rx == ANTENNA_B)
+		break;
+	case ANTENNA_B:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 2);
+		break;
+	}
 
 	/*
 	 * RT2525E and RT5222 need to flip TX I/Q
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 690356f..5e7b63e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -41,9 +41,10 @@ enum TX_STATUS {
  * Antenna values
  */
 enum antenna {
-	ANTENNA_DIVERSITY = 0,
+	ANTENNA_SW_DIVERSITY = 0,
 	ANTENNA_A = 1,
 	ANTENNA_B = 2,
+	ANTENNA_HW_DIVERSITY = 3,
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b94f005..6199606 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -536,125 +536,262 @@ static void rt61pci_config_txpower(struct rt2x00_dev *rt2x00dev,
 	rt61pci_rf_write(rt2x00dev, 4, rf.rf4);
 }
 
-static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
-				   const int antenna_tx, const int antenna_rx)
+static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
+				      const int antenna_tx,
+				      const int antenna_rx)
 {
-	u32 reg;
 	u8 r3;
 	u8 r4;
 	u8 r77;
 
-	rt2x00pci_register_read(rt2x00dev, PHY_CSR0, &reg);
+	rt61pci_bbp_read(rt2x00dev, 3, &r3);
+	rt61pci_bbp_read(rt2x00dev, 4, &r4);
+	rt61pci_bbp_read(rt2x00dev, 77, &r77);
 
-	if (rt2x00dev->curr_hwmode == HWMODE_A) {
-		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
-			rt61pci_bbp_write(rt2x00dev, 96, 0x78);
-			rt61pci_bbp_write(rt2x00dev, 104, 0x48);
-			rt61pci_bbp_write(rt2x00dev, 75, 0x80);
-			rt61pci_bbp_write(rt2x00dev, 86, 0x80);
-			rt61pci_bbp_write(rt2x00dev, 88, 0x80);
-		} else {
-			rt61pci_bbp_write(rt2x00dev, 96, 0x58);
-			rt61pci_bbp_write(rt2x00dev, 104, 0x38);
-			rt61pci_bbp_write(rt2x00dev, 75, 0xfe);
-			rt61pci_bbp_write(rt2x00dev, 86, 0xfe);
-			rt61pci_bbp_write(rt2x00dev, 88, 0xfe);
-		}
-		rt61pci_bbp_write(rt2x00dev, 35, 0x60);
-		rt61pci_bbp_write(rt2x00dev, 97, 0x58);
-		rt61pci_bbp_write(rt2x00dev, 98, 0x58);
+	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE,
+			  !rt2x00_rf(&rt2x00dev->chip, RF5225));
 
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 0);
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 1);
-	} else {
-		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags)) {
-			rt61pci_bbp_write(rt2x00dev, 96, 0x68);
-			rt61pci_bbp_write(rt2x00dev, 104, 0x3c);
-			rt61pci_bbp_write(rt2x00dev, 75, 0x80);
-			rt61pci_bbp_write(rt2x00dev, 86, 0x80);
-			rt61pci_bbp_write(rt2x00dev, 88, 0x80);
-		} else {
-			rt61pci_bbp_write(rt2x00dev, 96, 0x48);
-			rt61pci_bbp_write(rt2x00dev, 104, 0x2c);
-			rt61pci_bbp_write(rt2x00dev, 75, 0xfe);
-			rt61pci_bbp_write(rt2x00dev, 86, 0xfe);
-			rt61pci_bbp_write(rt2x00dev, 88, 0xfe);
-		}
-		rt61pci_bbp_write(rt2x00dev, 35, 0x50);
-		rt61pci_bbp_write(rt2x00dev, 97, 0x48);
-		rt61pci_bbp_write(rt2x00dev, 98, 0x48);
+	switch (antenna_rx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
+				  !!(rt2x00dev->curr_hwmode != HWMODE_A));
+		break;
+	case ANTENNA_A:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
 
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 1);
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 0);
+		if (rt2x00dev->curr_hwmode == HWMODE_A)
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
+		else
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
+		break;
+	case ANTENNA_B:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
+
+		if (rt2x00dev->curr_hwmode == HWMODE_A)
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
+		else
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
+		break;
 	}
 
-	rt2x00pci_register_write(rt2x00dev, PHY_CSR0, reg);
+	rt61pci_bbp_write(rt2x00dev, 77, r77);
+	rt61pci_bbp_write(rt2x00dev, 3, r3);
+	rt61pci_bbp_write(rt2x00dev, 4, r4);
+}
+
+static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
+				      const int antenna_tx,
+				      const int antenna_rx)
+{
+	u8 r3;
+	u8 r4;
+	u8 r77;
 
 	rt61pci_bbp_read(rt2x00dev, 3, &r3);
 	rt61pci_bbp_read(rt2x00dev, 4, &r4);
 	rt61pci_bbp_read(rt2x00dev, 77, &r77);
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF2527))
-		rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
+	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE,
+			  !rt2x00_rf(&rt2x00dev->chip, RF2527));
+	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
+			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
-		if (antenna_rx == ANTENNA_DIVERSITY) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
-			if (rt2x00dev->curr_hwmode != HWMODE_A)
-				rt2x00_set_field8(&r4, BBP_R4_RX_BG_MODE, 1);
-		} else if (antenna_rx == ANTENNA_A) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-			if (rt2x00dev->curr_hwmode == HWMODE_A)
-				rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
-			else
-				rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-			rt61pci_bbp_write(rt2x00dev, 77, r77);
-		} else if (antenna_rx == ANTENNA_B) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-			if (rt2x00dev->curr_hwmode == HWMODE_A)
-				rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-			else
-				rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
+	switch (antenna_rx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		break;
+	case ANTENNA_A:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
+		break;
+	case ANTENNA_B:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
+		break;
+	}
+
+	rt61pci_bbp_write(rt2x00dev, 77, r77);
+	rt61pci_bbp_write(rt2x00dev, 3, r3);
+	rt61pci_bbp_write(rt2x00dev, 4, r4);
+}
+
+static void rt61pci_config_antenna_2529_rx(struct rt2x00_dev *rt2x00dev,
+					   const int p1, const int p2)
+{
+	u32 reg;
+
+	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
+
+	if (p1 != 0xff) {
+		rt2x00_set_field32(&reg, MAC_CSR13_BIT4, !!p1);
+		rt2x00_set_field32(&reg, MAC_CSR13_BIT12, 0);
+		rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
+	}
+	if (p2 != 0xff) {
+		rt2x00_set_field32(&reg, MAC_CSR13_BIT3, !p2);
+		rt2x00_set_field32(&reg, MAC_CSR13_BIT11, 0);
+		rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
+	}
+}
+
+static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
+					const int antenna_tx,
+					const int antenna_rx)
+{
+	u16 eeprom;
+	u8 r3;
+	u8 r4;
+	u8 r77;
+
+	rt61pci_bbp_read(rt2x00dev, 3, &r3);
+	rt61pci_bbp_read(rt2x00dev, 4, &r4);
+	rt61pci_bbp_read(rt2x00dev, 77, &r77);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
+
+	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
+
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_ENABLE_DIVERSITY) &&
+	    rt2x00_get_field16(eeprom, EEPROM_NIC_TX_DIVERSITY)) {
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 1);
+		rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 1);
+	} else if (rt2x00_get_field16(eeprom, EEPROM_NIC_ENABLE_DIVERSITY)) {
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED) >= 2) {
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
 			rt61pci_bbp_write(rt2x00dev, 77, r77);
 		}
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2527) ||
-		   (rt2x00_rf(&rt2x00dev->chip, RF2529) &&
-		    test_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags))) {
-		if (antenna_rx == ANTENNA_DIVERSITY) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
-			rt2x00_set_field8(&r4, BBP_R4_RX_BG_MODE, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-					  test_bit(CONFIG_FRAME_TYPE,
-						   &rt2x00dev->flags));
-		} else if (antenna_rx == ANTENNA_A) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_BG_MODE, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-					  test_bit(CONFIG_FRAME_TYPE,
-						   &rt2x00dev->flags));
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 1);
+	} else if (!rt2x00_get_field16(eeprom, EEPROM_NIC_ENABLE_DIVERSITY) &&
+		   rt2x00_get_field16(eeprom, EEPROM_NIC_TX_DIVERSITY)) {
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
+
+		switch (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED)) {
+		case 0:
+			rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 1);
+			break;
+		case 1:
+			rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 0);
+			break;
+		case 2:
+			rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 0);
+			break;
+		case 3:
+			rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 1);
+			break;
+		}
+	} else if (!rt2x00_get_field16(eeprom, EEPROM_NIC_ENABLE_DIVERSITY) &&
+		   !rt2x00_get_field16(eeprom, EEPROM_NIC_TX_DIVERSITY)) {
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
+
+		switch (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED)) {
+		case 0:
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
 			rt61pci_bbp_write(rt2x00dev, 77, r77);
-		} else if (antenna_rx == ANTENNA_B) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_BG_MODE, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-					  test_bit(CONFIG_FRAME_TYPE,
-						   &rt2x00dev->flags));
+			rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 1);
+			break;
+		case 1:
 			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
 			rt61pci_bbp_write(rt2x00dev, 77, r77);
+			rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 0);
+			break;
+		case 2:
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
+			rt61pci_bbp_write(rt2x00dev, 77, r77);
+			rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 0);
+			break;
+		case 3:
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
+			rt61pci_bbp_write(rt2x00dev, 77, r77);
+			rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 1);
+			break;
 		}
 	}
 
+	rt61pci_bbp_write(rt2x00dev, 3, r3);
+	rt61pci_bbp_write(rt2x00dev, 4, r4);
+}
+
+struct antenna_sel {
+	u8 word;
 	/*
-	 * TODO: RF2529 with another antenna value then 2 are ignored.
-	 * The legacy driver is unclear whether in those cases there is
-	 * a possibility to switch antenna.
+	 * value[0] -> non-LNA
+	 * value[1] -> LNA
 	 */
+	u8 value[2];
+};
 
-	rt61pci_bbp_write(rt2x00dev, 3, r3);
-	rt61pci_bbp_write(rt2x00dev, 4, r4);
+static const struct antenna_sel antenna_sel_a[] = {
+	{ 96,  { 0x58, 0x78 } },
+	{ 104, { 0x38, 0x48 } },
+	{ 75,  { 0xfe, 0x80 } },
+	{ 86,  { 0xfe, 0x80 } },
+	{ 88,  { 0xfe, 0x80 } },
+	{ 35,  { 0x60, 0x60 } },
+	{ 97,  { 0x58, 0x58 } },
+	{ 98,  { 0x58, 0x58 } },
+};
+
+static const struct antenna_sel antenna_sel_bg[] = {
+	{ 96,  { 0x48, 0x68 } },
+	{ 104, { 0x2c, 0x3c } },
+	{ 75,  { 0xfe, 0x80 } },
+	{ 86,  { 0xfe, 0x80 } },
+	{ 88,  { 0xfe, 0x80 } },
+	{ 35,  { 0x50, 0x50 } },
+	{ 97,  { 0x48, 0x48 } },
+	{ 98,  { 0x48, 0x48 } },
+};
+
+static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
+				   const int antenna_tx, const int antenna_rx)
+{
+	const struct antenna_sel *sel;
+	unsigned int lna;
+	unsigned int i;
+	u32 reg;
+
+	rt2x00pci_register_read(rt2x00dev, PHY_CSR0, &reg);
+
+	if (rt2x00dev->curr_hwmode == HWMODE_A) {
+		sel = antenna_sel_a;
+		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
+
+		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 0);
+		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 1);
+	} else {
+		sel = antenna_sel_bg;
+		lna = test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
+
+		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 1);
+		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 0);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
+		rt61pci_bbp_write(rt2x00dev, sel[i].word, sel[i].value[lna]);
+
+	rt2x00pci_register_write(rt2x00dev, PHY_CSR0, reg);
+
+	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
+	    rt2x00_rf(&rt2x00dev->chip, RF5325))
+		rt61pci_config_antenna_5x(rt2x00dev, antenna_tx, antenna_rx);
+	else if (rt2x00_rf(&rt2x00dev->chip, RF2527))
+		rt61pci_config_antenna_2x(rt2x00dev, antenna_tx, antenna_rx);
+	else if (rt2x00_rf(&rt2x00dev->chip, RF2529)) {
+		if (test_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags))
+			rt61pci_config_antenna_2x(rt2x00dev, antenna_tx,
+						  antenna_rx);
+		else
+			rt61pci_config_antenna_2529(rt2x00dev, antenna_tx,
+						    antenna_rx);
+	}
 }
 
 static void rt61pci_config_duration(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index c47dd15..bd3e283 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -332,6 +332,11 @@ struct hw_pairwise_ta_entry {
 #define MAC_CSR13_BIT5			FIELD32(0x00000020)
 #define MAC_CSR13_BIT6			FIELD32(0x00000040)
 #define MAC_CSR13_BIT7			FIELD32(0x00000080)
+#define MAC_CSR13_BIT8			FIELD32(0x00000100)
+#define MAC_CSR13_BIT9			FIELD32(0x00000200)
+#define MAC_CSR13_BIT10			FIELD32(0x00000400)
+#define MAC_CSR13_BIT11			FIELD32(0x00000800)
+#define MAC_CSR13_BIT12			FIELD32(0x00001000)
 
 /*
  * MAC_CSR14: LED control register.
@@ -1002,8 +1007,7 @@ struct hw_pairwise_ta_entry {
  * FRAME_END: 1 - DPDT, 0 - SPDT (Only valid for 802.11G, RF2527 & RF2529)
  */
 #define BBP_R4_RX_ANTENNA		FIELD8(0x03)
-#define BBP_R4_RX_FRAME_END		FIELD8(0x10)
-#define BBP_R4_RX_BG_MODE		FIELD8(0x20)
+#define BBP_R4_RX_FRAME_END		FIELD8(0x20)
 
 /*
  * R77
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 703e4e1..4aef5af 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -508,126 +508,156 @@ static void rt73usb_config_txpower(struct rt2x00_dev *rt2x00dev,
 	rt73usb_rf_write(rt2x00dev, 4, rf.rf4);
 }
 
-static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
-				   const int antenna_tx, const int antenna_rx)
+static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
+				      const int antenna_tx,
+				      const int antenna_rx)
 {
-	u32 reg;
 	u8 r3;
 	u8 r4;
 	u8 r77;
 
-	rt73usb_register_read(rt2x00dev, PHY_CSR0, &reg);
+	rt73usb_bbp_read(rt2x00dev, 3, &r3);
+	rt73usb_bbp_read(rt2x00dev, 4, &r4);
+	rt73usb_bbp_read(rt2x00dev, 77, &r77);
 
-	if (rt2x00dev->curr_hwmode == HWMODE_A) {
-		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
-			rt73usb_bbp_write(rt2x00dev, 96, 0x78);
-			rt73usb_bbp_write(rt2x00dev, 104, 0x48);
-			rt73usb_bbp_write(rt2x00dev, 75, 0x80);
-			rt73usb_bbp_write(rt2x00dev, 86, 0x80);
-			rt73usb_bbp_write(rt2x00dev, 88, 0x80);
-		} else {
-			rt73usb_bbp_write(rt2x00dev, 96, 0x58);
-			rt73usb_bbp_write(rt2x00dev, 104, 0x38);
-			rt73usb_bbp_write(rt2x00dev, 75, 0xfe);
-			rt73usb_bbp_write(rt2x00dev, 86, 0xfe);
-			rt73usb_bbp_write(rt2x00dev, 88, 0xfe);
-		}
-		rt73usb_bbp_write(rt2x00dev, 35, 0x60);
-		rt73usb_bbp_write(rt2x00dev, 97, 0x58);
-		rt73usb_bbp_write(rt2x00dev, 98, 0x58);
+	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
 
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 0);
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 1);
-	} else {
-		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags)) {
-			rt73usb_bbp_write(rt2x00dev, 96, 0x68);
-			rt73usb_bbp_write(rt2x00dev, 104, 0x3c);
-			rt73usb_bbp_write(rt2x00dev, 75, 0x80);
-			rt73usb_bbp_write(rt2x00dev, 86, 0x80);
-			rt73usb_bbp_write(rt2x00dev, 88, 0x80);
-		} else {
-			rt73usb_bbp_write(rt2x00dev, 96, 0x48);
-			rt73usb_bbp_write(rt2x00dev, 104, 0x2c);
-			rt73usb_bbp_write(rt2x00dev, 75, 0xfe);
-			rt73usb_bbp_write(rt2x00dev, 86, 0xfe);
-			rt73usb_bbp_write(rt2x00dev, 88, 0xfe);
-		}
-		rt73usb_bbp_write(rt2x00dev, 35, 0x50);
-		rt73usb_bbp_write(rt2x00dev, 97, 0x48);
-		rt73usb_bbp_write(rt2x00dev, 98, 0x48);
+	switch (antenna_rx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
+				  !!(rt2x00dev->curr_hwmode != HWMODE_A));
+		break;
+	case ANTENNA_A:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
 
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 1);
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 0);
+		if (rt2x00dev->curr_hwmode == HWMODE_A)
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
+		else
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
+		break;
+	case ANTENNA_B:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
+
+		if (rt2x00dev->curr_hwmode == HWMODE_A)
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
+		else
+			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
+		break;
 	}
 
-	rt73usb_register_write(rt2x00dev, PHY_CSR0, reg);
+	rt73usb_bbp_write(rt2x00dev, 77, r77);
+	rt73usb_bbp_write(rt2x00dev, 3, r3);
+	rt73usb_bbp_write(rt2x00dev, 4, r4);
+}
+
+static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
+				      const int antenna_tx,
+				      const int antenna_rx)
+{
+	u8 r3;
+	u8 r4;
+	u8 r77;
 
 	rt73usb_bbp_read(rt2x00dev, 3, &r3);
 	rt73usb_bbp_read(rt2x00dev, 4, &r4);
 	rt73usb_bbp_read(rt2x00dev, 77, &r77);
 
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
+	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
+			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF5226) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5225)) {
-		if (antenna_rx == ANTENNA_DIVERSITY) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
-			if (rt2x00dev->curr_hwmode != HWMODE_A)
-				rt2x00_set_field8(&r4, BBP_R4_RX_BG_MODE, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-					  test_bit(CONFIG_FRAME_TYPE,
-						   &rt2x00dev->flags));
-		} else if (antenna_rx == ANTENNA_A) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-					  test_bit(CONFIG_FRAME_TYPE,
-						   &rt2x00dev->flags));
-			if (rt2x00dev->curr_hwmode == HWMODE_A)
-				rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
-			else
-				rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-			rt73usb_bbp_write(rt2x00dev, 77, r77);
-		} else if (antenna_rx == ANTENNA_B) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-					  test_bit(CONFIG_FRAME_TYPE,
-						   &rt2x00dev->flags));
-			if (rt2x00dev->curr_hwmode == HWMODE_A)
-				rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-			else
-				rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
-			rt73usb_bbp_write(rt2x00dev, 77, r77);
-		}
-	} else if (rt2x00_rf(&rt2x00dev->chip, RF2528) ||
-		   rt2x00_rf(&rt2x00dev->chip, RF2527)) {
-		if (antenna_rx == ANTENNA_DIVERSITY) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
-			rt2x00_set_field8(&r4, BBP_R4_RX_BG_MODE, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-					  test_bit(CONFIG_FRAME_TYPE,
-						   &rt2x00dev->flags));
-		} else if (antenna_rx == ANTENNA_A) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_BG_MODE, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-					  test_bit(CONFIG_FRAME_TYPE,
-						   &rt2x00dev->flags));
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-			rt73usb_bbp_write(rt2x00dev, 77, r77);
-		} else if (antenna_rx == ANTENNA_B) {
-			rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_BG_MODE, 1);
-			rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-					  test_bit(CONFIG_FRAME_TYPE,
-						   &rt2x00dev->flags));
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
-		}
+	switch (antenna_rx) {
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		break;
+	case ANTENNA_A:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
+		break;
+	case ANTENNA_B:
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
+		break;
 	}
 
+	rt73usb_bbp_write(rt2x00dev, 77, r77);
 	rt73usb_bbp_write(rt2x00dev, 3, r3);
 	rt73usb_bbp_write(rt2x00dev, 4, r4);
 }
 
+struct antenna_sel {
+	u8 word;
+	/*
+	 * value[0] -> non-LNA
+	 * value[1] -> LNA
+	 */
+	u8 value[2];
+};
+
+static const struct antenna_sel antenna_sel_a[] = {
+	{ 96,  { 0x58, 0x78 } },
+	{ 104, { 0x38, 0x48 } },
+	{ 75,  { 0xfe, 0x80 } },
+	{ 86,  { 0xfe, 0x80 } },
+	{ 88,  { 0xfe, 0x80 } },
+	{ 35,  { 0x60, 0x60 } },
+	{ 97,  { 0x58, 0x58 } },
+	{ 98,  { 0x58, 0x58 } },
+};
+
+static const struct antenna_sel antenna_sel_bg[] = {
+	{ 96,  { 0x48, 0x68 } },
+	{ 104, { 0x2c, 0x3c } },
+	{ 75,  { 0xfe, 0x80 } },
+	{ 86,  { 0xfe, 0x80 } },
+	{ 88,  { 0xfe, 0x80 } },
+	{ 35,  { 0x50, 0x50 } },
+	{ 97,  { 0x48, 0x48 } },
+	{ 98,  { 0x48, 0x48 } },
+};
+
+static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
+				   const int antenna_tx, const int antenna_rx)
+{
+	const struct antenna_sel *sel;
+	unsigned int lna;
+	unsigned int i;
+	u32 reg;
+
+	rt73usb_register_read(rt2x00dev, PHY_CSR0, &reg);
+
+	if (rt2x00dev->curr_hwmode == HWMODE_A) {
+		sel = antenna_sel_a;
+		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
+
+		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 0);
+		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 1);
+	} else {
+		sel = antenna_sel_bg;
+		lna = test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
+
+		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 1);
+		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 0);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
+		rt73usb_bbp_write(rt2x00dev, sel[i].word, sel[i].value[lna]);
+
+	rt73usb_register_write(rt2x00dev, PHY_CSR0, reg);
+
+	if (rt2x00_rf(&rt2x00dev->chip, RF5226) ||
+	    rt2x00_rf(&rt2x00dev->chip, RF5225))
+		rt73usb_config_antenna_5x(rt2x00dev, antenna_tx, antenna_rx);
+	else if (rt2x00_rf(&rt2x00dev->chip, RF2528) ||
+		 rt2x00_rf(&rt2x00dev->chip, RF2527))
+		rt73usb_config_antenna_2x(rt2x00dev, antenna_tx, antenna_rx);
+}
+
 static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
 				    const int short_slot_time,
 				    const int beacon_int)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index ec2632f..660a134 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -656,8 +656,7 @@ struct hw_pairwise_ta_entry {
  * FRAME_END: 1 - DPDT, 0 - SPDT (Only valid for 802.11G, RF2527 & RF2529)
  */
 #define BBP_R4_RX_ANTENNA		FIELD8(0x03)
-#define BBP_R4_RX_FRAME_END		FIELD8(0x10)
-#define BBP_R4_RX_BG_MODE		FIELD8(0x20)
+#define BBP_R4_RX_FRAME_END		FIELD8(0x20)
 
 /*
  * R77
-- 
1.5.3
