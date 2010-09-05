Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57470 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0IEXpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Sep 2010 19:45:00 -0400
Received: by fxm13 with SMTP id 13so2235228fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Sep 2010 16:44:59 -0700 (PDT)
Message-Id: <74edadab616ae89b65c3f8c937c018669b43b52a.1283729571.git.chunkeey@googlemail.com>
In-Reply-To: <613d5cf3ecf5799e71e1b34d565669223533d852.1283729571.git.chunkeey@googlemail.com>
References: <613d5cf3ecf5799e71e1b34d565669223533d852.1283729571.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 6 Sep 2010 01:10:25 +0200
Subject: [PATCH 6/6] carl9170: Makefile, Kconfig files and MAINTAINERS
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 MAINTAINERS                                |    7 +++++
 drivers/net/wireless/ath/Kconfig           |    1 +
 drivers/net/wireless/ath/Makefile          |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig  |   41 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/carl9170/Makefile |    4 +++
 5 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/carl9170/Kconfig
 create mode 100644 drivers/net/wireless/ath/carl9170/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 63e441b..429fcef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1120,6 +1120,13 @@ W:	http://wireless.kernel.org/en/users/Drivers/ar9170
 S:	Maintained
 F:	drivers/net/wireless/ath/ar9170/
 
+CARL9170 LINUX COMMUNITY WIRELESS DRIVER
+M:	Christian Lamparter <chunkeey@googlemail.com>
+L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org/en/users/Drivers/carl9170
+S:	Maintained
+F:	drivers/net/wireless/ath/carl9170/
+
 ATK0110 HWMON DRIVER
 M:	Luca Tettamanti <kronos.it@gmail.com>
 L:	lm-sensors@lm-sensors.org
diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 0a75be0..92c2162 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -25,5 +25,6 @@ config ATH_DEBUG
 source "drivers/net/wireless/ath/ath5k/Kconfig"
 source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/ar9170/Kconfig"
+source "drivers/net/wireless/ath/carl9170/Kconfig"
 
 endif
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 8113a50..40fa179 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_ATH5K)		+= ath5k/
 obj-$(CONFIG_ATH9K_HW)		+= ath9k/
 obj-$(CONFIG_AR9170_USB)        += ar9170/
+obj-$(CONFIG_CARL9170)		+= carl9170/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
new file mode 100644
index 0000000..c5d3a3f
--- /dev/null
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -0,0 +1,41 @@
+config CARL9170
+	tristate "Linux Community AR9170 802.11n USB support"
+	depends on USB && MAC80211 && EXPERIMENTAL
+	select FW_LOADER
+	select CRC32
+	help
+	  This is another driver for the Atheros "otus" 802.11n USB devices.
+
+	  This driver provides more features than the original,
+	  but it needs a special firmware (carl9170-1.fw) to do that.
+
+	  The firmware can be downloaded from our wiki here:
+	  http://wireless.kernel.org/en/users/Drivers/carl9170
+
+	  If you choose to build a module, it'll be called carl9170.
+
+config CARL9170_LEDS
+	bool "SoftLED Support"
+	depends on CARL9170
+	select MAC80211_LEDS
+	select LEDS_CLASS
+	select NEW_LEDS
+	default y
+	help
+	  This option is necessary, if you want your device' LEDs to blink
+
+	  Say Y, unless you need the LEDs for firmware debugging.
+
+config CARL9170_DEBUGFS
+	bool "DebugFS Support"
+	depends on CARL9170 && DEBUG_FS && MAC80211_DEBUGFS
+	default n
+	help
+	  Export several driver and device internals to user space.
+
+	  Say N.
+
+config CARL9170_WPC
+	bool
+	depends on CARL9170 && (INPUT = y || INPUT = CARL9170)
+	default y
diff --git a/drivers/net/wireless/ath/carl9170/Makefile b/drivers/net/wireless/ath/carl9170/Makefile
new file mode 100644
index 0000000..f64ed76
--- /dev/null
+++ b/drivers/net/wireless/ath/carl9170/Makefile
@@ -0,0 +1,4 @@
+carl9170-objs := main.o usb.o cmd.o mac.o phy.o led.o fw.o tx.o rx.o
+carl9170-$(CONFIG_CARL9170_DEBUGFS) += debug.o
+
+obj-$(CONFIG_CARL9170) += carl9170.o
-- 
1.7.1

