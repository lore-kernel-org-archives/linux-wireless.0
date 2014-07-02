Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:41944 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaGBUnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 16:43:35 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so11897426wes.14
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2014 13:43:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: N-PHY: rework names & picking of TX gain tables
Date: Wed,  2 Jul 2014 22:42:45 +0200
Message-Id: <1404333766-19248-1-git-send-email-zajec5@gmail.com> (sfid-20140702_224339_122131_DF64CDC0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows adding more revisions support, spotting lacking tables and
unifies naming schema.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       |  12 +++-
 drivers/net/wireless/b43/tables_nphy.c | 102 +++++++++++++++++++++++----------
 2 files changed, 84 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 0a6f04b..50ca6f8 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3369,7 +3369,11 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 	*/
 
 	for (i = 0; i < 2; i++) {
-		txgain = *(b43_nphy_get_tx_gain_table(dev) + txpi[i]);
+		const u32 *table = b43_nphy_get_tx_gain_table(dev);
+
+		if (!table)
+			break;
+		txgain = *(table + txpi[i]);
 
 		if (dev->phy.rev >= 3)
 			radio_gain = (txgain >> 16) & 0x1FFFF;
@@ -3783,6 +3787,9 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 	int i;
 
 	table = b43_nphy_get_tx_gain_table(dev);
+	if (!table)
+		return;
+
 	b43_ntab_write_bulk(dev, B43_NTAB32(26, 192), 128, table);
 	b43_ntab_write_bulk(dev, B43_NTAB32(27, 192), 128, table);
 
@@ -4488,6 +4495,9 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 
 		for (i = 0; i < 2; ++i) {
 			table = b43_nphy_get_tx_gain_table(dev);
+			if (!table)
+				break;
+
 			if (dev->phy.rev >= 3) {
 				target.ipa[i] = (table[index[i]] >> 16) & 0xF;
 				target.pad[i] = (table[index[i]] >> 20) & 0xF;
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index dd87685..3d6dda7 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2332,7 +2332,10 @@ static const u32 b43_ntab_noisevar_r7[] = {
 	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
 };
 
-/* TX gain tables */
+/**************************************************
+ * TX gain tables
+ **************************************************/
+
 static const u32 b43_ntab_tx_gain_rev0_1_2[] = {
 	0x03cc2b44, 0x03cc2b42, 0x03cc2a44, 0x03cc2a42,
 	0x03cc2944, 0x03c82b44, 0x03c82b42, 0x03c82a44,
@@ -2368,7 +2371,9 @@ static const u32 b43_ntab_tx_gain_rev0_1_2[] = {
 	0x03801442, 0x03801344, 0x03801342, 0x00002b00,
 };
 
-static const u32 b43_ntab_tx_gain_rev3plus_2ghz[] = {
+/* EPA 2 GHz */
+
+static const u32 b43_ntab_tx_gain_epa_rev3_2g[] = {
 	0x1f410044, 0x1f410042, 0x1f410040, 0x1f41003e,
 	0x1f41003c, 0x1f41003b, 0x1f410039, 0x1f410037,
 	0x1e410044, 0x1e410042, 0x1e410040, 0x1e41003e,
@@ -2403,7 +2408,9 @@ static const u32 b43_ntab_tx_gain_rev3plus_2ghz[] = {
 	0x1041003c, 0x1041003b, 0x10410039, 0x10410037,
 };
 
-static const u32 b43_ntab_tx_gain_rev3_5ghz[] = {
+/* EPA 5 GHz */
+
+static const u32 b43_ntab_tx_gain_epa_rev3_5g[] = {
 	0xcff70044, 0xcff70042, 0xcff70040, 0xcff7003e,
 	0xcff7003c, 0xcff7003b, 0xcff70039, 0xcff70037,
 	0xcef70044, 0xcef70042, 0xcef70040, 0xcef7003e,
@@ -2438,7 +2445,7 @@ static const u32 b43_ntab_tx_gain_rev3_5ghz[] = {
 	0xc0f7003c, 0xc0f7003b, 0xc0f70039, 0xc0f70037,
 };
 
-static const u32 b43_ntab_tx_gain_rev4_5ghz[] = {
+static const u32 b43_ntab_tx_gain_epa_rev4_5g[] = {
 	0x2ff20044, 0x2ff20042, 0x2ff20040, 0x2ff2003e,
 	0x2ff2003c, 0x2ff2003b, 0x2ff20039, 0x2ff20037,
 	0x2ef20044, 0x2ef20042, 0x2ef20040, 0x2ef2003e,
@@ -2473,7 +2480,7 @@ static const u32 b43_ntab_tx_gain_rev4_5ghz[] = {
 	0x20d2003a, 0x20d20038, 0x20d20036, 0x20d20034,
 };
 
-static const u32 b43_ntab_tx_gain_rev5plus_5ghz[] = {
+static const u32 b43_ntab_tx_gain_epa_rev5_5g[] = {
 	0x0f62004a, 0x0f620048, 0x0f620046, 0x0f620044,
 	0x0f620042, 0x0f620040, 0x0f62003e, 0x0f62003c,
 	0x0e620044, 0x0e620042, 0x0e620040, 0x0e62003e,
@@ -2508,7 +2515,9 @@ static const u32 b43_ntab_tx_gain_rev5plus_5ghz[] = {
 	0x0062003b, 0x00620039, 0x00620037, 0x00620035,
 };
 
-static const u32 txpwrctrl_tx_gain_ipa[] = {
+/* IPA 2 GHz */
+
+static const u32 b43_ntab_tx_gain_ipa_rev3_2g[] = {
 	0x5ff7002d, 0x5ff7002b, 0x5ff7002a, 0x5ff70029,
 	0x5ff70028, 0x5ff70027, 0x5ff70026, 0x5ff70025,
 	0x5ef7002d, 0x5ef7002b, 0x5ef7002a, 0x5ef70029,
@@ -2543,7 +2552,7 @@ static const u32 txpwrctrl_tx_gain_ipa[] = {
 	0x50f70028, 0x50f70027, 0x50f70026, 0x50f70025,
 };
 
-static const u32 txpwrctrl_tx_gain_ipa_rev5[] = {
+static const u32 b43_ntab_tx_gain_ipa_rev5_2g[] = {
 	0x1ff7002d, 0x1ff7002b, 0x1ff7002a, 0x1ff70029,
 	0x1ff70028, 0x1ff70027, 0x1ff70026, 0x1ff70025,
 	0x1ef7002d, 0x1ef7002b, 0x1ef7002a, 0x1ef70029,
@@ -2578,7 +2587,7 @@ static const u32 txpwrctrl_tx_gain_ipa_rev5[] = {
 	0x10f70028, 0x10f70027, 0x10f70026, 0x10f70025,
 };
 
-static const u32 txpwrctrl_tx_gain_ipa_rev6[] = {
+static const u32 b43_ntab_tx_gain_ipa_rev6_2g[] = {
 	0x0ff7002d, 0x0ff7002b, 0x0ff7002a, 0x0ff70029,
 	0x0ff70028, 0x0ff70027, 0x0ff70026, 0x0ff70025,
 	0x0ef7002d, 0x0ef7002b, 0x0ef7002a, 0x0ef70029,
@@ -2613,7 +2622,9 @@ static const u32 txpwrctrl_tx_gain_ipa_rev6[] = {
 	0x00f70028, 0x00f70027, 0x00f70026, 0x00f70025,
 };
 
-static const u32 txpwrctrl_tx_gain_ipa_5g[] = {
+/* IPA 2 5Hz */
+
+static const u32 b43_ntab_tx_gain_ipa_rev3_5g[] = {
 	0x7ff70035, 0x7ff70033, 0x7ff70032, 0x7ff70031,
 	0x7ff7002f, 0x7ff7002e, 0x7ff7002d, 0x7ff7002b,
 	0x7ff7002a, 0x7ff70029, 0x7ff70028, 0x7ff70027,
@@ -3390,23 +3401,39 @@ void b43_nphy_tables_init(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetIpaGainTbl */
 static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
+
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-		if (dev->phy.rev >= 6) {
-			if (dev->dev->chip_id == 47162)
-				return txpwrctrl_tx_gain_ipa_rev5;
-			return txpwrctrl_tx_gain_ipa_rev6;
-		} else if (dev->phy.rev >= 5) {
-			return txpwrctrl_tx_gain_ipa_rev5;
-		} else {
-			return txpwrctrl_tx_gain_ipa;
+		switch (phy->rev) {
+		case 6:
+			if (dev->dev->chip_id == BCMA_CHIP_ID_BCM47162)
+				return b43_ntab_tx_gain_ipa_rev5_2g;
+			return b43_ntab_tx_gain_ipa_rev6_2g;
+		case 5:
+			return b43_ntab_tx_gain_ipa_rev5_2g;
+		case 4:
+		case 3:
+			return b43_ntab_tx_gain_ipa_rev3_2g;
+		default:
+			b43err(dev->wl,
+			       "No 2GHz IPA gain table available for this device\n");
+			return NULL;
 		}
 	} else {
-		return txpwrctrl_tx_gain_ipa_5g;
+		switch (phy->rev) {
+		case 3 ... 6:
+			return b43_ntab_tx_gain_ipa_rev3_5g;
+		default:
+			b43err(dev->wl,
+			       "No 5GHz IPA gain table available for this device\n");
+			return NULL;
+		}
 	}
 }
 
 const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
 	enum ieee80211_band band = b43_current_band(dev->wl);
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
@@ -3418,19 +3445,36 @@ const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev)
 	    (dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ)) {
 		return b43_nphy_get_ipa_gain_table(dev);
 	} else if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
-		if (dev->phy.rev == 3)
-			return b43_ntab_tx_gain_rev3_5ghz;
-		if (dev->phy.rev == 4)
+		switch (phy->rev) {
+		case 6:
+		case 5:
+			return b43_ntab_tx_gain_epa_rev5_5g;
+		case 4:
 			return sprom->fem.ghz5.extpa_gain == 3 ?
-				b43_ntab_tx_gain_rev4_5ghz :
-				b43_ntab_tx_gain_rev4_5ghz; /* FIXME */
-		else
-			return b43_ntab_tx_gain_rev5plus_5ghz;
+				b43_ntab_tx_gain_epa_rev4_5g :
+				b43_ntab_tx_gain_epa_rev4_5g; /* FIXME */
+		case 3:
+			return b43_ntab_tx_gain_epa_rev3_5g;
+		default:
+			b43err(dev->wl,
+			       "No 5GHz EPA gain table available for this device\n");
+			return NULL;
+		}
 	} else {
-		if (dev->phy.rev >= 5 && sprom->fem.ghz5.extpa_gain == 3)
-			return b43_ntab_tx_gain_rev3plus_2ghz; /* FIXME */
-		else
-			return b43_ntab_tx_gain_rev3plus_2ghz;
+		switch (phy->rev) {
+		case 6:
+		case 5:
+			if (sprom->fem.ghz5.extpa_gain == 3)
+				return b43_ntab_tx_gain_epa_rev3_2g; /* FIXME */
+			/* fall through */
+		case 4:
+		case 3:
+			return b43_ntab_tx_gain_epa_rev3_2g;
+		default:
+			b43err(dev->wl,
+			       "No 2GHz EPA gain table available for this device\n");
+			return NULL;
+		}
 	}
 }
 
-- 
1.8.4.5

