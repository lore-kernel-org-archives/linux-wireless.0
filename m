Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57913 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab0GKKbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:31:46 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so640186ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:31:45 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/17] rt2x00: Convert AGC value from descriptor to RSSI (dBm)
Date: Sun, 11 Jul 2010 12:23:50 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com>
In-Reply-To: <201007111223.11190.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111223.51704.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RSSI values in the RXWI descriptor aren't true RSSI
values. Instead they are more like the AGC values similar
to rt61pci. And as such, it needs the same conversion
before it can be passed to rt2x00lib/mac80211.

This requires the struct queue_entry to be passed to
rt2800_process_rxwi rather then the skb structure which
is contained in the queue_entry. This is required to
obtain the lna_gain information from the rt2x00_dev structure.

This fixes connection problems when using wpa_supplicant
which would try to connect to the worst AP's rather then the
best ones.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c |   57 +++++++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2800lib.h |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 5 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 3cda229..edd3734 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -74,7 +74,7 @@
  * Signal information.
  * Default offset is required for RSSI <-> dBm conversion.
  */
-#define DEFAULT_RSSI_OFFSET		120 /* FIXME */
+#define DEFAULT_RSSI_OFFSET		120
 
 /*
  * Register layout information.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9030eef..255d089 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -325,9 +325,53 @@ void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc)
 }
 EXPORT_SYMBOL_GPL(rt2800_write_txwi);
 
-void rt2800_process_rxwi(struct sk_buff *skb, struct rxdone_entry_desc *rxdesc)
+static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxwi_w2)
 {
-	__le32 *rxwi = (__le32 *) skb->data;
+	int rssi0 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI0);
+	int rssi1 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI1);
+	int rssi2 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI2);
+	u16 eeprom;
+	u8 offset0;
+	u8 offset1;
+	u8 offset2;
+
+	if (rt2x00dev->rx_status.band == IEEE80211_BAND_2GHZ) {
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &eeprom);
+		offset0 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG_OFFSET0);
+		offset1 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG_OFFSET1);
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &eeprom);
+		offset2 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG2_OFFSET2);
+	} else {
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &eeprom);
+		offset0 = rt2x00_get_field16(eeprom, EEPROM_RSSI_A_OFFSET0);
+		offset1 = rt2x00_get_field16(eeprom, EEPROM_RSSI_A_OFFSET1);
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &eeprom);
+		offset2 = rt2x00_get_field16(eeprom, EEPROM_RSSI_A2_OFFSET2);
+	}
+
+	/*
+	 * Convert the value from the descriptor into the RSSI value
+	 * If the value in the descriptor is 0, it is considered invalid
+	 * and the default (extremely low) rssi value is assumed
+	 */
+	rssi0 = (rssi0) ? (-12 - offset0 - rt2x00dev->lna_gain - rssi0) : -128;
+	rssi1 = (rssi1) ? (-12 - offset1 - rt2x00dev->lna_gain - rssi1) : -128;
+	rssi2 = (rssi2) ? (-12 - offset2 - rt2x00dev->lna_gain - rssi2) : -128;
+
+	/*
+	 * mac80211 only accepts a single RSSI value. Calculating the
+	 * average doesn't deliver a fair answer either since -60:-60 would
+	 * be considered equally good as -50:-70 while the second is the one
+	 * which gives less energy...
+	 */
+	rssi0 = max(rssi0, rssi1);
+	return max(rssi0, rssi2);
+}
+
+void rt2800_process_rxwi(struct queue_entry *entry,
+			 struct rxdone_entry_desc *rxdesc)
+{
+	__le32 *rxwi = (__le32 *) entry->skb->data;
 	u32 word;
 
 	rt2x00_desc_read(rxwi, 0, &word);
@@ -358,14 +402,15 @@ void rt2800_process_rxwi(struct sk_buff *skb, struct rxdone_entry_desc *rxdesc)
 
 	rt2x00_desc_read(rxwi, 2, &word);
 
-	rxdesc->rssi =
-	    (rt2x00_get_field32(word, RXWI_W2_RSSI0) +
-	     rt2x00_get_field32(word, RXWI_W2_RSSI1)) / 2;
+	/*
+	 * Convert descriptor AGC value to RSSI value.
+	 */
+	rxdesc->rssi = rt2800_agc_to_rssi(entry->queue->rt2x00dev, word);
 
 	/*
 	 * Remove RXWI descriptor from start of buffer.
 	 */
-	skb_pull(skb, RXWI_DESC_SIZE);
+	skb_pull(entry->skb, RXWI_DESC_SIZE);
 }
 EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 8313dbf..eb3a4f5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -121,7 +121,7 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 arg0, const u8 arg1);
 
 void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc);
-void rt2800_process_rxwi(struct sk_buff *skb, struct rxdone_entry_desc *txdesc);
+void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *txdesc);
 
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 6f11760..faf71e2 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -805,7 +805,7 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 	/*
 	 * Process the RXWI structure that is at the start of the buffer.
 	 */
-	rt2800_process_rxwi(entry->skb, rxdesc);
+	rt2800_process_rxwi(entry, rxdesc);
 
 	/*
 	 * Set RX IDX in register to inform hardware that we have handled
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 4f85f7b..f2cd37e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -563,7 +563,7 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	/*
 	 * Process the RXWI structure.
 	 */
-	rt2800_process_rxwi(entry->skb, rxdesc);
+	rt2800_process_rxwi(entry, rxdesc);
 }
 
 /*
-- 
1.7.1.1

