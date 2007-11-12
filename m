Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:24010 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbXKLNs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 08:48:57 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1476773fkz
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2007 05:48:56 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] rt2x00: Fix chipset revision validation
Date: Mon, 12 Nov 2007 15:02:22 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711121502.01953.IvDoorn@gmail.com>
In-Reply-To: <200711121502.01953.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711121502.22409.IvDoorn@gmail.com> (sfid-20071112_134901_543202_DC5AB107)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The validation of the chipset revision was broken
since for rt2500usb and rt73usb different registers
should be read. When rt2500usb was loaded for a rt73
device it would false think the chipset was correct
because the wrong register was read and validated.

This has been fixed by expanding the check to also
see if the first 4 bits of the revision is not-0
(When reading the wrong register offset the returned
value is usually 0 which can be interpreted as invalid)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00.h    |    8 +++++---
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index c5a5c43..e6a0c37 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -617,7 +617,7 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * up to version C the link tuning should halt after 20
 	 * seconds.
 	 */
-	if (rt2x00_get_rev(&rt2x00dev->chip) < RT2560_VERSION_D &&
+	if (rt2x00_rev(&rt2x00dev->chip) < RT2560_VERSION_D &&
 	    rt2x00dev->link.count > 20)
 		return;
 
@@ -627,7 +627,7 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Chipset versions C and lower should directly continue
 	 * to the dynamic CCA tuning.
 	 */
-	if (rt2x00_get_rev(&rt2x00dev->chip) < RT2560_VERSION_D)
+	if (rt2x00_rev(&rt2x00dev->chip) < RT2560_VERSION_D)
 		goto dynamic_cca_tune;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 43f1e0f..b5a8f82 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -791,7 +791,7 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field16(&reg, MAC_CSR1_HOST_READY, 1);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR1, reg);
 
-	if (rt2x00_get_rev(&rt2x00dev->chip) >= RT2570_VERSION_C) {
+	if (rt2x00_rev(&rt2x00dev->chip) >= RT2570_VERSION_C) {
 		rt2500usb_register_read(rt2x00dev, PHY_CSR2, &reg);
 		rt2x00_set_field16(&reg, PHY_CSR2_LNA, 0);
 	} else {
@@ -1299,7 +1299,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2570, value, reg);
 
-	if (rt2x00_rev(&rt2x00dev->chip, 0xffff0)) {
+	if (!rt2x00_check_rev(&rt2x00dev->chip, 0)) {
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 82014d8..12382c3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -849,14 +849,16 @@ static inline char rt2x00_rf(const struct rt2x00_chip *chipset, const u16 chip)
 	return (chipset->rf == chip);
 }
 
-static inline u16 rt2x00_get_rev(const struct rt2x00_chip *chipset)
+static inline u16 rt2x00_rev(const struct rt2x00_chip *chipset)
 {
 	return chipset->rev;
 }
 
-static inline u16 rt2x00_rev(const struct rt2x00_chip *chipset, const u32 mask)
+static inline u16 rt2x00_check_rev(const struct rt2x00_chip *chipset,
+				   const u32 rev)
 {
-	return chipset->rev & mask;
+	return (((chipset->rev & 0xffff0) == rev) &&
+		!!(chipset->rev & 0x0000f));
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 532e75d..9bd0b4f 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1530,7 +1530,7 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt73usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2571, value, reg);
 
-	if (!rt2x00_rev(&rt2x00dev->chip, 0x25730)) {
+	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x25730)) {
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
-- 
1.5.3.4

