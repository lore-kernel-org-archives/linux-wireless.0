Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50642 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3FRFdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 01:33:46 -0400
Received: by mail-ee0-f47.google.com with SMTP id e49so2211122eek.6
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 22:33:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: register serial flash as platform device
Date: Tue, 18 Jun 2013 07:33:40 +0200
Message-Id: <1371533620-25293-1-git-send-email-zajec5@gmail.com> (sfid-20130618_073349_984415_C384ED69)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows writing MTD driver working as a platform driver. In
platform_data it will receive struct ssb_sflash, which contains all
important data about flash (window, size).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_chipcommon_sflash.c |   19 +++++++++++++++++++
 drivers/ssb/main.c                     |    8 ++++++++
 drivers/ssb/ssb_private.h              |    4 ++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/ssb/driver_chipcommon_sflash.c b/drivers/ssb/driver_chipcommon_sflash.c
index 205f1c4..e84cf04 100644
--- a/drivers/ssb/driver_chipcommon_sflash.c
+++ b/drivers/ssb/driver_chipcommon_sflash.c
@@ -9,6 +9,19 @@
 
 #include "ssb_private.h"
 
+static struct resource ssb_sflash_resource = {
+	.name	= "ssb_sflash",
+	.start	= SSB_FLASH2,
+	.end	= 0,
+	.flags  = IORESOURCE_MEM | IORESOURCE_READONLY,
+};
+
+struct platform_device ssb_sflash_dev = {
+	.name		= "ssb_sflash",
+	.resource	= &ssb_sflash_resource,
+	.num_resources	= 1,
+};
+
 struct ssb_sflash_tbl_e {
 	char *name;
 	u32 id;
@@ -141,6 +154,12 @@ int ssb_sflash_init(struct ssb_chipcommon *cc)
 	pr_info("Found %s serial flash (blocksize: 0x%X, blocks: %d)\n",
 		e->name, e->blocksize, e->numblocks);
 
+	/* Prepare platform device, but don't register it yet. It's too early,
+	 * malloc (required by device_private_init) is not available yet. */
+	ssb_sflash_dev.resource[0].end = ssb_sflash_dev.resource[0].start +
+					 sflash->size;
+	ssb_sflash_dev.dev.platform_data = sflash;
+
 	pr_err("Serial flash support is not implemented yet!\n");
 
 	return -ENOTSUPP;
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 812775a..e55ddf7 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -553,6 +553,14 @@ static int ssb_devices_register(struct ssb_bus *bus)
 	}
 #endif
 
+#ifdef CONFIG_SSB_SFLASH
+	if (bus->mipscore.sflash.present) {
+		err = platform_device_register(&ssb_sflash_dev);
+		if (err)
+			pr_err("Error registering serial flash\n");
+	}
+#endif
+
 	return 0;
 error:
 	/* Unwind the already registered devices. */
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 4671f17..eb507a5 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -243,6 +243,10 @@ static inline int ssb_sflash_init(struct ssb_chipcommon *cc)
 extern struct platform_device ssb_pflash_dev;
 #endif
 
+#ifdef CONFIG_SSB_SFLASH
+extern struct platform_device ssb_sflash_dev;
+#endif
+
 #ifdef CONFIG_SSB_DRIVER_EXTIF
 extern u32 ssb_extif_watchdog_timer_set_wdt(struct bcm47xx_wdt *wdt, u32 ticks);
 extern u32 ssb_extif_watchdog_timer_set_ms(struct bcm47xx_wdt *wdt, u32 ms);
-- 
1.7.10.4

