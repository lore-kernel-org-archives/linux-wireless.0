Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42349 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1HOQLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 12:11:46 -0400
Received: by fxh19 with SMTP id 19so3673111fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 09:11:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: LCN-PHY: basic PHY init
Date: Mon, 15 Aug 2011 18:50:55 +0200
Message-Id: <1313427056-3755-1-git-send-email-zajec5@gmail.com> (sfid-20110815_181153_749956_B1E503C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Sets were taken from:
 phy_read(0x044c) -> 0x0000
phy_write(0x044c) <- 0x0000
 phy_read(0x04b0) -> 0x0000
phy_write(0x04b0) <- 0x0000
 phy_read(0x04f9) -> 0x0000
phy_write(0x04f9) <- 0x0000

 phy_read(0x044a) -> 0x0000
phy_write(0x044a) <- 0x0080
 phy_read(0x044a) -> 0x0000
phy_write(0x044a) <- 0x0000
 phy_read(0x06d1) -> 0x0000
phy_write(0x06d1) <- 0x0080

Masks were taken from:
 phy_read(0x044c) -> 0xffff
phy_write(0x044c) <- 0xe0ff
 phy_read(0x04b0) -> 0xffff
phy_write(0x04b0) <- 0xf7f7
 phy_read(0x04f9) -> 0xffff
phy_write(0x04f9) <- 0xfff7

 phy_read(0x044a) -> 0xffff
phy_write(0x044a) <- 0xffff
 phy_read(0x044a) -> 0xffff
phy_write(0x044a) <- 0x007f
 phy_read(0x06d1) -> 0xffff
phy_write(0x06d1) <- 0xffff
---
 drivers/net/wireless/b43/phy_lcn.c |   74 +++++++++++++++++++++++++++++++++++-
 1 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 0fd72c1..604a3a6 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -28,6 +28,50 @@
 #include "main.h"
 
 /**************************************************
+ * Various PHY ops
+ **************************************************/
+
+static void b43_phy_lcn_afe_set_unset(struct b43_wldev *dev)
+{
+	u16 afe_ctl2 = b43_phy_read(dev, B43_PHY_LCN_AFE_CTL2);
+	u16 afe_ctl1 = b43_phy_read(dev, B43_PHY_LCN_AFE_CTL1);
+
+	b43_phy_write(dev, B43_PHY_LCN_AFE_CTL2, afe_ctl2 | 0x1);
+	b43_phy_write(dev, B43_PHY_LCN_AFE_CTL1, afe_ctl1 | 0x1);
+
+	b43_phy_write(dev, B43_PHY_LCN_AFE_CTL2, afe_ctl2 & ~0x1);
+	b43_phy_write(dev, B43_PHY_LCN_AFE_CTL1, afe_ctl1 & ~0x1);
+
+	b43_phy_write(dev, B43_PHY_LCN_AFE_CTL2, afe_ctl2);
+	b43_phy_write(dev, B43_PHY_LCN_AFE_CTL1, afe_ctl1);
+}
+
+static void b43_phy_lcn_clean_0x18_table(struct b43_wldev *dev)
+{
+	u8 i;
+
+	for (i = 0; i < 0x80; i++)
+		b43_lcntab_write(dev, B43_LCNTAB32(0x18, i), 0x80000);
+}
+
+static void b43_phy_lcn_clear_0x07_table(struct b43_wldev *dev)
+{
+	u8 i;
+
+	b43_phy_write(dev, B43_PHY_LCN_TABLE_ADDR, (0x7 << 10) | 0x340);
+	for (i = 0; i < 30; i++) {
+		b43_phy_write(dev, B43_PHY_LCN_TABLE_DATAHI, 0);
+		b43_phy_write(dev, B43_PHY_LCN_TABLE_DATALO, 0);
+	}
+
+	b43_phy_write(dev, B43_PHY_LCN_TABLE_ADDR, (0x7 << 10) | 0x80);
+	for (i = 0; i < 64; i++) {
+		b43_phy_write(dev, B43_PHY_LCN_TABLE_DATAHI, 0);
+		b43_phy_write(dev, B43_PHY_LCN_TABLE_DATALO, 0);
+	}
+}
+
+/**************************************************
  * Basic PHY ops.
  **************************************************/
 
@@ -60,6 +104,30 @@ static void b43_phy_lcn_op_prepare_structs(struct b43_wldev *dev)
 	memset(phy_lcn, 0, sizeof(*phy_lcn));
 }
 
+static int b43_phy_lcn_op_init(struct b43_wldev *dev)
+{
+	b43_phy_set(dev, 0x44a, 0x80);
+	b43_phy_mask(dev, 0x44a, 0x7f);
+	b43_phy_set(dev, 0x6d1, 0x80);
+	b43_phy_write(dev, 0x6d0, 0x7);
+
+	b43_phy_lcn_afe_set_unset(dev);
+
+	b43_phy_write(dev, 0x60a, 0xa0);
+	b43_phy_write(dev, 0x46a, 0x19);
+	b43_phy_maskset(dev, 0x663, 0xFF00, 0x64);
+
+	b43_phy_lcn_tables_init(dev);
+	/* TODO: various tables ops here */
+	b43_phy_lcn_clean_0x18_table(dev);
+
+	/* TODO: some ops here */
+
+	b43_phy_lcn_clear_0x07_table(dev);
+
+	return 0;
+}
+
 static void b43_phy_lcn_op_software_rfkill(struct b43_wldev *dev,
 					bool blocked)
 {
@@ -77,7 +145,9 @@ static void b43_phy_lcn_op_software_rfkill(struct b43_wldev *dev,
 		b43_phy_mask(dev, B43_PHY_LCN_RF_CTL7, ~0x8);
 		b43_phy_set(dev, B43_PHY_LCN_RF_CTL6, 0x8);
 	} else {
-		/* TODO */
+		b43_phy_mask(dev, B43_PHY_LCN_RF_CTL1, ~0x1f00);
+		b43_phy_mask(dev, B43_PHY_LCN_RF_CTL3, ~0x808);
+		b43_phy_mask(dev, B43_PHY_LCN_RF_CTL6, ~0x8);
 	}
 }
 
@@ -116,8 +186,8 @@ const struct b43_phy_operations b43_phyops_lcn = {
 	.allocate		= b43_phy_lcn_op_allocate,
 	.free			= b43_phy_lcn_op_free,
 	.prepare_structs	= b43_phy_lcn_op_prepare_structs,
-	/*
 	.init			= b43_phy_lcn_op_init,
+	/*
 	.phy_read		= b43_phy_lcn_op_read,
 	.phy_write		= b43_phy_lcn_op_write,
 	.phy_maskset		= b43_phy_lcn_op_maskset,
-- 
1.7.3.4

