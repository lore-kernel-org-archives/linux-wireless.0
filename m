Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32866 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1EIJF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 05:05:56 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so1473428eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 02:05:56 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC ONLY 5/5] b43: bus: abstract SPROM
Date: Mon,  9 May 2011 11:43:21 +0200
Message-Id: <1304934201-10626-5-git-send-email-zajec5@gmail.com> (sfid-20110509_110600_977761_9553CDCF)
In-Reply-To: <1304934201-10626-1-git-send-email-zajec5@gmail.com>
References: <1304934201-10626-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SPROM is another frequently used struct. We decided to share SPROM
struct between ssb na bcma as long as we will not need any hacks.
This will be easier to have direct pointer to SPROM.
---
 drivers/net/wireless/b43/bus.c   |    2 ++
 drivers/net/wireless/b43/bus.h   |    2 ++
 drivers/net/wireless/b43/main.c  |    8 ++++----
 drivers/net/wireless/b43/phy_n.c |   18 ++++++++++--------
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 677a8a4..eaf4095 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -54,6 +54,8 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 	dev->write16 = b43_bus_ssb_write16;
 	dev->write32 = b43_bus_ssb_write32;
 
+	dev->bus_sprom = &sdev->bus->sprom;
+
 	dev->core_rev = sdev->id.revision;
 
 	return dev;
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index adb5046..49e41ba 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -16,6 +16,8 @@ struct b43_bus_dev {
 	void (*write16)(struct b43_bus_dev *dev, u16 offset, u16 value);
 	void (*write32)(struct b43_bus_dev *dev, u16 offset, u32 value);
 
+	struct ssb_sprom *bus_sprom;
+
 	u8 core_rev;
 };
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 6b1d2a3..f173e2e 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1421,9 +1421,9 @@ u8 b43_ieee80211_antenna_sanitize(struct b43_wldev *dev,
 
 	/* Get the mask of available antennas. */
 	if (dev->phy.gmode)
-		antenna_mask = dev->sdev->bus->sprom.ant_available_bg;
+		antenna_mask = dev->dev->bus_sprom->ant_available_bg;
 	else
-		antenna_mask = dev->sdev->bus->sprom.ant_available_a;
+		antenna_mask = dev->dev->bus_sprom->ant_available_a;
 
 	if (!(antenna_mask & (1 << (antenna_nr - 1)))) {
 		/* This antenna is not available. Fall back to default. */
@@ -2582,7 +2582,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
 		mask |= 0x0180;
 		set |= 0x0180;
 	}
-	if (dev->sdev->bus->sprom.boardflags_lo & B43_BFL_PACTRL) {
+	if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_PACTRL) {
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
 			    b43_read16(dev, B43_MMIO_GPIO_MASK)
 			    | 0x0200);
@@ -4186,7 +4186,7 @@ static void setup_struct_wldev_for_init(struct b43_wldev *dev)
 
 static void b43_bluetooth_coext_enable(struct b43_wldev *dev)
 {
-	struct ssb_sprom *sprom = &dev->sdev->bus->sprom;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	u64 hf;
 
 	if (!modparam_btcoex)
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ddbd018..183a1c1 100644
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
@@ -3598,6 +3599,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 int b43_phy_initn(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
 	u8 tx_pwr_state;
@@ -3610,7 +3612,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	bool do_cal = false;
 
 	if ((dev->phy.rev >= 3) &&
-	   (bus->sprom.boardflags_lo & B43_BFL_EXTLNA) &&
+	   (sprom->boardflags_lo & B43_BFL_EXTLNA) &&
 	   (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)) {
 		chipco_set32(&dev->sdev->bus->chipco, SSB_CHIPCO_CHIPCTL, 0x40);
 	}
@@ -3650,7 +3652,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_AFESEQ_TX2RX_PUD_20M, 0x20);
 	b43_phy_write(dev, B43_NPHY_AFESEQ_TX2RX_PUD_40M, 0x20);
 
-	if (bus->sprom.boardflags2_lo & 0x100 ||
+	if (sprom->boardflags2_lo & 0x100 ||
 	    (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	     bus->boardinfo.type == 0x8B))
 		b43_phy_write(dev, B43_NPHY_TXREALFD, 0xA0);
-- 
1.7.3.4

