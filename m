Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35896 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbcGHPOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 11:14:31 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM SPECIFIC AMBA DRIVER
	(BCMA)), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V2] bcma: define ChipCommon B MII registers
Date: Fri,  8 Jul 2016 17:14:18 +0200
Message-Id: <1467990860-10663-1-git-send-email-zajec5@gmail.com> (sfid-20160708_171435_221004_95F536AD)
In-Reply-To: <1467970091-8308-1-git-send-email-zajec5@gmail.com>
References: <1467970091-8308-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't have access to datasheets to document all the bits but we can
name these registers at least.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Fix mistake in V1 that used BCMA_CCB_MII_MNG_CMD_DATA instead of
    BCMA_CCB_MII_MNG_CTL in the second bcma_wait_reg call.
---
 drivers/bcma/driver_chipcommon_b.c          | 9 +++++----
 include/linux/bcma/bcma_driver_chipcommon.h | 3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_b.c b/drivers/bcma/driver_chipcommon_b.c
index c20b5f4..57f10b5 100644
--- a/drivers/bcma/driver_chipcommon_b.c
+++ b/drivers/bcma/driver_chipcommon_b.c
@@ -33,11 +33,12 @@ static bool bcma_wait_reg(struct bcma_bus *bus, void __iomem *addr, u32 mask,
 void bcma_chipco_b_mii_write(struct bcma_drv_cc_b *ccb, u32 offset, u32 value)
 {
 	struct bcma_bus *bus = ccb->core->bus;
+	void __iomem *mii = ccb->mii;
 
-	writel(offset, ccb->mii + 0x00);
-	bcma_wait_reg(bus, ccb->mii + 0x00, 0x0100, 0x0000, 100);
-	writel(value, ccb->mii + 0x04);
-	bcma_wait_reg(bus, ccb->mii + 0x00, 0x0100, 0x0000, 100);
+	writel(offset, mii + BCMA_CCB_MII_MNG_CTL);
+	bcma_wait_reg(bus, mii + BCMA_CCB_MII_MNG_CTL, 0x0100, 0x0000, 100);
+	writel(value, mii + BCMA_CCB_MII_MNG_CMD_DATA);
+	bcma_wait_reg(bus, mii + BCMA_CCB_MII_MNG_CTL, 0x0100, 0x0000, 100);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_b_mii_write);
 
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index a5ac2ca..b20e3d5 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -504,6 +504,9 @@
 #define BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_MASK	0x1ff00000
 #define BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_SHIFT	20
 
+#define BCMA_CCB_MII_MNG_CTL		0x0000
+#define BCMA_CCB_MII_MNG_CMD_DATA	0x0004
+
 /* BCM4331 ChipControl numbers. */
 #define BCMA_CHIPCTL_4331_BT_COEXIST		BIT(0)	/* 0 disable */
 #define BCMA_CHIPCTL_4331_SECI			BIT(1)	/* 0 SECI is disabled (JATG functional) */
-- 
1.8.4.5

