Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:26815 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYHFN7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 09:59:12 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1136191nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 06:59:10 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] rt2x00: Move lna_gain calculation to config() callback
Date: Wed, 6 Aug 2008 16:22:17 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200808061617.44704.IvDoorn@gmail.com> <200808061618.31229.IvDoorn@gmail.com>
In-Reply-To: <200808061618.31229.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808061622.17181.IvDoorn@gmail.com> (sfid-20080806_155916_858147_A9CDEEA0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can optimize lna calculation in IRQ context by
calculating most of the value during the config() callback
when most of the value is actually influenced.

This will be required later by rt2800pci and rt2800usb as
well, since they need the lna_gain value during config().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h  |    5 +++
 drivers/net/wireless/rt2x00/rt61pci.c |   48 +++++++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt73usb.c |   41 ++++++++++++++++++---------
 3 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 7476a4e..6a14b60 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -804,6 +804,11 @@ struct rt2x00_dev {
 	u32 *rf;
 
 	/*
+	 * LNA gain
+	 */
+	short lna_gain;
+
+	/*
 	 * USB Max frame size (for rt2500usb & rt73usb).
 	 */
 	u16 usb_maxpacket;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 87012f8..0fcc456 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -638,6 +638,30 @@ static void rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
 }
 
+
+static void rt61pci_config_lna_gain(struct rt2x00_dev *rt2x00dev,
+				    struct rt2x00lib_conf *libconf)
+{
+	u16 eeprom;
+	short lna_gain = 0;
+
+	if (libconf->band == IEEE80211_BAND_2GHZ) {
+		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
+			lna_gain += 14;
+
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_BG, &eeprom);
+		lna_gain -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_BG_1);
+	} else {
+		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags))
+			lna_gain += 14;
+
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_A, &eeprom);
+		lna_gain -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_A_1);
+	}
+
+	rt2x00dev->lna_gain = lna_gain;
+}
+
 static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 				   const int basic_rate_mask)
 {
@@ -956,6 +980,9 @@ static void rt61pci_config(struct rt2x00_dev *rt2x00dev,
 			   struct rt2x00lib_conf *libconf,
 			   const unsigned int flags)
 {
+	/* Always recalculate LNA gain before changing configuration */
+	rt61pci_config_lna_gain(rt2x00dev, libconf);
+
 	if (flags & CONFIG_UPDATE_PHYMODE)
 		rt61pci_config_phymode(rt2x00dev, libconf->basic_rates);
 	if (flags & CONFIG_UPDATE_CHANNEL)
@@ -1883,40 +1910,27 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
  */
 static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 {
-	u16 eeprom;
-	u8 offset;
+	u8 offset = rt2x00dev->lna_gain;
 	u8 lna;
 
 	lna = rt2x00_get_field32(rxd_w1, RXD_W1_RSSI_LNA);
 	switch (lna) {
 	case 3:
-		offset = 90;
+		offset += 90;
 		break;
 	case 2:
-		offset = 74;
+		offset += 74;
 		break;
 	case 1:
-		offset = 64;
+		offset += 64;
 		break;
 	default:
 		return 0;
 	}
 
 	if (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ) {
-		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags))
-			offset += 14;
-
 		if (lna == 3 || lna == 2)
 			offset += 10;
-
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_A, &eeprom);
-		offset -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_A_1);
-	} else {
-		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
-			offset += 14;
-
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_BG, &eeprom);
-		offset -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_BG_1);
 	}
 
 	return rt2x00_get_field32(rxd_w1, RXD_W1_RSSI_AGC) * 2 - offset;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 1bd6b3f..4f2eb90 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -664,6 +664,26 @@ static void rt73usb_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt73usb_register_write(rt2x00dev, TXRX_CSR4, reg);
 }
 
+static void rt73usb_config_lna_gain(struct rt2x00_dev *rt2x00dev,
+				    struct rt2x00lib_conf *libconf)
+{
+	u16 eeprom;
+	short lna_gain = 0;
+
+	if (libconf->band == IEEE80211_BAND_2GHZ) {
+		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
+			lna_gain += 14;
+
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_BG, &eeprom);
+		lna_gain -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_BG_1);
+	} else {
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_A, &eeprom);
+		lna_gain -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_A_1);
+	}
+
+	rt2x00dev->lna_gain = lna_gain;
+}
+
 static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 				   const int basic_rate_mask)
 {
@@ -918,6 +938,9 @@ static void rt73usb_config(struct rt2x00_dev *rt2x00dev,
 			   struct rt2x00lib_conf *libconf,
 			   const unsigned int flags)
 {
+	/* Always recalculate LNA gain before changing configuration */
+	rt73usb_config_lna_gain(rt2x00dev, libconf);
+
 	if (flags & CONFIG_UPDATE_PHYMODE)
 		rt73usb_config_phymode(rt2x00dev, libconf->basic_rates);
 	if (flags & CONFIG_UPDATE_CHANNEL)
@@ -1644,20 +1667,19 @@ static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
  */
 static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 {
-	u16 eeprom;
-	u8 offset;
+	u8 offset = rt2x00dev->lna_gain;
 	u8 lna;
 
 	lna = rt2x00_get_field32(rxd_w1, RXD_W1_RSSI_LNA);
 	switch (lna) {
 	case 3:
-		offset = 90;
+		offset += 90;
 		break;
 	case 2:
-		offset = 74;
+		offset += 74;
 		break;
 	case 1:
-		offset = 64;
+		offset += 64;
 		break;
 	default:
 		return 0;
@@ -1673,15 +1695,6 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 			else if (lna == 2)
 				offset += 8;
 		}
-
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_A, &eeprom);
-		offset -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_A_1);
-	} else {
-		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
-			offset += 14;
-
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_BG, &eeprom);
-		offset -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_BG_1);
 	}
 
 	return rt2x00_get_field32(rxd_w1, RXD_W1_RSSI_AGC) * 2 - offset;
-- 
1.5.6.1

