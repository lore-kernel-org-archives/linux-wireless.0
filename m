Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36082 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1LQM4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 07:56:38 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so4011135eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 04:56:37 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 6/8] b43: N-PHY: reorder functions: move RSSI calibration
Date: Sat, 17 Dec 2011 13:57:25 +0100
Message-Id: <1324126647-22425-7-git-send-email-zajec5@gmail.com> (sfid-20111217_135645_132572_FD2921BA)
In-Reply-To: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  798 +++++++++++++++++++-------------------
 1 files changed, 399 insertions(+), 399 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 620d278..f027909 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1193,6 +1193,306 @@ static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
 		b43_nphy_rev2_rssi_select(dev, code, type);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRssi2055Vcm */
+static void b43_nphy_set_rssi_2055_vcm(struct b43_wldev *dev, u8 type, u8 *buf)
+{
+	int i;
+	for (i = 0; i < 2; i++) {
+		if (type == 2) {
+			if (i == 0) {
+				b43_radio_maskset(dev, B2055_C1_B0NB_RSSIVCM,
+						  0xFC, buf[0]);
+				b43_radio_maskset(dev, B2055_C1_RX_BB_RSSICTL5,
+						  0xFC, buf[1]);
+			} else {
+				b43_radio_maskset(dev, B2055_C2_B0NB_RSSIVCM,
+						  0xFC, buf[2 * i]);
+				b43_radio_maskset(dev, B2055_C2_RX_BB_RSSICTL5,
+						  0xFC, buf[2 * i + 1]);
+			}
+		} else {
+			if (i == 0)
+				b43_radio_maskset(dev, B2055_C1_RX_BB_RSSICTL5,
+						  0xF3, buf[0] << 2);
+			else
+				b43_radio_maskset(dev, B2055_C2_RX_BB_RSSICTL5,
+						  0xF3, buf[2 * i + 1] << 2);
+		}
+	}
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/PollRssi */
+static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
+				u8 nsamp)
+{
+	int i;
+	int out;
+	u16 save_regs_phy[9];
+	u16 s[2];
+
+	if (dev->phy.rev >= 3) {
+		save_regs_phy[0] = b43_phy_read(dev,
+						B43_NPHY_RFCTL_LUT_TRSW_UP1);
+		save_regs_phy[1] = b43_phy_read(dev,
+						B43_NPHY_RFCTL_LUT_TRSW_UP2);
+		save_regs_phy[2] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
+		save_regs_phy[3] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
+		save_regs_phy[4] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER1);
+		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
+		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B1S0);
+		save_regs_phy[7] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B32S1);
+		save_regs_phy[8] = 0;
+	} else {
+		save_regs_phy[0] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
+		save_regs_phy[1] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
+		save_regs_phy[2] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
+		save_regs_phy[3] = b43_phy_read(dev, B43_NPHY_RFCTL_CMD);
+		save_regs_phy[4] = b43_phy_read(dev, B43_NPHY_RFCTL_OVER);
+		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO1);
+		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO2);
+		save_regs_phy[7] = 0;
+		save_regs_phy[8] = 0;
+	}
+
+	b43_nphy_rssi_select(dev, 5, type);
+
+	if (dev->phy.rev < 2) {
+		save_regs_phy[8] = b43_phy_read(dev, B43_NPHY_GPIO_SEL);
+		b43_phy_write(dev, B43_NPHY_GPIO_SEL, 5);
+	}
+
+	for (i = 0; i < 4; i++)
+		buf[i] = 0;
+
+	for (i = 0; i < nsamp; i++) {
+		if (dev->phy.rev < 2) {
+			s[0] = b43_phy_read(dev, B43_NPHY_GPIO_LOOUT);
+			s[1] = b43_phy_read(dev, B43_NPHY_GPIO_HIOUT);
+		} else {
+			s[0] = b43_phy_read(dev, B43_NPHY_RSSI1);
+			s[1] = b43_phy_read(dev, B43_NPHY_RSSI2);
+		}
+
+		buf[0] += ((s8)((s[0] & 0x3F) << 2)) >> 2;
+		buf[1] += ((s8)(((s[0] >> 8) & 0x3F) << 2)) >> 2;
+		buf[2] += ((s8)((s[1] & 0x3F) << 2)) >> 2;
+		buf[3] += ((s8)(((s[1] >> 8) & 0x3F) << 2)) >> 2;
+	}
+	out = (buf[0] & 0xFF) << 24 | (buf[1] & 0xFF) << 16 |
+		(buf[2] & 0xFF) << 8 | (buf[3] & 0xFF);
+
+	if (dev->phy.rev < 2)
+		b43_phy_write(dev, B43_NPHY_GPIO_SEL, save_regs_phy[8]);
+
+	if (dev->phy.rev >= 3) {
+		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1,
+				save_regs_phy[0]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2,
+				save_regs_phy[1]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_C1, save_regs_phy[2]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_C2, save_regs_phy[3]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, save_regs_phy[4]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, save_regs_phy[5]);
+		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S0, save_regs_phy[6]);
+		b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S1, save_regs_phy[7]);
+	} else {
+		b43_phy_write(dev, B43_NPHY_AFECTL_C1, save_regs_phy[0]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_C2, save_regs_phy[1]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, save_regs_phy[2]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_CMD, save_regs_phy[3]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_OVER, save_regs_phy[4]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_RSSIO1, save_regs_phy[5]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_RSSIO2, save_regs_phy[6]);
+	}
+
+	return out;
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal */
+static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
+{
+	int i, j;
+	u8 state[4];
+	u8 code, val;
+	u16 class, override;
+	u8 regs_save_radio[2];
+	u16 regs_save_phy[2];
+
+	s8 offset[4];
+	u8 core;
+	u8 rail;
+
+	u16 clip_state[2];
+	u16 clip_off[2] = { 0xFFFF, 0xFFFF };
+	s32 results_min[4] = { };
+	u8 vcm_final[4] = { };
+	s32 results[4][4] = { };
+	s32 miniq[4][2] = { };
+
+	if (type == 2) {
+		code = 0;
+		val = 6;
+	} else if (type < 2) {
+		code = 25;
+		val = 4;
+	} else {
+		B43_WARN_ON(1);
+		return;
+	}
+
+	class = b43_nphy_classifier(dev, 0, 0);
+	b43_nphy_classifier(dev, 7, 4);
+	b43_nphy_read_clip_detection(dev, clip_state);
+	b43_nphy_write_clip_detection(dev, clip_off);
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		override = 0x140;
+	else
+		override = 0x110;
+
+	regs_save_phy[0] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
+	regs_save_radio[0] = b43_radio_read16(dev, B2055_C1_PD_RXTX);
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, override);
+	b43_radio_write16(dev, B2055_C1_PD_RXTX, val);
+
+	regs_save_phy[1] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
+	regs_save_radio[1] = b43_radio_read16(dev, B2055_C2_PD_RXTX);
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, override);
+	b43_radio_write16(dev, B2055_C2_PD_RXTX, val);
+
+	state[0] = b43_radio_read16(dev, B2055_C1_PD_RSSIMISC) & 0x07;
+	state[1] = b43_radio_read16(dev, B2055_C2_PD_RSSIMISC) & 0x07;
+	b43_radio_mask(dev, B2055_C1_PD_RSSIMISC, 0xF8);
+	b43_radio_mask(dev, B2055_C2_PD_RSSIMISC, 0xF8);
+	state[2] = b43_radio_read16(dev, B2055_C1_SP_RSSI) & 0x07;
+	state[3] = b43_radio_read16(dev, B2055_C2_SP_RSSI) & 0x07;
+
+	b43_nphy_rssi_select(dev, 5, type);
+	b43_nphy_scale_offset_rssi(dev, 0, 0, 5, 0, type);
+	b43_nphy_scale_offset_rssi(dev, 0, 0, 5, 1, type);
+
+	for (i = 0; i < 4; i++) {
+		u8 tmp[4];
+		for (j = 0; j < 4; j++)
+			tmp[j] = i;
+		if (type != 1)
+			b43_nphy_set_rssi_2055_vcm(dev, type, tmp);
+		b43_nphy_poll_rssi(dev, type, results[i], 8);
+		if (type < 2)
+			for (j = 0; j < 2; j++)
+				miniq[i][j] = min(results[i][2 * j],
+						results[i][2 * j + 1]);
+	}
+
+	for (i = 0; i < 4; i++) {
+		s32 mind = 40;
+		u8 minvcm = 0;
+		s32 minpoll = 249;
+		s32 curr;
+		for (j = 0; j < 4; j++) {
+			if (type == 2)
+				curr = abs(results[j][i]);
+			else
+				curr = abs(miniq[j][i / 2] - code * 8);
+
+			if (curr < mind) {
+				mind = curr;
+				minvcm = j;
+			}
+
+			if (results[j][i] < minpoll)
+				minpoll = results[j][i];
+		}
+		results_min[i] = minpoll;
+		vcm_final[i] = minvcm;
+	}
+
+	if (type != 1)
+		b43_nphy_set_rssi_2055_vcm(dev, type, vcm_final);
+
+	for (i = 0; i < 4; i++) {
+		offset[i] = (code * 8) - results[vcm_final[i]][i];
+
+		if (offset[i] < 0)
+			offset[i] = -((abs(offset[i]) + 4) / 8);
+		else
+			offset[i] = (offset[i] + 4) / 8;
+
+		if (results_min[i] == 248)
+			offset[i] = code - 32;
+
+		core = (i / 2) ? 2 : 1;
+		rail = (i % 2) ? 1 : 0;
+
+		b43_nphy_scale_offset_rssi(dev, 0, offset[i], core, rail,
+						type);
+	}
+
+	b43_radio_maskset(dev, B2055_C1_PD_RSSIMISC, 0xF8, state[0]);
+	b43_radio_maskset(dev, B2055_C2_PD_RSSIMISC, 0xF8, state[1]);
+
+	switch (state[2]) {
+	case 1:
+		b43_nphy_rssi_select(dev, 1, 2);
+		break;
+	case 4:
+		b43_nphy_rssi_select(dev, 1, 0);
+		break;
+	case 2:
+		b43_nphy_rssi_select(dev, 1, 1);
+		break;
+	default:
+		b43_nphy_rssi_select(dev, 1, 1);
+		break;
+	}
+
+	switch (state[3]) {
+	case 1:
+		b43_nphy_rssi_select(dev, 2, 2);
+		break;
+	case 4:
+		b43_nphy_rssi_select(dev, 2, 0);
+		break;
+	default:
+		b43_nphy_rssi_select(dev, 2, 1);
+		break;
+	}
+
+	b43_nphy_rssi_select(dev, 0, type);
+
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, regs_save_phy[0]);
+	b43_radio_write16(dev, B2055_C1_PD_RXTX, regs_save_radio[0]);
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, regs_save_phy[1]);
+	b43_radio_write16(dev, B2055_C2_PD_RXTX, regs_save_radio[1]);
+
+	b43_nphy_classifier(dev, 7, class);
+	b43_nphy_write_clip_detection(dev, clip_state);
+	/* Specs don't say about reset here, but it makes wl and b43 dumps
+	   identical, it really seems wl performs this */
+	b43_nphy_reset_cca(dev);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
+static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
+{
+	/* TODO */
+}
+
+/*
+ * RSSI Calibration
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal
+ */
+static void b43_nphy_rssi_cal(struct b43_wldev *dev)
+{
+	if (dev->phy.rev >= 3) {
+		b43_nphy_rev3_rssi_cal(dev);
+	} else {
+		b43_nphy_rev2_rssi_cal(dev, B43_NPHY_RSSI_Z);
+		b43_nphy_rev2_rssi_cal(dev, B43_NPHY_RSSI_X);
+		b43_nphy_rev2_rssi_cal(dev, B43_NPHY_RSSI_Y);
+	}
+}
+
 /**************************************************
  * Workarounds
  **************************************************/
@@ -2409,434 +2709,134 @@ static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B2, 0xA4);
 	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B3, 0x00);
 
-	if (dev->phy.rev == 2)
-		b43_phy_set(dev, B43_NPHY_FINERX2_CGC,
-				B43_NPHY_FINERX2_CGC_DECGC);
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
-static void b43_nphy_workarounds(struct b43_wldev *dev)
-{
-	struct b43_phy *phy = &dev->phy;
-	struct b43_phy_n *nphy = phy->n;
-
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
-		b43_nphy_classifier(dev, 1, 0);
-	else
-		b43_nphy_classifier(dev, 1, 1);
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 1);
-
-	b43_phy_set(dev, B43_NPHY_IQFLIP,
-		    B43_NPHY_IQFLIP_ADC1 | B43_NPHY_IQFLIP_ADC2);
-
-	if (dev->phy.rev >= 3)
-		b43_nphy_workarounds_rev3plus(dev);
-	else
-		b43_nphy_workarounds_rev1_2(dev);
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 0);
-}
-
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
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlCoefSetup */
-static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
-{
-	struct b43_phy_n *nphy = dev->phy.n;
-	int i, j;
-	u32 tmp;
-	u32 cur_real, cur_imag, real_part, imag_part;
-
-	u16 buffer[7];
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, true);
-
-	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 7, buffer);
-
-	for (i = 0; i < 2; i++) {
-		tmp = ((buffer[i * 2] & 0x3FF) << 10) |
-			(buffer[i * 2 + 1] & 0x3FF);
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
-				(((i + 26) << 10) | 320));
-		for (j = 0; j < 128; j++) {
-			b43_phy_write(dev, B43_NPHY_TABLE_DATAHI,
-					((tmp >> 16) & 0xFFFF));
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
-					(tmp & 0xFFFF));
-		}
-	}
-
-	for (i = 0; i < 2; i++) {
-		tmp = buffer[5 + i];
-		real_part = (tmp >> 8) & 0xFF;
-		imag_part = (tmp & 0xFF);
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
-				(((i + 26) << 10) | 448));
-
-		if (dev->phy.rev >= 3) {
-			cur_real = real_part;
-			cur_imag = imag_part;
-			tmp = ((cur_real & 0xFF) << 8) | (cur_imag & 0xFF);
-		}
-
-		for (j = 0; j < 128; j++) {
-			if (dev->phy.rev < 3) {
-				cur_real = (real_part * loscale[j] + 128) >> 8;
-				cur_imag = (imag_part * loscale[j] + 128) >> 8;
-				tmp = ((cur_real & 0xFF) << 8) |
-					(cur_imag & 0xFF);
-			}
-			b43_phy_write(dev, B43_NPHY_TABLE_DATAHI,
-					((tmp >> 16) & 0xFFFF));
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
-					(tmp & 0xFFFF));
-		}
-	}
-
-	if (dev->phy.rev >= 3) {
-		b43_shm_write16(dev, B43_SHM_SHARED,
-				B43_SHM_SH_NPHY_TXPWR_INDX0, 0xFFFF);
-		b43_shm_write16(dev, B43_SHM_SHARED,
-				B43_SHM_SH_NPHY_TXPWR_INDX1, 0xFFFF);
-	}
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, false);
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BPHYInit */
-static void b43_nphy_bphy_init(struct b43_wldev *dev)
-{
-	unsigned int i;
-	u16 val;
-
-	val = 0x1E1F;
-	for (i = 0; i < 16; i++) {
-		b43_phy_write(dev, B43_PHY_N_BMODE(0x88 + i), val);
-		val -= 0x202;
-	}
-	val = 0x3E3F;
-	for (i = 0; i < 16; i++) {
-		b43_phy_write(dev, B43_PHY_N_BMODE(0x98 + i), val);
-		val -= 0x202;
-	}
-	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRssi2055Vcm */
-static void b43_nphy_set_rssi_2055_vcm(struct b43_wldev *dev, u8 type, u8 *buf)
-{
-	int i;
-	for (i = 0; i < 2; i++) {
-		if (type == 2) {
-			if (i == 0) {
-				b43_radio_maskset(dev, B2055_C1_B0NB_RSSIVCM,
-						  0xFC, buf[0]);
-				b43_radio_maskset(dev, B2055_C1_RX_BB_RSSICTL5,
-						  0xFC, buf[1]);
-			} else {
-				b43_radio_maskset(dev, B2055_C2_B0NB_RSSIVCM,
-						  0xFC, buf[2 * i]);
-				b43_radio_maskset(dev, B2055_C2_RX_BB_RSSICTL5,
-						  0xFC, buf[2 * i + 1]);
-			}
-		} else {
-			if (i == 0)
-				b43_radio_maskset(dev, B2055_C1_RX_BB_RSSICTL5,
-						  0xF3, buf[0] << 2);
-			else
-				b43_radio_maskset(dev, B2055_C2_RX_BB_RSSICTL5,
-						  0xF3, buf[2 * i + 1] << 2);
-		}
-	}
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/PollRssi */
-static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
-				u8 nsamp)
-{
-	int i;
-	int out;
-	u16 save_regs_phy[9];
-	u16 s[2];
-
-	if (dev->phy.rev >= 3) {
-		save_regs_phy[0] = b43_phy_read(dev,
-						B43_NPHY_RFCTL_LUT_TRSW_UP1);
-		save_regs_phy[1] = b43_phy_read(dev,
-						B43_NPHY_RFCTL_LUT_TRSW_UP2);
-		save_regs_phy[2] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
-		save_regs_phy[3] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
-		save_regs_phy[4] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER1);
-		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
-		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B1S0);
-		save_regs_phy[7] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B32S1);
-		save_regs_phy[8] = 0;
-	} else {
-		save_regs_phy[0] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
-		save_regs_phy[1] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
-		save_regs_phy[2] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
-		save_regs_phy[3] = b43_phy_read(dev, B43_NPHY_RFCTL_CMD);
-		save_regs_phy[4] = b43_phy_read(dev, B43_NPHY_RFCTL_OVER);
-		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO1);
-		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO2);
-		save_regs_phy[7] = 0;
-		save_regs_phy[8] = 0;
-	}
-
-	b43_nphy_rssi_select(dev, 5, type);
-
-	if (dev->phy.rev < 2) {
-		save_regs_phy[8] = b43_phy_read(dev, B43_NPHY_GPIO_SEL);
-		b43_phy_write(dev, B43_NPHY_GPIO_SEL, 5);
-	}
-
-	for (i = 0; i < 4; i++)
-		buf[i] = 0;
-
-	for (i = 0; i < nsamp; i++) {
-		if (dev->phy.rev < 2) {
-			s[0] = b43_phy_read(dev, B43_NPHY_GPIO_LOOUT);
-			s[1] = b43_phy_read(dev, B43_NPHY_GPIO_HIOUT);
-		} else {
-			s[0] = b43_phy_read(dev, B43_NPHY_RSSI1);
-			s[1] = b43_phy_read(dev, B43_NPHY_RSSI2);
-		}
-
-		buf[0] += ((s8)((s[0] & 0x3F) << 2)) >> 2;
-		buf[1] += ((s8)(((s[0] >> 8) & 0x3F) << 2)) >> 2;
-		buf[2] += ((s8)((s[1] & 0x3F) << 2)) >> 2;
-		buf[3] += ((s8)(((s[1] >> 8) & 0x3F) << 2)) >> 2;
-	}
-	out = (buf[0] & 0xFF) << 24 | (buf[1] & 0xFF) << 16 |
-		(buf[2] & 0xFF) << 8 | (buf[3] & 0xFF);
-
-	if (dev->phy.rev < 2)
-		b43_phy_write(dev, B43_NPHY_GPIO_SEL, save_regs_phy[8]);
-
-	if (dev->phy.rev >= 3) {
-		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1,
-				save_regs_phy[0]);
-		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2,
-				save_regs_phy[1]);
-		b43_phy_write(dev, B43_NPHY_AFECTL_C1, save_regs_phy[2]);
-		b43_phy_write(dev, B43_NPHY_AFECTL_C2, save_regs_phy[3]);
-		b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, save_regs_phy[4]);
-		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, save_regs_phy[5]);
-		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S0, save_regs_phy[6]);
-		b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S1, save_regs_phy[7]);
-	} else {
-		b43_phy_write(dev, B43_NPHY_AFECTL_C1, save_regs_phy[0]);
-		b43_phy_write(dev, B43_NPHY_AFECTL_C2, save_regs_phy[1]);
-		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, save_regs_phy[2]);
-		b43_phy_write(dev, B43_NPHY_RFCTL_CMD, save_regs_phy[3]);
-		b43_phy_write(dev, B43_NPHY_RFCTL_OVER, save_regs_phy[4]);
-		b43_phy_write(dev, B43_NPHY_RFCTL_RSSIO1, save_regs_phy[5]);
-		b43_phy_write(dev, B43_NPHY_RFCTL_RSSIO2, save_regs_phy[6]);
-	}
-
-	return out;
+	if (dev->phy.rev == 2)
+		b43_phy_set(dev, B43_NPHY_FINERX2_CGC,
+				B43_NPHY_FINERX2_CGC_DECGC);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal */
-static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
+static void b43_nphy_workarounds(struct b43_wldev *dev)
 {
-	int i, j;
-	u8 state[4];
-	u8 code, val;
-	u16 class, override;
-	u8 regs_save_radio[2];
-	u16 regs_save_phy[2];
-
-	s8 offset[4];
-	u8 core;
-	u8 rail;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
 
-	u16 clip_state[2];
-	u16 clip_off[2] = { 0xFFFF, 0xFFFF };
-	s32 results_min[4] = { };
-	u8 vcm_final[4] = { };
-	s32 results[4][4] = { };
-	s32 miniq[4][2] = { };
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		b43_nphy_classifier(dev, 1, 0);
+	else
+		b43_nphy_classifier(dev, 1, 1);
 
-	if (type == 2) {
-		code = 0;
-		val = 6;
-	} else if (type < 2) {
-		code = 25;
-		val = 4;
-	} else {
-		B43_WARN_ON(1);
-		return;
-	}
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
 
-	class = b43_nphy_classifier(dev, 0, 0);
-	b43_nphy_classifier(dev, 7, 4);
-	b43_nphy_read_clip_detection(dev, clip_state);
-	b43_nphy_write_clip_detection(dev, clip_off);
+	b43_phy_set(dev, B43_NPHY_IQFLIP,
+		    B43_NPHY_IQFLIP_ADC1 | B43_NPHY_IQFLIP_ADC2);
 
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
-		override = 0x140;
+	if (dev->phy.rev >= 3)
+		b43_nphy_workarounds_rev3plus(dev);
 	else
-		override = 0x110;
-
-	regs_save_phy[0] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
-	regs_save_radio[0] = b43_radio_read16(dev, B2055_C1_PD_RXTX);
-	b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, override);
-	b43_radio_write16(dev, B2055_C1_PD_RXTX, val);
+		b43_nphy_workarounds_rev1_2(dev);
 
-	regs_save_phy[1] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
-	regs_save_radio[1] = b43_radio_read16(dev, B2055_C2_PD_RXTX);
-	b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, override);
-	b43_radio_write16(dev, B2055_C2_PD_RXTX, val);
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
 
-	state[0] = b43_radio_read16(dev, B2055_C1_PD_RSSIMISC) & 0x07;
-	state[1] = b43_radio_read16(dev, B2055_C2_PD_RSSIMISC) & 0x07;
-	b43_radio_mask(dev, B2055_C1_PD_RSSIMISC, 0xF8);
-	b43_radio_mask(dev, B2055_C2_PD_RSSIMISC, 0xF8);
-	state[2] = b43_radio_read16(dev, B2055_C1_SP_RSSI) & 0x07;
-	state[3] = b43_radio_read16(dev, B2055_C2_SP_RSSI) & 0x07;
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
 
-	b43_nphy_rssi_select(dev, 5, type);
-	b43_nphy_scale_offset_rssi(dev, 0, 0, 5, 0, type);
-	b43_nphy_scale_offset_rssi(dev, 0, 0, 5, 1, type);
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlCoefSetup */
+static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	int i, j;
+	u32 tmp;
+	u32 cur_real, cur_imag, real_part, imag_part;
 
-	for (i = 0; i < 4; i++) {
-		u8 tmp[4];
-		for (j = 0; j < 4; j++)
-			tmp[j] = i;
-		if (type != 1)
-			b43_nphy_set_rssi_2055_vcm(dev, type, tmp);
-		b43_nphy_poll_rssi(dev, type, results[i], 8);
-		if (type < 2)
-			for (j = 0; j < 2; j++)
-				miniq[i][j] = min(results[i][2 * j],
-						results[i][2 * j + 1]);
-	}
+	u16 buffer[7];
 
-	for (i = 0; i < 4; i++) {
-		s32 mind = 40;
-		u8 minvcm = 0;
-		s32 minpoll = 249;
-		s32 curr;
-		for (j = 0; j < 4; j++) {
-			if (type == 2)
-				curr = abs(results[j][i]);
-			else
-				curr = abs(miniq[j][i / 2] - code * 8);
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, true);
 
-			if (curr < mind) {
-				mind = curr;
-				minvcm = j;
-			}
+	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 7, buffer);
 
-			if (results[j][i] < minpoll)
-				minpoll = results[j][i];
+	for (i = 0; i < 2; i++) {
+		tmp = ((buffer[i * 2] & 0x3FF) << 10) |
+			(buffer[i * 2 + 1] & 0x3FF);
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
+				(((i + 26) << 10) | 320));
+		for (j = 0; j < 128; j++) {
+			b43_phy_write(dev, B43_NPHY_TABLE_DATAHI,
+					((tmp >> 16) & 0xFFFF));
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+					(tmp & 0xFFFF));
 		}
-		results_min[i] = minpoll;
-		vcm_final[i] = minvcm;
 	}
 
-	if (type != 1)
-		b43_nphy_set_rssi_2055_vcm(dev, type, vcm_final);
-
-	for (i = 0; i < 4; i++) {
-		offset[i] = (code * 8) - results[vcm_final[i]][i];
-
-		if (offset[i] < 0)
-			offset[i] = -((abs(offset[i]) + 4) / 8);
-		else
-			offset[i] = (offset[i] + 4) / 8;
-
-		if (results_min[i] == 248)
-			offset[i] = code - 32;
-
-		core = (i / 2) ? 2 : 1;
-		rail = (i % 2) ? 1 : 0;
-
-		b43_nphy_scale_offset_rssi(dev, 0, offset[i], core, rail,
-						type);
-	}
+	for (i = 0; i < 2; i++) {
+		tmp = buffer[5 + i];
+		real_part = (tmp >> 8) & 0xFF;
+		imag_part = (tmp & 0xFF);
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
+				(((i + 26) << 10) | 448));
 
-	b43_radio_maskset(dev, B2055_C1_PD_RSSIMISC, 0xF8, state[0]);
-	b43_radio_maskset(dev, B2055_C2_PD_RSSIMISC, 0xF8, state[1]);
+		if (dev->phy.rev >= 3) {
+			cur_real = real_part;
+			cur_imag = imag_part;
+			tmp = ((cur_real & 0xFF) << 8) | (cur_imag & 0xFF);
+		}
 
-	switch (state[2]) {
-	case 1:
-		b43_nphy_rssi_select(dev, 1, 2);
-		break;
-	case 4:
-		b43_nphy_rssi_select(dev, 1, 0);
-		break;
-	case 2:
-		b43_nphy_rssi_select(dev, 1, 1);
-		break;
-	default:
-		b43_nphy_rssi_select(dev, 1, 1);
-		break;
+		for (j = 0; j < 128; j++) {
+			if (dev->phy.rev < 3) {
+				cur_real = (real_part * loscale[j] + 128) >> 8;
+				cur_imag = (imag_part * loscale[j] + 128) >> 8;
+				tmp = ((cur_real & 0xFF) << 8) |
+					(cur_imag & 0xFF);
+			}
+			b43_phy_write(dev, B43_NPHY_TABLE_DATAHI,
+					((tmp >> 16) & 0xFFFF));
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+					(tmp & 0xFFFF));
+		}
 	}
 
-	switch (state[3]) {
-	case 1:
-		b43_nphy_rssi_select(dev, 2, 2);
-		break;
-	case 4:
-		b43_nphy_rssi_select(dev, 2, 0);
-		break;
-	default:
-		b43_nphy_rssi_select(dev, 2, 1);
-		break;
+	if (dev->phy.rev >= 3) {
+		b43_shm_write16(dev, B43_SHM_SHARED,
+				B43_SHM_SH_NPHY_TXPWR_INDX0, 0xFFFF);
+		b43_shm_write16(dev, B43_SHM_SHARED,
+				B43_SHM_SH_NPHY_TXPWR_INDX1, 0xFFFF);
 	}
 
-	b43_nphy_rssi_select(dev, 0, type);
-
-	b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, regs_save_phy[0]);
-	b43_radio_write16(dev, B2055_C1_PD_RXTX, regs_save_radio[0]);
-	b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, regs_save_phy[1]);
-	b43_radio_write16(dev, B2055_C2_PD_RXTX, regs_save_radio[1]);
-
-	b43_nphy_classifier(dev, 7, class);
-	b43_nphy_write_clip_detection(dev, clip_state);
-	/* Specs don't say about reset here, but it makes wl and b43 dumps
-	   identical, it really seems wl performs this */
-	b43_nphy_reset_cca(dev);
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, false);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
-static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BPHYInit */
+static void b43_nphy_bphy_init(struct b43_wldev *dev)
 {
-	/* TODO */
-}
+	unsigned int i;
+	u16 val;
 
-/*
- * RSSI Calibration
- * http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal
- */
-static void b43_nphy_rssi_cal(struct b43_wldev *dev)
-{
-	if (dev->phy.rev >= 3) {
-		b43_nphy_rev3_rssi_cal(dev);
-	} else {
-		b43_nphy_rev2_rssi_cal(dev, B43_NPHY_RSSI_Z);
-		b43_nphy_rev2_rssi_cal(dev, B43_NPHY_RSSI_X);
-		b43_nphy_rev2_rssi_cal(dev, B43_NPHY_RSSI_Y);
+	val = 0x1E1F;
+	for (i = 0; i < 16; i++) {
+		b43_phy_write(dev, B43_PHY_N_BMODE(0x88 + i), val);
+		val -= 0x202;
+	}
+	val = 0x3E3F;
+	for (i = 0; i < 16; i++) {
+		b43_phy_write(dev, B43_PHY_N_BMODE(0x98 + i), val);
+		val -= 0x202;
 	}
+	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
 }
 
 /*
-- 
1.7.7

