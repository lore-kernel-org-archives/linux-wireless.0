Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40972 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2ABRuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 12:50:09 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so15359264eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jan 2012 09:50:08 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/3] b43: N-PHY: implement TX power control setup
Date: Mon,  2 Jan 2012 19:31:22 +0100
Message-Id: <1325529082-10218-2-git-send-email-zajec5@gmail.com> (sfid-20120102_185013_697612_3F3161BF)
In-Reply-To: <1325529082-10218-1-git-send-email-zajec5@gmail.com>
References: <1325529082-10218-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  217 +++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/phy_n.h |    1 +
 2 files changed, 217 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c5cb0f4..15a0b79 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2420,6 +2420,221 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 	nphy->pwr_ctl_info[1].idle_tssi_2g = (tmp >> 8) & 0xFF;
 }
 
+/* http://bcm-v4.sipsolutions.net/PHY/N/TxPwrLimitToTbl */
+static void b43_nphy_tx_prepare_adjusted_power_table(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u8 idx, delta;
+	u8 i, stf_mode;
+
+	for (i = 0; i < 4; i++)
+		nphy->adj_pwr_tbl[i] = nphy->tx_power_offset[i];
+
+	for (stf_mode = 0; stf_mode < 4; stf_mode++) {
+		delta = 0;
+		switch (stf_mode) {
+		case 0:
+			if (dev->phy.is_40mhz && dev->phy.rev >= 5) {
+				idx = 68;
+			} else {
+				delta = 1;
+				idx = dev->phy.is_40mhz ? 52 : 4;
+			}
+			break;
+		case 1:
+			idx = dev->phy.is_40mhz ? 76 : 28;
+			break;
+		case 2:
+			idx = dev->phy.is_40mhz ? 84 : 36;
+			break;
+		case 3:
+			idx = dev->phy.is_40mhz ? 92 : 44;
+			break;
+		}
+
+		for (i = 0; i < 20; i++) {
+			nphy->adj_pwr_tbl[4 + 4 * i + stf_mode] =
+				nphy->tx_power_offset[idx];
+			if (i == 0)
+				idx += delta;
+			if (i == 14)
+				idx += 1 - delta;
+			if (i == 3 || i == 4 || i == 7 || i == 8 || i == 11 ||
+			    i == 13)
+				idx += 1;
+		}
+	}
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlSetup */
+static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+
+	s16 a1[2], b0[2], b1[2];
+	u8 idle[2];
+	s8 target[2];
+	s32 num, den, pwr;
+	u32 regval[64];
+
+	u16 freq = dev->phy.channel_freq;
+	u16 tmp;
+	u16 r; /* routing */
+	u8 i, c;
+
+	if (dev->dev->core_rev == 11 || dev->dev->core_rev == 12) {
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~0, 0x200000);
+		b43_read32(dev, B43_MMIO_MACCTL);
+		udelay(1);
+	}
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, true);
+
+	b43_phy_set(dev, B43_NPHY_TSSIMODE, B43_NPHY_TSSIMODE_EN);
+	if (dev->phy.rev >= 3)
+		b43_phy_mask(dev, B43_NPHY_TXPCTL_CMD,
+			     ~B43_NPHY_TXPCTL_CMD_PCTLEN & 0xFFFF);
+	else
+		b43_phy_set(dev, B43_NPHY_TXPCTL_CMD,
+			    B43_NPHY_TXPCTL_CMD_PCTLEN);
+
+	if (dev->dev->core_rev == 11 || dev->dev->core_rev == 12)
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~0x200000, 0);
+
+	if (sprom->revision < 4) {
+		idle[0] = nphy->pwr_ctl_info[0].idle_tssi_2g;
+		idle[1] = nphy->pwr_ctl_info[1].idle_tssi_2g;
+		target[0] = target[1] = 52;
+		a1[0] = a1[1] = -424;
+		b0[0] = b0[1] = 5612;
+		b1[0] = b1[1] = -1393;
+	} else {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			for (c = 0; c < 2; c++) {
+				idle[c] = nphy->pwr_ctl_info[c].idle_tssi_2g;
+				target[c] = sprom->core_pwr_info[c].maxpwr_2g;
+				a1[c] = sprom->core_pwr_info[c].pa_2g[0];
+				b0[c] = sprom->core_pwr_info[c].pa_2g[1];
+				b1[c] = sprom->core_pwr_info[c].pa_2g[2];
+			}
+		} else if (freq >= 4900 && freq < 5100) {
+			for (c = 0; c < 2; c++) {
+				idle[c] = nphy->pwr_ctl_info[c].idle_tssi_5g;
+				target[c] = sprom->core_pwr_info[c].maxpwr_5gl;
+				a1[c] = sprom->core_pwr_info[c].pa_5gl[0];
+				b0[c] = sprom->core_pwr_info[c].pa_5gl[1];
+				b1[c] = sprom->core_pwr_info[c].pa_5gl[2];
+			}
+		} else if (freq >= 5100 && freq < 5500) {
+			for (c = 0; c < 2; c++) {
+				idle[c] = nphy->pwr_ctl_info[c].idle_tssi_5g;
+				target[c] = sprom->core_pwr_info[c].maxpwr_5g;
+				a1[c] = sprom->core_pwr_info[c].pa_5g[0];
+				b0[c] = sprom->core_pwr_info[c].pa_5g[1];
+				b1[c] = sprom->core_pwr_info[c].pa_5g[2];
+			}
+		} else if (freq >= 5500) {
+			for (c = 0; c < 2; c++) {
+				idle[c] = nphy->pwr_ctl_info[c].idle_tssi_5g;
+				target[c] = sprom->core_pwr_info[c].maxpwr_5gh;
+				a1[c] = sprom->core_pwr_info[c].pa_5gh[0];
+				b0[c] = sprom->core_pwr_info[c].pa_5gh[1];
+				b1[c] = sprom->core_pwr_info[c].pa_5gh[2];
+			}
+		} else {
+			idle[0] = nphy->pwr_ctl_info[0].idle_tssi_5g;
+			idle[1] = nphy->pwr_ctl_info[1].idle_tssi_5g;
+			target[0] = target[1] = 52;
+			a1[0] = a1[1] = -424;
+			b0[0] = b0[1] = 5612;
+			b1[0] = b1[1] = -1393;
+		}
+	}
+	/* target[0] = target[1] = nphy->tx_power_max; */
+
+	if (dev->phy.rev >= 3) {
+		if (sprom->fem.ghz2.tssipos)
+			b43_phy_set(dev, B43_NPHY_TXPCTL_ITSSI, 0x4000);
+		if (dev->phy.rev >= 7) {
+			for (c = 0; c < 2; c++) {
+				r = c ? 0x190 : 0x170;
+				if (b43_nphy_ipa(dev))
+					b43_radio_write(dev, r + 0x9, (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) ? 0xE : 0xC);
+			}
+		} else {
+			if (b43_nphy_ipa(dev)) {
+				tmp = (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ? 0xC : 0xE;
+				b43_radio_write(dev,
+					B2056_TX0 | B2056_TX_TX_SSI_MUX, tmp);
+				b43_radio_write(dev,
+					B2056_TX1 | B2056_TX_TX_SSI_MUX, tmp);
+			} else {
+				b43_radio_write(dev,
+					B2056_TX0 | B2056_TX_TX_SSI_MUX, 0x11);
+				b43_radio_write(dev,
+					B2056_TX1 | B2056_TX_TX_SSI_MUX, 0x11);
+			}
+		}
+	}
+
+	if (dev->dev->core_rev == 11 || dev->dev->core_rev == 12) {
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~0, 0x200000);
+		b43_read32(dev, B43_MMIO_MACCTL);
+		udelay(1);
+	}
+
+	if (dev->phy.rev >= 7) {
+		b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD,
+				~B43_NPHY_TXPCTL_CMD_INIT, 0x19);
+		b43_phy_maskset(dev, B43_NPHY_TXPCTL_INIT,
+				~B43_NPHY_TXPCTL_INIT_PIDXI1, 0x19);
+	} else {
+		b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD,
+				~B43_NPHY_TXPCTL_CMD_INIT, 0x40);
+		if (dev->phy.rev > 1)
+			b43_phy_maskset(dev, B43_NPHY_TXPCTL_INIT,
+				~B43_NPHY_TXPCTL_INIT_PIDXI1, 0x40);
+	}
+
+	if (dev->dev->core_rev == 11 || dev->dev->core_rev == 12)
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~0x200000, 0);
+
+	b43_phy_write(dev, B43_NPHY_TXPCTL_N,
+		      0xF0 << B43_NPHY_TXPCTL_N_TSSID_SHIFT |
+		      3 << B43_NPHY_TXPCTL_N_NPTIL2_SHIFT);
+	b43_phy_write(dev, B43_NPHY_TXPCTL_ITSSI,
+		      idle[0] << B43_NPHY_TXPCTL_ITSSI_0_SHIFT |
+		      idle[1] << B43_NPHY_TXPCTL_ITSSI_1_SHIFT |
+		      B43_NPHY_TXPCTL_ITSSI_BINF);
+	b43_phy_write(dev, B43_NPHY_TXPCTL_TPWR,
+		      target[0] << B43_NPHY_TXPCTL_TPWR_0_SHIFT |
+		      target[1] << B43_NPHY_TXPCTL_TPWR_1_SHIFT);
+
+	for (c = 0; c < 2; c++) {
+		for (i = 0; i < 64; i++) {
+			num = 8 * (16 * b0[c] + b1[c] * i);
+			den = 32768 + a1[c] * i;
+			pwr = max((4 * num + den / 2) / den, -8);
+			if (dev->phy.rev < 3 && (i <= (31 - idle[c] + 1)))
+				pwr = max(pwr, target[c] + 1);
+			regval[i] = pwr;
+		}
+		b43_ntab_write_bulk(dev, B43_NTAB32(26 + c, 0), 64, regval);
+	}
+
+	b43_nphy_tx_prepare_adjusted_power_table(dev);
+	/*
+	b43_ntab_write_bulk(dev, B43_NTAB16(26, 64), 84, nphy->adj_pwr_tbl);
+	b43_ntab_write_bulk(dev, B43_NTAB16(27, 64), 84, nphy->adj_pwr_tbl);
+	*/
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, false);
+}
+
 static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -4107,7 +4322,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_nphy_tx_power_ctrl(dev, false);
 	b43_nphy_tx_power_fix(dev);
 	b43_nphy_tx_power_ctl_idle_tssi(dev);
-	/* TODO N PHY TX Power Control Setup */
+	b43_nphy_tx_power_ctl_setup(dev);
 	b43_nphy_tx_gain_table_upload(dev);
 
 	if (nphy->phyrxchain != 3)
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 5de8f74..fd12b38 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -798,6 +798,7 @@ struct b43_phy_n {
 	bool txpwrctrl;
 	bool pwg_gain_5ghz;
 	u8 tx_pwr_idx[2];
+	s8 tx_power_offset[101];
 	u16 adj_pwr_tbl[84];
 	u16 txcal_bbmult;
 	u16 txiqlocal_bestc[11];
-- 
1.7.3.4

