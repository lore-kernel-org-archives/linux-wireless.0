Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50104 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab3CUTcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 15:32:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] b43: remove warning for LP-PHY with sprom < 8
Date: Thu, 21 Mar 2013 20:28:40 +0100
Message-Id: <1363894120-14563-1-git-send-email-hauke@hauke-m.de> (sfid-20130321_203229_200137_4E8517E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BCM5354 SoC has a build in ieee80211 core rev 13 with a LP-PHY on
it. This devices has a sprom version 3 stored in the nvram. This patch
removes the warning and uses the opo values from the sprom as mentioned
in the specs.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/phy_lp.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 3ae2856..5ed352d 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -104,14 +104,8 @@ static void lpphy_read_band_sprom(struct b43_wldev *dev)
 		maxpwr = sprom->maxpwr_bg;
 		lpphy->max_tx_pwr_med_band = maxpwr;
 		cckpo = sprom->cck2gpo;
-		/*
-		 * We don't read SPROM's opo as specs say. On rev8 SPROMs
-		 * opo == ofdm2gpo and we don't know any SSB with LP-PHY
-		 * and SPROM rev below 8.
-		 */
-		B43_WARN_ON(sprom->revision < 8);
-		ofdmpo = sprom->ofdm2gpo;
 		if (cckpo) {
+			ofdmpo = sprom->ofdm2gpo;
 			for (i = 0; i < 4; i++) {
 				lpphy->tx_max_rate[i] =
 					maxpwr - (ofdmpo & 0xF) * 2;
@@ -124,11 +118,11 @@ static void lpphy_read_band_sprom(struct b43_wldev *dev)
 				ofdmpo >>= 4;
 			}
 		} else {
-			ofdmpo &= 0xFF;
+			u8 opo = sprom->opo;
 			for (i = 0; i < 4; i++)
 				lpphy->tx_max_rate[i] = maxpwr;
 			for (i = 4; i < 15; i++)
-				lpphy->tx_max_rate[i] = maxpwr - ofdmpo;
+				lpphy->tx_max_rate[i] = maxpwr - opo;
 		}
 	} else { /* 5GHz */
 		lpphy->tx_isolation_low_band = sprom->tri5gl;
-- 
1.7.10.4

