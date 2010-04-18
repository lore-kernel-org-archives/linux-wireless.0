Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42385 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab0DRPcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 11:32:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/9] ath9k: update the ath_max_4ms_framelen table
Date: Sun, 18 Apr 2010 16:56:37 +0200
Message-Id: <1271602602-8538-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1271602602-8538-3-git-send-email-nbd@openwrt.org>
References: <1271602602-8538-1-git-send-email-nbd@openwrt.org>
 <1271602602-8538-2-git-send-email-nbd@openwrt.org>
 <1271602602-8538-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include MCS0-31 and also add SGI for HT20. This makes it
possible to support more different rate combinations with
newer hardware.

Based on a patch by Selvam. T.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   41 +++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5d3d563..4078982 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -71,24 +71,36 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 			     int nbad, int txok, bool update_rc);
 
 enum {
-	MCS_DEFAULT,
+	MCS_HT20,
+	MCS_HT20_SGI,
 	MCS_HT40,
 	MCS_HT40_SGI,
 };
 
-static int ath_max_4ms_framelen[3][16] = {
-	[MCS_DEFAULT] = {
-		3216,  6434,  9650,  12868, 19304, 25740,  28956,  32180,
-		6430,  12860, 19300, 25736, 38600, 51472,  57890,  64320,
+static int ath_max_4ms_framelen[4][32] = {
+	[MCS_HT20] = {
+		3212,  6432,  9648,  12864,  19300,  25736,  28952,  32172,
+		6424,  12852, 19280, 25708,  38568,  51424,  57852,  64280,
+		9628,  19260, 28896, 38528,  57792,  65532,  65532,  65532,
+		12828, 25656, 38488, 51320,  65532,  65532,  65532,  65532,
+	},
+	[MCS_HT20_SGI] = {
+		3572,  7144,  10720,  14296,  21444,  28596,  32172,  35744,
+		7140,  14284, 21428,  28568,  42856,  57144,  64288,  65532,
+		10700, 21408, 32112,  42816,  64228,  65532,  65532,  65532,
+		14256, 28516, 42780,  57040,  65532,  65532,  65532,  65532,
 	},
 	[MCS_HT40] = {
-		6684,  13368, 20052, 26738, 40104, 53476,  60156,  66840,
-		13360, 26720, 40080, 53440, 80160, 106880, 120240, 133600,
+		6680,  13360,  20044,  26724,  40092,  53456,  60140,  65532,
+		13348, 26700,  40052,  53400,  65532,  65532,  65532,  65532,
+		20004, 40008,  60016,  65532,  65532,  65532,  65532,  65532,
+		26644, 53292,  65532,  65532,  65532,  65532,  65532,  65532,
 	},
 	[MCS_HT40_SGI] = {
-		/* TODO: Only MCS 7 and 15 updated, recalculate the rest */
-		6684,  13368, 20052, 26738, 40104, 53476,  60156,  74200,
-		13360, 26720, 40080, 53440, 80160, 106880, 120240, 148400,
+		7420,  14844,  22272,  29696,  44544,  59396,  65532,  65532,
+		14832, 29668,  44504,  59340,  65532,  65532,  65532,  65532,
+		22232, 44464,  65532,  65532,  65532,  65532,  65532,  65532,
+		29616, 59232,  65532,  65532,  65532,  65532,  65532,  65532,
 	}
 };
 
@@ -538,12 +550,13 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 				break;
 			}
 
-			if (rates[i].flags & IEEE80211_TX_RC_SHORT_GI)
-				modeidx = MCS_HT40_SGI;
-			else if (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			if (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 				modeidx = MCS_HT40;
 			else
-				modeidx = MCS_DEFAULT;
+				modeidx = MCS_HT20;
+
+			if (rates[i].flags & IEEE80211_TX_RC_SHORT_GI)
+				modeidx++;
 
 			frmlen = ath_max_4ms_framelen[modeidx][rates[i].idx];
 			max_4ms_framelen = min(max_4ms_framelen, frmlen);
-- 
1.6.4.2

