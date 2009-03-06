Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58095 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZCFFNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:13:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:13:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <j@w1.fi>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] mac80211_hwsim: add support for 5 GHz
Date: Thu, 5 Mar 2009 21:13:06 -0800
Message-ID: <1236316387-9718-1-git-send-email-lrodriguez@atheros.com> (sfid-20090306_061359_985690_52E6FD5B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ACME Inc. is now selling a dual band radio.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  138 ++++++++++++++++++++++++---------
 1 files changed, 102 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index fce49ba..d8716be 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -10,7 +10,6 @@
 /*
  * TODO:
  * - IBSS mode simulation (Beacon transmission with competition for "air time")
- * - IEEE 802.11a and 802.11n modes
  * - RX filtering based on filter configuration (data->rx_filter)
  */
 
@@ -86,22 +85,65 @@ static struct class *hwsim_class;
 
 static struct net_device *hwsim_mon; /* global monitor netdev */
 
+#define CHAN2G(_freq)  { \
+	.band = IEEE80211_BAND_2GHZ, \
+	.center_freq = (_freq), \
+	.hw_value = (_freq), \
+	.max_power = 20, \
+}
+
+#define CHAN5G(_freq) { \
+	.band = IEEE80211_BAND_5GHZ, \
+	.center_freq = (_freq), \
+	.hw_value = (_freq), \
+	.max_power = 20, \
+}
+
+static const struct ieee80211_channel hwsim_channels_2ghz[] = {
+	CHAN2G(2412), /* Channel 1 */
+	CHAN2G(2417), /* Channel 2 */
+	CHAN2G(2422), /* Channel 3 */
+	CHAN2G(2427), /* Channel 4 */
+	CHAN2G(2432), /* Channel 5 */
+	CHAN2G(2437), /* Channel 6 */
+	CHAN2G(2442), /* Channel 7 */
+	CHAN2G(2447), /* Channel 8 */
+	CHAN2G(2452), /* Channel 9 */
+	CHAN2G(2457), /* Channel 10 */
+	CHAN2G(2462), /* Channel 11 */
+	CHAN2G(2467), /* Channel 12 */
+	CHAN2G(2472), /* Channel 13 */
+	CHAN2G(2484), /* Channel 14 */
+};
 
-static const struct ieee80211_channel hwsim_channels[] = {
-	{ .center_freq = 2412 },
-	{ .center_freq = 2417 },
-	{ .center_freq = 2422 },
-	{ .center_freq = 2427 },
-	{ .center_freq = 2432 },
-	{ .center_freq = 2437 },
-	{ .center_freq = 2442 },
-	{ .center_freq = 2447 },
-	{ .center_freq = 2452 },
-	{ .center_freq = 2457 },
-	{ .center_freq = 2462 },
-	{ .center_freq = 2467 },
-	{ .center_freq = 2472 },
-	{ .center_freq = 2484 },
+static const struct ieee80211_channel hwsim_channels_5ghz[] = {
+	CHAN5G(5180), /* Channel 36 */
+	CHAN5G(5200), /* Channel 40 */
+	CHAN5G(5220), /* Channel 44 */
+	CHAN5G(5240), /* Channel 48 */
+
+	CHAN5G(5260), /* Channel 52 */
+	CHAN5G(5280), /* Channel 56 */
+	CHAN5G(5300), /* Channel 60 */
+	CHAN5G(5320), /* Channel 64 */
+
+	CHAN5G(5500), /* Channel 100 */
+	CHAN5G(5520), /* Channel 104 */
+	CHAN5G(5540), /* Channel 108 */
+	CHAN5G(5560), /* Channel 112 */
+	CHAN5G(5580), /* Channel 116 */
+	CHAN5G(5600), /* Channel 120 */
+	CHAN5G(5620), /* Channel 124 */
+	CHAN5G(5640), /* Channel 128 */
+	CHAN5G(5660), /* Channel 132 */
+	CHAN5G(5680), /* Channel 136 */
+	CHAN5G(5700), /* Channel 140 */
+
+	CHAN5G(5745), /* Channel 149 */
+	CHAN5G(5765), /* Channel 153 */
+	CHAN5G(5785), /* Channel 157 */
+	CHAN5G(5805), /* Channel 161 */
+	CHAN5G(5825), /* Channel 165 */
 };
 
 static const struct ieee80211_rate hwsim_rates[] = {
@@ -126,8 +168,9 @@ struct mac80211_hwsim_data {
 	struct list_head list;
 	struct ieee80211_hw *hw;
 	struct device *dev;
-	struct ieee80211_supported_band band;
-	struct ieee80211_channel channels[ARRAY_SIZE(hwsim_channels)];
+	struct ieee80211_supported_band bands[2];
+	struct ieee80211_channel channels_2ghz[ARRAY_SIZE(hwsim_channels_2ghz)];
+	struct ieee80211_channel channels_5ghz[ARRAY_SIZE(hwsim_channels_5ghz)];
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
 
 	struct ieee80211_channel *channel;
@@ -728,6 +771,7 @@ static int __init init_mac80211_hwsim(void)
 	u8 addr[ETH_ALEN];
 	struct mac80211_hwsim_data *data;
 	struct ieee80211_hw *hw;
+	enum ieee80211_band band;
 
 	if (radios < 1 || radios > 100)
 		return -EINVAL;
@@ -785,25 +829,47 @@ static int __init init_mac80211_hwsim(void)
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
 		hw->sta_data_size = sizeof(struct hwsim_sta_priv);
 
-		memcpy(data->channels, hwsim_channels, sizeof(hwsim_channels));
+		memcpy(data->channels_2ghz, hwsim_channels_2ghz,
+			sizeof(hwsim_channels_2ghz));
+		memcpy(data->channels_5ghz, hwsim_channels_5ghz,
+			sizeof(hwsim_channels_5ghz));
 		memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
-		data->band.channels = data->channels;
-		data->band.n_channels = ARRAY_SIZE(hwsim_channels);
-		data->band.bitrates = data->rates;
-		data->band.n_bitrates = ARRAY_SIZE(hwsim_rates);
-		data->band.ht_cap.ht_supported = true;
-		data->band.ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-			IEEE80211_HT_CAP_GRN_FLD |
-			IEEE80211_HT_CAP_SGI_40 |
-			IEEE80211_HT_CAP_DSSSCCK40;
-		data->band.ht_cap.ampdu_factor = 0x3;
-		data->band.ht_cap.ampdu_density = 0x6;
-		memset(&data->band.ht_cap.mcs, 0,
-		       sizeof(data->band.ht_cap.mcs));
-		data->band.ht_cap.mcs.rx_mask[0] = 0xff;
-		data->band.ht_cap.mcs.rx_mask[1] = 0xff;
-		data->band.ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &data->band;
+
+		for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
+			struct ieee80211_supported_band *sband = &data->bands[band];
+			switch (band) {
+			case IEEE80211_BAND_2GHZ:
+				sband->channels = data->channels_2ghz;
+				sband->n_channels =
+					ARRAY_SIZE(hwsim_channels_2ghz);
+				break;
+			case IEEE80211_BAND_5GHZ:
+				sband->channels = data->channels_5ghz;
+				sband->n_channels =
+					ARRAY_SIZE(hwsim_channels_5ghz);
+				break;
+			default:
+				break;
+			}
+
+			sband->bitrates = data->rates;
+			sband->n_bitrates = ARRAY_SIZE(hwsim_rates);
+
+			sband->ht_cap.ht_supported = true;
+			sband->ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+				IEEE80211_HT_CAP_GRN_FLD |
+				IEEE80211_HT_CAP_SGI_40 |
+				IEEE80211_HT_CAP_DSSSCCK40;
+			sband->ht_cap.ampdu_factor = 0x3;
+			sband->ht_cap.ampdu_density = 0x6;
+			memset(&sband->ht_cap.mcs, 0,
+			       sizeof(sband->ht_cap.mcs));
+			sband->ht_cap.mcs.rx_mask[0] = 0xff;
+			sband->ht_cap.mcs.rx_mask[1] = 0xff;
+			sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+
+			hw->wiphy->bands[band] = sband;
+		}
 
 		err = ieee80211_register_hw(hw);
 		if (err < 0) {
-- 
1.6.1.2.253.ga34a

