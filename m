Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41842 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1HMPO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 11:14:56 -0400
Received: by fxh19 with SMTP id 19so2833987fxh.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 08:14:55 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: HT-PHY: init: add missing small-tables writes
Date: Sat, 13 Aug 2011 17:54:04 +0200
Message-Id: <1313250844-4526-1-git-send-email-zajec5@gmail.com> (sfid-20110813_171504_065689_3876A790)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: this one depends on
[RFC][PATCH] b43: HT-PHY: allow writing longer tables with a single call
, please apply the one above.
---
 drivers/net/wireless/b43/phy_ht.c |   33 ++++++++++++++++++++++++++++++---
 1 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 80c448d..81c8656 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -352,18 +352,45 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	b43_phy_write(dev, 0x0b9, 0x0072);
 
-	/* TODO: Some ops here */
+	b43_httab_write_few(dev, B43_HTTAB16(7, 0x14e), 2, 0x010f, 0x010f);
+	b43_httab_write_few(dev, B43_HTTAB16(7, 0x15e), 2, 0x010f, 0x010f);
+	b43_httab_write_few(dev, B43_HTTAB16(7, 0x16e), 2, 0x010f, 0x010f);
 
 	b43_phy_ht_afe_unk1(dev);
 
-	/* TODO: Some ops here */
+	b43_httab_write_few(dev, B43_HTTAB16(7, 0x130), 9, 0x777, 0x111, 0x111,
+			    0x777, 0x111, 0x111, 0x777, 0x111, 0x111);
+
+	b43_httab_write(dev, B43_HTTAB16(7, 0x120), 0x0777);
+	b43_httab_write(dev, B43_HTTAB16(7, 0x124), 0x0777);
+
+	b43_httab_write(dev, B43_HTTAB16(8, 0x00), 0x02);
+	b43_httab_write(dev, B43_HTTAB16(8, 0x10), 0x02);
+	b43_httab_write(dev, B43_HTTAB16(8, 0x20), 0x02);
+
+	b43_httab_write_few(dev, B43_HTTAB16(8, 0x08), 4,
+			    0x8e, 0x96, 0x96, 0x96);
+	b43_httab_write_few(dev, B43_HTTAB16(8, 0x18), 4,
+			    0x8f, 0x9f, 0x9f, 0x9f);
+	b43_httab_write_few(dev, B43_HTTAB16(8, 0x28), 4,
+			    0x8f, 0x9f, 0x9f, 0x9f);
+
+	b43_httab_write_few(dev, B43_HTTAB16(8, 0x0c), 4, 0x2, 0x2, 0x2, 0x2);
+	b43_httab_write_few(dev, B43_HTTAB16(8, 0x1c), 4, 0x2, 0x2, 0x2, 0x2);
+	b43_httab_write_few(dev, B43_HTTAB16(8, 0x2c), 4, 0x2, 0x2, 0x2, 0x2);
 
 	b43_phy_maskset(dev, 0x0280, 0xff00, 0x3e);
 	b43_phy_maskset(dev, 0x0283, 0xff00, 0x3e);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x0141), 0xff00, 0x46);
 	b43_phy_maskset(dev, 0x0283, 0xff00, 0x40);
 
-	/* TODO: Some ops here */
+	b43_httab_write_few(dev, B43_HTTAB16(00, 0x8), 4,
+			    0x09, 0x0e, 0x13, 0x18);
+	b43_httab_write_few(dev, B43_HTTAB16(01, 0x8), 4,
+			    0x09, 0x0e, 0x13, 0x18);
+	/* TODO: Did wl mean 2 instead of 40? */
+	b43_httab_write_few(dev, B43_HTTAB16(40, 0x8), 4,
+			    0x09, 0x0e, 0x13, 0x18);
 
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x24), 0x3f, 0xd);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x64), 0x3f, 0xd);
-- 
1.7.3.4

