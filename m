Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [77.235.43.93] ([77.235.43.93]:54072 "EHLO main.fasthost.gr"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750725AbXGVNXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2007 09:23:31 -0400
Received: from paravoid  by divinity (envelope-from <paravoid@debian.org>)
	with local (Exim 4.63 (Debian GNU/Linux))
	id 1ICbIa-0000lx-Ea
	for linux-wireless@vger.kernel.org; Sun, 22 Jul 2007 16:16:36 +0300
Date: Sun, 22 Jul 2007 16:16:36 +0300
From: Faidon Liambotis <paravoid@debian.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.23 1/3] [wireless] Kconfig: order options
Message-ID: <20070722131636.GA2967@void.cube.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder the Atmel options so that the menu appears saner.
Before:
  < >   Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)
  <*>   Atmel at76c50x chipset  802.11b support
  < >     Atmel at76c506 PCI cards (NEW)
  < > Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards
  < > Atmel at76c502/at76c504 PCMCIA cards (NEW)

After:
  < >   Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)
  <*>   Atmel at76c50x chipset  802.11b support
  < >     Atmel at76c506 PCI cards (NEW)
  < >     Atmel at76c502/at76c504 PCMCIA cards (NEW)
  < >   Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards

Signed-off-by: Faidon Liambotis <paravoid@debian.org>
---
 drivers/net/wireless/Kconfig |   68 +++++++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index ae27af0..2e264b0 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -379,30 +379,6 @@ config PCI_HERMES
 	  common.  Some of the built-in wireless adaptors in laptops are of
 	  this variety.
 
-config ATMEL
-      tristate "Atmel at76c50x chipset  802.11b support"
-      depends on (PCI || PCMCIA) && WLAN_80211
-      select WIRELESS_EXT
-      select FW_LOADER
-      select CRC32
-       ---help---
-        A driver 802.11b wireless cards based on the Atmel fast-vnet
-        chips. This driver supports standard Linux wireless extensions. 
- 
-        Many  cards based on this chipset do not have flash memory
-        and need their firmware loaded at start-up. If yours is 
-        one of these, you will need to provide a firmware image
-        to be loaded into the card by the driver. The Atmel
-        firmware package can be downloaded from
-        <http://www.thekelleys.org.uk/atmel>
-
-config PCI_ATMEL
-      tristate "Atmel at76c506 PCI cards"
-      depends on ATMEL && PCI
-       ---help---
-        Enable support for PCI and mini-PCI cards containing the
-        Atmel at76c506 chip.
-
 config PCMCIA_HERMES
 	tristate "Hermes PCMCIA card support"
 	depends on PCMCIA && HERMES
@@ -437,6 +413,40 @@ config PCMCIA_SPECTRUM
 	  for downloading Symbol firmware are available at
 	  <http://sourceforge.net/projects/orinoco/>
 
+config ATMEL
+      tristate "Atmel at76c50x chipset  802.11b support"
+      depends on (PCI || PCMCIA) && WLAN_80211
+      select WIRELESS_EXT
+      select FW_LOADER
+      select CRC32
+       ---help---
+        A driver 802.11b wireless cards based on the Atmel fast-vnet
+        chips. This driver supports standard Linux wireless extensions. 
+ 
+        Many  cards based on this chipset do not have flash memory
+        and need their firmware loaded at start-up. If yours is 
+        one of these, you will need to provide a firmware image
+        to be loaded into the card by the driver. The Atmel
+        firmware package can be downloaded from
+        <http://www.thekelleys.org.uk/atmel>
+
+config PCI_ATMEL
+      tristate "Atmel at76c506 PCI cards"
+      depends on ATMEL && PCI
+       ---help---
+        Enable support for PCI and mini-PCI cards containing the
+        Atmel at76c506 chip.
+
+config PCMCIA_ATMEL
+	tristate "Atmel at76c502/at76c504 PCMCIA cards"
+	depends on ATMEL && PCMCIA
+	select WIRELESS_EXT
+	select FW_LOADER
+	select CRC32
+	---help---
+	  Enable support for PCMCIA cards containing the
+	  Atmel at76c502 and at76c504 chips.
+
 config AIRO_CS
 	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
 	depends on PCMCIA && (BROKEN || !M32R) && WLAN_80211
@@ -462,16 +472,6 @@ config AIRO_CS
 	  for location).  You also want to check out the PCMCIA-HOWTO,
 	  available from <http://www.tldp.org/docs.html#howto>.
 
-config PCMCIA_ATMEL
-	tristate "Atmel at76c502/at76c504 PCMCIA cards"
-	depends on ATMEL && PCMCIA
-	select WIRELESS_EXT
-	select FW_LOADER
-	select CRC32
-	---help---
-	  Enable support for PCMCIA cards containing the
-	  Atmel at76c502 and at76c504 chips.
-
 config PCMCIA_WL3501
       tristate "Planet WL3501 PCMCIA cards"
       depends on EXPERIMENTAL && PCMCIA && WLAN_80211
-- 
1.5.2.4

