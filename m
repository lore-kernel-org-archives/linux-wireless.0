Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:63376 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYJCUsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:48:52 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1801151wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 13:48:51 -0700 (PDT)
Subject: [PATCH 4/8] b43: use the b43_phy masking/setting helpers where
 possible from lo.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 13:48:47 -0700
Message-Id: <1223066927.6512.29.camel@brick> (sfid-20081003_224857_587865_B615C2BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/lo.c |   31 ++++++++-----------------------
 1 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index a6c185b..b41f2de 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -393,18 +393,10 @@ static void lo_measure_setup(struct b43_wldev *dev,
 		sav->phy_cck_14 = b43_phy_read(dev, B43_PHY_CCK(0x14));
 		sav->phy_hpwr_tssictl = b43_phy_read(dev, B43_PHY_HPWR_TSSICTL);
 
-		b43_phy_write(dev, B43_PHY_HPWR_TSSICTL,
-			      b43_phy_read(dev, B43_PHY_HPWR_TSSICTL)
-			      | 0x100);
-		b43_phy_write(dev, B43_PHY_EXTG(0x01),
-			      b43_phy_read(dev, B43_PHY_EXTG(0x01))
-			      | 0x40);
-		b43_phy_write(dev, B43_PHY_DACCTL,
-			      b43_phy_read(dev, B43_PHY_DACCTL)
-			      | 0x40);
-		b43_phy_write(dev, B43_PHY_CCK(0x14),
-			      b43_phy_read(dev, B43_PHY_CCK(0x14))
-			      | 0x200);
+		b43_phy_set(dev, B43_PHY_HPWR_TSSICTL, 0x100);
+		b43_phy_set(dev, B43_PHY_EXTG(0x01), 0x40);
+		b43_phy_set(dev, B43_PHY_DACCTL, 0x40);
+		b43_phy_set(dev, B43_PHY_CCK(0x14), 0x200);
 	}
 	if (phy->type == B43_PHYTYPE_B &&
 	    phy->radio_ver == 0x2050 && phy->radio_rev < 6) {
@@ -421,17 +413,10 @@ static void lo_measure_setup(struct b43_wldev *dev,
 		sav->phy_cck_3E = b43_phy_read(dev, B43_PHY_CCK(0x3E));
 		sav->phy_crs0 = b43_phy_read(dev, B43_PHY_CRS0);
 
-		b43_phy_write(dev, B43_PHY_CLASSCTL,
-			      b43_phy_read(dev, B43_PHY_CLASSCTL)
-			      & 0xFFFC);
-		b43_phy_write(dev, B43_PHY_CRS0, b43_phy_read(dev, B43_PHY_CRS0)
-			      & 0x7FFF);
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER)
-			      | 0x0003);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVERVAL)
-			      & 0xFFFC);
+		b43_phy_mask(dev, B43_PHY_CLASSCTL, 0xFFFC);
+		b43_phy_mask(dev, B43_PHY_CRS0, 0x7FFF);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0003);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFC);
 		if (phy->type == B43_PHYTYPE_G) {
 			if ((phy->rev >= 7) &&
 			    (sprom->boardflags_lo & B43_BFL_EXTLNA)) {
-- 
1.6.0.2.471.g47a76


