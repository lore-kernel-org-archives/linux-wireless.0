Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48744 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab3JQHmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 01/21] rt2x00: create a new module for rt2800 MMIO code
Date: Thu, 17 Oct 2013 09:42:15 +0200
Message-Id: <1381995755-16471-2-git-send-email-juhosg@openwrt.org> (sfid-20131017_100808_383487_6CF418CE)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create a new module for common code which can be used
for rt2800 device with memory mapped I/O. It is an empty
module for now, but it will be populated by subsequent
patches.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/Kconfig      |    4 +++
 drivers/net/wireless/rt2x00/Makefile     |    1 +
 drivers/net/wireless/rt2x00/rt2800mmio.c |   39 ++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800mmio.h |   34 ++++++++++++++++++++++++++
 4 files changed, 78 insertions(+)
 create mode 100644 drivers/net/wireless/rt2x00/rt2800mmio.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2800mmio.h

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index a18b005..2232b11 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -60,6 +60,7 @@ config RT2800PCI
 	tristate "Ralink rt27xx/rt28xx/rt30xx (PCI/PCIe/PCMCIA) support"
 	depends on PCI || SOC_RT288X || SOC_RT305X
 	select RT2800_LIB
+	select RT2800_LIB_MMIO
 	select RT2X00_LIB_MMIO
 	select RT2X00_LIB_PCI if PCI
 	select RT2X00_LIB_SOC if SOC_RT288X || SOC_RT305X
@@ -202,6 +203,9 @@ endif
 config RT2800_LIB
 	tristate
 
+config RT2800_LIB_MMIO
+	tristate
+
 config RT2X00_LIB_MMIO
 	tristate
 
diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
index f069d8b..d11e356 100644
--- a/drivers/net/wireless/rt2x00/Makefile
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_RT2X00_LIB_PCI)		+= rt2x00pci.o
 obj-$(CONFIG_RT2X00_LIB_SOC)		+= rt2x00soc.o
 obj-$(CONFIG_RT2X00_LIB_USB)		+= rt2x00usb.o
 obj-$(CONFIG_RT2800_LIB)		+= rt2800lib.o
+obj-$(CONFIG_RT2800_LIB_MMIO)		+= rt2800mmio.o
 obj-$(CONFIG_RT2400PCI)			+= rt2400pci.o
 obj-$(CONFIG_RT2500PCI)			+= rt2500pci.o
 obj-$(CONFIG_RT61PCI)			+= rt61pci.o
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.c b/drivers/net/wireless/rt2x00/rt2800mmio.c
new file mode 100644
index 0000000..a2b9848
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.c
@@ -0,0 +1,39 @@
+/*	Copyright (C) 2009 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
+ *	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
+ *	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
+ *	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
+ *	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
+ *	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
+ *	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
+ *	Copyright (C) 2009 Bart Zolnierkiewicz <bzolnier@gmail.com>
+ *	<http://rt2x00.serialmonkey.com>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the
+ *	Free Software Foundation, Inc.,
+ *	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*	Module: rt2800mmio
+ *	Abstract: rt2800 MMIO device routines.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "rt2x00.h"
+
+MODULE_AUTHOR(DRV_PROJECT);
+MODULE_VERSION(DRV_VERSION);
+MODULE_DESCRIPTION("rt2800 MMIO library");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.h b/drivers/net/wireless/rt2x00/rt2800mmio.h
new file mode 100644
index 0000000..32f9dcd
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.h
@@ -0,0 +1,34 @@
+/*	Copyright (C) 2009 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
+ *	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
+ *	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
+ *	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
+ *	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
+ *	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
+ *	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
+ *	Copyright (C) 2009 Bart Zolnierkiewicz <bzolnier@gmail.com>
+ *	<http://rt2x00.serialmonkey.com>
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the
+ *	Free Software Foundation, Inc.,
+ *	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*	Module: rt2800mmio
+ *	Abstract: forward declarations for the rt2800mmio module.
+ */
+
+#ifndef RT2800MMIO_H
+#define RT2800MMIO_H
+
+#endif /* RT2800MMIO_H */
-- 
1.7.10
