Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40586
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761793AbXHIAFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 20:05:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: arm allmodconfig
Date: Thu, 9 Aug 2007 02:04:22 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070808145705.756597b0.akpm@linux-foundation.org> <200708090038.05320.mb@bu3sch.de> <20070808155231.77bfc676.akpm@linux-foundation.org>
In-Reply-To: <20070808155231.77bfc676.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708090204.22237.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 August 2007, Andrew Morton wrote:
> yup, I understand the problem and I cannot suggest any acceptable solution,
> apart from...
> 
> > So, once you suggested that menuconfig should be changed to
> > show options "greyed out" when deps are not met. Are there
> > any patches available? Any starting point?
> 
> No, nothing at all, sorry.
> 
> I'm getting a _lot_ of build breakage out of SSB right now.
> 
> 
> I wonder if we could do something lame like adding some text to the
> BCM_whatever Kconfig files, right there on the top-level menu entry which
> says "go look at CONFIG_SSB".  Make it really obvious.
> 

I did some patch that adds a hacky config option which whole
purpuse is to describe what's going on.
It's a bad hack, but for now it's probably better than nothing.
How does this look like?

Index: wireless-dev/drivers/net/Kconfig
===================================================================
--- wireless-dev.orig/drivers/net/Kconfig	2007-08-07 00:01:58.000000000 +0200
+++ wireless-dev/drivers/net/Kconfig	2007-08-09 01:52:15.000000000 +0200
@@ -1452,10 +1452,31 @@ config APRICOT
 	  <file:Documentation/networking/net-modules.txt>.  The module will be
 	  called apricot.
 
+config B44_DEP_HACK
+	bool
+	depends on SSB && SSB_PCIHOST && SSB_DRIVER_PCICORE
+	default y
+
+config B44_ADVICE_HACK
+	bool "B44 for PCI not available. Read the help text of this option!"
+	depends on !B44_DEP_HACK
+	---help---
+	  The Broadcom 440x/47xx driver for PCI devices can not be enabled,
+	  because the required dependencies are not selected.
+
+	  In order to be able to select the Broadcom 440x/47xx PCI driver, you
+	  need to enable the following options first:
+
+	  CONFIG_SSB found in menu:
+	  Device Drivers/Sonics Silicon Backplane/Sonics Silicon Backplane support
+	  CONFIG_SSB_PCIHOST found in menu:
+	  Device Drivers/Sonics Silicon Backplane/Support for SSB on PCI-bus host
+	  CONFIG_SSB_DRIVER_PCICORE found in menu:
+	  Device Drivers/Sonics Silicon Backplane/SSB PCI core driver
+
 config B44
 	tristate "Broadcom 440x/47xx ethernet support"
-	depends on HAS_IOMEM
-	select SSB
+	depends on SSB
 	select MII
 	help
 	  If you have a network (Ethernet) controller of this type, say Y
@@ -1473,9 +1494,7 @@ config B44
 
 config B44_PCI
 	bool "Broadcom 440x PCI device support"
-	depends on B44 && NET_PCI
-	select SSB_PCIHOST
-	select SSB_DRIVER_PCICORE
+	depends on B44 && SSB_PCIHOST && SSB_DRIVER_PCICORE && NET_PCI
 	default y
 	help
 	  Support for Broadcom 440x PCI devices.
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/Kconfig
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/Kconfig	2007-08-02 16:47:33.000000000 +0200
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/Kconfig	2007-08-09 01:46:39.000000000 +0200
@@ -1,8 +1,29 @@
+config BCM43XX_DEP_HACK
+	bool
+	depends on SSB && SSB_PCIHOST && SSB_DRIVER_PCICORE
+	default y
+
+config BCM43XX_ADVICE_HACK
+	bool "BCM43xx PCI (mac80211) not available. Read the help text of this option!"
+	depends on !BCM43XX_DEP_HACK
+	---help---
+	  The BCM43xx driver for BCM43xx PCI devices can not be enabled,
+	  because the required dependencies are not selected.
+
+	  In order to be able to select the BCM43xx-mac80211 driver, you
+	  need to enable the following options first:
+
+	  CONFIG_SSB found in menu:
+	  Device Drivers/Sonics Silicon Backplane/Sonics Silicon Backplane support
+	  CONFIG_SSB_PCIHOST found in menu:
+	  Device Drivers/Sonics Silicon Backplane/Support for SSB on PCI-bus host
+	  CONFIG_SSB_DRIVER_PCICORE found in menu:
+	  Device Drivers/Sonics Silicon Backplane/SSB PCI core driver
+
 config BCM43XX_MAC80211
 	tristate "Broadcom BCM43xx wireless support (mac80211 stack)"
-	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on SSB && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
-	select SSB
 	select HW_RANDOM
 	---help---
 	  This is an experimental driver for the Broadcom 43xx wireless chip,
@@ -10,9 +31,7 @@ config BCM43XX_MAC80211
 
 config BCM43XX_MAC80211_PCI
 	bool "BCM43xx PCI device support"
-	depends on BCM43XX_MAC80211 && PCI
-	select SSB_PCIHOST
-	select SSB_DRIVER_PCICORE
+	depends on BCM43XX_MAC80211 && SSB_PCIHOST && SSB_DRIVER_PCICORE
 	default y
 	---help---
 	  Broadcom 43xx PCI device support.
@@ -24,8 +43,7 @@ config BCM43XX_MAC80211_PCI
 
 config BCM43XX_MAC80211_PCMCIA
 	bool "BCM43xx PCMCIA device support"
-	depends on BCM43XX_MAC80211 && PCMCIA
-	select SSB_PCMCIAHOST
+	depends on BCM43XX_MAC80211 && SSB_PCMCIAHOST
 	---help---
 	  Broadcom 43xx PCMCIA device support.
 
@@ -45,7 +63,6 @@ config BCM43XX_MAC80211_PCMCIA
 config BCM43XX_MAC80211_DEBUG
 	bool "Broadcom BCM43xx debugging (RECOMMENDED)"
 	depends on BCM43XX_MAC80211
-	select SSB_DEBUG if !SSB_SILENT
 	default y
 	---help---
 	  Broadcom 43xx debugging messages.

