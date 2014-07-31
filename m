Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44067 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaGaUBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:01:05 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so3218781wgh.6
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 13:01:01 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 3.18 7/7] b43: N-PHY: support setting custom TX power
Date: Thu, 31 Jul 2014 21:59:48 +0200
Message-Id: <1406836788-23704-8-git-send-email-zajec5@gmail.com> (sfid-20140731_220109_463592_5C04ABCE)
In-Reply-To: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
References: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Notes: I still need to implement helper for B43_MACCTL_PHY_LOCK, but
this may require wider changes, so will be handled in another patch.

V2: Make struct b43_ppr part of struct b43_phy_n
---
 drivers/net/wireless/b43/b43.h   |  1 +
 drivers/net/wireless/b43/phy_n.c | 84 ++++++++++++++++++++++++++++++++++------
 drivers/net/wireless/b43/phy_n.h |  4 ++
 3 files changed, 77 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index d55bd86..c0dda0b 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -457,6 +457,7 @@ enum {
 #define B43_MACCTL_RADIOLOCK		0x00080000	/* Radio lock */
 #define B43_MACCTL_BEACPROMISC		0x00100000	/* Beacon Promiscuous */
 #define B43_MACCTL_KEEP_BADPLCP		0x00200000	/* Keep frames with bad PLCP */
+#define B43_MACCTL_PHY_LOCK		0x00200000
 #define B43_MACCTL_KEEP_CTL		0x00400000	/* Keep control frames */
 #define B43_MACCTL_KEEP_BAD		0x00800000	/* Keep bad frames (FCS) */
 #define B43_MACCTL_PROMISC		0x01000000	/* Promiscuous mode */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 57a3ab2..cf625d8 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -34,6 +34,7 @@
 #include "radio_2056.h"
 #include "radio_2057.h"
 #include "main.h"
+#include "ppr.h"
 
 struct nphy_txgains {
 	u16 tx_lpf[2];
@@ -3606,16 +3607,6 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
  * Tx and Rx
  **************************************************/
 
-static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
-{//TODO
-}
-
-static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
-							bool ignore_tssi)
-{//TODO
-	return B43_TXPWR_RES_DONE;
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlEnable */
 static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 {
@@ -4069,6 +4060,7 @@ static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 
 	s16 a1[2], b0[2], b1[2];
 	u8 idle[2];
+	u8 ppr_max;
 	s8 target[2];
 	s32 num, den, pwr;
 	u32 regval[64];
@@ -4147,7 +4139,12 @@ static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 			b1[0] = b1[1] = -1393;
 		}
 	}
-	/* target[0] = target[1] = nphy->tx_power_max; */
+
+	ppr_max = b43_ppr_get_max(dev, &nphy->tx_pwr_max_ppr);
+	if (ppr_max) {
+		target[0] = ppr_max;
+		target[1] = ppr_max;
+	}
 
 	if (dev->phy.rev >= 3) {
 		if (sprom->fem.ghz2.tssipos)
@@ -5889,6 +5886,69 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 	b43_mac_enable(dev);
 }
 
+static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
+							bool ignore_tssi)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = dev->phy.n;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.chandef.chan;
+	struct b43_ppr *ppr = &nphy->tx_pwr_max_ppr;
+	u8 max; /* qdBm */
+	bool tx_pwr_state;
+
+	if (nphy->tx_pwr_last_recalc_freq == channel->center_freq &&
+	    nphy->tx_pwr_last_recalc_limit == phy->desired_txpower)
+		return B43_TXPWR_RES_DONE;
+
+	/* Make sure we have a clean PPR */
+	b43_ppr_clear(dev, ppr);
+
+	/* HW limitations */
+	b43_ppr_load_max_from_sprom(dev, ppr, B43_BAND_2G);
+
+	/* Regulatory & user settings */
+	max = INT_TO_Q52(phy->chandef->chan->max_power);
+	if (phy->desired_txpower)
+		max = min_t(u8, max, INT_TO_Q52(phy->desired_txpower));
+	b43_ppr_apply_max(dev, ppr, max);
+	if (b43_debug(dev, B43_DBG_XMITPOWER))
+		b43dbg(dev->wl, "Calculated TX power: " Q52_FMT "\n",
+		       Q52_ARG(b43_ppr_get_max(dev, ppr)));
+
+	/* TODO: Enable this once we get gains working */
+#if 0
+	/* Some extra gains */
+	hw_gain = 6; /* N-PHY specific */
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		hw_gain += sprom->antenna_gain.a0;
+	else
+		hw_gain += sprom->antenna_gain.a1;
+	b43_ppr_add(dev, ppr, -hw_gain);
+#endif
+
+	/* Make sure we didn't go too low */
+	b43_ppr_apply_min(dev, ppr, INT_TO_Q52(8));
+
+	/* Apply */
+	tx_pwr_state = nphy->txpwrctrl;
+	b43_mac_suspend(dev);
+	b43_nphy_tx_power_ctl_setup(dev);
+	if (dev->dev->core_rev == 11 || dev->dev->core_rev == 12) {
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~0, B43_MACCTL_PHY_LOCK);
+		b43_read32(dev, B43_MMIO_MACCTL);
+		udelay(1);
+	}
+	b43_nphy_tx_power_ctrl(dev, nphy->txpwrctrl);
+	if (dev->dev->core_rev == 11 || dev->dev->core_rev == 12)
+		b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_PHY_LOCK, 0);
+	b43_mac_enable(dev);
+
+	nphy->tx_pwr_last_recalc_freq = channel->center_freq;
+	nphy->tx_pwr_last_recalc_limit = phy->desired_txpower;
+
+	return B43_TXPWR_RES_DONE;
+}
+
 /**************************************************
  * N-PHY init
  **************************************************/
@@ -6422,6 +6482,7 @@ static int b43_nphy_op_allocate(struct b43_wldev *dev)
 	nphy = kzalloc(sizeof(*nphy), GFP_KERNEL);
 	if (!nphy)
 		return -ENOMEM;
+
 	dev->phy.n = nphy;
 
 	return 0;
@@ -6662,5 +6723,4 @@ const struct b43_phy_operations b43_phyops_n = {
 	.switch_channel		= b43_nphy_op_switch_channel,
 	.get_default_chan	= b43_nphy_op_get_default_chan,
 	.recalc_txpower		= b43_nphy_op_recalc_txpower,
-	.adjust_txpower		= b43_nphy_op_adjust_txpower,
 };
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 30bec81..a6da2c3 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -2,6 +2,7 @@
 #define B43_NPHY_H_
 
 #include "phy_common.h"
+#include "ppr.h"
 
 
 /* N-PHY registers. */
@@ -967,6 +968,9 @@ struct b43_phy_n {
 	struct b43_phy_n_txpwrindex txpwrindex[2];
 	struct b43_phy_n_pwr_ctl_info pwr_ctl_info[2];
 	struct b43_chanspec txiqlocal_chanspec;
+	struct b43_ppr tx_pwr_max_ppr;
+	u16 tx_pwr_last_recalc_freq;
+	int tx_pwr_last_recalc_limit;
 
 	u8 txrx_chain;
 	u16 tx_rx_cal_phy_saveregs[11];
-- 
1.8.4.5

