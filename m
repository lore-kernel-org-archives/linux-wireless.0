Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36082 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1LQM4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 07:56:33 -0500
Received: by eekc4 with SMTP id c4so4011135eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 04:56:32 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/8] b43: N-PHY: reorder functions: collect radio ones
Date: Sat, 17 Dec 2011 13:57:21 +0100
Message-Id: <1324126647-22425-3-git-send-email-zajec5@gmail.com> (sfid-20111217_135636_978273_0ECADE78)
In-Reply-To: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  388 +++++++++++++++++++-------------------
 1 files changed, 198 insertions(+), 190 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1ede258..29ab432 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -414,60 +414,9 @@ static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
 }
 
 /**************************************************
- * Others
+ * Radio 0x2056
  **************************************************/
 
-void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
-{//TODO
-}
-
-static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
-{//TODO
-}
-
-static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
-							bool ignore_tssi)
-{//TODO
-	return B43_TXPWR_RES_DONE;
-}
-
-static void b43_chantab_radio_upload(struct b43_wldev *dev,
-				const struct b43_nphy_channeltab_entry_rev2 *e)
-{
-	b43_radio_write(dev, B2055_PLL_REF, e->radio_pll_ref);
-	b43_radio_write(dev, B2055_RF_PLLMOD0, e->radio_rf_pllmod0);
-	b43_radio_write(dev, B2055_RF_PLLMOD1, e->radio_rf_pllmod1);
-	b43_radio_write(dev, B2055_VCO_CAPTAIL, e->radio_vco_captail);
-	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
-
-	b43_radio_write(dev, B2055_VCO_CAL1, e->radio_vco_cal1);
-	b43_radio_write(dev, B2055_VCO_CAL2, e->radio_vco_cal2);
-	b43_radio_write(dev, B2055_PLL_LFC1, e->radio_pll_lfc1);
-	b43_radio_write(dev, B2055_PLL_LFR1, e->radio_pll_lfr1);
-	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
-
-	b43_radio_write(dev, B2055_PLL_LFC2, e->radio_pll_lfc2);
-	b43_radio_write(dev, B2055_LGBUF_CENBUF, e->radio_lgbuf_cenbuf);
-	b43_radio_write(dev, B2055_LGEN_TUNE1, e->radio_lgen_tune1);
-	b43_radio_write(dev, B2055_LGEN_TUNE2, e->radio_lgen_tune2);
-	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
-
-	b43_radio_write(dev, B2055_C1_LGBUF_ATUNE, e->radio_c1_lgbuf_atune);
-	b43_radio_write(dev, B2055_C1_LGBUF_GTUNE, e->radio_c1_lgbuf_gtune);
-	b43_radio_write(dev, B2055_C1_RX_RFR1, e->radio_c1_rx_rfr1);
-	b43_radio_write(dev, B2055_C1_TX_PGAPADTN, e->radio_c1_tx_pgapadtn);
-	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
-
-	b43_radio_write(dev, B2055_C1_TX_MXBGTRIM, e->radio_c1_tx_mxbgtrim);
-	b43_radio_write(dev, B2055_C2_LGBUF_ATUNE, e->radio_c2_lgbuf_atune);
-	b43_radio_write(dev, B2055_C2_LGBUF_GTUNE, e->radio_c2_lgbuf_gtune);
-	b43_radio_write(dev, B2055_C2_RX_RFR1, e->radio_c2_rx_rfr1);
-	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
-
-	b43_radio_write(dev, B2055_C2_TX_PGAPADTN, e->radio_c2_tx_pgapadtn);
-	b43_radio_write(dev, B2055_C2_TX_MXBGTRIM, e->radio_c2_tx_mxbgtrim);
-}
-
 static void b43_chantab_radio_2056_upload(struct b43_wldev *dev,
 				const struct b43_nphy_channeltab_entry_rev3 *e)
 {
@@ -649,6 +598,203 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 	udelay(300);
 }
 
+static void b43_radio_init2056_pre(struct b43_wldev *dev)
+{
+	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+		     ~B43_NPHY_RFCTL_CMD_CHIP0PU);
+	/* Maybe wl meant to reset and set (order?) RFCTL_CMD_OEPORFORCE? */
+	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+		     B43_NPHY_RFCTL_CMD_OEPORFORCE);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+		    ~B43_NPHY_RFCTL_CMD_OEPORFORCE);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+		    B43_NPHY_RFCTL_CMD_CHIP0PU);
+}
+
+static void b43_radio_init2056_post(struct b43_wldev *dev)
+{
+	b43_radio_set(dev, B2056_SYN_COM_CTRL, 0xB);
+	b43_radio_set(dev, B2056_SYN_COM_PU, 0x2);
+	b43_radio_set(dev, B2056_SYN_COM_RESET, 0x2);
+	msleep(1);
+	b43_radio_mask(dev, B2056_SYN_COM_RESET, ~0x2);
+	b43_radio_mask(dev, B2056_SYN_PLL_MAST2, ~0xFC);
+	b43_radio_mask(dev, B2056_SYN_RCCAL_CTRL0, ~0x1);
+	/*
+	if (nphy->init_por)
+		Call Radio 2056 Recalibrate
+	*/
+}
+
+/*
+ * Initialize a Broadcom 2056 N-radio
+ * http://bcm-v4.sipsolutions.net/802.11/Radio/2056/Init
+ */
+static void b43_radio_init2056(struct b43_wldev *dev)
+{
+	b43_radio_init2056_pre(dev);
+	b2056_upload_inittabs(dev, 0, 0);
+	b43_radio_init2056_post(dev);
+}
+
+/**************************************************
+ * Radio 0x2055
+ **************************************************/
+
+static void b43_chantab_radio_upload(struct b43_wldev *dev,
+				const struct b43_nphy_channeltab_entry_rev2 *e)
+{
+	b43_radio_write(dev, B2055_PLL_REF, e->radio_pll_ref);
+	b43_radio_write(dev, B2055_RF_PLLMOD0, e->radio_rf_pllmod0);
+	b43_radio_write(dev, B2055_RF_PLLMOD1, e->radio_rf_pllmod1);
+	b43_radio_write(dev, B2055_VCO_CAPTAIL, e->radio_vco_captail);
+	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
+
+	b43_radio_write(dev, B2055_VCO_CAL1, e->radio_vco_cal1);
+	b43_radio_write(dev, B2055_VCO_CAL2, e->radio_vco_cal2);
+	b43_radio_write(dev, B2055_PLL_LFC1, e->radio_pll_lfc1);
+	b43_radio_write(dev, B2055_PLL_LFR1, e->radio_pll_lfr1);
+	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
+
+	b43_radio_write(dev, B2055_PLL_LFC2, e->radio_pll_lfc2);
+	b43_radio_write(dev, B2055_LGBUF_CENBUF, e->radio_lgbuf_cenbuf);
+	b43_radio_write(dev, B2055_LGEN_TUNE1, e->radio_lgen_tune1);
+	b43_radio_write(dev, B2055_LGEN_TUNE2, e->radio_lgen_tune2);
+	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
+
+	b43_radio_write(dev, B2055_C1_LGBUF_ATUNE, e->radio_c1_lgbuf_atune);
+	b43_radio_write(dev, B2055_C1_LGBUF_GTUNE, e->radio_c1_lgbuf_gtune);
+	b43_radio_write(dev, B2055_C1_RX_RFR1, e->radio_c1_rx_rfr1);
+	b43_radio_write(dev, B2055_C1_TX_PGAPADTN, e->radio_c1_tx_pgapadtn);
+	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
+
+	b43_radio_write(dev, B2055_C1_TX_MXBGTRIM, e->radio_c1_tx_mxbgtrim);
+	b43_radio_write(dev, B2055_C2_LGBUF_ATUNE, e->radio_c2_lgbuf_atune);
+	b43_radio_write(dev, B2055_C2_LGBUF_GTUNE, e->radio_c2_lgbuf_gtune);
+	b43_radio_write(dev, B2055_C2_RX_RFR1, e->radio_c2_rx_rfr1);
+	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
+
+	b43_radio_write(dev, B2055_C2_TX_PGAPADTN, e->radio_c2_tx_pgapadtn);
+	b43_radio_write(dev, B2055_C2_TX_MXBGTRIM, e->radio_c2_tx_mxbgtrim);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2055Setup */
+static void b43_radio_2055_setup(struct b43_wldev *dev,
+				const struct b43_nphy_channeltab_entry_rev2 *e)
+{
+	B43_WARN_ON(dev->phy.rev >= 3);
+
+	b43_chantab_radio_upload(dev, e);
+	udelay(50);
+	b43_radio_write(dev, B2055_VCO_CAL10, 0x05);
+	b43_radio_write(dev, B2055_VCO_CAL10, 0x45);
+	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
+	b43_radio_write(dev, B2055_VCO_CAL10, 0x65);
+	udelay(300);
+}
+
+static void b43_radio_init2055_pre(struct b43_wldev *dev)
+{
+	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+		     ~B43_NPHY_RFCTL_CMD_PORFORCE);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+		    B43_NPHY_RFCTL_CMD_CHIP0PU |
+		    B43_NPHY_RFCTL_CMD_OEPORFORCE);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+		    B43_NPHY_RFCTL_CMD_PORFORCE);
+}
+
+static void b43_radio_init2055_post(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+	int i;
+	u16 val;
+	bool workaround = false;
+
+	if (sprom->revision < 4)
+		workaround = (dev->dev->board_vendor != PCI_VENDOR_ID_BROADCOM
+			      && dev->dev->board_type == 0x46D
+			      && dev->dev->board_rev >= 0x41);
+	else
+		workaround =
+			!(sprom->boardflags2_lo & B43_BFL2_RXBB_INT_REG_DIS);
+
+	b43_radio_mask(dev, B2055_MASTER1, 0xFFF3);
+	if (workaround) {
+		b43_radio_mask(dev, B2055_C1_RX_BB_REG, 0x7F);
+		b43_radio_mask(dev, B2055_C2_RX_BB_REG, 0x7F);
+	}
+	b43_radio_maskset(dev, B2055_RRCCAL_NOPTSEL, 0xFFC0, 0x2C);
+	b43_radio_write(dev, B2055_CAL_MISC, 0x3C);
+	b43_radio_mask(dev, B2055_CAL_MISC, 0xFFBE);
+	b43_radio_set(dev, B2055_CAL_LPOCTL, 0x80);
+	b43_radio_set(dev, B2055_CAL_MISC, 0x1);
+	msleep(1);
+	b43_radio_set(dev, B2055_CAL_MISC, 0x40);
+	for (i = 0; i < 200; i++) {
+		val = b43_radio_read(dev, B2055_CAL_COUT2);
+		if (val & 0x80) {
+			i = 0;
+			break;
+		}
+		udelay(10);
+	}
+	if (i)
+		b43err(dev->wl, "radio post init timeout\n");
+	b43_radio_mask(dev, B2055_CAL_LPOCTL, 0xFF7F);
+	b43_switch_channel(dev, dev->phy.channel);
+	b43_radio_write(dev, B2055_C1_RX_BB_LPF, 0x9);
+	b43_radio_write(dev, B2055_C2_RX_BB_LPF, 0x9);
+	b43_radio_write(dev, B2055_C1_RX_BB_MIDACHP, 0x83);
+	b43_radio_write(dev, B2055_C2_RX_BB_MIDACHP, 0x83);
+	b43_radio_maskset(dev, B2055_C1_LNA_GAINBST, 0xFFF8, 0x6);
+	b43_radio_maskset(dev, B2055_C2_LNA_GAINBST, 0xFFF8, 0x6);
+	if (!nphy->gain_boost) {
+		b43_radio_set(dev, B2055_C1_RX_RFSPC1, 0x2);
+		b43_radio_set(dev, B2055_C2_RX_RFSPC1, 0x2);
+	} else {
+		b43_radio_mask(dev, B2055_C1_RX_RFSPC1, 0xFFFD);
+		b43_radio_mask(dev, B2055_C2_RX_RFSPC1, 0xFFFD);
+	}
+	udelay(2);
+}
+
+/*
+ * Initialize a Broadcom 2055 N-radio
+ * http://bcm-v4.sipsolutions.net/802.11/Radio/2055/Init
+ */
+static void b43_radio_init2055(struct b43_wldev *dev)
+{
+	b43_radio_init2055_pre(dev);
+	if (b43_status(dev) < B43_STAT_INITIALIZED) {
+		/* Follow wl, not specs. Do not force uploading all regs */
+		b2055_upload_inittab(dev, 0, 0);
+	} else {
+		bool ghz5 = b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ;
+		b2055_upload_inittab(dev, ghz5, 0);
+	}
+	b43_radio_init2055_post(dev);
+}
+
+/**************************************************
+ * Others
+ **************************************************/
+
+void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
+{//TODO
+}
+
+static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
+{//TODO
+}
+
+static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
+							bool ignore_tssi)
+{//TODO
+	return B43_TXPWR_RES_DONE;
+}
+
 static void b43_chantab_phy_upload(struct b43_wldev *dev,
 				   const struct b43_phy_n_sfo_cfg *e)
 {
@@ -952,144 +1098,6 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2055Setup */
-static void b43_radio_2055_setup(struct b43_wldev *dev,
-				const struct b43_nphy_channeltab_entry_rev2 *e)
-{
-	B43_WARN_ON(dev->phy.rev >= 3);
-
-	b43_chantab_radio_upload(dev, e);
-	udelay(50);
-	b43_radio_write(dev, B2055_VCO_CAL10, 0x05);
-	b43_radio_write(dev, B2055_VCO_CAL10, 0x45);
-	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
-	b43_radio_write(dev, B2055_VCO_CAL10, 0x65);
-	udelay(300);
-}
-
-static void b43_radio_init2055_pre(struct b43_wldev *dev)
-{
-	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
-		     ~B43_NPHY_RFCTL_CMD_PORFORCE);
-	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
-		    B43_NPHY_RFCTL_CMD_CHIP0PU |
-		    B43_NPHY_RFCTL_CMD_OEPORFORCE);
-	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
-		    B43_NPHY_RFCTL_CMD_PORFORCE);
-}
-
-static void b43_radio_init2055_post(struct b43_wldev *dev)
-{
-	struct b43_phy_n *nphy = dev->phy.n;
-	struct ssb_sprom *sprom = dev->dev->bus_sprom;
-	int i;
-	u16 val;
-	bool workaround = false;
-
-	if (sprom->revision < 4)
-		workaround = (dev->dev->board_vendor != PCI_VENDOR_ID_BROADCOM
-			      && dev->dev->board_type == 0x46D
-			      && dev->dev->board_rev >= 0x41);
-	else
-		workaround =
-			!(sprom->boardflags2_lo & B43_BFL2_RXBB_INT_REG_DIS);
-
-	b43_radio_mask(dev, B2055_MASTER1, 0xFFF3);
-	if (workaround) {
-		b43_radio_mask(dev, B2055_C1_RX_BB_REG, 0x7F);
-		b43_radio_mask(dev, B2055_C2_RX_BB_REG, 0x7F);
-	}
-	b43_radio_maskset(dev, B2055_RRCCAL_NOPTSEL, 0xFFC0, 0x2C);
-	b43_radio_write(dev, B2055_CAL_MISC, 0x3C);
-	b43_radio_mask(dev, B2055_CAL_MISC, 0xFFBE);
-	b43_radio_set(dev, B2055_CAL_LPOCTL, 0x80);
-	b43_radio_set(dev, B2055_CAL_MISC, 0x1);
-	msleep(1);
-	b43_radio_set(dev, B2055_CAL_MISC, 0x40);
-	for (i = 0; i < 200; i++) {
-		val = b43_radio_read(dev, B2055_CAL_COUT2);
-		if (val & 0x80) {
-			i = 0;
-			break;
-		}
-		udelay(10);
-	}
-	if (i)
-		b43err(dev->wl, "radio post init timeout\n");
-	b43_radio_mask(dev, B2055_CAL_LPOCTL, 0xFF7F);
-	b43_switch_channel(dev, dev->phy.channel);
-	b43_radio_write(dev, B2055_C1_RX_BB_LPF, 0x9);
-	b43_radio_write(dev, B2055_C2_RX_BB_LPF, 0x9);
-	b43_radio_write(dev, B2055_C1_RX_BB_MIDACHP, 0x83);
-	b43_radio_write(dev, B2055_C2_RX_BB_MIDACHP, 0x83);
-	b43_radio_maskset(dev, B2055_C1_LNA_GAINBST, 0xFFF8, 0x6);
-	b43_radio_maskset(dev, B2055_C2_LNA_GAINBST, 0xFFF8, 0x6);
-	if (!nphy->gain_boost) {
-		b43_radio_set(dev, B2055_C1_RX_RFSPC1, 0x2);
-		b43_radio_set(dev, B2055_C2_RX_RFSPC1, 0x2);
-	} else {
-		b43_radio_mask(dev, B2055_C1_RX_RFSPC1, 0xFFFD);
-		b43_radio_mask(dev, B2055_C2_RX_RFSPC1, 0xFFFD);
-	}
-	udelay(2);
-}
-
-/*
- * Initialize a Broadcom 2055 N-radio
- * http://bcm-v4.sipsolutions.net/802.11/Radio/2055/Init
- */
-static void b43_radio_init2055(struct b43_wldev *dev)
-{
-	b43_radio_init2055_pre(dev);
-	if (b43_status(dev) < B43_STAT_INITIALIZED) {
-		/* Follow wl, not specs. Do not force uploading all regs */
-		b2055_upload_inittab(dev, 0, 0);
-	} else {
-		bool ghz5 = b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ;
-		b2055_upload_inittab(dev, ghz5, 0);
-	}
-	b43_radio_init2055_post(dev);
-}
-
-static void b43_radio_init2056_pre(struct b43_wldev *dev)
-{
-	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
-		     ~B43_NPHY_RFCTL_CMD_CHIP0PU);
-	/* Maybe wl meant to reset and set (order?) RFCTL_CMD_OEPORFORCE? */
-	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
-		     B43_NPHY_RFCTL_CMD_OEPORFORCE);
-	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
-		    ~B43_NPHY_RFCTL_CMD_OEPORFORCE);
-	b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
-		    B43_NPHY_RFCTL_CMD_CHIP0PU);
-}
-
-static void b43_radio_init2056_post(struct b43_wldev *dev)
-{
-	b43_radio_set(dev, B2056_SYN_COM_CTRL, 0xB);
-	b43_radio_set(dev, B2056_SYN_COM_PU, 0x2);
-	b43_radio_set(dev, B2056_SYN_COM_RESET, 0x2);
-	msleep(1);
-	b43_radio_mask(dev, B2056_SYN_COM_RESET, ~0x2);
-	b43_radio_mask(dev, B2056_SYN_PLL_MAST2, ~0xFC);
-	b43_radio_mask(dev, B2056_SYN_RCCAL_CTRL0, ~0x1);
-	/*
-	if (nphy->init_por)
-		Call Radio 2056 Recalibrate
-	*/
-}
-
-/*
- * Initialize a Broadcom 2056 N-radio
- * http://bcm-v4.sipsolutions.net/802.11/Radio/2056/Init
- */
-static void b43_radio_init2056(struct b43_wldev *dev)
-{
-	b43_radio_init2056_pre(dev);
-	b2056_upload_inittabs(dev, 0, 0);
-	b43_radio_init2056_post(dev);
-}
-
 /*
  * Upload the N-PHY tables.
  * http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables
-- 
1.7.7

