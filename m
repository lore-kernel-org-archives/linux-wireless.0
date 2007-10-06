Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:18176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbXJFMEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:04 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605539ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:02 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/16] rt2x00: Fix rfkill handling
Date: Sat, 6 Oct 2007 14:14:06 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061414.07118.IvDoorn@gmail.com> (sfid-20071006_130408_692469_CFEDB913)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by Modestas Vainius, enabling rkfill in 1 driver and
disabling it in a second could cause a NULL pointer exception when
the rfkill-disabled driver still sets the CONFIG_SUPPORT_HW_BUTTON flag.

Furthermore, rfkill expects the timeout as a value in milliseconds
instead of jiffies. Also increase the timeout to a second,
since this 250ms would be overkill.

Also the flag DEVICE_ENABLED_RADIO_HW is causing problems
for devices which do not support the hardware button
while rfkill is enabled in the driver.

To remidy this we should inverse the flag and its meaning,
rename the flag to DEVICE_DISABLED_RADIO_HW this means that
by default the radio is enabled by the hardware button (if present)
and can only be disabled explicitely.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |    6 ++++--
 drivers/net/wireless/rt2x00/rt2500pci.c    |    6 ++++--
 drivers/net/wireless/rt2x00/rt2x00.h       |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    3 +--
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   10 ++--------
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c      |    6 ++++--
 7 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index ee62daa..7f2db6d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -244,6 +244,8 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
 	return rt2x00_get_field32(reg, GPIOCSR_BIT0);
 }
+#else
+#define rt2400pci_rfkill_poll	NULL
 #endif /* CONFIG_RT2400PCI_RFKILL */
 
 /*
@@ -1357,8 +1359,10 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
+#ifdef CONFIG_RT2400PCI_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
+#endif /* CONFIG_RT2400PCI_RFKILL */
 
 	/*
 	 * Check if the BBP tuning should be enabled.
@@ -1623,9 +1627,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
 	.set_device_state	= rt2400pci_set_device_state,
-#ifdef CONFIG_RT2400PCI_RFKILL
 	.rfkill_poll		= rt2400pci_rfkill_poll,
-#endif /* CONFIG_RT2400PCI_RFKILL */
 	.link_stats		= rt2400pci_link_stats,
 	.reset_tuner		= rt2400pci_reset_tuner,
 	.link_tuner		= rt2400pci_link_tuner,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 1137c26..1f70917 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -244,6 +244,8 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
 	return rt2x00_get_field32(reg, GPIOCSR_BIT0);
 }
+#else
+#define rt2500pci_rfkill_poll	NULL
 #endif /* CONFIG_RT2500PCI_RFKILL */
 
 /*
@@ -1527,8 +1529,10 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
+#ifdef CONFIG_RT2500PCI_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
+#endif /* CONFIG_RT2500PCI_RFKILL */
 
 	/*
 	 * Check if the BBP tuning should be enabled.
@@ -1934,9 +1938,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
 	.set_device_state	= rt2500pci_set_device_state,
-#ifdef CONFIG_RT2500PCI_RFKILL
 	.rfkill_poll		= rt2500pci_rfkill_poll,
-#endif /* CONFIG_RT2500PCI_RFKILL */
 	.link_stats		= rt2500pci_link_stats,
 	.reset_tuner		= rt2500pci_reset_tuner,
 	.link_tuner		= rt2500pci_link_tuner,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9bb5fb9..235e5ad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -451,7 +451,7 @@ enum rt2x00_flags {
 	DEVICE_STARTED,
 	DEVICE_STARTED_SUSPEND,
 	DEVICE_ENABLED_RADIO,
-	DEVICE_ENABLED_RADIO_HW,
+	DEVICE_DISABLED_RADIO_HW,
 
 	/*
 	 * Driver features
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 1e07c39..6dc4f63 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -104,8 +104,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * And check if the hardware button has been disabled.
 	 */
 	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) &&
-	     !test_bit(DEVICE_ENABLED_RADIO_HW, &rt2x00dev->flags)))
+	    test_bit(DEVICE_DISABLED_RADIO_HW, &rt2x00dev->flags))
 		return 0;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 6dd92eb..0ab39ca 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -28,9 +28,10 @@
 
 /*
  * Interval defines
+ * Both the link tuner as the rfkill will be called once per second.
  */
 #define LINK_TUNE_INTERVAL	( round_jiffies(HZ) )
-#define RFKILL_POLL_INTERVAL	( HZ / 4 )
+#define RFKILL_POLL_INTERVAL	( 1000 )
 
 /*
  * Radio control handlers.
@@ -98,13 +99,6 @@ void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev);
 #else
 static inline int rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
-	/*
-	 * Force enable this flag, this will assure that
-	 * devices with a hardware button but without rfkill support
-	 * can still use their hardware.
-	 */
-	__set_bit(DEVICE_ENABLED_RADIO_HW, &rt2x00dev->flags);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 06af014..a0f8b8e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -52,11 +52,11 @@ static int rt2x00rfkill_toggle_radio(void *data, enum rfkill_state state)
 
 	if (state == RFKILL_STATE_ON) {
 		INFO(rt2x00dev, "Hardware button pressed, enabling radio.\n");
-		__set_bit(DEVICE_ENABLED_RADIO_HW, &rt2x00dev->flags);
+		__clear_bit(DEVICE_DISABLED_RADIO_HW, &rt2x00dev->flags);
 		retval = rt2x00lib_enable_radio(rt2x00dev);
 	} else if (state == RFKILL_STATE_OFF) {
 		INFO(rt2x00dev, "Hardware button pressed, disabling radio.\n");
-		__clear_bit(DEVICE_ENABLED_RADIO_HW, &rt2x00dev->flags);
+		__set_bit(DEVICE_DISABLED_RADIO_HW, &rt2x00dev->flags);
 		rt2x00lib_disable_radio(rt2x00dev);
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 5ae09e3..ba6153a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -269,6 +269,8 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
 	return rt2x00_get_field32(reg, MAC_CSR13_BIT5);;
 }
+#else
+#define rt61pci_rfkill_poll	NULL
 #endif /* CONFIG_RT61PCI_RFKILL */
 
 /*
@@ -2088,8 +2090,10 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
+#ifdef CONFIG_RT61PCI_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
+#endif /* CONFIG_RT61PCI_RFKILL */
 
 	/*
 	 * Read frequency offset and RF programming sequence.
@@ -2529,9 +2533,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
 	.set_device_state	= rt61pci_set_device_state,
-#ifdef CONFIG_RT61PCI_RFKILL
 	.rfkill_poll		= rt61pci_rfkill_poll,
-#endif /* CONFIG_RT61PCI_RFKILL */
 	.link_stats		= rt61pci_link_stats,
 	.reset_tuner		= rt61pci_reset_tuner,
 	.link_tuner		= rt61pci_link_tuner,
-- 
1.5.3.4

