Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:48407 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbZHMOyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 10:54:45 -0400
Received: by fxm28 with SMTP id 28so638516fxm.17
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 07:54:45 -0700 (PDT)
Message-ID: <4A842934.2060206@gmail.com>
Date: Thu, 13 Aug 2009 16:54:44 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: LP-PHY: Initialize TX power control
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HW TX power control init still needs work.
The SW init is complete according to the specs.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
v2: Address Michael's comments, and update for the dummy transmission changes.

This depends on both the rev0/1 RC calibration patch and the
updated V4 dummy transmission patch I submitted earlier.

Larry, please review the SPEC TODO/SPEC FIXME comments!

 drivers/net/wireless/b43/phy_lp.c |  105 ++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/b43/phy_lp.h |    5 ++
 2 files changed, 103 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 2441a8d..b4e51f0 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1257,18 +1257,109 @@ static void lpphy_calibration(struct b43_wldev *dev)
 	b43_mac_enable(dev);
 }
 
+static void lpphy_set_tssi_mux(struct b43_wldev *dev, enum tssi_mux_mode mode)
+{
+	if (mode != TSSI_MUX_EXT) {
+		b43_radio_set(dev, B2063_PA_SP1, 0x2);
+		b43_phy_set(dev, B43_PHY_OFDM(0xF3), 0x1000);
+		b43_radio_write(dev, B2063_PA_CTL10, 0x51);
+		if (mode == TSSI_MUX_POSTPA) {
+			b43_radio_mask(dev, B2063_PA_SP1, 0xFFFE);
+			b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0xFFC7);
+		} else {
+			b43_radio_maskset(dev, B2063_PA_SP1, 0xFFFE, 0x1);
+			b43_phy_maskset(dev, B43_LPPHY_AFE_CTL_OVRVAL,
+					0xFFC7, 0x20);
+		}
+	} else {
+		//SPEC TODO
+	}
+}
+
+static void lpphy_tx_pctl_init_hw(struct b43_wldev *dev)
+{
+	u16 tmp;
+	int i;
+
+	//SPEC TODO Call LP PHY Clear TX Power offsets
+	for (i = 0; i < 64; i++) {
+		if (dev->phy.rev >= 2)
+			b43_lptab_write(dev, B43_LPTAB32(7, i + 1), i);
+		else
+			b43_lptab_write(dev, B43_LPTAB32(10, i + 1), i);
+	}
+
+	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_NNUM, 0xFF00, 0xFF);
+	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_NNUM, 0x8FFF, 0x5000);
+	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_IDLETSSI, 0xFFC0, 0x1F);
+	if (dev->phy.rev < 2) {
+		b43_phy_mask(dev, B43_LPPHY_LP_PHY_CTL, 0xEFFF);
+		b43_phy_maskset(dev, B43_LPPHY_LP_PHY_CTL, 0xDFFF, 0x2000);
+	} else {
+		b43_phy_mask(dev, B43_PHY_OFDM(0x103), 0xFFFE);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0x103), 0xFFFB, 0x4);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0x103), 0xFFEF, 0x10);
+		b43_radio_maskset(dev, B2063_IQ_CALIB_CTL2, 0xF3, 0x1);
+		lpphy_set_tssi_mux(dev, TSSI_MUX_POSTPA);
+	}
+	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_IDLETSSI, 0x7FFF, 0x8000);
+	b43_phy_mask(dev, B43_LPPHY_TX_PWR_CTL_DELTAPWR_LIMIT, 0xFF);
+	b43_phy_write(dev, B43_LPPHY_TX_PWR_CTL_DELTAPWR_LIMIT, 0xA);
+	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
+			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE,
+			B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF);
+	b43_phy_mask(dev, B43_LPPHY_TX_PWR_CTL_NNUM, 0xF8FF);
+	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
+			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE,
+			B43_LPPHY_TX_PWR_CTL_CMD_MODE_SW);
+
+	if (dev->phy.rev < 2) {
+		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_0, 0xEFFF, 0x1000);
+		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xEFFF);
+	} else {
+		lpphy_set_tx_power_by_index(dev, 0x7F);
+	}
+
+	b43_dummy_transmission(dev, true, true);
+
+	tmp = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_STAT);
+	if (tmp & 0x8000) {
+		b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_IDLETSSI,
+				0xFFC0, (tmp & 0xFF) - 32);
+	}
+
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xEFFF);
+
+	// (SPEC?) TODO Set "Target TX frequency" variable to 0
+	// SPEC FIXME "Set BB Multiplier to 0xE000" impossible - bb_mult is u8!
+}
+
+static void lpphy_tx_pctl_init_sw(struct b43_wldev *dev)
+{
+	struct lpphy_tx_gains gains;
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		gains.gm = 4;
+		gains.pad = 12;
+		gains.pga = 12;
+		gains.dac = 0;
+	} else {
+		gains.gm = 7;
+		gains.pad = 14;
+		gains.pga = 15;
+		gains.dac = 0;
+	}
+	lpphy_set_tx_gains(dev, gains);
+	lpphy_set_bb_mult(dev, 150);
+}
+
 /* Initialize TX power control */
 static void lpphy_tx_pctl_init(struct b43_wldev *dev)
 {
 	if (0/*FIXME HWPCTL capable */) {
-		//TODO
+		lpphy_tx_pctl_init_hw(dev);
 	} else { /* This device is only software TX power control capable. */
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-			//TODO
-		} else {
-			//TODO
-		}
-		//TODO set BB multiplier to 0x0096
+		lpphy_tx_pctl_init_sw(dev);
 	}
 }
 
diff --git a/drivers/net/wireless/b43/phy_lp.h b/drivers/net/wireless/b43/phy_lp.h
index 0461d5b..4eab760 100644
--- a/drivers/net/wireless/b43/phy_lp.h
+++ b/drivers/net/wireless/b43/phy_lp.h
@@ -886,6 +886,11 @@ struct b43_phy_lp {
 	u16 dig_flt_state[9];
 };
 
+enum tssi_mux_mode {
+	TSSI_MUX_PREPA,
+	TSSI_MUX_POSTPA,
+	TSSI_MUX_EXT,
+};
 
 struct b43_phy_operations;
 extern const struct b43_phy_operations b43_phyops_lp;
-- 
1.6.2.4



