Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:58012 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab0BDLXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 06:23:35 -0500
Received: by fg-out-1718.google.com with SMTP id 19so27494fgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 03:23:34 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/5] b43: N-PHY: save calibration for further restore
Date: Thu,  4 Feb 2010 12:23:11 +0100
Message-Id: <1265282592-25491-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
References: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   51 +++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/phy_n.h |    1 +
 2 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e8266ed..f632494 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2319,6 +2319,55 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 	}
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SaveCal */
+static void b43_nphy_save_cal(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	struct b43_phy_n_iq_comp *rxcal_coeffs = NULL;
+	u16 *txcal_radio_regs = NULL;
+	u8 *iqcal_chanspec;
+	u16 *table = NULL;
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		rxcal_coeffs = &nphy->cal_cache.rxcal_coeffs_2G;
+		txcal_radio_regs = nphy->cal_cache.txcal_radio_regs_2G;
+		iqcal_chanspec = &nphy->iqcal_chanspec_2G;
+		table = nphy->cal_cache.txcal_coeffs_2G;
+	} else {
+		rxcal_coeffs = &nphy->cal_cache.rxcal_coeffs_5G;
+		txcal_radio_regs = nphy->cal_cache.txcal_radio_regs_5G;
+		iqcal_chanspec = &nphy->iqcal_chanspec_5G;
+		table = nphy->cal_cache.txcal_coeffs_5G;
+	}
+
+	b43_nphy_rx_iq_coeffs(dev, false, rxcal_coeffs);
+	/* TODO use some definitions */
+	if (dev->phy.rev >= 3) {
+		txcal_radio_regs[0] = b43_radio_read(dev, 0x2021);
+		txcal_radio_regs[1] = b43_radio_read(dev, 0x2022);
+		txcal_radio_regs[2] = b43_radio_read(dev, 0x3021);
+		txcal_radio_regs[3] = b43_radio_read(dev, 0x3022);
+		txcal_radio_regs[4] = b43_radio_read(dev, 0x2023);
+		txcal_radio_regs[5] = b43_radio_read(dev, 0x2024);
+		txcal_radio_regs[6] = b43_radio_read(dev, 0x3023);
+		txcal_radio_regs[7] = b43_radio_read(dev, 0x3024);
+	} else {
+		txcal_radio_regs[0] = b43_radio_read(dev, 0x8B);
+		txcal_radio_regs[1] = b43_radio_read(dev, 0xBA);
+		txcal_radio_regs[2] = b43_radio_read(dev, 0x8D);
+		txcal_radio_regs[3] = b43_radio_read(dev, 0xBC);
+	}
+	*iqcal_chanspec = nphy->radio_chanspec;
+	b43_ntab_write_bulk(dev, B43_NTAB16(15, 80), 8, table);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreCal */
 static void b43_nphy_restore_cal(struct b43_wldev *dev)
 {
@@ -3016,7 +3065,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 
 	if (!b43_nphy_cal_tx_iq_lo(dev, target, true, false)) {
 		if (b43_nphy_cal_rx_iq(dev, target, 2, 0) == 0)
-			;/* Call N PHY Save Cal */
+			b43_nphy_save_cal(dev);
 		else if (nphy->mphase_cal_phase_id == 0)
 			;/* N PHY Periodic Calibration with argument 3 */
 	} else {
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index ae82f0f..0400a2c 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -975,6 +975,7 @@ struct b43_phy_n {
 	u16 papd_epsilon_offset[2];
 	s32 preamble_override;
 	u32 bb_mult_save;
+	u16 radio_chanspec;
 
 	bool gain_boost;
 	bool elna_gain_config;
-- 
1.6.4.2

