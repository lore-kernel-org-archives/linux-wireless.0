Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41359 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933340AbeGIUKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 16:10:16 -0400
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
Subject: [PATCH v2 23/24] mtd: rawnand: jz4780: Drop the dependency on MACH_JZ4780
Date: Mon,  9 Jul 2018 22:09:44 +0200
Message-Id: <20180709200945.30116-24-boris.brezillon@bootlin.com> (sfid-20180709_221038_551576_48465C2C)
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This MACH_JZ4780 dependency is taken care of by JZ4780_NEMC, no need
to repeat it here.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 7b5e97719c25..d9cd9608bc2d 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -499,7 +499,7 @@ config MTD_NAND_JZ4740
 
 config MTD_NAND_JZ4780
 	tristate "Support for NAND on JZ4780 SoC"
-	depends on MACH_JZ4780 && JZ4780_NEMC
+	depends on JZ4780_NEMC
 	help
 	  Enables support for NAND Flash connected to the NEMC on JZ4780 SoC
 	  based boards, using the BCH controller for hardware error correction.
-- 
2.14.1
