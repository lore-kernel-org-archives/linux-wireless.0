Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64172 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab0H3Unc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 16:43:32 -0400
Received: by bwz11 with SMTP id 11so4012336bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 13:43:31 -0700 (PDT)
Received: from debian64.daheim
	([192.168.0.4] helo=debian64.localnet ident=chuck)
	by debian64.daheim with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <chunkeey@googlemail.com>)
	id 1OqBCQ-0002lq-AE
	for linux-wireless@vger.kernel.org; Mon, 30 Aug 2010 22:43:26 +0200
Subject: [RFT 6/6] carl9170usb: Makefile, Kconfig files and MAINTAINERS
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Date: Mon, 30 Aug 2010 22:42:19 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201008302242.19395.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 MAINTAINERS                                |    1 +
 drivers/net/wireless/ath/Kconfig           |    1 +
 drivers/net/wireless/ath/Makefile          |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig  |   37 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/carl9170/Makefile |    4 +++
 5 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/carl9170/Kconfig
 create mode 100644 drivers/net/wireless/ath/carl9170/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 63e441b..1f10089 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1119,6 +1119,7 @@ L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/ar9170
 S:	Maintained
 F:	drivers/net/wireless/ath/ar9170/
+F:	drivers/net/wireless/ath/carl9170/
 
 ATK0110 HWMON DRIVER
 M:	Luca Tettamanti <kronos.it@gmail.com>
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
index 8113a50..75c372b 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_ATH5K)		+= ath5k/
 obj-$(CONFIG_ATH9K_HW)		+= ath9k/
 obj-$(CONFIG_AR9170_USB)        += ar9170/
+obj-$(CONFIG_CARL9170_USB)        += carl9170/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
new file mode 100644
index 0000000..cd3815a
--- /dev/null
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -0,0 +1,37 @@
+config CARL9170_USB
+	tristate "Community Driver for Atheros AR9170 802.11n USB support"
+	depends on USB && MAC80211 && EXPERIMENTAL
+	select FW_LOADER
+	help
+	  This is another driver for the Atheros "otus" 802.11n USB devices.
+
+	  This driver provides more features than the original,
+	  but it needs a special firmware (carl9170-1.fw) to do that.
+
+	  The firmware can be downloaded from here:
+
+	  http://wireless.kernel.org/en/users/Drivers/carl9170
+
+	  If you choose to build a module, it'll be called carl9170usb.
+
+config CARL9170_LEDS
+	bool "LED Support"
+	depends on CARL9170_USB && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = CARL9170_USB)
+	default y
+	help
+	  This option is necessary, if you want your device' LEDs to blink
+
+	  Say Y, unless you need the LEDs for firmware debugging.
+
+config CARL9170_DEBUGFS
+	bool "Debugging (DebugFS) Support"
+	depends on CARL9170_USB && MAC80211_DEBUGFS
+	default y
+	help
+	  Say Y, if you need access to carl9170usb's statistics for
+	  QoS queue status, rate control, etc.
+
+config CARL9170_WPS_BUTTON
+	bool
+	depends on CARL9170_USB && (INPUT = y || INPUT = CARL9170_USB)
+	default y
diff --git a/drivers/net/wireless/ath/carl9170/Makefile b/drivers/net/wireless/ath/carl9170/Makefile
new file mode 100644
index 0000000..2fba020
--- /dev/null
+++ b/drivers/net/wireless/ath/carl9170/Makefile
@@ -0,0 +1,4 @@
+carl9170usb-objs := main.o usb.o cmd.o mac.o phy.o led.o fw.o tx.o rx.o
+carl9170usb-$(CONFIG_CARL9170_DEBUGFS) += debug.o
+
+obj-$(CONFIG_CARL9170_USB) += carl9170usb.o
-- 
1.7.1

