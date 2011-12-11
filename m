Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54431 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1LKBOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 20:14:40 -0500
Received: by mail-ey0-f174.google.com with SMTP id k14so2316533eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 17:14:40 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/7] b43: N-PHY: random trivial fixes for typos, missing writes
Date: Sun, 11 Dec 2011 02:55:29 +0100
Message-Id: <1323568535-2816-2-git-send-email-zajec5@gmail.com> (sfid-20111211_021445_471241_1217EE9A)
In-Reply-To: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
References: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
There was off-by-one in tx2rx_events and tx2rx_delays arrays. Use
ARRAY_SIZE to avoid such mistakes.

Also, I've never meant to write numbers in octal system :| I really
forgot that leading 0 means octal :/
---
 drivers/net/wireless/b43/phy_n.c       |   23 +++++++++++++++--------
 drivers/net/wireless/b43/tables_nphy.c |    2 +-
 drivers/net/wireless/b43/tables_nphy.h |   28 ++++++++++++++--------------
 3 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index b17d9b6..f40d804 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1493,8 +1493,8 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
 	/* TX to RX */
-	u8 tx2rx_events[9] = { 0x4, 0x3, 0x6, 0x5, 0x2, 0x1, 0x8, 0x1F };
-	u8 tx2rx_delays[9] = { 8, 4, 2, 2, 4, 4, 6, 1 };
+	u8 tx2rx_events[8] = { 0x4, 0x3, 0x6, 0x5, 0x2, 0x1, 0x8, 0x1F };
+	u8 tx2rx_delays[8] = { 8, 4, 2, 2, 4, 4, 6, 1 };
 	/* RX to TX */
 	u8 rx2tx_events_ipa[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0xF, 0x3,
 					0x1F };
@@ -1505,6 +1505,9 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	u16 tmp16;
 	u32 tmp32;
 
+	b43_phy_write(dev, 0x23f, 0x1f8);
+	b43_phy_write(dev, 0x240, 0x1f8);
+
 	tmp32 = b43_ntab_read(dev, B43_NTAB32(30, 0));
 	tmp32 &= 0xffffff;
 	b43_ntab_write(dev, B43_NTAB32(30, 0), tmp32);
@@ -1520,12 +1523,13 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x2AE, 0x000C);
 
 	/* TX to RX */
-	b43_nphy_set_rf_sequence(dev, 1, tx2rx_events, tx2rx_delays, 9);
+	b43_nphy_set_rf_sequence(dev, 1, tx2rx_events, tx2rx_delays,
+				 ARRAY_SIZE(tx2rx_events));
 
 	/* RX to TX */
 	if (b43_nphy_ipa(dev))
-		b43_nphy_set_rf_sequence(dev, 1, rx2tx_events_ipa,
-					 rx2tx_delays_ipa, 9);
+		b43_nphy_set_rf_sequence(dev, 0, rx2tx_events_ipa,
+				rx2tx_delays_ipa, ARRAY_SIZE(rx2tx_events_ipa));
 	if (nphy->hw_phyrxchain != 3 &&
 	    nphy->hw_phyrxchain != nphy->hw_phytxchain) {
 		if (b43_nphy_ipa(dev)) {
@@ -1533,7 +1537,8 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 			rx2tx_delays[6] = 1;
 			rx2tx_events[7] = 0x1F;
 		}
-		b43_nphy_set_rf_sequence(dev, 1, rx2tx_events, rx2tx_delays, 9);
+		b43_nphy_set_rf_sequence(dev, 1, rx2tx_events, rx2tx_delays,
+					 ARRAY_SIZE(rx2tx_events));
 	}
 
 	tmp16 = (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) ?
@@ -1547,8 +1552,8 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 
 	b43_nphy_gain_ctrl_workarounds(dev);
 
-	b43_ntab_write(dev, B43_NTAB32(8, 0), 2);
-	b43_ntab_write(dev, B43_NTAB32(8, 16), 2);
+	b43_ntab_write(dev, B43_NTAB16(8, 0), 2);
+	b43_ntab_write(dev, B43_NTAB16(8, 16), 2);
 
 	/* TODO */
 
@@ -1560,6 +1565,8 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_BIAS_AUX, 0x07);
 	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_LOB_BIAS, 0x88);
 	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_LOB_BIAS, 0x88);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_CMFB_IDAC, 0x00);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_CMFB_IDAC, 0x00);
 	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXG_CMFB_IDAC, 0x00);
 	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXG_CMFB_IDAC, 0x00);
 
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 7b326f2..4ec3d66 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2652,7 +2652,7 @@ const u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[] = {
 const s16 tbl_tx_filter_coef_rev4[7][15] = {
 	{  -377,   137,  -407,   208, -1527,
 	    956,    93,   186,    93,   230,
-	    -44,   230,    20,  -191,   201 },
+	    -44,   230,   201,  -191,   201 },
 	{   -77,    20,   -98,    49,   -93,
 	     60,    56,   111,    56,    26,
 	     -5,    26,    34,   -32,    34 },
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index a81696b..ddca0dd 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -127,25 +127,25 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 #define B43_NTAB_C1_LOFEEDTH_SIZE	128
 
 /* Static N-PHY tables, PHY revision >= 3 */
-#define B43_NTAB_FRAMESTRUCT_R3		B43_NTAB32(10, 000) /* frame struct  */
-#define B43_NTAB_PILOT_R3		B43_NTAB16(11, 000) /* pilot  */
-#define B43_NTAB_TMAP_R3		B43_NTAB32(12, 000) /* TM AP  */
-#define B43_NTAB_INTLEVEL_R3		B43_NTAB32(13, 000) /* INT LV  */
-#define B43_NTAB_TDTRN_R3		B43_NTAB32(14, 000) /* TD TRN  */
-#define B43_NTAB_NOISEVAR0_R3		B43_NTAB32(16, 000) /* noise variance 0  */
+#define B43_NTAB_FRAMESTRUCT_R3		B43_NTAB32(10,   0) /* frame struct  */
+#define B43_NTAB_PILOT_R3		B43_NTAB16(11,   0) /* pilot  */
+#define B43_NTAB_TMAP_R3		B43_NTAB32(12,   0) /* TM AP  */
+#define B43_NTAB_INTLEVEL_R3		B43_NTAB32(13,   0) /* INT LV  */
+#define B43_NTAB_TDTRN_R3		B43_NTAB32(14,   0) /* TD TRN  */
+#define B43_NTAB_NOISEVAR0_R3		B43_NTAB32(16,   0) /* noise variance 0  */
 #define B43_NTAB_NOISEVAR1_R3		B43_NTAB32(16, 128) /* noise variance 1  */
-#define B43_NTAB_MCS_R3			B43_NTAB16(18, 000) /* MCS  */
+#define B43_NTAB_MCS_R3			B43_NTAB16(18,   0) /* MCS  */
 #define B43_NTAB_TDI20A0_R3		B43_NTAB32(19, 128) /* TDI 20/0  */
 #define B43_NTAB_TDI20A1_R3		B43_NTAB32(19, 256) /* TDI 20/1  */
 #define B43_NTAB_TDI40A0_R3		B43_NTAB32(19, 640) /* TDI 40/0  */
 #define B43_NTAB_TDI40A1_R3		B43_NTAB32(19, 768) /* TDI 40/1  */
-#define B43_NTAB_PILOTLT_R3		B43_NTAB32(20, 000) /* PLT lookup  */
-#define B43_NTAB_CHANEST_R3		B43_NTAB32(22, 000) /* channel estimate  */
-#define B43_NTAB_FRAMELT_R3		B43_NTAB8 (24, 000) /* frame lookup  */
-#define B43_NTAB_C0_ESTPLT_R3		B43_NTAB8 (26, 000) /* estimated power lookup 0  */
-#define B43_NTAB_C1_ESTPLT_R3		B43_NTAB8 (27, 000) /* estimated power lookup 1  */
-#define B43_NTAB_C0_ADJPLT_R3		B43_NTAB8 (26, 064) /* adjusted power lookup 0  */
-#define B43_NTAB_C1_ADJPLT_R3		B43_NTAB8 (27, 064) /* adjusted power lookup 1  */
+#define B43_NTAB_PILOTLT_R3		B43_NTAB32(20,   0) /* PLT lookup  */
+#define B43_NTAB_CHANEST_R3		B43_NTAB32(22,   0) /* channel estimate  */
+#define B43_NTAB_FRAMELT_R3		 B43_NTAB8(24,   0) /* frame lookup  */
+#define B43_NTAB_C0_ESTPLT_R3		 B43_NTAB8(26,   0) /* estimated power lookup 0  */
+#define B43_NTAB_C1_ESTPLT_R3		 B43_NTAB8(27,   0) /* estimated power lookup 1  */
+#define B43_NTAB_C0_ADJPLT_R3		 B43_NTAB8(26,  64) /* adjusted power lookup 0  */
+#define B43_NTAB_C1_ADJPLT_R3		 B43_NTAB8(27,  64) /* adjusted power lookup 1  */
 #define B43_NTAB_C0_GAINCTL_R3		B43_NTAB32(26, 192) /* gain control lookup 0  */
 #define B43_NTAB_C1_GAINCTL_R3		B43_NTAB32(27, 192) /* gain control lookup 1  */
 #define B43_NTAB_C0_IQLT_R3		B43_NTAB32(26, 320) /* I/Q lookup 0  */
-- 
1.7.3.4

