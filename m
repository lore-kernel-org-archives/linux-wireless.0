Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765478AbXGaSeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:13 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:11 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/24] rt2x00: Correctly handle RF 0 writing
Date: Tue, 31 Jul 2007 20:37:19 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.19852.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 9b7ee86485d789df2a1e6006a073d0847f54a5b7 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 28 Jul 2007 12:15:56 +0200
Subject: [PATCH 11/24] rt2x00: Correctly handle RF 0 writing

When attempting to write to RF 0 the rf handler should
exit immediately.
This also removes the requirement to do index - 1
when reading and writing to the RF buffer since the size
is big enough to keep word 0 unused.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    3 +++
 drivers/net/wireless/rt2500pci.c |    3 +++
 drivers/net/wireless/rt2500usb.c |    3 +++
 drivers/net/wireless/rt2x00.h    |    6 ++----
 drivers/net/wireless/rt61pci.c   |    3 +++
 drivers/net/wireless/rt73usb.c   |    3 +++
 6 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 45bc993..a43a407 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -142,6 +142,9 @@ static void rt2400pci_rf_write(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 	unsigned int i;
 
+	if (!word)
+		return;
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2x00pci_register_read(rt2x00dev, RFCSR, &reg);
 		if (!rt2x00_get_field32(reg, RFCSR_BUSY))
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 3117e0b..7f4287c 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -142,6 +142,9 @@ static void rt2500pci_rf_write(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 	unsigned int i;
 
+	if (!word)
+		return;
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2x00pci_register_read(rt2x00dev, RFCSR, &reg);
 		if (!rt2x00_get_field32(reg, RFCSR_BUSY))
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 89cb347..0d775fa 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -178,6 +178,9 @@ static void rt2500usb_rf_write(const struct rt2x00_dev *rt2x00dev,
 	u16 reg;
 	unsigned int i;
 
+	if (!word)
+		return;
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2500usb_register_read(rt2x00dev, PHY_CSR10, &reg);
 		if (!rt2x00_get_field16(reg, PHY_CSR10_RF_BUSY))
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 8be013b..227a50a 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -961,15 +961,13 @@ static inline struct data_ring* rt2x00_get_ring(
 static inline void rt2x00_rf_read(const struct rt2x00_dev *rt2x00dev,
 	const unsigned int word, u32 *data)
 {
-	if (word)
-		*data = rt2x00dev->rf[word - 1];
+	*data = rt2x00dev->rf[word];
 }
 
 static inline void rt2x00_rf_write(const struct rt2x00_dev *rt2x00dev,
 	const unsigned int word, u32 data)
 {
-	if (word)
-		rt2x00dev->rf[word - 1] = data;
+	rt2x00dev->rf[word] = data;
 }
 
 /*
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index fb0c5c5..37191a4 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -140,6 +140,9 @@ static void rt61pci_rf_write(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 	unsigned int i;
 
+	if (!word)
+		return;
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2x00pci_register_read(rt2x00dev, PHY_CSR4, &reg);
 		if (!rt2x00_get_field32(reg, PHY_CSR4_BUSY))
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 07e6087..8add8d3 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -179,6 +179,9 @@ static void rt73usb_rf_write(const struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 	unsigned int i;
 
+	if (!word)
+		return;
+
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt73usb_register_read(rt2x00dev, PHY_CSR4, &reg);
 		if (!rt2x00_get_field32(reg, PHY_CSR4_BUSY))
-- 
1.5.2.4

