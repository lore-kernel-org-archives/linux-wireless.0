Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:46627 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZHKTxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 15:53:08 -0400
Received: by fxm28 with SMTP id 28so1745455fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 12:53:08 -0700 (PDT)
Message-ID: <4A81CC22.9010208@gmail.com>
Date: Tue, 11 Aug 2009 21:53:06 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: Implement RC calibration for rev.2+ LP PHYs
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
Larry,
Rev0/1 RC calibration is missing because the spec needs clarification
(lots of cryptic variable names, a struct that is never defined, etc.),
hence the SPEC FIXME.

 drivers/net/wireless/b43/phy_lp.c |   86 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 85 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 1b4f63a..689c932 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -605,6 +605,90 @@ static void lpphy_radio_init(struct b43_wldev *dev)
 	}
 }
 
+static void lpphy_set_rc_cap(struct b43_wldev *dev)
+{
+	u8 rc_cap = dev->phy.lp->rc_cap;
+
+	b43_radio_write(dev, B2062_N_RXBB_CALIB2, max_t(u8, rc_cap-4, 0x80));
+	b43_radio_write(dev, B2062_N_TX_CTL_A, ((rc_cap & 0x1F) >> 1) | 0x80);
+	b43_radio_write(dev, B2062_S_RXG_CNT16, ((rc_cap & 0x1F) >> 2) | 0x80);
+}
+
+static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
+{
+	//TODO and SPEC FIXME
+}
+
+static void lpphy_rev2plus_rc_calib(struct b43_wldev *dev)
+{
+	struct ssb_bus *bus = dev->dev->bus;
+	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
+	u8 tmp = b43_radio_read(dev, B2063_RX_BB_SP8) & 0xFF;
+	int i;
+
+	b43_radio_write(dev, B2063_RX_BB_SP8, 0x0);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
+	b43_radio_mask(dev, B2063_PLL_SP1, 0xF7);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7C);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL2, 0x15);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL3, 0x70);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0x52);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x1);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7D);
+
+	for (i = 0; i < 10000; i++) {
+		if (b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2)
+			break;
+		msleep(1);
+	}
+
+	if (!(b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2))
+		b43_radio_write(dev, B2063_RX_BB_SP8, tmp);
+
+	tmp = b43_radio_read(dev, B2063_TX_BB_SP3) & 0xFF;
+
+	b43_radio_write(dev, B2063_TX_BB_SP3, 0x0);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7C);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL2, 0x55);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL3, 0x76);
+
+	if (crystal_freq == 24000000) {
+		b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0xFC);
+		b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x0);
+	} else {
+		b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0x13);
+		b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x1);
+	}
+
+	b43_radio_write(dev, B2063_PA_SP7, 0x7D);
+
+	for (i = 0; i < 10000; i++) {
+		if (b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2)
+			break;
+		msleep(1);
+	}
+
+	if (!(b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2))
+		b43_radio_write(dev, B2063_TX_BB_SP3, tmp);
+
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
+}
+
+static void lpphy_calibrate_rc(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+
+	if (dev->phy.rev >= 2) {
+		lpphy_rev2plus_rc_calib(dev);
+	} else if (!lpphy->rc_cap) {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+			lpphy_rev0_1_rc_calib(dev);
+	} else {
+		lpphy_set_rc_cap(dev);
+	}
+}
+
 /* Read the TX power control mode from hardware. */
 static void lpphy_read_tx_pctl_mode_from_hardware(struct b43_wldev *dev)
 {
@@ -780,7 +864,7 @@ static int b43_lpphy_op_init(struct b43_wldev *dev)
 	lpphy_read_band_sprom(dev); //FIXME should this be in prepare_structs?
 	lpphy_baseband_init(dev);
 	lpphy_radio_init(dev);
-	//TODO calibrate RC
+	lpphy_calibrate_rc(dev);
 	//TODO set channel
 	lpphy_tx_pctl_init(dev);
 	lpphy_calibration(dev);
-- 
1.6.2.4


