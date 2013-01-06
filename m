Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:61887 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3AFUst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2013 15:48:49 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so8134816bkc.38
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2013 12:48:48 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: add place for serial flash driver
Date: Sun,  6 Jan 2013 21:48:50 +0100
Message-Id: <1357505330-7689-1-git-send-email-zajec5@gmail.com> (sfid-20130106_214903_736036_FB037301)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/Kconfig                    |    5 +++++
 drivers/ssb/Makefile                   |    1 +
 drivers/ssb/driver_chipcommon_sflash.c |   18 ++++++++++++++++++
 drivers/ssb/driver_mipscore.c          |    3 ++-
 drivers/ssb/ssb_private.h              |   11 +++++++++++
 5 files changed, 37 insertions(+), 1 deletions(-)
 create mode 100644 drivers/ssb/driver_chipcommon_sflash.c

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 4620460..4f0dd37 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -137,6 +137,11 @@ config SSB_DRIVER_MIPS
 
 	  If unsure, say N
 
+config SSB_SFLASH
+	bool "SSB serial flash support"
+	depends on SSB_DRIVER_MIPS && BROKEN
+	default y
+
 # Assumption: We are on embedded, if we compile the MIPS core.
 config SSB_EMBEDDED
 	bool
diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index 9159ba7..b1ddc11 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -11,6 +11,7 @@ ssb-$(CONFIG_SSB_SDIOHOST)		+= sdio.o
 # built-in drivers
 ssb-y					+= driver_chipcommon.o
 ssb-y					+= driver_chipcommon_pmu.o
+ssb-$(CONFIG_SSB_SFLASH)		+= driver_chipcommon_sflash.o
 ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
 ssb-$(CONFIG_SSB_DRIVER_EXTIF)		+= driver_extif.o
 ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
diff --git a/drivers/ssb/driver_chipcommon_sflash.c b/drivers/ssb/driver_chipcommon_sflash.c
new file mode 100644
index 0000000..8662697
--- /dev/null
+++ b/drivers/ssb/driver_chipcommon_sflash.c
@@ -0,0 +1,18 @@
+/*
+ * Sonics Silicon Backplane
+ * ChipCommon serial flash interface
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/ssb/ssb.h>
+
+#include "ssb_private.h"
+
+/* Initialize serial flash access */
+int ssb_sflash_init(struct ssb_chipcommon *cc)
+{
+	pr_err("Serial flash support is not implemented yet!\n");
+
+	return -ENOTSUPP;
+}
diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index 5bd05b1..2a7684c 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -203,7 +203,8 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 	switch (bus->chipco.capabilities & SSB_CHIPCO_CAP_FLASHT) {
 	case SSB_CHIPCO_FLASHT_STSER:
 	case SSB_CHIPCO_FLASHT_ATSER:
-		pr_err("Serial flash not supported\n");
+		pr_debug("Found serial flash\n");
+		ssb_sflash_init(&bus->chipco);
 		break;
 	case SSB_CHIPCO_FLASHT_PARA:
 		pr_debug("Found parallel flash\n");
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 6c10b66..77d9426 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -217,6 +217,17 @@ extern u32 ssb_chipco_watchdog_timer_set_wdt(struct bcm47xx_wdt *wdt,
 					     u32 ticks);
 extern u32 ssb_chipco_watchdog_timer_set_ms(struct bcm47xx_wdt *wdt, u32 ms);
 
+/* driver_chipcommon_sflash.c */
+#ifdef CONFIG_SSB_SFLASH
+int ssb_sflash_init(struct ssb_chipcommon *cc);
+#else
+static inline int ssb_sflash_init(struct ssb_chipcommon *cc)
+{
+	pr_err("Serial flash not supported\n");
+	return 0;
+}
+#endif /* CONFIG_SSB_SFLASH */
+
 #ifdef CONFIG_SSB_DRIVER_EXTIF
 extern u32 ssb_extif_watchdog_timer_set_wdt(struct bcm47xx_wdt *wdt, u32 ticks);
 extern u32 ssb_extif_watchdog_timer_set_ms(struct bcm47xx_wdt *wdt, u32 ms);
-- 
1.7.7

