Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57913 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab0GKKby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:31:54 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so640186ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:31:53 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/17] rt2x00: Rename CONFIG_DISABLE_LINK_TUNING
Date: Sun, 11 Jul 2010 12:24:22 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111223.51704.IvDoorn@gmail.com>
In-Reply-To: <201007111223.51704.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111224.23529.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename CONFIG_DISABLE_LINK_TUNING to DRIVER_SUPPORT_LINK_TUNING
Link tuning support is not only based on EEPROM decisions, but
also if the device actually supports it.

Currently only rt2500usb doesn't support link tuning because
of hardware problems. But rt2800usb is also suspected of having
problems with link tuning.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c  |    4 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c  |    5 ++---
 drivers/net/wireless/rt2x00/rt2500usb.c  |    8 --------
 drivers/net/wireless/rt2x00/rt2800pci.c  |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c  |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00link.c |    7 ++++---
 drivers/net/wireless/rt2x00/rt61pci.c    |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c    |    1 +
 9 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 3bedf56..5d5047f 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1399,8 +1399,8 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Check if the BBP tuning should be enabled.
 	 */
-	if (!rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RX_AGCVGC_TUNING))
-		__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
+	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RX_AGCVGC_TUNING))
+		__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 69d231d..1d4758a 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1557,9 +1557,8 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Check if the BBP tuning should be enabled.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
-
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_DYN_BBP_TUNE))
-		__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
+	if (!rt2x00_get_field16(eeprom, EEPROM_NIC_DYN_BBP_TUNE))
+		__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
 	 * Read the RSSI <-> dBm offset information.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 4420552..6e48a15 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1471,13 +1471,6 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
 
 	/*
-	 * Check if the BBP tuning should be disabled.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_DYN_BBP_TUNE))
-		__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
-
-	/*
 	 * Read the RSSI <-> dBm offset information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
@@ -1743,7 +1736,6 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 		__set_bit(DRIVER_REQUIRE_COPY_IV, &rt2x00dev->flags);
 	}
-	__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index faf71e2..a9eca99 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1037,6 +1037,7 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
+	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f2cd37e..e4ab4db 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -632,6 +632,7 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
+	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 788b0e4..42f4661 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -646,6 +646,7 @@ enum rt2x00_flags {
 	CONFIG_SUPPORT_HW_CRYPTO,
 	DRIVER_SUPPORT_CONTROL_FILTERS,
 	DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL,
+	DRIVER_SUPPORT_LINK_TUNING,
 
 	/*
 	 * Driver configuration
@@ -655,7 +656,6 @@ enum rt2x00_flags {
 	CONFIG_EXTERNAL_LNA_A,
 	CONFIG_EXTERNAL_LNA_BG,
 	CONFIG_DOUBLE_ANTENNA,
-	CONFIG_DISABLE_LINK_TUNING,
 	CONFIG_CHANNEL_HT40,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 2f8136c..801925b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -359,10 +359,11 @@ static void rt2x00link_tuner(struct work_struct *work)
 		qual->rssi = link->avg_rssi.avg;
 
 	/*
-	 * Only perform the link tuning when Link tuning
-	 * has been enabled (This could have been disabled from the EEPROM).
+	 * Check if link tuning is supported by the hardware, some hardware
+	 * do not support link tuning at all, while other devices can disable
+	 * the feature from the EEPROM.
 	 */
-	if (!test_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags))
+	if (test_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags))
 		rt2x00dev->ops->lib->link_tuner(rt2x00dev, qual, link->count);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0123fbc..ee84536 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2690,6 +2690,7 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
+	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 286dd97..156f5d3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2135,6 +2135,7 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
+	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
-- 
1.7.1.1

