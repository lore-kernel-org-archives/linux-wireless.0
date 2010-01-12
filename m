Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58834 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0ALMsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:48:07 -0500
Date: Tue, 12 Jan 2010 13:48:04 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 06/17] mwl8k: rename 2.4 GHz band/channels/rates related variables from FOO to FOO_24
Message-ID: <20100112124804.GV1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To prepare for adding 5 GHz band/channels/rates.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   76 ++++++++++++++++++++---------------------
 1 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 76da583..37cbfbf 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -141,6 +141,9 @@ struct mwl8k_priv {
 	/* hardware/firmware parameters */
 	bool ap_fw;
 	struct rxd_ops *rxd_ops;
+	struct ieee80211_supported_band band_24;
+	struct ieee80211_channel channels_24[14];
+	struct ieee80211_rate rates_24[14];
 
 	/* firmware access */
 	struct mutex fw_mutex;
@@ -173,11 +176,6 @@ struct mwl8k_priv {
 	struct mwl8k_rx_queue rxq[MWL8K_RX_QUEUES];
 	struct mwl8k_tx_queue txq[MWL8K_TX_QUEUES];
 
-	/* PHY parameters */
-	struct ieee80211_supported_band band;
-	struct ieee80211_channel channels[14];
-	struct ieee80211_rate rates[14];
-
 	bool radio_on;
 	bool radio_short_preamble;
 	bool sniffer_enabled;
@@ -220,7 +218,7 @@ struct mwl8k_sta {
 };
 #define MWL8K_STA(_sta) ((struct mwl8k_sta *)&((_sta)->drv_priv))
 
-static const struct ieee80211_channel mwl8k_channels[] = {
+static const struct ieee80211_channel mwl8k_channels_24[] = {
 	{ .center_freq = 2412, .hw_value = 1, },
 	{ .center_freq = 2417, .hw_value = 2, },
 	{ .center_freq = 2422, .hw_value = 3, },
@@ -237,7 +235,7 @@ static const struct ieee80211_channel mwl8k_channels[] = {
 	{ .center_freq = 2484, .hw_value = 14, },
 };
 
-static const struct ieee80211_rate mwl8k_rates[] = {
+static const struct ieee80211_rate mwl8k_rates_24[] = {
 	{ .bitrate = 10, .hw_value = 2, },
 	{ .bitrate = 20, .hw_value = 4, },
 	{ .bitrate = 55, .hw_value = 11, },
@@ -731,8 +729,8 @@ mwl8k_rxd_8366_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 	} else {
 		int i;
 
-		for (i = 0; i < ARRAY_SIZE(mwl8k_rates); i++) {
-			if (mwl8k_rates[i].hw_value == rxd->rate) {
+		for (i = 0; i < ARRAY_SIZE(mwl8k_rates_24); i++) {
+			if (mwl8k_rates_24[i].hw_value == rxd->rate) {
 				status->rate_idx = i;
 				break;
 			}
@@ -1597,48 +1595,48 @@ struct mwl8k_cmd_get_hw_spec_sta {
 static void mwl8k_set_ht_caps(struct ieee80211_hw *hw, u32 cap)
 {
 	struct mwl8k_priv *priv = hw->priv;
+	struct ieee80211_supported_band *band = &priv->band_24;
 	int rx_streams;
 	int tx_streams;
 
-	priv->band.ht_cap.ht_supported = 1;
+	band->ht_cap.ht_supported = 1;
 
 	if (cap & MWL8K_CAP_MAX_AMSDU)
-		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_MAX_AMSDU;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 	if (cap & MWL8K_CAP_GREENFIELD)
-		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_GRN_FLD;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_GRN_FLD;
 	if (cap & MWL8K_CAP_AMPDU) {
 		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
-		priv->band.ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
-		priv->band.ht_cap.ampdu_density =
-				IEEE80211_HT_MPDU_DENSITY_NONE;
+		band->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+		band->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
 	}
 	if (cap & MWL8K_CAP_RX_STBC)
-		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_RX_STBC;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_RX_STBC;
 	if (cap & MWL8K_CAP_TX_STBC)
-		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_TX_STBC;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_TX_STBC;
 	if (cap & MWL8K_CAP_SHORTGI_40MHZ)
-		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
 	if (cap & MWL8K_CAP_SHORTGI_20MHZ)
-		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
 	if (cap & MWL8K_CAP_DELAY_BA)
-		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_DELAY_BA;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_DELAY_BA;
 	if (cap & MWL8K_CAP_40MHZ)
-		priv->band.ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
 	rx_streams = hweight32(cap & MWL8K_CAP_RX_ANTENNA_MASK);
 	tx_streams = hweight32(cap & MWL8K_CAP_TX_ANTENNA_MASK);
 
-	priv->band.ht_cap.mcs.rx_mask[0] = 0xff;
+	band->ht_cap.mcs.rx_mask[0] = 0xff;
 	if (rx_streams >= 2)
-		priv->band.ht_cap.mcs.rx_mask[1] = 0xff;
+		band->ht_cap.mcs.rx_mask[1] = 0xff;
 	if (rx_streams >= 3)
-		priv->band.ht_cap.mcs.rx_mask[2] = 0xff;
-	priv->band.ht_cap.mcs.rx_mask[4] = 0x01;
-	priv->band.ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+		band->ht_cap.mcs.rx_mask[2] = 0xff;
+	band->ht_cap.mcs.rx_mask[4] = 0x01;
+	band->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 
 	if (rx_streams != tx_streams) {
-		priv->band.ht_cap.mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
-		priv->band.ht_cap.mcs.tx_params |= (tx_streams - 1) <<
+		band->ht_cap.mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
+		band->ht_cap.mcs.tx_params |= (tx_streams - 1) <<
 				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
 	}
 }
@@ -2192,7 +2190,7 @@ static void legacy_rate_mask_to_array(u8 *rates, u32 mask)
 
 	for (i = 0, j = 0; i < 14; i++) {
 		if (mask & (1 << i))
-			rates[j++] = mwl8k_rates[i].hw_value;
+			rates[j++] = mwl8k_rates_24[i].hw_value;
 	}
 }
 
@@ -3347,7 +3345,7 @@ mwl8k_bss_info_changed_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		 * beacons will always go out at 1 Mb/s).
 		 */
 		idx = ffs(vif->bss_conf.basic_rates);
-		rate = idx ? mwl8k_rates[idx - 1].hw_value : 2;
+		rate = idx ? mwl8k_rates_24[idx - 1].hw_value : 2;
 
 		mwl8k_cmd_use_fixed_rate_ap(hw, rate, rate);
 	}
@@ -3855,16 +3853,16 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv->pending_tx_pkts = 0;
 
 
-	memcpy(priv->channels, mwl8k_channels, sizeof(mwl8k_channels));
-	priv->band.band = IEEE80211_BAND_2GHZ;
-	priv->band.channels = priv->channels;
-	priv->band.n_channels = ARRAY_SIZE(mwl8k_channels);
-	priv->band.bitrates = priv->rates;
-	priv->band.n_bitrates = ARRAY_SIZE(mwl8k_rates);
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	memcpy(priv->channels_24, mwl8k_channels_24, sizeof(mwl8k_channels_24));
+	priv->band_24.band = IEEE80211_BAND_2GHZ;
+	priv->band_24.channels = priv->channels_24;
+	priv->band_24.n_channels = ARRAY_SIZE(mwl8k_channels_24);
+	priv->band_24.bitrates = priv->rates_24;
+	priv->band_24.n_bitrates = ARRAY_SIZE(mwl8k_rates_24);
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band_24;
 
-	BUILD_BUG_ON(sizeof(priv->rates) != sizeof(mwl8k_rates));
-	memcpy(priv->rates, mwl8k_rates, sizeof(mwl8k_rates));
+	BUILD_BUG_ON(sizeof(priv->rates_24) != sizeof(mwl8k_rates_24));
+	memcpy(priv->rates_24, mwl8k_rates_24, sizeof(mwl8k_rates_24));
 
 	/*
 	 * Extra headroom is the size of the required DMA header
-- 
1.5.6.4
