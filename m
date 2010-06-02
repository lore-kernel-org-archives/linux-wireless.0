Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57553 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0FBKWi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 06:22:38 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 03:22:38 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19462.12598.844782.312969@gargle.gargle.HOWL>
Date: Wed, 2 Jun 2010 15:53:50 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/8] ath9k_htc: Setup 5GHz channels
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR7010 is dual-band. Setup the channels and rateset
for 5GHz band.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   55 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 +-
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index acd9cb9..cda3041 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -34,6 +34,13 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 	.max_power = 20, \
 }
 
+#define CHAN5G(_freq, _idx) { \
+	.band = IEEE80211_BAND_5GHZ, \
+	.center_freq = (_freq), \
+	.hw_value = (_idx), \
+	.max_power = 20, \
+}
+
 static struct ieee80211_channel ath9k_2ghz_channels[] = {
 	CHAN2G(2412, 0), /* Channel 1 */
 	CHAN2G(2417, 1), /* Channel 2 */
@@ -51,6 +58,37 @@ static struct ieee80211_channel ath9k_2ghz_channels[] = {
 	CHAN2G(2484, 13), /* Channel 14 */
 };
 
+static struct ieee80211_channel ath9k_5ghz_channels[] = {
+	/* _We_ call this UNII 1 */
+	CHAN5G(5180, 14), /* Channel 36 */
+	CHAN5G(5200, 15), /* Channel 40 */
+	CHAN5G(5220, 16), /* Channel 44 */
+	CHAN5G(5240, 17), /* Channel 48 */
+	/* _We_ call this UNII 2 */
+	CHAN5G(5260, 18), /* Channel 52 */
+	CHAN5G(5280, 19), /* Channel 56 */
+	CHAN5G(5300, 20), /* Channel 60 */
+	CHAN5G(5320, 21), /* Channel 64 */
+	/* _We_ call this "Middle band" */
+	CHAN5G(5500, 22), /* Channel 100 */
+	CHAN5G(5520, 23), /* Channel 104 */
+	CHAN5G(5540, 24), /* Channel 108 */
+	CHAN5G(5560, 25), /* Channel 112 */
+	CHAN5G(5580, 26), /* Channel 116 */
+	CHAN5G(5600, 27), /* Channel 120 */
+	CHAN5G(5620, 28), /* Channel 124 */
+	CHAN5G(5640, 29), /* Channel 128 */
+	CHAN5G(5660, 30), /* Channel 132 */
+	CHAN5G(5680, 31), /* Channel 136 */
+	CHAN5G(5700, 32), /* Channel 140 */
+	/* _We_ call this UNII 3 */
+	CHAN5G(5745, 33), /* Channel 149 */
+	CHAN5G(5765, 34), /* Channel 153 */
+	CHAN5G(5785, 35), /* Channel 157 */
+	CHAN5G(5805, 36), /* Channel 161 */
+	CHAN5G(5825, 37), /* Channel 165 */
+};
+
 /* Atheros hardware rate code addition for short premble */
 #define SHPCHECK(__hw_rate, __flags) \
 	((__flags & IEEE80211_RATE_SHORT_PREAMBLE) ? (__hw_rate | 0x04) : 0)
@@ -552,6 +590,17 @@ static void ath9k_init_channels_rates(struct ath9k_htc_priv *priv)
 		priv->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
 			ARRAY_SIZE(ath9k_legacy_rates);
 	}
+
+	if (test_bit(ATH9K_MODE_11A, priv->ah->caps.wireless_modes)) {
+		priv->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_channels;
+		priv->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
+		priv->sbands[IEEE80211_BAND_5GHZ].n_channels =
+			ARRAY_SIZE(ath9k_5ghz_channels);
+		priv->sbands[IEEE80211_BAND_5GHZ].bitrates =
+			ath9k_legacy_rates + 4;
+		priv->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
+			ARRAY_SIZE(ath9k_legacy_rates) - 4;
+	}
 }
 
 static void ath9k_init_misc(struct ath9k_htc_priv *priv)
@@ -683,11 +732,17 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	if (test_bit(ATH9K_MODE_11G, priv->ah->caps.wireless_modes))
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&priv->sbands[IEEE80211_BAND_2GHZ];
+	if (test_bit(ATH9K_MODE_11A, priv->ah->caps.wireless_modes))
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&priv->sbands[IEEE80211_BAND_5GHZ];
 
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		if (test_bit(ATH9K_MODE_11G, priv->ah->caps.wireless_modes))
 			setup_ht_cap(priv,
 				     &priv->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+		if (test_bit(ATH9K_MODE_11A, priv->ah->caps.wireless_modes))
+			setup_ht_cap(priv,
+				     &priv->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index b7ce902..7aefbc6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -343,8 +343,7 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 	u32 caps = 0;
 	int i, j;
 
-	/* Only 2GHz is supported */
-	sband = priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+	sband = priv->hw->wiphy->bands[priv->hw->conf.channel->band];
 
 	for (i = 0, j = 0; i < sband->n_bitrates; i++) {
 		if (sta->supp_rates[sband->band] & BIT(i)) {
-- 
1.7.1

