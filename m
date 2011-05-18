Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57019 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1EQX32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:29:28 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so286932eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 16:29:28 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 7/9] b43: bus: abstract chip info
Date: Wed, 18 May 2011 02:06:41 +0200
Message-Id: <1305677203-16660-7-git-send-email-zajec5@gmail.com> (sfid-20110518_012932_705320_2488D191)
In-Reply-To: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/bus.c          |    4 ++++
 drivers/net/wireless/b43/bus.h          |    4 ++++
 drivers/net/wireless/b43/main.c         |   12 ++++++------
 drivers/net/wireless/b43/phy_g.c        |    8 ++++----
 drivers/net/wireless/b43/phy_lp.c       |   22 +++++++++-------------
 drivers/net/wireless/b43/tables_lpphy.c |    3 +--
 6 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index ec59a12..8d0e758 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -74,6 +74,10 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 	dev->dma_dev = sdev->dma_dev;
 	dev->irq = sdev->irq;
 
+	dev->chip_id = sdev->bus->chip_id;
+	dev->chip_rev = sdev->bus->chip_rev;
+	dev->chip_pkg = sdev->bus->chip_package;
+
 	dev->bus_sprom = &sdev->bus->sprom;
 
 	dev->core_id = sdev->id.coreid;
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index d432f5c..14942fb 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -24,6 +24,10 @@ struct b43_bus_dev {
 	struct device *dma_dev;
 	unsigned int irq;
 
+	u16 chip_id;
+	u8 chip_rev;
+	u8 chip_pkg;
+
 	struct ssb_sprom *bus_sprom;
 
 	u16 core_id;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index fd1e74c..e80aaef 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2588,7 +2588,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
 
 	mask = 0x0000001F;
 	set = 0x0000000F;
-	if (dev->sdev->bus->chip_id == 0x4301) {
+	if (dev->dev->chip_id == 0x4301) {
 		mask |= 0x0060;
 		set |= 0x0060;
 	}
@@ -2748,8 +2748,8 @@ static void b43_adjust_opmode(struct b43_wldev *dev)
 
 	cfp_pretbtt = 2;
 	if ((ctl & B43_MACCTL_INFRA) && !(ctl & B43_MACCTL_AP)) {
-		if (dev->sdev->bus->chip_id == 0x4306 &&
-		    dev->sdev->bus->chip_rev == 3)
+		if (dev->dev->chip_id == 0x4306 &&
+		    dev->dev->chip_rev == 3)
 			cfp_pretbtt = 100;
 		else
 			cfp_pretbtt = 50;
@@ -4096,10 +4096,10 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 	       analog_type, phy_type, phy_rev);
 
 	/* Get RADIO versioning */
-	if (dev->sdev->bus->chip_id == 0x4317) {
-		if (dev->sdev->bus->chip_rev == 0)
+	if (dev->dev->chip_id == 0x4317) {
+		if (dev->dev->chip_rev == 0)
 			tmp = 0x3205017F;
-		else if (dev->sdev->bus->chip_rev == 1)
+		else if (dev->dev->chip_rev == 1)
 			tmp = 0x4205017F;
 		else
 			tmp = 0x5205017F;
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index ccb02af..40ce9e6 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -2088,8 +2088,8 @@ static void b43_phy_initg(struct b43_wldev *dev)
 	/* FIXME: The spec says in the following if, the 0 should be replaced
 	   'if OFDM may not be used in the current locale'
 	   but OFDM is legal everywhere */
-	if ((dev->sdev->bus->chip_id == 0x4306
-	     && dev->sdev->bus->chip_package == 2) || 0) {
+	if ((dev->dev->chip_id == 0x4306
+	     && dev->dev->chip_pkg == 2) || 0) {
 		b43_phy_mask(dev, B43_PHY_CRS0, 0xBFFF);
 		b43_phy_mask(dev, B43_PHY_OFDM(0xC3), 0x7FFF);
 	}
@@ -2203,7 +2203,7 @@ static void default_radio_attenuation(struct b43_wldev *dev,
 					 && bus->boardinfo.type ==
 					 SSB_BOARD_BU4306)
 					rf->att = 5;
-				else if (bus->chip_id == 0x4320)
+				else if (dev->dev->chip_id == 0x4320)
 					rf->att = 4;
 				else
 					rf->att = 3;
@@ -2388,7 +2388,7 @@ static int b43_gphy_init_tssi2dbm_table(struct b43_wldev *dev)
 	pab1 = (s16) (dev->dev->bus_sprom->pa0b1);
 	pab2 = (s16) (dev->dev->bus_sprom->pa0b2);
 
-	B43_WARN_ON((dev->sdev->bus->chip_id == 0x4301) &&
+	B43_WARN_ON((dev->dev->chip_id == 0x4301) &&
 		    (phy->radio_ver != 0x2050)); /* Not supported anymore */
 
 	gphy->dyn_tssi_tbl = 0;
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 41d0281..bb78be3 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -324,8 +324,8 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_8, B43_LPPHY_TR_LOOKUP_4);
 	}
 	if ((sprom->boardflags_hi & B43_BFH_FEM_BT) &&
-	    (bus->chip_id == 0x5354) &&
-	    (bus->chip_package == SSB_CHIPPACK_BCM4712S)) {
+	    (dev->dev->chip_id == 0x5354) &&
+	    (dev->dev->chip_pkg == SSB_CHIPPACK_BCM4712S)) {
 		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0006);
 		b43_phy_write(dev, B43_LPPHY_GPIO_SELECT, 0x0005);
 		b43_phy_write(dev, B43_LPPHY_GPIO_OUTEN, 0xFFFF);
@@ -450,7 +450,7 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xFC1F, 0xA0);
 	b43_phy_maskset(dev, B43_LPPHY_GAINDIRECTMISMATCH, 0xE0FF, 0x300);
 	b43_phy_maskset(dev, B43_LPPHY_HIGAINDB, 0x00FF, 0x2A00);
-	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 0)) {
+	if ((dev->dev->chip_id == 0x4325) && (dev->dev->chip_rev == 0)) {
 		b43_phy_maskset(dev, B43_LPPHY_LOWGAINDB, 0x00FF, 0x2100);
 		b43_phy_maskset(dev, B43_LPPHY_VERYLOWGAINDB, 0xFF00, 0xA);
 	} else {
@@ -468,7 +468,7 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xFFE0, 0x12);
 	b43_phy_maskset(dev, B43_LPPHY_GAINMISMATCH, 0x0FFF, 0x9000);
 
-	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 0)) {
+	if ((dev->dev->chip_id == 0x4325) && (dev->dev->chip_rev == 0)) {
 		b43_lptab_write(dev, B43_LPTAB16(0x08, 0x14), 0);
 		b43_lptab_write(dev, B43_LPTAB16(0x08, 0x12), 0x40);
 	}
@@ -493,7 +493,7 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 		      0x2000 | ((u16)lpphy->rssi_gs << 10) |
 		      ((u16)lpphy->rssi_vc << 4) | lpphy->rssi_vf);
 
-	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 0)) {
+	if ((dev->dev->chip_id == 0x4325) && (dev->dev->chip_rev == 0)) {
 		b43_phy_set(dev, B43_LPPHY_AFE_ADC_CTL_0, 0x1C);
 		b43_phy_maskset(dev, B43_LPPHY_AFE_CTL, 0x00FF, 0x8800);
 		b43_phy_maskset(dev, B43_LPPHY_AFE_ADC_CTL_1, 0xFC3C, 0x0400);
@@ -698,7 +698,7 @@ static void lpphy_radio_init(struct b43_wldev *dev)
 		lpphy_sync_stx(dev);
 		b43_phy_write(dev, B43_PHY_OFDM(0xF0), 0x5F80);
 		b43_phy_write(dev, B43_PHY_OFDM(0xF1), 0);
-		if (dev->sdev->bus->chip_id == 0x4325) {
+		if (dev->dev->chip_id == 0x4325) {
 			// TODO SSB PMU recalibration
 		}
 	}
@@ -1841,7 +1841,6 @@ static void lpphy_papd_cal(struct b43_wldev *dev, struct lpphy_tx_gains gains,
 static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct lpphy_tx_gains gains, oldgains;
 	int old_txpctl, old_afe_ovr, old_rf, old_bbmult;
 
@@ -1855,7 +1854,7 @@ static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
 
 	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
 
-	if (bus->chip_id == 0x4325 && bus->chip_rev == 0)
+	if (dev->dev->chip_id == 0x4325 && dev->dev->chip_rev == 0)
 		lpphy_papd_cal(dev, gains, 0, 1, 30);
 	else
 		lpphy_papd_cal(dev, gains, 0, 1, 65);
@@ -1871,7 +1870,6 @@ static int lpphy_rx_iq_cal(struct b43_wldev *dev, bool noise, bool tx,
 			    bool rx, bool pa, struct lpphy_tx_gains *gains)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->sdev->bus;
 	const struct lpphy_rx_iq_comp *iqcomp = NULL;
 	struct lpphy_tx_gains nogains, oldgains;
 	u16 tmp;
@@ -1880,7 +1878,7 @@ static int lpphy_rx_iq_cal(struct b43_wldev *dev, bool noise, bool tx,
 	memset(&nogains, 0, sizeof(nogains));
 	memset(&oldgains, 0, sizeof(oldgains));
 
-	if (bus->chip_id == 0x5354) {
+	if (dev->dev->chip_id == 0x5354) {
 		for (i = 0; i < ARRAY_SIZE(lpphy_5354_iq_table); i++) {
 			if (lpphy_5354_iq_table[i].chan == lpphy->channel) {
 				iqcomp = &lpphy_5354_iq_table[i];
@@ -2409,11 +2407,9 @@ static const struct b206x_channel b2063_chantbl[] = {
 
 static void lpphy_b2062_reset_pll_bias(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
-
 	b43_radio_write(dev, B2062_S_RFPLL_CTL2, 0xFF);
 	udelay(20);
-	if (bus->chip_id == 0x5354) {
+	if (dev->dev->chip_id == 0x5354) {
 		b43_radio_write(dev, B2062_N_COMM1, 4);
 		b43_radio_write(dev, B2062_S_RFPLL_CTL2, 4);
 	} else {
diff --git a/drivers/net/wireless/b43/tables_lpphy.c b/drivers/net/wireless/b43/tables_lpphy.c
index aa11755..6748c5a 100644
--- a/drivers/net/wireless/b43/tables_lpphy.c
+++ b/drivers/net/wireless/b43/tables_lpphy.c
@@ -2304,7 +2304,6 @@ void lpphy_rev0_1_table_init(struct b43_wldev *dev)
 
 void lpphy_rev2plus_table_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	int i;
 
 	B43_WARN_ON(dev->phy.rev < 2);
@@ -2341,7 +2340,7 @@ void lpphy_rev2plus_table_init(struct b43_wldev *dev)
 	b43_lptab_write_bulk(dev, B43_LPTAB32(10, 0),
 		ARRAY_SIZE(lpphy_papd_mult_table), lpphy_papd_mult_table);
 
-	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 0)) {
+	if ((dev->dev->chip_id == 0x4325) && (dev->dev->chip_rev == 0)) {
 		b43_lptab_write_bulk(dev, B43_LPTAB32(13, 0),
 			ARRAY_SIZE(lpphy_a0_gain_idx_table), lpphy_a0_gain_idx_table);
 		b43_lptab_write_bulk(dev, B43_LPTAB16(14, 0),
-- 
1.7.3.4

