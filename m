Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:39389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933648AbXCUS6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 14:58:07 -0400
Received: by ug-out-1314.google.com with SMTP id 44so435317uga
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2007 11:58:05 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] Move eeprom_93cx6 from lib/ to drivers/misc/
Date: Wed, 21 Mar 2007 19:57:39 +0100
Cc: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703211957.39999.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As requested, this will move the eeprom_93cx6 from its location in
lib/ to drivers/misc/
This second version uses correct identation for the --help-- line.

Signed-off-by Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 80b199f..4069fe1 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -122,4 +122,12 @@ config SONY_LAPTOP
 
 	  Read <file:Documentation/sony-laptop.txt> for more information.
 
+config EEPROM_93CX6
+	tristate "EEPROM 93CX6 support"
+	---help---
+	  This is a driver for the EEPROM chipsets 93c46 and 93c66.
+	  The driver supports both read as well as write commands.
+
+	  When compiled as a module, this driver will be called "eeprom_93c6.ko".
+
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7793ccd..f65b835 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
+obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
diff --git a/lib/eeprom_93cx6.c b/drivers/misc/eeprom_93cx6.c
similarity index 100%
rename from lib/eeprom_93cx6.c
rename to drivers/misc/eeprom_93cx6.c
diff --git a/lib/Kconfig b/lib/Kconfig
index 0b275b7..8e91748 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -50,14 +50,6 @@ config LIBCRC32C
 	  require M here.  See Castagnoli93.
 	  Module will be libcrc32c.
 
-config EEPROM_93CX6
-	tristate "EEPROM 93CX6 support"
-	---help---
-	This is a driver for the EEPROM chipsets 93c46 and 93c66.
-	The driver supports both read as well as write commands.
-
-	When compiled as a module, this driver will be called "eeprom_93c6.ko".
-
 config AUDIT_GENERIC
 	bool
 	depends on AUDIT && !AUDIT_ARCH
diff --git a/lib/Makefile b/lib/Makefile
index 71ae5be..d7edaf3 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -56,8 +56,6 @@ obj-$(CONFIG_TEXTSEARCH_FSM) += ts_fsm.o
 obj-$(CONFIG_SMP) += percpu_counter.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 
-obj-$(CONFIG_EEPROM_93CX6) += eeprom_93cx6.o
-
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
