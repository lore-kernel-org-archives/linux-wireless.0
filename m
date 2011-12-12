Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40098 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1LLV7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 16:59:23 -0500
Received: by eekc4 with SMTP id c4so1835472eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 13:59:22 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: update TX power fix
Date: Mon, 12 Dec 2011 23:40:22 +0100
Message-Id: <1323729622-2711-1-git-send-email-zajec5@gmail.com> (sfid-20111212_225926_592796_D148A25C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specs were updated.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 730f5a4..6b95fd2 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -475,7 +475,9 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
-	if (dev->phy.rev >= 3) {
+	if (dev->phy.rev >= 7) {
+		txpi[0] = txpi[1] = 30;
+	} else if (dev->phy.rev >= 3) {
 		txpi[0] = 40;
 		txpi[1] = 40;
 	} else if (sprom->revision < 4) {
@@ -499,6 +501,9 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 			txpi[1] = 91;
 		}
 	}
+	if (dev->phy.rev < 7 &&
+	    (txpi[0] < 40 || txpi[0] > 100 || txpi[1] < 40 || txpi[1] > 10))
+		txpi[0] = txpi[1] = 91;
 
 	/*
 	for (i = 0; i < 2; i++) {
@@ -509,15 +514,31 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 
 	for (i = 0; i < 2; i++) {
 		if (dev->phy.rev >= 3) {
-			/* FIXME: support 5GHz */
-			txgain = b43_ntab_tx_gain_rev3plus_2ghz[txpi[i]];
+			if (b43_nphy_ipa(dev)) {
+				txgain = *(b43_nphy_get_ipa_gain_table(dev) +
+						txpi[i]);
+			} else if (b43_current_band(dev->wl) ==
+				   IEEE80211_BAND_5GHZ) {
+				/* FIXME: use 5GHz tables */
+				txgain =
+					b43_ntab_tx_gain_rev3plus_2ghz[txpi[i]];
+			} else {
+				if (dev->phy.rev >= 5 &&
+				    sprom->fem.ghz5.extpa_gain == 3)
+					; /* FIXME: 5GHz_txgain_HiPwrEPA */
+				txgain =
+					b43_ntab_tx_gain_rev3plus_2ghz[txpi[i]];
+			}
 			radio_gain = (txgain >> 16) & 0x1FFFF;
 		} else {
 			txgain = b43_ntab_tx_gain_rev0_1_2[txpi[i]];
 			radio_gain = (txgain >> 16) & 0x1FFF;
 		}
 
-		dac_gain = (txgain >> 8) & 0x3F;
+		if (dev->phy.rev >= 7)
+			dac_gain = (txgain >> 8) & 0x7;
+		else
+			dac_gain = (txgain >> 8) & 0x3F;
 		bbmult = txgain & 0xFF;
 
 		if (dev->phy.rev >= 3) {
@@ -547,7 +568,8 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 			u32 tmp32;
 			u16 reg = (i == 0) ?
 				B43_NPHY_PAPD_EN0 : B43_NPHY_PAPD_EN1;
-			tmp32 = b43_ntab_read(dev, B43_NTAB32(26 + i, txpi[i]));
+			tmp32 = b43_ntab_read(dev, B43_NTAB32(26 + i,
+							      576 + txpi[i]));
 			b43_phy_maskset(dev, reg, 0xE00F, (u32) tmp32 << 4);
 			b43_phy_set(dev, reg, 0x4);
 		}
-- 
1.7.3.4

