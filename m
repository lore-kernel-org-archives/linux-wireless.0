Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:20022 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbYKITrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 14:47:05 -0500
Received: by ik-out-1112.google.com with SMTP id c29so1680967ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2008 11:47:03 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Optimize get_duration / get_duration_res
Date: Sun, 9 Nov 2008 20:47:00 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811092047.01070.IvDoorn@gmail.com> (sfid-20081109_204714_228116_83A89455)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can optimize get_duration and get_duration_res
by making them a macro. They are really simple
calculation handlers so this doesn't matter much.

Often (especially in rt2400pci and rt2500pci,
the arguments are hardcoded, and the result value
is passed into other hardcoded values.

By making the functions a macro GCC can
optimize the entire thing much better.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |   10 ++++----
 drivers/net/wireless/rt2x00/rt2500pci.c    |   10 ++++----
 drivers/net/wireless/rt2x00/rt2500usb.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h       |   31 ++++++++++-----------------
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c  |    4 +-
 6 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 257cd71..c4c56b0 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -322,7 +322,7 @@ static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Enable beacon config
 		 */
-		bcn_preload = PREAMBLE + get_duration(IEEE80211_HEADER, 20);
+		bcn_preload = PREAMBLE + GET_DURATION(IEEE80211_HEADER, 20);
 		rt2x00pci_register_read(rt2x00dev, BCNCSR1, &reg);
 		rt2x00_set_field32(&reg, BCNCSR1_PRELOAD, bcn_preload);
 		rt2x00pci_register_write(rt2x00dev, BCNCSR1, reg);
@@ -367,25 +367,25 @@ static void rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
 	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
 	rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 10));
+	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 10));
 	rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR3, &reg);
 	rt2x00_set_field32(&reg, ARCSR3_SIGNAL, 0x01 | preamble_mask);
 	rt2x00_set_field32(&reg, ARCSR3_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 20));
+	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 20));
 	rt2x00pci_register_write(rt2x00dev, ARCSR3, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR4, &reg);
 	rt2x00_set_field32(&reg, ARCSR4_SIGNAL, 0x02 | preamble_mask);
 	rt2x00_set_field32(&reg, ARCSR4_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 55));
+	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 55));
 	rt2x00pci_register_write(rt2x00dev, ARCSR4, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR5, &reg);
 	rt2x00_set_field32(&reg, ARCSR5_SIGNAL, 0x03 | preamble_mask);
 	rt2x00_set_field32(&reg, ARCSR5_SERVICE, 0x84);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 110));
+	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 110));
 	rt2x00pci_register_write(rt2x00dev, ARCSR5, reg);
 
 	rt2x00pci_register_write(rt2x00dev, ARCSR1, erp->basic_rates);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index a3fbfdf..08fb8e0 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -327,7 +327,7 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Enable beacon config
 		 */
-		bcn_preload = PREAMBLE + get_duration(IEEE80211_HEADER, 20);
+		bcn_preload = PREAMBLE + GET_DURATION(IEEE80211_HEADER, 20);
 		rt2x00pci_register_read(rt2x00dev, BCNCSR1, &reg);
 		rt2x00_set_field32(&reg, BCNCSR1_PRELOAD, bcn_preload);
 		rt2x00_set_field32(&reg, BCNCSR1_BEACON_CWMIN, queue->cw_min);
@@ -373,25 +373,25 @@ static void rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
 	rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
 	rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 10));
+	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 10));
 	rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR3, &reg);
 	rt2x00_set_field32(&reg, ARCSR3_SIGNAL, 0x01 | preamble_mask);
 	rt2x00_set_field32(&reg, ARCSR3_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 20));
+	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 20));
 	rt2x00pci_register_write(rt2x00dev, ARCSR3, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR4, &reg);
 	rt2x00_set_field32(&reg, ARCSR4_SIGNAL, 0x02 | preamble_mask);
 	rt2x00_set_field32(&reg, ARCSR4_SERVICE, 0x04);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 55));
+	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 55));
 	rt2x00pci_register_write(rt2x00dev, ARCSR4, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR5, &reg);
 	rt2x00_set_field32(&reg, ARCSR5_SIGNAL, 0x03 | preamble_mask);
 	rt2x00_set_field32(&reg, ARCSR5_SERVICE, 0x84);
-	rt2x00_set_field32(&reg, ARCSR2_LENGTH, get_duration(ACK_SIZE, 110));
+	rt2x00_set_field32(&reg, ARCSR2_LENGTH, GET_DURATION(ACK_SIZE, 110));
 	rt2x00pci_register_write(rt2x00dev, ARCSR5, reg);
 
 	rt2x00pci_register_write(rt2x00dev, ARCSR1, erp->basic_rates);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 3e4051c..ecc4e5a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -385,7 +385,7 @@ static void rt2500usb_config_intf(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Enable beacon config
 		 */
-		bcn_preload = PREAMBLE + get_duration(IEEE80211_HEADER, 20);
+		bcn_preload = PREAMBLE + GET_DURATION(IEEE80211_HEADER, 20);
 		rt2500usb_register_read(rt2x00dev, TXRX_CSR20, &reg);
 		rt2x00_set_field16(&reg, TXRX_CSR20_OFFSET, bcn_preload >> 6);
 		rt2x00_set_field16(&reg, TXRX_CSR20_BCN_EXPECT_WINDOW,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 4506f6c..baccea7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -92,6 +92,16 @@
 	DEBUG_PRINTK(__dev, KERN_DEBUG, "EEPROM recovery", __msg, ##__args)
 
 /*
+ * Duration calculations
+ * The rate variable passed is: 100kbs.
+ * To convert from bytes to bits we multiply size with 8,
+ * then the size is multiplied with 10 to make the
+ * real rate -> rate argument correction.
+ */
+#define GET_DURATION(__size, __rate)	(((__size) * 8 * 10) / (__rate))
+#define GET_DURATION_RES(__size, __rate)(((__size) * 8 * 10) % (__rate))
+
+/*
  * Standard timing and size defines.
  * These values should follow the ieee80211 specifications.
  */
@@ -109,9 +119,9 @@
 #define DIFS			( PIFS + SLOT_TIME )
 #define SHORT_DIFS		( SHORT_PIFS + SHORT_SLOT_TIME )
 #define EIFS			( SIFS + DIFS + \
-				  (8 * (IEEE80211_HEADER + ACK_SIZE)) )
+				  GET_DURATION(IEEE80211_HEADER + ACK_SIZE, 10) )
 #define SHORT_EIFS		( SIFS + SHORT_DIFS + \
-				  (8 * (IEEE80211_HEADER + ACK_SIZE)) )
+				  GET_DURATION(IEEE80211_HEADER + ACK_SIZE, 10) )
 
 /*
  * Chipset identification
@@ -920,23 +930,6 @@ static inline u16 rt2x00_check_rev(const struct rt2x00_chip *chipset,
 		!!(chipset->rev & 0x0000f));
 }
 
-/*
- * Duration calculations
- * The rate variable passed is: 100kbs.
- * To convert from bytes to bits we multiply size with 8,
- * then the size is multiplied with 10 to make the
- * real rate -> rate argument correction.
- */
-static inline u16 get_duration(const unsigned int size, const u8 rate)
-{
-	return ((size * 8 * 10) / rate);
-}
-
-static inline u16 get_duration_res(const unsigned int size, const u8 rate)
-{
-	return ((size * 8 * 10) % rate);
-}
-
 /**
  * rt2x00queue_map_txskb - Map a skb into DMA for TX purposes.
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 1059b4d..7c62ce1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -92,8 +92,8 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 	erp.difs = bss_conf->use_short_slot ? SHORT_DIFS : DIFS;
 	erp.eifs = bss_conf->use_short_slot ? SHORT_EIFS : EIFS;
 
-	erp.ack_timeout = PLCP + erp.difs + get_duration(ACK_SIZE, 10);
-	erp.ack_consume_time = SIFS + PLCP + get_duration(ACK_SIZE, 10);
+	erp.ack_timeout = PLCP + erp.difs + GET_DURATION(ACK_SIZE, 10);
+	erp.ack_consume_time = SIFS + PLCP + GET_DURATION(ACK_SIZE, 10);
 
 	if (bss_conf->use_short_preamble) {
 		erp.ack_timeout += SHORT_PREAMBLE;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7fc9c6e..d7752db 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -319,8 +319,8 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 		/*
 		 * Convert length to microseconds.
 		 */
-		residual = get_duration_res(data_length, hwrate->bitrate);
-		duration = get_duration(data_length, hwrate->bitrate);
+		residual = GET_DURATION_RES(data_length, hwrate->bitrate);
+		duration = GET_DURATION(data_length, hwrate->bitrate);
 
 		if (residual != 0) {
 			duration++;
-- 
1.5.6.1

