Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39281 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1HaVee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 17:34:34 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so788832ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:34:33 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 6/6] b43: LCN-PHY: add conditions for few operations
Date: Wed, 31 Aug 2011 23:36:21 +0200
Message-Id: <1314826581-27852-6-git-send-email-zajec5@gmail.com> (sfid-20110831_233441_895873_AE674D3F)
In-Reply-To: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
References: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was not possible to guess the conditions from MMIO dumps. Take them
from brcmsmac code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c        |   44 ++++++++++++++++++++--------
 drivers/net/wireless/b43/tables_phy_lcn.c |    8 ++++-
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index b461278..d0f106e 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -39,6 +39,7 @@ static void b43_radio_2064_channel_setup(struct b43_wldev *dev)
 	b43_radio_set(dev, 0x09d, 0x4);
 	b43_radio_write(dev, 0x09e, 0xf);
 
+	/* Channel specific values in theory, in practice always the same */
 	b43_radio_write(dev, 0x02a, 0xb);
 	b43_radio_maskset(dev, 0x030, ~0x3, 0xa);
 	b43_radio_maskset(dev, 0x091, ~0x3, 0);
@@ -70,22 +71,31 @@ static void b43_radio_2064_channel_setup(struct b43_wldev *dev)
 	b43_radio_write(dev, 0x044, save[0]);
 	b43_radio_write(dev, 0x12b, save[1]);
 
-	b43_radio_write(dev, 0x038, 0x0);
-	b43_radio_write(dev, 0x091, 0x7);
+	if (dev->phy.rev == 1) {
+		/* brcmsmac uses outdated 0x3 for 0x038 */
+		b43_radio_write(dev, 0x038, 0x0);
+		b43_radio_write(dev, 0x091, 0x7);
+	}
 }
 
 /* wlc_radio_2064_init */
 static void b43_radio_2064_init(struct b43_wldev *dev)
 {
-	b43_radio_write(dev, 0x09c, 0x0020);
-	b43_radio_write(dev, 0x105, 0x0008);
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		b43_radio_write(dev, 0x09c, 0x0020);
+		b43_radio_write(dev, 0x105, 0x0008);
+	} else {
+		/* TODO */
+	}
 	b43_radio_write(dev, 0x032, 0x0062);
 	b43_radio_write(dev, 0x033, 0x0019);
 	b43_radio_write(dev, 0x090, 0x0010);
 	b43_radio_write(dev, 0x010, 0x0000);
-	b43_radio_write(dev, 0x060, 0x007f);
-	b43_radio_write(dev, 0x061, 0x0072);
-	b43_radio_write(dev, 0x062, 0x007f);
+	if (dev->phy.rev == 1) {
+		b43_radio_write(dev, 0x060, 0x007f);
+		b43_radio_write(dev, 0x061, 0x0072);
+		b43_radio_write(dev, 0x062, 0x007f);
+	}
 	b43_radio_write(dev, 0x01d, 0x0002);
 	b43_radio_write(dev, 0x01e, 0x0006);
 
@@ -145,10 +155,12 @@ static void b43_phy_lcn_clear_tx_power_offsets(struct b43_wldev *dev)
 {
 	u8 i;
 
-	b43_phy_write(dev, B43_PHY_LCN_TABLE_ADDR, (0x7 << 10) | 0x340);
-	for (i = 0; i < 30; i++) {
-		b43_phy_write(dev, B43_PHY_LCN_TABLE_DATAHI, 0);
-		b43_phy_write(dev, B43_PHY_LCN_TABLE_DATALO, 0);
+	if (1) { /* FIXME */
+		b43_phy_write(dev, B43_PHY_LCN_TABLE_ADDR, (0x7 << 10) | 0x340);
+		for (i = 0; i < 30; i++) {
+			b43_phy_write(dev, B43_PHY_LCN_TABLE_DATAHI, 0);
+			b43_phy_write(dev, B43_PHY_LCN_TABLE_DATALO, 0);
+		}
 	}
 
 	b43_phy_write(dev, B43_PHY_LCN_TABLE_ADDR, (0x7 << 10) | 0x80);
@@ -178,8 +190,13 @@ static void b43_phy_lcn_rev0_baseband_init(struct b43_wldev *dev)
 	b43_phy_set(dev, 0x44a, 0x44);
 	b43_phy_write(dev, 0x44a, 0x80);
 
+	if (!(dev->dev->bus_sprom->boardflags_lo & B43_BFL_FEM))
+		; /* TODO */
 	b43_phy_maskset(dev, 0x634, ~0xff, 0xc);
-	b43_phy_maskset(dev, 0x634, ~0xff, 0xa);
+	if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_FEM) {
+		b43_phy_maskset(dev, 0x634, ~0xff, 0xa);
+		b43_phy_write(dev, 0x910, 0x1);
+	}
 
 	b43_phy_write(dev, 0x910, 0x1);
 
@@ -207,7 +224,8 @@ static void b43_phy_lcn_bu_tweaks(struct b43_wldev *dev)
 	b43_phy_maskset(dev, 0x434, ~0xff, 0xfd);
 	b43_phy_maskset(dev, 0x420, ~0xff, 0x10);
 
-	b43_radio_set(dev, 0x09b, 0xf0);
+	if (dev->dev->bus_sprom->board_rev >= 0x1204)
+		b43_radio_set(dev, 0x09b, 0xf0);
 
 	b43_phy_write(dev, 0x7d6, 0x0902);
 
diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
index c62a940..7bf7057 100644
--- a/drivers/net/wireless/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -501,9 +501,15 @@ void b43_phy_lcn_tables_init(struct b43_wldev *dev)
 {
 	b43_phy_lcn_upload_static_tables(dev);
 	/* TODO: various tables ops here */
-	b43_lcntab_write_bulk(dev, B43_LCNTAB16(0xf, 0),
+
+	if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_FEM &&
+	    !(dev->dev->bus_sprom->boardflags_hi & B43_BFH_FEM_BT))
+		b43_lcntab_write_bulk(dev, B43_LCNTAB16(0xf, 0),
 			ARRAY_SIZE(b43_lcntab_sw_ctl_4313_epa_rev0),
 			b43_lcntab_sw_ctl_4313_epa_rev0);
+	else
+		b43err(dev->wl, "SW ctl table is unknown for this card\n");
+
 	/* TODO: various tables ops here */
 	b43_phy_lcn_rewrite_tables(dev);
 	b43_phy_lcn_clean_papd_comp_table(dev);
-- 
1.7.3.4

