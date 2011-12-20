Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35859 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1LTVEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 16:04:47 -0500
Received: by eekc4 with SMTP id c4so6950267eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 13:04:46 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: N-PHY: move common TX/RX functions
Date: Tue, 20 Dec 2011 22:45:47 +0100
Message-Id: <1324417549-5545-1-git-send-email-zajec5@gmail.com> (sfid-20111220_220449_886772_85F4BB1B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  218 +++++++++++++++++++-------------------
 1 files changed, 111 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e89b04b..52503c6 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1929,6 +1929,117 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 }
 
 /**************************************************
+ * Tx/Rx common
+ **************************************************/
+
+/*
+ * Transmits a known value for LO calibration
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TXTone
+ */
+static int b43_nphy_tx_tone(struct b43_wldev *dev, u32 freq, u16 max_val,
+				bool iqmode, bool dac_test)
+{
+	u16 samp = b43_nphy_gen_load_samples(dev, freq, max_val, dac_test);
+	if (samp == 0)
+		return -1;
+	b43_nphy_run_samples(dev, samp, 0xFFFF, 0, iqmode, dac_test);
+	return 0;
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Chains */
+static void b43_nphy_update_txrx_chain(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	bool override = false;
+	u16 chain = 0x33;
+
+	if (nphy->txrx_chain == 0) {
+		chain = 0x11;
+		override = true;
+	} else if (nphy->txrx_chain == 1) {
+		chain = 0x22;
+		override = true;
+	}
+
+	b43_phy_maskset(dev, B43_NPHY_RFSEQCA,
+			~(B43_NPHY_RFSEQCA_TXEN | B43_NPHY_RFSEQCA_RXEN),
+			chain);
+
+	if (override)
+		b43_phy_set(dev, B43_NPHY_RFSEQMODE,
+				B43_NPHY_RFSEQMODE_CAOVER);
+	else
+		b43_phy_mask(dev, B43_NPHY_RFSEQMODE,
+				~B43_NPHY_RFSEQMODE_CAOVER);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/stop-playback */
+static void b43_nphy_stop_playback(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	u16 tmp;
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	tmp = b43_phy_read(dev, B43_NPHY_SAMP_STAT);
+	if (tmp & 0x1)
+		b43_phy_set(dev, B43_NPHY_SAMP_CMD, B43_NPHY_SAMP_CMD_STOP);
+	else if (tmp & 0x2)
+		b43_phy_mask(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x7FFF);
+
+	b43_phy_mask(dev, B43_NPHY_SAMP_CMD, ~0x0004);
+
+	if (nphy->bb_mult_save & 0x80000000) {
+		tmp = nphy->bb_mult_save & 0xFFFF;
+		b43_ntab_write(dev, B43_NTAB16(15, 87), tmp);
+		nphy->bb_mult_save = 0;
+	}
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/IqCalGainParams */
+static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
+					struct nphy_txgains target,
+					struct nphy_iqcal_params *params)
+{
+	int i, j, indx;
+	u16 gain;
+
+	if (dev->phy.rev >= 3) {
+		params->txgm = target.txgm[core];
+		params->pga = target.pga[core];
+		params->pad = target.pad[core];
+		params->ipa = target.ipa[core];
+		params->cal_gain = (params->txgm << 12) | (params->pga << 8) |
+					(params->pad << 4) | (params->ipa);
+		for (j = 0; j < 5; j++)
+			params->ncorr[j] = 0x79;
+	} else {
+		gain = (target.pad[core]) | (target.pga[core] << 4) |
+			(target.txgm[core] << 8);
+
+		indx = (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ?
+			1 : 0;
+		for (i = 0; i < 9; i++)
+			if (tbl_iqcal_gainparams[indx][i][0] == gain)
+				break;
+		i = min(i, 8);
+
+		params->txgm = tbl_iqcal_gainparams[indx][i][1];
+		params->pga = tbl_iqcal_gainparams[indx][i][2];
+		params->pad = tbl_iqcal_gainparams[indx][i][3];
+		params->cal_gain = (params->txgm << 7) | (params->pga << 4) |
+					(params->pad << 2);
+		for (j = 0; j < 4; j++)
+			params->ncorr[j] = tbl_iqcal_gainparams[indx][i][4 + j];
+	}
+}
+
+/**************************************************
  * Tx and Rx
  **************************************************/
 
@@ -2290,34 +2401,6 @@ static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Chains */
-static void b43_nphy_update_txrx_chain(struct b43_wldev *dev)
-{
-	struct b43_phy_n *nphy = dev->phy.n;
-
-	bool override = false;
-	u16 chain = 0x33;
-
-	if (nphy->txrx_chain == 0) {
-		chain = 0x11;
-		override = true;
-	} else if (nphy->txrx_chain == 1) {
-		chain = 0x22;
-		override = true;
-	}
-
-	b43_phy_maskset(dev, B43_NPHY_RFSEQCA,
-			~(B43_NPHY_RFSEQCA_TXEN | B43_NPHY_RFSEQCA_RXEN),
-			chain);
-
-	if (override)
-		b43_phy_set(dev, B43_NPHY_RFSEQMODE,
-				B43_NPHY_RFSEQMODE_CAOVER);
-	else
-		b43_phy_mask(dev, B43_NPHY_RFSEQMODE,
-				~B43_NPHY_RFSEQMODE_CAOVER);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxIqEst */
 static void b43_nphy_rx_iq_est(struct b43_wldev *dev, struct nphy_iq_est *est,
 				u16 samps, u8 time, bool wait)
@@ -2569,33 +2652,6 @@ static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW3, array[3]);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/stop-playback */
-static void b43_nphy_stop_playback(struct b43_wldev *dev)
-{
-	struct b43_phy_n *nphy = dev->phy.n;
-	u16 tmp;
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 1);
-
-	tmp = b43_phy_read(dev, B43_NPHY_SAMP_STAT);
-	if (tmp & 0x1)
-		b43_phy_set(dev, B43_NPHY_SAMP_CMD, B43_NPHY_SAMP_CMD_STOP);
-	else if (tmp & 0x2)
-		b43_phy_mask(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x7FFF);
-
-	b43_phy_mask(dev, B43_NPHY_SAMP_CMD, ~0x0004);
-
-	if (nphy->bb_mult_save & 0x80000000) {
-		tmp = nphy->bb_mult_save & 0xFFFF;
-		b43_ntab_write(dev, B43_NTAB16(15, 87), tmp);
-		nphy->bb_mult_save = 0;
-	}
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 0);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SpurWar */
 static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 {
@@ -2655,20 +2711,6 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
-/*
- * Transmits a known value for LO calibration
- * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TXTone
- */
-static int b43_nphy_tx_tone(struct b43_wldev *dev, u32 freq, u16 max_val,
-				bool iqmode, bool dac_test)
-{
-	u16 samp = b43_nphy_gen_load_samples(dev, freq, max_val, dac_test);
-	if (samp == 0)
-		return -1;
-	b43_nphy_run_samples(dev, samp, 0xFFFF, 0, iqmode, dac_test);
-	return 0;
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlCoefSetup */
 static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
 {
@@ -2872,44 +2914,6 @@ static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/IqCalGainParams */
-static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
-					struct nphy_txgains target,
-					struct nphy_iqcal_params *params)
-{
-	int i, j, indx;
-	u16 gain;
-
-	if (dev->phy.rev >= 3) {
-		params->txgm = target.txgm[core];
-		params->pga = target.pga[core];
-		params->pad = target.pad[core];
-		params->ipa = target.ipa[core];
-		params->cal_gain = (params->txgm << 12) | (params->pga << 8) |
-					(params->pad << 4) | (params->ipa);
-		for (j = 0; j < 5; j++)
-			params->ncorr[j] = 0x79;
-	} else {
-		gain = (target.pad[core]) | (target.pga[core] << 4) |
-			(target.txgm[core] << 8);
-
-		indx = (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ?
-			1 : 0;
-		for (i = 0; i < 9; i++)
-			if (tbl_iqcal_gainparams[indx][i][0] == gain)
-				break;
-		i = min(i, 8);
-
-		params->txgm = tbl_iqcal_gainparams[indx][i][1];
-		params->pga = tbl_iqcal_gainparams[indx][i][2];
-		params->pad = tbl_iqcal_gainparams[indx][i][3];
-		params->cal_gain = (params->txgm << 7) | (params->pga << 4) |
-					(params->pad << 2);
-		for (j = 0; j < 4; j++)
-			params->ncorr[j] = tbl_iqcal_gainparams[indx][i][4 + j];
-	}
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/UpdateTxCalLadder */
 static void b43_nphy_update_tx_cal_ladder(struct b43_wldev *dev, u16 core)
 {
-- 
1.7.3.4

