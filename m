Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:56206 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZHOXFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 19:05:06 -0400
Received: by bwz22 with SMTP id 22so1700272bwz.18
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2009 16:05:06 -0700 (PDT)
Message-ID: <4A873F20.4020705@gmail.com>
Date: Sun, 16 Aug 2009 01:05:04 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: LP-PHY: Update baseband init for recent spec changes
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The spec had some nasty typos, and a large part of the rev0/1 BB
init procedure was also missing. Fix these.

Also make the init-time channel switch debuggable.

(The change from -EINVAL to -EIO is simply to make it possible
to distinguish the PLL charge pump error from a channel-not-found
error.)

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
V2: Coding style fix suggested by Michael on IRC.

 drivers/net/wireless/b43/phy_lp.c |   72 ++++++++++++++++++++++++++++++++++---
 1 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 3872a31..c7f6c75 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -204,8 +204,62 @@ static void lpphy_table_init(struct b43_wldev *dev)
 static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->dev->bus;
+	struct b43_phy_lp *lpphy = dev->phy.lp;
 	u16 tmp, tmp2;
 
+	b43_phy_mask(dev, B43_LPPHY_AFE_DAC_CTL, 0xF7FF);
+	b43_phy_write(dev, B43_LPPHY_AFE_CTL, 0);
+	b43_phy_write(dev, B43_LPPHY_AFE_CTL_OVR, 0);
+	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_0, 0);
+	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_2, 0);
+	b43_phy_set(dev, B43_LPPHY_AFE_DAC_CTL, 0x0004);
+	b43_phy_maskset(dev, B43_LPPHY_OFDMSYNCTHRESH0, 0xFF00, 0x0078);
+	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0x83FF, 0x5800);
+	b43_phy_write(dev, B43_LPPHY_ADC_COMPENSATION_CTL, 0x0016);
+	b43_phy_maskset(dev, B43_LPPHY_AFE_ADC_CTL_0, 0xFFF8, 0x0004);
+	b43_phy_maskset(dev, B43_LPPHY_VERYLOWGAINDB, 0x00FF, 0x5400);
+	b43_phy_maskset(dev, B43_LPPHY_HIGAINDB, 0x00FF, 0x2400);
+	b43_phy_maskset(dev, B43_LPPHY_LOWGAINDB, 0x00FF, 0x2100);
+	b43_phy_maskset(dev, B43_LPPHY_VERYLOWGAINDB, 0xFF00, 0x0006);
+	b43_phy_mask(dev, B43_LPPHY_RX_RADIO_CTL, 0xFFFE);
+	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xFFE0, 0x0005);
+	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xFC10, 0x0180);
+	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0x83FF, 0x3800);
+	b43_phy_maskset(dev, B43_LPPHY_GAINDIRECTMISMATCH, 0xFFF0, 0x0005);
+	b43_phy_maskset(dev, B43_LPPHY_GAIN_MISMATCH_LIMIT, 0xFFC0, 0x001A);
+	b43_phy_maskset(dev, B43_LPPHY_CRS_ED_THRESH, 0xFF00, 0x00B3);
+	b43_phy_maskset(dev, B43_LPPHY_CRS_ED_THRESH, 0x00FF, 0xAD00);
+	b43_phy_maskset(dev, B43_LPPHY_INPUT_PWRDB,
+			0xFF00, lpphy->rx_pwr_offset);
+	if ((bus->sprom.boardflags_lo & B43_BFL_FEM) &&
+	   ((b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ||
+	   (bus->sprom.boardflags_hi & B43_BFH_PAREF))) {
+		/* TODO:
+		 * Set the LDO voltage to 0x0028 - FIXME: What is this?
+		 * Call sb_pmu_set_ldo_voltage with 4 and the LDO voltage
+		 * 	as arguments
+		 * Call sb_pmu_paref_ldo_enable with argument TRUE
+		 */
+		if (dev->phy.rev == 0) {
+		       	b43_phy_maskset(dev, B43_LPPHY_LP_RF_SIGNAL_LUT,
+					0xFFCF, 0x0010);
+		}
+		b43_lptab_write(dev, B43_LPTAB16(11, 7), 60);
+	} else {
+		//TODO: Call ssb_pmu_paref_ldo_enable with argument FALSE
+		b43_phy_maskset(dev, B43_LPPHY_LP_RF_SIGNAL_LUT,
+				0xFFCF, 0x0020);
+		b43_lptab_write(dev, B43_LPTAB16(11, 7), 100);
+	}
+	tmp = lpphy->rssi_vf | lpphy->rssi_vc << 4 | 0xA000;
+	b43_phy_write(dev, B43_LPPHY_AFE_RSSI_CTL_0, tmp);
+	if (bus->sprom.boardflags_hi & B43_BFH_RSSIINV)
+		b43_phy_maskset(dev, B43_LPPHY_AFE_RSSI_CTL_1, 0xF000, 0x0AAA);
+	else
+		b43_phy_maskset(dev, B43_LPPHY_AFE_RSSI_CTL_1, 0xF000, 0x02AA);
+	b43_lptab_write(dev, B43_LPTAB16(11, 1), 24);
+	b43_phy_maskset(dev, B43_LPPHY_RX_RADIO_CTL,
+			0xFFF9, (lpphy->bx_arch << 1));
 	if (dev->phy.rev == 1 &&
 	   (bus->sprom.boardflags_hi & B43_BFH_FEM_BT)) {
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_1, 0xFFC0, 0x000A);
@@ -255,7 +309,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xFFC0, 0x0006);
 		b43_phy_maskset(dev, B43_LPPHY_TR_LOOKUP_4, 0xC0FF, 0x0700);
 	}
-	if (dev->phy.rev == 1) {
+	if (dev->phy.rev == 1 && (bus->sprom.boardflags_hi & B43_BFH_PAREF)) {
 		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_5, B43_LPPHY_TR_LOOKUP_1);
 		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_6, B43_LPPHY_TR_LOOKUP_2);
 		b43_phy_copy(dev, B43_LPPHY_TR_LOOKUP_7, B43_LPPHY_TR_LOOKUP_3);
@@ -267,6 +321,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0006);
 		b43_phy_write(dev, B43_LPPHY_GPIO_SELECT, 0x0005);
 		b43_phy_write(dev, B43_LPPHY_GPIO_OUTEN, 0xFFFF);
+		//FIXME the Broadcom driver caches & delays this HF write!
 		b43_hf_write(dev, b43_hf_read(dev) | B43_HF_PR45960W);
 	}
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
@@ -384,7 +439,7 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_LPPHY_PWR_THRESH1, 0xFFF0, 0x9);
 	b43_phy_mask(dev, B43_LPPHY_GAINDIRECTMISMATCH, ~0xF);
 	b43_phy_maskset(dev, B43_LPPHY_VERYLOWGAINDB, 0x00FF, 0x5500);
-	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xF81F, 0xA0);
+	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xFC1F, 0xA0);
 	b43_phy_maskset(dev, B43_LPPHY_GAINDIRECTMISMATCH, 0xE0FF, 0x300);
 	b43_phy_maskset(dev, B43_LPPHY_HIGAINDB, 0x00FF, 0x2A00);
 	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 0)) {
@@ -405,7 +460,7 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xFFE0, 0x12);
 	b43_phy_maskset(dev, B43_LPPHY_GAINMISMATCH, 0x0FFF, 0x9000);
 
-	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 1)) {
+	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 0)) {
 		b43_lptab_write(dev, B43_LPTAB16(0x08, 0x14), 0);
 		b43_lptab_write(dev, B43_LPTAB16(0x08, 0x12), 0x40);
 	}
@@ -416,6 +471,7 @@ static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_LPPHY_SYNCPEAKCNT, 0xFFF8, 0x6);
 		b43_phy_maskset(dev, B43_LPPHY_MINPWR_LEVEL, 0x00FF, 0x9D00);
 		b43_phy_maskset(dev, B43_LPPHY_MINPWR_LEVEL, 0xFF00, 0xA1);
+		b43_phy_mask(dev, B43_LPPHY_IDLEAFTERPKTRXTO, 0x00FF);
 	} else /* 5GHz */
 		b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x40);
 
@@ -1883,7 +1939,7 @@ static int lpphy_b2062_tune(struct b43_wldev *dev,
 		lpphy_b2062_reset_pll_bias(dev);
 		lpphy_b2062_vco_calib(dev);
 		if (b43_radio_read(dev, B2062_S_RFPLL_CTL3) & 0x10)
-			err = -EINVAL;
+			err = -EIO;
 	}
 
 	b43_radio_mask(dev, B2062_S_RFPLL_CTL14, ~0x04);
@@ -2068,11 +2124,17 @@ static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
 
 static int b43_lpphy_op_init(struct b43_wldev *dev)
 {
+	int err;
+	
 	lpphy_read_band_sprom(dev); //FIXME should this be in prepare_structs?
 	lpphy_baseband_init(dev);
 	lpphy_radio_init(dev);
 	lpphy_calibrate_rc(dev);
-	b43_lpphy_op_switch_channel(dev, b43_lpphy_op_get_default_chan(dev));
+	err = b43_lpphy_op_switch_channel(dev,
+				b43_lpphy_op_get_default_chan(dev));
+	if (err)
+		b43dbg(dev->wl, "Switch to init channel failed, error = %d.\n",
+		       err);
 	lpphy_tx_pctl_init(dev);
 	lpphy_calibration(dev);
 	//TODO ACI init
-- 
1.6.2.4



