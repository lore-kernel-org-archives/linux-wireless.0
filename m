Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33596 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab0KRM0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 07:26:54 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so1855656eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 04:26:54 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: N-PHY: minor fixes to match specs
Date: Thu, 18 Nov 2010 13:27:58 +0100
Message-Id: <1290083280-13550-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290083280-13550-1-git-send-email-zajec5@gmail.com>
References: <1290083280-13550-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6facb8a..e1d02f9 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -875,7 +875,7 @@ static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 			data[2] = lna_gain[2] + gain[i];
 			data[3] = lna_gain[3] + gain[i];
 		}
-		b43_ntab_write_bulk(dev, B43_NTAB16(10, 8), 4, data);
+		b43_ntab_write_bulk(dev, B43_NTAB16(i, 8), 4, data);
 
 		minmax[i] = 23 + gain[i];
 	}
@@ -895,6 +895,7 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 	struct b43_phy_n *nphy = dev->phy.n;
 	u8 i, j;
 	u8 code;
+	u16 tmp;
 
 	/* TODO: for PHY >= 3
 	s8 *lna1_gain, *lna2_gain;
@@ -999,9 +1000,11 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 			for (i = 0; i < 4; i++) {
 				b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
 						(0x0400 * i) + 0x0020);
-				for (j = 0; j < 21; j++)
+				for (j = 0; j < 21; j++) {
+					tmp = j * (i < 2 ? 3 : 1);
 					b43_phy_write(dev,
-						B43_NPHY_TABLE_DATALO, 3 * j);
+						B43_NPHY_TABLE_DATALO, tmp);
+				}
 			}
 
 			b43_nphy_set_rf_sequence(dev, 5,
-- 
1.7.1

