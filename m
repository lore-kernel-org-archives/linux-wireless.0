Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63981 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1IUTEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 15:04:34 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so2223980wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 12:04:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: LCN-PHY: minor clean ups
Date: Wed, 21 Sep 2011 21:44:15 +0200
Message-Id: <1316634255-3116-3-git-send-email-zajec5@gmail.com> (sfid-20110921_210438_464349_F99F42E0)
In-Reply-To: <1316634255-3116-1-git-send-email-zajec5@gmail.com>
References: <1316634255-3116-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c        |    2 +-
 drivers/net/wireless/b43/tables_phy_lcn.c |   25 +++++++++++++++++++++----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index bffeb44..a13e28e 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -433,7 +433,7 @@ static void b43_phy_lcn_sense_setup(struct b43_wldev *dev,
 	b43_phy_set(dev, 0x4d0, 0x20);
 	b43_radio_write(dev, 0x112, 0x6);
 
-	/* TODO: dummy transmission? */
+	b43_dummy_transmission(dev, true, false);
 	/* Wait if not done */
 	if (!(b43_phy_read(dev, 0x476) & 0x8000))
 		udelay(10);
diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
index 9d484e2..5176363 100644
--- a/drivers/net/wireless/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -657,8 +657,25 @@ void b43_phy_lcn_load_tx_gain_tab(struct b43_wldev *dev,
 	}
 }
 
+/* wlc_lcnphy_load_rfpower */
+static void b43_phy_lcn_load_rfpower(struct b43_wldev *dev)
+{
+	u32 bbmult, rfgain;
+	u8 i;
+
+	for (i = 0; i < 128; i++) {
+		bbmult = b43_lcntab_read(dev, B43_LCNTAB32(0x7, 0x140 + i));
+		bbmult >>= 20;
+		rfgain = b43_lcntab_read(dev, B43_LCNTAB32(0x7, 0xc0 + i));
+
+		/* TODO: calculate value for 0x240 + i table offset
+		 * b43_lcntab_write(dev, B43_LCNTAB32(0x7, 0x240 + i), val);
+		 */
+	}
+}
+
 /* Not implemented in brcmsmac, noticed in wl in MMIO dump */
-static void b43_phy_lcn_rewrite_tables(struct b43_wldev *dev)
+static void b43_phy_lcn_rewrite_rfpower_table(struct b43_wldev *dev)
 {
 	int i;
 	u32 tmp;
@@ -685,7 +702,7 @@ void b43_phy_lcn_tables_init(struct b43_wldev *dev)
 	b43_phy_lcn_upload_static_tables(dev);
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-		if (sprom->boardflags_lo & B43_BFL_EXTLNA)
+		if (sprom->boardflags_lo & B43_BFL_FEM)
 			b43_phy_lcn_load_tx_gain_tab(dev,
 				b43_lcntab_tx_gain_tbl_2ghz_ext_pa_rev0);
 		else
@@ -701,7 +718,7 @@ void b43_phy_lcn_tables_init(struct b43_wldev *dev)
 	else
 		b43err(dev->wl, "SW ctl table is unknown for this card\n");
 
-	/* TODO: various tables ops here */
-	b43_phy_lcn_rewrite_tables(dev);
+	b43_phy_lcn_load_rfpower(dev);
+	b43_phy_lcn_rewrite_rfpower_table(dev);
 	b43_phy_lcn_clean_papd_comp_table(dev);
 }
-- 
1.7.3.4

