Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:43719 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaE0UIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:08:16 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so10168007wes.4
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:08:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: N-PHY: optimize init by doing some ops just once
Date: Tue, 27 May 2014 22:07:32 +0200
Message-Id: <1401221253-4135-2-git-send-email-zajec5@gmail.com> (sfid-20140527_220826_510247_2F800686)
In-Reply-To: <1401221253-4135-1-git-send-email-zajec5@gmail.com>
References: <1401221253-4135-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       | 11 +----
 drivers/net/wireless/b43/phy_n.h       |  1 -
 drivers/net/wireless/b43/tables_nphy.c | 80 ++++++++++++++++++----------------
 3 files changed, 44 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 41dab89..98ff806 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -700,13 +700,11 @@ static void b43_radio_2057_init_post(struct b43_wldev *dev)
 	b43_radio_mask(dev, R2057_RFPLL_MISC_CAL_RESETN, ~0x78);
 	b43_radio_mask(dev, R2057_XTAL_CONFIG2, ~0x80);
 
-	if (dev->phy.n->init_por) {
+	if (dev->phy.do_full_init) {
 		b43_radio_2057_rcal(dev);
 		b43_radio_2057_rccal(dev);
 	}
 	b43_radio_mask(dev, R2057_RFPLL_MASTER, ~0x8);
-
-	dev->phy.n->init_por = false;
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/Radio/2057/Init */
@@ -1028,7 +1026,7 @@ static void b43_radio_init2056_post(struct b43_wldev *dev)
 	b43_radio_mask(dev, B2056_SYN_COM_RESET, ~0x2);
 	b43_radio_mask(dev, B2056_SYN_PLL_MAST2, ~0xFC);
 	b43_radio_mask(dev, B2056_SYN_RCCAL_CTRL0, ~0x1);
-	if (dev->phy.n->init_por)
+	if (dev->phy.do_full_init)
 		b43_radio_2056_rcal(dev);
 }
 
@@ -1041,8 +1039,6 @@ static void b43_radio_init2056(struct b43_wldev *dev)
 	b43_radio_init2056_pre(dev);
 	b2056_upload_inittabs(dev, 0, 0);
 	b43_radio_init2056_post(dev);
-
-	dev->phy.n->init_por = false;
 }
 
 /**************************************************
@@ -5561,7 +5557,6 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 	nphy->hang_avoid = (phy->rev == 3 || phy->rev == 4);
 	nphy->spur_avoid = (phy->rev >= 3) ?
 				B43_SPUR_AVOID_AUTO : B43_SPUR_AVOID_DISABLE;
-	nphy->init_por = true;
 	nphy->gain_boost = true; /* this way we follow wl, assume it is true */
 	nphy->txrx_chain = 2; /* sth different than 0 and 1 for now */
 	nphy->phyrxchain = 3; /* to avoid b43_nphy_set_rx_core_state like wl */
@@ -5602,8 +5597,6 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 		nphy->ipa2g_on = sprom->fem.ghz2.extpa_gain == 2;
 		nphy->ipa5g_on = sprom->fem.ghz5.extpa_gain == 2;
 	}
-
-	nphy->init_por = true;
 }
 
 static void b43_nphy_op_free(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 9a5b6bc..ecfbf66 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -931,7 +931,6 @@ struct b43_phy_n {
 	u16 papd_epsilon_offset[2];
 	s32 preamble_override;
 	u32 bb_mult_save;
-	bool init_por;
 
 	bool gain_boost;
 	bool elna_gain_config;
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 50d03ff..4047c05 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -3042,30 +3042,32 @@ static void b43_nphy_tables_init_rev3(struct b43_wldev *dev)
 		antswlut = sprom->fem.ghz2.antswlut;
 
 	/* Static tables */
-	ntab_upload(dev, B43_NTAB_FRAMESTRUCT_R3, b43_ntab_framestruct_r3);
-	ntab_upload(dev, B43_NTAB_PILOT_R3, b43_ntab_pilot_r3);
-	ntab_upload(dev, B43_NTAB_TMAP_R3, b43_ntab_tmap_r3);
-	ntab_upload(dev, B43_NTAB_INTLEVEL_R3, b43_ntab_intlevel_r3);
-	ntab_upload(dev, B43_NTAB_TDTRN_R3, b43_ntab_tdtrn_r3);
-	ntab_upload(dev, B43_NTAB_NOISEVAR_R3, b43_ntab_noisevar_r3);
-	ntab_upload(dev, B43_NTAB_MCS_R3, b43_ntab_mcs_r3);
-	ntab_upload(dev, B43_NTAB_TDI20A0_R3, b43_ntab_tdi20a0_r3);
-	ntab_upload(dev, B43_NTAB_TDI20A1_R3, b43_ntab_tdi20a1_r3);
-	ntab_upload(dev, B43_NTAB_TDI40A0_R3, b43_ntab_tdi40a0_r3);
-	ntab_upload(dev, B43_NTAB_TDI40A1_R3, b43_ntab_tdi40a1_r3);
-	ntab_upload(dev, B43_NTAB_PILOTLT_R3, b43_ntab_pilotlt_r3);
-	ntab_upload(dev, B43_NTAB_CHANEST_R3, b43_ntab_channelest_r3);
-	ntab_upload(dev, B43_NTAB_FRAMELT_R3, b43_ntab_framelookup_r3);
-	ntab_upload(dev, B43_NTAB_C0_ESTPLT_R3, b43_ntab_estimatepowerlt0_r3);
-	ntab_upload(dev, B43_NTAB_C1_ESTPLT_R3, b43_ntab_estimatepowerlt1_r3);
-	ntab_upload(dev, B43_NTAB_C0_ADJPLT_R3, b43_ntab_adjustpower0_r3);
-	ntab_upload(dev, B43_NTAB_C1_ADJPLT_R3, b43_ntab_adjustpower1_r3);
-	ntab_upload(dev, B43_NTAB_C0_GAINCTL_R3, b43_ntab_gainctl0_r3);
-	ntab_upload(dev, B43_NTAB_C1_GAINCTL_R3, b43_ntab_gainctl1_r3);
-	ntab_upload(dev, B43_NTAB_C0_IQLT_R3, b43_ntab_iqlt0_r3);
-	ntab_upload(dev, B43_NTAB_C1_IQLT_R3, b43_ntab_iqlt1_r3);
-	ntab_upload(dev, B43_NTAB_C0_LOFEEDTH_R3, b43_ntab_loftlt0_r3);
-	ntab_upload(dev, B43_NTAB_C1_LOFEEDTH_R3, b43_ntab_loftlt1_r3);
+	if (dev->phy.do_full_init) {
+		ntab_upload(dev, B43_NTAB_FRAMESTRUCT_R3, b43_ntab_framestruct_r3);
+		ntab_upload(dev, B43_NTAB_PILOT_R3, b43_ntab_pilot_r3);
+		ntab_upload(dev, B43_NTAB_TMAP_R3, b43_ntab_tmap_r3);
+		ntab_upload(dev, B43_NTAB_INTLEVEL_R3, b43_ntab_intlevel_r3);
+		ntab_upload(dev, B43_NTAB_TDTRN_R3, b43_ntab_tdtrn_r3);
+		ntab_upload(dev, B43_NTAB_NOISEVAR_R3, b43_ntab_noisevar_r3);
+		ntab_upload(dev, B43_NTAB_MCS_R3, b43_ntab_mcs_r3);
+		ntab_upload(dev, B43_NTAB_TDI20A0_R3, b43_ntab_tdi20a0_r3);
+		ntab_upload(dev, B43_NTAB_TDI20A1_R3, b43_ntab_tdi20a1_r3);
+		ntab_upload(dev, B43_NTAB_TDI40A0_R3, b43_ntab_tdi40a0_r3);
+		ntab_upload(dev, B43_NTAB_TDI40A1_R3, b43_ntab_tdi40a1_r3);
+		ntab_upload(dev, B43_NTAB_PILOTLT_R3, b43_ntab_pilotlt_r3);
+		ntab_upload(dev, B43_NTAB_CHANEST_R3, b43_ntab_channelest_r3);
+		ntab_upload(dev, B43_NTAB_FRAMELT_R3, b43_ntab_framelookup_r3);
+		ntab_upload(dev, B43_NTAB_C0_ESTPLT_R3, b43_ntab_estimatepowerlt0_r3);
+		ntab_upload(dev, B43_NTAB_C1_ESTPLT_R3, b43_ntab_estimatepowerlt1_r3);
+		ntab_upload(dev, B43_NTAB_C0_ADJPLT_R3, b43_ntab_adjustpower0_r3);
+		ntab_upload(dev, B43_NTAB_C1_ADJPLT_R3, b43_ntab_adjustpower1_r3);
+		ntab_upload(dev, B43_NTAB_C0_GAINCTL_R3, b43_ntab_gainctl0_r3);
+		ntab_upload(dev, B43_NTAB_C1_GAINCTL_R3, b43_ntab_gainctl1_r3);
+		ntab_upload(dev, B43_NTAB_C0_IQLT_R3, b43_ntab_iqlt0_r3);
+		ntab_upload(dev, B43_NTAB_C1_IQLT_R3, b43_ntab_iqlt1_r3);
+		ntab_upload(dev, B43_NTAB_C0_LOFEEDTH_R3, b43_ntab_loftlt0_r3);
+		ntab_upload(dev, B43_NTAB_C1_LOFEEDTH_R3, b43_ntab_loftlt1_r3);
+	}
 
 	/* Volatile tables */
 	if (antswlut < ARRAY_SIZE(b43_ntab_antswctl_r3))
@@ -3078,20 +3080,22 @@ static void b43_nphy_tables_init_rev3(struct b43_wldev *dev)
 static void b43_nphy_tables_init_rev0(struct b43_wldev *dev)
 {
 	/* Static tables */
-	ntab_upload(dev, B43_NTAB_FRAMESTRUCT, b43_ntab_framestruct);
-	ntab_upload(dev, B43_NTAB_FRAMELT, b43_ntab_framelookup);
-	ntab_upload(dev, B43_NTAB_TMAP, b43_ntab_tmap);
-	ntab_upload(dev, B43_NTAB_TDTRN, b43_ntab_tdtrn);
-	ntab_upload(dev, B43_NTAB_INTLEVEL, b43_ntab_intlevel);
-	ntab_upload(dev, B43_NTAB_PILOT, b43_ntab_pilot);
-	ntab_upload(dev, B43_NTAB_TDI20A0, b43_ntab_tdi20a0);
-	ntab_upload(dev, B43_NTAB_TDI20A1, b43_ntab_tdi20a1);
-	ntab_upload(dev, B43_NTAB_TDI40A0, b43_ntab_tdi40a0);
-	ntab_upload(dev, B43_NTAB_TDI40A1, b43_ntab_tdi40a1);
-	ntab_upload(dev, B43_NTAB_CHANEST, b43_ntab_channelest);
-	ntab_upload(dev, B43_NTAB_MCS, b43_ntab_mcs);
-	ntab_upload(dev, B43_NTAB_NOISEVAR10, b43_ntab_noisevar10);
-	ntab_upload(dev, B43_NTAB_NOISEVAR11, b43_ntab_noisevar11);
+	if (dev->phy.do_full_init) {
+		ntab_upload(dev, B43_NTAB_FRAMESTRUCT, b43_ntab_framestruct);
+		ntab_upload(dev, B43_NTAB_FRAMELT, b43_ntab_framelookup);
+		ntab_upload(dev, B43_NTAB_TMAP, b43_ntab_tmap);
+		ntab_upload(dev, B43_NTAB_TDTRN, b43_ntab_tdtrn);
+		ntab_upload(dev, B43_NTAB_INTLEVEL, b43_ntab_intlevel);
+		ntab_upload(dev, B43_NTAB_PILOT, b43_ntab_pilot);
+		ntab_upload(dev, B43_NTAB_TDI20A0, b43_ntab_tdi20a0);
+		ntab_upload(dev, B43_NTAB_TDI20A1, b43_ntab_tdi20a1);
+		ntab_upload(dev, B43_NTAB_TDI40A0, b43_ntab_tdi40a0);
+		ntab_upload(dev, B43_NTAB_TDI40A1, b43_ntab_tdi40a1);
+		ntab_upload(dev, B43_NTAB_CHANEST, b43_ntab_channelest);
+		ntab_upload(dev, B43_NTAB_MCS, b43_ntab_mcs);
+		ntab_upload(dev, B43_NTAB_NOISEVAR10, b43_ntab_noisevar10);
+		ntab_upload(dev, B43_NTAB_NOISEVAR11, b43_ntab_noisevar11);
+	}
 
 	/* Volatile tables */
 	ntab_upload(dev, B43_NTAB_BDI, b43_ntab_bdi);
-- 
1.8.4.5

