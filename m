Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:2430 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933632AbXCKOGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 10:06:05 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1687602muf
        for <linux-wireless@vger.kernel.org>; Sun, 11 Mar 2007 07:06:04 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] rt2x00: fix firmware dependency
Date: Sun, 11 Mar 2007 15:05:48 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703111505.48510.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to always build rt2x00lib.ko including the firmware handlers,
only rt61pci and rt73usb will require the firmware handling. So lets add a new
invisible config option selected by rt61pci and rt73usb to enable the firmware
handling inside rt2x00lib.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

Patch send again because of mail client problem

diff --git a/drivers/net/wireless/mac80211/rt2x00/Kconfig b/drivers/net/wireless/mac80211/rt2x00/Kconfig
index 6242f15..0528431 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Kconfig
+++ b/drivers/net/wireless/mac80211/rt2x00/Kconfig
@@ -15,6 +15,10 @@ config RT2X00_LIB
 	tristate
 	depends on RT2X00
 
+config RT2X00_LIB_FIRMWARE
+	boolean
+	depends on RT2X00
+
 config RT2400PCI
 	tristate "Ralink rt2400 pci/pcmcia support"
 	depends on RT2X00 && PCI
@@ -39,6 +43,7 @@ config RT61PCI
 	tristate "Ralink rt61 pci/pcmcia support"
 	depends on RT2X00 && FW_LOADER && PCI
 	select RT2X00_LIB
+	select RT2X00_LIB_FIRMWARE
 	select CRC_ITU_T
 	select EEPROM_93CX6
 	---help---
@@ -59,6 +64,7 @@ config RT73USB
 	tristate "Ralink rt73 usb support"
 	depends on RT2X00 && FW_LOADER && USB
 	select RT2X00_LIB
+	select RT2X00_LIB_FIRMWARE
 	select CRC_ITU_T
 	---help---
 	This is an experimental driver for the Ralink rt73 wireless chip.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
index 8dacf00..ba27a3e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
@@ -40,6 +40,7 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
+#ifdef CONFIG_RT2X00_LIB_FIRMWARE
 struct fw_entry {
 	u32	chip;
 	char	*name;
@@ -92,6 +93,7 @@ int rt2x00lib_load_firmware_wait(struct rt2x00_dev *rt2x00dev)
 	return -ETIMEDOUT;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_load_firmware_wait);
+#endif /* CONFIG_RT2X00_LIB_FIRMWARE */
 
 void rt2x00lib_update_tx_stats(struct data_entry *entry,
 	const int status, const int is_ack, const int retry)
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
index 5ec88a6..9728d5b 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
@@ -30,9 +30,11 @@
 
 #include <linux/firmware.h>
 
+#ifdef CONFIG_RT2X00_LIB_FIRMWARE
 int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev, struct device *dev,
 	void (*cont)(const struct firmware *fw, void *context));
 int rt2x00lib_load_firmware_wait(struct rt2x00_dev *rt2x00dev);
+#endif /* CONFIG_RT2X00_LIB_FIRMWARE */
 
 void rt2x00lib_update_tx_stats(struct data_entry *entry,
 	const int status, const int is_ack, const int retry);
