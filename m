Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34215 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbbLRTil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 14:38:41 -0500
Received: by mail-pa0-f50.google.com with SMTP id wq6so65010481pac.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2015 11:38:40 -0800 (PST)
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-mtd@lists.infradead.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Brian Norris <computersforpeace@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v5] mtd: nand: bcm47xx: use the mtd instance embedded in struct nand_chip
Date: Fri, 18 Dec 2015 11:38:18 -0800
Message-Id: <1450467498-35553-1-git-send-email-computersforpeace@gmail.com> (sfid-20151218_203844_584459_E8C90D65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

struct nand_chip now embeds an mtd device. Make use of this mtd instance.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
Rebased Boris's patch to l2-mtd.git

 drivers/mtd/nand/bcm47xxnflash/bcm47xxnflash.h |  1 -
 drivers/mtd/nand/bcm47xxnflash/main.c          | 10 ++++++----
 drivers/mtd/nand/bcm47xxnflash/ops_bcm4706.c   |  2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/bcm47xxnflash/bcm47xxnflash.h b/drivers/mtd/nand/bcm47xxnflash/bcm47xxnflash.h
index c005a62330b1..8ea75710a854 100644
--- a/drivers/mtd/nand/bcm47xxnflash/bcm47xxnflash.h
+++ b/drivers/mtd/nand/bcm47xxnflash/bcm47xxnflash.h
@@ -12,7 +12,6 @@ struct bcm47xxnflash {
 	struct bcma_drv_cc *cc;
 
 	struct nand_chip nand_chip;
-	struct mtd_info mtd;
 
 	unsigned curr_command;
 	int curr_page_addr;
diff --git a/drivers/mtd/nand/bcm47xxnflash/main.c b/drivers/mtd/nand/bcm47xxnflash/main.c
index 0b3acc439181..2c9bffb614c5 100644
--- a/drivers/mtd/nand/bcm47xxnflash/main.c
+++ b/drivers/mtd/nand/bcm47xxnflash/main.c
@@ -27,6 +27,7 @@ static int bcm47xxnflash_probe(struct platform_device *pdev)
 {
 	struct bcma_nflash *nflash = dev_get_platdata(&pdev->dev);
 	struct bcm47xxnflash *b47n;
+	struct mtd_info *mtd;
 	int err = 0;
 
 	b47n = devm_kzalloc(&pdev->dev, sizeof(*b47n), GFP_KERNEL);
@@ -34,8 +35,9 @@ static int bcm47xxnflash_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	b47n->nand_chip.priv = b47n;
-	b47n->mtd.dev.parent = &pdev->dev;
-	b47n->mtd.priv = &b47n->nand_chip; /* Required */
+	mtd = nand_to_mtd(&b47n->nand_chip);
+	mtd->dev.parent = &pdev->dev;
+	mtd->priv = &b47n->nand_chip; /* Required */
 	b47n->cc = container_of(nflash, struct bcma_drv_cc, nflash);
 
 	if (b47n->cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
@@ -51,7 +53,7 @@ static int bcm47xxnflash_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, b47n);
 
-	err = mtd_device_parse_register(&b47n->mtd, probes, NULL, NULL, 0);
+	err = mtd_device_parse_register(mtd, probes, NULL, NULL, 0);
 	if (err) {
 		pr_err("Failed to register MTD device: %d\n", err);
 		return err;
@@ -64,7 +66,7 @@ static int bcm47xxnflash_remove(struct platform_device *pdev)
 {
 	struct bcm47xxnflash *nflash = platform_get_drvdata(pdev);
 
-	nand_release(&nflash->mtd);
+	nand_release(nand_to_mtd(&nflash->nand_chip));
 
 	return 0;
 }
diff --git a/drivers/mtd/nand/bcm47xxnflash/ops_bcm4706.c b/drivers/mtd/nand/bcm47xxnflash/ops_bcm4706.c
index e5b2e48658c4..652478035a7d 100644
--- a/drivers/mtd/nand/bcm47xxnflash/ops_bcm4706.c
+++ b/drivers/mtd/nand/bcm47xxnflash/ops_bcm4706.c
@@ -421,7 +421,7 @@ int bcm47xxnflash_ops_bcm4706_init(struct bcm47xxnflash *b47n)
 			(w4 << 24 | w3 << 18 | w2 << 12 | w1 << 6 | w0));
 
 	/* Scan NAND */
-	err = nand_scan(&b47n->mtd, 1);
+	err = nand_scan(nand_to_mtd(&b47n->nand_chip), 1);
 	if (err) {
 		pr_err("Could not scan NAND flash: %d\n", err);
 		goto exit;
-- 
2.6.0.rc2.230.g3dd15c0

