Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:61558 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030650AbXDLSGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 14:06:24 -0400
Received: by ug-out-1314.google.com with SMTP id 44so387077uga
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2007 11:06:22 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>
Subject: Please pull from "upstream" branch of rt2x00
Date: Thu, 12 Apr 2007 20:05:29 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200704122005.29919.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is quite fast after the previous pull request,
but this fixes several important bugs where the most
important 2 are the debugsfs fixes.

After these fedora bugs should be fixed.
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233345
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233434

Ivo

---

The following changes since commit fd349fec02854ab413d9aa47c732f892a13f83b6:
  John W. Linville (1):
        Merge branch 'zd1211rw-week15' of git://git.kernel.org/.../mwu/mac80211-drivers

are found in the git repository at:

  http://git.serialmonkey.com/rt2x00.git/ upstream

Ivo van Doorn (8):
      rt2x00: Add new rt73 USB ID
      rt2x00: Add new "invisible" config options for PCI and USB
      rt2x00: Don't unregister unregistered interfaces
      rt2x00: Create generic rt2x00lib_{enable,disable}_radio() function
      rt2x00: rt2x00debug should be compiled into rt2x00lib
      Merge branch 'wireless-dev'
      rt2x00: Fix debugfs register length handling
      rt2x00: Fix crash during rmmod with debugfs enabled

 drivers/net/wireless/mac80211/rt2x00/Kconfig       |   15 +++++-
 drivers/net/wireless/mac80211/rt2x00/Makefile      |    5 +-
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c   |   59 ++++---------------
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.h   |    6 --
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c   |   59 ++++---------------
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.h   |    6 --
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c   |   58 ++++---------------
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.h   |    6 --
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h      |    5 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c |   46 +++------------
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h |    5 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c   |   51 +++++++++++++++++
 drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h   |    6 ++
 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c   |   12 ++--
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c     |   55 ++++--------------
 drivers/net/wireless/mac80211/rt2x00/rt61pci.h     |    6 --
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c     |   59 +++++---------------
 drivers/net/wireless/mac80211/rt2x00/rt73usb.h     |    6 --
 18 files changed, 163 insertions(+), 302 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/Kconfig b/drivers/net/wireless/mac80211/rt2x00/Kconfig
index 31541ed..af67572 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Kconfig
+++ b/drivers/net/wireless/mac80211/rt2x00/Kconfig
@@ -15,6 +15,14 @@ config RT2X00_LIB
 	tristate
 	depends on RT2X00
 
+config RT2X00_LIB_PCI
+	tristate
+	depends on RT2X00
+
+config RT2X00_LIB_USB
+	tristate
+	depends on RT2X00
+
 config RT2X00_LIB_FIRMWARE
 	boolean
 	depends on RT2X00
@@ -23,6 +31,7 @@ config RT2400PCI
 	tristate "Ralink rt2400 pci/pcmcia support"
 	depends on RT2X00 && PCI
 	select RT2X00_LIB
+	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
 	This is an experimental driver for the Ralink rt2400 wireless chip.
@@ -33,6 +42,7 @@ config RT2500PCI
 	tristate "Ralink rt2500 pci/pcmcia support"
 	depends on RT2X00 && PCI
 	select RT2X00_LIB
+	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
 	This is an experimental driver for the Ralink rt2500 wireless chip.
@@ -43,6 +53,7 @@ config RT61PCI
 	tristate "Ralink rt61 pci/pcmcia support"
 	depends on RT2X00 && FW_LOADER && PCI
 	select RT2X00_LIB
+	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
 	select CRC_ITU_T
 	select EEPROM_93CX6
@@ -55,6 +66,7 @@ config RT2500USB
 	tristate "Ralink rt2500 usb support"
 	depends on RT2X00 && USB
 	select RT2X00_LIB
+	select RT2X00_LIB_USB
 	---help---
 	This is an experimental driver for the Ralink rt2500 wireless chip.
 
@@ -64,6 +76,7 @@ config RT73USB
 	tristate "Ralink rt73 usb support"
 	depends on RT2X00 && FW_LOADER && USB
 	select RT2X00_LIB
+	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
 	select CRC_ITU_T
 	---help---
@@ -72,7 +85,7 @@ config RT73USB
 	When compiled as a module, this driver will be called "rt73usb.ko".
 
 config RT2X00_DEBUGFS
-	tristate "Ralink debugfs support"
+	bool "Ralink debugfs support"
 	depends on RT2X00 && RT2X00_LIB && MAC80211_DEBUGFS
 	---help---
 	Enable creation of debugfs files for the rt2x00 drivers.
diff --git a/drivers/net/wireless/mac80211/rt2x00/Makefile b/drivers/net/wireless/mac80211/rt2x00/Makefile
index 52f8b1e..f3a2cb1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Makefile
+++ b/drivers/net/wireless/mac80211/rt2x00/Makefile
@@ -1,9 +1,12 @@
 rt2x00lib-objs := rt2x00dev.o rt2x00mac.o
 
+ifeq ($(CONFIG_RT2X00_DEBUGFS),y)
+	rt2x00lib-objs += rt2x00debug.o
+endif
+
 obj-$(CONFIG_RT2X00_LIB)	+= rt2x00lib.o
 obj-$(CONFIG_RT2400PCI)		+= rt2400pci.o
 obj-$(CONFIG_RT2500PCI)		+= rt2500pci.o
 obj-$(CONFIG_RT61PCI)		+= rt61pci.o
 obj-$(CONFIG_RT2500USB)		+= rt2500usb.o
 obj-$(CONFIG_RT73USB)		+= rt73usb.o
-obj-$(CONFIG_RT2X00_DEBUGFS)	+= rt2x00debug.o
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 4b1afb9..9bf40cd 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -186,7 +186,7 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, RFCSR, reg);
 }
 
-#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#ifdef CONFIG_RT2X00_DEBUGFS
 #include "rt2x00debug.h"
 
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
@@ -235,32 +235,33 @@ static struct rt2x00debug rt2400pci_rt2x00debug = {
 		.read		= rt2400pci_read_csr,
 		.write		= rt2400pci_write_csr,
 		.word_size	= sizeof(u32),
-		.length		= CSR_REG_SIZE,
+		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
 	.reg_eeprom	= {
 		.read		= rt2400pci_read_eeprom,
 		.write		= rt2400pci_write_eeprom,
 		.word_size	= sizeof(u16),
-		.length		= EEPROM_SIZE,
+		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.reg_bbp	= {
 		.read		= rt2400pci_read_bbp,
 		.write		= rt2400pci_write_bbp,
 		.word_size	= sizeof(u8),
-		.length		= BBP_SIZE,
+		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 };
 
 static void rt2400pci_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	if (!rt2x00debug_register(&rt2400pci_rt2x00debug,
-		rt2x00dev->hw->wiphy, rt2x00dev))
+	rt2x00dev->debugfs_intf = rt2x00debug_register(
+		&rt2400pci_rt2x00debug, rt2x00dev->hw->wiphy, rt2x00dev);
+	if (!rt2x00dev->debugfs_intf)
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt2400pci_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
+	rt2x00debug_deregister(rt2x00dev->debugfs_intf);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt2400pci_open_debugfs(struct rt2x00_dev *rt2x00dev){}
@@ -1235,36 +1236,21 @@ static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	/*
-	 * Don't enable the radio twice.
-	 * or if the hardware button has been disabled.
-	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return 0;
-
-	/*
 	 * Initialize all registers.
 	 */
 	if (rt2400pci_init_rings(rt2x00dev) ||
 	    rt2400pci_init_registers(rt2x00dev) ||
 	    rt2400pci_init_bbp(rt2x00dev)) {
 		ERROR("Register initialization failed.\n");
-		goto exit_fail;
+		return -EIO;
 	}
 
 	/*
-	 * Determine channel change time.
-	 */
-	if (rt2x00lib_detect_channel_time(rt2x00dev))
-		goto exit_fail;
-
-	/*
 	 * Clear interrupts.
 	 */
 	rt2x00_register_read(rt2x00dev, CSR7, &reg);
 	rt2x00_register_write(rt2x00dev, CSR7, reg);
 
-	SET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
 	/*
 	 * Enable interrupts.
 	 */
@@ -1277,40 +1263,22 @@ static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_register_write(rt2x00dev, CSR8, reg);
 
 	/*
-	 * Enable RX.
-	 */
-	rt2400pci_toggle_rx(rt2x00dev, 1);
-
-	/*
 	 * Enable LED
 	 */
 	rt2400pci_enable_led(rt2x00dev);
 
-	ieee80211_start_queues(rt2x00dev->hw);
-
 	return 0;
-
-exit_fail:
-	rt2400pci_uninitialize(rt2x00dev);
-	return -EIO;
 }
 
 static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return;
-
-	ieee80211_stop_queues(rt2x00dev->hw);
-
 	/*
 	 * Disable LED
 	 */
 	rt2400pci_disable_led(rt2x00dev);
 
-	CLEAR_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
 	rt2x00_register_write(rt2x00dev, PWRCSR0, 0);
 
 	/*
@@ -1325,8 +1293,6 @@ static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
 	rt2x00_register_write(rt2x00dev, TXCSR0, reg);
 
-	rt2400pci_toggle_rx(rt2x00dev, 0);
-
 	/*
 	 * Disable interrupts.
 	 */
@@ -2450,12 +2416,13 @@ static void rt2400pci_remove(struct pci_dev *pci_dev)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
+	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
+		ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt2400pci driver data.
 	 */
-	rt2400pci_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 	rt2400pci_uninitialize(rt2x00dev);
 	rt2400pci_free_dev(rt2x00dev);
 
@@ -2484,7 +2451,7 @@ static int rt2400pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	/*
 	 * Disable the radio.
 	 */
-	rt2400pci_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 
 	/*
 	 * Set device mode to sleep for power management.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
index 585c5aa..333b240 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
@@ -916,12 +916,6 @@ static void rt2400pci_activity_led(struct rt2x00_dev *rt2x00dev,
 	char activity);
 
 /*
- * Radio control functions.
- */
-static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev);
-static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev);
-
-/*
  * Interrupt functions.
  */
 static void rt2400pci_rxdone(struct work_struct *work);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index b052220..033c765 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -186,7 +186,7 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, RFCSR, reg);
 }
 
-#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#ifdef CONFIG_RT2X00_DEBUGFS
 #include "rt2x00debug.h"
 
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
@@ -235,32 +235,33 @@ static struct rt2x00debug rt2500pci_rt2x00debug = {
 		.read		= rt2500pci_read_csr,
 		.write		= rt2500pci_write_csr,
 		.word_size	= sizeof(u32),
-		.length		= CSR_REG_SIZE,
+		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
 	.reg_eeprom	= {
 		.read		= rt2500pci_read_eeprom,
 		.write		= rt2500pci_write_eeprom,
 		.word_size	= sizeof(u16),
-		.length		= EEPROM_SIZE,
+		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.reg_bbp	= {
 		.read		= rt2500pci_read_bbp,
 		.write		= rt2500pci_write_bbp,
 		.word_size	= sizeof(u8),
-		.length		= BBP_SIZE,
+		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 };
 
 static void rt2500pci_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	if (!rt2x00debug_register(&rt2500pci_rt2x00debug,
-		rt2x00dev->hw->wiphy, rt2x00dev))
+	rt2x00dev->debugfs_intf = rt2x00debug_register(
+		&rt2500pci_rt2x00debug, rt2x00dev->hw->wiphy, rt2x00dev);
+	if (!rt2x00dev->debugfs_intf)
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt2500pci_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
+	rt2x00debug_deregister(rt2x00dev->debugfs_intf);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt2500pci_open_debugfs(struct rt2x00_dev *rt2x00dev){}
@@ -1361,36 +1362,21 @@ static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	/*
-	 * Don't enable the radio twice,
-	 * or if the hardware button has been disabled.
-	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return 0;
-
-	/*
 	 * Initialize all registers.
 	 */
 	if (rt2500pci_init_rings(rt2x00dev) ||
 	    rt2500pci_init_registers(rt2x00dev) ||
 	    rt2500pci_init_bbp(rt2x00dev)) {
 		ERROR("Register initialization failed.\n");
-		goto exit_fail;
+		return -EIO;
 	}
 
 	/*
-	 * Determine channel change time.
-	 */
-	if (rt2x00lib_detect_channel_time(rt2x00dev))
-		goto exit_fail;
-
-	/*
 	 * Clear interrupts.
 	 */
 	rt2x00_register_read(rt2x00dev, CSR7, &reg);
 	rt2x00_register_write(rt2x00dev, CSR7, reg);
 
-	SET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
 	/*
 	 * Enable interrupts.
 	 */
@@ -1403,40 +1389,22 @@ static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_register_write(rt2x00dev, CSR8, reg);
 
 	/*
-	 * Enable RX.
-	 */
-	rt2500pci_toggle_rx(rt2x00dev, 1);
-
-	/*
 	 * Enable LED
 	 */
 	rt2500pci_enable_led(rt2x00dev);
 
-	ieee80211_start_queues(rt2x00dev->hw);
-
 	return 0;
-
-exit_fail:
-	rt2500pci_uninitialize(rt2x00dev);
-	return -EIO;
 }
 
 static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return;
-
-	ieee80211_stop_queues(rt2x00dev->hw);
-
 	/*
 	 * Disable LED
 	 */
 	rt2500pci_disable_led(rt2x00dev);
 
-	CLEAR_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
 	rt2x00_register_write(rt2x00dev, PWRCSR0, 0);
 
 	/*
@@ -1451,8 +1419,6 @@ static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
 	rt2x00_register_write(rt2x00dev, TXCSR0, reg);
 
-	rt2500pci_toggle_rx(rt2x00dev, 0);
-
 	/*
 	 * Disable interrupts.
 	 */
@@ -2747,12 +2713,13 @@ static void rt2500pci_remove(struct pci_dev *pci_dev)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
+	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
+		ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt2500pci driver data.
 	 */
-	rt2500pci_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 	rt2500pci_uninitialize(rt2x00dev);
 	rt2500pci_free_dev(rt2x00dev);
 
@@ -2781,7 +2748,7 @@ static int rt2500pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	/*
 	 * Disable the radio.
 	 */
-	rt2500pci_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 
 	/*
 	 * Set device mode to sleep for power management.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
index fd7cd1a..5c32b48 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
@@ -1183,12 +1183,6 @@ static void rt2500pci_activity_led(struct rt2x00_dev *rt2x00dev,
 	char activity);
 
 /*
- * Radio control functions.
- */
-static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev);
-static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev);
-
-/*
  * Interrupt functions.
  */
 static void rt2500pci_rxdone(struct work_struct *work);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index e023711..a67568a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -228,7 +228,7 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, PHY_CSR10, reg);
 }
 
-#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#ifdef CONFIG_RT2X00_DEBUGFS
 #include "rt2x00debug.h"
 
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u16)) )
@@ -277,32 +277,33 @@ static struct rt2x00debug rt2500usb_rt2x00debug = {
 		.read		= rt2500usb_read_csr,
 		.write		= rt2500usb_write_csr,
 		.word_size	= sizeof(u16),
-		.length		= CSR_REG_SIZE,
+		.word_count	= CSR_REG_SIZE / sizeof(u16),
 	},
 	.reg_eeprom	= {
 		.read		= rt2500usb_read_eeprom,
 		.write		= rt2500usb_write_eeprom,
 		.word_size	= sizeof(u16),
-		.length		= EEPROM_SIZE,
+		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.reg_bbp	= {
 		.read		= rt2500usb_read_bbp,
 		.write		= rt2500usb_write_bbp,
 		.word_size	= sizeof(u8),
-		.length		= BBP_SIZE,
+		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 };
 
 static void rt2500usb_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	if (!rt2x00debug_register(&rt2500usb_rt2x00debug,
-		rt2x00dev->hw->wiphy, rt2x00dev))
+	rt2x00dev->debugfs_intf = rt2x00debug_register(
+		&rt2500usb_rt2x00debug, rt2x00dev->hw->wiphy, rt2x00dev);
+	if (!rt2x00dev->debugfs_intf)
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt2500usb_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
+	rt2x00debug_deregister(rt2x00dev->debugfs_intf);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt2500usb_open_debugfs(struct rt2x00_dev *rt2x00dev){}
@@ -1281,34 +1282,15 @@ static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 
 	/*
-	 * Don't enable the radio twice.
-	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return 0;
-
-	/*
 	 * Initialize all registers.
 	 */
 	if (rt2500usb_init_rings(rt2x00dev) ||
 	    rt2500usb_init_registers(rt2x00dev) ||
 	    rt2500usb_init_bbp(rt2x00dev)) {
 		ERROR("Register initialization failed.\n");
-		goto exit_fail;
+		return -EIO;
 	}
 
-	/*
-	 * Determine channel change time.
-	 */
-	if (rt2x00lib_detect_channel_time(rt2x00dev))
-		goto exit_fail;
-
-	SET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
-	/*
-	 * Enable RX.
-	 */
-	rt2500usb_toggle_rx(rt2x00dev, 1);
-
 	ring = &rt2x00dev->ring[RING_RX];
 	for (i = 0; i < ring->stats.limit; i++) {
 		SET_FLAG(&ring->entry[i], ENTRY_OWNER_NIC);
@@ -1320,13 +1302,7 @@ static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2500usb_enable_led(rt2x00dev);
 
-	ieee80211_start_queues(rt2x00dev->hw);
-
 	return 0;
-
-exit_fail:
-	rt2500usb_uninitialize(rt2x00dev);
-	return -EIO;
 }
 
 static void rt2500usb_disable_radio(struct rt2x00_dev *rt2x00dev)
@@ -1334,18 +1310,11 @@ static void rt2500usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	struct data_ring *ring;
 	unsigned int i;
 
-	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return;
-
-	ieee80211_stop_queues(rt2x00dev->hw);
-
 	/*
 	 * Disable LED
 	 */
 	rt2500usb_disable_led(rt2x00dev);
 
-	CLEAR_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
 	rt2x00_register_write(rt2x00dev, MAC_CSR13, 0x2121);
 	rt2x00_register_write(rt2x00dev, MAC_CSR14, 0x2121);
 
@@ -1357,8 +1326,6 @@ static void rt2500usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Cancel RX and TX.
 	 */
-	rt2500usb_toggle_rx(rt2x00dev, 0);
-
 	rt2x00_vendor_request(rt2x00dev, USB_RX_CONTROL,
 		USB_VENDOR_REQUEST_OUT, 0x00, 0x00, NULL, 0, REGISTER_TIMEOUT);
 
@@ -2545,12 +2512,13 @@ static void rt2500usb_disconnect(struct usb_interface *usb_intf)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
+	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
+		ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt2500usb driver data.
 	 */
-	rt2500usb_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 	rt2500usb_uninitialize(rt2x00dev);
 	rt2500usb_free_dev(rt2x00dev);
 
@@ -2579,7 +2547,7 @@ static int rt2500usb_suspend(struct usb_interface *usb_intf,
 	/*
 	 * Disable the radio.
 	 */
-	rt2500usb_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 
 	/*
 	 * Set device mode to sleep for power management.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
index 287160c..c3e2d6b 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -731,12 +731,6 @@ static void rt2500usb_enable_led(struct rt2x00_dev *rt2x00dev);
 static void rt2500usb_disable_led(struct rt2x00_dev *rt2x00dev);
 
 /*
- * Radio control functions.
- */
-static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev);
-static void rt2500usb_disable_radio(struct rt2x00_dev *rt2x00dev);
-
-/*
  * Interrupt functions.
  */
 static void rt2500usb_interrupt_beacondone(struct urb *urb);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index 38fae66..a0bb0ab 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -809,9 +809,10 @@ struct rt2x00_dev {
 	void __iomem *csr_addr;
 
 	/*
-	 * If enabled, the structure for the debugfs files.
+	 * If enabled, the debugfs interface that should be
+	 * used for deregistration of debugfs.
 	 */
-	void *debugfs_data;
+	struct rt2x00debug_intf *debugfs_intf;
 
 	/*
 	 * Queue for deferred work.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
index 290fa12..9b8138d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
@@ -19,16 +19,12 @@
  */
 
 /*
-	Module: rt2x00debug
-	Abstract: rt2x00debug specific routines.
+	Module: rt2x00lib
+	Abstract: rt2x00 debugfs specific routines.
 	Supported chipsets: RT2460, RT2560, RT2570,
 	rt2561, rt2561s, rt2661 & rt2573.
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/version.h>
-#include <linux/init.h>
 #include <linux/debugfs.h>
 
 #include <asm/uaccess.h>
@@ -187,7 +183,7 @@ exit:
 		struct rt2x00debug *debug = intf->debug;		\
 		struct rt2x00debug_reg *reg = &debug->reg_##__name;	\
 									\
-		if (intf->offset_##__name > reg->length)		\
+		if (intf->offset_##__name > reg->word_count)		\
 			return -EINVAL;					\
 									\
 		return rt2x00debug_file_read(intf->rt2x00dev, buf,	\
@@ -206,7 +202,7 @@ RT2X00DEBUGFS_OPS_READ(bbp);
 		struct rt2x00debug *debug = intf->debug;		\
 		struct rt2x00debug_reg *reg = &debug->reg_##__name;	\
 									\
-		if (intf->offset_##__name > reg->length)		\
+		if (intf->offset_##__name > reg->word_count)		\
 			return -EINVAL;					\
 									\
 		return rt2x00debug_file_write(intf->rt2x00dev, buf,	\
@@ -260,9 +256,9 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 		return NULL;
 
 	blob->data = data;
-	data += sprintf(data, "csr length: %d\n", debug->reg_csr.length);
-	data += sprintf(data, "eeprom length: %d\n", debug->reg_eeprom.length);
-	data += sprintf(data, "bbp length: %d\n", debug->reg_bbp.length);
+	data += sprintf(data, "csr length: %d\n", debug->reg_csr.word_count);
+	data += sprintf(data, "eeprom length: %d\n", debug->reg_eeprom.word_count);
+	data += sprintf(data, "bbp length: %d\n", debug->reg_bbp.word_count);
 	blob->size = strlen(blob->data);
 
 	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
@@ -331,17 +327,15 @@ void *rt2x00debug_register(struct rt2x00debug *debug, struct wiphy *wiphy,
 	return intf;
 
 exit:
-	rt2x00debug_deregister(debug);
+	rt2x00debug_deregister(intf);
 
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(rt2x00debug_register);
 
-void rt2x00debug_deregister(void *debugfs_data)
+void rt2x00debug_deregister(struct rt2x00debug_intf *intf)
 {
-	struct rt2x00debug_intf *intf = debugfs_data;
-
-	if (!intf)
+	if (unlikely(!intf))
 		return;
 
 	debugfs_remove(intf->bbp_val_entry);
@@ -358,23 +352,3 @@ void rt2x00debug_deregister(void *debugfs_data)
 	kfree(intf);
 }
 EXPORT_SYMBOL_GPL(rt2x00debug_deregister);
-
-/*
- * rt2x00debug module information.
- */
-MODULE_AUTHOR("http://rt2x00.serialmonkey.com");
-MODULE_DESCRIPTION("Debugfs support for rt2x00 drivers.");
-MODULE_LICENSE("GPL");
-
-static int __init rt2x00debug_init(void)
-{
-	return 0;
-}
-
-static void __exit rt2x00debug_exit(void)
-{
-
-}
-
-module_init(rt2x00debug_init);
-module_exit(rt2x00debug_exit);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
index ef8401d..6c98718 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
@@ -31,6 +31,7 @@
 #include <net/wireless.h>
 
 struct rt2x00_dev;
+struct rt2x00debug_intf;
 
 typedef void (debug_access_t)(struct rt2x00_dev *rt2x00dev,
 	const unsigned long word, void *data);
@@ -40,7 +41,7 @@ struct rt2x00debug_reg {
 	debug_access_t *write;
 
 	unsigned int word_size;
-	unsigned int length;
+	unsigned int word_count;
 };
 
 struct rt2x00debug {
@@ -65,6 +66,6 @@ struct rt2x00debug {
 
 void *rt2x00debug_register(struct rt2x00debug *debug, struct wiphy *wiphy,
 	struct rt2x00_dev *rt2x00dev);
-void rt2x00debug_deregister(void *debugfs_data);
+void rt2x00debug_deregister(struct rt2x00debug_intf *intf);
 
 #endif /* RT2X00DEBUG_H */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
index 39a3be2..8854bb2 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
@@ -40,6 +40,57 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
+/*
+ * Radio control handlers.
+ */
+int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
+{
+	int status;
+
+	/*
+	 * Don't enable the radio twice.
+	 * or if the hardware button has been disabled.
+	 */
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
+		return 0;
+
+	status = rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+	if (status)
+		return status;
+
+	/*
+	 * Determine channel change time.
+	 */
+	if (rt2x00lib_detect_channel_time(rt2x00dev)) {
+		rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+		return -EIO;
+	}
+
+	SET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
+
+	rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 1);
+
+	ieee80211_start_queues(rt2x00dev->hw);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_enable_radio);
+
+void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
+{
+	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
+		return;
+
+	ieee80211_stop_queues(rt2x00dev->hw);
+
+	rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 0);
+
+	CLEAR_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
+
+	rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_disable_radio);
+
 #ifdef CONFIG_RT2X00_LIB_FIRMWARE
 struct fw_entry {
 	u32	chip;
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
index 63fbef6..0a04255 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
@@ -31,6 +31,12 @@
 #include <linux/firmware.h>
 
 /*
+ * Radio control handlers.
+ */
+int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev);
+void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev);
+
+/*
  * Firmware handlers.
  */
 #ifdef CONFIG_RT2X00_LIB_FIRMWARE
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
index eaf267a..569996d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
@@ -118,8 +118,8 @@ int rt2x00lib_reset(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
-	rt2x00dev->lib_ops->disable_radio(rt2x00dev);
-	return rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
+	return rt2x00lib_enable_radio(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_reset);
 
@@ -172,7 +172,7 @@ int rt2x00lib_add_interface(struct ieee80211_hw *hw,
 		/*
 		 * Enable radio.
 		 */
-		status = rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+		status = rt2x00lib_enable_radio(rt2x00dev);
 		if (status)
 			return status;
 	}
@@ -238,7 +238,7 @@ void rt2x00lib_remove_interface(struct ieee80211_hw *hw,
 	 */
 	if (!GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
 	    !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
-		rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+		rt2x00lib_disable_radio(rt2x00dev);
 
 	/*
 	 * Check if we still have 1 non-monitor or a monitor
@@ -275,7 +275,7 @@ int rt2x00lib_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	 */
 	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
 		if (!conf->radio_enabled)
-			rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+			rt2x00lib_disable_radio(rt2x00dev);
 		else {
 			rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 0);
 		}
@@ -297,7 +297,7 @@ int rt2x00lib_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
 		rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 1);
 	} else if (conf->radio_enabled)
-		return rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+		return rt2x00lib_enable_radio(rt2x00dev);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index d2ee3f5..ed11d26 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -217,7 +217,7 @@ static void rt2x00_mcu_request(const struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, HOST_CMD_CSR, reg);
 }
 
-#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#ifdef CONFIG_RT2X00_DEBUGFS
 #include "rt2x00debug.h"
 
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
@@ -266,32 +266,33 @@ static struct rt2x00debug rt61pci_rt2x00debug = {
 		.read		= rt61pci_read_csr,
 		.write		= rt61pci_write_csr,
 		.word_size	= sizeof(u32),
-		.length		= CSR_REG_SIZE,
+		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
 	.reg_eeprom	= {
 		.read		= rt61pci_read_eeprom,
 		.write		= rt61pci_write_eeprom,
 		.word_size	= sizeof(u16),
-		.length		= EEPROM_SIZE,
+		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.reg_bbp	= {
 		.read		= rt61pci_read_bbp,
 		.write		= rt61pci_write_bbp,
 		.word_size	= sizeof(u8),
-		.length		= BBP_SIZE,
+		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 };
 
 static void rt61pci_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	if (!rt2x00debug_register(&rt61pci_rt2x00debug,
-		rt2x00dev->hw->wiphy, rt2x00dev))
+	rt2x00dev->debugfs_intf = rt2x00debug_register(
+		&rt61pci_rt2x00debug, rt2x00dev->hw->wiphy, rt2x00dev);
+	if (!rt2x00dev->debugfs_intf)
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt61pci_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
+	rt2x00debug_deregister(rt2x00dev->debugfs_intf);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt61pci_open_debugfs(struct rt2x00_dev *rt2x00dev){}
@@ -1631,29 +1632,16 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	/*
-	 * Don't enable the radio twice.
-	 * or if the hardware button has been disabled.
-	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return 0;
-
-	/*
 	 * Initialize all registers.
 	 */
 	if (rt61pci_init_rings(rt2x00dev) ||
 	    rt61pci_init_registers(rt2x00dev) ||
 	    rt61pci_init_bbp(rt2x00dev)) {
 		ERROR("Register initialization failed.\n");
-		goto exit_fail;
+		return -EIO;
 	}
 
 	/*
-	 * Determine channel change time.
-	 */
-	if (rt2x00lib_detect_channel_time(rt2x00dev))
-		goto exit_fail;
-
-	/*
 	 * Clear interrupts.
 	 */
 	rt2x00_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
@@ -1662,8 +1650,6 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg);
 	rt2x00_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg);
 
-	SET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
 	/*
 	 * Enable interrupts.
 	 */
@@ -1678,38 +1664,24 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Enable RX.
 	 */
 	rt2x00_register_write(rt2x00dev, RX_CNTL_CSR, 0x00000001);
-	rt61pci_toggle_rx(rt2x00dev, 1);
 
 	/*
 	 * Enable LED
 	 */
 	rt61pci_enable_led(rt2x00dev);
 
-	ieee80211_start_queues(rt2x00dev->hw);
-
 	return 0;
-
-exit_fail:
-	rt61pci_uninitialize(rt2x00dev);
-	return -EIO;
 }
 
 static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return;
-
-	ieee80211_stop_queues(rt2x00dev->hw);
-
 	/*
 	 * Disable LED
 	 */
 	rt61pci_disable_led(rt2x00dev);
 
-	CLEAR_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
 	rt2x00_register_write(rt2x00dev, MAC_CSR10, 0x00001818);
 
 	/*
@@ -1728,8 +1700,6 @@ static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_MGMT, 1);
 	rt2x00_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 
-	rt61pci_toggle_rx(rt2x00dev, 0);
-
 	/*
 	 * Disable interrupts.
 	 */
@@ -3211,12 +3181,13 @@ static void rt61pci_remove(struct pci_dev *pci_dev)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
+	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
+		ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt61pci driver data.
 	 */
-	rt61pci_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 	rt61pci_uninitialize(rt2x00dev);
 	rt61pci_free_dev(rt2x00dev);
 
@@ -3245,7 +3216,7 @@ static int rt61pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	/*
 	 * Disable the radio.
 	 */
-	rt61pci_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 
 	/*
 	 * Set device mode to sleep for power management.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
index 4c97ba8..44de73f 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
@@ -1346,12 +1346,6 @@ static void rt61pci_disable_led(struct rt2x00_dev *rt2x00dev);
 static void rt61pci_activity_led(struct rt2x00_dev *rt2x00dev, char rssi);
 
 /*
- * Radio control functions.
- */
-static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev);
-static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev);
-
-/*
  * Interrupt functions.
  */
 static void rt61pci_rxdone(struct work_struct *work);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 837ceb1..dde1065 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -224,7 +224,7 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, PHY_CSR4, reg);
 }
 
-#if defined(CONFIG_RT2X00_DEBUGFS) || defined(CONFIG_RT2X00_DEBUGFS_MODULE)
+#ifdef CONFIG_RT2X00_DEBUGFS
 #include "rt2x00debug.h"
 
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
@@ -273,32 +273,33 @@ static struct rt2x00debug rt73usb_rt2x00debug = {
 		.read		= rt73usb_read_csr,
 		.write		= rt73usb_write_csr,
 		.word_size	= sizeof(u32),
-		.length		= CSR_REG_SIZE,
+		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
 	.reg_eeprom	= {
 		.read		= rt73usb_read_eeprom,
 		.write		= rt73usb_write_eeprom,
 		.word_size	= sizeof(u16),
-		.length		= EEPROM_SIZE,
+		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.reg_bbp	= {
 		.read		= rt73usb_read_bbp,
 		.write		= rt73usb_write_bbp,
 		.word_size	= sizeof(u8),
-		.length		= BBP_SIZE,
+		.word_count	= BBP_SIZE / sizeof(u8),
 	},
 };
 
 static void rt73usb_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	if (!rt2x00debug_register(&rt73usb_rt2x00debug,
-		rt2x00dev->hw->wiphy, rt2x00dev))
+	rt2x00dev->debugfs_intf = rt2x00debug_register(
+		&rt73usb_rt2x00debug, rt2x00dev->hw->wiphy, rt2x00dev);
+	if (!rt2x00dev->debugfs_intf)
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt73usb_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
+	rt2x00debug_deregister(rt2x00dev->debugfs_intf);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt73usb_open_debugfs(struct rt2x00_dev *rt2x00dev){}
@@ -1410,34 +1411,15 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 
 	/*
-	 * Don't enable the radio twice.
-	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return 0;
-
-	/*
 	 * Initialize all registers.
 	 */
 	if (rt73usb_init_rings(rt2x00dev) ||
 	    rt73usb_init_registers(rt2x00dev) ||
 	    rt73usb_init_bbp(rt2x00dev)) {
 		ERROR("Register initialization failed.\n");
-		goto exit_fail;
+		return -EIO;
 	}
 
-	/*
-	 * Determine channel change time.
-	 */
-	if (rt2x00lib_detect_channel_time(rt2x00dev))
-		goto exit_fail;
-
-	SET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
-	/*
-	 * Enable RX.
-	 */
-	rt73usb_toggle_rx(rt2x00dev, 1);
-
 	ring = &rt2x00dev->ring[RING_RX];
 	for (i = 0; i < ring->stats.limit; i++) {
 		SET_FLAG(&ring->entry[i], ENTRY_OWNER_NIC);
@@ -1449,13 +1431,7 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt73usb_enable_led(rt2x00dev);
 
-	ieee80211_start_queues(rt2x00dev->hw);
-
 	return 0;
-
-exit_fail:
-	rt73usb_uninitialize(rt2x00dev);
-	return -EIO;
 }
 
 static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev)
@@ -1463,18 +1439,11 @@ static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	struct data_ring *ring;
 	unsigned int i;
 
-	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return;
-
-	ieee80211_stop_queues(rt2x00dev->hw);
-
 	/*
 	 * Disable LED
 	 */
 	rt73usb_disable_led(rt2x00dev);
 
-	CLEAR_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO);
-
 	rt2x00_register_write(rt2x00dev, MAC_CSR10, 0x00001818);
 
 	/*
@@ -1485,8 +1454,6 @@ static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Cancel RX and TX.
 	 */
-	rt73usb_toggle_rx(rt2x00dev, 0);
-
 	rt2x00_vendor_request(rt2x00dev, USB_RX_CONTROL,
 		USB_VENDOR_REQUEST_OUT, 0x00, 0x00, NULL, 0, REGISTER_TIMEOUT);
 
@@ -2835,12 +2802,13 @@ static void rt73usb_disconnect(struct usb_interface *usb_intf)
 	/*
 	 * Uninitialize the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
+	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
+		ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt73usb driver data.
 	 */
-	rt73usb_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 	rt73usb_uninitialize(rt2x00dev);
 	rt73usb_free_dev(rt2x00dev);
 
@@ -2868,7 +2836,7 @@ static int rt73usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 	/*
 	 * Disable the radio.
 	 */
-	rt73usb_disable_radio(rt2x00dev);
+	rt2x00lib_disable_radio(rt2x00dev);
 
 	/*
 	 * Set device mode to sleep for power management.
@@ -2982,6 +2950,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0769, 0x31f3) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xab01) },
+	{ USB_DEVICE(0x2019, 0xab50) },
 	{ 0, }
 };
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
index 7394185..8f9abb0 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
@@ -930,12 +930,6 @@ static void rt73usb_disable_led(struct rt2x00_dev *rt2x00dev);
 static void rt73usb_activity_led(struct rt2x00_dev *rt2x00dev, char rssi);
 
 /*
- * Radio control functions.
- */
-static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev);
-static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev);
-
-/*
  * Interrupt functions.
  */
 static void rt73usb_interrupt_beacondone(struct urb *urb);
