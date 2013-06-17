Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:46119 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3FQR42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 13:56:28 -0400
Received: by mail-ea0-f170.google.com with SMTP id h10so2002363eaj.15
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 10:56:27 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: add struct for serial flash
Date: Mon, 17 Jun 2013 19:56:20 +0200
Message-Id: <1371491780-23412-1-git-send-email-zajec5@gmail.com> (sfid-20130617_195633_489593_1F83C7E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This data allow writing for example MTD driver.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_chipcommon_sflash.c |    7 +++++++
 include/linux/ssb/ssb_driver_mips.h    |   15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/ssb/driver_chipcommon_sflash.c b/drivers/ssb/driver_chipcommon_sflash.c
index 1b9e770..205f1c4 100644
--- a/drivers/ssb/driver_chipcommon_sflash.c
+++ b/drivers/ssb/driver_chipcommon_sflash.c
@@ -73,6 +73,7 @@ static void ssb_sflash_cmd(struct ssb_chipcommon *cc, u32 opcode)
 /* Initialize serial flash access */
 int ssb_sflash_init(struct ssb_chipcommon *cc)
 {
+	struct ssb_sflash *sflash = &cc->dev->bus->mipscore.sflash;
 	const struct ssb_sflash_tbl_e *e;
 	u32 id, id2;
 
@@ -131,6 +132,12 @@ int ssb_sflash_init(struct ssb_chipcommon *cc)
 		return -ENOTSUPP;
 	}
 
+	sflash->window = SSB_FLASH2;
+	sflash->blocksize = e->blocksize;
+	sflash->numblocks = e->numblocks;
+	sflash->size = sflash->blocksize * sflash->numblocks;
+	sflash->present = true;
+
 	pr_info("Found %s serial flash (blocksize: 0x%X, blocks: %d)\n",
 		e->name, e->blocksize, e->numblocks);
 
diff --git a/include/linux/ssb/ssb_driver_mips.h b/include/linux/ssb/ssb_driver_mips.h
index afe79d4..6535e47 100644
--- a/include/linux/ssb/ssb_driver_mips.h
+++ b/include/linux/ssb/ssb_driver_mips.h
@@ -20,6 +20,18 @@ struct ssb_pflash {
 	u32 window_size;
 };
 
+#ifdef CONFIG_SSB_SFLASH
+struct ssb_sflash {
+	bool present;
+	u32 window;
+	u32 blocksize;
+	u16 numblocks;
+	u32 size;
+
+	void *priv;
+};
+#endif
+
 struct ssb_mipscore {
 	struct ssb_device *dev;
 
@@ -27,6 +39,9 @@ struct ssb_mipscore {
 	struct ssb_serial_port serial_ports[4];
 
 	struct ssb_pflash pflash;
+#ifdef CONFIG_SSB_SFLASH
+	struct ssb_sflash sflash;
+#endif
 };
 
 extern void ssb_mipscore_init(struct ssb_mipscore *mcore);
-- 
1.7.10.4

