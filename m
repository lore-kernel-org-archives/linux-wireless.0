Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbXGaSeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:09 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:08 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/24] rt2x00: Increase RF_SIZE
Date: Tue, 31 Jul 2007 20:37:15 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.15944.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 527760f942ce72f42a342467cbc6b0960be72038 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 28 Jul 2007 11:35:57 +0200
Subject: [PATCH 09/24] rt2x00: Increase RF_SIZE

Increase the RF_SIZE with the size of 1 word,
this is needed to correctly emulate the word 0
and to prevent debugfs to always read 1 word below the limit.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.h |    2 +-
 drivers/net/wireless/rt2500pci.h |    2 +-
 drivers/net/wireless/rt2500usb.h |    2 +-
 drivers/net/wireless/rt61pci.h   |    2 +-
 drivers/net/wireless/rt73usb.h   |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.h b/drivers/net/wireless/rt2400pci.h
index 930b2ca..4afc932 100644
--- a/drivers/net/wireless/rt2400pci.h
+++ b/drivers/net/wireless/rt2400pci.h
@@ -48,7 +48,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
 #define BBP_SIZE			0x0020
-#define RF_SIZE				0x000c
+#define RF_SIZE				0x0010
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/rt2500pci.h b/drivers/net/wireless/rt2500pci.h
index 463f2c9..d95a4e8 100644
--- a/drivers/net/wireless/rt2500pci.h
+++ b/drivers/net/wireless/rt2500pci.h
@@ -59,7 +59,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0200
 #define BBP_SIZE			0x0040
-#define RF_SIZE				0x0010
+#define RF_SIZE				0x0014
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/rt2500usb.h b/drivers/net/wireless/rt2500usb.h
index 065c3ab..5feb34e 100644
--- a/drivers/net/wireless/rt2500usb.h
+++ b/drivers/net/wireless/rt2500usb.h
@@ -59,7 +59,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x006a
 #define BBP_SIZE			0x0060
-#define RF_SIZE				0x0010
+#define RF_SIZE				0x0014
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/rt61pci.h b/drivers/net/wireless/rt61pci.h
index 3e653bd..33cd2aa 100644
--- a/drivers/net/wireless/rt61pci.h
+++ b/drivers/net/wireless/rt61pci.h
@@ -50,7 +50,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
 #define BBP_SIZE			0x0080
-#define RF_SIZE				0x0010
+#define RF_SIZE				0x0014
 
 /*
  * PCI registers.
diff --git a/drivers/net/wireless/rt73usb.h b/drivers/net/wireless/rt73usb.h
index ee2e0b1..bd95cc3 100644
--- a/drivers/net/wireless/rt73usb.h
+++ b/drivers/net/wireless/rt73usb.h
@@ -50,7 +50,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
 #define BBP_SIZE			0x0080
-#define RF_SIZE				0x0010
+#define RF_SIZE				0x0014
 
 /*
  * USB registers.
-- 
1.5.2.4

