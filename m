Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:34423 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbZADTVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 14:21:16 -0500
Received: by ewy10 with SMTP id 10so7545608ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2009 11:21:13 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
Date: Sun, 4 Jan 2009 20:21:10 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901042021.10904.IvDoorn@gmail.com> (sfid-20090104_202135_840070_E0B394B8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2500pci and rt2500usb contain a special field in the EEPROM
which indicates which regulatory domain the card belongs to.
This code can easily be translated into a country code which
we can send as alpha2 hint for CRDA.

Please note that most cards will have 0xffff as EEPROM value,
and thus do not provide a regulatory hint through the EEPROM.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 76f016d..98d3c6c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1512,6 +1512,17 @@ static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+static const char* reg_domain_map[] = {
+	"US",	/* REGION_FCC: 1-11 */
+	"CA",	/* REGION_IC: 1-11 */
+	"DE",	/* REGION_ETSI: 1-13 */
+	"ES",	/* REGION_SPAIN: 10-11 */
+	"FR",	/* REGION_FRANCE: 10-13 */
+	"JP",	/* REGION_MKK: 14 */
+	"JP",	/* REGION_MKK1: 1-14 */
+	"IL",	/* REGION_ISRAEL: 3-9 */
+};
+
 static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -1577,6 +1588,16 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
+	 * Read Geography information, if it contains valid data we should
+	 * send the regulatory hint as alpha2 value to cfg80211.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_GEOGRAPHY, &eeprom);
+	if (eeprom != 0xffff) {
+		value = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO);
+		regulatory_hint(rt2x00dev->hw->wiphy, reg_domain_map[value]);
+	}
+
+	/*
 	 * Read the RSSI <-> dBm offset information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 2bc4e46..7f364dd 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1546,6 +1546,17 @@ static int rt2500usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+static const char* reg_domain_map[] = {
+	"US",	/* REGION_FCC: 1-11 */
+	"CA",	/* REGION_IC: 1-11 */
+	"DE",	/* REGION_ETSI: 1-13 */
+	"ES",	/* REGION_SPAIN: 10-11 */
+	"FR",	/* REGION_FRANCE: 10-13 */
+	"JP",	/* REGION_MKK: 14 */
+	"JP",	/* REGION_MKK1: 1-14 */
+	"IL",	/* REGION_ISRAEL: 3-9 */
+};
+
 static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u16 reg;
@@ -1626,6 +1637,16 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
+	 * Read Geography information, if it contains valid data we should
+	 * send the regulatory hint as alpha2 value to cfg80211.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_GEOGRAPHY, &eeprom);
+	if (eeprom != 0xffff) {
+		value = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO);
+		regulatory_hint(rt2x00dev->hw->wiphy, reg_domain_map[value]);
+	}
+
+	/*
 	 * Read the RSSI <-> dBm offset information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
