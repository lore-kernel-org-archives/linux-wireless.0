Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51756 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2ILUxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 16:53:40 -0400
Received: by wgbdr13 with SMTP id dr13so1847316wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2012 13:53:39 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: export PLL reading function
Date: Wed, 12 Sep 2012 22:53:36 +0200
Message-Id: <1347483216-2309-1-git-send-email-zajec5@gmail.com> (sfid-20120912_225344_301869_1AE6099F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required by NAND flash driver for initializing wait counters.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
To see usage, take a look at
[PATCH 2/4] mtd: bcm47xxnflash: init NAND on BCM4706
(it is ML posted patch only, not included in any tree yet)
---
 drivers/bcma/driver_chipcommon_pmu.c |    3 ++-
 include/linux/bcma/bcma.h            |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 8b8f2f3..c7d94b47 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -13,12 +13,13 @@
 #include <linux/export.h>
 #include <linux/bcma/bcma.h>
 
-static u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
+u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
 {
 	bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR, offset);
 	bcma_cc_read32(cc, BCMA_CC_PLLCTL_ADDR);
 	return bcma_cc_read32(cc, BCMA_CC_PLLCTL_DATA);
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_pll_read);
 
 void bcma_chipco_pll_write(struct bcma_drv_cc *cc, u32 offset, u32 value)
 {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 1954a4e..b58fae0 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -345,6 +345,7 @@ extern void bcma_core_set_clockmode(struct bcma_device *core,
 				    enum bcma_clkmode clkmode);
 extern void bcma_core_pll_ctl(struct bcma_device *core, u32 req, u32 status,
 			      bool on);
+extern u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset);
 #define BCMA_DMA_TRANSLATION_MASK	0xC0000000
 #define  BCMA_DMA_TRANSLATION_NONE	0x00000000
 #define  BCMA_DMA_TRANSLATION_DMA32_CMT	0x40000000 /* Client Mode Translation for 32-bit DMA */
-- 
1.7.7

