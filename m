Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:54766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbXGYUsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:43 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420027ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:42 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/11] rt2x00: Parse chipset revision for RT chip validation
Date: Wed, 25 Jul 2007 22:50:27 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252250.27837.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From a8a6c0ece7a9a3c352c943b0ae686093fb09630a Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Wed, 25 Jul 2007 19:43:16 +0200
Subject: [PATCH 10/11] rt2x00: Parse chipset revision for RT chip validation

Because of duplicate USB ID's it is possible
the driver is attempting to work for a wrong device.
Because RF chipset validation is insufficient we should
parse the revision identification from the EEPROM.

example revisions:
  rt2570: 0x0000c
  rt73:   0x2573c

This helps us identify rt2570 from rt73, but it remains
possible conflicts with other chipsets remain... :(

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c |    4 ++--
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c |    7 ++++++-
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h    |    7 ++++++-
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c   |    5 +++++
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 7649d69..76f5551 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -682,7 +682,7 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * up to version C the link tuning should halt after 20
 	 * seconds.
 	 */
-	if (rt2x00_rev(&rt2x00dev->chip) < RT2560_VERSION_D &&
+	if (rt2x00_get_rev(&rt2x00dev->chip) < RT2560_VERSION_D &&
 	    rt2x00dev->link.count > 20)
 		return;
 
@@ -692,7 +692,7 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Chipset versions C and lower should directly continue
 	 * to the dynamic CCA tuning.
 	 */
-	if (rt2x00_rev(&rt2x00dev->chip) < RT2560_VERSION_D)
+	if (rt2x00_get_rev(&rt2x00dev->chip) < RT2560_VERSION_D)
 		goto dynamic_cca_tune;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 2ac3ec3..2cceb6c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -756,7 +756,7 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2500usb_register_write(rt2x00dev, MAC_CSR1, 0x0004);
 
-	if (rt2x00_rev(&rt2x00dev->chip) >= RT2570_VERSION_C) {
+	if (rt2x00_get_rev(&rt2x00dev->chip) >= RT2570_VERSION_C) {
 		rt2500usb_register_read(rt2x00dev, PHY_CSR2, &reg);
 		reg &= ~0x0002;
 	} else {
@@ -1228,6 +1228,11 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2570, value, reg);
 
+	if (rt2x00_rev(&rt2x00dev->chip, 0xffff0)) {
+		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
+		return -ENODEV;
+	}
+
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2522) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2523) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2524) &&
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index bae34f9..5be5956 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -1034,11 +1034,16 @@ static inline char rt2x00_rf(const struct rt2x00_chip *chipset, const u16 chip)
 	return (chipset->rf == chip);
 }
 
-static inline u16 rt2x00_rev(const struct rt2x00_chip *chipset)
+static inline u16 rt2x00_get_rev(const struct rt2x00_chip *chipset)
 {
 	return chipset->rev;
 }
 
+static inline u16 rt2x00_rev(const struct rt2x00_chip *chipset, const u32 mask)
+{
+	return chipset->rev & mask;
+}
+
 /*
  * Device specific rate value.
  * We will have to create the device specific rate value
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 60166b2..3d838d1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1483,6 +1483,11 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt73usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2571, value, reg);
 
+	if (!rt2x00_rev(&rt2x00dev->chip, 0x25730)) {
+		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
+		return -ENODEV;
+	}
+
 	if (!rt2x00_rf(&rt2x00dev->chip, RF5226) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2528) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF5225) &&
-- 
1.5.2.2

