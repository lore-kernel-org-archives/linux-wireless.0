Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56900 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1HaVeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 17:34:22 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so1223358eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:34:21 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/6] b43: LCN-PHY: upload additional 0x7 table
Date: Wed, 31 Aug 2011 23:36:19 +0200
Message-Id: <1314826581-27852-4-git-send-email-zajec5@gmail.com> (sfid-20110831_233428_723853_0D369C17)
In-Reply-To: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
References: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_phy_lcn.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
index 95efea6..fd2b16d 100644
--- a/drivers/net/wireless/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -295,6 +295,20 @@ static const u32 b43_lcntab_0x18[] = {
 	0x00080000, 0x00080000, 0x00080000, 0x00080000,
 };
 
+const u16 b43_lcntab_0x0f_late[] = {
+	0x0002, 0x0008, 0x0004, 0x0001, 0x0002, 0x0008,
+	0x0004, 0x0001, 0x0002, 0x0008, 0x0004, 0x0001,
+	0x0002, 0x0008, 0x0004, 0x0001, 0x0002, 0x0008,
+	0x0004, 0x0001, 0x0002, 0x0008, 0x0004, 0x0001,
+	0x0002, 0x0008, 0x0004, 0x0001, 0x0002, 0x0008,
+	0x0004, 0x0001, 0x0002, 0x0008, 0x0004, 0x0001,
+	0x0002, 0x0008, 0x0004, 0x0001, 0x0002, 0x0008,
+	0x0004, 0x0001, 0x0002, 0x0008, 0x0004, 0x0001,
+	0x0002, 0x0008, 0x0004, 0x0001, 0x0002, 0x0008,
+	0x0004, 0x0001, 0x0002, 0x0008, 0x0004, 0x0001,
+	0x0002, 0x0008, 0x0004, 0x0001,
+};
+
 /**************************************************
  * R/W ops.
  **************************************************/
@@ -486,6 +500,9 @@ void b43_phy_lcn_tables_init(struct b43_wldev *dev)
 {
 	b43_phy_lcn_upload_static_tables(dev);
 	/* TODO: various tables ops here */
+	b43_lcntab_write_bulk(dev, B43_LCNTAB16(0xf, 0),
+			ARRAY_SIZE(b43_lcntab_0x0f_late), b43_lcntab_0x0f_late);
+	/* TODO: various tables ops here */
 	b43_phy_lcn_rewrite_tables(dev);
 	b43_phy_lcn_clean_0x18_table(dev);
 }
-- 
1.7.3.4

