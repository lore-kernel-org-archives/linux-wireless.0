Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37326 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab0AMXyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 18:54:33 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so801959fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2010 15:54:32 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Jan 2010 00:54:31 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 3/3 v2] b43: N-PHY: add RX IQ calculation for rev < 3
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6hwo5mt9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---

V2: get rid of warning by casting

---
  drivers/net/wireless/b43/phy_n.c |  195 +++++++++++++++++++++++++++++++++++++-
  drivers/net/wireless/b43/phy_n.h |    1 +
  2 files changed, 195 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 101ef39..d0a0ce9 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -582,6 +582,199 @@ static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
  	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW3, array[3]);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalRxIqRev2 */
+static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
+			struct nphy_txgains target, u8 type, bool debug)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	int i, j, index;
+	u8 rfctl[2];
+	u8 afectl_core;
+	u16 tmp[6];
+	u16 cur_hpf1, cur_hpf2, cur_lna;
+	u32 real, imag;
+	enum ieee80211_band band;
+
+	u8 use;
+	u16 cur_hpf;
+	u16 lna[3] = { 3, 3, 1 };
+	u16 hpf1[3] = { 7, 2, 0 };
+	u16 hpf2[3] = { 2, 0, 0 };
+	u32 power[3];
+	u16 gain_save[2];
+	u16 cal_gain[2];
+	struct nphy_iqcal_params cal_params[2];
+	struct nphy_iq_est est;
+	int ret = 0;
+	bool playtone = true;
+	int desired = 13;
+
+	b43_nphy_stay_in_carrier_search(dev, 1);
+
+	if (dev->phy.rev < 2)
+		;//TODO: Call N PHY Reapply TX Cal Coeffs
+	//TODO: Read an N PHY Table with ID 7, length 2, offset 0x110, width 16, and data gain_save
+	for (i = 0; i < 2; i++) {
+		b43_nphy_iq_cal_gain_params(dev, i, target, &cal_params[i]);
+		cal_gain[i] = cal_params[i].cal_gain;
+	}
+	//TODO: Write an N PHY Table with ID 7, length 2, offset 0x110, width 16, and data from cal_gain
+
+	for (i = 0; i < 2; i++) {
+		if (i == 0) {
+			rfctl[0] = B43_NPHY_RFCTL_INTC1;
+			rfctl[1] = B43_NPHY_RFCTL_INTC2;
+			afectl_core = B43_NPHY_AFECTL_C1;
+		} else {
+			rfctl[0] = B43_NPHY_RFCTL_INTC2;
+			rfctl[1] = B43_NPHY_RFCTL_INTC1;
+			afectl_core = B43_NPHY_AFECTL_C2;
+		}
+
+		tmp[1] = b43_phy_read(dev, B43_NPHY_RFSEQCA);
+		tmp[2] = b43_phy_read(dev, afectl_core);
+		tmp[3] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
+		tmp[4] = b43_phy_read(dev, rfctl[0]);
+		tmp[5] = b43_phy_read(dev, rfctl[1]);
+
+		b43_phy_maskset(dev, B43_NPHY_RFSEQCA,
+				(u16)~B43_NPHY_RFSEQCA_RXDIS,
+				((1 - i) << B43_NPHY_RFSEQCA_RXDIS_SHIFT));
+		b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_TXEN,
+				(1 - i));
+		b43_phy_set(dev, afectl_core, 0x0006);
+		b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x0006);
+
+		band = b43_current_band(dev->wl);
+
+		if (nphy->rxcalparams & 0xFF000000) {
+			if (band == IEEE80211_BAND_5GHZ)
+				b43_phy_write(dev, rfctl[0], 0x140);
+			else
+				b43_phy_write(dev, rfctl[0], 0x110);
+		} else {
+			if (band == IEEE80211_BAND_5GHZ)
+				b43_phy_write(dev, rfctl[0], 0x180);
+			else
+				b43_phy_write(dev, rfctl[0], 0x120);
+		}
+
+		if (band == IEEE80211_BAND_5GHZ)
+			b43_phy_write(dev, rfctl[1], 0x148);
+		else
+			b43_phy_write(dev, rfctl[1], 0x114);
+
+		if (nphy->rxcalparams & 0x10000) {
+			b43_radio_maskset(dev, B2055_C1_GENSPARE2, 0xFC,
+					(i + 1));
+			b43_radio_maskset(dev, B2055_C2_GENSPARE2, 0xFC,
+					(2 - i));
+		}
+
+		for (j = 0; i < 4; j++) {
+			if (j < 3) {
+				cur_lna = lna[j];
+				cur_hpf1 = hpf1[j];
+				cur_hpf2 = hpf2[j];
+			} else {
+				if (power[1] > 10000) {
+					use = 1;
+					cur_hpf = cur_hpf1;
+					index = 2;
+				} else {
+					if (power[0] > 10000) {
+						use = 1;
+						cur_hpf = cur_hpf1;
+						index = 1;
+					} else {
+						index = 0;
+						use = 2;
+						cur_hpf = cur_hpf2;
+					}
+				}
+				cur_lna = lna[index];
+				cur_hpf1 = hpf1[index];
+				cur_hpf2 = hpf2[index];
+				cur_hpf += desired - hweight32(power[index]);
+				cur_hpf = clamp_val(cur_hpf, 0, 10);
+				if (use == 1)
+					cur_hpf1 = cur_hpf;
+				else
+					cur_hpf2 = cur_hpf;
+			}
+
+			tmp[0] = ((cur_hpf2 << 8) | (cur_hpf1 << 4) |
+					(cur_lna << 2));
+			//TODO: Call N PHY RF Ctrl Override with 0x400, tmp[0], 3, 0 as arguments
+			//TODO: Call N PHY Force RF Seq with 2 as argument
+			//TODO: Call N PHT Stop Playback
+
+			if (playtone) {
+				//TODO: Call N PHY TX Tone with 4000, (nphy_rxcalparams & 0xffff), 0, 0 as arguments and save result as ret
+				playtone = false;
+			} else {
+				//TODO: Call N PHY Run Samples with 160, 0xFFFF, 0, 0, 0 as arguments
+			}
+
+			if (ret == 0) {
+				if (j < 3) {
+					b43_nphy_rx_iq_est(dev, &est, 1024, 32,
+									false);
+					if (i == 0) {
+						real = est.i0_pwr;
+						imag = est.q0_pwr;
+					} else {
+						real = est.i1_pwr;
+						imag = est.q1_pwr;
+					}
+					power[i] = ((real + imag) / 1024) + 1;
+				} else {
+					//TODO: Call N PHY Calc RX IQ Comp with (1 << i) as argument
+				}
+				//TODO: Call N PHY Stop Playback
+			}
+
+			if (ret != 0)
+				break;
+		}
+
+		b43_radio_mask(dev, B2055_C1_GENSPARE2, 0xFC);
+		b43_radio_mask(dev, B2055_C2_GENSPARE2, 0xFC);
+		b43_phy_write(dev, rfctl[1], tmp[5]);
+		b43_phy_write(dev, rfctl[0], tmp[4]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, tmp[3]);
+		b43_phy_write(dev, afectl_core, tmp[2]);
+		b43_phy_write(dev, B43_NPHY_RFSEQCA, tmp[1]);
+
+		if (ret != 0)
+			break;
+	}
+
+	//TODO: Call N PHY RF Ctrl Override with 0x400, 0, 3, 1 as arguments
+	//TODO: Call N PHY Force RF Seq with 2 as argument
+	//TODO: Write an N PHY Table with ID 7, length 2, offset 0x110, width 16, and data from gain_save
+
+	b43_nphy_stay_in_carrier_search(dev, 0);
+
+	return ret;
+}
+
+static int b43_nphy_rev3_cal_rx_iq(struct b43_wldev *dev,
+			struct nphy_txgains target, u8 type, bool debug)
+{
+	return -1;
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalRxIq */
+static int b43_nphy_cal_rx_iq(struct b43_wldev *dev,
+			struct nphy_txgains target, u8 type, bool debug)
+{
+	if (dev->phy.rev >= 3)
+		return b43_nphy_rev3_cal_rx_iq(dev, target, type, debug);
+	else
+		return b43_nphy_rev2_cal_rx_iq(dev, target, type, debug);
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxLpFbw */
  static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
  {
@@ -1414,7 +1607,7 @@ int b43_phy_initn(struct b43_wldev *dev)
  					target = b43_nphy_get_tx_gains(dev);
  				}
  				/* TODO: If the output of N PHY Cal TX Iqlo with target, 1 0 as arguments is 0
-					If the output of N PHY Cal RX Iqlo with target, 2 0 as arguments is 0
+					if (b43_nphy_cal_rx_iq(dev, target, 2, 0) == 0)
  						Call N PHY Save Cal */
  			} else if (nphy->mphase_cal_phase_id == 0) {
  				//TODO N PHY Periodic Calibration with argument 3
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 491ff88..ab54b0f 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -973,6 +973,7 @@ struct b43_phy_n {
  	u8 antsel_type;
  	u16 papd_epsilon_offset[2];
  	u32 deaf_count;
+	u32 rxcalparams;
  	bool hang_avoid;
  	bool mute;

-- 
1.6.4.2

