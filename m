Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42391 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0K1MAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 07:00:09 -0500
Received: by wwa36 with SMTP id 36so3665501wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Nov 2010 04:00:08 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: N-PHY: implement very basic TX power control management
Date: Sun, 28 Nov 2010 12:59:43 +0100
Message-Id: <1290945585-20864-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290945585-20864-1-git-send-email-zajec5@gmail.com>
References: <1290945585-20864-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John, this patch depends on ssb patch I've sent today
---
 drivers/net/wireless/b43/phy_n.c |  159 ++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/b43/phy_n.h |    2 +-
 2 files changed, 153 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index bf1a1d4..d5595b6 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -67,6 +67,8 @@ enum b43_nphy_rf_sequence {
 	B43_RFSEQ_UPDATE_GAINU,
 };
 
+static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev,
+						bool enable);
 static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
 					u8 *events, u8 *delays, u8 length);
 static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
@@ -145,9 +147,153 @@ static void b43_chantab_phy_upload(struct b43_wldev *dev,
 	b43_phy_write(dev, B43_NPHY_BW6, e->phy_bw6);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlEnable */
+static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	u8 i;
+	u16 tmp;
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	nphy->txpwrctrl = enable;
+	if (!enable) {
+		if (dev->phy.rev >= 3)
+			; /* TODO */
+
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x6840);
+		for (i = 0; i < 84; i++)
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0);
+
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x6C40);
+		for (i = 0; i < 84; i++)
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0);
+
+		tmp = B43_NPHY_TXPCTL_CMD_COEFF | B43_NPHY_TXPCTL_CMD_HWPCTLEN;
+		if (dev->phy.rev >= 3)
+			tmp |= B43_NPHY_TXPCTL_CMD_PCTLEN;
+		b43_phy_mask(dev, B43_NPHY_TXPCTL_CMD, ~tmp);
+
+		if (dev->phy.rev >= 3) {
+			b43_phy_set(dev, B43_NPHY_AFECTL_OVER1, 0x0100);
+			b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x0100);
+		} else {
+			b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x4000);
+		}
+
+		if (dev->phy.rev == 2)
+			b43_phy_maskset(dev, B43_NPHY_BPHY_CTL3,
+				~B43_NPHY_BPHY_CTL3_SCALE, 0x53);
+		else if (dev->phy.rev < 2)
+			b43_phy_maskset(dev, B43_NPHY_BPHY_CTL3,
+				~B43_NPHY_BPHY_CTL3_SCALE, 0x5A);
+
+		if (dev->phy.rev < 2 && 0)
+			; /* TODO */
+	} else {
+		b43err(dev->wl, "enabling tx pwr ctrl not implemented yet\n");
+	}
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrFix */
 static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 {
-	//TODO
+	struct b43_phy_n *nphy = dev->phy.n;
+	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
+
+	u8 txpi[2], bbmult, i;
+	u16 tmp, radio_gain, dac_gain;
+	u16 freq = dev->phy.channel_freq;
+	u32 txgain;
+	/* u32 gaintbl; rev3+ */
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	if (dev->phy.rev >= 3) {
+		txpi[0] = 40;
+		txpi[1] = 40;
+	} else if (sprom->revision < 4) {
+		txpi[0] = 72;
+		txpi[1] = 72;
+	} else {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			txpi[0] = sprom->txpid2g[0];
+			txpi[1] = sprom->txpid2g[1];
+		} else if (freq >= 4900 && freq < 5100) {
+			txpi[0] = sprom->txpid5gl[0];
+			txpi[1] = sprom->txpid5gl[1];
+		} else if (freq >= 5100 && freq < 5500) {
+			txpi[0] = sprom->txpid5g[0];
+			txpi[1] = sprom->txpid5g[1];
+		} else if (freq >= 5500) {
+			txpi[0] = sprom->txpid5gh[0];
+			txpi[1] = sprom->txpid5gh[1];
+		} else {
+			txpi[0] = 91;
+			txpi[1] = 91;
+		}
+	}
+
+	/*
+	for (i = 0; i < 2; i++) {
+		nphy->txpwrindex[i].index_internal = txpi[i];
+		nphy->txpwrindex[i].index_internal_save = txpi[i];
+	}
+	*/
+
+	for (i = 0; i < 2; i++) {
+		if (dev->phy.rev >= 3) {
+			/* TODO */
+			radio_gain = (txgain >> 16) & 0x1FFFF;
+		} else {
+			txgain = b43_ntab_tx_gain_rev0_1_2[txpi[i]];
+			radio_gain = (txgain >> 16) & 0x1FFF;
+		}
+
+		dac_gain = (txgain >> 8) & 0x3F;
+		bbmult = txgain & 0xFF;
+
+		if (dev->phy.rev >= 3) {
+			if (i == 0)
+				b43_phy_set(dev, B43_NPHY_AFECTL_OVER1, 0x0100);
+			else
+				b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x0100);
+		} else {
+			b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x4000);
+		}
+
+		if (i == 0)
+			b43_phy_write(dev, B43_NPHY_AFECTL_DACGAIN1, dac_gain);
+		else
+			b43_phy_write(dev, B43_NPHY_AFECTL_DACGAIN2, dac_gain);
+
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D10 + i);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, radio_gain);
+
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x3C57);
+		tmp = b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+
+		if (i == 0)
+			tmp = (tmp & 0x00FF) | (bbmult << 8);
+		else
+			tmp = (tmp & 0xFF00) | bbmult;
+
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x3C57);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, tmp);
+
+		if (0)
+			; /* TODO */
+	}
+
+	b43_phy_mask(dev, B43_NPHY_BPHY_CTL2, ~B43_NPHY_BPHY_CTL2_LUT);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
 
@@ -2351,7 +2497,7 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 	struct nphy_txgains target;
 	const u32 *table = NULL;
 
-	if (nphy->txpwrctrl == 0) {
+	if (!nphy->txpwrctrl) {
 		int i;
 
 		if (nphy->hang_avoid)
@@ -3260,9 +3406,8 @@ int b43_phy_initn(struct b43_wldev *dev)
 		b43_nphy_bphy_init(dev);
 
 	tx_pwr_state = nphy->txpwrctrl;
-	/* TODO N PHY TX power control with argument 0
-		(turning off power control) */
-	/* TODO Fix the TX Power Settings */
+	b43_nphy_tx_power_ctrl(dev, false);
+	b43_nphy_tx_power_fix(dev);
 	/* TODO N PHY TX Power Control Idle TSSI */
 	/* TODO N PHY TX Power Control Setup */
 
@@ -3333,7 +3478,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	}
 
 	b43_nphy_tx_pwr_ctrl_coef_setup(dev);
-	/* TODO N PHY TX Power Control Enable with argument tx_pwr_state */
+	b43_nphy_tx_power_ctrl(dev, tx_pwr_state);
 	b43_phy_write(dev, B43_NPHY_TXMACIF_HOLDOFF, 0x0015);
 	b43_phy_write(dev, B43_NPHY_TXMACDELAY, 0x0320);
 	if (phy->rev >= 3 && phy->rev <= 6)
@@ -3384,7 +3529,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 			b43_phy_mask(dev, B43_PHY_B_TEST, ~0x840);
 	}
 
-	if (nphy->txpwrctrl)
+	if (!nphy->txpwrctrl)
 		b43_nphy_tx_power_fix(dev);
 
 	if (dev->phy.rev < 3)
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index c144e59..001e841 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -782,7 +782,7 @@ struct b43_phy_n {
 	u16 mphase_txcal_numcmds;
 	u16 mphase_txcal_bestcoeffs[11];
 
-	u8 txpwrctrl;
+	bool txpwrctrl;
 	u16 txcal_bbmult;
 	u16 txiqlocal_bestc[11];
 	bool txiqlocal_coeffsvalid;
-- 
1.6.3.3

