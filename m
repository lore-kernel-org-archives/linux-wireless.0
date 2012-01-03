Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36520 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2ACVID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 16:08:03 -0500
Received: by eekc4 with SMTP id c4so16211505eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 13:08:02 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/5] b43: N-PHY: add helper for getting gain table
Date: Tue,  3 Jan 2012 22:49:17 +0100
Message-Id: <1325627361-3394-1-git-send-email-zajec5@gmail.com> (sfid-20120103_220808_584842_C635ADB6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also move the code to tables file.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       |   81 ++-----------------------------
 drivers/net/wireless/b43/tables_nphy.c |   65 ++++++++++++++++++++++----
 drivers/net/wireless/b43/tables_nphy.h |   12 +----
 3 files changed, 64 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ea7cc86..20394d8 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -85,24 +85,6 @@ static inline bool b43_nphy_ipa(struct b43_wldev *dev)
 		(dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ));
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetIpaGainTbl */
-static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
-{
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-		if (dev->phy.rev >= 6) {
-			if (dev->dev->chip_id == 47162)
-				return txpwrctrl_tx_gain_ipa_rev5;
-			return txpwrctrl_tx_gain_ipa_rev6;
-		} else if (dev->phy.rev >= 5) {
-			return txpwrctrl_tx_gain_ipa_rev5;
-		} else {
-			return txpwrctrl_tx_gain_ipa;
-		}
-	} else {
-		return txpwrctrl_tx_gain_ipa_5g;
-	}
-}
-
 /**************************************************
  * RF (just without b43_nphy_rf_control_intc_override)
  **************************************************/
@@ -2229,27 +2211,12 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 	*/
 
 	for (i = 0; i < 2; i++) {
-		if (dev->phy.rev >= 3) {
-			if (b43_nphy_ipa(dev)) {
-				txgain = *(b43_nphy_get_ipa_gain_table(dev) +
-						txpi[i]);
-			} else if (b43_current_band(dev->wl) ==
-				   IEEE80211_BAND_5GHZ) {
-				/* FIXME: use 5GHz tables */
-				txgain =
-					b43_ntab_tx_gain_rev3plus_2ghz[txpi[i]];
-			} else {
-				if (dev->phy.rev >= 5 &&
-				    sprom->fem.ghz5.extpa_gain == 3)
-					; /* FIXME: 5GHz_txgain_HiPwrEPA */
-				txgain =
-					b43_ntab_tx_gain_rev3plus_2ghz[txpi[i]];
-			}
+		txgain = *(b43_nphy_get_tx_gain_table(dev) + txpi[i]);
+
+		if (dev->phy.rev >= 3)
 			radio_gain = (txgain >> 16) & 0x1FFFF;
-		} else {
-			txgain = b43_ntab_tx_gain_rev0_1_2[txpi[i]];
+		else
 			radio_gain = (txgain >> 16) & 0x1FFF;
-		}
 
 		if (dev->phy.rev >= 7)
 			dac_gain = (txgain >> 8) & 0x7;
@@ -2647,24 +2614,7 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 	int i;
 #endif
 
-	if (phy->rev >= 3) {
-		if (b43_nphy_ipa(dev)) {
-			table = b43_nphy_get_ipa_gain_table(dev);
-		} else {
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
-				if (phy->rev == 3)
-					table = b43_ntab_tx_gain_rev3_5ghz;
-				if (phy->rev == 4)
-					table = b43_ntab_tx_gain_rev4_5ghz;
-				else
-					table = b43_ntab_tx_gain_rev5plus_5ghz;
-			} else {
-				table = b43_ntab_tx_gain_rev3plus_2ghz;
-			}
-		}
-	} else {
-		table = b43_ntab_tx_gain_rev0_1_2;
-	}
+	table = b43_nphy_get_tx_gain_table(dev);
 	b43_ntab_write_bulk(dev, B43_NTAB32(26, 192), 128, table);
 	b43_ntab_write_bulk(dev, B43_NTAB32(27, 192), 128, table);
 
@@ -3354,32 +3304,13 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 			B43_NPHY_TXPCTL_STAT_BIDX_SHIFT;
 
 		for (i = 0; i < 2; ++i) {
+			table = b43_nphy_get_tx_gain_table(dev);
 			if (dev->phy.rev >= 3) {
-				enum ieee80211_band band =
-					b43_current_band(dev->wl);
-
-				if (b43_nphy_ipa(dev)) {
-					table = b43_nphy_get_ipa_gain_table(dev);
-				} else {
-					if (band == IEEE80211_BAND_5GHZ) {
-						if (dev->phy.rev == 3)
-							table = b43_ntab_tx_gain_rev3_5ghz;
-						else if (dev->phy.rev == 4)
-							table = b43_ntab_tx_gain_rev4_5ghz;
-						else
-							table = b43_ntab_tx_gain_rev5plus_5ghz;
-					} else {
-						table = b43_ntab_tx_gain_rev3plus_2ghz;
-					}
-				}
-
 				target.ipa[i] = (table[index[i]] >> 16) & 0xF;
 				target.pad[i] = (table[index[i]] >> 20) & 0xF;
 				target.pga[i] = (table[index[i]] >> 24) & 0xF;
 				target.txgm[i] = (table[index[i]] >> 28) & 0xF;
 			} else {
-				table = b43_ntab_tx_gain_rev0_1_2;
-
 				target.ipa[i] = (table[index[i]] >> 16) & 0x3;
 				target.pad[i] = (table[index[i]] >> 18) & 0x3;
 				target.pga[i] = (table[index[i]] >> 20) & 0x7;
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index b0de03f..645bc34 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2214,7 +2214,7 @@ static const u16 b43_ntab_antswctl2g_r3[4][32] = {
 };
 
 /* TX gain tables */
-const u32 b43_ntab_tx_gain_rev0_1_2[] = {
+static const u32 b43_ntab_tx_gain_rev0_1_2[] = {
 	0x03cc2b44, 0x03cc2b42, 0x03cc2a44, 0x03cc2a42,
 	0x03cc2944, 0x03c82b44, 0x03c82b42, 0x03c82a44,
 	0x03c82a42, 0x03c82944, 0x03c82942, 0x03c82844,
@@ -2249,7 +2249,7 @@ const u32 b43_ntab_tx_gain_rev0_1_2[] = {
 	0x03801442, 0x03801344, 0x03801342, 0x00002b00,
 };
 
-const u32 b43_ntab_tx_gain_rev3plus_2ghz[] = {
+static const u32 b43_ntab_tx_gain_rev3plus_2ghz[] = {
 	0x1f410044, 0x1f410042, 0x1f410040, 0x1f41003e,
 	0x1f41003c, 0x1f41003b, 0x1f410039, 0x1f410037,
 	0x1e410044, 0x1e410042, 0x1e410040, 0x1e41003e,
@@ -2284,7 +2284,7 @@ const u32 b43_ntab_tx_gain_rev3plus_2ghz[] = {
 	0x1041003c, 0x1041003b, 0x10410039, 0x10410037,
 };
 
-const u32 b43_ntab_tx_gain_rev3_5ghz[] = {
+static const u32 b43_ntab_tx_gain_rev3_5ghz[] = {
 	0xcff70044, 0xcff70042, 0xcff70040, 0xcff7003e,
 	0xcff7003c, 0xcff7003b, 0xcff70039, 0xcff70037,
 	0xcef70044, 0xcef70042, 0xcef70040, 0xcef7003e,
@@ -2319,7 +2319,7 @@ const u32 b43_ntab_tx_gain_rev3_5ghz[] = {
 	0xc0f7003c, 0xc0f7003b, 0xc0f70039, 0xc0f70037,
 };
 
-const u32 b43_ntab_tx_gain_rev4_5ghz[] = {
+static const u32 b43_ntab_tx_gain_rev4_5ghz[] = {
 	0x2ff20044, 0x2ff20042, 0x2ff20040, 0x2ff2003e,
 	0x2ff2003c, 0x2ff2003b, 0x2ff20039, 0x2ff20037,
 	0x2ef20044, 0x2ef20042, 0x2ef20040, 0x2ef2003e,
@@ -2354,7 +2354,7 @@ const u32 b43_ntab_tx_gain_rev4_5ghz[] = {
 	0x20d2003a, 0x20d20038, 0x20d20036, 0x20d20034,
 };
 
-const u32 b43_ntab_tx_gain_rev5plus_5ghz[] = {
+static const u32 b43_ntab_tx_gain_rev5plus_5ghz[] = {
 	0x0f62004a, 0x0f620048, 0x0f620046, 0x0f620044,
 	0x0f620042, 0x0f620040, 0x0f62003e, 0x0f62003c,
 	0x0e620044, 0x0e620042, 0x0e620040, 0x0e62003e,
@@ -2389,7 +2389,7 @@ const u32 b43_ntab_tx_gain_rev5plus_5ghz[] = {
 	0x0062003b, 0x00620039, 0x00620037, 0x00620035,
 };
 
-const u32 txpwrctrl_tx_gain_ipa[] = {
+static const u32 txpwrctrl_tx_gain_ipa[] = {
 	0x5ff7002d, 0x5ff7002b, 0x5ff7002a, 0x5ff70029,
 	0x5ff70028, 0x5ff70027, 0x5ff70026, 0x5ff70025,
 	0x5ef7002d, 0x5ef7002b, 0x5ef7002a, 0x5ef70029,
@@ -2424,7 +2424,7 @@ const u32 txpwrctrl_tx_gain_ipa[] = {
 	0x50f70028, 0x50f70027, 0x50f70026, 0x50f70025,
 };
 
-const u32 txpwrctrl_tx_gain_ipa_rev5[] = {
+static const u32 txpwrctrl_tx_gain_ipa_rev5[] = {
 	0x1ff7002d, 0x1ff7002b, 0x1ff7002a, 0x1ff70029,
 	0x1ff70028, 0x1ff70027, 0x1ff70026, 0x1ff70025,
 	0x1ef7002d, 0x1ef7002b, 0x1ef7002a, 0x1ef70029,
@@ -2459,7 +2459,7 @@ const u32 txpwrctrl_tx_gain_ipa_rev5[] = {
 	0x10f70028, 0x10f70027, 0x10f70026, 0x10f70025,
 };
 
-const u32 txpwrctrl_tx_gain_ipa_rev6[] = {
+static const u32 txpwrctrl_tx_gain_ipa_rev6[] = {
 	0x0ff7002d, 0x0ff7002b, 0x0ff7002a, 0x0ff70029,
 	0x0ff70028, 0x0ff70027, 0x0ff70026, 0x0ff70025,
 	0x0ef7002d, 0x0ef7002b, 0x0ef7002a, 0x0ef70029,
@@ -2494,7 +2494,7 @@ const u32 txpwrctrl_tx_gain_ipa_rev6[] = {
 	0x00f70028, 0x00f70027, 0x00f70026, 0x00f70025,
 };
 
-const u32 txpwrctrl_tx_gain_ipa_5g[] = {
+static const u32 txpwrctrl_tx_gain_ipa_5g[] = {
 	0x7ff70035, 0x7ff70033, 0x7ff70032, 0x7ff70031,
 	0x7ff7002f, 0x7ff7002e, 0x7ff7002d, 0x7ff7002b,
 	0x7ff7002a, 0x7ff70029, 0x7ff70028, 0x7ff70027,
@@ -3126,6 +3126,53 @@ void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev)
 		B43_WARN_ON(1);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetIpaGainTbl */
+static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
+{
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (dev->phy.rev >= 6) {
+			if (dev->dev->chip_id == 47162)
+				return txpwrctrl_tx_gain_ipa_rev5;
+			return txpwrctrl_tx_gain_ipa_rev6;
+		} else if (dev->phy.rev >= 5) {
+			return txpwrctrl_tx_gain_ipa_rev5;
+		} else {
+			return txpwrctrl_tx_gain_ipa;
+		}
+	} else {
+		return txpwrctrl_tx_gain_ipa_5g;
+	}
+}
+
+const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev)
+{
+	enum ieee80211_band band = b43_current_band(dev->wl);
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+
+	if (dev->phy.rev < 3)
+		return b43_ntab_tx_gain_rev0_1_2;
+
+	/* rev 3+ */
+	if ((dev->phy.n->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
+	    (dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ)) {
+		return b43_nphy_get_ipa_gain_table(dev);
+	} else if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		if (dev->phy.rev == 3)
+			return b43_ntab_tx_gain_rev3_5ghz;
+		if (dev->phy.rev == 4)
+			return sprom->fem.ghz5.extpa_gain == 3 ?
+				b43_ntab_tx_gain_rev4_5ghz :
+				b43_ntab_tx_gain_rev4_5ghz; /* FIXME */
+		else
+			return b43_ntab_tx_gain_rev5plus_5ghz;
+	} else {
+		if (dev->phy.rev >= 5 && sprom->fem.ghz5.extpa_gain == 3)
+			return b43_ntab_tx_gain_rev3plus_2ghz; /* FIXME */
+		else
+			return b43_ntab_tx_gain_rev3plus_2ghz;
+	}
+}
+
 struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 	struct b43_wldev *dev, bool ghz5, bool ext_lna)
 {
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 97038c4..2a9d5f1 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -177,16 +177,8 @@ void b43_ntab_write_bulk(struct b43_wldev *dev, u32 offset,
 void b43_nphy_rev0_1_2_tables_init(struct b43_wldev *dev);
 void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev);
 
-extern const u32 b43_ntab_tx_gain_rev0_1_2[];
-extern const u32 b43_ntab_tx_gain_rev3plus_2ghz[];
-extern const u32 b43_ntab_tx_gain_rev3_5ghz[];
-extern const u32 b43_ntab_tx_gain_rev4_5ghz[];
-extern const u32 b43_ntab_tx_gain_rev5plus_5ghz[];
-
-extern const u32 txpwrctrl_tx_gain_ipa[];
-extern const u32 txpwrctrl_tx_gain_ipa_rev5[];
-extern const u32 txpwrctrl_tx_gain_ipa_rev6[];
-extern const u32 txpwrctrl_tx_gain_ipa_5g[];
+const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev);
+
 extern const u16 tbl_iqcal_gainparams[2][9][8];
 extern const struct nphy_txiqcal_ladder ladder_lo[];
 extern const struct nphy_txiqcal_ladder ladder_iq[];
-- 
1.7.3.4

