Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbXHSScB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:32:01 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:32:00 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 23/30] rt2x00: Move rt2x00 files into rt2x00 folder
Date: Sun, 19 Aug 2007 20:35:00 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200708192035.00875.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 0ad22000ea988cd69bccaa49823163e5658dd293 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 14:03:15 +0200
Subject: [PATCH 23/30] rt2x00: Move rt2x00 files into rt2x00 folder

rt2x00 covers quite a lot of files (at the moment 25
but more will be added with new drivers), to properly
group them together and making management of the files
easier they should be put into a new rt2x00 folder.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
Patch trimmed, Only Makefile and Kconfig difference has been added.
All other files have been moved (without changes) using:
mkdir drivers/net/wireless/rt2x00

git mv drivers/net/wireless/rt2400pci.c drivers/net/wireless/rt2x00/rt2400pci.c
git mv drivers/net/wireless/rt2400pci.h drivers/net/wireless/rt2x00/rt2400pci.h
git mv drivers/net/wireless/rt2500pci.c drivers/net/wireless/rt2x00/rt2500pci.c
git mv drivers/net/wireless/rt2500pci.h drivers/net/wireless/rt2x00/rt2500pci.h
git mv drivers/net/wireless/rt2500usb.c drivers/net/wireless/rt2x00/rt2500usb.c
git mv drivers/net/wireless/rt2500usb.h drivers/net/wireless/rt2x00/rt2500usb.h
git mv drivers/net/wireless/rt2x00.h drivers/net/wireless/rt2x00/rt2x00.h
git mv drivers/net/wireless/rt2x00config.c drivers/net/wireless/rt2x00/rt2x00config.c
git mv drivers/net/wireless/rt2x00debug.c drivers/net/wireless/rt2x00/rt2x00debug.c
git mv drivers/net/wireless/rt2x00debug.h drivers/net/wireless/rt2x00/rt2x00debug.h
git mv drivers/net/wireless/rt2x00dev.c drivers/net/wireless/rt2x00/rt2x00dev.c
git mv drivers/net/wireless/rt2x00firmware.c drivers/net/wireless/rt2x00/rt2x00firmware.c
git mv drivers/net/wireless/rt2x00lib.h drivers/net/wireless/rt2x00/rt2x00lib.h
git mv drivers/net/wireless/rt2x00mac.c drivers/net/wireless/rt2x00/rt2x00mac.c
git mv drivers/net/wireless/rt2x00pci.c drivers/net/wireless/rt2x00/rt2x00pci.c
git mv drivers/net/wireless/rt2x00pci.h drivers/net/wireless/rt2x00/rt2x00pci.h
git mv drivers/net/wireless/rt2x00reg.h drivers/net/wireless/rt2x00/rt2x00reg.h
git mv drivers/net/wireless/rt2x00rfkill.c drivers/net/wireless/rt2x00/rt2x00rfkill.c
git mv drivers/net/wireless/rt2x00ring.h drivers/net/wireless/rt2x00/rt2x00ring.h
git mv drivers/net/wireless/rt2x00usb.c drivers/net/wireless/rt2x00/rt2x00usb.c
git mv drivers/net/wireless/rt2x00usb.h drivers/net/wireless/rt2x00/rt2x00usb.h
git mv drivers/net/wireless/rt61pci.c drivers/net/wireless/rt2x00/rt61pci.c
git mv drivers/net/wireless/rt61pci.h drivers/net/wireless/rt2x00/rt61pci.h
git mv drivers/net/wireless/rt73usb.c drivers/net/wireless/rt2x00/rt73usb.c
git mv drivers/net/wireless/rt73usb.h drivers/net/wireless/rt2x00/rt73usb.h

 drivers/net/wireless/Kconfig                 |  131 +--
 drivers/net/wireless/Makefile                |   23 +-
 drivers/net/wireless/rt2400pci.c             | 1683 ------------------
 drivers/net/wireless/rt2400pci.h             |  943 -----------
 drivers/net/wireless/rt2500pci.c             | 1975 ----------------------
 drivers/net/wireless/rt2500pci.h             | 1218 -------------
 drivers/net/wireless/rt2500usb.c             | 1687 ------------------
 drivers/net/wireless/rt2500usb.h             |  767 ---------
 drivers/net/wireless/rt2x00.h                |  788 ---------
 drivers/net/wireless/rt2x00/Kconfig          |  130 ++
 drivers/net/wireless/rt2x00/Makefile         |   22 +
 drivers/net/wireless/rt2x00/rt2400pci.c      | 1683 ++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2400pci.h      |  943 +++++++++++
 drivers/net/wireless/rt2x00/rt2500pci.c      | 1975 ++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2500pci.h      | 1218 +++++++++++++
 drivers/net/wireless/rt2x00/rt2500usb.c      | 1687 ++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2500usb.h      |  767 +++++++++
 drivers/net/wireless/rt2x00/rt2x00.h         |  788 +++++++++
 drivers/net/wireless/rt2x00/rt2x00config.c   |  165 ++
 drivers/net/wireless/rt2x00/rt2x00debug.c    |  328 ++++
 drivers/net/wireless/rt2x00/rt2x00debug.h    |   57 +
 drivers/net/wireless/rt2x00/rt2x00dev.c      | 1153 +++++++++++++
 drivers/net/wireless/rt2x00/rt2x00firmware.c |  126 ++
 drivers/net/wireless/rt2x00/rt2x00lib.h      |  124 ++
 drivers/net/wireless/rt2x00/rt2x00mac.c      |  418 +++++
 drivers/net/wireless/rt2x00/rt2x00pci.c      |  512 ++++++
 drivers/net/wireless/rt2x00/rt2x00pci.h      |  124 ++
 drivers/net/wireless/rt2x00/rt2x00reg.h      |  270 +++
 drivers/net/wireless/rt2x00/rt2x00rfkill.c   |  146 ++
 drivers/net/wireless/rt2x00/rt2x00ring.h     |  240 +++
 drivers/net/wireless/rt2x00/rt2x00usb.c      |  724 ++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.h      |  183 ++
 drivers/net/wireless/rt2x00/rt61pci.c        | 2348 ++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt61pci.h        | 1382 +++++++++++++++
 drivers/net/wireless/rt2x00/rt73usb.c        | 2002 ++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt73usb.h        |  967 +++++++++++
 drivers/net/wireless/rt2x00config.c          |  165 --
 drivers/net/wireless/rt2x00debug.c           |  328 ----
 drivers/net/wireless/rt2x00debug.h           |   57 -
 drivers/net/wireless/rt2x00dev.c             | 1153 -------------
 drivers/net/wireless/rt2x00firmware.c        |  126 --
 drivers/net/wireless/rt2x00lib.h             |  124 --
 drivers/net/wireless/rt2x00mac.c             |  418 -----
 drivers/net/wireless/rt2x00pci.c             |  512 ------
 drivers/net/wireless/rt2x00pci.h             |  124 --
 drivers/net/wireless/rt2x00reg.h             |  270 ---
 drivers/net/wireless/rt2x00rfkill.c          |  146 --
 drivers/net/wireless/rt2x00ring.h            |  240 ---
 drivers/net/wireless/rt2x00usb.c             |  724 --------
 drivers/net/wireless/rt2x00usb.h             |  183 --
 drivers/net/wireless/rt61pci.c               | 2348 --------------------------
 drivers/net/wireless/rt61pci.h               | 1382 ---------------
 drivers/net/wireless/rt73usb.c               | 2002 ----------------------
 drivers/net/wireless/rt73usb.h               |  967 -----------
 54 files changed, 20484 insertions(+), 20482 deletions(-)
 delete mode 100644 drivers/net/wireless/rt2400pci.c
 delete mode 100644 drivers/net/wireless/rt2400pci.h
 delete mode 100644 drivers/net/wireless/rt2500pci.c
 delete mode 100644 drivers/net/wireless/rt2500pci.h
 delete mode 100644 drivers/net/wireless/rt2500usb.c
 delete mode 100644 drivers/net/wireless/rt2500usb.h
 delete mode 100644 drivers/net/wireless/rt2x00.h
 create mode 100644 drivers/net/wireless/rt2x00/Kconfig
 create mode 100644 drivers/net/wireless/rt2x00/Makefile
 create mode 100644 drivers/net/wireless/rt2x00/rt2400pci.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2400pci.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2500pci.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2500pci.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2500usb.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2500usb.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00config.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00debug.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00debug.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00dev.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00firmware.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00lib.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00mac.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00pci.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00pci.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00reg.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00rfkill.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00ring.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00usb.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00usb.h
 create mode 100644 drivers/net/wireless/rt2x00/rt61pci.c
 create mode 100644 drivers/net/wireless/rt2x00/rt61pci.h
 create mode 100644 drivers/net/wireless/rt2x00/rt73usb.c
 create mode 100644 drivers/net/wireless/rt2x00/rt73usb.h
 delete mode 100644 drivers/net/wireless/rt2x00config.c
 delete mode 100644 drivers/net/wireless/rt2x00debug.c
 delete mode 100644 drivers/net/wireless/rt2x00debug.h
 delete mode 100644 drivers/net/wireless/rt2x00dev.c
 delete mode 100644 drivers/net/wireless/rt2x00firmware.c
 delete mode 100644 drivers/net/wireless/rt2x00lib.h
 delete mode 100644 drivers/net/wireless/rt2x00mac.c
 delete mode 100644 drivers/net/wireless/rt2x00pci.c
 delete mode 100644 drivers/net/wireless/rt2x00pci.h
 delete mode 100644 drivers/net/wireless/rt2x00reg.h
 delete mode 100644 drivers/net/wireless/rt2x00rfkill.c
 delete mode 100644 drivers/net/wireless/rt2x00ring.h
 delete mode 100644 drivers/net/wireless/rt2x00usb.c
 delete mode 100644 drivers/net/wireless/rt2x00usb.h
 delete mode 100644 drivers/net/wireless/rt61pci.c
 delete mode 100644 drivers/net/wireless/rt61pci.h
 delete mode 100644 drivers/net/wireless/rt73usb.c
 delete mode 100644 drivers/net/wireless/rt73usb.h

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 366263e..dee7a4f 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -589,136 +589,6 @@ config P54_PCI
 	tristate "Prism54 PCI support"
 	depends on P54_COMMON && PCI
 
-config RT2X00
-	tristate "Ralink driver support"
-	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
-	---help---
-	  This will enable the experimental support for the Ralink drivers,
-	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
-
-	  These drivers will make use of the Devicescape ieee80211 stack.
-
-	  When building one of the individual drivers, the rt2x00 library
-	  will also be created. That library (when the driver is built as
-	  a module) will be called "rt2x00lib.ko".
-
-config RT2X00_LIB
-	tristate
-	depends on RT2X00
-
-config RT2X00_LIB_PCI
-	tristate
-	depends on RT2X00
-	select RT2X00_LIB
-
-config RT2X00_LIB_USB
-	tristate
-	depends on RT2X00
-	select RT2X00_LIB
-
-config RT2X00_LIB_FIRMWARE
-	boolean
-	depends on RT2X00_LIB
-	select CRC_ITU_T
-	select FW_LOADER
-
-config RT2X00_LIB_RFKILL
-	boolean
-	depends on RT2X00_LIB
-	select RFKILL
-	select INPUT_POLLDEV
-
-config RT2400PCI
-	tristate "Ralink rt2400 pci/pcmcia support"
-	depends on RT2X00 && PCI
-	select RT2X00_LIB_PCI
-	select EEPROM_93CX6
-	---help---
-	  This is an experimental driver for the Ralink rt2400 wireless chip.
-
-	  When compiled as a module, this driver will be called "rt2400pci.ko".
-
-config RT2400PCI_RFKILL
-	bool "RT2400 rfkill support"
-	depends on RT2400PCI
-	select RT2X00_LIB_RFKILL
-	---help---
-	  This adds support for integrated rt2400 devices that feature a
-	  hardware button to control the radio state.
-	  This feature depends on the RF switch subsystem rfkill.
-
-config RT2500PCI
-	tristate "Ralink rt2500 pci/pcmcia support"
-	depends on RT2X00 && PCI
-	select RT2X00_LIB_PCI
-	select EEPROM_93CX6
-	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
-
-	  When compiled as a module, this driver will be called "rt2500pci.ko".
-
-config RT2500PCI_RFKILL
-	bool "RT2500 rfkill support"
-	depends on RT2500PCI
-	select RT2X00_LIB_RFKILL
-	---help---
-	  This adds support for integrated rt2500 devices that feature a
-	  hardware button to control the radio state.
-	  This feature depends on the RF switch subsystem rfkill.
-
-config RT61PCI
-	tristate "Ralink rt61 pci/pcmcia support"
-	depends on RT2X00 && PCI
-	select RT2X00_LIB_PCI
-	select RT2X00_LIB_FIRMWARE
-	select EEPROM_93CX6
-	---help---
-	  This is an experimental driver for the Ralink rt61 wireless chip.
-
-	  When compiled as a module, this driver will be called "rt61pci.ko".
-
-config RT61PCI_RFKILL
-	bool "RT61 rfkill support"
-	depends on RT61PCI
-	select RT2X00_LIB_RFKILL
-	---help---
-	  This adds support for integrated rt61 devices that feature a
-	  hardware button to control the radio state.
-	  This feature depends on the RF switch subsystem rfkill.
-
-config RT2500USB
-	tristate "Ralink rt2500 usb support"
-	depends on RT2X00 && USB
-	select RT2X00_LIB_USB
-	---help---
-	  This is an experimental driver for the Ralink rt2500 wireless chip.
-
-	  When compiled as a module, this driver will be called "rt2500usb.ko".
-
-config RT73USB
-	tristate "Ralink rt73 usb support"
-	depends on RT2X00 && USB
-	select RT2X00_LIB_USB
-	select RT2X00_LIB_FIRMWARE
-	---help---
-	  This is an experimental driver for the Ralink rt73 wireless chip.
-
-	  When compiled as a module, this driver will be called "rt73usb.ko".
-
-config RT2X00_LIB_DEBUGFS
-	bool "Ralink debugfs support"
-	depends on RT2X00_LIB && MAC80211_DEBUGFS
-	---help---
-	  Enable creation of debugfs files for the rt2x00 drivers.
-	  These debugfs files support both reading and writing of the
-	  most important register types of the rt2x00 devices.
-
-config RT2X00_DEBUG
-	bool "Ralink debug output"
-	depends on RT2X00_LIB
-	---help---
-	  Enable debugging output for all rt2x00 modules
-
 config IWLWIFI
 	bool "Intel Wireless WiFi Link Drivers"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
@@ -853,5 +723,6 @@ source "drivers/net/wireless/bcm43xx/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/zd1211rw-mac80211/Kconfig"
+source "drivers/net/wireless/rt2x00/Kconfig"
 
 endmenu
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index b3427bb..e28b067 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -56,28 +56,7 @@ obj-$(CONFIG_P54_COMMON)	+= p54common.o
 obj-$(CONFIG_P54_USB)		+= p54usb.o
 obj-$(CONFIG_P54_PCI)		+= p54pci.o
 
-rt2x00lib-objs := rt2x00dev.o rt2x00mac.o rt2x00config.o
-
-ifeq ($(CONFIG_RT2X00_LIB_DEBUGFS),y)
-	rt2x00lib-objs += rt2x00debug.o
-endif
-
-ifeq ($(CONFIG_RT2X00_LIB_RFKILL),y)
-	rt2x00lib-objs += rt2x00rfkill.o
-endif
-
-ifeq ($(CONFIG_RT2X00_LIB_FIRMWARE),y)
-	rt2x00lib-objs += rt2x00firmware.o
-endif
-
-obj-$(CONFIG_RT2X00_LIB)	+= rt2x00lib.o
-obj-$(CONFIG_RT2X00_LIB_PCI)	+= rt2x00pci.o
-obj-$(CONFIG_RT2X00_LIB_USB)	+= rt2x00usb.o
-obj-$(CONFIG_RT2400PCI)		+= rt2400pci.o
-obj-$(CONFIG_RT2500PCI)		+= rt2500pci.o
-obj-$(CONFIG_RT61PCI)		+= rt61pci.o
-obj-$(CONFIG_RT2500USB)		+= rt2500usb.o
-obj-$(CONFIG_RT73USB)		+= rt73usb.o
+obj-$(CONFIG_RT2X00)		+= rt2x00/
 
 # NOTE:  We use common code from iwl-base.c to build driver
 # specific binaries based on the #define IWL -- the target
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
new file mode 100644
index 0000000..da05b1f
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -0,0 +1,130 @@
+config RT2X00
+	tristate "Ralink driver support"
+	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	---help---
+	  This will enable the experimental support for the Ralink drivers,
+	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
+
+	  These drivers will make use of the Devicescape ieee80211 stack.
+
+	  When building one of the individual drivers, the rt2x00 library
+	  will also be created. That library (when the driver is built as
+	  a module) will be called "rt2x00lib.ko".
+
+config RT2X00_LIB
+	tristate
+	depends on RT2X00
+
+config RT2X00_LIB_PCI
+	tristate
+	depends on RT2X00
+	select RT2X00_LIB
+
+config RT2X00_LIB_USB
+	tristate
+	depends on RT2X00
+	select RT2X00_LIB
+
+config RT2X00_LIB_FIRMWARE
+	boolean
+	depends on RT2X00_LIB
+	select CRC_ITU_T
+	select FW_LOADER
+
+config RT2X00_LIB_RFKILL
+	boolean
+	depends on RT2X00_LIB
+	select RFKILL
+	select INPUT_POLLDEV
+
+config RT2400PCI
+	tristate "Ralink rt2400 pci/pcmcia support"
+	depends on RT2X00 && PCI
+	select RT2X00_LIB_PCI
+	select EEPROM_93CX6
+	---help---
+	  This is an experimental driver for the Ralink rt2400 wireless chip.
+
+	  When compiled as a module, this driver will be called "rt2400pci.ko".
+
+config RT2400PCI_RFKILL
+	bool "RT2400 rfkill support"
+	depends on RT2400PCI
+	select RT2X00_LIB_RFKILL
+	---help---
+	  This adds support for integrated rt2400 devices that feature a
+	  hardware button to control the radio state.
+	  This feature depends on the RF switch subsystem rfkill.
+
+config RT2500PCI
+	tristate "Ralink rt2500 pci/pcmcia support"
+	depends on RT2X00 && PCI
+	select RT2X00_LIB_PCI
+	select EEPROM_93CX6
+	---help---
+	  This is an experimental driver for the Ralink rt2500 wireless chip.
+
+	  When compiled as a module, this driver will be called "rt2500pci.ko".
+
+config RT2500PCI_RFKILL
+	bool "RT2500 rfkill support"
+	depends on RT2500PCI
+	select RT2X00_LIB_RFKILL
+	---help---
+	  This adds support for integrated rt2500 devices that feature a
+	  hardware button to control the radio state.
+	  This feature depends on the RF switch subsystem rfkill.
+
+config RT61PCI
+	tristate "Ralink rt61 pci/pcmcia support"
+	depends on RT2X00 && PCI
+	select RT2X00_LIB_PCI
+	select RT2X00_LIB_FIRMWARE
+	select EEPROM_93CX6
+	---help---
+	  This is an experimental driver for the Ralink rt61 wireless chip.
+
+	  When compiled as a module, this driver will be called "rt61pci.ko".
+
+config RT61PCI_RFKILL
+	bool "RT61 rfkill support"
+	depends on RT61PCI
+	select RT2X00_LIB_RFKILL
+	---help---
+	  This adds support for integrated rt61 devices that feature a
+	  hardware button to control the radio state.
+	  This feature depends on the RF switch subsystem rfkill.
+
+config RT2500USB
+	tristate "Ralink rt2500 usb support"
+	depends on RT2X00 && USB
+	select RT2X00_LIB_USB
+	---help---
+	  This is an experimental driver for the Ralink rt2500 wireless chip.
+
+	  When compiled as a module, this driver will be called "rt2500usb.ko".
+
+config RT73USB
+	tristate "Ralink rt73 usb support"
+	depends on RT2X00 && USB
+	select RT2X00_LIB_USB
+	select RT2X00_LIB_FIRMWARE
+	---help---
+	  This is an experimental driver for the Ralink rt73 wireless chip.
+
+	  When compiled as a module, this driver will be called "rt73usb.ko".
+
+config RT2X00_LIB_DEBUGFS
+	bool "Ralink debugfs support"
+	depends on RT2X00_LIB && MAC80211_DEBUGFS
+	---help---
+	  Enable creation of debugfs files for the rt2x00 drivers.
+	  These debugfs files support both reading and writing of the
+	  most important register types of the rt2x00 devices.
+
+config RT2X00_DEBUG
+	bool "Ralink debug output"
+	depends on RT2X00_LIB
+	---help---
+	  Enable debugging output for all rt2x00 modules
+
diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
new file mode 100644
index 0000000..30d654a
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -0,0 +1,22 @@
+rt2x00lib-objs := rt2x00dev.o rt2x00mac.o rt2x00config.o
+
+ifeq ($(CONFIG_RT2X00_LIB_DEBUGFS),y)
+	rt2x00lib-objs += rt2x00debug.o
+endif
+
+ifeq ($(CONFIG_RT2X00_LIB_RFKILL),y)
+	rt2x00lib-objs += rt2x00rfkill.o
+endif
+
+ifeq ($(CONFIG_RT2X00_LIB_FIRMWARE),y)
+	rt2x00lib-objs += rt2x00firmware.o
+endif
+
+obj-$(CONFIG_RT2X00_LIB)	+= rt2x00lib.o
+obj-$(CONFIG_RT2X00_LIB_PCI)	+= rt2x00pci.o
+obj-$(CONFIG_RT2X00_LIB_USB)	+= rt2x00usb.o
+obj-$(CONFIG_RT2400PCI)		+= rt2400pci.o
+obj-$(CONFIG_RT2500PCI)		+= rt2500pci.o
+obj-$(CONFIG_RT61PCI)		+= rt61pci.o
+obj-$(CONFIG_RT2500USB)		+= rt2500usb.o
+obj-$(CONFIG_RT73USB)		+= rt73usb.o
