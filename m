Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45505 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab0LIT4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 14:56:22 -0500
Received: by wwa36 with SMTP id 36so2856888wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 11:56:20 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: N-PHY: use designed function and macro for writing tables
Date: Thu,  9 Dec 2010 20:56:00 +0100
Message-Id: <1291924561-21630-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291924561-21630-1-git-send-email-zajec5@gmail.com>
References: <1291924561-21630-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   31 ++++++++++---------------------
 1 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e12f399..a1aa570 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1209,29 +1209,18 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 			b43_radio_set(dev, B2055_C2_TX_RF_SPARE, 0x8);
 		}
 
-		/* TODO: convert to b43_ntab_write? */
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2000);
-		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x000A);
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2010);
-		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x000A);
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2002);
-		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0xCDAA);
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2012);
-		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0xCDAA);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x00), 0x000A);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x10), 0x000A);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x02), 0xCDAA);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x12), 0xCDAA);
 
 		if (dev->phy.rev < 2) {
-			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2008);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0000);
-			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2018);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0000);
-			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2007);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x7AAB);
-			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2017);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x7AAB);
-			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2006);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0800);
-			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2016);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0800);
+			b43_ntab_write(dev, B43_NTAB16(8, 0x08), 0x0000);
+			b43_ntab_write(dev, B43_NTAB16(8, 0x18), 0x0000);
+			b43_ntab_write(dev, B43_NTAB16(8, 0x07), 0x7AAB);
+			b43_ntab_write(dev, B43_NTAB16(8, 0x17), 0x7AAB);
+			b43_ntab_write(dev, B43_NTAB16(8, 0x06), 0x0800);
+			b43_ntab_write(dev, B43_NTAB16(8, 0x16), 0x0800);
 		}
 
 		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
-- 
1.6.3.3

