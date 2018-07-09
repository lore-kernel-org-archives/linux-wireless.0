Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41357 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933335AbeGIUKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
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
Subject: [PATCH v2 21/24] MIPS: jz4740: Move jz4740_nand.h header to include/linux/platform_data/jz4740
Date: Mon,  9 Jul 2018 22:09:42 +0200
Message-Id: <20180709200945.30116-22-boris.brezillon@bootlin.com> (sfid-20180709_221036_565328_264796C7)
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This way we will be able to compile the jz4740_nand driver when
COMPILE_TEST=y.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 arch/mips/jz4740/board-qi_lb60.c                                      | 3 ++-
 drivers/mtd/nand/raw/jz4740_nand.c                                    | 2 +-
 .../mach-jz4740 => include/linux/platform_data/jz4740}/jz4740_nand.h  | 4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)
 rename {arch/mips/include/asm/mach-jz4740 => include/linux/platform_data/jz4740}/jz4740_nand.h (91%)

diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index 60f0767507c6..af0c8ace0141 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -29,10 +29,11 @@
 #include <linux/power/gpio-charger.h>
 #include <linux/pwm.h>
 
+#include <linux/platform_data/jz4740/jz4740_nand.h>
+
 #include <asm/mach-jz4740/gpio.h>
 #include <asm/mach-jz4740/jz4740_fb.h>
 #include <asm/mach-jz4740/jz4740_mmc.h>
-#include <asm/mach-jz4740/jz4740_nand.h>
 
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
diff --git a/drivers/mtd/nand/raw/jz4740_nand.c b/drivers/mtd/nand/raw/jz4740_nand.c
index 613b00a9604b..a0254461812d 100644
--- a/drivers/mtd/nand/raw/jz4740_nand.c
+++ b/drivers/mtd/nand/raw/jz4740_nand.c
@@ -25,7 +25,7 @@
 
 #include <linux/gpio.h>
 
-#include <asm/mach-jz4740/jz4740_nand.h>
+#include <linux/platform_data/jz4740/jz4740_nand.h>
 
 #define JZ_REG_NAND_CTRL	0x50
 #define JZ_REG_NAND_ECC_CTRL	0x100
diff --git a/arch/mips/include/asm/mach-jz4740/jz4740_nand.h b/include/linux/platform_data/jz4740/jz4740_nand.h
similarity index 91%
rename from arch/mips/include/asm/mach-jz4740/jz4740_nand.h
rename to include/linux/platform_data/jz4740/jz4740_nand.h
index f381d465e768..bc571f6d5ced 100644
--- a/arch/mips/include/asm/mach-jz4740/jz4740_nand.h
+++ b/include/linux/platform_data/jz4740/jz4740_nand.h
@@ -13,8 +13,8 @@
  *
  */
 
-#ifndef __ASM_MACH_JZ4740_JZ4740_NAND_H__
-#define __ASM_MACH_JZ4740_JZ4740_NAND_H__
+#ifndef __JZ4740_NAND_H__
+#define __JZ4740_NAND_H__
 
 #include <linux/mtd/rawnand.h>
 #include <linux/mtd/partitions.h>
-- 
2.14.1
