Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:26599 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbYJCUs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:48:58 -0400
Received: by el-out-1112.google.com with SMTP id z25so367613ele.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 13:48:57 -0700 (PDT)
Subject: [PATCH 8/8] b43: remove final uses of b43_radio_{read|write}16 and
 helper defines
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 13:48:49 -0700
Message-Id: <1223066929.6512.33.camel@brick> (sfid-20081003_224911_303967_D75CA1C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c  |   10 ++---
 drivers/net/wireless/b43/phy_common.h  |    2 -
 drivers/net/wireless/b43/phy_n.c       |   62 ++++++++++++++++----------------
 drivers/net/wireless/b43/tables_nphy.c |    2 +-
 drivers/net/wireless/b43/wa.c          |    5 +--
 5 files changed, 38 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index af37abc..c805fc2 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -190,20 +190,18 @@ void b43_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 
 void b43_radio_mask(struct b43_wldev *dev, u16 offset, u16 mask)
 {
-	b43_radio_write16(dev, offset,
-			  b43_radio_read16(dev, offset) & mask);
+	b43_radio_write(dev, offset, b43_radio_read(dev, offset) & mask);
 }
 
 void b43_radio_set(struct b43_wldev *dev, u16 offset, u16 set)
 {
-	b43_radio_write16(dev, offset,
-			  b43_radio_read16(dev, offset) | set);
+	b43_radio_write(dev, offset, b43_radio_read(dev, offset) | set);
 }
 
 void b43_radio_maskset(struct b43_wldev *dev, u16 offset, u16 mask, u16 set)
 {
-	b43_radio_write16(dev, offset,
-			  (b43_radio_read16(dev, offset) & mask) | set);
+	b43_radio_write(dev, offset,
+			(b43_radio_read(dev, offset) & mask) | set);
 }
 
 u16 b43_phy_read(struct b43_wldev *dev, u16 reg)
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index c9f5430..a3a9d48 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -307,13 +307,11 @@ void b43_phy_maskset(struct b43_wldev *dev, u16 offset, u16 mask, u16 set);
  * b43_radio_read - 16bit Radio register read access
  */
 u16 b43_radio_read(struct b43_wldev *dev, u16 reg);
-#define b43_radio_read16	b43_radio_read /* DEPRECATED */
 
 /**
  * b43_radio_write - 16bit Radio register write access
  */
 void b43_radio_write(struct b43_wldev *dev, u16 reg, u16 value);
-#define b43_radio_write16	b43_radio_write /* DEPRECATED */
 
 /**
  * b43_radio_mask - Mask a 16bit radio register with a mask
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 8bcfda5..205e6a0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -47,28 +47,28 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 static void b43_chantab_radio_upload(struct b43_wldev *dev,
 				     const struct b43_nphy_channeltab_entry *e)
 {
-	b43_radio_write16(dev, B2055_PLL_REF, e->radio_pll_ref);
-	b43_radio_write16(dev, B2055_RF_PLLMOD0, e->radio_rf_pllmod0);
-	b43_radio_write16(dev, B2055_RF_PLLMOD1, e->radio_rf_pllmod1);
-	b43_radio_write16(dev, B2055_VCO_CAPTAIL, e->radio_vco_captail);
-	b43_radio_write16(dev, B2055_VCO_CAL1, e->radio_vco_cal1);
-	b43_radio_write16(dev, B2055_VCO_CAL2, e->radio_vco_cal2);
-	b43_radio_write16(dev, B2055_PLL_LFC1, e->radio_pll_lfc1);
-	b43_radio_write16(dev, B2055_PLL_LFR1, e->radio_pll_lfr1);
-	b43_radio_write16(dev, B2055_PLL_LFC2, e->radio_pll_lfc2);
-	b43_radio_write16(dev, B2055_LGBUF_CENBUF, e->radio_lgbuf_cenbuf);
-	b43_radio_write16(dev, B2055_LGEN_TUNE1, e->radio_lgen_tune1);
-	b43_radio_write16(dev, B2055_LGEN_TUNE2, e->radio_lgen_tune2);
-	b43_radio_write16(dev, B2055_C1_LGBUF_ATUNE, e->radio_c1_lgbuf_atune);
-	b43_radio_write16(dev, B2055_C1_LGBUF_GTUNE, e->radio_c1_lgbuf_gtune);
-	b43_radio_write16(dev, B2055_C1_RX_RFR1, e->radio_c1_rx_rfr1);
-	b43_radio_write16(dev, B2055_C1_TX_PGAPADTN, e->radio_c1_tx_pgapadtn);
-	b43_radio_write16(dev, B2055_C1_TX_MXBGTRIM, e->radio_c1_tx_mxbgtrim);
-	b43_radio_write16(dev, B2055_C2_LGBUF_ATUNE, e->radio_c2_lgbuf_atune);
-	b43_radio_write16(dev, B2055_C2_LGBUF_GTUNE, e->radio_c2_lgbuf_gtune);
-	b43_radio_write16(dev, B2055_C2_RX_RFR1, e->radio_c2_rx_rfr1);
-	b43_radio_write16(dev, B2055_C2_TX_PGAPADTN, e->radio_c2_tx_pgapadtn);
-	b43_radio_write16(dev, B2055_C2_TX_MXBGTRIM, e->radio_c2_tx_mxbgtrim);
+	b43_radio_write(dev, B2055_PLL_REF, e->radio_pll_ref);
+	b43_radio_write(dev, B2055_RF_PLLMOD0, e->radio_rf_pllmod0);
+	b43_radio_write(dev, B2055_RF_PLLMOD1, e->radio_rf_pllmod1);
+	b43_radio_write(dev, B2055_VCO_CAPTAIL, e->radio_vco_captail);
+	b43_radio_write(dev, B2055_VCO_CAL1, e->radio_vco_cal1);
+	b43_radio_write(dev, B2055_VCO_CAL2, e->radio_vco_cal2);
+	b43_radio_write(dev, B2055_PLL_LFC1, e->radio_pll_lfc1);
+	b43_radio_write(dev, B2055_PLL_LFR1, e->radio_pll_lfr1);
+	b43_radio_write(dev, B2055_PLL_LFC2, e->radio_pll_lfc2);
+	b43_radio_write(dev, B2055_LGBUF_CENBUF, e->radio_lgbuf_cenbuf);
+	b43_radio_write(dev, B2055_LGEN_TUNE1, e->radio_lgen_tune1);
+	b43_radio_write(dev, B2055_LGEN_TUNE2, e->radio_lgen_tune2);
+	b43_radio_write(dev, B2055_C1_LGBUF_ATUNE, e->radio_c1_lgbuf_atune);
+	b43_radio_write(dev, B2055_C1_LGBUF_GTUNE, e->radio_c1_lgbuf_gtune);
+	b43_radio_write(dev, B2055_C1_RX_RFR1, e->radio_c1_rx_rfr1);
+	b43_radio_write(dev, B2055_C1_TX_PGAPADTN, e->radio_c1_tx_pgapadtn);
+	b43_radio_write(dev, B2055_C1_TX_MXBGTRIM, e->radio_c1_tx_mxbgtrim);
+	b43_radio_write(dev, B2055_C2_LGBUF_ATUNE, e->radio_c2_lgbuf_atune);
+	b43_radio_write(dev, B2055_C2_LGBUF_GTUNE, e->radio_c2_lgbuf_gtune);
+	b43_radio_write(dev, B2055_C2_RX_RFR1, e->radio_c2_rx_rfr1);
+	b43_radio_write(dev, B2055_C2_TX_PGAPADTN, e->radio_c2_tx_pgapadtn);
+	b43_radio_write(dev, B2055_C2_TX_MXBGTRIM, e->radio_c2_tx_mxbgtrim);
 }
 
 static void b43_chantab_phy_upload(struct b43_wldev *dev,
@@ -103,9 +103,9 @@ static int nphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, 0x50);
 	b43_chantab_radio_upload(dev, tabent);
 	udelay(50);
-	b43_radio_write16(dev, B2055_VCO_CAL10, 5);
-	b43_radio_write16(dev, B2055_VCO_CAL10, 45);
-	b43_radio_write16(dev, B2055_VCO_CAL10, 65);
+	b43_radio_write(dev, B2055_VCO_CAL10, 5);
+	b43_radio_write(dev, B2055_VCO_CAL10, 45);
+	b43_radio_write(dev, B2055_VCO_CAL10, 65);
 	udelay(300);
 	if (0 /*FIXME 5Ghz*/)
 		b43_phy_set(dev, B43_NPHY_BANDCTL, B43_NPHY_BANDCTL_5GHZ);
@@ -148,7 +148,7 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 	}
 	b43_radio_maskset(dev, B2055_RRCCAL_NOPTSEL, 0x3F, 0x2C);
 	msleep(1);
-	b43_radio_write16(dev, B2055_CAL_MISC, 0x3C);
+	b43_radio_write(dev, B2055_CAL_MISC, 0x3C);
 	msleep(1);
 	b43_radio_mask(dev, B2055_CAL_MISC, 0xFFBE);
 	msleep(1);
@@ -159,7 +159,7 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 	b43_radio_set(dev, B2055_CAL_MISC, 0x40);
 	msleep(1);
 	for (i = 0; i < 100; i++) {
-		val = b43_radio_read16(dev, B2055_CAL_COUT2);
+		val = b43_radio_read(dev, B2055_CAL_COUT2);
 		if (val & 0x80)
 			break;
 		udelay(10);
@@ -168,10 +168,10 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 	b43_radio_mask(dev, B2055_CAL_LPOCTL, 0xFF7F);
 	msleep(1);
 	nphy_channel_switch(dev, dev->phy.channel);
-	b43_radio_write16(dev, B2055_C1_RX_BB_LPF, 0x9);
-	b43_radio_write16(dev, B2055_C2_RX_BB_LPF, 0x9);
-	b43_radio_write16(dev, B2055_C1_RX_BB_MIDACHP, 0x83);
-	b43_radio_write16(dev, B2055_C2_RX_BB_MIDACHP, 0x83);
+	b43_radio_write(dev, B2055_C1_RX_BB_LPF, 0x9);
+	b43_radio_write(dev, B2055_C2_RX_BB_LPF, 0x9);
+	b43_radio_write(dev, B2055_C1_RX_BB_MIDACHP, 0x83);
+	b43_radio_write(dev, B2055_C2_RX_BB_MIDACHP, 0x83);
 }
 
 /* Initialize a Broadcom 2055 N-radio */
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 4e23363..1920481 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -286,7 +286,7 @@ void b2055_upload_inittab(struct b43_wldev *dev,
 				value = e->ghz5;
 			else
 				value = e->ghz2;
-			b43_radio_write16(dev, i, value);
+			b43_radio_write(dev, i, value);
 		}
 	}
 }
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index 0c0fb15..dc6653c 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -66,7 +66,7 @@ void b43_wa_initgains(struct b43_wldev *dev)
 		b43_phy_read(dev, B43_PHY_LPFGAINCTL) & 0xFF0F);
 	if (phy->rev <= 2)
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_LPFGAIN, 0, 0x1FBF);
-	b43_radio_write16(dev, 0x0002, 0x1FBF);
+	b43_radio_write(dev, 0x0002, 0x1FBF);
 
 	b43_phy_write(dev, 0x0024, 0x4680);
 	b43_phy_write(dev, 0x0020, 0x0003);
@@ -399,8 +399,7 @@ static void b43_wa_altagc(struct b43_wldev *dev)
 		(b43_phy_read(dev, B43_PHY_OFDM(0x1A)) & ~0x3F80) | 0x2B80);
 	b43_phy_write(dev, B43_PHY_ANTWRSETT,
 		(b43_phy_read(dev, B43_PHY_ANTWRSETT) & 0xF0FF) | 0x0300);
-	b43_radio_write16(dev, 0x7A,
-		b43_radio_read16(dev, 0x7A) | 0x0008);
+	b43_radio_set(dev, 0x7A, 0x0008);
 	b43_phy_write(dev, B43_PHY_N1P1GAIN,
 		(b43_phy_read(dev, B43_PHY_N1P1GAIN) & ~0x000F) | 0x0008);
 	b43_phy_write(dev, B43_PHY_P1P2GAIN,
-- 
1.6.0.2.471.g47a76


