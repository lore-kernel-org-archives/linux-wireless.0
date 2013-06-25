Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:50714 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3FYIVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 04:21:39 -0400
Received: by mail-ea0-f177.google.com with SMTP id j14so6611580eak.22
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jun 2013 01:21:38 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: drop BROKEN from SSB_SFLASH
Date: Tue, 25 Jun 2013 10:13:46 +0200
Message-Id: <1372148026-9750-1-git-send-email-zajec5@gmail.com> (sfid-20130625_102144_262768_52A9944E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With recent patches ssb can fetch info about serial flash and register
it as a platform device. No more reasons to mark it BROKEN.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
---
Hauke: does it look OK for you? Did you give it a try?
---
 drivers/ssb/Kconfig                    |    2 +-
 drivers/ssb/driver_chipcommon_sflash.c |    8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 4f0dd37..775251d 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -139,7 +139,7 @@ config SSB_DRIVER_MIPS
 
 config SSB_SFLASH
 	bool "SSB serial flash support"
-	depends on SSB_DRIVER_MIPS && BROKEN
+	depends on SSB_DRIVER_MIPS
 	default y
 
 # Assumption: We are on embedded, if we compile the MIPS core.
diff --git a/drivers/ssb/driver_chipcommon_sflash.c b/drivers/ssb/driver_chipcommon_sflash.c
index e84cf04..50328de 100644
--- a/drivers/ssb/driver_chipcommon_sflash.c
+++ b/drivers/ssb/driver_chipcommon_sflash.c
@@ -151,8 +151,8 @@ int ssb_sflash_init(struct ssb_chipcommon *cc)
 	sflash->size = sflash->blocksize * sflash->numblocks;
 	sflash->present = true;
 
-	pr_info("Found %s serial flash (blocksize: 0x%X, blocks: %d)\n",
-		e->name, e->blocksize, e->numblocks);
+	pr_info("Found %s serial flash (size: %dKiB, blocksize: 0x%X, blocks: %d)\n",
+		e->name, sflash->size / 1024, e->blocksize, e->numblocks);
 
 	/* Prepare platform device, but don't register it yet. It's too early,
 	 * malloc (required by device_private_init) is not available yet. */
@@ -160,7 +160,5 @@ int ssb_sflash_init(struct ssb_chipcommon *cc)
 					 sflash->size;
 	ssb_sflash_dev.dev.platform_data = sflash;
 
-	pr_err("Serial flash support is not implemented yet!\n");
-
-	return -ENOTSUPP;
+	return 0;
 }
-- 
1.7.10.4

