Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:20547 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXJMOKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 10:10:37 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1250541mue
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 07:10:36 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/11] rt2x00: Cleanup if-statements
Date: Sat, 13 Oct 2007 16:26:42 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710131621.05173.IvDoorn@gmail.com>
In-Reply-To: <200710131621.05173.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200710131626.42828.IvDoorn@gmail.com> (sfid-20071013_151052_208239_1FE761AB)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup if-statements for simple 1/0 register field values.

This also fixes a endian bug in rt2500usb when working
with the PHY_CSR2 initialization. As well as a bug
in the enabling of the LED in rt73usb.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   28 ++++++-----------
 drivers/net/wireless/rt2x00/rt2500pci.c |   28 ++++++-----------
 drivers/net/wireless/rt2x00/rt2500usb.c |   22 +++++--------
 drivers/net/wireless/rt2x00/rt2500usb.h |   13 +++++++-
 drivers/net/wireless/rt2x00/rt2x00.h    |   12 ++++----
 drivers/net/wireless/rt2x00/rt61pci.c   |   50 +++++++++++++++----------------
 drivers/net/wireless/rt2x00/rt73usb.c   |   28 ++++++++---------
 7 files changed, 83 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 46201ec..59f7128 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -524,18 +524,10 @@ static void rt2400pci_enable_led(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00_set_field32(&reg, LEDCSR_ON_PERIOD, 70);
 	rt2x00_set_field32(&reg, LEDCSR_OFF_PERIOD, 30);
-
-	if (rt2x00dev->led_mode == LED_MODE_TXRX_ACTIVITY) {
-		rt2x00_set_field32(&reg, LEDCSR_LINK, 1);
-		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, 0);
-	} else if (rt2x00dev->led_mode == LED_MODE_ASUS) {
-		rt2x00_set_field32(&reg, LEDCSR_LINK, 0);
-		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, 1);
-	} else {
-		rt2x00_set_field32(&reg, LEDCSR_LINK, 1);
-		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, 1);
-	}
-
+	rt2x00_set_field32(&reg, LEDCSR_LINK,
+			   (rt2x00dev->led_mode != LED_MODE_ASUS));
+	rt2x00_set_field32(&reg, LEDCSR_ACTIVITY,
+			   (rt2x00dev->led_mode != LED_MODE_TXRX_ACTIVITY));
 	rt2x00pci_register_write(rt2x00dev, LEDCSR, reg);
 }
 
@@ -1110,12 +1102,12 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	}
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	if (queue == IEEE80211_TX_QUEUE_DATA0)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
-	else if (queue == IEEE80211_TX_QUEUE_DATA1)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
-	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, 1);
+	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO,
+			   (queue == IEEE80211_TX_QUEUE_DATA0));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
+			   (queue == IEEE80211_TX_QUEUE_DATA1));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
+			   (queue == IEEE80211_TX_QUEUE_AFTER_BEACON));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index aecfaa8..c9bb389 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -563,18 +563,10 @@ static void rt2500pci_enable_led(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00_set_field32(&reg, LEDCSR_ON_PERIOD, 70);
 	rt2x00_set_field32(&reg, LEDCSR_OFF_PERIOD, 30);
-
-	if (rt2x00dev->led_mode == LED_MODE_TXRX_ACTIVITY) {
-		rt2x00_set_field32(&reg, LEDCSR_LINK, 1);
-		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, 0);
-	} else if (rt2x00dev->led_mode == LED_MODE_ASUS) {
-		rt2x00_set_field32(&reg, LEDCSR_LINK, 0);
-		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, 1);
-	} else {
-		rt2x00_set_field32(&reg, LEDCSR_LINK, 1);
-		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, 1);
-	}
-
+	rt2x00_set_field32(&reg, LEDCSR_LINK,
+			   (rt2x00dev->led_mode != LED_MODE_ASUS));
+	rt2x00_set_field32(&reg, LEDCSR_ACTIVITY,
+			   (rt2x00dev->led_mode != LED_MODE_TXRX_ACTIVITY));
 	rt2x00pci_register_write(rt2x00dev, LEDCSR, reg);
 }
 
@@ -1244,12 +1236,12 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	}
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	if (queue == IEEE80211_TX_QUEUE_DATA0)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
-	else if (queue == IEEE80211_TX_QUEUE_DATA1)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
-	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
-		rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, 1);
+	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO,
+			   (queue == IEEE80211_TX_QUEUE_DATA0));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
+			   (queue == IEEE80211_TX_QUEUE_DATA1));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
+			   (queue == IEEE80211_TX_QUEUE_AFTER_BEACON));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 9e42745..7e5fd91 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -517,18 +517,10 @@ static void rt2500usb_enable_led(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_write(rt2x00dev, MAC_CSR21, reg);
 
 	rt2500usb_register_read(rt2x00dev, MAC_CSR20, &reg);
-
-	if (rt2x00dev->led_mode == LED_MODE_TXRX_ACTIVITY) {
-		rt2x00_set_field16(&reg, MAC_CSR20_LINK, 1);
-		rt2x00_set_field16(&reg, MAC_CSR20_ACTIVITY, 0);
-	} else if (rt2x00dev->led_mode == LED_MODE_ASUS) {
-		rt2x00_set_field16(&reg, MAC_CSR20_LINK, 0);
-		rt2x00_set_field16(&reg, MAC_CSR20_ACTIVITY, 1);
-	} else {
-		rt2x00_set_field16(&reg, MAC_CSR20_LINK, 1);
-		rt2x00_set_field16(&reg, MAC_CSR20_ACTIVITY, 1);
-	}
-
+	rt2x00_set_field16(&reg, MAC_CSR20_LINK,
+			   (rt2x00dev->led_mode != LED_MODE_ASUS));
+	rt2x00_set_field16(&reg, MAC_CSR20_ACTIVITY,
+			   (rt2x00dev->led_mode != LED_MODE_TXRX_ACTIVITY));
 	rt2500usb_register_write(rt2x00dev, MAC_CSR20, reg);
 }
 
@@ -765,9 +757,11 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_get_rev(&rt2x00dev->chip) >= RT2570_VERSION_C) {
 		rt2500usb_register_read(rt2x00dev, PHY_CSR2, &reg);
-		reg &= ~0x0002;
+		rt2x00_set_field16(&reg, PHY_CSR2_LNA, 0);
 	} else {
-		reg = 0x3002;
+		reg = 0;
+		rt2x00_set_field16(&reg, PHY_CSR2_LNA, 1);
+		rt2x00_set_field16(&reg, PHY_CSR2_LNA_MODE, 3);
 	}
 	rt2500usb_register_write(rt2x00dev, PHY_CSR2, reg);
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index b18d56e..2741840 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -430,10 +430,21 @@
 
 /*
  * MAC configuration registers.
+ */
+
+/*
  * PHY_CSR2: TX MAC configuration.
- * PHY_CSR3: RX MAC configuration.
+ * NOTE: Both register fields are complete dummy,
+ * documentation and legacy drivers are unclear un
+ * what this register means or what fields exists.
  */
 #define PHY_CSR2			0x04c4
+#define PHY_CSR2_LNA			FIELD16(0x0002)
+#define PHY_CSR2_LNA_MODE		FIELD16(0x3000)
+
+/*
+ * PHY_CSR3: RX MAC configuration.
+ */
 #define PHY_CSR3			0x04c6
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index c9df8f1..e3fbcb8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -133,20 +133,20 @@
  */
 static inline int is_rts_frame(u16 fc)
 {
-	return !!(((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-		  ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_RTS));
+	return (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
+		((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_RTS));
 }
 
 static inline int is_cts_frame(u16 fc)
 {
-	return !!(((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-		  ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_CTS));
+	return (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
+		((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_CTS));
 }
 
 static inline int is_probe_resp(u16 fc)
 {
-	return !!(((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-		  ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP));
+	return (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+		((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP));
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 48b9a70..82a58cb 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -428,7 +428,7 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-				  !!(rt2x00dev->curr_hwmode != HWMODE_A));
+				  (rt2x00dev->curr_hwmode != HWMODE_A));
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
@@ -646,17 +646,17 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00dev->curr_hwmode == HWMODE_A) {
 		sel = antenna_sel_a;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
-
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 0);
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 1);
 	} else {
 		sel = antenna_sel_bg;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
-
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 1);
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 0);
 	}
 
+	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG,
+			   (rt2x00dev->curr_hwmode == HWMODE_B ||
+			    rt2x00dev->curr_hwmode == HWMODE_G));
+	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A,
+			   (rt2x00dev->curr_hwmode == HWMODE_A));
+
 	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
 		rt61pci_bbp_write(rt2x00dev, sel[i].word, sel[i].value[lna]);
 
@@ -727,7 +727,6 @@ static void rt61pci_config(struct rt2x00_dev *rt2x00dev,
 static void rt61pci_enable_led(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
-	u16 led_reg;
 	u8 arg0;
 	u8 arg1;
 
@@ -736,15 +735,14 @@ static void rt61pci_enable_led(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MAC_CSR14_OFF_PERIOD, 30);
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR14, reg);
 
-	led_reg = rt2x00dev->led_reg;
-	rt2x00_set_field16(&led_reg, MCU_LEDCS_RADIO_STATUS, 1);
-	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A)
-		rt2x00_set_field16(&led_reg, MCU_LEDCS_LINK_A_STATUS, 1);
-	else
-		rt2x00_set_field16(&led_reg, MCU_LEDCS_LINK_BG_STATUS, 1);
+	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_RADIO_STATUS, 1);
+	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_A_STATUS,
+			   (rt2x00dev->rx_status.phymode == MODE_IEEE80211A));
+	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_BG_STATUS,
+			   (rt2x00dev->rx_status.phymode != MODE_IEEE80211A));
 
-	arg0 = led_reg & 0xff;
-	arg1 = (led_reg >> 8) & 0xff;
+	arg0 = rt2x00dev->led_reg & 0xff;
+	arg1 = (rt2x00dev->led_reg >> 8) & 0xff;
 
 	rt61pci_mcu_request(rt2x00dev, MCU_LED, 0xff, arg0, arg1);
 }
@@ -1655,16 +1653,16 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	}
 
 	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
-	if (queue == IEEE80211_TX_QUEUE_DATA0)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, 1);
-	else if (queue == IEEE80211_TX_QUEUE_DATA1)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, 1);
-	else if (queue == IEEE80211_TX_QUEUE_DATA2)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, 1);
-	else if (queue == IEEE80211_TX_QUEUE_DATA3)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, 1);
-	else if (queue == IEEE80211_TX_QUEUE_DATA4)
-		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_MGMT, 1);
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0,
+			   (queue == IEEE80211_TX_QUEUE_DATA0));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1,
+			   (queue == IEEE80211_TX_QUEUE_DATA1));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2,
+			   (queue == IEEE80211_TX_QUEUE_DATA2));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3,
+			   (queue == IEEE80211_TX_QUEUE_DATA3));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_MGMT,
+			   (queue == IEEE80211_TX_QUEUE_DATA4));
 	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 3ffb5cd..14e2b2d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -200,8 +200,8 @@ rf_write:
 	 * all others contain 20 bits.
 	 */
 	rt2x00_set_field32(&reg, PHY_CSR4_NUMBER_OF_BITS,
-			   20 + !!(rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-				   rt2x00_rf(&rt2x00dev->chip, RF2527)));
+			   20 + (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
+				 rt2x00_rf(&rt2x00dev->chip, RF2527)));
 	rt2x00_set_field32(&reg, PHY_CSR4_IF_SELECT, 0);
 	rt2x00_set_field32(&reg, PHY_CSR4_BUSY, 1);
 
@@ -412,7 +412,7 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-				  !!(rt2x00dev->curr_hwmode != HWMODE_A));
+				  (rt2x00dev->curr_hwmode != HWMODE_A));
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
@@ -531,17 +531,17 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00dev->curr_hwmode == HWMODE_A) {
 		sel = antenna_sel_a;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
-
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 0);
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 1);
 	} else {
 		sel = antenna_sel_bg;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
-
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG, 1);
-		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 0);
 	}
 
+	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG,
+			   (rt2x00dev->curr_hwmode == HWMODE_B ||
+			    rt2x00dev->curr_hwmode == HWMODE_G));
+	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A,
+			   (rt2x00dev->curr_hwmode == HWMODE_A));
+
 	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
 		rt73usb_bbp_write(rt2x00dev, sel[i].word, sel[i].value[lna]);
 
@@ -614,12 +614,10 @@ static void rt73usb_enable_led(struct rt2x00_dev *rt2x00dev)
 	rt73usb_register_write(rt2x00dev, MAC_CSR14, reg);
 
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_RADIO_STATUS, 1);
-	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A)
-		rt2x00_set_field16(&rt2x00dev->led_reg,
-				   MCU_LEDCS_LINK_A_STATUS, 1);
-	else
-		rt2x00_set_field16(&rt2x00dev->led_reg,
-				   MCU_LEDCS_LINK_BG_STATUS, 1);
+	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_A_STATUS,
+			   (rt2x00dev->rx_status.phymode == MODE_IEEE80211A));
+	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_BG_STATUS,
+			   (rt2x00dev->rx_status.phymode != MODE_IEEE80211A));
 
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_LED_CONTROL, 0x0000,
 				    rt2x00dev->led_reg, REGISTER_TIMEOUT);
-- 
1.5.3.4

