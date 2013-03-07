Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33785 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab3CGPsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:48:09 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so458272eei.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:48:07 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 12/13] b43: HT-PHY: setup TX power control
Date: Thu,  7 Mar 2013 16:47:26 +0100
Message-Id: <1362671247-10766-13-git-send-email-zajec5@gmail.com> (sfid-20130307_171303_751768_816C6FE6)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |  109 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_ht.h |   25 +++++++++
 2 files changed, 134 insertions(+)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 831dca4..6d5eb04 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -557,6 +557,114 @@ static void b43_phy_ht_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 
 	/* TODO */
 }
+
+static void b43_phy_ht_tx_power_ctl_setup(struct b43_wldev *dev)
+{
+	struct b43_phy_ht *phy_ht = dev->phy.ht;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+
+	u8 *idle = phy_ht->idle_tssi;
+	u8 target[3];
+	s16 a1[3], b0[3], b1[3];
+
+	u16 freq = dev->phy.channel_freq;
+	int i, c;
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		for (c = 0; c < 3; c++) {
+			target[c] = sprom->core_pwr_info[c].maxpwr_2g;
+			a1[c] = sprom->core_pwr_info[c].pa_2g[0];
+			b0[c] = sprom->core_pwr_info[c].pa_2g[1];
+			b1[c] = sprom->core_pwr_info[c].pa_2g[2];
+		}
+	} else if (freq >= 4900 && freq < 5100) {
+		for (c = 0; c < 3; c++) {
+			target[c] = sprom->core_pwr_info[c].maxpwr_5gl;
+			a1[c] = sprom->core_pwr_info[c].pa_5gl[0];
+			b0[c] = sprom->core_pwr_info[c].pa_5gl[1];
+			b1[c] = sprom->core_pwr_info[c].pa_5gl[2];
+		}
+	} else if (freq >= 5100 && freq < 5500) {
+		for (c = 0; c < 3; c++) {
+			target[c] = sprom->core_pwr_info[c].maxpwr_5g;
+			a1[c] = sprom->core_pwr_info[c].pa_5g[0];
+			b0[c] = sprom->core_pwr_info[c].pa_5g[1];
+			b1[c] = sprom->core_pwr_info[c].pa_5g[2];
+		}
+	} else if (freq >= 5500) {
+		for (c = 0; c < 3; c++) {
+			target[c] = sprom->core_pwr_info[c].maxpwr_5gh;
+			a1[c] = sprom->core_pwr_info[c].pa_5gh[0];
+			b0[c] = sprom->core_pwr_info[c].pa_5gh[1];
+			b1[c] = sprom->core_pwr_info[c].pa_5gh[2];
+		}
+	} else {
+		target[0] = target[1] = target[2] = 52;
+		a1[0] = a1[1] = a1[2] = -424;
+		b0[0] = b0[1] = b0[2] = 5612;
+		b1[0] = b1[1] = b1[2] = -1393;
+	}
+
+	b43_phy_set(dev, B43_PHY_HT_TSSIMODE, B43_PHY_HT_TSSIMODE_EN);
+	b43_phy_mask(dev, B43_PHY_HT_TXPCTL_CMD_C1,
+		     ~B43_PHY_HT_TXPCTL_CMD_C1_PCTLEN & 0xFFFF);
+
+	/* TODO: Does it depend on sprom->fem.ghz2.tssipos? */
+	b43_phy_set(dev, B43_PHY_HT_TXPCTL_IDLE_TSSI, 0x4000);
+
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_CMD_C1,
+			~B43_PHY_HT_TXPCTL_CMD_C1_INIT, 0x19);
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_CMD_C2,
+			~B43_PHY_HT_TXPCTL_CMD_C2_INIT, 0x19);
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_CMD_C3,
+			~B43_PHY_HT_TXPCTL_CMD_C3_INIT, 0x19);
+
+	b43_phy_set(dev, B43_PHY_HT_TXPCTL_IDLE_TSSI,
+		    B43_PHY_HT_TXPCTL_IDLE_TSSI_BINF);
+
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_IDLE_TSSI,
+			~B43_PHY_HT_TXPCTL_IDLE_TSSI_C1,
+			idle[0] << B43_PHY_HT_TXPCTL_IDLE_TSSI_C1_SHIFT);
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_IDLE_TSSI,
+			~B43_PHY_HT_TXPCTL_IDLE_TSSI_C2,
+			idle[1] << B43_PHY_HT_TXPCTL_IDLE_TSSI_C2_SHIFT);
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_IDLE_TSSI2,
+			~B43_PHY_HT_TXPCTL_IDLE_TSSI2_C3,
+			idle[2] << B43_PHY_HT_TXPCTL_IDLE_TSSI2_C3_SHIFT);
+
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_N, ~B43_PHY_HT_TXPCTL_N_TSSID,
+			0xf0);
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_N, ~B43_PHY_HT_TXPCTL_N_NPTIL2,
+			0x3 << B43_PHY_HT_TXPCTL_N_NPTIL2_SHIFT);
+#if 0
+	/* TODO: what to mask/set? */
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_CMD_C1, 0x800, 0)
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_CMD_C1, 0x400, 0)
+#endif
+
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_TARG_PWR,
+			~B43_PHY_HT_TXPCTL_TARG_PWR_C1,
+			target[0] << B43_PHY_HT_TXPCTL_TARG_PWR_C1_SHIFT);
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_TARG_PWR,
+			~B43_PHY_HT_TXPCTL_TARG_PWR_C2 & 0xFFFF,
+			target[1] << B43_PHY_HT_TXPCTL_TARG_PWR_C2_SHIFT);
+	b43_phy_maskset(dev, B43_PHY_HT_TXPCTL_TARG_PWR2,
+			~B43_PHY_HT_TXPCTL_TARG_PWR2_C3,
+			target[2] << B43_PHY_HT_TXPCTL_TARG_PWR2_C3_SHIFT);
+
+	for (c = 0; c < 3; c++) {
+		s32 num, den, pwr;
+		u32 regval[64];
+
+		for (i = 0; i < 64; i++) {
+			num = 8 * (16 * b0[c] + b1[c] * i);
+			den = 32768 + a1[c] * i;
+			pwr = max((4 * num + den / 2) / den, -8);
+			regval[i] = pwr;
+		}
+		b43_httab_write_bulk(dev, B43_HTTAB16(26 + c, 0), 64, regval);
+	}
+}
 #endif
 
 /**************************************************
@@ -844,6 +952,7 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 #if 0
 	b43_phy_ht_tx_power_ctl(dev, false);
 	b43_phy_ht_tx_power_ctl_idle_tssi(dev);
+	b43_phy_ht_tx_power_ctl_setup(dev);
 	/* TODO */
 	b43_phy_ht_tx_power_ctl(dev, saved_tx_pwr_ctl);
 #endif
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 165c501..9b2408e 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -23,6 +23,9 @@
 #define B43_PHY_HT_SAMP_WAIT_CNT		0x0C5	/* Sample wait count */
 #define B43_PHY_HT_SAMP_DEP_CNT			0x0C6	/* Sample depth count */
 #define B43_PHY_HT_SAMP_STAT			0x0C7	/* Sample status */
+#define B43_PHY_HT_TSSIMODE			0x122	/* TSSI mode */
+#define  B43_PHY_HT_TSSIMODE_EN			0x0001	/* TSSI enable */
+#define  B43_PHY_HT_TSSIMODE_PDEN		0x0002	/* Power det enable */
 #define B43_PHY_HT_BW1				0x1CE
 #define B43_PHY_HT_BW2				0x1CF
 #define B43_PHY_HT_BW3				0x1D0
@@ -34,6 +37,22 @@
 #define  B43_PHY_HT_TXPCTL_CMD_C1_COEFF		0x2000	/* Power control coefficients */
 #define  B43_PHY_HT_TXPCTL_CMD_C1_HWPCTLEN	0x4000	/* Hardware TX power control enable */
 #define  B43_PHY_HT_TXPCTL_CMD_C1_PCTLEN	0x8000	/* TX power control enable */
+#define B43_PHY_HT_TXPCTL_N			0x1E8	/* TX power control N num */
+#define  B43_PHY_HT_TXPCTL_N_TSSID		0x00FF	/* N TSSI delay */
+#define  B43_PHY_HT_TXPCTL_N_TSSID_SHIFT	0
+#define  B43_PHY_HT_TXPCTL_N_NPTIL2		0x0700	/* N PT integer log2 */
+#define  B43_PHY_HT_TXPCTL_N_NPTIL2_SHIFT	8
+#define B43_PHY_HT_TXPCTL_IDLE_TSSI		0x1E9	/* TX power control idle TSSI */
+#define  B43_PHY_HT_TXPCTL_IDLE_TSSI_C1		0x003F
+#define  B43_PHY_HT_TXPCTL_IDLE_TSSI_C1_SHIFT	0
+#define  B43_PHY_HT_TXPCTL_IDLE_TSSI_C2		0x3F00
+#define  B43_PHY_HT_TXPCTL_IDLE_TSSI_C2_SHIFT	8
+#define  B43_PHY_HT_TXPCTL_IDLE_TSSI_BINF	0x8000	/* Raw TSSI offset bin format */
+#define B43_PHY_HT_TXPCTL_TARG_PWR		0x1EA	/* TX power control target power */
+#define  B43_PHY_HT_TXPCTL_TARG_PWR_C1		0x00FF	/* Power 0 */
+#define  B43_PHY_HT_TXPCTL_TARG_PWR_C1_SHIFT	0
+#define  B43_PHY_HT_TXPCTL_TARG_PWR_C2		0xFF00	/* Power 1 */
+#define  B43_PHY_HT_TXPCTL_TARG_PWR_C2_SHIFT	8
 #define B43_PHY_HT_TXPCTL_CMD_C2		0x222
 #define  B43_PHY_HT_TXPCTL_CMD_C2_INIT		0x007F
 #define B43_PHY_HT_RSSI_C1			0x219
@@ -72,6 +91,12 @@
 
 #define B43_PHY_HT_TXPCTL_CMD_C3		B43_PHY_EXTG(0x164)
 #define  B43_PHY_HT_TXPCTL_CMD_C3_INIT		0x007F
+#define B43_PHY_HT_TXPCTL_IDLE_TSSI2		B43_PHY_EXTG(0x165)	/* TX power control idle TSSI */
+#define  B43_PHY_HT_TXPCTL_IDLE_TSSI2_C3	0x003F
+#define  B43_PHY_HT_TXPCTL_IDLE_TSSI2_C3_SHIFT	0
+#define B43_PHY_HT_TXPCTL_TARG_PWR2		B43_PHY_EXTG(0x166)	/* TX power control target power */
+#define  B43_PHY_HT_TXPCTL_TARG_PWR2_C3		0x00FF
+#define  B43_PHY_HT_TXPCTL_TARG_PWR2_C3_SHIFT	0
 
 #define B43_PHY_HT_TEST				B43_PHY_N_BMODE(0x00A)
 
-- 
1.7.10.4

