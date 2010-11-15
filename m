Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:51936 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab0KONQN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 08:16:13 -0500
Date: Mon, 15 Nov 2010 14:16:06 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
Message-ID: <1785288.181289826959653.JavaMail.wlan@CHBU500181>
In-Reply-To: <16168765.161289826231239.JavaMail.wlan@CHBU500181>
Subject: Re: [PATCH 8/9] ath5k: AHB port. Add AHB bus support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, Nov 12, 2010 at 08:55:36PM +0100, Felix Fietkau wrote:
> > On 2010-11-12 8:51 PM, Wojciech Dubowik wrote:
> > >> Having both in the kernel is completely pointless. There are no
> > >> devices
> > >> that can support both, nor will there ever be.
> > > 
> > > I agree. The only advantage would be that some of the typos and
> missing
> > > functions in either of the files would be detected during compile
> time.
> 
> Compile-testing coverage is a fine reason to allow people to compile
> both modules.  Ok, I accept that it's a bit of a pain to create
> separate
> modules, but can we at least do it like:
> 
> ath5k-$(CONFIG_ATH5K_PCI) += pci.o
> ath5k-$(CONFIG_ATH5K_AHB) += ahb.o
> 
> and add the appropriate selects and mutual exclusion to the Kconfig?
> Of course, that presupposes a Kconfig entry for CONFIG_ATHEROS_AR2316
> where there is not one currently.
> 
> -- 
> Bob Copeland %% www.bobcopeland.com

What about such changes compared to original patch? It's then possible to
compile both modules at the same time. Of course linking won't work because
I would need to separate functions like in ath9k.

---
diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index eb83b7b..eba97f8 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -1,9 +1,11 @@
 config ATH5K
        tristate "Atheros 5xxx wireless cards support"
-       depends on PCI && MAC80211
+       depends on (PCI || ATHEROS_AR231X) && MAC80211
        select MAC80211_LEDS
        select LEDS_CLASS
        select NEW_LEDS
+       select ATH5K_AHB if ATHEROS_AR231X
+       select ATH5K_PCI if PCI
        ---help---
          This module adds support for wireless adapters based on
          Atheros 5xxx chipset.
@@ -37,3 +39,14 @@ config ATH5K_DEBUG
 
          modprobe ath5k debug=0x00000400
 
+config ATH5K_AHB
+       bool "Atheros 5xxx AHB bus support"
+       depends on ATHEROS_AR231X
+       ---help---
+       This adds support for WiSoC type chipsets of the 5xxx family
+
+config ATH5K_PCI
+       bool "Atheros 5xxx PCI bus support"
+       depends on PCI
+       ---help---
+       This adds support for PCI type chipsets of the 5xxx family
diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index 50d5e08..a16b178 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -15,5 +15,6 @@ ath5k-y                               += rfkill.o
 ath5k-y                                += ani.o
 ath5k-y                                += sysfs.o
 ath5k-$(CONFIG_ATH5K_DEBUG)    += debug.o
-ath5k-y                                += $(if $(CONFIG_ATHEROS_AR231X),ahb,pci).o
+ath5k-$(CONFIG_ATH5K_PCI)      += pci.o
+ath5k-$(CONFIG_ATH5K_AHB)      += ahb.o
 obj-$(CONFIG_ATH5K)            += ath5k.o
