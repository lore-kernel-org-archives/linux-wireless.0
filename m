Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63652 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1LUXGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 18:06:10 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so7959769eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 15:06:10 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: N-PHY: update gain ctl workarounds
Date: Thu, 22 Dec 2011 00:47:17 +0100
Message-Id: <1324511239-3536-2-git-send-email-zajec5@gmail.com> (sfid-20111222_000615_752351_A371BA16)
In-Reply-To: <1324511239-3536-1-git-send-email-zajec5@gmail.com>
References: <1324511239-3536-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specs were updated, now we match wl according to MMIO dumps.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       |    4 +-
 drivers/net/wireless/b43/tables_nphy.c |  106 +++++++++++++++++++++++++++-----
 2 files changed, 92 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d3222b8..38cf37d 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1511,7 +1511,8 @@ static void b43_nphy_gain_ctl_workarounds_rev3plus(struct b43_wldev *dev)
 	/* Prepare values */
 	ghz5 = b43_phy_read(dev, B43_NPHY_BANDCTL)
 		& B43_NPHY_BANDCTL_5GHZ;
-	ext_lna = sprom->boardflags_lo & B43_BFL_EXTLNA;
+	ext_lna = ghz5 ? sprom->boardflags_hi & B43_BFH_EXTLNA_5GHZ :
+		sprom->boardflags_lo & B43_BFL_EXTLNA;
 	e = b43_nphy_get_gain_ctl_workaround_ent(dev, ghz5, ext_lna);
 	if (ghz5 && dev->phy.rev >= 5)
 		rssi_gain = 0x90;
@@ -1562,7 +1563,6 @@ static void b43_nphy_gain_ctl_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x2A7, e->init_gain);
 	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x106), 2,
 				e->rfseq_init);
-	b43_phy_write(dev, B43_NPHY_C1_INITGAIN, e->init_gain);
 
 	/* TODO: check defines. Do not match variables names */
 	b43_phy_write(dev, B43_NPHY_C1_CLIP1_MEDGAIN, e->cliphi_gain);
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 3252560..f7def135 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2752,7 +2752,18 @@ const struct nphy_rf_control_override_rev3 tbl_rf_control_override_rev3[] = {
 	{ 0x00C0,  6, 0xE7, 0xF9, 0xEC, 0xFB }  /* field == 0x4000 (fls 15) */
 };
 
-struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_workaround[2][3] = {
+struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_wa_phy6_radio11_ghz2 = {
+	{ 10, 14, 19, 27 },
+	{ -5, 6, 10, 15 },
+	{ 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA },
+	{ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 },
+	0x427E,
+	{ 0x413F, 0x413F, 0x413F, 0x413F },
+	0x007E, 0x0066, 0x1074,
+	0x18, 0x18, 0x18,
+	0x01D0, 0x5,
+};
+struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_workaround[2][4] = {
 	{ /* 2GHz */
 		{ /* PHY rev 3 */
 			{ 7, 11, 16, 23 },
@@ -2776,15 +2787,26 @@ struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_workaround[2][3] = {
 			0x18, 0x18, 0x18,
 			0x01A1, 0x5,
 		},
-		{ /* PHY rev 5+ */
+		{ /* PHY rev 5 */
 			{ 9, 13, 18, 26 },
 			{ -3, 7, 11, 16 },
 			{ 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA },
 			{ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 },
 			0x427E, /* invalid for external LNA! */
 			{ 0x413F, 0x413F, 0x413F, 0x413F }, /* invalid for external LNA! */
-			0x1076, 0x0066, 0x106A,
-			0xC, 0xC, 0xC,
+			0x1076, 0x0066, 0x0000, /* low is invalid (the last one) */
+			0x18, 0x18, 0x18,
+			0x01D0, 0x9,
+		},
+		{ /* PHY rev 6+ */
+			{ 8, 13, 18, 25 },
+			{ -5, 6, 10, 14 },
+			{ 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA },
+			{ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 },
+			0x527E, /* invalid for external LNA! */
+			{ 0x513F, 0x513F, 0x513F, 0x513F }, /* invalid for external LNA! */
+			0x1076, 0x0066, 0x0000, /* low is invalid (the last one) */
+			0x18, 0x18, 0x18,
 			0x01D0, 0x5,
 		},
 	},
@@ -2811,7 +2833,7 @@ struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_workaround[2][3] = {
 			0x24, 0x24, 0x24,
 			0x0107, 25,
 		},
-		{ /* PHY rev 5+ */
+		{ /* PHY rev 5 */
 			{ 6, 10, 16, 21 },
 			{ -7, 0, 4, 8 },
 			{ 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD },
@@ -2822,6 +2844,17 @@ struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_workaround[2][3] = {
 			0x24, 0x24, 0x24,
 			0x00A9, 25,
 		},
+		{ /* PHY rev 6+ */
+			{ 6, 10, 16, 21 },
+			{ -7, 0, 4, 8 },
+			{ 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD },
+			{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 },
+			0x729E,
+			{ 0x714F, 0x714F, 0x714F, 0x714F },
+			0x029E, 0x2084, 0x2086,
+			0x24, 0x24, 0x24, /* low is invalid for radio rev 11! */
+			0x00F0, 25,
+		},
 	},
 };
 
@@ -3098,26 +3131,67 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 {
 	struct nphy_gain_ctl_workaround_entry *e;
 	u8 phy_idx;
+	u8 tr_iso = ghz5 ? dev->dev->bus_sprom->fem.ghz5.tr_iso :
+			   dev->dev->bus_sprom->fem.ghz2.tr_iso;
+
+	if (!ghz5 && dev->phy.rev >= 6 && dev->phy.radio_rev == 11)
+		return &nphy_gain_ctl_wa_phy6_radio11_ghz2;
 
 	B43_WARN_ON(dev->phy.rev < 3);
-	if (dev->phy.rev >= 5)
+	if (dev->phy.rev >= 6)
+		phy_idx = 3;
+	else if (dev->phy.rev == 5)
 		phy_idx = 2;
 	else if (dev->phy.rev == 4)
 		phy_idx = 1;
 	else
 		phy_idx = 0;
-
 	e = &nphy_gain_ctl_workaround[ghz5][phy_idx];
 
-	/* Only one entry differs for external LNA, so instead making whole
-	 * table 2 times bigger, hack is here
-	 */
-	if (!ghz5 && dev->phy.rev >= 5 && ext_lna) {
-		e->rfseq_init[0] &= 0x0FFF;
-		e->rfseq_init[1] &= 0x0FFF;
-		e->rfseq_init[2] &= 0x0FFF;
-		e->rfseq_init[3] &= 0x0FFF;
-		e->init_gain &= 0x0FFF;
+	/* Some workarounds to the workarounds... */
+	if (ghz5 && dev->phy.rev >= 6) {
+		if (dev->phy.radio_rev == 11 &&
+		    !b43_channel_type_is_40mhz(dev->phy.channel_type))
+			e->cliplo_gain = 0x2d;
+	} else if (!ghz5 && dev->phy.rev >= 5) {
+		if (ext_lna) {
+			e->rfseq_init[0] &= ~0x4000;
+			e->rfseq_init[1] &= ~0x4000;
+			e->rfseq_init[2] &= ~0x4000;
+			e->rfseq_init[3] &= ~0x4000;
+			e->init_gain &= ~0x4000;
+		}
+		switch (tr_iso) {
+		case 0:
+			e->cliplo_gain = 0x0062;
+		case 1:
+			e->cliplo_gain = 0x0064;
+		case 2:
+			e->cliplo_gain = 0x006a;
+		case 3:
+			e->cliplo_gain = 0x106a;
+		case 4:
+			e->cliplo_gain = 0x106c;
+		case 5:
+			e->cliplo_gain = 0x1074;
+		case 6:
+			e->cliplo_gain = 0x107c;
+		case 7:
+			e->cliplo_gain = 0x207c;
+		default:
+			e->cliplo_gain = 0x106a;
+		}
+	} else if (ghz5 && dev->phy.rev == 4 && ext_lna) {
+		e->rfseq_init[0] &= ~0x4000;
+		e->rfseq_init[1] &= ~0x4000;
+		e->rfseq_init[2] &= ~0x4000;
+		e->rfseq_init[3] &= ~0x4000;
+		e->init_gain &= ~0x4000;
+		e->rfseq_init[0] |= 0x1000;
+		e->rfseq_init[1] |= 0x1000;
+		e->rfseq_init[2] |= 0x1000;
+		e->rfseq_init[3] |= 0x1000;
+		e->init_gain |= 0x1000;
 	}
 
 	return e;
-- 
1.7.3.4

