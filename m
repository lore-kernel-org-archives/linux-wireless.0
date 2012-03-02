Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:49138 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932368Ab2CBBl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 20:41:59 -0500
Received: from zeta.dmz-us.st.com (ns4.st.com [167.4.16.71])
	by beta.dmz-us.st.com (STMicroelectronics) with ESMTP id 8EA8C49
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:41:44 +0000 (GMT)
Received: from relay2.stm.gmessaging.net (unknown [10.230.100.18])
	by zeta.dmz-us.st.com (STMicroelectronics) with ESMTP id D93CE55
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 00:13:07 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay2.stm.gmessaging.net (Postfix) with ESMTPS id DD005A8065
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 02:41:54 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 21/21] cw1200: Kconfig + Makefile for the driver.
Date: Fri, 2 Mar 2012 02:41:35 +0100
Message-ID: <1330652495-25837-22-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024231_185549_5ECA663F)
In-Reply-To: <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch contains build system files for the cw1200 driver.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/staging/Kconfig         |    2 +
 drivers/staging/Makefile        |    1 +
 drivers/staging/cw1200/Kconfig  |  143 +++++++++++++++++++++++++++++++++++++++
 drivers/staging/cw1200/Makefile |   19 +++++
 4 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/cw1200/Kconfig
 create mode 100644 drivers/staging/cw1200/Makefile

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index f1abfb1..7134785 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -134,4 +134,6 @@ source "drivers/staging/ramster/Kconfig"
 
 source "drivers/staging/ozwpan/Kconfig"
 
+source "drivers/staging/cw1200/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index ffe7d44..09a9f22 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_RAMSTER)		+= ramster/
 obj-$(CONFIG_USB_WPAN_HCD)	+= ozwpan/
+obj-$(CONFIG_CW1200)		+= cw1200/
diff --git a/drivers/staging/cw1200/Kconfig b/drivers/staging/cw1200/Kconfig
new file mode 100644
index 0000000..1afd9b0
--- /dev/null
+++ b/drivers/staging/cw1200/Kconfig
@@ -0,0 +1,143 @@
+config CW1200
+       tristate "CW1200 WLAN support"
+       select MAC80211
+       select CFG80211
+       help
+
+         This is an experimental driver for the cw1200 chip-set.
+         Enabling this option enables the generic driver without
+         any platform support.
+
+         Please select the appropriate platform below.
+
+if CW1200
+
+config CW1200_STANDALONE
+      bool "Build a standalone cw1200 driver"
+      depends on CW1200
+      help
+        Say Y here if you would like to build a standalone cw1200 driver,
+        not associated with any platform. Likely you wil not be able to use
+	it for any purposes.
+        If unsure, say N.
+
+config CW1200_NON_POWER_OF_TWO_BLOCKSIZES
+      bool "Platform supports non-power-of-two SDIO transfer"
+      depends on CW1200
+      help
+        Say N here only if you are running the driver on a platform
+        which does not have support for non-power-of-two SDIO transfer.
+        If unsure, say Y.
+
+config CW1200_USE_GPIO_IRQ
+      bool "Use GPIO interrupt"
+      depends on CW1200 && !CW1200_STANDALONE
+      help
+        Say Y here if you want to include GPIO IRQ support instead of SDIO IRQ.
+        If unsure, say N.
+
+config CW1200_5GHZ_SUPPORT
+      bool "5GHz band support"
+      depends on CW1200
+      help
+        Say Y if your device supports 5GHz band. Should be disabled for
+        CW1100 silicon.
+        If unsure, say N.
+
+config CW1200_USE_STE_EXTENSIONS
+      bool "STE extensions"
+      depends on CW1200
+      help
+        Say Y if you want to include experimental code or code with
+	not resolved dependency.
+        If unsure, say N.
+
+config CW1200_WAPI_SUPPORT
+      bool "WAPI support"
+      depends on CW1200_USE_STE_EXTENSIONS
+      help
+        Say Y if your compat-wireless support WAPI.
+        If unsure, say N.
+
+config CW1200_DISABLE_BEACON_HINTS
+      bool "Disable 11d beacon hints"
+      depends on CW1200
+      help
+        Say Y if you want to disable 11d beacon hints.
+        If unsure, say N.
+
+config CW1200_U5500_SUPPORT
+      bool "Enable U5500 support"
+      depends on CW1200 && !CW1200_STANDALONE
+      help
+        Say Y if you want to enable wlan on u5500 platform support.
+        If unsure, say N.
+
+menu "Driver debug features"
+      depends on CW1200
+
+config CW1200_DEBUGFS
+      bool "Expose driver internals to DebugFS (DEVELOPMENT)"
+      help
+        Say Y if you want to expose driver internals to DebugFS.
+        If unsure, say N.
+
+config CW1200_BH_DEBUG
+      bool "Enable low-level device communication logs (DEVELOPMENT)"
+      help
+        Say Y if you want to enable BH logs.
+        If unsure, say N.
+
+config CW1200_WSM_DEBUG
+      bool "Enable WSM API debug messages (DEVELOPMENT)"
+      help
+        Say Y if you want to enable WSM logs.
+        If unsure, say N.
+
+config CW1200_WSM_DUMPS
+      bool "Verbose WSM API logging (DEVELOPMENT)"
+      help
+        Say Y if you want to enable WSM dumps.
+        If unsure, say N.
+
+config CW1200_WSM_DUMPS_SHORT
+      depends on CW1200_WSM_DUMPS
+      bool "Dump only first x bytes (default 20) (DEVELOPMENT)"
+      help
+        Say Y if you want to limit amount of data printed in WSM dumps.
+        If unsure, say N.
+
+config CW1200_TXRX_DEBUG
+      bool "Enable TX/RX debug messages (DEVELOPMENT)"
+      help
+        Say Y if you want to enable TX logs.
+        If unsure, say N.
+
+config CW1200_TX_POLICY_DEBUG
+      bool "Enable TX policy debug (DEVELOPMENT)"
+      help
+        Say Y if you want to enable TX policy logs.
+        If unsure, say N.
+
+config CW1200_STA_DEBUG
+      bool "Enable STA/AP debug (DEVELOPMENT)"
+      help
+        Say Y if you want to enable STA logs.
+        If unsure, say N.
+
+config CW1200_DUMP_ON_ERROR
+      bool "Dump kernel in case of critical error (DEVELOPMENT)"
+      help
+        Say Y only if you know for sure what are you doing.
+        If unsure, say N.
+
+endmenu
+
+config CW1200_ITP
+      bool "Enable ITP DebugFS"
+      depends on CW1200_DEBUGFS
+      help
+        Say Y if you want to include ITP code.
+        If unsure, say N.
+
+endif
diff --git a/drivers/staging/cw1200/Makefile b/drivers/staging/cw1200/Makefile
new file mode 100644
index 0000000..01a3290
--- /dev/null
+++ b/drivers/staging/cw1200/Makefile
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

