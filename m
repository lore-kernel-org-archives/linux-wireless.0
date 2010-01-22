Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35680 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0AVAxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 19:53:51 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so747111ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 16:53:50 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/5] b43: N-PHY: add setting power amplifier filters
Date: Fri, 22 Jan 2010 01:53:15 +0100
Message-Id: <1264121596-9616-5-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       |   41 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/tables_nphy.c |   24 ++++++++++++++++++
 drivers/net/wireless/b43/tables_nphy.h |    1 +
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f5900f0..97a44e4 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1628,6 +1628,43 @@ static void b43_nphy_update_tx_cal_ladder(struct b43_wldev *dev, u16 core)
 	}
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ExtPaSetTxDigiFilts */
+static void b43_nphy_ext_pa_set_tx_dig_filters(struct b43_wldev *dev)
+{
+	int i;
+	for (i = 0; i < 15; i++)
+		b43_phy_write(dev, B43_PHY_N(0x2C5 + i),
+				tbl_tx_filter_coef_rev4[2][i]);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/IpaSetTxDigiFilts */
+static void b43_nphy_int_pa_set_tx_dig_filters(struct b43_wldev *dev)
+{
+	int i, j;
+	/* B43_NPHY_TXF_20CO_S0A1, B43_NPHY_TXF_40CO_S0A1, unknown */
+	u16 offset[] = { 0x186, 0x195, 0x2C5 };
+
+	for (i = 0; i < 3; i++)
+		for (j = 0; j < 15; j++)
+			b43_phy_write(dev, B43_PHY_N(offset[i] + j),
+					tbl_tx_filter_coef_rev4[i][j]);
+
+	if (dev->phy.is_40mhz) {
+		for (j = 0; j < 15; j++)
+			b43_phy_write(dev, B43_PHY_N(offset[0] + j),
+					tbl_tx_filter_coef_rev4[3][j]);
+	} else if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		for (j = 0; j < 15; j++)
+			b43_phy_write(dev, B43_PHY_N(offset[0] + j),
+					tbl_tx_filter_coef_rev4[5][j]);
+	}
+
+	if (dev->phy.channel == 14)
+		for (j = 0; j < 15; j++)
+			b43_phy_write(dev, B43_PHY_N(offset[0] + j),
+					tbl_tx_filter_coef_rev4[6][j]);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetTxGain */
 static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 {
@@ -2371,9 +2408,9 @@ int b43_phy_initn(struct b43_wldev *dev)
 		b43_phy_set(dev, B43_NPHY_PAPD_EN1, 0x1);
 		b43_phy_maskset(dev, B43_NPHY_EPS_TABLE_ADJ1, 0x007F,
 				nphy->papd_epsilon_offset[1] << 7);
-		/* TODO N PHY IPA Set TX Dig Filters */
+		b43_nphy_int_pa_set_tx_dig_filters(dev);
 	} else if (phy->rev >= 5) {
-		/* TODO N PHY Ext PA Set TX Dig Filters */
+		b43_nphy_ext_pa_set_tx_dig_filters(dev);
 	}
 
 	b43_nphy_workarounds(dev);
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index dd9687d..a00d509 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2883,6 +2883,30 @@ const u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[] = {
 	0x9084, 0x9267, 0x9056, 0x9234
 };
 
+const s16 tbl_tx_filter_coef_rev4[7][15] = {
+	{  -377,   137,  -407,   208, -1527,
+	    956,    93,   186,    93,   230,
+	    -44,   230,    20,  -191,   201 },
+	{   -77,    20,   -98,    49,   -93,
+	     60,    56,   111,    56,    26,
+	     -5,    26,    34,   -32,    34 },
+	{  -360,   164,  -376,   164, -1533,
+	    576,   308,  -314,   308,   121,
+	    -73,   121,    91,   124,    91 },
+	{  -295,   200,  -363,   142, -1391,
+	    826,   151,   301,   151,   151,
+	    301,   151,   602,  -752,   602 },
+	{   -92,    58,   -96,    49,  -104,
+	     44,    17,    35,    17,    12,
+	     25,    12,    13,    27,    13 },
+	{  -375,   136,  -399,   209, -1479,
+	    949,   130,   260,   130,   230,
+	    -44,   230,   201,  -191,   201 },
+	{ 0xed9,  0xc8, 0xe95,  0x8e, 0xa91,
+	  0x33a,  0x97, 0x12d,  0x97,  0x97,
+	  0x12d,  0x97, 0x25a, 0xd10, 0x25a }
+};
+
 /* addr0,  addr1,  bmask,  shift */
 const struct nphy_rf_control_override_rev2 tbl_rf_control_override_rev2[] = {
 	{ 0x78, 0x78, 0x0038,  3 }, /* for field == 0x0002 (fls == 2) */
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 5d38172..9c1c6ec 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -193,6 +193,7 @@ extern const u16 tbl_tx_iqlo_cal_cmds_recal_nphyrev3[];
 extern const u16 tbl_tx_iqlo_cal_cmds_recal[];
 extern const u16 tbl_tx_iqlo_cal_cmds_fullcal[];
 extern const u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[];
+extern const s16 tbl_tx_filter_coef_rev4[7][15];
 
 extern const struct nphy_rf_control_override_rev2
 	tbl_rf_control_override_rev2[];
-- 
1.6.4.2

