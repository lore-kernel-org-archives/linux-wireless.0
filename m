Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 04/11] atheros: move tx/rx chainmask to ath_common
Date: Mon, 14 Sep 2009 04:37:21 -0400
Message-Id: <1252917448-10744-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h          |    3 ++
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 -
 drivers/net/wireless/ath/ath9k/beacon.c |    3 +-
 drivers/net/wireless/ath/ath9k/hw.c     |    4 +-
 drivers/net/wireless/ath/ath9k/main.c   |   34 +++++++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/xmit.c   |    3 +-
 6 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 2ca9701..38ca68e 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -56,6 +56,9 @@ struct ath_common {
 	u8 curbssid[ETH_ALEN];
 	u8 bssidmask[ETH_ALEN];
 
+	u8 tx_chainmask;
+	u8 rx_chainmask;
+
 	struct ath_regulatory regulatory;
 	const struct ath_ops *ops;
 };
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9864461..46d19e8 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -586,8 +586,6 @@ struct ath_softc {
 	u16 curtxpow;
 	u8 nbcnvifs;
 	u16 nvifs;
-	u8 tx_chainmask;
-	u8 rx_chainmask;
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	u8 splitmic;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 2f00313..54be876 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -62,6 +62,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 {
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_desc *ds;
 	struct ath9k_11n_rate_series series[4];
 	const struct ath_rate_table *rt;
@@ -109,7 +110,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 	series[0].Tries = 1;
 	series[0].Rate = rate;
-	series[0].ChSel = sc->tx_chainmask;
+	series[0].ChSel = common->tx_chainmask;
 	series[0].RateFlags = (ctsrate) ? ATH9K_RATESERIES_RTS_CTS : 0;
 	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0, ctsrate, ctsduration,
 				     series, 4, 0);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cd98719..4a5d398 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2324,8 +2324,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	int i, rx_chainmask, r;
 
 	ah->extprotspacing = sc->ht_extprotspacing;
-	ah->txchainmask = sc->tx_chainmask;
-	ah->rxchainmask = sc->rx_chainmask;
+	ah->txchainmask = common->tx_chainmask;
+	ah->rxchainmask = common->rx_chainmask;
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 214ce65..6404157 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -438,8 +438,11 @@ static void ath_ani_calibrate(unsigned long data)
 
 		/* Perform calibration if necessary */
 		if (longcal || shortcal) {
-			sc->ani.caldone = ath9k_hw_calibrate(ah, ah->curchan,
-						     sc->rx_chainmask, longcal);
+			sc->ani.caldone =
+				ath9k_hw_calibrate(ah,
+						   ah->curchan,
+						   common->rx_chainmask,
+						   longcal);
 
 			if (longcal)
 				sc->ani.noise_floor = ath9k_hw_getchan_noise(ah,
@@ -492,19 +495,21 @@ static void ath_start_ani(struct ath_softc *sc)
 void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	if ((sc->sc_flags & SC_OP_SCANNING) || is_ht ||
 	    (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE)) {
-		sc->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
-		sc->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
+		common->tx_chainmask = ah->caps.tx_chainmask;
+		common->rx_chainmask = ah->caps.rx_chainmask;
 	} else {
-		sc->tx_chainmask = 1;
-		sc->rx_chainmask = 1;
+		common->tx_chainmask = 1;
+		common->rx_chainmask = 1;
 	}
 
-	ath_print(ath9k_hw_common(ah), ATH_DBG_CONFIG,
+	ath_print(common, ATH_DBG_CONFIG,
 		  "tx chmask: %d, rx chmask: %d\n",
-		  sc->tx_chainmask, sc->rx_chainmask);
+		  common->tx_chainmask,
+		  common->rx_chainmask);
 }
 
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
@@ -949,6 +954,7 @@ static void ath_key_delete(struct ath_softc *sc, struct ieee80211_key_conf *key)
 static void setup_ht_cap(struct ath_softc *sc,
 			 struct ieee80211_sta_ht_cap *ht_info)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	u8 tx_streams, rx_streams;
 
 	ht_info->ht_supported = true;
@@ -962,11 +968,13 @@ static void setup_ht_cap(struct ath_softc *sc,
 
 	/* set up supported mcs set */
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-	tx_streams = !(sc->tx_chainmask & (sc->tx_chainmask - 1)) ? 1 : 2;
-	rx_streams = !(sc->rx_chainmask & (sc->rx_chainmask - 1)) ? 1 : 2;
+	tx_streams = !(common->tx_chainmask & (common->tx_chainmask - 1)) ?
+		     1 : 2;
+	rx_streams = !(common->rx_chainmask & (common->rx_chainmask - 1)) ?
+		     1 : 2;
 
 	if (tx_streams != rx_streams) {
-		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_CONFIG,
+		ath_print(common, ATH_DBG_CONFIG,
 			  "TX streams %d, RX streams: %d\n",
 			  tx_streams, rx_streams);
 		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
@@ -1763,8 +1771,8 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 		sc->sc_flags |= SC_OP_RXAGGR;
 	}
 
-	sc->tx_chainmask = ah->caps.tx_chainmask;
-	sc->rx_chainmask = ah->caps.rx_chainmask;
+	common->tx_chainmask = ah->caps.tx_chainmask;
+	common->rx_chainmask = ah->caps.rx_chainmask;
 
 	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
 	sc->rx.defant = ath9k_hw_getdefantenna(ah);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3665050..f302652 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1456,6 +1456,7 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	const struct ath_rate_table *rt = sc->cur_rate_table;
 	struct ath9k_11n_rate_series series[4];
 	struct sk_buff *skb;
@@ -1511,7 +1512,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 
 		rix = rates[i].idx;
 		series[i].Tries = rates[i].count;
-		series[i].ChSel = sc->tx_chainmask;
+		series[i].ChSel = common->tx_chainmask;
 
 		if (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 			series[i].Rate = rt->info[rix].ratecode |
-- 
1.6.3.3

