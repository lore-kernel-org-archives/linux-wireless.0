Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43265 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbZFJQZn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 12:25:43 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 09:25:46 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <jouni.malinen@atheros.com>, <luis.rodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 1/7] ath9k: Manipulate and report the correct RSSI
Date: Wed, 10 Jun 2009 21:55:26 +0530
Message-ID: <1244651133-6537-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
References: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSSI reported by the RX descriptor requires little manipulation.
Manipulate and report the correct RSSI to the stack. This will
fix the improper signal levels reported by iwconfig iw dev wlanX
station dump.

Also use the default noise floor for now as the one reported
during the caliberation seems to be wrong.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   15 +++++++++++++++
 drivers/net/wireless/ath/ath9k/calib.c |   13 ++++++++++---
 drivers/net/wireless/ath/ath9k/calib.h |    4 +++-
 drivers/net/wireless/ath/ath9k/main.c  |    1 +
 drivers/net/wireless/ath/ath9k/recv.c  |   20 +++++++++++++++++++-
 5 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9cd523f..2a3c66f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -297,12 +297,27 @@ struct ath_tx_control {
 #define ATH_TX_XRETRY       0x02
 #define ATH_TX_BAR          0x04
 
+#define ATH_RSSI_LPF_LEN           10
+#define RSSI_LPF_THRESHOLD         -20
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
index f7baa40..0fd3f25 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -447,6 +447,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 		an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
 				     sta->ht_cap.ampdu_factor);
 		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
+		an->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 5014a19..0f62795 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -145,6 +145,9 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 	u8 ratecode;
 	__le16 fc;
 	struct ieee80211_hw *hw;
+	struct ieee80211_sta *sta;
+	struct ath_node *an;
+
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
@@ -229,11 +232,26 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 		}
 	}
 
+	rcu_read_lock();
+	sta = ieee80211_find_sta(sc->hw, hdr->addr2);
+	if (sta) {
+		an = (struct ath_node *) sta->drv_priv;
+		ATH_RSSI_LPF(an->last_rssi, ds->ds_rxstat.rs_rssi);
+		if (likely(an->last_rssi != ATH_RSSI_DUMMY_MARKER))
+			ds->ds_rxstat.rs_rssi = ATH_EP_RND(an->last_rssi,
+					ATH_RSSI_EP_MULTIPLIER);
+		if (ds->ds_rxstat.rs_rssi < 0)
+			ds->ds_rxstat.rs_rssi = 0;
+		else if (ds->ds_rxstat.rs_rssi > 127)
+			ds->ds_rxstat.rs_rssi = 127;
+	}
+	rcu_read_unlock();
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

