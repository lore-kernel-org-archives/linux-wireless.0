Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36520 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2ACVIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 16:08:07 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so16211505eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 13:08:07 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/5] b43: N-PHY: upload PAPD PGA gain delta table
Date: Tue,  3 Jan 2012 22:49:19 +0100
Message-Id: <1325627361-3394-3-git-send-email-zajec5@gmail.com> (sfid-20120103_220813_636207_6C61BDC0)
In-Reply-To: <1325627361-3394-1-git-send-email-zajec5@gmail.com>
References: <1325627361-3394-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       |   11 +++++------
 drivers/net/wireless/b43/tables_nphy.c |    5 +++++
 drivers/net/wireless/b43/tables_nphy.h |    2 ++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1e499f0..c4c310d 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2607,12 +2607,9 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 	struct b43_phy *phy = &dev->phy;
 
 	const u32 *table = NULL;
-#if 0
-	TODO: b43_ntab_papd_pga_gain_delta_ipa_2*
 	u32 rfpwr_offset;
 	u8 pga_gain;
 	int i;
-#endif
 
 	table = b43_nphy_get_tx_gain_table(dev);
 	b43_ntab_write_bulk(dev, B43_NTAB32(26, 192), 128, table);
@@ -2621,19 +2618,21 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 	if (phy->rev >= 3) {
 #if 0
 		nphy->gmval = (table[0] >> 16) & 0x7000;
+#endif
 
 		for (i = 0; i < 128; i++) {
 			pga_gain = (table[i] >> 24) & 0xF;
 			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-				rfpwr_offset = b43_ntab_papd_pga_gain_delta_ipa_2g[pga_gain];
+				rfpwr_offset =
+				 b43_ntab_papd_pga_gain_delta_ipa_2g[pga_gain];
 			else
-				rfpwr_offset = b43_ntab_papd_pga_gain_delta_ipa_5g[pga_gain];
+				rfpwr_offset =
+				 0; /* FIXME */
 			b43_ntab_write(dev, B43_NTAB32(26, 576 + i),
 				       rfpwr_offset);
 			b43_ntab_write(dev, B43_NTAB32(27, 576 + i),
 				       rfpwr_offset);
 		}
-#endif
 	}
 }
 
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index dc52249..44d49f7 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2529,6 +2529,11 @@ static const u32 txpwrctrl_tx_gain_ipa_5g[] = {
 	0x70f70021, 0x70f70020, 0x70f70020, 0x70f7001f,
 };
 
+const s8 b43_ntab_papd_pga_gain_delta_ipa_2g[] = {
+	-114, -108, -98, -91, -84, -78, -70, -62,
+	-54, -46, -39, -31, -23, -15, -8, 0
+};
+
 const u16 tbl_iqcal_gainparams[2][9][8] = {
 	{
 		{ 0x000, 0, 0, 2, 0x69, 0x69, 0x69, 0x69 },
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 2a9d5f1..f348953 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -179,6 +179,8 @@ void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev);
 
 const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev);
 
+extern const s8 b43_ntab_papd_pga_gain_delta_ipa_2g[];
+
 extern const u16 tbl_iqcal_gainparams[2][9][8];
 extern const struct nphy_txiqcal_ladder ladder_lo[];
 extern const struct nphy_txiqcal_ladder ladder_iq[];
-- 
1.7.3.4

