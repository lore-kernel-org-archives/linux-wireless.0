Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49108 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1H1Lt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 07:49:28 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so3667747fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 04:49:28 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: LCN-PHY: implement more PHY ops before radio init
Date: Sun, 28 Aug 2011 14:28:44 +0200
Message-Id: <1314534525-4475-2-git-send-email-zajec5@gmail.com> (sfid-20110828_134942_978075_6BE4836C)
In-Reply-To: <1314534525-4475-1-git-send-email-zajec5@gmail.com>
References: <1314534525-4475-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c |   56 ++++++++++++++++++++++++++++++++++--
 1 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index cf75d3d..9707a2b 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -48,7 +48,7 @@ static void b43_radio_2064_init(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x4ea, 0x4688);
 	b43_phy_maskset(dev, 0x4eb, ~0x7, 0x2);
 	b43_phy_mask(dev, 0x4eb, ~0x01c0);
-	b43_phy_maskset(dev, 0x4eb, 0xff00, 0x19);
+	b43_phy_maskset(dev, 0x46a, 0xff00, 0x19);
 
 	b43_lcntab_write(dev, B43_LCNTAB16(0x00, 0x55), 0);
 
@@ -120,6 +120,57 @@ static void b43_phy_lcn_clear_0x07_table(struct b43_wldev *dev)
 	}
 }
 
+static void b43_phy_lcn_pre_radio_init(struct b43_wldev *dev)
+{
+	b43_radio_write(dev, 0x11c, 0);
+
+	b43_phy_write(dev, 0x43b, 0);
+	b43_phy_write(dev, 0x43c, 0);
+	b43_phy_write(dev, 0x44c, 0);
+	b43_phy_write(dev, 0x4e6, 0);
+	b43_phy_write(dev, 0x4f9, 0);
+	b43_phy_write(dev, 0x4b0, 0);
+	b43_phy_write(dev, 0x938, 0);
+	b43_phy_write(dev, 0x4b0, 0);
+	b43_phy_write(dev, 0x44e, 0);
+
+	b43_phy_set(dev, 0x567, 0x03);
+
+	b43_phy_set(dev, 0x44a, 0x44);
+	b43_phy_write(dev, 0x44a, 0x80);
+
+	b43_phy_maskset(dev, 0x634, ~0xff, 0xc);
+	b43_phy_maskset(dev, 0x634, ~0xff, 0xa);
+
+	b43_phy_write(dev, 0x910, 0x1);
+
+	b43_phy_maskset(dev, 0x448, ~0x300, 0x100);
+	b43_phy_maskset(dev, 0x608, ~0xff, 0x17);
+	b43_phy_maskset(dev, 0x604, ~0x7ff, 0x3ea);
+
+	b43_phy_set(dev, 0x805, 0x1);
+
+	b43_phy_maskset(dev, 0x42f, ~0x7, 0x3);
+	b43_phy_maskset(dev, 0x030, ~0x7, 0x3);
+
+	b43_phy_write(dev, 0x414, 0x1e10);
+	b43_phy_write(dev, 0x415, 0x0640);
+
+	b43_phy_maskset(dev, 0x4df, (u16) ~0xff00, 0xf700);
+
+	b43_phy_set(dev, 0x44a, 0x44);
+	b43_phy_write(dev, 0x44a, 0x80);
+
+	b43_phy_maskset(dev, 0x434, ~0xff, 0xfd);
+	b43_phy_maskset(dev, 0x420, ~0xff, 0x10);
+
+	b43_radio_set(dev, 0x09b, 0xf0);
+
+	b43_phy_write(dev, 0x7d6, 0x0902);
+
+	/* TODO: more ops */
+}
+
 /**************************************************
  * Basic PHY ops.
  **************************************************/
@@ -170,8 +221,7 @@ static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 	/* TODO: various tables ops here */
 	b43_phy_lcn_clean_0x18_table(dev);
 
-	/* TODO: some ops here */
-
+	b43_phy_lcn_pre_radio_init(dev);
 	b43_phy_lcn_clear_0x07_table(dev);
 
 	if (dev->phy.radio_ver == 0x2064)
-- 
1.7.3.4

