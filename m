Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1639 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab0DKMb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 08:31:26 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/9] rt2x00: Align RT chipset definitions with vendor driver.
Date: Sun, 11 Apr 2010 14:31:09 +0200
Message-Id: <1270989075-2267-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only include definitions for RT chipsets that are also used inside the
Ralink vendor drivers.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   43 ++++++++++++++++++++++++++++--
 drivers/net/wireless/rt2x00/rt2800lib.c |   22 +++++-----------
 drivers/net/wireless/rt2x00/rt2x00.h    |    7 ++---
 3 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 455dc3f..4d5871b 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1537,6 +1537,15 @@ struct mac_iveiv_entry {
  */
 
 /*
+ * RFCSR 1:
+ */
+#define RFCSR1_RF_BLOCK_EN		FIELD8(0x01)
+#define RFCSR1_RX0_PD			FIELD8(0x04)
+#define RFCSR1_TX0_PD			FIELD8(0x08)
+#define RFCSR1_RX1_PD			FIELD8(0x10)
+#define RFCSR1_TX1_PD			FIELD8(0x20)
+
+/*
  * RFCSR 6:
  */
 #define RFCSR6_R1			FIELD8(0x03)
@@ -1553,12 +1562,26 @@ struct mac_iveiv_entry {
 #define RFCSR12_TX_POWER		FIELD8(0x1f)
 
 /*
+ * RFCSR 15:
+ */
+#define RFCSR15_TX_LO2_EN		FIELD8(0x08)
+
+/*
  * RFCSR 17:
  */
-#define RFCSR17_R1			FIELD8(0x07)
-#define RFCSR17_R2			FIELD8(0x08)
-#define RFCSR17_R3			FIELD8(0x20)
+#define RFCSR17_TXMIXER_GAIN		FIELD8(0x07)
+#define RFCSR17_TX_LO1_EN		FIELD8(0x08)
+#define RFCSR17_R			FIELD8(0x20)
 
+/*
+ * RFCSR 20:
+ */
+#define RFCSR20_RX_LO1_EN		FIELD8(0x08)
+
+/*
+ * RFCSR 21:
+ */
+#define RFCSR21_RX_LO2_EN		FIELD8(0x08)
 
 /*
  * RFCSR 22:
@@ -1571,6 +1594,14 @@ struct mac_iveiv_entry {
 #define RFCSR23_FREQ_OFFSET		FIELD8(0x7f)
 
 /*
+ * RFCSR 27:
+ */
+#define RFCSR27_R1			FIELD8(0x03)
+#define RFCSR27_R2			FIELD8(0x04)
+#define RFCSR27_R3			FIELD8(0x30)
+#define RFCSR27_R4			FIELD8(0x40)
+
+/*
  * RFCSR 30:
  */
 #define RFCSR30_RF_CALIBRATION		FIELD8(0x80)
@@ -1710,6 +1741,12 @@ struct mac_iveiv_entry {
 #define EEPROM_RSSI_BG2_LNA_A1		FIELD16(0xff00)
 
 /*
+ * EEPROM TXMIXER GAIN BG offset (note overlaps with EEPROM RSSI BG2).
+ */
+#define EEPROM_TXMIXER_GAIN_BG		0x0024
+#define EEPROM_TXMIXER_GAIN_BG_VAL	FIELD16(0x0007)
+
+/*
  * EEPROM RSSI A offset
  */
 #define EEPROM_RSSI_A			0x0025
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 394c8e4..2ab8884 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1209,10 +1209,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
 	if ((rt2x00_rt(rt2x00dev, RT2872) &&
 	     (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION)) ||
-	    rt2x00_rt(rt2x00dev, RT2880) ||
 	    rt2x00_rt(rt2x00dev, RT2883) ||
-	    rt2x00_rt(rt2x00dev, RT2890) ||
-	    rt2x00_rt(rt2x00dev, RT3052) ||
 	    (rt2x00_rt(rt2x00dev, RT3070) &&
 	     (rt2x00_rev(rt2x00dev) < RT3070_VERSION)))
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
@@ -1503,6 +1500,12 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	    (rt2x00_rev(rt2x00dev) > RT2860D_VERSION))
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 
+	if (rt2x00_rt(rt2x00dev, RT2872)) {
+		rt2800_bbp_write(rt2x00dev, 31, 0x08);
+		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
+		rt2800_bbp_write(rt2x00dev, 80, 0x08);
+	}
+
 	if (rt2x00_is_usb(rt2x00dev) &&
 	    rt2x00_rt(rt2x00dev, RT3070) &&
 	    (rt2x00_rev(rt2x00dev) == RT3070_VERSION)) {
@@ -1511,12 +1514,6 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3052)) {
-		rt2800_bbp_write(rt2x00dev, 31, 0x08);
-		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
-		rt2800_bbp_write(rt2x00dev, 80, 0x08);
-	}
-
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
@@ -1772,9 +1769,7 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
 		   rt2x00_rt(rt2x00dev, RT2870) ||
 		   rt2x00_rt(rt2x00dev, RT2872) ||
-		   rt2x00_rt(rt2x00dev, RT2880) ||
-		   (rt2x00_rt(rt2x00dev, RT2883) &&
-		    (rt2x00_rev(rt2x00dev) < RT2883_VERSION))) {
+		   rt2x00_rt(rt2x00dev, RT2872)) {
 		/*
 		 * There is a max of 2 RX streams for RT28x0 series
 		 */
@@ -1879,10 +1874,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00_rt(rt2x00dev, RT2860) &&
 	    !rt2x00_rt(rt2x00dev, RT2870) &&
 	    !rt2x00_rt(rt2x00dev, RT2872) &&
-	    !rt2x00_rt(rt2x00dev, RT2880) &&
 	    !rt2x00_rt(rt2x00dev, RT2883) &&
-	    !rt2x00_rt(rt2x00dev, RT2890) &&
-	    !rt2x00_rt(rt2x00dev, RT3052) &&
 	    !rt2x00_rt(rt2x00dev, RT3070) &&
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
 	    !rt2x00_rt(rt2x00dev, RT3090) &&
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d9daa9c..16aa850 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -177,16 +177,15 @@ struct rt2x00_chip {
 #define RT2573		0x2573
 #define RT2860		0x2860	/* 2.4GHz PCI/CB */
 #define RT2870		0x2870
-#define RT2872		0x2872
-#define RT2880		0x2880	/* WSOC */
+#define RT2872		0x2872	/* WSOC */
 #define RT2883		0x2883	/* WSOC */
-#define RT2890		0x2890	/* 2.4GHz PCIe */
-#define RT3052		0x3052	/* WSOC */
 #define RT3070		0x3070
 #define RT3071		0x3071
 #define RT3090		0x3090	/* 2.4GHz PCIe */
 #define RT3390		0x3390
 #define RT3572		0x3572
+#define RT3593		0x3593	/* PCIe */
+#define RT3883		0x3883	/* WSOC */
 
 	u16 rf;
 	u16 rev;
-- 
1.7.0.4

