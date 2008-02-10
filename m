Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:18709 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbYBJSyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 13:54:33 -0500
Date: Sun, 10 Feb 2008 10:52:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
	Michael =?ISO-8859-1?Q?B=FCker?= <m.bueker@berlin.de>,
	linville@tuxdriver.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH] wireless: rt2x00: fix driver menu indenting
Message-Id: <20080210105252.e0a433ee.randy.dunlap@oracle.com> (sfid-20080210_185441_360764_7EDBFEBD)
In-Reply-To: <200802091623.06504.m.bueker@berlin.de>
References: <200802091623.06504.m.bueker@berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 9 Feb 2008 16:23:06 +0100 Michael B=FCker wrote:

> 2) When selecting "Ralink driver support" (CONFIG_RT2X00), the accomp=
anying=20
> drivers (CONFIG_RT2400PCI, CONFIG_RT61PC, ...) appear unindented. The=
y should=20
> be indented by four spaces.

Yes, patch is below.

---
=46rom: Randy Dunlap <randy.dunlap@oracle.com>

Michael B=FCker <m.bueker@berlin.de> reports that the RT2x00 drivers
are not indented as they should be, so use proper dependencies to make
them be indented as expected.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/rt2x00/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-2.6.24-git21.orig/drivers/net/wireless/rt2x00/Kconfig
+++ linux-2.6.24-git21/drivers/net/wireless/rt2x00/Kconfig
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
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
