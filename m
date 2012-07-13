Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:45383 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2GMOfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 10:35:52 -0400
Date: Fri, 13 Jul 2012 10:35:51 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192de: Fix phy-based version calculation
Message-ID: <20120713143551.GF9489@alittletooquiet.net> (sfid-20120713_163557_029044_8DC145B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Forest Bond <forest.bond@rapidrollout.com>

Commit d83579e2a50ac68389e6b4c58b845c702cf37516 incorporated some
changes from the vendor driver that made it newly important that the
calculated hardware version correctly include the CHIP_92D bit, as all
of the IS_92D_* macros were changed to depend on it.  However, this bit
was being unset for dual-mac, dual-phy devices.  The vendor driver
behavior was modified to not do this, but unfortunately this change was
not picked up along with the others.  This caused scanning in the 2.4GHz
band to be broken, and possibly other bugs as well.

This patch brings the version calculation logic in parity with the
vendor driver in this regard, and in doing so fixes the regression.
However, the version calculation code in general continues to be largely
incoherent and messy, and needs to be cleaned up.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
---
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
index 18380a7..4420312 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -3345,21 +3345,21 @@ void rtl92d_phy_config_macphymode_info(struct ieee80211_hw *hw)
 	switch (rtlhal->macphymode) {
 	case DUALMAC_SINGLEPHY:
 		rtlphy->rf_type = RF_2T2R;
-		rtlhal->version |= CHIP_92D_SINGLEPHY;
+		rtlhal->version |= RF_TYPE_2T2R;
 		rtlhal->bandset = BAND_ON_BOTH;
 		rtlhal->current_bandtype = BAND_ON_2_4G;
 		break;
 
 	case SINGLEMAC_SINGLEPHY:
 		rtlphy->rf_type = RF_2T2R;
-		rtlhal->version |= CHIP_92D_SINGLEPHY;
+		rtlhal->version |= RF_TYPE_2T2R;
 		rtlhal->bandset = BAND_ON_BOTH;
 		rtlhal->current_bandtype = BAND_ON_2_4G;
 		break;
 
 	case DUALMAC_DUALPHY:
 		rtlphy->rf_type = RF_1T1R;
-		rtlhal->version &= (~CHIP_92D_SINGLEPHY);
+		rtlhal->version &= RF_TYPE_1T1R;
 		/* Now we let MAC0 run on 5G band. */
 		if (rtlhal->interfaceindex == 0) {
 			rtlhal->bandset = BAND_ON_5G;
-- 
1.7.0.4
