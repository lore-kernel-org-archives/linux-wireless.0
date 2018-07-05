Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43488 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753384AbeGEJpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:45:46 -0400
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
        linux-wireless@vger.kernel.org
Subject: [PATCH 06/27] mtd: rawnand: sharpsl: Remove inclusion of mach and asm headers
Date: Thu,  5 Jul 2018 11:45:01 +0200
Message-Id: <20180705094522.12138-7-boris.brezillon@bootlin.com> (sfid-20180705_114558_556602_BC747EA7)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need mach/hardware.h and sm/mach-types.h, and asm/io.h can be
replaced by linux/io.h.

Now that we removed those inclusions, we're ready to allow selection of
this driver when COMPILE_TEST=y.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/sharpsl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/sharpsl.c b/drivers/mtd/nand/raw/sharpsl.c
index e93df02c825e..fc171b17a39b 100644
--- a/drivers/mtd/nand/raw/sharpsl.c
+++ b/drivers/mtd/nand/raw/sharpsl.c
@@ -21,10 +21,7 @@
 #include <linux/mtd/sharpsl.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-
-#include <asm/io.h>
-#include <mach/hardware.h>
-#include <asm/mach-types.h>
+#include <linux/io.h>
 
 struct sharpsl_nand {
 	struct nand_chip	chip;
-- 
2.14.1
