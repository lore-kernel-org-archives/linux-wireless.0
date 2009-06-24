Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21384 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbZFXN0t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 09:26:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2009 06:26:53 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 1/7] ath9k: Manipulate and report the correct RSSI
Date: Wed, 24 Jun 2009 18:56:36 +0530
Message-ID: <1245850002-26351-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1245850002-26351-1-git-send-email-senthilkumar@atheros.com>
References: <1245850002-26351-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSSI reported by the RX descriptor requires little manipulation.
Manipulate and report the correct RSSI to the stack. This will
fix the improper signal levels reported by iwconfig iw dev wlanX
station dump. Also the Link Quality reported seems to be varying
(falls to zero also sometimes) when iperf is run from STA to AP.

Also use the default noise floor for now as the one reported
during the caliberation seems to be wrong.

The Signal and Link Quality before this patch (taken while TX is
in progress from STA to AP)

09:59:13.285428037 Link Quality=29/70  Signal level=-81 dBm
09:59:13.410660084 Link Quality=20/70  Signal level=-90 dBm
09:59:13.586864392 Link Quality=21/70  Signal level=-89 dBm
09:59:13.710296281 Link Quality=21/70  Signal level=-89 dBm
09:59:13.821683064 Link Quality=25/70  Signal level=-85 dBm
09:59:13.933402989 Link Quality=24/70  Signal level=-86 dBm
09:59:14.045839276 Link Quality=26/70  Signal level=-84 dBm
09:59:14.193926673 Link Quality=23/70  Signal level=-87 dBm
09:59:14.306230262 Link Quality=31/70  Signal level=-79 dBm
09:59:14.419459667 Link Quality=26/70  Signal level=-84 dBm
09:59:14.530711167 Link Quality=37/70  Signal level=-73 dBm
09:59:14.642593962 Link Quality=29/70  Signal level=-81 dBm
09:59:14.754361169 Link Quality=21/70  Signal level=-89 dBm
09:59:14.866217355 Link Quality=21/70  Signal level=-89 dBm
09:59:14.976963623 Link Quality=28/70  Signal level=-82 dBm
09:59:15.089149809 Link Quality=26/70  Signal level=-84 dBm
09:59:15.205039887 Link Quality=27/70  Signal level=-83 dBm
09:59:15.316368003 Link Quality=23/70  Signal level=-87 dBm
09:59:15.427684036 Link Quality=36/70  Signal level=-74 dBm
09:59:15.539756380 Link Quality=21/70  Signal level=-89 dBm
09:59:15.650549093 Link Quality=22/70  Signal level=-88 dBm
09:59:15.761171672 Link Quality=32/70  Signal level=-78 dBm
09:59:15.872793750 Link Quality=23/70  Signal level=-87 dBm
09:59:15.984421694 Link Quality=22/70  Signal level=-88 dBm
09:59:16.097315093 Link Quality=21/70  Signal level=-89 dBm

The link quality and signal level after this patch (take while
TX is in progress from STA to AP)

17:21:25.627848091 Link Quality=65/70  Signal level=-45 dBm
17:21:25.762805607 Link Quality=65/70  Signal level=-45 dBm
17:21:25.875521888 Link Quality=66/70  Signal level=-44 dBm
17:21:25.987468448 Link Quality=66/70  Signal level=-44 dBm
17:21:26.100628151 Link Quality=66/70  Signal level=-44 dBm
17:21:26.213129671 Link Quality=66/70  Signal level=-44 dBm
17:21:26.324923070 Link Quality=65/70  Signal level=-45 dBm
17:21:26.436831357 Link Quality=65/70  Signal level=-45 dBm
17:21:26.610356973 Link Quality=65/70  Signal level=-45 dBm
17:21:26.723340047 Link Quality=65/70  Signal level=-45 dBm
17:21:26.835715293 Link Quality=64/70  Signal level=-46 dBm
17:21:26.949542748 Link Quality=64/70  Signal level=-46 dBm
17:21:27.062261613 Link Quality=65/70  Signal level=-45 dBm
17:21:27.174511563 Link Quality=64/70  Signal level=-46 dBm
17:21:27.287616232 Link Quality=64/70  Signal level=-46 dBm
17:21:27.400598119 Link Quality=64/70  Signal level=-46 dBm
17:21:27.511381404 Link Quality=64/70  Signal level=-46 dBm
17:21:27.624530421 Link Quality=65/70  Signal level=-45 dBm
17:21:27.737807109 Link Quality=64/70  Signal level=-46 dBm
17:21:27.850861352 Link Quality=65/70  Signal level=-45 dBm
17:21:27.963369436 Link Quality=64/70  Signal level=-46 dBm
17:21:28.076582289 Link Quality=64/70  Signal level=-46 dBm

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/calib.c |   13 ++++++++++---
 drivers/net/wireless/ath/ath9k/calib.h |    4 +++-
 drivers/net/wireless/ath/ath9k/main.c  |    1 +
 drivers/net/wireless/ath/ath9k/recv.c  |   25 ++++++++++++++++++++++++-
 5 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7425a1f..6fa72b8 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -295,12 +295,28 @@ struct ath_tx_control {
 #define ATH_TX_XRETRY       0x02
 #define ATH_TX_BAR          0x04
 
+#define ATH_RSSI_LPF_LEN 		10
+#define RSSI_LPF_THRESHOLD		-20
+#define ATH9K_RSSI_BAD			0x80
+#define ATH_RSSI_EP_MULTIPLIER     (1<<7)
+#define ATH_EP_MUL(x, mul)         ((x) * (mul))
+#define ATH_RSSI_IN(x)             (ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
+#define ATH_LPF_RSSI(x, y, len) \
+    ((x != ATH_RSSI_DUMMY_MARKER) ? (((x) * ((len) - 1) + (y)) / (len)) : (y))
+#define ATH_RSSI_LPF(x, y) do {                     			\
+    if ((y) >= RSSI_LPF_THRESHOLD)                         		\
+	x = ATH_LPF_RSSI((x), ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN);  	\
+} while (0)
+#define ATH_EP_RND(x, mul) 						\
+	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
+
 struct ath_node {
 	struct ath_softc *an_sc;
 	struct ath_atx_tid tid[WME_NUM_TID];
 	struct ath_atx_ac ac[WME_NUM_AC];
 	u16 maxampdu;
 	u8 mpdudensity;
+	int last_rssi;
 };
 
 struct ath_tx {
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index a32d7e7..1f0c5fe 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -691,15 +691,22 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah)
 {
 	int i, j;
+	s16 noise_floor;
+
+	if (AR_SREV_9280(ah))
+		noise_floor = AR_PHY_CCA_MAX_AR9280_GOOD_VALUE;
+	else if (AR_SREV_9285(ah))
+		noise_floor = AR_PHY_CCA_MAX_AR9285_GOOD_VALUE;
+	else
+		noise_floor = AR_PHY_CCA_MAX_AR5416_GOOD_VALUE;
 
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		ah->nfCalHist[i].currIndex = 0;
-		ah->nfCalHist[i].privNF = AR_PHY_CCA_MAX_GOOD_VALUE;
+		ah->nfCalHist[i].privNF = noise_floor;
 		ah->nfCalHist[i].invalidNFcount =
 			AR_PHY_CCA_FILTERWINDOW_LENGTH;
 		for (j = 0; j < ATH9K_NF_CAL_HIST_MAX; j++) {
-			ah->nfCalHist[i].nfCalBuffer[j] =
-				AR_PHY_CCA_MAX_GOOD_VALUE;
+			ah->nfCalHist[i].nfCalBuffer[j] = noise_floor;
 		}
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index fe5367f..547e697 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -25,7 +25,9 @@ extern const struct ath9k_percal_data adc_dc_cal_multi_sample;
 extern const struct ath9k_percal_data adc_dc_cal_single_sample;
 extern const struct ath9k_percal_data adc_init_dc_cal;
 
-#define AR_PHY_CCA_MAX_GOOD_VALUE      		-85
+#define AR_PHY_CCA_MAX_AR5416_GOOD_VALUE	-85
+#define AR_PHY_CCA_MAX_AR9280_GOOD_VALUE	-112
+#define AR_PHY_CCA_MAX_AR9285_GOOD_VALUE	-118
 #define AR_PHY_CCA_MAX_HIGH_VALUE      		-62
 #define AR_PHY_CCA_MIN_BAD_VALUE       		-140
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 66a6c1f..f2bbc28 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -463,6 +463,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 		an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
 				     sta->ht_cap.ampdu_factor);
 		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
+		an->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2b2872b..214c4bb 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -145,6 +145,10 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 	u8 ratecode;
 	__le16 fc;
 	struct ieee80211_hw *hw;
+	struct ieee80211_sta *sta;
+	struct ath_node *an;
+	int last_rssi = ATH_RSSI_DUMMY_MARKER;
+
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
@@ -229,11 +233,30 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 		}
 	}
 
+	rcu_read_lock();
+	sta = ieee80211_find_sta(sc->hw, hdr->addr2);
+	if (sta) {
+		an = (struct ath_node *) sta->drv_priv;
+		if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
+		   !ds->ds_rxstat.rs_moreaggr)
+			ATH_RSSI_LPF(an->last_rssi, ds->ds_rxstat.rs_rssi);
+		last_rssi = an->last_rssi;
+	}
+	rcu_read_unlock();
+
+	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
+		ds->ds_rxstat.rs_rssi = ATH_EP_RND(last_rssi,
+					ATH_RSSI_EP_MULTIPLIER);
+	if (ds->ds_rxstat.rs_rssi < 0)
+		ds->ds_rxstat.rs_rssi = 0;
+	else if (ds->ds_rxstat.rs_rssi > 127)
+		ds->ds_rxstat.rs_rssi = 127;
+
 	rx_status->mactime = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->noise = sc->ani.noise_floor;
-	rx_status->signal = rx_status->noise + ds->ds_rxstat.rs_rssi;
+	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + ds->ds_rxstat.rs_rssi;
 	rx_status->antenna = ds->ds_rxstat.rs_antenna;
 
 	/* at 45 you will be able to use MCS 15 reliably. A more elaborate
-- 
1.6.0.4

