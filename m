Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:14625 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbXJ0LZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:13 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1035411fkz
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:12 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/21] rt2x00: Split rt61/rt73 antenna selection into RX and TX antenna
Date: Sat, 27 Oct 2007 13:39:57 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271339.58096.IvDoorn@gmail.com> (sfid-20071027_124132_439064_BEF2B389)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on investigation of the legacy drivers, I have made the
following assumptions of the antenna setup:
 - R77 is the TX antenna configuration
 - RF2529 fetches default antenna selection from NIC eeprom word

With these assumptions we can change the antenna configuration
to correctly read both antenna setup values and correctly
configure the antenna. And we can now also configure the antenna
for RF2529 without a double antenna.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |  215 +++++++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt61pci.h |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c |   58 +++++++--
 drivers/net/wireless/rt2x00/rt73usb.h |    2 +-
 4 files changed, 189 insertions(+), 88 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0830000..7f0665e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -424,6 +424,29 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE,
 			  !rt2x00_rf(&rt2x00dev->chip, RF5225));
 
+	/*
+	 * Configure the TX antenna.
+	 */
+	switch (ant->tx) {
+	case ANTENNA_A:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
+		break;
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
+	case ANTENNA_B:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
+		break;
+	}
+
+	/*
+	 * Configure the RX antenna.
+	 */
 	switch (ant->rx) {
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
@@ -433,11 +456,6 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-
-		if (rt2x00dev->curr_hwmode == HWMODE_A)
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
-		else
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
 		break;
 	case ANTENNA_SW_DIVERSITY:
 		/*
@@ -449,11 +467,6 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-
-		if (rt2x00dev->curr_hwmode == HWMODE_A)
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-		else
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
 		break;
 	}
 
@@ -478,13 +491,35 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
 			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
+	/*
+	 * Configure the TX antenna.
+	 */
+	switch (ant->tx) {
+	case ANTENNA_A:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
+		break;
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
+	case ANTENNA_B:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
+		break;
+	}
+
+	/*
+	 * Configure the RX antenna.
+	 */
 	switch (ant->rx) {
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-		rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
 		break;
 	case ANTENNA_SW_DIVERSITY:
 		/*
@@ -495,7 +530,6 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-		rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
 		break;
 	}
 
@@ -530,74 +564,75 @@ static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
 	u8 r3;
 	u8 r4;
 	u8 r77;
+	u8 rx_ant;
 
 	rt61pci_bbp_read(rt2x00dev, 3, &r3);
 	rt61pci_bbp_read(rt2x00dev, 4, &r4);
 	rt61pci_bbp_read(rt2x00dev, 77, &r77);
+
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
+	rx_ant = !!(rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED) & 2);
 
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
 
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_ENABLE_DIVERSITY) &&
-	    rt2x00_get_field16(eeprom, EEPROM_NIC_TX_DIVERSITY)) {
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
-		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 1);
-		rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 1);
-	} else if (rt2x00_get_field16(eeprom, EEPROM_NIC_ENABLE_DIVERSITY)) {
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED) >= 2) {
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-			rt61pci_bbp_write(rt2x00dev, 77, r77);
-		}
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-		rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 1);
-	} else if (!rt2x00_get_field16(eeprom, EEPROM_NIC_ENABLE_DIVERSITY) &&
-		   rt2x00_get_field16(eeprom, EEPROM_NIC_TX_DIVERSITY)) {
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
-		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
+	/*
+	 * Configure the TX antenna.
+	 */
+	switch (ant->tx) {
+	case ANTENNA_A:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
+		break;
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
+	case ANTENNA_B:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
+		break;
+	}
 
-		switch (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED)) {
-		case 0:
-			rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 1);
-			break;
-		case 1:
-			rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 0);
-			break;
-		case 2:
-			rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 0);
-			break;
-		case 3:
-			rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 1);
-			break;
-		}
-	} else if (!rt2x00_get_field16(eeprom, EEPROM_NIC_ENABLE_DIVERSITY) &&
-		   !rt2x00_get_field16(eeprom, EEPROM_NIC_TX_DIVERSITY)) {
+	/*
+	 * Configure the RX antenna.
+	 */
+	switch (ant->rx) {
+	case ANTENNA_A:
+		rt61pci_config_antenna_2529_rx(rt2x00dev, 0, rx_ant);
+		break;
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
+	case ANTENNA_B:
+		rt61pci_config_antenna_2529_rx(rt2x00dev, 1, rx_ant);
+		break;
+	}
+
+	/*
+	 * FIXME: We are using the default antenna setup to
+	 * determine the remaining settings. This because we
+	 * need to know what the EEPROM indicated.
+	 * It is however unclear if this is required, and overall
+	 * using the default antenna settings here is incorrect
+	 * since mac80211 might have told us to use fixed settings.
+	 */
+	if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+	else
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
 
-		switch (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED)) {
-		case 0:
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
-			rt61pci_bbp_write(rt2x00dev, 77, r77);
-			rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 1);
-			break;
-		case 1:
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
-			rt61pci_bbp_write(rt2x00dev, 77, r77);
-			rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 0);
-			break;
-		case 2:
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-			rt61pci_bbp_write(rt2x00dev, 77, r77);
-			rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 0);
-			break;
-		case 3:
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-			rt61pci_bbp_write(rt2x00dev, 77, r77);
-			rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 1);
-			break;
-		}
-	}
+	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
+			  (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY) &&
+			  (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY));
 
+	rt61pci_bbp_write(rt2x00dev, 77, r77);
 	rt61pci_bbp_write(rt2x00dev, 3, r3);
 	rt61pci_bbp_write(rt2x00dev, 4, r4);
 }
@@ -2019,6 +2054,12 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
+	 * Determine number of antenna's.
+	 */
+	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_NUM) == 2)
+		__set_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags);
+
+	/*
 	 * Identify default antenna configuration.
 	 */
 	rt2x00dev->default_ant.tx =
@@ -2033,12 +2074,6 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags);
 
 	/*
-	 * Determine number of antenna's.
-	 */
-	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_NUM) == 2)
-		__set_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags);
-
-	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
 #ifdef CONFIG_RT61PCI_RFKILL
@@ -2066,6 +2101,38 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
 
 	/*
+	 * When working with a RF2529 chip without double antenna
+	 * the antenna settings should be gathered from the NIC
+	 * eeprom word.
+	 */
+	if (rt2x00_rf(&rt2x00dev->chip, RF2529) &&
+	    !test_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags)) {
+		switch (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED)) {
+		case 0:
+			rt2x00dev->default_ant.tx = ANTENNA_B;
+			rt2x00dev->default_ant.rx = ANTENNA_A;
+			break;
+		case 1:
+			rt2x00dev->default_ant.tx = ANTENNA_B;
+			rt2x00dev->default_ant.rx = ANTENNA_B;
+			break;
+		case 2:
+			rt2x00dev->default_ant.tx = ANTENNA_A;
+			rt2x00dev->default_ant.rx = ANTENNA_A;
+			break;
+		case 3:
+			rt2x00dev->default_ant.tx = ANTENNA_A;
+			rt2x00dev->default_ant.rx = ANTENNA_B;
+			break;
+		}
+
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_TX_DIVERSITY))
+			rt2x00dev->default_ant.tx = ANTENNA_SW_DIVERSITY;
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_ENABLE_DIVERSITY))
+			rt2x00dev->default_ant.rx = ANTENNA_SW_DIVERSITY;
+	}
+
+	/*
 	 * Store led settings, for correct led behaviour.
 	 * If the eeprom value is invalid,
 	 * switch to default led mode.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 6721d7d..ba51016 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1083,7 +1083,7 @@ struct hw_pairwise_ta_entry {
 /*
  * R77
  */
-#define BBP_R77_PAIR			FIELD8(0x03)
+#define BBP_R77_TX_ANTENNA		FIELD8(0x03)
 
 /*
  * RF registers
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 048f9f4..d1119e3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -408,6 +408,29 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
 
+	/*
+	 * Configure the TX antenna.
+	 */
+	switch (ant->tx) {
+	case ANTENNA_A:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
+		break;
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
+	case ANTENNA_B:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
+		break;
+	}
+
+	/*
+	 * Configure the RX antenna.
+	 */
 	switch (ant->rx) {
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
@@ -417,11 +440,6 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-
-		if (rt2x00dev->curr_hwmode == HWMODE_A)
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
-		else
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
 		break;
 	case ANTENNA_SW_DIVERSITY:
 		/*
@@ -433,11 +451,6 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-
-		if (rt2x00dev->curr_hwmode == HWMODE_A)
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
-		else
-			rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
 		break;
 	}
 
@@ -461,13 +474,35 @@ static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
 			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
+	/*
+	 * Configure the TX antenna.
+	 */
+	switch (ant->tx) {
+	case ANTENNA_A:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
+		break;
+	case ANTENNA_SW_DIVERSITY:
+	case ANTENNA_HW_DIVERSITY:
+		/*
+		 * NOTE: We should never come here because rt2x00lib is
+		 * supposed to catch this and send us the correct antenna
+		 * explicitely. However we are nog going to bug about this.
+		 * Instead, just default to antenna B.
+		 */
+	case ANTENNA_B:
+		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
+		break;
+	}
+
+	/*
+	 * Configure the RX antenna.
+	 */
 	switch (ant->rx) {
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-		rt2x00_set_field8(&r77, BBP_R77_PAIR, 3);
 		break;
 	case ANTENNA_SW_DIVERSITY:
 		/*
@@ -478,7 +513,6 @@ static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 		 */
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-		rt2x00_set_field8(&r77, BBP_R77_PAIR, 0);
 		break;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index f095151..13f479c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -719,7 +719,7 @@ struct hw_pairwise_ta_entry {
 /*
  * R77
  */
-#define BBP_R77_PAIR			FIELD8(0x03)
+#define BBP_R77_TX_ANTENNA		FIELD8(0x03)
 
 /*
  * RF registers
-- 
1.5.3.4

