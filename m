Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39281 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab1HaVeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 17:34:17 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so788832ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:34:16 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/6] b43: LCN-PHY: rewrite 0x7 table at the end of init
Date: Wed, 31 Aug 2011 23:36:18 +0200
Message-Id: <1314826581-27852-3-git-send-email-zajec5@gmail.com> (sfid-20110831_233428_195701_AD749D6E)
In-Reply-To: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
References: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not implemented in brcmsmac, but was noticed in (newer) wl. Can
be workaround for some hardware bug.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_phy_lcn.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
index f74c00a..95efea6 100644
--- a/drivers/net/wireless/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -463,6 +463,17 @@ static void b43_phy_lcn_upload_static_tables(struct b43_wldev *dev)
 	lcntab_upload(dev, B43_LCNTAB32(0x18, 0), b43_lcntab_0x18);
 }
 
+/* Not implemented in brcmsmac, noticed in wl in MMIO dump */
+static void b43_phy_lcn_rewrite_tables(struct b43_wldev *dev)
+{
+	int i;
+	u32 tmp;
+	for (i = 0; i < 128; i++) {
+		tmp = b43_lcntab_read(dev, B43_LCNTAB32(0x7, 0x240 + i));
+		b43_lcntab_write(dev, B43_LCNTAB32(0x7, 0x240 + i), tmp);
+	}
+}
+
 static void b43_phy_lcn_clean_0x18_table(struct b43_wldev *dev)
 {
 	u8 i;
@@ -475,5 +486,6 @@ void b43_phy_lcn_tables_init(struct b43_wldev *dev)
 {
 	b43_phy_lcn_upload_static_tables(dev);
 	/* TODO: various tables ops here */
+	b43_phy_lcn_rewrite_tables(dev);
 	b43_phy_lcn_clean_0x18_table(dev);
 }
-- 
1.7.3.4

