Return-path: <linux-wireless-owner@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934398AbYCDX1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 18:27:50 -0500
Message-Id: <200803042326.m24NQ7Fa003264@imap1.linux-foundation.org> (sfid-20080304_232755_626162_664D43A5)
Subject: [patch 02/10] wireless: rt2x00: fix driver menu indenting
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	randy.dunlap@oracle.com, IvDoorn@gmail.com, m.bueker@berlin.de
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2008 15:26:07 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Randy Dunlap <randy.dunlap@oracle.com>

Michael B=FCker reports that the RT2x00 drivers are not indented as the=
y
should be, so use proper dependencies to make them be indented as expec=
ted.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael B=FCker <m.bueker@berlin.de>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rt2x00/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/net/wireless/rt2x00/Kconfig~wireless-rt2x00-fix-drive=
r-menu-indenting drivers/net/wireless/rt2x00/Kconfig
--- a/drivers/net/wireless/rt2x00/Kconfig~wireless-rt2x00-fix-driver-me=
nu-indenting
+++ a/drivers/net/wireless/rt2x00/Kconfig
@@ -11,18 +11,17 @@ config RT2X00
 	  will also be created. That library (when the driver is built as
 	  a module) will be called "rt2x00lib.ko".
=20
+if RT2X00
+
 config RT2X00_LIB
 	tristate
-	depends on RT2X00
=20
 config RT2X00_LIB_PCI
 	tristate
-	depends on RT2X00
 	select RT2X00_LIB
=20
 config RT2X00_LIB_USB
 	tristate
-	depends on RT2X00
 	select RT2X00_LIB
=20
 config RT2X00_LIB_FIRMWARE
@@ -39,7 +38,7 @@ config RT2X00_LIB_RFKILL
=20
 config RT2400PCI
 	tristate "Ralink rt2400 pci/pcmcia support"
-	depends on RT2X00 && PCI
+	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
@@ -58,7 +57,7 @@ config RT2400PCI_RFKILL
=20
 config RT2500PCI
 	tristate "Ralink rt2500 pci/pcmcia support"
-	depends on RT2X00 && PCI
+	depends on PCI
 	select RT2X00_LIB_PCI
 	select EEPROM_93CX6
 	---help---
@@ -77,7 +76,7 @@ config RT2500PCI_RFKILL
=20
 config RT61PCI
 	tristate "Ralink rt61 pci/pcmcia support"
-	depends on RT2X00 && PCI
+	depends on PCI
 	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
 	select EEPROM_93CX6
@@ -97,7 +96,7 @@ config RT61PCI_RFKILL
=20
 config RT2500USB
 	tristate "Ralink rt2500 usb support"
-	depends on RT2X00 && USB
+	depends on USB
 	select RT2X00_LIB_USB
 	---help---
 	  This is an experimental driver for the Ralink rt2500 wireless chip.
@@ -106,7 +105,7 @@ config RT2500USB
=20
 config RT73USB
 	tristate "Ralink rt73 usb support"
-	depends on RT2X00 && USB
+	depends on USB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
 	---help---
@@ -128,3 +127,4 @@ config RT2X00_DEBUG
 	---help---
 	  Enable debugging output for all rt2x00 modules
=20
+endif
_
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
