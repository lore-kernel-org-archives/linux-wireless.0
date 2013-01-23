Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46062 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3AWLHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 06:07:55 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so4018142eei.35
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 03:07:54 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 RFC 2/2] ssb: register platform device for parallel flash
Date: Wed, 23 Jan 2013 12:07:49 +0100
Message-Id: <1358939269-22502-1-git-send-email-zajec5@gmail.com> (sfid-20130123_120759_218210_1D429F94)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: register as "physmap-flash"

I think we can safely do that without CONFIG_MTD_PHYSMAP dependency.
Am I right?
---
 drivers/ssb/driver_mipscore.c |   29 ++++++++++++++++++++++++++++-
 drivers/ssb/main.c            |    8 ++++++++
 drivers/ssb/ssb_private.h     |    4 ++++
 3 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index 77bc8d4..33b37da 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -10,6 +10,7 @@
 
 #include <linux/ssb/ssb.h>
 
+#include <linux/mtd/physmap.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
@@ -17,6 +18,25 @@
 
 #include "ssb_private.h"
 
+static const char *part_probes[] = { "bcm47xxpart", NULL };
+
+static struct physmap_flash_data ssb_pflash_data = {
+	.part_probe_types	= part_probes,
+};
+
+static struct resource ssb_pflash_resource = {
+	.name	= "ssb_pflash",
+	.flags  = IORESOURCE_MEM,
+};
+
+struct platform_device ssb_pflash_dev = {
+	.name		= "physmap-flash",
+	.dev		= {
+		.platform_data  = &ssb_pflash_data,
+	},
+	.resource	= &ssb_pflash_resource,
+	.num_resources	= 1,
+};
 
 static inline u32 mips_read32(struct ssb_mipscore *mcore,
 			      u16 offset)
@@ -197,7 +217,7 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 		pflash->buswidth = 2;
 		pflash->window = SSB_FLASH1;
 		pflash->window_size = SSB_FLASH1_SZ;
-		return;
+		goto ssb_pflash;
 	}
 
 	/* There is ChipCommon, so use it to read info about flash */
@@ -219,6 +239,13 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 			pflash->buswidth = 2;
 		break;
 	}
+
+ssb_pflash:
+	if (pflash->present) {
+		ssb_pflash_data.width = pflash->buswidth;
+		ssb_pflash_resource.start = pflash->window;
+		ssb_pflash_resource.end = pflash->window + pflash->window_size;
+	}
 }
 
 u32 ssb_cpu_clock(struct ssb_mipscore *mcore)
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 772ad9b..9987d9f 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -540,6 +540,14 @@ static int ssb_devices_register(struct ssb_bus *bus)
 		dev_idx++;
 	}
 
+#ifdef CONFIG_SSB_DRIVER_MIPS
+	if (bus->mipscore.pflash.present) {
+		err = platform_device_register(&ssb_pflash_dev);
+		if (err)
+			pr_err("Error registering parallel flash\n");
+	}
+#endif
+
 	return 0;
 error:
 	/* Unwind the already registered devices. */
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 77d9426..53198dc 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -228,6 +228,10 @@ static inline int ssb_sflash_init(struct ssb_chipcommon *cc)
 }
 #endif /* CONFIG_SSB_SFLASH */
 
+#ifdef CONFIG_SSB_DRIVER_MIPS
+extern struct platform_device ssb_pflash_dev;
+#endif
+
 #ifdef CONFIG_SSB_DRIVER_EXTIF
 extern u32 ssb_extif_watchdog_timer_set_wdt(struct bcm47xx_wdt *wdt, u32 ticks);
 extern u32 ssb_extif_watchdog_timer_set_ms(struct bcm47xx_wdt *wdt, u32 ms);
-- 
1.7.7

