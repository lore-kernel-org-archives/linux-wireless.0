Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54143 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbaBYNtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:49:22 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0MMXVC-1WJugg048U-008K5O for
 <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 14:49:20 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 2/7] ath9k_htc: use ath9k_cmn_init_channels_rates
Date: Tue, 25 Feb 2014 14:48:51 +0100
Message-Id: <1393336136-31069-3-git-send-email-linux@rempel-privat.de> (sfid-20140225_144925_584367_5706FEC9)
In-Reply-To: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
References: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and ath_common sbands.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 123 ++------------------------
 2 files changed, 6 insertions(+), 118 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ba83f58..3baf9ce 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -487,7 +487,6 @@ struct ath9k_htc_priv {
 	unsigned long op_flags;
 
 	struct ath9k_hw_cal_data caldata;
-	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 
 	spinlock_t beacon_lock;
 	struct htc_beacon_config cur_beacon_conf;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 8d0b9bc..752586d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -38,93 +38,6 @@ static int ath9k_ps_enable;
 module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
 MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
 
-#define CHAN2G(_freq, _idx)  { \
-	.center_freq = (_freq), \
-	.hw_value = (_idx), \
-	.max_power = 20, \
-}
-
-#define CHAN5G(_freq, _idx) { \
-	.band = IEEE80211_BAND_5GHZ, \
-	.center_freq = (_freq), \
-	.hw_value = (_idx), \
-	.max_power = 20, \
-}
-
-static struct ieee80211_channel ath9k_2ghz_channels[] = {
-	CHAN2G(2412, 0), /* Channel 1 */
-	CHAN2G(2417, 1), /* Channel 2 */
-	CHAN2G(2422, 2), /* Channel 3 */
-	CHAN2G(2427, 3), /* Channel 4 */
-	CHAN2G(2432, 4), /* Channel 5 */
-	CHAN2G(2437, 5), /* Channel 6 */
-	CHAN2G(2442, 6), /* Channel 7 */
-	CHAN2G(2447, 7), /* Channel 8 */
-	CHAN2G(2452, 8), /* Channel 9 */
-	CHAN2G(2457, 9), /* Channel 10 */
-	CHAN2G(2462, 10), /* Channel 11 */
-	CHAN2G(2467, 11), /* Channel 12 */
-	CHAN2G(2472, 12), /* Channel 13 */
-	CHAN2G(2484, 13), /* Channel 14 */
-};
-
-static struct ieee80211_channel ath9k_5ghz_channels[] = {
-	/* _We_ call this UNII 1 */
-	CHAN5G(5180, 14), /* Channel 36 */
-	CHAN5G(5200, 15), /* Channel 40 */
-	CHAN5G(5220, 16), /* Channel 44 */
-	CHAN5G(5240, 17), /* Channel 48 */
-	/* _We_ call this UNII 2 */
-	CHAN5G(5260, 18), /* Channel 52 */
-	CHAN5G(5280, 19), /* Channel 56 */
-	CHAN5G(5300, 20), /* Channel 60 */
-	CHAN5G(5320, 21), /* Channel 64 */
-	/* _We_ call this "Middle band" */
-	CHAN5G(5500, 22), /* Channel 100 */
-	CHAN5G(5520, 23), /* Channel 104 */
-	CHAN5G(5540, 24), /* Channel 108 */
-	CHAN5G(5560, 25), /* Channel 112 */
-	CHAN5G(5580, 26), /* Channel 116 */
-	CHAN5G(5600, 27), /* Channel 120 */
-	CHAN5G(5620, 28), /* Channel 124 */
-	CHAN5G(5640, 29), /* Channel 128 */
-	CHAN5G(5660, 30), /* Channel 132 */
-	CHAN5G(5680, 31), /* Channel 136 */
-	CHAN5G(5700, 32), /* Channel 140 */
-	/* _We_ call this UNII 3 */
-	CHAN5G(5745, 33), /* Channel 149 */
-	CHAN5G(5765, 34), /* Channel 153 */
-	CHAN5G(5785, 35), /* Channel 157 */
-	CHAN5G(5805, 36), /* Channel 161 */
-	CHAN5G(5825, 37), /* Channel 165 */
-};
-
-/* Atheros hardware rate code addition for short premble */
-#define SHPCHECK(__hw_rate, __flags) \
-	((__flags & IEEE80211_RATE_SHORT_PREAMBLE) ? (__hw_rate | 0x04) : 0)
-
-#define RATE(_bitrate, _hw_rate, _flags) {		\
-	.bitrate	= (_bitrate),			\
-	.flags		= (_flags),			\
-	.hw_value	= (_hw_rate),			\
-	.hw_value_short = (SHPCHECK(_hw_rate, _flags))	\
-}
-
-static struct ieee80211_rate ath9k_legacy_rates[] = {
-	RATE(10, 0x1b, 0),
-	RATE(20, 0x1a, IEEE80211_RATE_SHORT_PREAMBLE), /* shortp : 0x1e */
-	RATE(55, 0x19, IEEE80211_RATE_SHORT_PREAMBLE), /* shortp: 0x1d */
-	RATE(110, 0x18, IEEE80211_RATE_SHORT_PREAMBLE), /* short: 0x1c */
-	RATE(60, 0x0b, 0),
-	RATE(90, 0x0f, 0),
-	RATE(120, 0x0a, 0),
-	RATE(180, 0x0e, 0),
-	RATE(240, 0x09, 0),
-	RATE(360, 0x0d, 0),
-	RATE(480, 0x08, 0),
-	RATE(540, 0x0c, 0),
-};
-
 #ifdef CONFIG_MAC80211_LEDS
 static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] = {
 	{ .throughput = 0 * 1024, .blink_time = 334 },
@@ -580,31 +493,6 @@ err:
 	return -EINVAL;
 }
 
-static void ath9k_init_channels_rates(struct ath9k_htc_priv *priv)
-{
-	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
-		priv->sbands[IEEE80211_BAND_2GHZ].channels =
-			ath9k_2ghz_channels;
-		priv->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-		priv->sbands[IEEE80211_BAND_2GHZ].n_channels =
-			ARRAY_SIZE(ath9k_2ghz_channels);
-		priv->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
-		priv->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
-			ARRAY_SIZE(ath9k_legacy_rates);
-	}
-
-	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ) {
-		priv->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_channels;
-		priv->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
-		priv->sbands[IEEE80211_BAND_5GHZ].n_channels =
-			ARRAY_SIZE(ath9k_5ghz_channels);
-		priv->sbands[IEEE80211_BAND_5GHZ].bitrates =
-			ath9k_legacy_rates + 4;
-		priv->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
-			ARRAY_SIZE(ath9k_legacy_rates) - 4;
-	}
-}
-
 static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
@@ -629,6 +517,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	if (!ah)
 		return -ENOMEM;
 
+	ah->dev = priv->dev;
 	ah->hw_version.devid = devid;
 	ah->hw_version.usbdev = drv_info;
 	ah->ah_flags |= AH_USE_EEPROM;
@@ -685,8 +574,8 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	for (i = 0; i < ATH9K_HTC_MAX_BCN_VIF; i++)
 		priv->cur_beacon_conf.bslot[i] = NULL;
 
+	ath9k_cmn_init_channels_rates(common);
 	ath9k_cmn_init_crypto(ah);
-	ath9k_init_channels_rates(priv);
 	ath9k_init_misc(priv);
 	ath9k_htc_init_btcoex(priv, product);
 
@@ -766,18 +655,18 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&priv->sbands[IEEE80211_BAND_2GHZ];
+			&common->sbands[IEEE80211_BAND_2GHZ];
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&priv->sbands[IEEE80211_BAND_5GHZ];
+			&common->sbands[IEEE80211_BAND_5GHZ];
 
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 			setup_ht_cap(priv,
-				     &priv->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+				     &common->sbands[IEEE80211_BAND_2GHZ].ht_cap);
 		if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
 			setup_ht_cap(priv,
-				     &priv->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+				     &common->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
 	pBase = ath9k_htc_get_eeprom_base(priv);
-- 
1.9.0

