Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40256 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab3EOOTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:35 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 13/18] ath9k: add and use 5/10 MHz bitrate tables
Date: Wed, 15 May 2013 16:19:04 +0200
Message-Id: <1368627549-22518-14-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_161949_685840_8F5B0465)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a reduced bandwidth mode is enabled, the according bitrate tables
must be used instead of the standard tables. This patch adds these
bitrate tables and selects the appropriate table.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   13 ++++++-
 drivers/net/wireless/ath/ath9k/init.c   |   63 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/rc.c     |    9 +++++
 drivers/net/wireless/ath/ath9k/recv.c   |   13 +++++--
 drivers/net/wireless/ath/ath9k/xmit.c   |   14 ++++++-
 5 files changed, 90 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 2ff570f..56383e5 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -76,13 +76,22 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_tx_info info;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
 	u8 chainmask = ah->txchainmask;
 	u8 rate = 0;
+	int n_bitrates;
 
 	sband = &sc->sbands[common->hw->conf.chandef.chan->band];
-	rate = sband->bitrates[rateidx].hw_value;
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   common->hw->conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
+
+	rate = bitrates[rateidx].hw_value;
 	if (vif->bss_conf.use_short_preamble)
-		rate |= sband->bitrates[rateidx].hw_value_short;
+		rate |= bitrates[rateidx].hw_value_short;
 
 	memset(&info, 0, sizeof(info));
 	info.pkt_len = skb->len + FCS_LEN;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 5921194..919d4c2 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -155,6 +155,30 @@ static struct ieee80211_rate ath9k_legacy_rates[] = {
 	RATE(540, 0x0c, 0),
 };
 
+static struct ieee80211_rate ath9k_legacy_rates_half[] = {
+	RATE(30, 0x0b, 0),
+	RATE(45, 0x0f, 0),
+	RATE(60, 0x0a, 0),
+	RATE(90, 0x0e, 0),
+	RATE(120, 0x09, 0),
+	RATE(180, 0x0d, 0),
+	RATE(240, 0x08, 0),
+	RATE(270, 0x0c, 0),
+};
+
+static struct ieee80211_rate ath9k_legacy_rates_quarter[] = {
+	RATE(15, 0x0b, 0),
+	RATE(22, 0x0f, 0), /* actually 22.5 */
+	RATE(30, 0x0a, 0),
+	RATE(45, 0x0e, 0),
+	RATE(60, 0x09, 0),
+	RATE(90, 0x0d, 0),
+	RATE(120, 0x08, 0),
+	RATE(135, 0x0c, 0),
+};
+
+
+
 #ifdef CONFIG_MAC80211_LEDS
 static const struct ieee80211_tpt_blink ath9k_tpt_blink[] = {
 	{ .throughput = 0 * 1024, .blink_time = 334 },
@@ -442,6 +466,7 @@ static int ath9k_init_queues(struct ath_softc *sc)
 static int ath9k_init_channels_rates(struct ath_softc *sc)
 {
 	void *channels;
+	struct ieee80211_supported_band *sband;
 
 	BUILD_BUG_ON(ARRAY_SIZE(ath9k_2ghz_chantable) +
 		     ARRAY_SIZE(ath9k_5ghz_chantable) !=
@@ -455,13 +480,18 @@ static int ath9k_init_channels_rates(struct ath_softc *sc)
 
 		memcpy(channels, ath9k_2ghz_chantable,
 		       sizeof(ath9k_2ghz_chantable));
-		sc->sbands[IEEE80211_BAND_2GHZ].channels = channels;
-		sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-		sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
-			ARRAY_SIZE(ath9k_2ghz_chantable);
-		sc->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
-		sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
-			ARRAY_SIZE(ath9k_legacy_rates);
+		sband = &sc->sbands[IEEE80211_BAND_2GHZ];
+		sband->channels = channels;
+		sband->band = IEEE80211_BAND_2GHZ;
+		sband->n_channels = ARRAY_SIZE(ath9k_2ghz_chantable);
+		sband->bitrates = ath9k_legacy_rates;
+		sband->n_bitrates = ARRAY_SIZE(ath9k_legacy_rates);
+		sband->bitrates_half = ath9k_legacy_rates_half;
+		sband->n_bitrates_half = ARRAY_SIZE(ath9k_legacy_rates_half);
+		sband->bitrates_quarter = ath9k_legacy_rates_quarter;
+		sband->n_bitrates_quarter =
+			ARRAY_SIZE(ath9k_legacy_rates_quarter);
+
 	}
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ) {
@@ -472,14 +502,17 @@ static int ath9k_init_channels_rates(struct ath_softc *sc)
 
 		memcpy(channels, ath9k_5ghz_chantable,
 		       sizeof(ath9k_5ghz_chantable));
-		sc->sbands[IEEE80211_BAND_5GHZ].channels = channels;
-		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
-		sc->sbands[IEEE80211_BAND_5GHZ].n_channels =
-			ARRAY_SIZE(ath9k_5ghz_chantable);
-		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
-			ath9k_legacy_rates + 4;
-		sc->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
-			ARRAY_SIZE(ath9k_legacy_rates) - 4;
+		sband = &sc->sbands[IEEE80211_BAND_5GHZ];
+		sband->channels = channels;
+		sband->band = IEEE80211_BAND_5GHZ;
+		sband->n_channels = ARRAY_SIZE(ath9k_5ghz_chantable);
+		sband->bitrates = ath9k_legacy_rates + 4;
+		sband->n_bitrates = ARRAY_SIZE(ath9k_legacy_rates) - 4;
+		sband->bitrates_half = ath9k_legacy_rates_half;
+		sband->n_bitrates_half = ARRAY_SIZE(ath9k_legacy_rates_half);
+		sband->bitrates_quarter = ath9k_legacy_rates_quarter;
+		sband->n_bitrates_quarter =
+			ARRAY_SIZE(ath9k_legacy_rates_quarter);
 	}
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ed57d57..0559ac6 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1283,8 +1283,17 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	struct ath_softc *sc = priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	int i, j = 0;
 
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   sc->hw->conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
+
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if (sta->supp_rates[sband->band] & BIT(i)) {
 			ath_rc_priv->neg_rates.rs_rates[j]
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 8be2b5d..9e7c929 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -858,6 +858,8 @@ static int ath9k_process_rate(struct ath_common *common,
 			      struct ieee80211_rx_status *rxs)
 {
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	int n_bitrates;
 	enum ieee80211_band band;
 	unsigned int i = 0;
 	struct ath_softc __maybe_unused *sc = common->priv;
@@ -865,6 +867,11 @@ static int ath9k_process_rate(struct ath_common *common,
 	band = hw->conf.chandef.chan->band;
 	sband = hw->wiphy->bands[band];
 
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   hw->conf.chandef.width,
+					   &bitrates, &n_bitrates)))
+		return 0;
+
 	if (rx_stats->rs_rate & 0x80) {
 		/* HT rate */
 		rxs->flag |= RX_FLAG_HT;
@@ -876,12 +883,12 @@ static int ath9k_process_rate(struct ath_common *common,
 		return 0;
 	}
 
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sband->bitrates[i].hw_value == rx_stats->rs_rate) {
+	for (i = 0; i < n_bitrates; i++) {
+		if (bitrates[i].hw_value == rx_stats->rs_rate) {
 			rxs->rate_idx = i;
 			return 0;
 		}
-		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
+		if (bitrates[i].hw_value_short == rx_stats->rs_rate) {
 			rxs->flag |= RX_FLAG_SHORTPRE;
 			rxs->rate_idx = i;
 			return 0;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index eab0fcb..7062386 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -998,15 +998,25 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
 	const struct ieee80211_rate *rate;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
 	struct ieee80211_hdr *hdr;
 	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
-	int i;
+	int i, n_bitrates;
 	u8 rix = 0;
 
 	skb = bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
 	rates = bf->rates;
 	hdr = (struct ieee80211_hdr *)skb->data;
+	sband = &sc->sbands[tx_info->band];
+
+	if (WARN_ON(ieee80211_get_bitrates(sband,
+					   sc->hw->conf.chandef.width,
+					   &bitrates, &n_bitrates))) {
+		bitrates = sband->bitrates;
+		n_bitrates = sband->n_bitrates;
+	}
 
 	/* set dur_update_en for l-sig computation except for PS-Poll frames */
 	info->dur_update = !ieee80211_is_pspoll(hdr->frame_control);
@@ -1052,7 +1062,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 		}
 
 		/* legacy rates */
-		rate = &sc->sbands[tx_info->band].bitrates[rates[i].idx];
+		rate = &bitrates[rates[i].idx];
 		if ((tx_info->band == IEEE80211_BAND_2GHZ) &&
 		    !(rate->flags & IEEE80211_RATE_ERP_G))
 			phy = WLAN_RC_PHY_CCK;
-- 
1.7.10.4

