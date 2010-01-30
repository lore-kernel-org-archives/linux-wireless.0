Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:60633 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab0A3TSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 14:18:35 -0500
Received: by mail-fx0-f220.google.com with SMTP id 20so2964636fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 11:18:35 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/5] b43: N-PHY: implement setting RF sequence
Date: Sat, 30 Jan 2010 20:18:07 +0100
Message-Id: <1264879087-14326-5-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264879087-14326-1-git-send-email-zajec5@gmail.com>
References: <1264879087-14326-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   35 +++++++++++++++++++++++++++++++----
 1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c1fc3cc..ff42bd4 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -64,6 +64,8 @@ enum b43_nphy_rf_sequence {
 	B43_RFSEQ_UPDATE_GAINU,
 };
 
+static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
+					u8 *events, u8 *delays, u8 length);
 static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
 				       enum b43_nphy_rf_sequence seq);
 
@@ -827,8 +829,8 @@ static void b43_nphy_gain_crtl_workarounds(struct b43_wldev *dev)
 						B43_NPHY_TABLE_DATALO, 3 * j);
 			}
 
-			/* TODO: b43_nphy_set_rf_sequence(dev, 5,
-					rfseq_events, rfseq_delays, 3);*/
+			b43_nphy_set_rf_sequence(dev, 5,
+					rfseq_events, rfseq_delays, 3);
 			b43_phy_maskset(dev, B43_NPHY_OVER_DGAIN1,
 				(u16)~B43_NPHY_OVER_DGAIN_CCKDGECV,
 				0x5A << B43_NPHY_OVER_DGAIN_CCKDGECV_SHIFT);
@@ -911,8 +913,8 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 			delays1[0] = 0x1;
 			delays1[5] = 0x14;
 		}
-		/*TODO:b43_nphy_set_rf_sequence(dev, 0, events1, delays1, 7);*/
-		/*TODO:b43_nphy_set_rf_sequence(dev, 1, events2, delays2, 7);*/
+		b43_nphy_set_rf_sequence(dev, 0, events1, delays1, 7);
+		b43_nphy_set_rf_sequence(dev, 1, events2, delays2, 7);
 
 		b43_nphy_gain_crtl_workarounds(dev);
 
@@ -1131,6 +1133,31 @@ static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, false);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRfSeq */
+static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
+					u8 *events, u8 *delays, u8 length)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	u8 i;
+	u8 end = (dev->phy.rev >= 3) ? 0x1F : 0x0F;
+	u16 offset1 = cmd << 4;
+	u16 offset2 = offset1 + 0x80;
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, true);
+
+	b43_ntab_write_bulk(dev, B43_NTAB8(7, offset1), length, events);
+	b43_ntab_write_bulk(dev, B43_NTAB8(7, offset2), length, delays);
+
+	for (i = length; i < 16; i++) {
+		b43_ntab_write(dev, B43_NTAB8(7, offset1 + i), end);
+		b43_ntab_write(dev, B43_NTAB8(7, offset2 + i), 1);
+	}
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, false);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ForceRFSeq */
 static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
 				       enum b43_nphy_rf_sequence seq)
-- 
1.6.4.2

