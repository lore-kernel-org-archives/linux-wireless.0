Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1IPKbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 06:31:06 -0400
Received: by fxe4 with SMTP id 4so1527867fxe.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 03:31:05 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/6] bcma: cc: export more control functions
Date: Fri, 16 Sep 2011 12:33:58 +0200
Message-Id: <1316169243-8808-1-git-send-email-zajec5@gmail.com> (sfid-20110916_123116_456124_69F6B612)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_pmu.c        |   38 ++++++++++++++++++++------
 include/linux/bcma/bcma_driver_chipcommon.h |    9 ++++++
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 4bc10aa..2968d80 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -18,20 +18,40 @@ static u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
 	return bcma_cc_read32(cc, BCMA_CC_PLLCTL_DATA);
 }
 
-static void bcma_chipco_chipctl_maskset(struct bcma_drv_cc *cc,
-					u32 offset, u32 mask, u32 set)
+void bcma_chipco_pll_write(struct bcma_drv_cc *cc, u32 offset, u32 value)
 {
-	u32 value;
+	bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR, offset);
+	bcma_cc_read32(cc, BCMA_CC_PLLCTL_ADDR);
+	bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, value);
+}
+EXPORT_SYMBOL_GPL(bcma_chipco_pll_write);
 
-	bcma_cc_read32(cc, BCMA_CC_CHIPCTL_ADDR);
+void bcma_chipco_pll_maskset(struct bcma_drv_cc *cc, u32 offset, u32 mask,
+			     u32 set)
+{
+	bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR, offset);
+	bcma_cc_read32(cc, BCMA_CC_PLLCTL_ADDR);
+	bcma_cc_maskset32(cc, BCMA_CC_PLLCTL_DATA, mask, set);
+}
+EXPORT_SYMBOL_GPL(bcma_chipco_pll_maskset);
+
+void bcma_chipco_chipctl_maskset(struct bcma_drv_cc *cc,
+				 u32 offset, u32 mask, u32 set)
+{
 	bcma_cc_write32(cc, BCMA_CC_CHIPCTL_ADDR, offset);
 	bcma_cc_read32(cc, BCMA_CC_CHIPCTL_ADDR);
-	value = bcma_cc_read32(cc, BCMA_CC_CHIPCTL_DATA);
-	value &= mask;
-	value |= set;
-	bcma_cc_write32(cc, BCMA_CC_CHIPCTL_DATA, value);
-	bcma_cc_read32(cc, BCMA_CC_CHIPCTL_DATA);
+	bcma_cc_maskset32(cc, BCMA_CC_CHIPCTL_DATA, mask, set);
+}
+EXPORT_SYMBOL_GPL(bcma_chipco_chipctl_maskset);
+
+void bcma_chipco_regctl_maskset(struct bcma_drv_cc *cc, u32 offset, u32 mask,
+				u32 set)
+{
+	bcma_cc_write32(cc, BCMA_CC_REGCTL_ADDR, offset);
+	bcma_cc_read32(cc, BCMA_CC_REGCTL_ADDR);
+	bcma_cc_maskset32(cc, BCMA_CC_REGCTL_DATA, mask, set);
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_regctl_maskset);
 
 static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
 {
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index a7ae33d..1526d96 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -378,4 +378,13 @@ u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value);
 /* PMU support */
 extern void bcma_pmu_init(struct bcma_drv_cc *cc);
 
+extern void bcma_chipco_pll_write(struct bcma_drv_cc *cc, u32 offset,
+				  u32 value);
+extern void bcma_chipco_pll_maskset(struct bcma_drv_cc *cc, u32 offset,
+				    u32 mask, u32 set);
+extern void bcma_chipco_chipctl_maskset(struct bcma_drv_cc *cc,
+					u32 offset, u32 mask, u32 set);
+extern void bcma_chipco_regctl_maskset(struct bcma_drv_cc *cc,
+				       u32 offset, u32 mask, u32 set);
+
 #endif /* LINUX_BCMA_DRIVER_CC_H_ */
-- 
1.7.3.4

