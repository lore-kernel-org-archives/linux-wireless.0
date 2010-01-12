Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58836 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0ALMsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:48:18 -0500
Date: Tue, 12 Jan 2010 13:48:17 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 07/17] mwl8k: move responsibility for initialising wiphy bands to GET_HW_SPEC
Message-ID: <20100112124817.GW1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So that we can make 2.4 GHz and 5 GHz band registration conditional
on the capability bitmask returned by the firmware.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   35 ++++++++++++++++++++++++-----------
 1 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 37cbfbf..a17111f 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1558,6 +1558,28 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 }
 
 /*
+ * Setup code shared between STA and AP firmware images.
+ */
+static void mwl8k_setup_2ghz_band(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+
+	BUILD_BUG_ON(sizeof(priv->channels_24) != sizeof(mwl8k_channels_24));
+	memcpy(priv->channels_24, mwl8k_channels_24, sizeof(mwl8k_channels_24));
+
+	BUILD_BUG_ON(sizeof(priv->rates_24) != sizeof(mwl8k_rates_24));
+	memcpy(priv->rates_24, mwl8k_rates_24, sizeof(mwl8k_rates_24));
+
+	priv->band_24.band = IEEE80211_BAND_2GHZ;
+	priv->band_24.channels = priv->channels_24;
+	priv->band_24.n_channels = ARRAY_SIZE(mwl8k_channels_24);
+	priv->band_24.bitrates = priv->rates_24;
+	priv->band_24.n_bitrates = ARRAY_SIZE(mwl8k_rates_24);
+
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band_24;
+}
+
+/*
  * CMD_GET_HW_SPEC (STA version).
  */
 struct mwl8k_cmd_get_hw_spec_sta {
@@ -1671,6 +1693,7 @@ static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
 		priv->num_mcaddrs = le16_to_cpu(cmd->num_mcaddrs);
 		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
 		priv->hw_rev = cmd->hw_rev;
+		mwl8k_setup_2ghz_band(hw);
 		if (cmd->caps & cpu_to_le32(MWL8K_CAP_MIMO))
 			mwl8k_set_ht_caps(hw, le32_to_cpu(cmd->caps));
 	}
@@ -1726,6 +1749,7 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 		priv->num_mcaddrs = le16_to_cpu(cmd->num_mcaddrs);
 		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
 		priv->hw_rev = cmd->hw_rev;
+		mwl8k_setup_2ghz_band(hw);
 
 		off = le32_to_cpu(cmd->wcbbase0) & 0xffff;
 		iowrite32(cpu_to_le32(priv->txq[0].txd_dma), priv->sram + off);
@@ -3853,17 +3877,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv->pending_tx_pkts = 0;
 
 
-	memcpy(priv->channels_24, mwl8k_channels_24, sizeof(mwl8k_channels_24));
-	priv->band_24.band = IEEE80211_BAND_2GHZ;
-	priv->band_24.channels = priv->channels_24;
-	priv->band_24.n_channels = ARRAY_SIZE(mwl8k_channels_24);
-	priv->band_24.bitrates = priv->rates_24;
-	priv->band_24.n_bitrates = ARRAY_SIZE(mwl8k_rates_24);
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band_24;
-
-	BUILD_BUG_ON(sizeof(priv->rates_24) != sizeof(mwl8k_rates_24));
-	memcpy(priv->rates_24, mwl8k_rates_24, sizeof(mwl8k_rates_24));
-
 	/*
 	 * Extra headroom is the size of the required DMA header
 	 * minus the size of the smallest 802.11 frame (CTS frame).
-- 
1.5.6.4
