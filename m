Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33752 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbLIBFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 20:05:18 -0500
Received: by pabur14 with SMTP id ur14so20559886pab.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2015 17:05:18 -0800 (PST)
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-mtd@lists.infradead.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Brian Norris <computersforpeace@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mtd: bcm47xxnflash: really unregister NAND on device removal
Date: Tue,  8 Dec 2015 17:04:59 -0800
Message-Id: <1449623099-21634-1-git-send-email-computersforpeace@gmail.com> (sfid-20151209_020523_182350_9857B3D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The field bcma_nflash::mtd is never set to be non-zero anywhere, but we
test for it in the removal path. So the MTD is never unregistered.

Also, we should use nand_release(), not mtd_device_unregister().

Finally, we don't need to use the 'platdata' for stashing/retrieving our
*driver* data -- that's what *_{get,set}_drvdata() are for.

So, kill off bcm_nflash::mtd, and stash the struct bcm47xxnflash in
drvdata instead. Also move the forward declaration of mtd_info up a bit,
since struct bcma_sflash should be using it.

Caught while inspecting other changes being made to this driver. Compile
tested only.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: "Rafał Miłecki" <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
---
Might have some small conflict with Boris' NAND/MTD refactoring patch set. I
can rebase this small one if his gets in proper shape. Just wanted to get this
out there.

 drivers/mtd/nand/bcm47xxnflash/main.c       | 7 ++++---
 include/linux/bcma/bcma_driver_chipcommon.h | 6 ++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/bcm47xxnflash/main.c b/drivers/mtd/nand/bcm47xxnflash/main.c
index 9ba0c0f2cd9b..0b3acc439181 100644
--- a/drivers/mtd/nand/bcm47xxnflash/main.c
+++ b/drivers/mtd/nand/bcm47xxnflash/main.c
@@ -49,6 +49,8 @@ static int bcm47xxnflash_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	platform_set_drvdata(pdev, b47n);
+
 	err = mtd_device_parse_register(&b47n->mtd, probes, NULL, NULL, 0);
 	if (err) {
 		pr_err("Failed to register MTD device: %d\n", err);
@@ -60,10 +62,9 @@ static int bcm47xxnflash_probe(struct platform_device *pdev)
 
 static int bcm47xxnflash_remove(struct platform_device *pdev)
 {
-	struct bcma_nflash *nflash = dev_get_platdata(&pdev->dev);
+	struct bcm47xxnflash *nflash = platform_get_drvdata(pdev);
 
-	if (nflash->mtd)
-		mtd_device_unregister(nflash->mtd);
+	nand_release(&nflash->mtd);
 
 	return 0;
 }
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index cf038431a5cc..db51a6ffb7d6 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -579,6 +579,8 @@ struct bcma_pflash {
 };
 
 #ifdef CONFIG_BCMA_SFLASH
+struct mtd_info;
+
 struct bcma_sflash {
 	bool present;
 	u32 window;
@@ -592,13 +594,9 @@ struct bcma_sflash {
 #endif
 
 #ifdef CONFIG_BCMA_NFLASH
-struct mtd_info;
-
 struct bcma_nflash {
 	bool present;
 	bool boot;		/* This is the flash the SoC boots from */
-
-	struct mtd_info *mtd;
 };
 #endif
 
-- 
2.6.0.rc2.230.g3dd15c0

