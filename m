Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:59513 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXEGDjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2007 23:39:17 -0400
Date: Sun, 06 May 2007 22:38:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] TI acx100/acx111: Make debug level selectable in  configuration
Message-ID: <463e9f41.I1vRfGQlMXUkbHRi%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debug level for the TI acx100/acx111 driver is only set by editing
one of the header files. This patch adds configuration parameters to
set the debug level, and modifies the header file to use those parameters.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/tiacx/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/tiacx/Kconfig
+++ wireless-2.6/drivers/net/wireless/tiacx/Kconfig
@@ -1,6 +1,6 @@
 config ACX_PCI
 	tristate "TI acx100/acx111 802.11b/g PCI"
-	depends on NET_RADIO && EXPERIMENTAL && PCI
+	depends on WLAN_80211 && EXPERIMENTAL && PCI
 	select FW_LOADER
 	select IEEE80211
 	select IEEE80211_SOFTMAC
@@ -36,9 +36,31 @@ config ACX_PCI
 	Texas Instruments did not take part in development of this driver
 	in any way, shape or form.
 
+choice
+	prompt "ACX debug level"
+	depends on ACX_PCI
+	default ACX_PCI_DEBUG_FULL
+
+config ACX_PCI_DEBUG_MIN
+	prompt "No debugging output"
+	bool
+	depends on ACX_PCI
+
+config ACX_PCI_DEBUG_REG
+	prompt "Intermediate debugging output"
+	bool
+	depends on ACX_PCI
+
+config ACX_PCI_DEBUG_MAX
+	prompt "Maximum debugging output"
+	bool
+	depends on ACX_PCI
+
+endchoice
+
 config ACX_USB
 	tristate "TI acx100/acx111 802.11b/g USB"
-	depends on NET_RADIO && EXPERIMENTAL && USB
+	depends on WLAN_80211 && EXPERIMENTAL && USB
 	select FW_LOADER
 	select IEEE80211
 	select IEEE80211_SOFTMAC
@@ -62,3 +84,27 @@ config ACX_USB
 
 	Texas Instruments did not take part in development of this driver
 	in any way, shape or form.
+
+choice
+	prompt "ACX debug level"
+	depends on ACX_USB
+	default ACX_USB_DEBUG_FULL
+
+config ACX_USB_DEBUG_MIN
+	prompt "No debugging output"
+	bool
+	depends on ACX_USB
+
+config ACX_USB_DEBUG_REG
+	prompt "Intermediate debugging output"
+	bool
+	depends on ACX_USB
+
+config ACX_USB_DEBUG_MAX
+	prompt "Maximum debugging output"
+	bool
+	depends on ACX_USB
+
+endchoice
+
+
Index: wireless-2.6/drivers/net/wireless/tiacx/acx_config.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/tiacx/acx_config.h
+++ wireless-2.6/drivers/net/wireless/tiacx/acx_config.h
@@ -3,7 +3,20 @@
 /* set to 0 if you don't want any debugging code to be compiled in */
 /* set to 1 if you want some debugging */
 /* set to 2 if you want extensive debug log */
+/* #define ACX_DEBUG 2  This is now set with a configuration variable */
+
+#if (defined CONFIG_ACX_PCI_DEBUG_MIN || defined CONFIG_ACX_USB_DEBUG_MIN)
+#define ACX_DEBUG 0
+#endif
+
+#if (defined CONFIG_ACX_PCI_DEBUG_REG || defined CONFIG_ACX_USB_DEBUG_REG)
+#define ACX_DEBUG 1
+#endif
+
+#if (defined CONFIG_ACX_PCI_DEBUG_MAX || defined CONFIG_ACX_USB_DEBUG_MAX)
 #define ACX_DEBUG 2
+#endif
+
 #define ACX_DEFAULT_MSG (L_ASSOC|L_INIT)
 
 /* assume 32bit I/O width
