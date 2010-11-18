Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33596 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab0KRM1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 07:27:00 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so1855656eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 04:26:59 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: N-PHY: fix some typos, conditions, set gain_boost
Date: Thu, 18 Nov 2010 13:27:59 +0100
Message-Id: <1290083280-13550-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290083280-13550-1-git-send-email-zajec5@gmail.com>
References: <1290083280-13550-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e1d02f9..bea7dab 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -918,15 +918,15 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 				B43_NPHY_C2_CGAINI_CL2DETECT);
 
 		/* Set narrowband clip threshold */
-		b43_phy_set(dev, B43_NPHY_C1_NBCLIPTHRES, 0x84);
-		b43_phy_set(dev, B43_NPHY_C2_NBCLIPTHRES, 0x84);
+		b43_phy_write(dev, B43_NPHY_C1_NBCLIPTHRES, 0x84);
+		b43_phy_write(dev, B43_NPHY_C2_NBCLIPTHRES, 0x84);
 
 		if (!dev->phy.is_40mhz) {
 			/* Set dwell lengths */
-			b43_phy_set(dev, B43_NPHY_CLIP1_NBDWELL_LEN, 0x002B);
-			b43_phy_set(dev, B43_NPHY_CLIP2_NBDWELL_LEN, 0x002B);
-			b43_phy_set(dev, B43_NPHY_W1CLIP1_DWELL_LEN, 0x0009);
-			b43_phy_set(dev, B43_NPHY_W1CLIP2_DWELL_LEN, 0x0009);
+			b43_phy_write(dev, B43_NPHY_CLIP1_NBDWELL_LEN, 0x002B);
+			b43_phy_write(dev, B43_NPHY_CLIP2_NBDWELL_LEN, 0x002B);
+			b43_phy_write(dev, B43_NPHY_W1CLIP1_DWELL_LEN, 0x0009);
+			b43_phy_write(dev, B43_NPHY_W1CLIP2_DWELL_LEN, 0x0009);
 		}
 
 		/* Set wideband clip 2 threshold */
@@ -948,7 +948,7 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 				~B43_NPHY_C2_CCK_CGAINI_GAINBKOFF, 0x1);
 		}
 
-		b43_phy_set(dev, B43_NPHY_CCK_SHIFTB_REF, 0x809C);
+		b43_phy_write(dev, B43_NPHY_CCK_SHIFTB_REF, 0x809C);
 
 		if (nphy->gain_boost) {
 			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ &&
@@ -969,10 +969,10 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 				code << B43_NPHY_C2_INITGAIN_HPVGA2_SHIFT);
 
 		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D06);
-		b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
-					(code << 8 | 0x7C));
-		b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
-					(code << 8 | 0x7C));
+		/* specs say about 2 loops, but wl does 4 */
+		for (i = 0; i < 4; i++)
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+							(code << 8 | 0x7C));
 
 		b43_nphy_adjust_lna_gain_table(dev);
 
@@ -990,10 +990,10 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
 
 			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D06);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
-					(code << 8 | 0x74));
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
-					(code << 8 | 0x74));
+			/* specs say about 2 loops, but wl does 4 */
+			for (i = 0; i < 4; i++)
+				b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+							(code << 8 | 0x74));
 		}
 
 		if (dev->phy.rev == 2) {
@@ -1033,7 +1033,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 	u8 events2[7] = { 0x0, 0x3, 0x5, 0x4, 0x2, 0x1, 0x8 };
 	u8 delays2[7] = { 0x8, 0x6, 0x2, 0x4, 0x4, 0x6, 0x1 };
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
 		b43_nphy_classifier(dev, 1, 0);
 	else
 		b43_nphy_classifier(dev, 1, 1);
@@ -3458,7 +3458,8 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 
 	memset(nphy, 0, sizeof(*nphy));
 
-	//TODO init struct b43_phy_n
+	/* wl goes path which is executed for gain_boost, assume it is true */
+	nphy->gain_boost = true;
 }
 
 static void b43_nphy_op_free(struct b43_wldev *dev)
-- 
1.7.1

