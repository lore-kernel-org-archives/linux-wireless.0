Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:60712 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbbEYJfP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 05:35:15 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCHv3 2/2] add mt7601u kbuild and others
Date: Mon, 25 May 2015 11:34:33 +0200
Message-Id: <1432546473-18081-3-git-send-email-moorray3@wp.pl> (sfid-20150525_113518_306327_811A132B)
In-Reply-To: <1432546473-18081-1-git-send-email-moorray3@wp.pl>
References: <1430571690-9054-1-git-send-email-moorray3@wp.pl>
 <1432546473-18081-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 MAINTAINERS                                    |  6 ++++++
 drivers/net/wireless/Kconfig                   |  1 +
 drivers/net/wireless/Makefile                  |  2 ++
 drivers/net/wireless/mediatek/Kconfig          | 10 ++++++++++
 drivers/net/wireless/mediatek/Makefile         |  1 +
 drivers/net/wireless/mediatek/mt7601u/Kconfig  |  6 ++++++
 drivers/net/wireless/mediatek/mt7601u/Makefile |  9 +++++++++
 7 files changed, 35 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index df106f87a3ba..c6f4576efd56 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6365,6 +6365,12 @@ F:	include/uapi/linux/meye.h
 F:	include/uapi/linux/ivtv*
 F:	include/uapi/linux/uvcvideo.h
 
+MEDIATEK MT7601U WIRELESS LAN DRIVER
+M:	Jakub Kicinski <kubakici@wp.pl>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/mediatek/mt7601u/
+
 MEGARAID SCSI/SAS DRIVERS
 M:	Kashyap Desai <kashyap.desai@avagotech.com>
 M:	Sumit Saxena <sumit.saxena@avagotech.com>
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 16604bdf5197..a63ab2e83105 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -277,6 +277,7 @@ source "drivers/net/wireless/libertas/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
+source "drivers/net/wireless/mediatek/Kconfig"
 source "drivers/net/wireless/rtlwifi/Kconfig"
 source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 0c8891686718..6b9e729dd8ac 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -45,6 +45,8 @@ obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
 obj-$(CONFIG_IWLEGACY)	+= iwlegacy/
 obj-$(CONFIG_RT2X00)	+= rt2x00/
 
+obj-$(CONFIG_WL_MEDIATEK)	+= mediatek/
+
 obj-$(CONFIG_P54_COMMON)	+= p54/
 
 obj-$(CONFIG_ATH_CARDS)		+= ath/
diff --git a/drivers/net/wireless/mediatek/Kconfig b/drivers/net/wireless/mediatek/Kconfig
new file mode 100644
index 000000000000..cba300c6b5da
--- /dev/null
+++ b/drivers/net/wireless/mediatek/Kconfig
@@ -0,0 +1,10 @@
+menuconfig WL_MEDIATEK
+	bool "Mediatek Wireless LAN support"
+	---help---
+	  Enable community drivers for MediaTek WiFi devices.
+	  Those drivers make use of the Linux mac80211 stack.
+
+
+if WL_MEDIATEK
+source "drivers/net/wireless/mediatek/mt7601u/Kconfig"
+endif # WL_MEDIATEK
diff --git a/drivers/net/wireless/mediatek/Makefile b/drivers/net/wireless/mediatek/Makefile
new file mode 100644
index 000000000000..9d5f182fd7fd
--- /dev/null
+++ b/drivers/net/wireless/mediatek/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MT7601U)	+= mt7601u/
diff --git a/drivers/net/wireless/mediatek/mt7601u/Kconfig b/drivers/net/wireless/mediatek/mt7601u/Kconfig
new file mode 100644
index 000000000000..f46bed92796b
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt7601u/Kconfig
@@ -0,0 +1,6 @@
+config MT7601U
+	tristate "MediaTek MT7601U (USB) support"
+	depends on MAC80211
+	depends on USB
+	---help---
+	  This adds support for MT7601U-based wireless USB dongles.
diff --git a/drivers/net/wireless/mediatek/mt7601u/Makefile b/drivers/net/wireless/mediatek/mt7601u/Makefile
new file mode 100644
index 000000000000..ea9ed8a5db4d
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt7601u/Makefile
@@ -0,0 +1,9 @@
+ccflags-y += -D__CHECK_ENDIAN__
+
+obj-$(CONFIG_MT7601U)	+= mt7601u.o
+
+mt7601u-objs	= \
+	usb.o init.o main.o mcu.o trace.o dma.o core.o eeprom.o phy.o \
+	mac.o util.o debugfs.o tx.o
+
+CFLAGS_trace.o := -I$(src)
-- 
2.1.0

