Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46824 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab1DBUtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Apr 2011 16:49:36 -0400
Date: Sat, 02 Apr 2011 15:49:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: arend@broadcom.com, rvossen@broadcom.com, dowan@broadcom.com,
	henryp@broadcom.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH] staging: brcm80211: Remove symbol CONFIG_BRCM80211
Message-ID: <4d978bdd.fJYDlOsgMzeVsaGM%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the staging driver brcm80211 was renamed to brcmsmac, CONFIG_BRCM80211
is not really needed. In addition, a two-entry list hardly needs a separate
config menu.

The only awkward place in the revised code is the double addition of the
brcm80211 Makefile.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/staging/Makefile
===================================================================
--- linux-2.6.orig/drivers/staging/Makefile
+++ linux-2.6/drivers/staging/Makefile
@@ -16,7 +16,8 @@ obj-$(CONFIG_USB_IP_COMMON)	+= usbip/
 obj-$(CONFIG_W35UND)		+= winbond/
 obj-$(CONFIG_PRISM2_USB)	+= wlan-ng/
 obj-$(CONFIG_ECHO)		+= echo/
-obj-$(CONFIG_BRCM80211)		+= brcm80211/
+obj-$(CONFIG_BRCMSMAC)		+= brcm80211/
+obj-$(CONFIG_BRCMFMAC)		+= brcm80211/
 obj-$(CONFIG_RT2860)		+= rt2860/
 obj-$(CONFIG_RT2870)		+= rt2870/
 obj-$(CONFIG_COMEDI)		+= comedi/
Index: linux-2.6/drivers/staging/brcm80211/Kconfig
===================================================================
--- linux-2.6.orig/drivers/staging/brcm80211/Kconfig
+++ linux-2.6/drivers/staging/brcm80211/Kconfig
@@ -1,11 +1,8 @@
-menuconfig BRCM80211
-	tristate "Broadcom IEEE802.11n WLAN drivers"
-	depends on WLAN
-
 config BRCMSMAC
-	bool "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
+	tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
+	default n
 	depends on PCI
-	depends on BRCM80211 && MAC80211
+	depends on WLAN && MAC80211
 	select FW_LOADER
 	---help---
 	  This module adds support for PCIe wireless adapters based on Broadcom
@@ -13,9 +10,10 @@ config BRCMSMAC
 	  be called brcmsmac.ko.
 
 config BRCMFMAC
-	bool "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
+	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
+	default n
 	depends on MMC
-	depends on BRCM80211 && CFG80211
+	depends on WLAN && CFG80211
 	select FW_LOADER
 	select WIRELESS_EXT
 	select WEXT_PRIV
@@ -28,6 +26,6 @@ config BRCMFMAC
 config BRCMDBG
 	bool "Broadcom driver debug functions"
 	default n
-	depends on BRCM80211
+	depends on BRCMSMAC || BRCMFMAC
 	---help---
 	  Selecting this enables additional code for debug purposes.
