Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:60633 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab0A3TS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 14:18:29 -0500
Received: by mail-fx0-f220.google.com with SMTP id 20so2964636fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 11:18:29 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/5] b43: N-PHY: add TX radio setup for newer PHYs
Date: Sat, 30 Jan 2010 20:18:06 +0100
Message-Id: <1264879087-14326-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264879087-14326-1-git-send-email-zajec5@gmail.com>
References: <1264879087-14326-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   53 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index cf107c5..c1fc3cc 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1803,9 +1803,60 @@ static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
 	u16 *save = nphy->tx_rx_cal_radio_saveregs;
+	u16 tmp;
+	u8 offset, i;
 
 	if (dev->phy.rev >= 3) {
-		/* TODO */
+	    for (i = 0; i < 2; i++) {
+		tmp = (i == 0) ? 0x2000 : 0x3000;
+		offset = i * 11;
+
+		save[offset + 0] = b43_radio_read16(dev, B2055_CAL_RVARCTL);
+		save[offset + 1] = b43_radio_read16(dev, B2055_CAL_LPOCTL);
+		save[offset + 2] = b43_radio_read16(dev, B2055_CAL_TS);
+		save[offset + 3] = b43_radio_read16(dev, B2055_CAL_RCCALRTS);
+		save[offset + 4] = b43_radio_read16(dev, B2055_CAL_RCALRTS);
+		save[offset + 5] = b43_radio_read16(dev, B2055_PADDRV);
+		save[offset + 6] = b43_radio_read16(dev, B2055_XOCTL1);
+		save[offset + 7] = b43_radio_read16(dev, B2055_XOCTL2);
+		save[offset + 8] = b43_radio_read16(dev, B2055_XOREGUL);
+		save[offset + 9] = b43_radio_read16(dev, B2055_XOMISC);
+		save[offset + 10] = b43_radio_read16(dev, B2055_PLL_LFC1);
+
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			b43_radio_write16(dev, tmp | B2055_CAL_RVARCTL, 0x0A);
+			b43_radio_write16(dev, tmp | B2055_CAL_LPOCTL, 0x40);
+			b43_radio_write16(dev, tmp | B2055_CAL_TS, 0x55);
+			b43_radio_write16(dev, tmp | B2055_CAL_RCCALRTS, 0);
+			b43_radio_write16(dev, tmp | B2055_CAL_RCALRTS, 0);
+			if (nphy->ipa5g_on) {
+				b43_radio_write16(dev, tmp | B2055_PADDRV, 4);
+				b43_radio_write16(dev, tmp | B2055_XOCTL1, 1);
+			} else {
+				b43_radio_write16(dev, tmp | B2055_PADDRV, 0);
+				b43_radio_write16(dev, tmp | B2055_XOCTL1, 0x2F);
+			}
+			b43_radio_write16(dev, tmp | B2055_XOCTL2, 0);
+		} else {
+			b43_radio_write16(dev, tmp | B2055_CAL_RVARCTL, 0x06);
+			b43_radio_write16(dev, tmp | B2055_CAL_LPOCTL, 0x40);
+			b43_radio_write16(dev, tmp | B2055_CAL_TS, 0x55);
+			b43_radio_write16(dev, tmp | B2055_CAL_RCCALRTS, 0);
+			b43_radio_write16(dev, tmp | B2055_CAL_RCALRTS, 0);
+			b43_radio_write16(dev, tmp | B2055_XOCTL1, 0);
+			if (nphy->ipa2g_on) {
+				b43_radio_write16(dev, tmp | B2055_PADDRV, 6);
+				b43_radio_write16(dev, tmp | B2055_XOCTL2,
+					(dev->phy.rev < 5) ? 0x11 : 0x01);
+			} else {
+				b43_radio_write16(dev, tmp | B2055_PADDRV, 0);
+				b43_radio_write16(dev, tmp | B2055_XOCTL2, 0);
+			}
+		}
+		b43_radio_write16(dev, tmp | B2055_XOREGUL, 0);
+		b43_radio_write16(dev, tmp | B2055_XOMISC, 0);
+		b43_radio_write16(dev, tmp | B2055_PLL_LFC1, 0);
+	    }
 	} else {
 		save[0] = b43_radio_read16(dev, B2055_C1_TX_RF_IQCAL1);
 		b43_radio_write16(dev, B2055_C1_TX_RF_IQCAL1, 0x29);
-- 
1.6.4.2

