Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57019 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1EQX3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:29:33 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so286932eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 16:29:33 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 8/9] b43: bus: abstract board info
Date: Wed, 18 May 2011 02:06:42 +0200
Message-Id: <1305677203-16660-8-git-send-email-zajec5@gmail.com> (sfid-20110518_012937_564391_98ECD36A)
In-Reply-To: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/bus.c        |    4 +++
 drivers/net/wireless/b43/bus.h        |    4 +++
 drivers/net/wireless/b43/leds.c       |    5 +--
 drivers/net/wireless/b43/phy_a.c      |    7 ++---
 drivers/net/wireless/b43/phy_common.c |    4 +-
 drivers/net/wireless/b43/phy_g.c      |   48 +++++++++++++++-----------------
 drivers/net/wireless/b43/phy_lp.c     |    5 +--
 drivers/net/wireless/b43/phy_n.c      |   15 ++++------
 drivers/net/wireless/b43/wa.c         |   19 +++++-------
 9 files changed, 54 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 8d0e758..f897b70 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -74,6 +74,10 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 	dev->dma_dev = sdev->dma_dev;
 	dev->irq = sdev->irq;
 
+	dev->board_vendor = sdev->bus->boardinfo.vendor;
+	dev->board_type = sdev->bus->boardinfo.type;
+	dev->board_rev = sdev->bus->boardinfo.rev;
+
 	dev->chip_id = sdev->bus->chip_id;
 	dev->chip_rev = sdev->bus->chip_rev;
 	dev->chip_pkg = sdev->bus->chip_package;
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index 14942fb..e88b449 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -24,6 +24,10 @@ struct b43_bus_dev {
 	struct device *dma_dev;
 	unsigned int irq;
 
+	u16 board_vendor;
+	u16 board_type;
+	u16 board_rev;
+
 	u16 chip_id;
 	u8 chip_rev;
 	u8 chip_pkg;
diff --git a/drivers/net/wireless/b43/leds.c b/drivers/net/wireless/b43/leds.c
index 70bcf42..b56ed41 100644
--- a/drivers/net/wireless/b43/leds.c
+++ b/drivers/net/wireless/b43/leds.c
@@ -215,7 +215,6 @@ static void b43_led_get_sprominfo(struct b43_wldev *dev,
 				  enum b43_led_behaviour *behaviour,
 				  bool *activelow)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	u8 sprom[4];
 
 	sprom[0] = dev->dev->bus_sprom->gpio0;
@@ -231,12 +230,12 @@ static void b43_led_get_sprominfo(struct b43_wldev *dev,
 		case 0:
 			*behaviour = B43_LED_ACTIVITY;
 			*activelow = 1;
-			if (bus->boardinfo.vendor == PCI_VENDOR_ID_COMPAQ)
+			if (dev->dev->board_vendor == PCI_VENDOR_ID_COMPAQ)
 				*behaviour = B43_LED_RADIO_ALL;
 			break;
 		case 1:
 			*behaviour = B43_LED_RADIO_B;
-			if (bus->boardinfo.vendor == PCI_VENDOR_ID_ASUSTEK)
+			if (dev->dev->board_vendor == PCI_VENDOR_ID_ASUSTEK)
 				*behaviour = B43_LED_ASSOC;
 			break;
 		case 2:
diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index 821b516..73ace55 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -265,7 +265,6 @@ static void hardware_pctl_init_aphy(struct b43_wldev *dev)
 
 void b43_phy_inita(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 
 	/* This lowlevel A-PHY init is also called from G-PHY init.
@@ -296,9 +295,9 @@ void b43_phy_inita(struct b43_wldev *dev)
 
 		b43_radio_init2060(dev);
 
-		if ((bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM) &&
-		    ((bus->boardinfo.type == SSB_BOARD_BU4306) ||
-		     (bus->boardinfo.type == SSB_BOARD_BU4309))) {
+		if ((dev->dev->board_vendor == SSB_BOARDVENDOR_BCM) &&
+		    ((dev->dev->board_type == SSB_BOARD_BU4306) ||
+		     (dev->dev->board_type == SSB_BOARD_BU4309))) {
 			; //TODO: A PHY LO
 		}
 
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 3f7bdf8..425af28 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -368,8 +368,8 @@ void b43_phy_txpower_check(struct b43_wldev *dev, unsigned int flags)
 	/* The next check will be needed in two seconds, or later. */
 	phy->next_txpwr_check_time = round_jiffies(now + (HZ * 2));
 
-	if ((dev->sdev->bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM) &&
-	    (dev->sdev->bus->boardinfo.type == SSB_BOARD_BU4306))
+	if ((dev->dev->board_vendor == SSB_BOARDVENDOR_BCM) &&
+	    (dev->dev->board_type == SSB_BOARD_BU4306))
 		return; /* No software txpower adjustment needed */
 
 	result = phy->ops->recalc_txpower(dev, !!(flags & B43_TXPWR_IGNORE_TSSI));
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 40ce9e6..684be1f 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -1491,7 +1491,6 @@ static u16 b43_radio_init2050(struct b43_wldev *dev)
 
 static void b43_phy_initb5(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	u16 offset, value;
@@ -1500,8 +1499,8 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 	if (phy->analog == 1) {
 		b43_radio_set(dev, 0x007A, 0x0050);
 	}
-	if ((bus->boardinfo.vendor != SSB_BOARDVENDOR_BCM) &&
-	    (bus->boardinfo.type != SSB_BOARD_BU4306)) {
+	if ((dev->dev->board_vendor != SSB_BOARDVENDOR_BCM) &&
+	    (dev->dev->board_type != SSB_BOARD_BU4306)) {
 		value = 0x2120;
 		for (offset = 0x00A8; offset < 0x00C7; offset++) {
 			b43_phy_write(dev, offset, value);
@@ -1922,7 +1921,6 @@ static void b43_hardware_pctl_init_gphy(struct b43_wldev *dev)
 /* Initialize B/G PHY power control */
 static void b43_phy_init_pctl(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	struct b43_rfatt old_rfatt;
@@ -1931,8 +1929,8 @@ static void b43_phy_init_pctl(struct b43_wldev *dev)
 
 	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
 
-	if ((bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM) &&
-	    (bus->boardinfo.type == SSB_BOARD_BU4306))
+	if ((dev->dev->board_vendor == SSB_BOARDVENDOR_BCM) &&
+	    (dev->dev->board_type == SSB_BOARD_BU4306))
 		return;
 
 	b43_phy_write(dev, 0x0028, 0x8018);
@@ -2136,17 +2134,17 @@ static void default_baseband_attenuation(struct b43_wldev *dev,
 static void default_radio_attenuation(struct b43_wldev *dev,
 				      struct b43_rfatt *rf)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
+	struct b43_bus_dev *bdev = dev->dev;
 	struct b43_phy *phy = &dev->phy;
 
 	rf->with_padmix = 0;
 
-	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM &&
-	    bus->boardinfo.type == SSB_BOARD_BCM4309G) {
-		if (bus->boardinfo.rev < 0x43) {
+	if (dev->dev->board_vendor == SSB_BOARDVENDOR_BCM &&
+	    dev->dev->board_type == SSB_BOARD_BCM4309G) {
+		if (dev->dev->board_rev < 0x43) {
 			rf->att = 2;
 			return;
-		} else if (bus->boardinfo.rev < 0x51) {
+		} else if (dev->dev->board_rev < 0x51) {
 			rf->att = 3;
 			return;
 		}
@@ -2172,21 +2170,21 @@ static void default_radio_attenuation(struct b43_wldev *dev,
 			return;
 		case 1:
 			if (phy->type == B43_PHYTYPE_G) {
-				if (bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM
-				    && bus->boardinfo.type == SSB_BOARD_BCM4309G
-				    && bus->boardinfo.rev >= 30)
+				if (bdev->board_vendor == SSB_BOARDVENDOR_BCM
+				    && bdev->board_type == SSB_BOARD_BCM4309G
+				    && bdev->board_rev >= 30)
 					rf->att = 3;
-				else if (bus->boardinfo.vendor ==
+				else if (bdev->board_vendor ==
 					 SSB_BOARDVENDOR_BCM
-					 && bus->boardinfo.type ==
+					 && bdev->board_type ==
 					 SSB_BOARD_BU4306)
 					rf->att = 3;
 				else
 					rf->att = 1;
 			} else {
-				if (bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM
-				    && bus->boardinfo.type == SSB_BOARD_BCM4309G
-				    && bus->boardinfo.rev >= 30)
+				if (bdev->board_vendor == SSB_BOARDVENDOR_BCM
+				    && bdev->board_type == SSB_BOARD_BCM4309G
+				    && bdev->board_rev >= 30)
 					rf->att = 7;
 				else
 					rf->att = 6;
@@ -2194,16 +2192,16 @@ static void default_radio_attenuation(struct b43_wldev *dev,
 			return;
 		case 2:
 			if (phy->type == B43_PHYTYPE_G) {
-				if (bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM
-				    && bus->boardinfo.type == SSB_BOARD_BCM4309G
-				    && bus->boardinfo.rev >= 30)
+				if (bdev->board_vendor == SSB_BOARDVENDOR_BCM
+				    && bdev->board_type == SSB_BOARD_BCM4309G
+				    && bdev->board_rev >= 30)
 					rf->att = 3;
-				else if (bus->boardinfo.vendor ==
+				else if (bdev->board_vendor ==
 					 SSB_BOARDVENDOR_BCM
-					 && bus->boardinfo.type ==
+					 && bdev->board_type ==
 					 SSB_BOARD_BU4306)
 					rf->att = 5;
-				else if (dev->dev->chip_id == 0x4320)
+				else if (bdev->chip_id == 0x4320)
 					rf->att = 4;
 				else
 					rf->att = 3;
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index bb78be3..2606c25 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -287,7 +287,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_8, 0xFFC0, 0x000A);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_8, 0xC0FF, 0x0B00);
 	} else if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ ||
-		  (bus->boardinfo.type == 0x048A) || ((dev->phy.rev == 0) &&
+		  (dev->dev->board_type == 0x048A) || ((dev->phy.rev == 0) &&
 		  (sprom->boardflags_lo & B43_BFL_FEM))) {
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x0001);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xC0FF, 0x0400);
@@ -413,7 +413,6 @@ static void lpphy_restore_dig_flt_state(struct b43_wldev *dev)
 
 static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 
 	b43_phy_write(dev, B43_LPPHY_AFE_DAC_CTL, 0x50);
@@ -433,7 +432,7 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 	b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x4000);
 	b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x2000);
 	b43_phy_set(dev, B43_PHY_OFDM(0x10A), 0x1);
-	if (bus->boardinfo.rev >= 0x18) {
+	if (dev->dev->board_rev >= 0x18) {
 		b43_lptab_write(dev, B43_LPTAB32(17, 65), 0xEC);
 		b43_phy_maskset(dev, B43_PHY_OFDM(0x10A), 0xFF01, 0x14);
 	} else {
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 99ea191..03c4f57 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -424,15 +424,14 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
-	struct ssb_boardinfo *binfo = &(dev->sdev->bus->boardinfo);
 	int i;
 	u16 val;
 	bool workaround = false;
 
 	if (sprom->revision < 4)
-		workaround = (binfo->vendor != PCI_VENDOR_ID_BROADCOM &&
-				binfo->type == 0x46D &&
-				binfo->rev >= 0x41);
+		workaround = (dev->dev->board_vendor != PCI_VENDOR_ID_BROADCOM
+			      && dev->dev->board_type == 0x46D
+			      && dev->dev->board_rev >= 0x41);
 	else
 		workaround =
 			!(sprom->boardflags2_lo & B43_BFL2_RXBB_INT_REG_DIS);
@@ -1373,7 +1372,6 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
 static void b43_nphy_workarounds(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
@@ -1505,7 +1503,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
 
 		if (sprom->boardflags2_lo & 0x100 &&
-		    bus->boardinfo.type == 0x8B) {
+		    dev->dev->board_type == 0x8B) {
 			delays1[0] = 0x1;
 			delays1[5] = 0x14;
 		}
@@ -3587,7 +3585,6 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
  */
 int b43_phy_initn(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
@@ -3642,8 +3639,8 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_AFESEQ_TX2RX_PUD_40M, 0x20);
 
 	if (sprom->boardflags2_lo & 0x100 ||
-	    (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
-	     bus->boardinfo.type == 0x8B))
+	    (dev->dev->board_vendor == PCI_VENDOR_ID_APPLE &&
+	     dev->dev->board_type == 0x8B))
 		b43_phy_write(dev, B43_NPHY_TXREALFD, 0xA0);
 	else
 		b43_phy_write(dev, B43_NPHY_TXREALFD, 0xB8);
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index 2829ee1..5d00d0e 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -458,17 +458,15 @@ static void b43_wa_rssi_adc(struct b43_wldev *dev)
 
 static void b43_wa_boards_a(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
-
-	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM &&
-	    bus->boardinfo.type == SSB_BOARD_BU4306 &&
-	    bus->boardinfo.rev < 0x30) {
+	if (dev->dev->board_vendor == SSB_BOARDVENDOR_BCM &&
+	    dev->dev->board_type == SSB_BOARD_BU4306 &&
+	    dev->dev->board_rev < 0x30) {
 		b43_phy_write(dev, 0x0010, 0xE000);
 		b43_phy_write(dev, 0x0013, 0x0140);
 		b43_phy_write(dev, 0x0014, 0x0280);
 	} else {
-		if (bus->boardinfo.type == SSB_BOARD_MP4318 &&
-		    bus->boardinfo.rev < 0x20) {
+		if (dev->dev->board_type == SSB_BOARD_MP4318 &&
+		    dev->dev->board_rev < 0x20) {
 			b43_phy_write(dev, 0x0013, 0x0210);
 			b43_phy_write(dev, 0x0014, 0x0840);
 		} else {
@@ -486,13 +484,12 @@ static void b43_wa_boards_a(struct b43_wldev *dev)
 
 static void b43_wa_boards_g(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 
-	if (bus->boardinfo.vendor != SSB_BOARDVENDOR_BCM ||
-	    bus->boardinfo.type != SSB_BOARD_BU4306 ||
-	    bus->boardinfo.rev != 0x17) {
+	if (dev->dev->board_vendor != SSB_BOARDVENDOR_BCM ||
+	    dev->dev->board_type != SSB_BOARD_BU4306 ||
+	    dev->dev->board_rev != 0x17) {
 		if (phy->rev < 2) {
 			b43_ofdmtab_write16(dev, B43_OFDMTAB_GAINX_R1, 1, 0x0002);
 			b43_ofdmtab_write16(dev, B43_OFDMTAB_GAINX_R1, 2, 0x0001);
-- 
1.7.3.4

