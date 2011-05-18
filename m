Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57019 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1EQX3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:29:19 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so286932eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 16:29:18 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/9] b43: bus: abstract SPROM
Date: Wed, 18 May 2011 02:06:39 +0200
Message-Id: <1305677203-16660-5-git-send-email-zajec5@gmail.com> (sfid-20110518_012924_160245_1044C6C9)
In-Reply-To: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SPROM is another frequently used struct. We decided to share SPROM
struct between ssb na bcma as long as we will not need any hacks.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/bus.c          |    2 +
 drivers/net/wireless/b43/bus.h          |    2 +
 drivers/net/wireless/b43/leds.c         |    8 +-
 drivers/net/wireless/b43/lo.c           |    4 +-
 drivers/net/wireless/b43/main.c         |   10 ++--
 drivers/net/wireless/b43/phy_a.c        |   14 ++--
 drivers/net/wireless/b43/phy_g.c        |   36 ++++++------
 drivers/net/wireless/b43/phy_lp.c       |   93 ++++++++++++++++---------------
 drivers/net/wireless/b43/phy_n.c        |   18 +++---
 drivers/net/wireless/b43/tables_lpphy.c |   12 ++--
 drivers/net/wireless/b43/wa.c           |    5 +-
 drivers/net/wireless/b43/xmit.c         |    2 +-
 12 files changed, 107 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index be3d206..c116f12 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -70,6 +70,8 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 	dev->block_read = b43_bus_ssb_block_read;
 	dev->block_write = b43_bus_ssb_block_write;
 
+	dev->bus_sprom = &sdev->bus->sprom;
+
 	dev->core_id = sdev->id.coreid;
 	dev->core_rev = sdev->id.revision;
 
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index 742f084..6d575d6 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -20,6 +20,8 @@ struct b43_bus_dev {
 	void (*block_write)(struct b43_bus_dev *dev, const void *buffer,
 			    size_t count, u16 offset, u8 reg_width);
 
+	struct ssb_sprom *bus_sprom;
+
 	u16 core_id;
 	u8 core_rev;
 };
diff --git a/drivers/net/wireless/b43/leds.c b/drivers/net/wireless/b43/leds.c
index 0cafafe..26d37ef 100644
--- a/drivers/net/wireless/b43/leds.c
+++ b/drivers/net/wireless/b43/leds.c
@@ -218,10 +218,10 @@ static void b43_led_get_sprominfo(struct b43_wldev *dev,
 	struct ssb_bus *bus = dev->sdev->bus;
 	u8 sprom[4];
 
-	sprom[0] = bus->sprom.gpio0;
-	sprom[1] = bus->sprom.gpio1;
-	sprom[2] = bus->sprom.gpio2;
-	sprom[3] = bus->sprom.gpio3;
+	sprom[0] = dev->dev->bus_sprom->gpio0;
+	sprom[1] = dev->dev->bus_sprom->gpio1;
+	sprom[2] = dev->dev->bus_sprom->gpio2;
+	sprom[3] = dev->dev->bus_sprom->gpio3;
 
 	if (sprom[led_index] == 0xFF) {
 		/* There is no LED information in the SPROM
diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 2ef7d4b..b32efd4 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -98,7 +98,7 @@ static u16 lo_measure_feedthrough(struct b43_wldev *dev,
 		rfover |= pga;
 		rfover |= lna;
 		rfover |= trsw_rx;
-		if ((dev->sdev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA)
+		if ((dev->dev->bus_sprom->boardflags_lo & B43_BFL_EXTLNA)
 		    && phy->rev > 6)
 			rfover |= B43_PHY_RFOVERVAL_EXTLNA;
 
@@ -387,7 +387,7 @@ struct lo_g_saved_values {
 static void lo_measure_setup(struct b43_wldev *dev,
 			     struct lo_g_saved_values *sav)
 {
-	struct ssb_sprom *sprom = &dev->sdev->bus->sprom;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	struct b43_txpower_lo_control *lo = gphy->lo_control;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 971ec1b..0f3a104 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1427,9 +1427,9 @@ u8 b43_ieee80211_antenna_sanitize(struct b43_wldev *dev,
 
 	/* Get the mask of available antennas. */
 	if (dev->phy.gmode)
-		antenna_mask = dev->sdev->bus->sprom.ant_available_bg;
+		antenna_mask = dev->dev->bus_sprom->ant_available_bg;
 	else
-		antenna_mask = dev->sdev->bus->sprom.ant_available_a;
+		antenna_mask = dev->dev->bus_sprom->ant_available_a;
 
 	if (!(antenna_mask & (1 << (antenna_nr - 1)))) {
 		/* This antenna is not available. Fall back to default. */
@@ -2599,7 +2599,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
 		mask |= 0x0180;
 		set |= 0x0180;
 	}
-	if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_PACTRL) {
+	if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_PACTRL) {
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
 			    b43_read16(dev, B43_MMIO_GPIO_MASK)
 			    | 0x0200);
@@ -4204,7 +4204,7 @@ static void setup_struct_wldev_for_init(struct b43_wldev *dev)
 
 static void b43_bluetooth_coext_enable(struct b43_wldev *dev)
 {
-	struct ssb_sprom *sprom = &dev->sdev->bus->sprom;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	u64 hf;
 
 	if (!modparam_btcoex)
@@ -4318,7 +4318,7 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 static int b43_wireless_core_init(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->sdev->bus;
-	struct ssb_sprom *sprom = &bus->sprom;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 	int err;
 	u64 hf;
diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index b01c8ce..821b516 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -311,7 +311,7 @@ void b43_phy_inita(struct b43_wldev *dev)
 	}
 
 	if ((phy->type == B43_PHYTYPE_G) &&
-	    (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)) {
+	    (dev->dev->bus_sprom->boardflags_lo & B43_BFL_PACTRL)) {
 		b43_phy_maskset(dev, B43_PHY_OFDM(0x6E), 0xE000, 0x3CF);
 	}
 }
@@ -323,17 +323,17 @@ static int b43_aphy_init_tssi2dbm_table(struct b43_wldev *dev)
 	struct b43_phy_a *aphy = phy->a;
 	s16 pab0, pab1, pab2;
 
-	pab0 = (s16) (dev->sdev->bus->sprom.pa1b0);
-	pab1 = (s16) (dev->sdev->bus->sprom.pa1b1);
-	pab2 = (s16) (dev->sdev->bus->sprom.pa1b2);
+	pab0 = (s16) (dev->dev->bus_sprom->pa1b0);
+	pab1 = (s16) (dev->dev->bus_sprom->pa1b1);
+	pab2 = (s16) (dev->dev->bus_sprom->pa1b2);
 
 	if (pab0 != 0 && pab1 != 0 && pab2 != 0 &&
 	    pab0 != -1 && pab1 != -1 && pab2 != -1) {
 		/* The pabX values are set in SPROM. Use them. */
-		if ((s8) dev->sdev->bus->sprom.itssi_a != 0 &&
-		    (s8) dev->sdev->bus->sprom.itssi_a != -1)
+		if ((s8) dev->dev->bus_sprom->itssi_a != 0 &&
+		    (s8) dev->dev->bus_sprom->itssi_a != -1)
 			aphy->tgt_idle_tssi =
-			    (s8) (dev->sdev->bus->sprom.itssi_a);
+			    (s8) (dev->dev->bus_sprom->itssi_a);
 		else
 			aphy->tgt_idle_tssi = 62;
 		aphy->tssi2dbm = b43_generate_dyn_tssi2dbm_tab(dev, pab0,
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 1758a28..ccb02af 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -718,7 +718,7 @@ static void b43_calc_nrssi_threshold(struct b43_wldev *dev)
 	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
 
 	if (!phy->gmode ||
-	    !(dev->sdev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
+	    !(dev->dev->bus_sprom->boardflags_lo & B43_BFL_RSSI)) {
 		tmp16 = b43_nrssi_hw_read(dev, 0x20);
 		if (tmp16 >= 0x20)
 			tmp16 -= 0x40;
@@ -1114,7 +1114,7 @@ static u16 radio2050_rfover_val(struct b43_wldev *dev,
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
-	struct ssb_sprom *sprom = &(dev->sdev->bus->sprom);
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
 	if (!phy->gmode)
 		return 0;
@@ -1620,7 +1620,7 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 		b43_radio_write16(dev, 0x5A, 0x88);
 		b43_radio_write16(dev, 0x5B, 0x6B);
 		b43_radio_write16(dev, 0x5C, 0x0F);
-		if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_ALTIQ) {
+		if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_ALTIQ) {
 			b43_radio_write16(dev, 0x5D, 0xFA);
 			b43_radio_write16(dev, 0x5E, 0xD8);
 		} else {
@@ -1787,7 +1787,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	b43_phy_set(dev, B43_PHY_RFOVER, 0x0100);
 	b43_phy_mask(dev, B43_PHY_RFOVERVAL, 0xCFFF);
 
-	if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA) {
+	if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_EXTLNA) {
 		if (phy->rev >= 7) {
 			b43_phy_set(dev, B43_PHY_RFOVER, 0x0800);
 			b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x8000);
@@ -2053,7 +2053,7 @@ static void b43_phy_initg(struct b43_wldev *dev)
 	if (phy->rev >= 6) {
 		b43_phy_maskset(dev, B43_PHY_CCK(0x36), 0x0FFF, (gphy->lo_control->tx_bias << 12));
 	}
-	if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
+	if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_PACTRL)
 		b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x8075);
 	else
 		b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x807F);
@@ -2066,7 +2066,7 @@ static void b43_phy_initg(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0x8078);
 	}
 
-	if (!(dev->sdev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
+	if (!(dev->dev->bus_sprom->boardflags_lo & B43_BFL_RSSI)) {
 		/* The specs state to update the NRSSI LT with
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
@@ -2105,7 +2105,7 @@ void b43_gphy_channel_switch(struct b43_wldev *dev,
 	b43_write16(dev, B43_MMIO_CHANNEL, channel2freq_bg(channel));
 
 	if (channel == 14) {
-		if (dev->sdev->bus->sprom.country_code ==
+		if (dev->dev->bus_sprom->country_code ==
 		    SSB_SPROM1CCODE_JAPAN)
 			b43_hf_write(dev,
 				     b43_hf_read(dev) & ~B43_HF_ACPR);
@@ -2384,9 +2384,9 @@ static int b43_gphy_init_tssi2dbm_table(struct b43_wldev *dev)
 	struct b43_phy_g *gphy = phy->g;
 	s16 pab0, pab1, pab2;
 
-	pab0 = (s16) (dev->sdev->bus->sprom.pa0b0);
-	pab1 = (s16) (dev->sdev->bus->sprom.pa0b1);
-	pab2 = (s16) (dev->sdev->bus->sprom.pa0b2);
+	pab0 = (s16) (dev->dev->bus_sprom->pa0b0);
+	pab1 = (s16) (dev->dev->bus_sprom->pa0b1);
+	pab2 = (s16) (dev->dev->bus_sprom->pa0b2);
 
 	B43_WARN_ON((dev->sdev->bus->chip_id == 0x4301) &&
 		    (phy->radio_ver != 0x2050)); /* Not supported anymore */
@@ -2396,10 +2396,10 @@ static int b43_gphy_init_tssi2dbm_table(struct b43_wldev *dev)
 	if (pab0 != 0 && pab1 != 0 && pab2 != 0 &&
 	    pab0 != -1 && pab1 != -1 && pab2 != -1) {
 		/* The pabX values are set in SPROM. Use them. */
-		if ((s8) dev->sdev->bus->sprom.itssi_bg != 0 &&
-		    (s8) dev->sdev->bus->sprom.itssi_bg != -1) {
+		if ((s8) dev->dev->bus_sprom->itssi_bg != 0 &&
+		    (s8) dev->dev->bus_sprom->itssi_bg != -1) {
 			gphy->tgt_idle_tssi =
-				(s8) (dev->sdev->bus->sprom.itssi_bg);
+				(s8) (dev->dev->bus_sprom->itssi_bg);
 		} else
 			gphy->tgt_idle_tssi = 62;
 		gphy->tssi2dbm = b43_generate_dyn_tssi2dbm_tab(dev, pab0,
@@ -2840,7 +2840,7 @@ static void b43_gphy_op_adjust_txpower(struct b43_wldev *dev)
 				    B43_TXCTL_TXMIX;
 				rfatt += 2;
 				bbatt += 2;
-			} else if (dev->sdev->bus->sprom.
+			} else if (dev->dev->bus_sprom->
 				   boardflags_lo &
 				   B43_BFL_PACTRL) {
 				bbatt += 4 * (rfatt - 2);
@@ -2914,14 +2914,14 @@ static enum b43_txpwr_result b43_gphy_op_recalc_txpower(struct b43_wldev *dev,
 	estimated_pwr = b43_gphy_estimate_power_out(dev, average_tssi);
 
 	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
-	max_pwr = dev->sdev->bus->sprom.maxpwr_bg;
-	if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
+	max_pwr = dev->dev->bus_sprom->maxpwr_bg;
+	if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_PACTRL)
 		max_pwr -= 3; /* minus 0.75 */
 	if (unlikely(max_pwr >= INT_TO_Q52(30/*dBm*/))) {
 		b43warn(dev->wl,
 			"Invalid max-TX-power value in SPROM.\n");
 		max_pwr = INT_TO_Q52(20); /* fake it */
-		dev->sdev->bus->sprom.maxpwr_bg = max_pwr;
+		dev->dev->bus_sprom->maxpwr_bg = max_pwr;
 	}
 
 	/* Get desired power (in Q5.2) */
@@ -3014,7 +3014,7 @@ static void b43_gphy_op_pwork_60sec(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 
-	if (!(dev->sdev->bus->sprom.boardflags_lo & B43_BFL_RSSI))
+	if (!(dev->dev->bus_sprom->boardflags_lo & B43_BFL_RSSI))
 		return;
 
 	b43_mac_suspend(dev);
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 012c8da..41d0281 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -85,39 +85,39 @@ static void b43_lpphy_op_free(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/LP/ReadBandSrom */
 static void lpphy_read_band_sprom(struct b43_wldev *dev)
 {
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->sdev->bus;
 	u16 cckpo, maxpwr;
 	u32 ofdmpo;
 	int i;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-		lpphy->tx_isolation_med_band = bus->sprom.tri2g;
-		lpphy->bx_arch = bus->sprom.bxa2g;
-		lpphy->rx_pwr_offset = bus->sprom.rxpo2g;
-		lpphy->rssi_vf = bus->sprom.rssismf2g;
-		lpphy->rssi_vc = bus->sprom.rssismc2g;
-		lpphy->rssi_gs = bus->sprom.rssisav2g;
-		lpphy->txpa[0] = bus->sprom.pa0b0;
-		lpphy->txpa[1] = bus->sprom.pa0b1;
-		lpphy->txpa[2] = bus->sprom.pa0b2;
-		maxpwr = bus->sprom.maxpwr_bg;
+		lpphy->tx_isolation_med_band = sprom->tri2g;
+		lpphy->bx_arch = sprom->bxa2g;
+		lpphy->rx_pwr_offset = sprom->rxpo2g;
+		lpphy->rssi_vf = sprom->rssismf2g;
+		lpphy->rssi_vc = sprom->rssismc2g;
+		lpphy->rssi_gs = sprom->rssisav2g;
+		lpphy->txpa[0] = sprom->pa0b0;
+		lpphy->txpa[1] = sprom->pa0b1;
+		lpphy->txpa[2] = sprom->pa0b2;
+		maxpwr = sprom->maxpwr_bg;
 		lpphy->max_tx_pwr_med_band = maxpwr;
-		cckpo = bus->sprom.cck2gpo;
+		cckpo = sprom->cck2gpo;
 		/*
 		 * We don't read SPROM's opo as specs say. On rev8 SPROMs
 		 * opo == ofdm2gpo and we don't know any SSB with LP-PHY
 		 * and SPROM rev below 8.
 		 */
-		B43_WARN_ON(bus->sprom.revision < 8);
-		ofdmpo = bus->sprom.ofdm2gpo;
+		B43_WARN_ON(sprom->revision < 8);
+		ofdmpo = sprom->ofdm2gpo;
 		if (cckpo) {
 			for (i = 0; i < 4; i++) {
 				lpphy->tx_max_rate[i] =
 					maxpwr - (ofdmpo & 0xF) * 2;
 				ofdmpo >>= 4;
 			}
-			ofdmpo = bus->sprom.ofdm2gpo;
+			ofdmpo = sprom->ofdm2gpo;
 			for (i = 4; i < 15; i++) {
 				lpphy->tx_max_rate[i] =
 					maxpwr - (ofdmpo & 0xF) * 2;
@@ -131,39 +131,39 @@ static void lpphy_read_band_sprom(struct b43_wldev *dev)
 				lpphy->tx_max_rate[i] = maxpwr - ofdmpo;
 		}
 	} else { /* 5GHz */
-		lpphy->tx_isolation_low_band = bus->sprom.tri5gl;
-		lpphy->tx_isolation_med_band = bus->sprom.tri5g;
-		lpphy->tx_isolation_hi_band = bus->sprom.tri5gh;
-		lpphy->bx_arch = bus->sprom.bxa5g;
-		lpphy->rx_pwr_offset = bus->sprom.rxpo5g;
-		lpphy->rssi_vf = bus->sprom.rssismf5g;
-		lpphy->rssi_vc = bus->sprom.rssismc5g;
-		lpphy->rssi_gs = bus->sprom.rssisav5g;
-		lpphy->txpa[0] = bus->sprom.pa1b0;
-		lpphy->txpa[1] = bus->sprom.pa1b1;
-		lpphy->txpa[2] = bus->sprom.pa1b2;
-		lpphy->txpal[0] = bus->sprom.pa1lob0;
-		lpphy->txpal[1] = bus->sprom.pa1lob1;
-		lpphy->txpal[2] = bus->sprom.pa1lob2;
-		lpphy->txpah[0] = bus->sprom.pa1hib0;
-		lpphy->txpah[1] = bus->sprom.pa1hib1;
-		lpphy->txpah[2] = bus->sprom.pa1hib2;
-		maxpwr = bus->sprom.maxpwr_al;
-		ofdmpo = bus->sprom.ofdm5glpo;
+		lpphy->tx_isolation_low_band = sprom->tri5gl;
+		lpphy->tx_isolation_med_band = sprom->tri5g;
+		lpphy->tx_isolation_hi_band = sprom->tri5gh;
+		lpphy->bx_arch = sprom->bxa5g;
+		lpphy->rx_pwr_offset = sprom->rxpo5g;
+		lpphy->rssi_vf = sprom->rssismf5g;
+		lpphy->rssi_vc = sprom->rssismc5g;
+		lpphy->rssi_gs = sprom->rssisav5g;
+		lpphy->txpa[0] = sprom->pa1b0;
+		lpphy->txpa[1] = sprom->pa1b1;
+		lpphy->txpa[2] = sprom->pa1b2;
+		lpphy->txpal[0] = sprom->pa1lob0;
+		lpphy->txpal[1] = sprom->pa1lob1;
+		lpphy->txpal[2] = sprom->pa1lob2;
+		lpphy->txpah[0] = sprom->pa1hib0;
+		lpphy->txpah[1] = sprom->pa1hib1;
+		lpphy->txpah[2] = sprom->pa1hib2;
+		maxpwr = sprom->maxpwr_al;
+		ofdmpo = sprom->ofdm5glpo;
 		lpphy->max_tx_pwr_low_band = maxpwr;
 		for (i = 4; i < 12; i++) {
 			lpphy->tx_max_ratel[i] = maxpwr - (ofdmpo & 0xF) * 2;
 			ofdmpo >>= 4;
 		}
-		maxpwr = bus->sprom.maxpwr_a;
-		ofdmpo = bus->sprom.ofdm5gpo;
+		maxpwr = sprom->maxpwr_a;
+		ofdmpo = sprom->ofdm5gpo;
 		lpphy->max_tx_pwr_med_band = maxpwr;
 		for (i = 4; i < 12; i++) {
 			lpphy->tx_max_rate[i] = maxpwr - (ofdmpo & 0xF) * 2;
 			ofdmpo >>= 4;
 		}
-		maxpwr = bus->sprom.maxpwr_ah;
-		ofdmpo = bus->sprom.ofdm5ghpo;
+		maxpwr = sprom->maxpwr_ah;
+		ofdmpo = sprom->ofdm5ghpo;
 		lpphy->max_tx_pwr_hi_band = maxpwr;
 		for (i = 4; i < 12; i++) {
 			lpphy->tx_max_rateh[i] = maxpwr - (ofdmpo & 0xF) * 2;
@@ -215,6 +215,7 @@ static void lpphy_table_init(struct b43_wldev *dev)
 static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	u16 tmp, tmp2;
 
@@ -242,9 +243,9 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_LPPHY_CRS_ED_THRESH, 0x00FF, 0xAD00);
 	b43_phy_maskset(dev, B43_LPPHY_INPUT_PWRDB,
 			0xFF00, lpphy->rx_pwr_offset);
-	if ((bus->sprom.boardflags_lo & B43_BFL_FEM) &&
+	if ((sprom->boardflags_lo & B43_BFL_FEM) &&
 	   ((b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ||
-	   (bus->sprom.boardflags_hi & B43_BFH_PAREF))) {
+	   (sprom->boardflags_hi & B43_BFH_PAREF))) {
 		ssb_pmu_set_ldo_voltage(&bus->chipco, LDO_PAREF, 0x28);
 		ssb_pmu_set_ldo_paref(&bus->chipco, true);
 		if (dev->phy.rev == 0) {
@@ -260,7 +261,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 	}
 	tmp = lpphy->rssi_vf | lpphy->rssi_vc << 4 | 0xA000;
 	b43_phy_write(dev, B43_LPPHY_AFE_RSSI_CTL_0, tmp);
-	if (bus->sprom.boardflags_hi & B43_BFH_RSSIINV)
+	if (sprom->boardflags_hi & B43_BFH_RSSIINV)
 		b43_phy_maskset(dev, B43_LPPHY_AFE_RSSI_CTL_1, 0xF000, 0x0AAA);
 	else
 		b43_phy_maskset(dev, B43_LPPHY_AFE_RSSI_CTL_1, 0xF000, 0x02AA);
@@ -268,7 +269,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_LPPHY_RX_RADIO_CTL,
 			0xFFF9, (lpphy->bx_arch << 1));
 	if (dev->phy.rev == 1 &&
-	   (bus->sprom.boardflags_hi & B43_BFH_FEM_BT)) {
+	   (sprom->boardflags_hi & B43_BFH_FEM_BT)) {
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x000A);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0x3F00, 0x0900);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xFFC0, 0x000A);
@@ -287,7 +288,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_8, 0xC0FF, 0x0B00);
 	} else if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ ||
 		  (bus->boardinfo.type == 0x048A) || ((dev->phy.rev == 0) &&
-		  (bus->sprom.boardflags_lo & B43_BFL_FEM))) {
+		  (sprom->boardflags_lo & B43_BFL_FEM))) {
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x0001);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xC0FF, 0x0400);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xFFC0, 0x0001);
@@ -297,7 +298,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xFFC0, 0x0002);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xC0FF, 0x0A00);
 	} else if (dev->phy.rev == 1 ||
-		  (bus->sprom.boardflags_lo & B43_BFL_FEM)) {
+		  (sprom->boardflags_lo & B43_BFL_FEM)) {
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x0004);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xC0FF, 0x0800);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_2, 0xFFC0, 0x0004);
@@ -316,13 +317,13 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xFFC0, 0x0006);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xC0FF, 0x0700);
 	}
-	if (dev->phy.rev == 1 && (bus->sprom.boardflags_hi & B43_BFH_PAREF)) {
+	if (dev->phy.rev == 1 && (sprom->boardflags_hi & B43_BFH_PAREF)) {
 		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_5, B43_LPPHY_TR_LOOKUP_1);
 		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_6, B43_LPPHY_TR_LOOKUP_2);
 		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_7, B43_LPPHY_TR_LOOKUP_3);
 		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_8, B43_LPPHY_TR_LOOKUP_4);
 	}
-	if ((bus->sprom.boardflags_hi & B43_BFH_FEM_BT) &&
+	if ((sprom->boardflags_hi & B43_BFH_FEM_BT) &&
 	    (bus->chip_id == 0x5354) &&
 	    (bus->chip_package == SSB_CHIPPACK_BCM4712S)) {
 		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0006);
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 40f1db7..99ea191 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -299,7 +299,7 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
-	struct ssb_sprom *sprom = &(dev->sdev->bus->sprom);
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
 	u8 txpi[2], bbmult, i;
 	u16 tmp, radio_gain, dac_gain;
@@ -423,7 +423,7 @@ static void b43_radio_init2055_pre(struct b43_wldev *dev)
 static void b43_radio_init2055_post(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
-	struct ssb_sprom *sprom = &(dev->sdev->bus->sprom);
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct ssb_boardinfo *binfo = &(dev->sdev->bus->boardinfo);
 	int i;
 	u16 val;
@@ -1168,7 +1168,7 @@ static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
-	struct ssb_sprom *sprom = &(dev->sdev->bus->sprom);
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
 	/* PHY rev 0, 1, 2 */
 	u8 i, j;
@@ -1374,6 +1374,7 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 static void b43_nphy_workarounds(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
 
@@ -1443,9 +1444,9 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 
 		/* N PHY WAR TX Chain Update with hw_phytxchain as argument */
 
-		if ((bus->sprom.boardflags2_lo & B43_BFL2_APLL_WAR &&
+		if ((sprom->boardflags2_lo & B43_BFL2_APLL_WAR &&
 		    b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ||
-		    (bus->sprom.boardflags2_lo & B43_BFL2_GPLL_WAR &&
+		    (sprom->boardflags2_lo & B43_BFL2_GPLL_WAR &&
 		    b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ))
 			tmp32 = 0x00088888;
 		else
@@ -1503,7 +1504,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
 		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
 
-		if (bus->sprom.boardflags2_lo & 0x100 &&
+		if (sprom->boardflags2_lo & 0x100 &&
 		    bus->boardinfo.type == 0x8B) {
 			delays1[0] = 0x1;
 			delays1[5] = 0x14;
@@ -3587,6 +3588,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 int b43_phy_initn(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
 	u8 tx_pwr_state;
@@ -3599,7 +3601,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	bool do_cal = false;
 
 	if ((dev->phy.rev >= 3) &&
-	   (bus->sprom.boardflags_lo & B43_BFL_EXTLNA) &&
+	   (sprom->boardflags_lo & B43_BFL_EXTLNA) &&
 	   (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)) {
 		chipco_set32(&dev->sdev->bus->chipco, SSB_CHIPCO_CHIPCTL, 0x40);
 	}
@@ -3639,7 +3641,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_AFESEQ_TX2RX_PUD_20M, 0x20);
 	b43_phy_write(dev, B43_NPHY_AFESEQ_TX2RX_PUD_40M, 0x20);
 
-	if (bus->sprom.boardflags2_lo & 0x100 ||
+	if (sprom->boardflags2_lo & 0x100 ||
 	    (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	     bus->boardinfo.type == 0x8B))
 		b43_phy_write(dev, B43_NPHY_TXREALFD, 0xA0);
diff --git a/drivers/net/wireless/b43/tables_lpphy.c b/drivers/net/wireless/b43/tables_lpphy.c
index 59df3c6..aa11755 100644
--- a/drivers/net/wireless/b43/tables_lpphy.c
+++ b/drivers/net/wireless/b43/tables_lpphy.c
@@ -2416,12 +2416,12 @@ void lpphy_write_gain_table_bulk(struct b43_wldev *dev, int offset, int count,
 
 void lpphy_init_tx_gain_table(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
 	switch (dev->phy.rev) {
 	case 0:
-		if ((bus->sprom.boardflags_hi & B43_BFH_NOPA) ||
-		    (bus->sprom.boardflags_lo & B43_BFL_HGPA))
+		if ((sprom->boardflags_hi & B43_BFH_NOPA) ||
+		    (sprom->boardflags_lo & B43_BFL_HGPA))
 			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev0_nopa_tx_gain_table);
 		else if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
@@ -2432,8 +2432,8 @@ void lpphy_init_tx_gain_table(struct b43_wldev *dev)
 					lpphy_rev0_5ghz_tx_gain_table);
 		break;
 	case 1:
-		if ((bus->sprom.boardflags_hi & B43_BFH_NOPA) ||
-		    (bus->sprom.boardflags_lo & B43_BFL_HGPA))
+		if ((sprom->boardflags_hi & B43_BFH_NOPA) ||
+		    (sprom->boardflags_lo & B43_BFL_HGPA))
 			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev1_nopa_tx_gain_table);
 		else if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
@@ -2444,7 +2444,7 @@ void lpphy_init_tx_gain_table(struct b43_wldev *dev)
 					lpphy_rev1_5ghz_tx_gain_table);
 		break;
 	default:
-		if (bus->sprom.boardflags_hi & B43_BFH_NOPA)
+		if (sprom->boardflags_hi & B43_BFH_NOPA)
 			lpphy_write_gain_table_bulk(dev, 0, 128,
 					lpphy_rev2_nopa_tx_gain_table);
 		else if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index 8f4db44..2829ee1 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -487,6 +487,7 @@ static void b43_wa_boards_a(struct b43_wldev *dev)
 static void b43_wa_boards_g(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 
 	if (bus->boardinfo.vendor != SSB_BOARDVENDOR_BCM ||
@@ -498,7 +499,7 @@ static void b43_wa_boards_g(struct b43_wldev *dev)
 		} else {
 			b43_ofdmtab_write16(dev, B43_OFDMTAB_GAINX, 1, 0x0002);
 			b43_ofdmtab_write16(dev, B43_OFDMTAB_GAINX, 2, 0x0001);
-			if ((bus->sprom.boardflags_lo & B43_BFL_EXTLNA) &&
+			if ((sprom->boardflags_lo & B43_BFL_EXTLNA) &&
 			    (phy->rev >= 7)) {
 				b43_phy_mask(dev, B43_PHY_EXTG(0x11), 0xF7FF);
 				b43_ofdmtab_write16(dev, B43_OFDMTAB_GAINX, 0x0020, 0x0001);
@@ -510,7 +511,7 @@ static void b43_wa_boards_g(struct b43_wldev *dev)
 			}
 		}
 	}
-	if (bus->sprom.boardflags_lo & B43_BFL_FEM) {
+	if (sprom->boardflags_lo & B43_BFL_FEM) {
 		b43_phy_write(dev, B43_PHY_GTABCTL, 0x3120);
 		b43_phy_write(dev, B43_PHY_GTABDATA, 0xC480);
 	}
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index c8f99ae..488b898 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -547,7 +547,7 @@ static s8 b43_rssi_postprocess(struct b43_wldev *dev,
 			else
 				tmp -= 3;
 		} else {
-			if (dev->sdev->bus->sprom.
+			if (dev->dev->bus_sprom->
 			    boardflags_lo & B43_BFL_RSSI) {
 				if (in_rssi > 63)
 					in_rssi = 63;
-- 
1.7.3.4

