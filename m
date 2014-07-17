Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42914 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaGQRcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 13:32:50 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so3172143wib.14
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 10:32:48 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/6] b43: N-PHY: add tables for radio 0x2057 rev 14
Date: Thu, 17 Jul 2014 19:31:02 +0200
Message-Id: <1405618266-20200-2-git-send-email-zajec5@gmail.com> (sfid-20140717_193301_774126_41146949)
In-Reply-To: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
References: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Channel tables were fetched using this lovely set of commands:
egrep -A 60 'read32 0x.....160 -> 0x00010028' 43217-wl.txt.b43 > 43217-channels-1.txt
vim 43217-channels-1.txt
:%s/radio_write(0x0016) <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)/\t\tRADIOREGS7_2G(\1, \2, \3, \4, \5, \6, \7, \8,/
:%s/radio_write(0x002d) <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)/\t\t\t      \1, \2, \3, \4, \5, \6, \7, \8,/
:%s/radio_write(0x00e3) <- \(.*\)\n.* <- \(.*\)/\t\t\t      \1, \2),/
:%s/phy_write(0x01ce) <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)\n.* <- \(.*\)/\t\tPHYREGS(\1, \2, \3, \4, \5, \6),/
:%s/ read32 0x.....160 -> 0x00010028\nwrite16 0x.....164 <- \(.*\)/\t\t.freq\t\t\t= \1/
:wq
grep -P "\t" 43217-channels-1.txt > 43217-channels-2.txt
vim 43217-channels-2.txt
:%s/\(.*freq\)/\t{\r\1/
:%s/\(PHYREGS.*\)/\1\r\t},/
:wq

Inittable was extracted from the following part of dump:
>>> b43_radio_init2057_pre end
radio_write(0x0011) <- 0x00fc
radio_write(0x0030) <- 0x0024
radio_write(0x0040) <- 0x001c
radio_write(0x0082) <- 0x0008
radio_write(0x00b4) <- 0x0044
radio_write(0x00c8) <- 0x0001
radio_write(0x00c9) <- 0x0001
radio_write(0x0107) <- 0x0008
radio_write(0x014d) <- 0x0001
radio_write(0x014e) <- 0x0001
radio_write(0x01af) <- 0x0040
radio_write(0x01b0) <- 0x0040
radio_write(0x01cc) <- 0x0001
radio_write(0x01cf) <- 0x0010
radio_write(0x01d0) <- 0x000f
radio_write(0x01d3) <- 0x0010
radio_write(0x01d4) <- 0x000f
---
 drivers/net/wireless/b43/phy_n.c       |  12 +++-
 drivers/net/wireless/b43/radio_2057.c  | 103 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/tables_nphy.c |  40 +++++++++++++
 3 files changed, 152 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 479cda8..3da02ff 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -765,7 +765,12 @@ static void b43_radio_2057_setup(struct b43_wldev *dev,
 			}
 		}
 		break;
-	/* TODO */
+	case 14: /* 2 GHz only */
+		b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_R1, 0x1b);
+		b43_radio_write(dev, R2057_CP_KPD_IDAC, 0x3f);
+		b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C1, 0x1f);
+		b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C2, 0x1f);
+		break;
 	}
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
@@ -778,8 +783,11 @@ static void b43_radio_2057_setup(struct b43_wldev *dev,
 				txmix2g_tune_boost_pu = 0x0041;
 				/* TODO */
 				break;
+			case 14:
+				txmix2g_tune_boost_pu = 0x21;
+				pad2g_tune_pus = 0x23;
+				break;
 			}
-			/* TODO */
 		}
 
 		if (txmix2g_tune_boost_pu)
diff --git a/drivers/net/wireless/b43/radio_2057.c b/drivers/net/wireless/b43/radio_2057.c
index c9c24b6..ff1e026 100644
--- a/drivers/net/wireless/b43/radio_2057.c
+++ b/drivers/net/wireless/b43/radio_2057.c
@@ -117,6 +117,15 @@ static u16 r2057_rev9_init[][2] = {
 	{ 0x14e, 0x01 }, { 0x1b7, 0x05 }, { 0x1c2, 0xa0 },
 };
 
+/* Extracted from MMIO dump of 6.30.223.248 */
+static u16 r2057_rev14_init[][2] = {
+	{ 0x011, 0xfc }, { 0x030, 0x24 }, { 0x040, 0x1c }, { 0x082, 0x08 },
+	{ 0x0b4, 0x44 }, { 0x0c8, 0x01 }, { 0x0c9, 0x01 }, { 0x107, 0x08 },
+	{ 0x14d, 0x01 }, { 0x14e, 0x01 }, { 0x1af, 0x40 }, { 0x1b0, 0x40 },
+	{ 0x1cc, 0x01 }, { 0x1cf, 0x10 }, { 0x1d0, 0x0f }, { 0x1d3, 0x10 },
+	{ 0x1d4, 0x0f },
+};
+
 #define RADIOREGS7(r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, \
 		   r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, \
 		   r20, r21, r22, r23, r24, r25, r26, r27) \
@@ -280,6 +289,87 @@ static const struct b43_nphy_chantabent_rev7_2g b43_nphy_chantab_phy_rev8_radio_
 	}
 };
 
+/* Extracted from MMIO dump of 6.30.223.248 */
+static const struct b43_nphy_chantabent_rev7_2g b43_nphy_chantab_phy_rev17_radio_rev14[] = {
+	{
+		.freq			= 2412,
+		RADIOREGS7_2G(0x48, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x6c,
+			      0x09, 0x0d, 0x09, 0x03, 0x21, 0x53, 0xff, 0x21,
+			      0x53, 0xff),
+		PHYREGS(0x03c9, 0x03c5, 0x03c1, 0x043a, 0x043f, 0x0443),
+	},
+	{
+		.freq			= 2417,
+		RADIOREGS7_2G(0x4b, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x71,
+			      0x09, 0x0d, 0x08, 0x03, 0x21, 0x53, 0xff, 0x21,
+			      0x53, 0xff),
+		PHYREGS(0x03cb, 0x03c7, 0x03c3, 0x0438, 0x043d, 0x0441),
+	},
+	{
+		.freq			= 2422,
+		RADIOREGS7_2G(0x4e, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x76,
+			      0x09, 0x0d, 0x08, 0x03, 0x21, 0x53, 0xff, 0x21,
+			      0x53, 0xff),
+		PHYREGS(0x03cd, 0x03c9, 0x03c5, 0x0436, 0x043a, 0x043f),
+	},
+	{
+		.freq			= 2427,
+		RADIOREGS7_2G(0x52, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x7b,
+			      0x09, 0x0c, 0x08, 0x03, 0x21, 0x53, 0xff, 0x21,
+			      0x53, 0xff),
+		PHYREGS(0x03cf, 0x03cb, 0x03c7, 0x0434, 0x0438, 0x043d),
+	},
+	{
+		.freq			= 2432,
+		RADIOREGS7_2G(0x55, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x80,
+			      0x09, 0x0c, 0x08, 0x03, 0x21, 0x53, 0xff, 0x21,
+			      0x53, 0xff),
+		PHYREGS(0x03d1, 0x03cd, 0x03c9, 0x0431, 0x0436, 0x043a),
+	},
+	{
+		.freq			= 2437,
+		RADIOREGS7_2G(0x58, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x85,
+			      0x09, 0x0c, 0x08, 0x03, 0x21, 0x53, 0xff, 0x21,
+			      0x53, 0xff),
+		PHYREGS(0x03d3, 0x03cf, 0x03cb, 0x042f, 0x0434, 0x0438),
+	},
+	{
+		.freq			= 2442,
+		RADIOREGS7_2G(0x5c, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x8a,
+			      0x09, 0x0c, 0x08, 0x03, 0x21, 0x43, 0xff, 0x21,
+			      0x43, 0xff),
+		PHYREGS(0x03d5, 0x03d1, 0x03cd, 0x042d, 0x0431, 0x0436),
+	},
+	{
+		.freq			= 2447,
+		RADIOREGS7_2G(0x5f, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x8f,
+			      0x09, 0x0c, 0x08, 0x03, 0x21, 0x43, 0xff, 0x21,
+			      0x43, 0xff),
+		PHYREGS(0x03d7, 0x03d3, 0x03cf, 0x042b, 0x042f, 0x0434),
+	},
+	{
+		.freq			= 2452,
+		RADIOREGS7_2G(0x62, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x94,
+			      0x09, 0x0c, 0x08, 0x03, 0x21, 0x43, 0xff, 0x21,
+			      0x43, 0xff),
+		PHYREGS(0x03d9, 0x03d5, 0x03d1, 0x0429, 0x042d, 0x0431),
+	},
+	{
+		.freq			= 2457,
+		RADIOREGS7_2G(0x66, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x99,
+			      0x09, 0x0b, 0x07, 0x03, 0x21, 0x43, 0xff, 0x21,
+			      0x43, 0xff),
+		PHYREGS(0x03db, 0x03d7, 0x03d3, 0x0427, 0x042b, 0x042f),
+	},
+	{
+		.freq			= 2462,
+		RADIOREGS7_2G(0x69, 0x16, 0x30, 0x2b, 0x1f, 0x1f, 0x30, 0x9e,
+			      0x09, 0x0b, 0x07, 0x03, 0x01, 0x43, 0xff, 0x01,
+			      0x43, 0xff),
+		PHYREGS(0x03dd, 0x03d9, 0x03d5, 0x0424, 0x0429, 0x042d),
+	},
+};
+
 /* Extracted from MMIO dump of 6.30.223.141 */
 static const struct b43_nphy_chantabent_rev7 b43_nphy_chantab_phy_rev16_radio_rev9[] = {
 	{
@@ -476,6 +566,12 @@ void r2057_upload_inittabs(struct b43_wldev *dev)
 			size = ARRAY_SIZE(r2057_rev9_init);
 		}
 		break;
+	case 17:
+		if (phy->radio_rev == 14) {
+			table = r2057_rev14_init[0];
+			size = ARRAY_SIZE(r2057_rev14_init);
+		}
+		break;
 	}
 
 	B43_WARN_ON(!table);
@@ -498,7 +594,6 @@ void r2057_get_chantabent_rev7(struct b43_wldev *dev, u16 freq,
 	*tabent_r7 = NULL;
 	*tabent_r7_2g = NULL;
 
-	/* TODO */
 	switch (phy->rev) {
 	case 8:
 		if (phy->radio_rev == 5) {
@@ -512,6 +607,12 @@ void r2057_get_chantabent_rev7(struct b43_wldev *dev, u16 freq,
 			len = ARRAY_SIZE(b43_nphy_chantab_phy_rev16_radio_rev9);
 		}
 		break;
+	case 17:
+		if (phy->radio_rev == 14) {
+			e_r7_2g = b43_nphy_chantab_phy_rev17_radio_rev14;
+			len = ARRAY_SIZE(b43_nphy_chantab_phy_rev17_radio_rev14);
+		}
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index b39a8dd..ab27c2d 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2764,6 +2764,42 @@ static const u32 b43_ntab_tx_gain_ipa_2057_rev9_2g[] = {
 	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
 };
 
+/* Extracted from MMIO dump of 6.30.223.248 */
+static const u32 b43_ntab_tx_gain_ipa_2057_rev14_2g[] = {
+	0x50df002e, 0x50cf002d, 0x50bf002c, 0x50b7002b,
+	0x50af002a, 0x50a70029, 0x509f0029, 0x50970028,
+	0x508f0027, 0x50870027, 0x507f0027, 0x50770027,
+	0x506f0027, 0x50670027, 0x505f0028, 0x50570029,
+	0x504f002b, 0x5047002e, 0x5047002b, 0x50470029,
+	0x503f002c, 0x503f0029, 0x5037002c, 0x5037002a,
+	0x50370028, 0x502f002d, 0x502f002b, 0x502f0028,
+	0x502f0026, 0x5027002d, 0x5027002a, 0x50270028,
+	0x50270026, 0x50270024, 0x501f002e, 0x501f002b,
+	0x501f0029, 0x501f0027, 0x501f0024, 0x501f0022,
+	0x501f0020, 0x501f001f, 0x5017002c, 0x50170029,
+	0x50170027, 0x50170024, 0x50170022, 0x50170021,
+	0x5017001f, 0x5017001d, 0x5017001b, 0x5017001a,
+	0x50170018, 0x50170017, 0x50170015, 0x500f002c,
+	0x500f002a, 0x500f0027, 0x500f0025, 0x500f0023,
+	0x500f0022, 0x500f001f, 0x500f001e, 0x500f001c,
+	0x500f001a, 0x500f0019, 0x500f0018, 0x500f0016,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+	0x500f0015, 0x500f0015, 0x500f0015, 0x500f0015,
+};
+
 /* IPA 2 5Hz */
 
 static const u32 b43_ntab_tx_gain_ipa_rev3_5g[] = {
@@ -3583,6 +3619,10 @@ static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		switch (phy->rev) {
+		case 17:
+			if (phy->radio_rev == 14)
+				return b43_ntab_tx_gain_ipa_2057_rev14_2g;
+			break;
 		case 16:
 			if (phy->radio_rev == 9)
 				return b43_ntab_tx_gain_ipa_2057_rev9_2g;
-- 
1.8.4.5

