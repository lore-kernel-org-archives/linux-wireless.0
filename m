Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39281 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab1HaVeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 17:34:12 -0400
Received: by ewy4 with SMTP id 4so788832ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:34:11 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/6] b43: LCN-PHY: put tables functions in correct file
Date: Wed, 31 Aug 2011 23:36:17 +0200
Message-Id: <1314826581-27852-2-git-send-email-zajec5@gmail.com> (sfid-20110831_233416_959060_531FDAFB)
In-Reply-To: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
References: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c        |   10 ----------
 drivers/net/wireless/b43/tables_phy_lcn.c |   17 ++++++++++++++++-
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index b617e1f..9e57577 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -137,14 +137,6 @@ static void b43_phy_lcn_afe_set_unset(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_LCN_AFE_CTL1, afe_ctl1);
 }
 
-static void b43_phy_lcn_clean_0x18_table(struct b43_wldev *dev)
-{
-	u8 i;
-
-	for (i = 0; i < 0x80; i++)
-		b43_lcntab_write(dev, B43_LCNTAB32(0x18, i), 0x80000);
-}
-
 static void b43_phy_lcn_clear_0x07_table(struct b43_wldev *dev)
 {
 	u8 i;
@@ -319,8 +311,6 @@ static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, 0x663, 0xFF00, 0x64);
 
 	b43_phy_lcn_tables_init(dev);
-	/* TODO: various tables ops here */
-	b43_phy_lcn_clean_0x18_table(dev);
 
 	b43_phy_lcn_pre_radio_init(dev);
 	b43_phy_lcn_clear_0x07_table(dev);
diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
index 916d3f1..f74c00a 100644
--- a/drivers/net/wireless/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -445,7 +445,7 @@ void b43_lcntab_write_bulk(struct b43_wldev *dev, u32 offset,
 #define lcntab_upload(dev, offset, data) do { \
 		b43_lcntab_write_bulk(dev, offset, ARRAY_SIZE(data), data); \
 	} while (0)
-void b43_phy_lcn_tables_init(struct b43_wldev *dev)
+static void b43_phy_lcn_upload_static_tables(struct b43_wldev *dev)
 {
 	lcntab_upload(dev, B43_LCNTAB16(0x02, 0), b43_lcntab_0x02);
 	lcntab_upload(dev, B43_LCNTAB16(0x01, 0), b43_lcntab_0x01);
@@ -462,3 +462,18 @@ void b43_phy_lcn_tables_init(struct b43_wldev *dev)
 	lcntab_upload(dev, B43_LCNTAB16(0x00, 0), b43_lcntab_0x00);
 	lcntab_upload(dev, B43_LCNTAB32(0x18, 0), b43_lcntab_0x18);
 }
+
+static void b43_phy_lcn_clean_0x18_table(struct b43_wldev *dev)
+{
+	u8 i;
+
+	for (i = 0; i < 0x80; i++)
+		b43_lcntab_write(dev, B43_LCNTAB32(0x18, i), 0x80000);
+}
+
+void b43_phy_lcn_tables_init(struct b43_wldev *dev)
+{
+	b43_phy_lcn_upload_static_tables(dev);
+	/* TODO: various tables ops here */
+	b43_phy_lcn_clean_0x18_table(dev);
+}
-- 
1.7.3.4

