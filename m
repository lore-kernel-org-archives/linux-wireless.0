Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41287 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933149AbeGIUKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 16:10:14 -0400
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
Subject: [PATCH v2 11/24] mtd: rawnand: sunxi: Make sure ret is initialized in sunxi_nfc_read_byte()
Date: Mon,  9 Jul 2018 22:09:32 +0200
Message-Id: <20180709200945.30116-12-boris.brezillon@bootlin.com> (sfid-20180709_221023_307703_FE397FA0)
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the following smatch warning:

drivers/mtd/nand/raw/sunxi_nand.c:551 sunxi_nfc_read_byte() error: uninitialized symbol 'ret'.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 99043c3a4fa7..4b11cd4a79be 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -544,7 +544,7 @@ static void sunxi_nfc_write_buf(struct mtd_info *mtd, const uint8_t *buf,
 
 static uint8_t sunxi_nfc_read_byte(struct mtd_info *mtd)
 {
-	uint8_t ret;
+	uint8_t ret = 0;
 
 	sunxi_nfc_read_buf(mtd, &ret, 1);
 
-- 
2.14.1
