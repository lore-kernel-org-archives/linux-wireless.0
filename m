Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:43925 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760682AbaGSKw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 06:52:58 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so5593498wes.22
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 03:52:57 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/7] b43: N-PHY: add helper for setting digital filters
Date: Sat, 19 Jul 2014 12:52:41 +0200
Message-Id: <1405767167-30315-1-git-send-email-zajec5@gmail.com> (sfid-20140719_125304_776454_3DA98E93)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 92bfe35..b5c8a81 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4809,41 +4809,46 @@ static void b43_nphy_update_tx_cal_ladder(struct b43_wldev *dev, u16 core)
 	}
 }
 
+static void b43_nphy_pa_set_tx_dig_filter(struct b43_wldev *dev, u16 offset,
+					  const s16 *filter)
+{
+	int i;
+
+	offset = B43_PHY_N(offset);
+
+	for (i = 0; i < 15; i++, offset++)
+		b43_phy_write(dev, offset, filter[i]);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ExtPaSetTxDigiFilts */
 static void b43_nphy_ext_pa_set_tx_dig_filters(struct b43_wldev *dev)
 {
-	int i;
-	for (i = 0; i < 15; i++)
-		b43_phy_write(dev, B43_PHY_N(0x2C5 + i),
-				tbl_tx_filter_coef_rev4[2][i]);
+	b43_nphy_pa_set_tx_dig_filter(dev, 0x2C5,
+				      tbl_tx_filter_coef_rev4[2]);
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/IpaSetTxDigiFilts */
 static void b43_nphy_int_pa_set_tx_dig_filters(struct b43_wldev *dev)
 {
-	int i, j;
 	/* B43_NPHY_TXF_20CO_S0A1, B43_NPHY_TXF_40CO_S0A1, unknown */
 	static const u16 offset[] = { 0x186, 0x195, 0x2C5 };
+	int i;
 
 	for (i = 0; i < 3; i++)
-		for (j = 0; j < 15; j++)
-			b43_phy_write(dev, B43_PHY_N(offset[i] + j),
-					tbl_tx_filter_coef_rev4[i][j]);
+		b43_nphy_pa_set_tx_dig_filter(dev, offset[i],
+					      tbl_tx_filter_coef_rev4[i]);
 
 	if (b43_is_40mhz(dev)) {
-		for (j = 0; j < 15; j++)
-			b43_phy_write(dev, B43_PHY_N(offset[0] + j),
-					tbl_tx_filter_coef_rev4[3][j]);
+		b43_nphy_pa_set_tx_dig_filter(dev, 0x186,
+					      tbl_tx_filter_coef_rev4[3]);
 	} else if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
-		for (j = 0; j < 15; j++)
-			b43_phy_write(dev, B43_PHY_N(offset[0] + j),
-					tbl_tx_filter_coef_rev4[5][j]);
+		b43_nphy_pa_set_tx_dig_filter(dev, 0x186,
+					      tbl_tx_filter_coef_rev4[5]);
 	}
 
 	if (dev->phy.channel == 14)
-		for (j = 0; j < 15; j++)
-			b43_phy_write(dev, B43_PHY_N(offset[0] + j),
-					tbl_tx_filter_coef_rev4[6][j]);
+		b43_nphy_pa_set_tx_dig_filter(dev, 0x186,
+					      tbl_tx_filter_coef_rev4[6]);
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetTxGain */
-- 
1.8.4.5

