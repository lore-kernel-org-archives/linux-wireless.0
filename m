Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:50552 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaGQRdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 13:33:01 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so3447875wes.25
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 10:33:00 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 6/6] b43: N-PHY: update spur avoidance to support newer devices
Date: Thu, 17 Jul 2014 19:31:06 +0200
Message-Id: <1405618266-20200-6-git-send-email-zajec5@gmail.com> (sfid-20140717_193306_801723_059BDA81)
In-Reply-To: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
References: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 43 +++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 0f0c130..92bfe35 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -6099,26 +6099,45 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 
 	if (dev->phy.rev >= 3 &&
 	    dev->phy.n->spur_avoid != B43_SPUR_AVOID_DISABLE) {
-		bool avoid = false;
+		u8 spuravoid = 0;
+
 		if (dev->phy.n->spur_avoid == B43_SPUR_AVOID_FORCE) {
-			avoid = true;
-		} else if (!b43_is_40mhz(dev)) {
-			if ((ch >= 5 && ch <= 8) || ch == 13 || ch == 14)
-				avoid = true;
-		} else { /* 40MHz */
-			if (nphy->aband_spurwar_en &&
-			    (ch == 38 || ch == 102 || ch == 118))
-				avoid = dev->dev->chip_id == 0x4716;
+			spuravoid = 1;
+		} else if (phy->rev >= 19) {
+			/* TODO */
+		} else if (phy->rev >= 18) {
+			/* TODO */
+		} else if (phy->rev >= 17) {
+			/* TODO: Off for channels 1-11, but check 12-14! */
+		} else if (phy->rev >= 16) {
+			/* TODO: Off for 2 GHz, but check 5 GHz! */
+		} else if (phy->rev >= 7) {
+			if (!b43_is_40mhz(dev)) { /* 20MHz */
+				if (ch == 13 || ch == 14 || ch == 153)
+					spuravoid = 1;
+			} else { /* 40 MHz */
+				if (ch == 54)
+					spuravoid = 1;
+			}
+		} else {
+			if (!b43_is_40mhz(dev)) { /* 20MHz */
+				if ((ch >= 5 && ch <= 8) || ch == 13 || ch == 14)
+					spuravoid = 1;
+			} else { /* 40MHz */
+				if (nphy->aband_spurwar_en &&
+				    (ch == 38 || ch == 102 || ch == 118))
+					spuravoid = dev->dev->chip_id == 0x4716;
+			}
 		}
 
-		b43_nphy_pmu_spur_avoid(dev, avoid);
+		b43_nphy_pmu_spur_avoid(dev, spuravoid);
 
-		b43_mac_switch_freq(dev, avoid);
+		b43_mac_switch_freq(dev, spuravoid);
 
 		if (dev->phy.rev == 3 || dev->phy.rev == 4)
 			; /* TODO: reset PLL */
 
-		if (avoid)
+		if (spuravoid)
 			b43_phy_set(dev, B43_NPHY_BBCFG, B43_NPHY_BBCFG_RSTRX);
 		else
 			b43_phy_mask(dev, B43_NPHY_BBCFG,
-- 
1.8.4.5

