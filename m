Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50085 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300Ab0KRUKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 15:10:54 -0500
Received: by ewy5 with SMTP id 5so32028ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 12:10:53 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: N-PHY: fix BPHY init
Date: Thu, 18 Nov 2010 21:11:41 +0100
Message-Id: <1290111103-19308-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 2c60793..ff0c2b9 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1579,13 +1579,13 @@ static void b43_nphy_bphy_init(struct b43_wldev *dev)
 	u16 val;
 
 	val = 0x1E1F;
-	for (i = 0; i < 14; i++) {
+	for (i = 0; i < 16; i++) {
 		b43_phy_write(dev, B43_PHY_N_BMODE(0x88 + i), val);
 		val -= 0x202;
 	}
 	val = 0x3E3F;
 	for (i = 0; i < 16; i++) {
-		b43_phy_write(dev, B43_PHY_N_BMODE(0x97 + i), val);
+		b43_phy_write(dev, B43_PHY_N_BMODE(0x98 + i), val);
 		val -= 0x202;
 	}
 	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
-- 
1.7.1

