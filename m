Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41311 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933314AbeGIUKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 16:10:15 -0400
From: Boris Brezillon <boris.brezillon@bootlin.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 14/24] mtd: rawnand: fsmc: Use uintptr_t casts instead of unsigned ones
Date: Mon,  9 Jul 2018 22:09:35 +0200
Message-Id: <20180709200945.30116-15-boris.brezillon@bootlin.com> (sfid-20180709_221021_308269_D174929E)
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

uintptr_t should be used when casting a pointer to an unsigned int so
that the code compiles without warnings even on 64-bit architectures.

This is needed if we want to allow selection of this driver when
COMPILE_TEST=y.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/fsmc_nand.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/fsmc_nand.c b/drivers/mtd/nand/raw/fsmc_nand.c
index d71c49f50e77..527bebc7e6c9 100644
--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -547,7 +547,7 @@ static void fsmc_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
 	struct fsmc_nand_data *host  = mtd_to_fsmc(mtd);
 	int i;
 
-	if (IS_ALIGNED((uint32_t)buf, sizeof(uint32_t)) &&
+	if (IS_ALIGNED((uintptr_t)buf, sizeof(uint32_t)) &&
 			IS_ALIGNED(len, sizeof(uint32_t))) {
 		uint32_t *p = (uint32_t *)buf;
 		len = len >> 2;
@@ -570,7 +570,7 @@ static void fsmc_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
 	struct fsmc_nand_data *host  = mtd_to_fsmc(mtd);
 	int i;
 
-	if (IS_ALIGNED((uint32_t)buf, sizeof(uint32_t)) &&
+	if (IS_ALIGNED((uintptr_t)buf, sizeof(uint32_t)) &&
 			IS_ALIGNED(len, sizeof(uint32_t))) {
 		uint32_t *p = (uint32_t *)buf;
 		len = len >> 2;
-- 
2.14.1
