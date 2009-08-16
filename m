Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:50172 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZHPQFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 12:05:14 -0400
Received: by fxm11 with SMTP id 11so1907312fxm.39
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2009 09:05:15 -0700 (PDT)
Message-ID: <4A882E35.60407@gmail.com>
Date: Sun, 16 Aug 2009 18:05:09 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: LP-PHY: Update code for spec fixes, and fix a few
 typos
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few typos have been discovered in both the specs and the code.
This patch fixes them.

Also use lpphy_op_switch_channel consistently, and make all users
of it print its return value for easier debugging.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
V2: Fix one more typo (this time a harmless one).

 drivers/net/wireless/b43/phy_lp.c |   53 ++++++++++++++++++++++++------------
 1 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index d949cfa..1de4a74 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -554,7 +554,7 @@ static void lpphy_2062_init(struct b43_wldev *dev)
 	B43_WARN_ON(!(bus->chipco.capabilities & SSB_CHIPCO_CAP_PMU));
 	B43_WARN_ON(crystalfreq == 0);
 
-	if (crystalfreq >= 30000000) {
+	if (crystalfreq <= 30000000) {
 		lpphy->pdiv = 1;
 		b43_radio_mask(dev, B2062_S_RFPLL_CTL1, 0xFFFB);
 	} else {
@@ -562,14 +562,16 @@ static void lpphy_2062_init(struct b43_wldev *dev)
 		b43_radio_set(dev, B2062_S_RFPLL_CTL1, 0x4);
 	}
 
-	tmp = (800000000 * lpphy->pdiv + crystalfreq) /
-	      (32000000 * lpphy->pdiv);
-	tmp = (tmp - 1) & 0xFF;
+	tmp = (((800000000 * lpphy->pdiv + crystalfreq) /
+	      (2 * crystalfreq)) - 8) & 0xFF;
+	b43_radio_write(dev, B2062_S_RFPLL_CTL7, tmp);
+
+	tmp = (((100 * crystalfreq + 16000000 * lpphy->pdiv) /
+	      (32000000 * lpphy->pdiv)) - 1) & 0xFF;
 	b43_radio_write(dev, B2062_S_RFPLL_CTL18, tmp);
 
-	tmp = (2 * crystalfreq + 1000000 * lpphy->pdiv) /
-	      (2000000 * lpphy->pdiv);
-	tmp = ((tmp & 0xFF) - 1) & 0xFFFF;
+	tmp = (((2 * crystalfreq + 1000000 * lpphy->pdiv) /
+	      (2000000 * lpphy->pdiv)) - 1) & 0xFF;
 	b43_radio_write(dev, B2062_S_RFPLL_CTL19, tmp);
 
 	ref = (1000 * lpphy->pdiv + 2 * crystalfreq) / (2000 * lpphy->pdiv);
@@ -673,7 +675,7 @@ static void lpphy_radio_init(struct b43_wldev *dev)
 	b43_phy_mask(dev, B43_LPPHY_FOURWIRE_CTL, 0xFFFD);
 	udelay(1);
 
-	if (dev->phy.rev < 2) {
+	if (dev->phy.radio_ver == 0x2062) {
 		lpphy_2062_init(dev);
 	} else {
 		lpphy_2063_init(dev);
@@ -690,11 +692,18 @@ struct lpphy_iq_est { u32 iq_prod, i_pwr, q_pwr; };
 
 static void lpphy_set_rc_cap(struct b43_wldev *dev)
 {
-	u8 rc_cap = dev->phy.lp->rc_cap;
+	struct b43_phy_lp *lpphy = dev->phy.lp;
 
-	b43_radio_write(dev, B2062_N_RXBB_CALIB2, max_t(u8, rc_cap-4, 0x80));
-	b43_radio_write(dev, B2062_N_TX_CTL_A, ((rc_cap & 0x1F) >> 1) | 0x80);
-	b43_radio_write(dev, B2062_S_RXG_CNT16, ((rc_cap & 0x1F) >> 2) | 0x80);
+	u8 rc_cap = (lpphy->rc_cap & 0x1F) >> 1;
+	
+	if (dev->phy.rev == 1) //FIXME check channel 14!
+		rc_cap = max_t(u8, rc_cap + 5, 15);
+
+	b43_radio_write(dev, B2062_N_RXBB_CALIB2,
+			max_t(u8, lpphy->rc_cap - 4, 0x80));
+	b43_radio_write(dev, B2062_N_TX_CTL_A, rc_cap | 0x80);
+	b43_radio_write(dev, B2062_S_RXG_CNT16,
+			((lpphy->rc_cap & 0x1F) >> 2) | 0x80);
 }
 
 static u8 lpphy_get_bb_mult(struct b43_wldev *dev)
@@ -1103,6 +1112,9 @@ static void lpphy_set_tx_power_control(struct b43_wldev *dev,
 	lpphy_write_tx_pctl_mode_to_hardware(dev);
 }
 
+static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
+				       unsigned int new_channel);
+
 static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
@@ -1120,11 +1132,16 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
 	    old_rf2_ovr, old_rf2_ovrval, old_phy_ctl;
 	enum b43_lpphy_txpctl_mode old_txpctl;
 	u32 normal_pwr, ideal_pwr, mean_sq_pwr, tmp = 0, mean_sq_pwr_min = 0;
-	int loopback, i, j, inner_sum;
+	int loopback, i, j, inner_sum, err;
 
 	memset(&iq_est, 0, sizeof(iq_est));
 
-	b43_switch_channel(dev, 7);
+	err = b43_lpphy_op_switch_channel(dev, 7);
+	if (err) {
+		b43dbg(dev->wl,
+		       "RC calib: Failed to switch to channel 7, error = %d",
+		       err);
+	}
 	old_txg_ovr = (b43_phy_read(dev, B43_LPPHY_AFE_CTL_OVR) >> 6) & 1;
 	old_bbmult = lpphy_get_bb_mult(dev);
 	if (old_txg_ovr)
@@ -1883,14 +1900,14 @@ static int lpphy_b2062_tune(struct b43_wldev *dev,
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	struct ssb_bus *bus = dev->dev->bus;
-	static const struct b206x_channel *chandata = NULL;
+	const struct b206x_channel *chandata = NULL;
 	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
 	u32 tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9;
 	int i, err = 0;
 
-	for (i = 0; i < ARRAY_SIZE(b2063_chantbl); i++) {
-		if (b2063_chantbl[i].channel == channel) {
-			chandata = &b2063_chantbl[i];
+	for (i = 0; i < ARRAY_SIZE(b2062_chantbl); i++) {
+		if (b2062_chantbl[i].channel == channel) {
+			chandata = &b2062_chantbl[i];
 			break;
 		}
 	}
-- 
1.6.2.4



