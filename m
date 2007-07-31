Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765152AbXGaSeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:08 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:07 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/24] rt2x00: Fix invalid RF array reading
Date: Tue, 31 Jul 2007 20:37:13 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.13175.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 9a895eb31291e4a856a4d04f4f99ea6cf055e5ec Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 28 Jul 2007 01:12:39 +0200
Subject: [PATCH 08/24] rt2x00: Fix invalid RF array reading

RF registers don't have a word 0, check when this is
being requested and just ignore that request. (Only possible
call can come from debugfs).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.h |    2 +-
 drivers/net/wireless/rt2500pci.h |    2 +-
 drivers/net/wireless/rt2500usb.h |    2 +-
 drivers/net/wireless/rt2x00.h    |    6 ++++--
 drivers/net/wireless/rt61pci.h   |    2 +-
 drivers/net/wireless/rt73usb.h   |    2 +-
 6 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.h b/drivers/net/wireless/rt2400pci.h
index 54fd789..930b2ca 100644
--- a/drivers/net/wireless/rt2400pci.h
+++ b/drivers/net/wireless/rt2400pci.h
@@ -48,7 +48,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
 #define BBP_SIZE			0x0020
-#define RF_SIZE				0x0008
+#define RF_SIZE				0x000c
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/rt2500pci.h b/drivers/net/wireless/rt2500pci.h
index 49c6792..463f2c9 100644
--- a/drivers/net/wireless/rt2500pci.h
+++ b/drivers/net/wireless/rt2500pci.h
@@ -59,7 +59,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0200
 #define BBP_SIZE			0x0040
-#define RF_SIZE				0x000c
+#define RF_SIZE				0x0010
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/rt2500usb.h b/drivers/net/wireless/rt2500usb.h
index 425c804..065c3ab 100644
--- a/drivers/net/wireless/rt2500usb.h
+++ b/drivers/net/wireless/rt2500usb.h
@@ -59,7 +59,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x006a
 #define BBP_SIZE			0x0060
-#define RF_SIZE				0x000c
+#define RF_SIZE				0x0010
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index bf80f51..8be013b 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -961,13 +961,15 @@ static inline struct data_ring* rt2x00_get_ring(
 static inline void rt2x00_rf_read(const struct rt2x00_dev *rt2x00dev,
 	const unsigned int word, u32 *data)
 {
-	*data = rt2x00dev->rf[word - 1];
+	if (word)
+		*data = rt2x00dev->rf[word - 1];
 }
 
 static inline void rt2x00_rf_write(const struct rt2x00_dev *rt2x00dev,
 	const unsigned int word, u32 data)
 {
-	rt2x00dev->rf[word] = data;
+	if (word)
+		rt2x00dev->rf[word - 1] = data;
 }
 
 /*
diff --git a/drivers/net/wireless/rt61pci.h b/drivers/net/wireless/rt61pci.h
index ed450e7..3e653bd 100644
--- a/drivers/net/wireless/rt61pci.h
+++ b/drivers/net/wireless/rt61pci.h
@@ -50,7 +50,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
 #define BBP_SIZE			0x0080
-#define RF_SIZE				0x000c
+#define RF_SIZE				0x0010
 
 /*
  * PCI registers.
diff --git a/drivers/net/wireless/rt73usb.h b/drivers/net/wireless/rt73usb.h
index 276fa3f..ee2e0b1 100644
--- a/drivers/net/wireless/rt73usb.h
+++ b/drivers/net/wireless/rt73usb.h
@@ -50,7 +50,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
 #define BBP_SIZE			0x0080
-#define RF_SIZE				0x000c
+#define RF_SIZE				0x0010
 
 /*
  * USB registers.
-- 
1.5.2.4

