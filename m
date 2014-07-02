Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37132 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaGBPFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 11:05:55 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so665333wib.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2014 08:05:47 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: initialize hardware tables on new devices
Date: Wed,  2 Jul 2014 17:05:35 +0200
Message-Id: <1404313535-11814-1-git-send-email-zajec5@gmail.com> (sfid-20140702_170559_849978_1CDA9FC0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Init of volatile table is based on the following dump from 6.30.223.141:
phy_write(0x0072) <- 0x2400
phy_write(0x0073) <- 0x0002
phy_write(0x0072) <- 0x2404
phy_write(0x0073) <- 0x0012
phy_write(0x0072) <- 0x2408
phy_write(0x0073) <- 0x0008
phy_write(0x0072) <- 0x2420
phy_write(0x0073) <- 0x0002
phy_write(0x0072) <- 0x2424
phy_write(0x0073) <- 0x0018
phy_write(0x0072) <- 0x2428
phy_write(0x0073) <- 0x0002
---
 drivers/net/wireless/b43/tables_nphy.c | 288 +++++++++++++++++++++++++++++++--
 drivers/net/wireless/b43/tables_nphy.h |   4 +
 2 files changed, 281 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index b221715..dd87685 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2146,6 +2146,192 @@ static const u16 b43_ntab_antswctl_r3[4][32] = {
 	}
 };
 
+/* static tables, PHY revision >= 7 */
+
+/* Copied from brcmsmac (5.75.11) */
+static const u32 b43_ntab_tmap_r7[] = {
+	0x8a88aa80, 0x8aaaaa8a, 0x8a8a8aa8, 0x00000888,
+	0x88000000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0xf1111110, 0x11111111, 0x11f11111, 0x00000111,
+	0x11000000, 0x1111f111, 0x11111111, 0x111111f1,
+	0x8a88aa80, 0x8aaaaa8a, 0x8a8a8aa8, 0x000aa888,
+	0x88880000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0xa1111110, 0x11111111, 0x11c11111, 0x00000111,
+	0x11000000, 0x1111a111, 0x11111111, 0x111111a1,
+	0xa2222220, 0x22222222, 0x22c22222, 0x00000222,
+	0x22000000, 0x2222a222, 0x22222222, 0x222222a2,
+	0xf1111110, 0x11111111, 0x11f11111, 0x00011111,
+	0x11110000, 0x1111f111, 0x11111111, 0x111111f1,
+	0xa8aa88a0, 0xa88888a8, 0xa8a8a88a, 0x00088aaa,
+	0xaaaa0000, 0xa8a8aa88, 0xa88aaaaa, 0xaaaa8a8a,
+	0xaaa8aaa0, 0x8aaa8aaa, 0xaa8a8a8a, 0x000aaa88,
+	0x8aaa0000, 0xaaa8a888, 0x8aa88a8a, 0x8a88a888,
+	0x08080a00, 0x0a08080a, 0x080a0a08, 0x00080808,
+	0x080a0000, 0x080a0808, 0x080a0808, 0x0a0a0a08,
+	0xa0a0a0a0, 0x80a0a080, 0x8080a0a0, 0x00008080,
+	0x80a00000, 0x80a080a0, 0xa080a0a0, 0x8080a0a0,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x99999000, 0x9b9b99bb, 0x9bb99999, 0x9999b9b9,
+	0x9b99bb90, 0x9bbbbb9b, 0x9b9b9bb9, 0x00000999,
+	0x88000000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa80, 0x8aaaaa8a, 0x8a8a8aa8, 0x00aaa888,
+	0x22000000, 0x2222b222, 0x22222222, 0x222222b2,
+	0xb2222220, 0x22222222, 0x22d22222, 0x00000222,
+	0x11000000, 0x1111a111, 0x11111111, 0x111111a1,
+	0xa1111110, 0x11111111, 0x11c11111, 0x00000111,
+	0x33000000, 0x3333b333, 0x33333333, 0x333333b3,
+	0xb3333330, 0x33333333, 0x33d33333, 0x00000333,
+	0x22000000, 0x2222a222, 0x22222222, 0x222222a2,
+	0xa2222220, 0x22222222, 0x22c22222, 0x00000222,
+	0x99b99b00, 0x9b9b99bb, 0x9bb99999, 0x9999b9b9,
+	0x9b99bb99, 0x9bbbbb9b, 0x9b9b9bb9, 0x00000999,
+	0x88000000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa88, 0x8aaaaa8a, 0x8a8a8aa8, 0x08aaa888,
+	0x22222200, 0x2222f222, 0x22222222, 0x222222f2,
+	0x22222222, 0x22222222, 0x22f22222, 0x00000222,
+	0x11000000, 0x1111f111, 0x11111111, 0x11111111,
+	0xf1111111, 0x11111111, 0x11f11111, 0x01111111,
+	0xbb9bb900, 0xb9b9bb99, 0xb99bbbbb, 0xbbbb9b9b,
+	0xb9bb99bb, 0xb99999b9, 0xb9b9b99b, 0x00000bbb,
+	0xaa000000, 0xa8a8aa88, 0xa88aaaaa, 0xaaaa8a8a,
+	0xa8aa88aa, 0xa88888a8, 0xa8a8a88a, 0x0a888aaa,
+	0xaa000000, 0xa8a8aa88, 0xa88aaaaa, 0xaaaa8a8a,
+	0xa8aa88a0, 0xa88888a8, 0xa8a8a88a, 0x00000aaa,
+	0x88000000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa80, 0x8aaaaa8a, 0x8a8a8aa8, 0x00000888,
+	0xbbbbbb00, 0x999bbbbb, 0x9bb99b9b, 0xb9b9b9bb,
+	0xb9b99bbb, 0xb9b9b9bb, 0xb9bb9b99, 0x00000999,
+	0x8a000000, 0xaa88a888, 0xa88888aa, 0xa88a8a88,
+	0xa88aa88a, 0x88a8aaaa, 0xa8aa8aaa, 0x0888a88a,
+	0x0b0b0b00, 0x090b0b0b, 0x0b090b0b, 0x0909090b,
+	0x09090b0b, 0x09090b0b, 0x09090b09, 0x00000909,
+	0x0a000000, 0x0a080808, 0x080a080a, 0x080a0a08,
+	0x080a080a, 0x0808080a, 0x0a0a0a08, 0x0808080a,
+	0xb0b0b000, 0x9090b0b0, 0x90b09090, 0xb0b0b090,
+	0xb0b090b0, 0x90b0b0b0, 0xb0b09090, 0x00000090,
+	0x80000000, 0xa080a080, 0xa08080a0, 0xa0808080,
+	0xa080a080, 0x80a0a0a0, 0xa0a080a0, 0x00a0a0a0,
+	0x22000000, 0x2222f222, 0x22222222, 0x222222f2,
+	0xf2222220, 0x22222222, 0x22f22222, 0x00000222,
+	0x11000000, 0x1111f111, 0x11111111, 0x111111f1,
+	0xf1111110, 0x11111111, 0x11f11111, 0x00000111,
+	0x33000000, 0x3333f333, 0x33333333, 0x333333f3,
+	0xf3333330, 0x33333333, 0x33f33333, 0x00000333,
+	0x22000000, 0x2222f222, 0x22222222, 0x222222f2,
+	0xf2222220, 0x22222222, 0x22f22222, 0x00000222,
+	0x99000000, 0x9b9b99bb, 0x9bb99999, 0x9999b9b9,
+	0x9b99bb90, 0x9bbbbb9b, 0x9b9b9bb9, 0x00000999,
+	0x88000000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa80, 0x8aaaaa8a, 0x8a8a8aa8, 0x00000888,
+	0x88888000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa80, 0x8aaaaa8a, 0x8a8a8aa8, 0x00000888,
+	0x88000000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa80, 0x8aaaaa8a, 0x8a8a8aa8, 0x00aaa888,
+	0x88a88a00, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa88, 0x8aaaaa8a, 0x8a8a8aa8, 0x000aa888,
+	0x88880000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa88, 0x8aaaaa8a, 0x8a8a8aa8, 0x08aaa888,
+	0x11000000, 0x1111a111, 0x11111111, 0x111111a1,
+	0xa1111110, 0x11111111, 0x11c11111, 0x00000111,
+	0x11000000, 0x1111a111, 0x11111111, 0x111111a1,
+	0xa1111110, 0x11111111, 0x11c11111, 0x00000111,
+	0x88000000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa80, 0x8aaaaa8a, 0x8a8a8aa8, 0x00000888,
+	0x88000000, 0x8a8a88aa, 0x8aa88888, 0x8888a8a8,
+	0x8a88aa80, 0x8aaaaa8a, 0x8a8a8aa8, 0x00000888,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Extracted from MMIO dump of 6.30.223.141 */
+static const u32 b43_ntab_noisevar_r7[] = {
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+	0x020c020c, 0x0000014d, 0x020c020c, 0x0000014d,
+};
+
 /* TX gain tables */
 static const u32 b43_ntab_tx_gain_rev0_1_2[] = {
 	0x03cc2b44, 0x03cc2b42, 0x03cc2a44, 0x03cc2a42,
@@ -3031,6 +3217,91 @@ void b43_ntab_write_bulk(struct b43_wldev *dev, u32 offset,
 		b43_ntab_write_bulk(dev, offset, ARRAY_SIZE(data), data); \
 	} while (0)
 
+static void b43_nphy_tables_init_shared_lut(struct b43_wldev *dev)
+{
+	ntab_upload(dev, B43_NTAB_C0_ESTPLT_R3, b43_ntab_estimatepowerlt0_r3);
+	ntab_upload(dev, B43_NTAB_C1_ESTPLT_R3, b43_ntab_estimatepowerlt1_r3);
+	ntab_upload(dev, B43_NTAB_C0_ADJPLT_R3, b43_ntab_adjustpower0_r3);
+	ntab_upload(dev, B43_NTAB_C1_ADJPLT_R3, b43_ntab_adjustpower1_r3);
+	ntab_upload(dev, B43_NTAB_C0_GAINCTL_R3, b43_ntab_gainctl0_r3);
+	ntab_upload(dev, B43_NTAB_C1_GAINCTL_R3, b43_ntab_gainctl1_r3);
+	ntab_upload(dev, B43_NTAB_C0_IQLT_R3, b43_ntab_iqlt0_r3);
+	ntab_upload(dev, B43_NTAB_C1_IQLT_R3, b43_ntab_iqlt1_r3);
+	ntab_upload(dev, B43_NTAB_C0_LOFEEDTH_R3, b43_ntab_loftlt0_r3);
+	ntab_upload(dev, B43_NTAB_C1_LOFEEDTH_R3, b43_ntab_loftlt1_r3);
+}
+
+static void b43_nphy_tables_init_rev7_volatile(struct b43_wldev *dev)
+{
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+	u8 antswlut;
+	int core, offset, i;
+
+	const int antswlut0_offsets[] = { 0, 4, 8, }; /* Offsets for values */
+	const u8 antswlut0_values[][3] = {
+		{ 0x2, 0x12, 0x8 }, /* Core 0 */
+		{ 0x2, 0x18, 0x2 }, /* Core 1 */
+	};
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		antswlut = sprom->fem.ghz5.antswlut;
+	else
+		antswlut = sprom->fem.ghz2.antswlut;
+
+	switch (antswlut) {
+	case 0:
+		for (core = 0; core < 2; core++) {
+			for (i = 0; i < ARRAY_SIZE(antswlut0_values[0]); i++) {
+				offset = core ? 0x20 : 0x00;
+				offset += antswlut0_offsets[i];
+				b43_ntab_write(dev, B43_NTAB8(9, offset),
+					       antswlut0_values[core][i]);
+			}
+		}
+		break;
+	default:
+		b43err(dev->wl, "Unsupported antswlut: %d\n", antswlut);
+		break;
+	}
+}
+
+static void b43_nphy_tables_init_rev16(struct b43_wldev *dev)
+{
+	/* Static tables */
+	if (dev->phy.do_full_init) {
+		ntab_upload(dev, B43_NTAB_NOISEVAR_R7, b43_ntab_noisevar_r7);
+		b43_nphy_tables_init_shared_lut(dev);
+	}
+
+	/* Volatile tables */
+	b43_nphy_tables_init_rev7_volatile(dev);
+}
+
+static void b43_nphy_tables_init_rev7(struct b43_wldev *dev)
+{
+	/* Static tables */
+	if (dev->phy.do_full_init) {
+		ntab_upload(dev, B43_NTAB_FRAMESTRUCT_R3, b43_ntab_framestruct_r3);
+		ntab_upload(dev, B43_NTAB_PILOT_R3, b43_ntab_pilot_r3);
+		ntab_upload(dev, B43_NTAB_TMAP_R7, b43_ntab_tmap_r7);
+		ntab_upload(dev, B43_NTAB_INTLEVEL_R3, b43_ntab_intlevel_r3);
+		ntab_upload(dev, B43_NTAB_TDTRN_R3, b43_ntab_tdtrn_r3);
+		ntab_upload(dev, B43_NTAB_NOISEVAR_R7, b43_ntab_noisevar_r7);
+		ntab_upload(dev, B43_NTAB_MCS_R3, b43_ntab_mcs_r3);
+		ntab_upload(dev, B43_NTAB_TDI20A0_R3, b43_ntab_tdi20a0_r3);
+		ntab_upload(dev, B43_NTAB_TDI20A1_R3, b43_ntab_tdi20a1_r3);
+		ntab_upload(dev, B43_NTAB_TDI40A0_R3, b43_ntab_tdi40a0_r3);
+		ntab_upload(dev, B43_NTAB_TDI40A1_R3, b43_ntab_tdi40a1_r3);
+		ntab_upload(dev, B43_NTAB_PILOTLT_R3, b43_ntab_pilotlt_r3);
+		ntab_upload(dev, B43_NTAB_CHANEST_R3, b43_ntab_channelest_r3);
+		ntab_upload(dev, B43_NTAB_FRAMELT_R3, b43_ntab_framelookup_r3);
+		b43_nphy_tables_init_shared_lut(dev);
+	}
+
+	/* Volatile tables */
+	b43_nphy_tables_init_rev7_volatile(dev);
+}
+
 static void b43_nphy_tables_init_rev3(struct b43_wldev *dev)
 {
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
@@ -3057,16 +3328,7 @@ static void b43_nphy_tables_init_rev3(struct b43_wldev *dev)
 		ntab_upload(dev, B43_NTAB_PILOTLT_R3, b43_ntab_pilotlt_r3);
 		ntab_upload(dev, B43_NTAB_CHANEST_R3, b43_ntab_channelest_r3);
 		ntab_upload(dev, B43_NTAB_FRAMELT_R3, b43_ntab_framelookup_r3);
-		ntab_upload(dev, B43_NTAB_C0_ESTPLT_R3, b43_ntab_estimatepowerlt0_r3);
-		ntab_upload(dev, B43_NTAB_C1_ESTPLT_R3, b43_ntab_estimatepowerlt1_r3);
-		ntab_upload(dev, B43_NTAB_C0_ADJPLT_R3, b43_ntab_adjustpower0_r3);
-		ntab_upload(dev, B43_NTAB_C1_ADJPLT_R3, b43_ntab_adjustpower1_r3);
-		ntab_upload(dev, B43_NTAB_C0_GAINCTL_R3, b43_ntab_gainctl0_r3);
-		ntab_upload(dev, B43_NTAB_C1_GAINCTL_R3, b43_ntab_gainctl1_r3);
-		ntab_upload(dev, B43_NTAB_C0_IQLT_R3, b43_ntab_iqlt0_r3);
-		ntab_upload(dev, B43_NTAB_C1_IQLT_R3, b43_ntab_iqlt1_r3);
-		ntab_upload(dev, B43_NTAB_C0_LOFEEDTH_R3, b43_ntab_loftlt0_r3);
-		ntab_upload(dev, B43_NTAB_C1_LOFEEDTH_R3, b43_ntab_loftlt1_r3);
+		b43_nphy_tables_init_shared_lut(dev);
 	}
 
 	/* Volatile tables */
@@ -3115,7 +3377,11 @@ static void b43_nphy_tables_init_rev0(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables */
 void b43_nphy_tables_init(struct b43_wldev *dev)
 {
-	if (dev->phy.rev >= 3)
+	if (dev->phy.rev >= 16)
+		b43_nphy_tables_init_rev16(dev);
+	else if (dev->phy.rev >= 7)
+		b43_nphy_tables_init_rev7(dev);
+	else if (dev->phy.rev >= 3)
 		b43_nphy_tables_init_rev3(dev);
 	else
 		b43_nphy_tables_init_rev0(dev);
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 3a58aee..3ce2e6f 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -165,6 +165,10 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 #define B43_NTAB_C1_LOFEEDTH_R3		B43_NTAB16(27, 448) /* Local Oscillator Feed Through lookup 1 */
 #define B43_NTAB_C1_PAPD_COMP_R3	B43_NTAB16(27, 576)
 
+/* Static N-PHY tables, PHY revision >= 7 */
+#define B43_NTAB_TMAP_R7		B43_NTAB32(12,   0) /* TM AP */
+#define B43_NTAB_NOISEVAR_R7		B43_NTAB32(16,   0) /* noise variance */
+
 #define B43_NTAB_TX_IQLO_CAL_LOFT_LADDER_40_SIZE	18
 #define B43_NTAB_TX_IQLO_CAL_LOFT_LADDER_20_SIZE	18
 #define B43_NTAB_TX_IQLO_CAL_IQIMB_LADDER_40_SIZE	18
-- 
1.8.4.5

