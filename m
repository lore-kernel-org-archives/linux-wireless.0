Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:55640 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaGaUA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:00:59 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so3330008wes.31
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 13:00:57 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.18 5/7] b43: N-PHY: add RF power tables for radio 0x2057 revs 9 & 14
Date: Thu, 31 Jul 2014 21:59:46 +0200
Message-Id: <1406836788-23704-6-git-send-email-zajec5@gmail.com> (sfid-20140731_220103_155177_586F02F4)
In-Reply-To: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
References: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't write them as we don't have gains configured correctly yet.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
These magic tables I add here may deserve some explanation. The problem
with fetching these tables was that wl.ko doesn't write them directly.
Instead it uses values from another table, extracts some bits from them
and then picks a proper value. This is why I couldn't get all values by
simply looking at MMIO dump and I had to guess few.

First I found writes of proper tables in MMIO dump:

1) Writing "txpwr" 32b values (cut to 5 out of 128)
phy_write(0x0072) <- 0x68c0	// This is (26 << 10) | 0xC0
phy_write(0x0074) <- 0x60ff
phy_write(0x0073) <- 0x0031	// This was 0x60ff0031 value
phy_write(0x0074) <- 0x60e7
phy_write(0x0073) <- 0x002c	// This was 0x60e7002c value
phy_write(0x0074) <- 0x60cf
phy_write(0x0073) <- 0x002a	// This was 0x60cf002a value
phy_write(0x0074) <- 0x60c7
phy_write(0x0073) <- 0x0029	// This was 0x60c70029 value
phy_write(0x0074) <- 0x60b7
phy_write(0x0073) <- 0x0029	// This was 0x60b70029 value
(...)

2) Writing RF power offset values (cut to 5 out of 128)
phy_write(0x0072) <- 0x6a40	// This is ((26 << 10) | 0x240) + 0
phy_write(0x0074) <- 0x0000
phy_write(0x0073) <- 0x0000
phy_write(0x0072) <- 0x6a41	// This is ((26 << 10) | 0x240) + 1
phy_write(0x0074) <- 0xffff
phy_write(0x0073) <- 0xfffd
phy_write(0x0072) <- 0x6a42	// This is ((26 << 10) | 0x240) + 2
phy_write(0x0074) <- 0xffff
phy_write(0x0073) <- 0xfff9
phy_write(0x0072) <- 0x6a43	// This is ((26 << 10) | 0x240) + 3
phy_write(0x0074) <- 0xffff
phy_write(0x0073) <- 0xfff7
phy_write(0x0072) <- 0x6a44	// This is ((26 << 10) | 0x240) + 4
phy_write(0x0074) <- 0xffff
phy_write(0x0073) <- 0xfff4
(...)

Then from every "txpwr" value I extracted "pad_gain" value using:
((table[i] >> 19) & 0x1f) and put corresponding write to the second
table next to it. Then I had to change hex value into signed int. It
went like this:
txpwr:0x60ff0031 pad_gain:31	0x00000000 0
txpwr:0x60e7002c pad_gain:28	0xfffffffd -3
txpwr:0x60cf002a pad_gain:25	0xfffffff9 -7
txpwr:0x60c70029 pad_gain:24	0xfffffff7 -9
txpwr:0x60b70029 pad_gain:22	0xfffffff4 -12
(...)
---
 drivers/net/wireless/b43/phy_n.c       | 21 +++++++++--
 drivers/net/wireless/b43/tables_nphy.c | 67 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/tables_nphy.h |  2 +
 3 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index df64032..57a3ab2 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4235,8 +4235,9 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 
 	const u32 *table = NULL;
 	u32 rfpwr_offset;
-	u8 pga_gain;
+	u8 pga_gain, pad_gain;
 	int i;
+	const s16 *uninitialized_var(rf_pwr_offset_table);
 
 	table = b43_nphy_get_tx_gain_table(dev);
 	if (!table)
@@ -4252,13 +4253,27 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 	nphy->gmval = (table[0] >> 16) & 0x7000;
 #endif
 
+	if (phy->rev >= 19) {
+		return;
+	} else if (phy->rev >= 7) {
+		rf_pwr_offset_table = b43_ntab_get_rf_pwr_offset_table(dev);
+		if (!rf_pwr_offset_table)
+			return;
+		/* TODO: Enable this once we have gains configured */
+		return;
+	}
+
 	for (i = 0; i < 128; i++) {
 		if (phy->rev >= 19) {
 			/* TODO */
 			return;
 		} else if (phy->rev >= 7) {
-			/* TODO */
-			return;
+			pga_gain = (table[i] >> 24) & 0xf;
+			pad_gain = (table[i] >> 19) & 0x1f;
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+				rfpwr_offset = rf_pwr_offset_table[pad_gain];
+			else
+				rfpwr_offset = rf_pwr_offset_table[pga_gain];
 		} else {
 			pga_gain = (table[i] >> 24) & 0xF;
 			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index f449cff..25d1cbd 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2878,6 +2878,40 @@ const s8 b43_ntab_papd_pga_gain_delta_ipa_2g[] = {
 	-54, -46, -39, -31, -23, -15, -8, 0
 };
 
+/* Extracted from MMIO dump of 6.30.223.248
+ * Entries: 0, 15, 17, 21, 24, 26, 27, 29, 30 were guessed
+ */
+static const s16 b43_ntab_rf_pwr_offset_2057_rev9_2g[] = {
+	-133, -133, -107, -92, -81,
+	-73, -66, -61, -56, -52,
+	-48, -44, -41, -37, -34,
+	-31, -28, -25, -22, -19,
+	-17, -14, -12, -10, -9,
+	-7, -5, -4, -3, -2,
+	-1, 0,
+};
+
+/* Extracted from MMIO dump of 6.30.223.248 */
+static const s16 b43_ntab_rf_pwr_offset_2057_rev9_5g[] = {
+	-101, -94, -86, -79, -72,
+	-65, -57, -50, -42, -35,
+	-28, -21, -16, -9, -4,
+	0,
+};
+
+/* Extracted from MMIO dump of 6.30.223.248
+ * Entries: 0, 26, 28, 29, 30, 31 were guessed
+ */
+static const s16 b43_ntab_rf_pwr_offset_2057_rev14_2g[] = {
+	-111, -111, -111, -84, -70,
+	-59, -52, -45, -40, -36,
+	-32, -29, -26, -23, -21,
+	-18, -16, -15, -13, -11,
+	-10, -8, -7, -6, -5,
+	-4, -4, -3, -3, -2,
+	-2, -1,
+};
+
 const u16 tbl_iqcal_gainparams[2][9][8] = {
 	{
 		{ 0x000, 0, 0, 2, 0x69, 0x69, 0x69, 0x69 },
@@ -3708,6 +3742,39 @@ const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev)
 	}
 }
 
+const s16 *b43_ntab_get_rf_pwr_offset_table(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		switch (phy->rev) {
+		case 17:
+			if (phy->radio_rev == 14)
+				return b43_ntab_rf_pwr_offset_2057_rev14_2g;
+			break;
+		case 16:
+			if (phy->radio_rev == 9)
+				return b43_ntab_rf_pwr_offset_2057_rev9_2g;
+			break;
+		}
+
+		b43err(dev->wl,
+		       "No 2GHz RF power table available for this device\n");
+		return NULL;
+	} else {
+		switch (phy->rev) {
+		case 16:
+			if (phy->radio_rev == 9)
+				return b43_ntab_rf_pwr_offset_2057_rev9_5g;
+			break;
+		}
+
+		b43err(dev->wl,
+		       "No 5GHz RF power table available for this device\n");
+		return NULL;
+	}
+}
+
 struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 	struct b43_wldev *dev, bool ghz5, bool ext_lna)
 {
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 3ce2e6f..b51f386 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -191,6 +191,8 @@ void b43_nphy_tables_init(struct b43_wldev *dev);
 
 const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev);
 
+const s16 *b43_ntab_get_rf_pwr_offset_table(struct b43_wldev *dev);
+
 extern const s8 b43_ntab_papd_pga_gain_delta_ipa_2g[];
 
 extern const u16 tbl_iqcal_gainparams[2][9][8];
-- 
1.8.4.5

