Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46825 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaBQNXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 08:23:14 -0500
Received: by mail-ee0-f41.google.com with SMTP id e51so6541849eek.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 05:23:13 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de, Rostislav Lisovy <lisovy@gmail.com>
Subject: [RFC 2/4] ath9k: Allow 5/10 MHz channel setting (for OCB)
Date: Mon, 17 Feb 2014 14:22:52 +0100
Message-Id: <1392643374-3545-3-git-send-email-lisovy@gmail.com> (sfid-20140217_142322_797493_87BD003A)
In-Reply-To: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
References: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  5 +++++
 drivers/net/wireless/ath/ath9k/hw.h           |  3 ++-
 drivers/net/wireless/ath/ath9k/init.c         | 20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c         |  6 ++++++
 drivers/net/wireless/ath/ath9k/xmit.c         |  6 ++++++
 drivers/net/wireless/ath/regd.c               |  9 ++++++---
 drivers/net/wireless/rtlwifi/regd.c           |  9 ++++++---
 7 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index c028df7..348864e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1095,6 +1095,11 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	rx_status->signal =  rxbuf->rxstatus.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
 	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
+	if (IS_CHAN_HALF_RATE(priv->ah->curchan))
+		rx_status->flag |= RX_FLAG_10MHZ;
+	else if (IS_CHAN_QUARTER_RATE(priv->ah->curchan))
+		rx_status->flag |= RX_FLAG_5MHZ;
+
 
 	return true;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a2c9a5d..88e44c7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -69,7 +69,7 @@
 
 #define ATH9K_RSSI_BAD			-128
 
-#define ATH9K_NUM_CHANNELS	38
+#define ATH9K_NUM_CHANNELS	54
 
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
@@ -422,6 +422,7 @@ struct ath9k_channel {
 
 #define IS_CHAN_HALF_RATE(_c) (!!((_c)->channelFlags & CHANNEL_HALF))
 #define IS_CHAN_QUARTER_RATE(_c) (!!((_c)->channelFlags & CHANNEL_QUARTER))
+
 #define IS_CHAN_A_FAST_CLOCK(_ah, _c)			\
 	(IS_CHAN_5GHZ(_c) && ((_ah)->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK))
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 710192e..7bad46f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -128,6 +128,26 @@ static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	CHAN5G(5785, 35), /* Channel 157 */
 	CHAN5G(5805, 36), /* Channel 161 */
 	CHAN5G(5825, 37), /* Channel 165 */
+
+	CHAN5G(5850, 38), /* Channel 170 */
+	/* ITA-G5B */
+	CHAN5G(5855, 39), /* Channel 171 */
+	CHAN5G(5860, 40), /* Channel 172 */
+	CHAN5G(5865, 41), /* Channel 173 */
+	CHAN5G(5870, 42), /* Channel 174 */
+	/* ITS-G5A */
+	CHAN5G(5875, 43), /* Channel 175 */
+	CHAN5G(5880, 44), /* Channel 176 */
+	CHAN5G(5885, 45), /* Channel 177 */
+	CHAN5G(5890, 46), /* Channel 178 */
+	CHAN5G(5895, 47), /* Channel 179 */
+	CHAN5G(5900, 48), /* Channel 180 */
+	CHAN5G(5905, 49), /* Channel 181 */
+	/* ITS-G5D */
+	CHAN5G(5910, 50), /* Channel 182 */
+	CHAN5G(5915, 51), /* Channel 183 */
+	CHAN5G(5920, 52), /* Channel 184 */
+	CHAN5G(5925, 53), /* Channel 185 */
 };
 
 /* Atheros hardware rate code addition for short premble */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 95ddca5..ea8d15d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1435,6 +1435,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 		retval = ath9k_rx_skb_preprocess(sc, hdr_skb, &rs, rxs,
 						 &decrypt_error, tsf);
+
+		if (IS_CHAN_HALF_RATE(ah->curchan))
+			rxs->flag |= RX_FLAG_10MHZ;
+		else if (IS_CHAN_QUARTER_RATE(ah->curchan))
+			rxs->flag |= RX_FLAG_5MHZ;
+
 		if (retval)
 			goto requeue_drop_frag;
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b5a19e0..7770f4a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2335,6 +2335,12 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		/* Frame was ACKed */
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 
+	if (IS_CHAN_HALF_RATE(sc->sc_ah->curchan))
+		tx_info->flags |= IEEE80211_TX_CTL_10MHZ;
+	else if (IS_CHAN_QUARTER_RATE(sc->sc_ah->curchan))
+		tx_info->flags |= IEEE80211_TX_CTL_5MHZ;
+
+
 	padpos = ieee80211_hdrlen(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len>padpos+padsize) {
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 1217c52..9a7b934 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -195,6 +195,7 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
 	unsigned int i;
+	u32 bandwidth = 0;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 
@@ -212,7 +213,8 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				continue;
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				reg_rule = freq_reg_info(wiphy, ch->center_freq);
+				reg_rule = freq_reg_info(wiphy, ch->center_freq,
+							 bandwidth);
 				if (IS_ERR(reg_rule))
 					continue;
 				/*
@@ -249,6 +251,7 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	const struct ieee80211_reg_rule *reg_rule;
+	u32 bandwidth = 0;
 
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
 	if (!sband)
@@ -276,7 +279,7 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 */
 
 	ch = &sband->channels[11]; /* CH 12 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, ch->center_freq, bandwidth);
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
@@ -284,7 +287,7 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	}
 
 	ch = &sband->channels[12]; /* CH 13 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, ch->center_freq, bandwidth);
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index d7d0d49..89836b0 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -158,6 +158,7 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
 	unsigned int i;
+	u32 bandwidth = 0;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 
@@ -172,7 +173,8 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 			    (ch->flags & IEEE80211_CHAN_RADAR))
 				continue;
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				reg_rule = freq_reg_info(wiphy, ch->center_freq);
+				reg_rule = freq_reg_info(wiphy, ch->center_freq,
+							 bandwidth);
 				if (IS_ERR(reg_rule))
 					continue;
 
@@ -208,6 +210,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	const struct ieee80211_reg_rule *reg_rule;
+	u32 bandwidth = 0;
 
 	if (!wiphy->bands[IEEE80211_BAND_2GHZ])
 		return;
@@ -235,7 +238,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 */
 
 	ch = &sband->channels[11];	/* CH 12 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, ch->center_freq, bandwidth);
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
@@ -243,7 +246,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	}
 
 	ch = &sband->channels[12];	/* CH 13 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, ch->center_freq, bandwidth);
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-- 
1.8.5.1

