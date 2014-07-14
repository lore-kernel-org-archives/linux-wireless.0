Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44065 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbaGNUW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 16:22:29 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so3214610wiv.11
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2014 13:22:27 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH 2/2] b43: N-PHY: support setting TX power
Date: Mon, 14 Jul 2014 22:20:37 +0200
Message-Id: <1405369237-3012-2-git-send-email-zajec5@gmail.com> (sfid-20140714_222235_864309_F57FEDB5)
In-Reply-To: <1405369237-3012-1-git-send-email-zajec5@gmail.com>
References: <1405369237-3012-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
So far it was tested on BCM43228 only. I can say that changing TX power
definitely affects performance, but I have to check for regressions.
---
 drivers/net/wireless/b43/b43.h   |  1 +
 drivers/net/wireless/b43/phy_n.c | 81 ++++++++++++++++++++++++++++++++++------
 drivers/net/wireless/b43/phy_n.h |  3 ++
 3 files changed, 73 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 6cfd86d..9b8feb9 100644
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
index 479cda8..b60ac1f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -34,6 +34,7 @@
 #include "radio_2056.h"
 #include "radio_2057.h"
 #include "main.h"
+#include "ppr.h"
 
 struct nphy_txgains {
 	u16 tx_lpf[2];
@@ -3396,16 +3397,6 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
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
@@ -3936,7 +3927,11 @@ static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 			b1[0] = b1[1] = -1393;
 		}
 	}
-	/* target[0] = target[1] = nphy->tx_power_max; */
+
+	if (nphy->tx_pwr_max_ppr) {
+		target[0] = b43_ppr_get_max(dev, nphy->tx_pwr_max_ppr);
+		target[1] = target[0];
+	}
 
 	if (dev->phy.rev >= 3) {
 		if (sprom->fem.ghz2.tssipos)
@@ -5642,6 +5637,67 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 	b43_mac_enable(dev);
 }
 
+static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
+							bool ignore_tssi)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = dev->phy.n;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.chandef.chan;
+	u8 max; /* qdBm */
+	int hw_gain; /* qdBm */
+	bool tx_pwr_state;
+
+	if (nphy->tx_pwr_last_recalc_freq == channel->center_freq &&
+	    nphy->tx_pwr_last_recalc_limit == phy->desired_txpower)
+		return B43_TXPWR_RES_DONE;
+
+	if (!nphy->tx_pwr_max_ppr) {
+		nphy->tx_pwr_max_ppr = b43_ppr_alloc(dev);
+		if (WARN_ON(!nphy->tx_pwr_max_ppr))
+			return B43_TXPWR_RES_DONE;
+	} else {
+		b43_ppr_clear(dev, nphy->tx_pwr_max_ppr);
+	}
+
+	/* HW limitations */
+	b43_ppr_load_max_from_sprom(dev, nphy->tx_pwr_max_ppr, B43_BAND_2G);
+
+	/* Regulatory & user settings */
+	max = INT_TO_Q52(phy->chandef->chan->max_power);
+	max = min_t(u8, max, INT_TO_Q52(phy->desired_txpower));
+	b43_ppr_apply_max(dev, nphy->tx_pwr_max_ppr, max);
+
+	/* Some extra gains */
+	hw_gain = 6; /* N-PHY specific */
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		hw_gain += sprom->antenna_gain.a0;
+	else
+		hw_gain += sprom->antenna_gain.a1;
+	b43_ppr_add(dev, nphy->tx_pwr_max_ppr, -hw_gain);
+
+	/* Make sure we didn't go too low */
+	b43_ppr_apply_min(dev, nphy->tx_pwr_max_ppr, INT_TO_Q52(8));
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
+	return B43_TXPWR_RES_DONE;
+}
+
 /**************************************************
  * N-PHY init
  **************************************************/
@@ -6158,6 +6214,7 @@ static int b43_nphy_op_allocate(struct b43_wldev *dev)
 	nphy = kzalloc(sizeof(*nphy), GFP_KERNEL);
 	if (!nphy)
 		return -ENOMEM;
+
 	dev->phy.n = nphy;
 
 	return 0;
@@ -6221,6 +6278,7 @@ static void b43_nphy_op_free(struct b43_wldev *dev)
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
 
+	kfree(nphy->tx_pwr_max_ppr);
 	kfree(nphy);
 	phy->n = NULL;
 }
@@ -6413,5 +6471,4 @@ const struct b43_phy_operations b43_phyops_n = {
 	.switch_channel		= b43_nphy_op_switch_channel,
 	.get_default_chan	= b43_nphy_op_get_default_chan,
 	.recalc_txpower		= b43_nphy_op_recalc_txpower,
-	.adjust_txpower		= b43_nphy_op_adjust_txpower,
 };
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 7fd5d5f..2f934da 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -963,6 +963,9 @@ struct b43_phy_n {
 	struct b43_phy_n_txpwrindex txpwrindex[2];
 	struct b43_phy_n_pwr_ctl_info pwr_ctl_info[2];
 	struct b43_chanspec txiqlocal_chanspec;
+	struct b43_ppr *tx_pwr_max_ppr;
+	u16 tx_pwr_last_recalc_freq;
+	int tx_pwr_last_recalc_limit;
 
 	u8 txrx_chain;
 	u16 tx_rx_cal_phy_saveregs[11];
-- 
1.8.4.5

