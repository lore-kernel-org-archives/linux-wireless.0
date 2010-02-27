Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:51090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966330Ab0B0MEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 07:04:06 -0500
Received: by fg-out-1718.google.com with SMTP id d23so309269fga.1
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 04:04:04 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 04/10] b43: N-PHY: update writing channel-specific radio registers
Date: Sat, 27 Feb 2010 13:03:35 +0100
Message-Id: <1267272221-1873-5-git-send-email-zajec5@gmail.com>
In-Reply-To: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
References: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: unconditional flushes
---
 drivers/net/wireless/b43/phy_n.c |   54 ++++++++++++++++++++++---------------
 1 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index dd81e8a..2c592d2 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -90,28 +90,38 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
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
 }
 
 static void b43_chantab_phy_upload(struct b43_wldev *dev,
-- 
1.6.4.2

