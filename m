Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41295 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933169AbeGIUKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
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
Subject: [PATCH v2 10/24] mtd: rawnand: sunxi: Add an U suffix to NFC_PAGE_OP definition
Date: Mon,  9 Jul 2018 22:09:31 +0200
Message-Id: <20180709200945.30116-11-boris.brezillon@bootlin.com> (sfid-20180709_221019_568317_E396049D)
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the "warning: large integer implicitly truncated to unsigned type
[-Woverflow]" warning when compiled for x86.

This is needed in order to allow compiling this driver when
COMPILE_TEST=y.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index d831a141a196..99043c3a4fa7 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -127,7 +127,7 @@
 #define NFC_CMD_TYPE_MSK	GENMASK(31, 30)
 #define NFC_NORMAL_OP		(0 << 30)
 #define NFC_ECC_OP		(1 << 30)
-#define NFC_PAGE_OP		(2 << 30)
+#define NFC_PAGE_OP		(2U << 30)
 
 /* define bit use in NFC_RCMD_SET */
 #define NFC_READ_CMD_MSK	GENMASK(7, 0)
-- 
2.14.1
