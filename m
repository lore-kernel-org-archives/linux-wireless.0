Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:53392 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759314Ab2CBU1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 15:27:09 -0500
Received: from zeta.dmz-us.st.com (ns4.st.com [167.4.16.71])
	by beta.dmz-us.st.com (STMicroelectronics) with ESMTP id 5F28676
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:26:54 +0000 (GMT)
Received: from relay1.stm.gmessaging.net (unknown [10.230.100.17])
	by zeta.dmz-us.st.com (STMicroelectronics) with ESMTP id 5CA9157
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 18:57:41 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay1.stm.gmessaging.net (Postfix) with ESMTPS id A565F24C2C0
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 21:26:55 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCHv2 21/21] cw1200: Kconfig + Makefile for the driver.
Date: Fri, 2 Mar 2012 21:26:43 +0100
Message-ID: <1330720003-15866-22-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_212744_786845_925B834C)
In-Reply-To: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
 <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch contains build system files for the cw1200 driver.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/net/wireless/Kconfig         |    1 +
 drivers/net/wireless/Makefile        |    2 +
 drivers/net/wireless/cw1200/Kconfig  |  203 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/cw1200/Makefile |   19 +++
 4 files changed, 225 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/cw1200/Kconfig
 create mode 100644 drivers/net/wireless/cw1200/Makefile

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index abd3b71..6fcda14 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -286,5 +286,6 @@ source "drivers/net/wireless/wl1251/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/mwifiex/Kconfig"
+source "drivers/net/wireless/cw1200/Kconfig"
 
 endif # WLAN
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 98db761..d57fb4b 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -61,3 +61,5 @@ obj-$(CONFIG_MWIFIEX)	+= mwifiex/
 
 obj-$(CONFIG_BRCMFMAC)	+= brcm80211/
 obj-$(CONFIG_BRCMSMAC)	+= brcm80211/
+
+obj-$(CONFIG_CW1200)	+= cw1200/
diff --git a/drivers/net/wireless/cw1200/Kconfig b/drivers/net/wireless/cw1200/Kconfig
new file mode 100644
index 0000000..43b86dd
--- /dev/null
+++ b/drivers/net/wireless/cw1200/Kconfig
@@ -0,0 +1,203 @@
+menuconfig CW1200
+	tristate "ST-Ericsson cw1200 WiFi driver"
+	select MAC80211
+	select CFG80211
+	---help---
+	  This is a mac80211 driver for the ST-Ericsson cw1200 chip-set.
+	  The driver supports also cw1100 chipset.
+
+	  If you enable this option, two modules will be built: cw1200_core
+	  module with core cw1200 support and cw1200_wlan, an SDIO glue layer
+	  for the driver.
+
+config CW1200_STANDALONE
+	bool "Build a standalone cw1200 driver"
+	depends on CW1200
+	---help---
+	  Usually it is not enough just to build the driver modules, you need
+	  to provide platform-specific data for the driver from your mach- code
+	  (unless you device does not require any power, clock or reset control).
+
+	  Say Y here if you would like to build a standalone cw1200 driver,
+	  not associated with any platform. Likely you will not be able to use
+	  it for any purposes.
+
+	  If unsure, say N.
+
+config CW1200_USE_GPIO_IRQ
+	bool "Use GPIO interrupt"
+	depends on CW1200 && !CW1200_STANDALONE
+	---help---
+	  Say Y here if you want to include GPIO IRQ support instead of SDIO IRQ.
+
+	  GPIO IRQ signalling is significantly faster than SDIO, but it requires
+	  a dedicated GPIO line to be connected to the cw1200 device. It is safe
+	  to use SDIO IRQ even if GPIO is connected, but it will lead to some
+	  performance penalty.
+
+	  Please refer to your hardware design to find out if SDIO IRQ is
+	  supported on your platform.
+
+	  If unsure, say N.
+
+config CW1200_U5500_SUPPORT
+	bool "Enable U5500 support"
+	depends on CW1200 && !CW1200_STANDALONE
+	---help---
+	  Say Y if you want to enable wlan support on u5500 STE platform.
+
+	  u5500 uses a bit different method of enabling power end resetting of
+	  the chip. The code under this configuration option uses a prcmu_ctrl
+	  callback in the device platform data structure to enable or disable
+	  power.
+
+	  You can also create a custom prcmu_ctrl callback and use this option
+	  if the generic power on / power off sequence does not fit your system
+	  design.
+
+	  If unsure, say N.
+
+config CW1200_NON_POWER_OF_TWO_BLOCKSIZES
+	bool "Platform supports non-power-of-two SDIO transfer"
+	depends on CW1200
+	---help---
+	  Say N here only if you are running the driver on a platform
+	  which does not have support for non-power-of-two SDIO transfer.
+
+	  Disabling this option is safe, but it will lead to some performance
+	  penalty.
+
+	  If unsure, say Y.
+
+config CW1200_5GHZ_SUPPORT
+	bool "5GHz band support"
+	depends on CW1200
+	---help---
+	  Say Y if your device supports 5GHz band. Usually a system based on cw1200
+	  device supports 5GHz band, while a cw1100-based system does not. But it
+	  might be some variations, please check your system design.
+
+	  If unsure, say N.
+
+config CW1200_CERTIFICATION_TRICKS
+	bool "Enable WiFi certification tricks"
+	depends on CW1200
+	---help---
+	  Say Y here if you would like to build a system which can be WiFi-certified.
+	  It is mostly related to WFD test case 6.1.10 of the WiFi Direct test plan,
+	  but not only. It is safe to have this option enabled. Impact to the system
+	  performance is minimal.
+
+	  If unsure, say Y.
+
+config CW1200_DISABLE_BEACON_HINTS
+	bool "Disable 11d beacon hints"
+	depends on CW1200
+	---help---
+	  Say Y if you want to disable 11d beacon hints. Usually you don't need to
+	  do it, because they are used for 11d support in the mac80211 code.
+
+	  However, in some variants of design you might know for sure the regulatory
+	  domain you are residing in. In that rare case using this option you can
+	  disable unnecessary AI. One of examples of such kind of design is a mobile
+	  phone, where positioning information is available directly from the mobile
+	  network, and this information takes precedence over 11d hints.
+
+	  If unsure, say N.
+
+config CW1200_DEBUGFS
+	bool "Expose driver internals to DebugFS (DEVELOPMENT)"
+	depends on CW1200
+	---help---
+	  Say Y if you want to expose driver internals to DebugFS.
+
+	  If unsure, say N.
+
+config CW1200_ITP
+	bool "Enable ITP DebugFS (DEVELOPMENT)"
+	depends on CW1200_DEBUGFS
+	---help---
+	  Say Y if you want to include ITP (device calibration and "productization")
+	  code.
+
+	  If unsure, say N.
+
+menu "Driver debug features"
+	depends on CW1200
+
+config CW1200_BH_DEBUG
+	bool "Enable low-level device communication logs (DEVELOPMENT)"
+	---help---
+	  Say Y if you want to enable low-level communication logs: interrupts,
+	  device wakeups, wake-downs, suspends, resumes etc.
+
+	  If unsure, say N.
+
+config CW1200_WSM_DEBUG
+	bool "Enable WSM API debug messages (DEVELOPMENT)"
+	---help---
+	  Say Y if you want to enable WSM logs. The logs will help you to trace
+	  the sequence of WSM commands sent over the device interface. No additional
+	  information will be stored, like command payload, just WSM message ID.
+
+	  Usually you would like to enable verbose WSM logging in addition.
+
+	  If unsure, say N.
+
+config CW1200_WSM_DUMPS
+	bool "Verbose WSM API logging (DEVELOPMENT)"
+	---help---
+	  Say Y if you want to enable WSM dumps. The dumps will store in the kernel
+	  log all data sent over the device interface.
+
+	  Note: WSM dumps are quite time- and log space consuming.
+
+	  If unsure, say N.
+
+config CW1200_WSM_DUMPS_SHORT
+	depends on CW1200_WSM_DUMPS
+	bool "Dump only first x bytes (default 20) (DEVELOPMENT)"
+	---help---
+	  Say Y if you want to limit amount of data printed in WSM dumps. It reduces
+	  system performance impact, but reduces also ability to debug some tricky cases.
+
+	  If unsure, say Y.
+
+config CW1200_TXRX_DEBUG
+	bool "Enable TX/RX debug messages (DEVELOPMENT)"
+	---help---
+	  Say Y if you want to enable TX and RX logs.
+
+	  Note: TX logs consumes quite a lot of log space. Usually it's more natural
+	  to enable WSM dumps instead.
+
+	  If unsure, say N.
+
+config CW1200_TX_POLICY_DEBUG
+	bool "Enable TX policy debug (DEVELOPMENT)"
+	---help---
+	  Say Y if you want to enable TX rate control logs.
+
+	  Usually you do not need this kind of logs. The only exception is if you are
+	  going to debug rate control selection code in the driver.
+
+	  If unsure, say N.
+
+config CW1200_STA_DEBUG
+	bool "Enable STA/AP debug (DEVELOPMENT)"
+	---help---
+	  Say Y if you want to enable STA and AP logs.
+
+	  This kind of logs is often quite useful for generic debugging and tracing.
+	  The logs are quite lightweight.
+
+	  If unsure, say N.
+
+config CW1200_DUMP_ON_ERROR
+	bool "Dump kernel in case of critical error (DEVELOPMENT)"
+	---help---
+	  Say Y only if you really know what are you doing.
+
+	  If unsure, say N.
+
+endmenu
diff --git a/drivers/net/wireless/cw1200/Makefile b/drivers/net/wireless/cw1200/Makefile
new file mode 100644
index 0000000..01a3290
--- /dev/null
+++ b/drivers/net/wireless/cw1200/Makefile
@@ -0,0 +1,19 @@
+cw1200_core-y := \
+		fwio.o \
+		txrx.o \
+		main.o \
+		queue.o \
+		hwio.o \
+		bh.o \
+		wsm.o \
+		sta.o \
+		ap.o \
+		scan.o
+cw1200_core-$(CONFIG_CW1200_DEBUGFS)	+= debug.o
+cw1200_core-$(CONFIG_CW1200_ITP)	+= itp.o
+cw1200_core-$(CONFIG_PM)		+= pm.o
+
+cw1200_wlan-y := cw1200_sdio.o
+
+obj-$(CONFIG_CW1200) += cw1200_core.o
+obj-$(CONFIG_CW1200) += cw1200_wlan.o
-- 
1.7.9

