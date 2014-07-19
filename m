Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61691 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761229AbaGSKxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 06:53:18 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so1941281wiw.12
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 03:53:17 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 6/7] b43: N-PHY: final fixes to rev7+ workarounds
Date: Sat, 19 Jul 2014 12:52:46 +0200
Message-Id: <1405767167-30315-6-git-send-email-zajec5@gmail.com> (sfid-20140719_125321_987869_19011FA5)
In-Reply-To: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
References: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1052540..11d7543 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2729,6 +2729,8 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 
 	u16 bias, conv, filt;
 
+	u32 noise_tbl[2];
+
 	u32 tmp32;
 	u8 core;
 
@@ -2955,9 +2957,10 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 			b43_ntab_write(dev, B43_NTAB16(7, 0x159 + core * 16),
 				       rx2tx_lut_40_11n[core]);
 		}
-		b43_nphy_rf_ctl_override_rev7(dev, 16, 1, 3, false, 2);
 	}
+
 	b43_phy_write(dev, 0x32F, 0x3);
+
 	if (phy->radio_rev == 4 || phy->radio_rev == 6)
 		b43_nphy_rf_ctl_override_rev7(dev, 4, 1, 3, false, 0);
 
@@ -3104,8 +3107,8 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 		b43_phy_set(dev, B43_NPHY_AFECTL_OVER1, 0x1);
 		b43_phy_mask(dev, B43_NPHY_AFECTL_C2, ~0x1);
 		b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x1);
-		b43_ntab_write(dev, B43_NTAB16(8, 0x05), 0x20);
-		b43_ntab_write(dev, B43_NTAB16(8, 0x15), 0x20);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x05), 0);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x15), 0);
 
 		b43_phy_mask(dev, B43_NPHY_AFECTL_C1, ~0x4);
 		b43_phy_mask(dev, B43_NPHY_AFECTL_OVER1, ~0x4);
@@ -3116,20 +3119,20 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_ENDROP_TLEN, 0x2);
 
 	b43_ntab_write(dev, B43_NTAB32(16, 0x100), 20);
-	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x138), 2, ntab7_138_146);
+	b43_ntab_write_bulk(dev, B43_NTAB8(7, 0x138), 2, ntab7_138_146);
 	b43_ntab_write(dev, B43_NTAB16(7, 0x141), 0x77);
-	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x133), 3, ntab7_133);
-	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x146), 2, ntab7_138_146);
+	b43_ntab_write_bulk(dev, B43_NTAB8(7, 0x133), 3, ntab7_133);
+	b43_ntab_write_bulk(dev, B43_NTAB8(7, 0x146), 2, ntab7_138_146);
 	b43_ntab_write(dev, B43_NTAB16(7, 0x123), 0x77);
 	b43_ntab_write(dev, B43_NTAB16(7, 0x12A), 0x77);
 
-	if (!b43_is_40mhz(dev)) {
-		b43_ntab_write(dev, B43_NTAB32(16, 0x03), 0x18D);
-		b43_ntab_write(dev, B43_NTAB32(16, 0x7F), 0x18D);
-	} else {
-		b43_ntab_write(dev, B43_NTAB32(16, 0x03), 0x14D);
-		b43_ntab_write(dev, B43_NTAB32(16, 0x7F), 0x14D);
-	}
+	b43_ntab_read_bulk(dev, B43_NTAB32(16, 0x02), 1, noise_tbl);
+	noise_tbl[1] = b43_is_40mhz(dev) ? 0x14D : 0x18D;
+	b43_ntab_write_bulk(dev, B43_NTAB32(16, 0x02), 2, noise_tbl);
+
+	b43_ntab_read_bulk(dev, B43_NTAB32(16, 0x7E), 1, noise_tbl);
+	noise_tbl[1] = b43_is_40mhz(dev) ? 0x14D : 0x18D;
+	b43_ntab_write_bulk(dev, B43_NTAB32(16, 0x7E), 2, noise_tbl);
 
 	b43_nphy_gain_ctl_workarounds(dev);
 
-- 
1.8.4.5

