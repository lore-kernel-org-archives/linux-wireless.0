Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbXHSSac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:32 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:31 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/30] rt2x00: Set vgc_level during reset_tuner
Date: Sun, 19 Aug 2007 20:23:12 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192023.12222.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From dc0c67691b4f794fcaad97ddc36f4e9354658d6e Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 12:55:51 +0200
Subject: [PATCH 06/30] rt2x00: Set vgc_level during reset_tuner

Reset the vgc_level to the correct AGC VGC value
that has just been written to the register during
reset_tuner.
This will assure that the value will be valid
when it is used during the link tuner.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    1 +
 drivers/net/wireless/rt2500pci.c |    1 +
 drivers/net/wireless/rt2500usb.c |    4 +++-
 drivers/net/wireless/rt61pci.c   |    1 +
 drivers/net/wireless/rt73usb.c   |    1 +
 5 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 1506666..d8628e6 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -655,6 +655,7 @@ static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev)
 static void rt2400pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	rt2400pci_bbp_write(rt2x00dev, 13, 0x08);
+	rt2x00dev->link.vgc_level = 0x08;
 }
 
 static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 445ec3e..4d195de 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -755,6 +755,7 @@ static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev)
 static void rt2500pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	rt2500pci_bbp_write(rt2x00dev, 17, 0x48);
+	rt2x00dev->link.vgc_level = 0x48;
 }
 
 static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 29b675c..581cc6f 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -728,6 +728,8 @@ static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_VGC, &eeprom);
 	value = rt2x00_get_field16(eeprom, EEPROM_BBPTUNE_VGCUPPER);
 	rt2500usb_bbp_write(rt2x00dev, 17, value);
+
+	rt2x00dev->link.vgc_level = value;
 }
 
 static void rt2500usb_link_tuner(struct rt2x00_dev *rt2x00dev)
@@ -1204,7 +1206,7 @@ static int rt2500usb_fill_rxdone(struct data_entry *entry,
 	*ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	*size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	return;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index e292572..7c52a4e 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -968,6 +968,7 @@ static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev)
 static void rt61pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	rt61pci_bbp_write(rt2x00dev, 17, 0x20);
+	rt2x00dev->link.vgc_level = 0x20;
 }
 
 static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 149f5ee..74e4173 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -858,6 +858,7 @@ static void rt73usb_link_stats(struct rt2x00_dev *rt2x00dev)
 static void rt73usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	rt73usb_bbp_write(rt2x00dev, 17, 0x20);
+	rt2x00dev->link.vgc_level = 0x20;
 }
 
 static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
-- 
1.5.3.rc5

