Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:4082 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXJ0LZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:26 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973044nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:25 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/21] rt2x00: Rework rt61 antenna selection.
Date: Sat, 27 Oct 2007 13:41:53 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271341.53905.IvDoorn@gmail.com> (sfid-20071027_124130_228393_B761C4A6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

This patch changes rt61 antenna selection again. It helps at least with the
rt61 pci card in my box, I hope I haven't broken behaviour on other RF chips.
RF 2529 antenna setup is incomplete, we need to at code for diversity when we
figure out how it is done properly.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |  143 +++++++++------------------------
 drivers/net/wireless/rt2x00/rt61pci.h |   10 ++-
 2 files changed, 46 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index d540525..0839946 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -422,40 +422,24 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	rt61pci_bbp_read(rt2x00dev, 77, &r77);
 
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE,
-			  !rt2x00_rf(&rt2x00dev->chip, RF5225));
-
-	/*
-	 * Configure the TX antenna.
-	 */
-	switch (ant->tx) {
-	case ANTENNA_A:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
-		break;
-	case ANTENNA_SW_DIVERSITY:
-	case ANTENNA_HW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
-	case ANTENNA_B:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
-		break;
-	}
+			  rt2x00_rf(&rt2x00dev->chip, RF5325));
 
 	/*
 	 * Configure the RX antenna.
 	 */
 	switch (ant->rx) {
 	case ANTENNA_HW_DIVERSITY:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 2);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
 				  (rt2x00dev->curr_hwmode != HWMODE_A));
 		break;
 	case ANTENNA_A:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
+		if (rt2x00dev->curr_hwmode == HWMODE_A)
+			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
+		else
+			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		break;
 	case ANTENNA_SW_DIVERSITY:
 		/*
@@ -465,8 +449,12 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 		 * Instead, just default to antenna B.
 		 */
 	case ANTENNA_B:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
+		if (rt2x00dev->curr_hwmode == HWMODE_A)
+			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
+		else
+			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		break;
 	}
 
@@ -487,39 +475,20 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 	rt61pci_bbp_read(rt2x00dev, 77, &r77);
 
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE,
-			  !rt2x00_rf(&rt2x00dev->chip, RF2527));
+			  rt2x00_rf(&rt2x00dev->chip, RF2529));
 	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
 			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
 	/*
-	 * Configure the TX antenna.
-	 */
-	switch (ant->tx) {
-	case ANTENNA_A:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
-		break;
-	case ANTENNA_SW_DIVERSITY:
-	case ANTENNA_HW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
-	case ANTENNA_B:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
-		break;
-	}
-
-	/*
 	 * Configure the RX antenna.
 	 */
 	switch (ant->rx) {
 	case ANTENNA_HW_DIVERSITY:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 2);
 		break;
 	case ANTENNA_A:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
+		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		break;
 	case ANTENNA_SW_DIVERSITY:
 		/*
@@ -529,7 +498,8 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 		 * Instead, just default to antenna B.
 		 */
 	case ANTENNA_B:
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
+		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		break;
 	}
 
@@ -545,16 +515,13 @@ static void rt61pci_config_antenna_2529_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
 
-	if (p1 != 0xff) {
-		rt2x00_set_field32(&reg, MAC_CSR13_BIT4, !!p1);
-		rt2x00_set_field32(&reg, MAC_CSR13_BIT12, 0);
-		rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
-	}
-	if (p2 != 0xff) {
-		rt2x00_set_field32(&reg, MAC_CSR13_BIT3, !p2);
-		rt2x00_set_field32(&reg, MAC_CSR13_BIT11, 0);
-		rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
-	}
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT4, p1);
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT12, 0);
+
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT3, !p2);
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT11, 0);
+
+	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
 }
 
 static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
@@ -570,37 +537,18 @@ static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
 	rt61pci_bbp_read(rt2x00dev, 4, &r4);
 	rt61pci_bbp_read(rt2x00dev, 77, &r77);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
-	rx_ant = !!(rt2x00_get_field16(eeprom, EEPROM_NIC_TX_RX_FIXED) & 2);
-
-	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
-
-	/*
-	 * Configure the TX antenna.
+	/* FIXME: Antenna selection for the rf 2529 is very confusing in the
+	 * legacy driver. The code below should be ok for non-diversity setups.
 	 */
-	switch (ant->tx) {
-	case ANTENNA_A:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 0);
-		break;
-	case ANTENNA_SW_DIVERSITY:
-	case ANTENNA_HW_DIVERSITY:
-		/*
-		 * NOTE: We should never come here because rt2x00lib is
-		 * supposed to catch this and send us the correct antenna
-		 * explicitely. However we are nog going to bug about this.
-		 * Instead, just default to antenna B.
-		 */
-	case ANTENNA_B:
-		rt2x00_set_field8(&r77, BBP_R77_TX_ANTENNA, 3);
-		break;
-	}
 
 	/*
 	 * Configure the RX antenna.
 	 */
 	switch (ant->rx) {
 	case ANTENNA_A:
-		rt61pci_config_antenna_2529_rx(rt2x00dev, 0, rx_ant);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
+		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
+		rt61pci_config_antenna_2529_rx(rt2x00dev, 0, 0);
 		break;
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
@@ -611,27 +559,12 @@ static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
 		 * Instead, just default to antenna B.
 		 */
 	case ANTENNA_B:
-		rt61pci_config_antenna_2529_rx(rt2x00dev, 1, rx_ant);
+		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
+		rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
+		rt61pci_config_antenna_2529_rx(rt2x00dev, 1, 1);
 		break;
 	}
 
-	/*
-	 * FIXME: We are using the default antenna setup to
-	 * determine the remaining settings. This because we
-	 * need to know what the EEPROM indicated.
-	 * It is however unclear if this is required, and overall
-	 * using the default antenna settings here is incorrect
-	 * since mac80211 might have told us to use fixed settings.
-	 */
-	if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
-	else
-		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
-
-	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-			  (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY) &&
-			  (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY));
-
 	rt61pci_bbp_write(rt2x00dev, 77, r77);
 	rt61pci_bbp_write(rt2x00dev, 3, r3);
 	rt61pci_bbp_write(rt2x00dev, 4, r4);
@@ -676,8 +609,6 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	unsigned int i;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, PHY_CSR0, &reg);
-
 	if (rt2x00dev->curr_hwmode == HWMODE_A) {
 		sel = antenna_sel_a;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
@@ -686,15 +617,17 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 		lna = test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
 	}
 
+	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
+		rt61pci_bbp_write(rt2x00dev, sel[i].word, sel[i].value[lna]);
+
+	rt2x00pci_register_read(rt2x00dev, PHY_CSR0, &reg);
+
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG,
 			   (rt2x00dev->curr_hwmode == HWMODE_B ||
 			    rt2x00dev->curr_hwmode == HWMODE_G));
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A,
 			   (rt2x00dev->curr_hwmode == HWMODE_A));
 
-	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
-		rt61pci_bbp_write(rt2x00dev, sel[i].word, sel[i].value[lna]);
-
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR0, reg);
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index ba51016..50d9f6a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1077,13 +1077,19 @@ struct hw_pairwise_ta_entry {
  * R4: RX antenna control
  * FRAME_END: 1 - DPDT, 0 - SPDT (Only valid for 802.11G, RF2527 & RF2529)
  */
-#define BBP_R4_RX_ANTENNA		FIELD8(0x03)
+
+/*
+ * ANTENNA_CONTROL semantics (guessed):
+ * 0x1: Software controlled antenna switching (fixed or SW diversity)
+ * 0x2: Hardware diversity.
+ */
+#define BBP_R4_RX_ANTENNA_CONTROL	FIELD8(0x03)
 #define BBP_R4_RX_FRAME_END		FIELD8(0x20)
 
 /*
  * R77
  */
-#define BBP_R77_TX_ANTENNA		FIELD8(0x03)
+#define BBP_R77_RX_ANTENNA		FIELD8(0x03)
 
 /*
  * RF registers
-- 
1.5.3.4

