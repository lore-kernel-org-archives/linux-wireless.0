Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:53802 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0ADU6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:58:43 -0500
Date: Mon, 4 Jan 2010 21:58:40 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 14/14] mwl8k: pass GET_HW_SPEC capability bitmask up the stack
Message-ID: <20100104205840.GN1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables HT association and AMPDU in the receive direction for
STA firmware images on hardware that supports it.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   64 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 887ce0f..a048636 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1578,6 +1578,68 @@ struct mwl8k_cmd_get_hw_spec_sta {
 	__le32 total_rxd;
 } __attribute__((packed));
 
+#define MWL8K_CAP_MAX_AMSDU		0x20000000
+#define MWL8K_CAP_GREENFIELD		0x08000000
+#define MWL8K_CAP_AMPDU			0x04000000
+#define MWL8K_CAP_RX_STBC		0x01000000
+#define MWL8K_CAP_TX_STBC		0x00800000
+#define MWL8K_CAP_SHORTGI_40MHZ		0x00400000
+#define MWL8K_CAP_SHORTGI_20MHZ		0x00200000
+#define MWL8K_CAP_RX_ANTENNA_MASK	0x000e0000
+#define MWL8K_CAP_TX_ANTENNA_MASK	0x0001c000
+#define MWL8K_CAP_DELAY_BA		0x00003000
+#define MWL8K_CAP_MIMO			0x00000200
+#define MWL8K_CAP_40MHZ			0x00000100
+
+static void mwl8k_set_ht_caps(struct ieee80211_hw *hw, u32 cap)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	int rx_streams;
+	int tx_streams;
+
+	priv->band.ht_cap.ht_supported = 1;
+
+	if (cap & MWL8K_CAP_MAX_AMSDU)
+		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_MAX_AMSDU;
+	if (cap & MWL8K_CAP_GREENFIELD)
+		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_GRN_FLD;
+	if (cap & MWL8K_CAP_AMPDU) {
+		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+		priv->band.ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+		priv->band.ht_cap.ampdu_density =
+				IEEE80211_HT_MPDU_DENSITY_NONE;
+	}
+	if (cap & MWL8K_CAP_RX_STBC)
+		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_RX_STBC;
+	if (cap & MWL8K_CAP_TX_STBC)
+		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_TX_STBC;
+	if (cap & MWL8K_CAP_SHORTGI_40MHZ)
+		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
+	if (cap & MWL8K_CAP_SHORTGI_20MHZ)
+		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
+	if (cap & MWL8K_CAP_DELAY_BA)
+		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_DELAY_BA;
+	if (cap & MWL8K_CAP_40MHZ)
+		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+
+	rx_streams = hweight32(cap & MWL8K_CAP_RX_ANTENNA_MASK);
+	tx_streams = hweight32(cap & MWL8K_CAP_TX_ANTENNA_MASK);
+
+	priv->band.ht_cap.mcs.rx_mask[0] = 0xff;
+	if (rx_streams >= 2)
+		priv->band.ht_cap.mcs.rx_mask[1] = 0xff;
+	if (rx_streams >= 3)
+		priv->band.ht_cap.mcs.rx_mask[2] = 0xff;
+	priv->band.ht_cap.mcs.rx_mask[4] = 0x01;
+	priv->band.ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+
+	if (rx_streams != tx_streams) {
+		priv->band.ht_cap.mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
+		priv->band.ht_cap.mcs.tx_params |= (tx_streams - 1) <<
+				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
+	}
+}
+
 static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
@@ -1608,6 +1670,8 @@ static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
 		priv->num_mcaddrs = le16_to_cpu(cmd->num_mcaddrs);
 		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
 		priv->hw_rev = cmd->hw_rev;
+		if (cmd->caps & cpu_to_le32(MWL8K_CAP_MIMO))
+			mwl8k_set_ht_caps(hw, le32_to_cpu(cmd->caps));
 	}
 
 	kfree(cmd);
-- 
1.5.6.4
