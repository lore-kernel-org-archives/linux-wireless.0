Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49713 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab2GKR70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 13:59:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 08/12] ath9k: fix aggregate size limit based on queue TXOP limit
Date: Wed, 11 Jul 2012 19:59:11 +0200
Message-Id: <1342029555-31618-8-git-send-email-nbd@openwrt.org> (sfid-20120711_195938_724176_FA243ECD)
In-Reply-To: <1342029555-31618-7-git-send-email-nbd@openwrt.org>
References: <1342029555-31618-1-git-send-email-nbd@openwrt.org>
 <1342029555-31618-2-git-send-email-nbd@openwrt.org>
 <1342029555-31618-3-git-send-email-nbd@openwrt.org>
 <1342029555-31618-4-git-send-email-nbd@openwrt.org>
 <1342029555-31618-5-git-send-email-nbd@openwrt.org>
 <1342029555-31618-6-git-send-email-nbd@openwrt.org>
 <1342029555-31618-7-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the aggregate size exceeds the TXOP limit, it leads to lots of unnecessary
hardware and software retries.

The previous 4ms frame limit table was completely undocumented, the commit
that updated it only vaguely referenced and equation from the standard,
but I've been unable to replicate its results.

Fix this by using a formula based on the code in ath_pkt_duration, which is
more likely to be correct for this case.

Reported-by: Dave Täht <dave.taht@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +
 drivers/net/wireless/ath/ath9k/main.c  |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   73 +++++++++++++++++++-------------
 3 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 10568c0..6f74f74 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -298,6 +298,7 @@ struct ath_tx {
 	struct ath_descdma txdma;
 	struct ath_txq *txq_map[WME_NUM_AC];
 	u32 txq_max_pending[WME_NUM_AC];
+	u16 max_aggr_framelen[WME_NUM_AC][4][32];
 };
 
 struct ath_rx_edma {
@@ -342,6 +343,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs);
 void ath_tx_cleanup(struct ath_softc *sc);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
+void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop);
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl);
 void ath_tx_tasklet(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6f0be0d..1f6265b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1384,6 +1384,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 		queue, txq->axq_qnum, params->aifs, params->cw_min,
 		params->cw_max, params->txop);
 
+	ath_update_max_aggr_framelen(sc, queue, qi.tqi_burstTime);
 	ret = ath_txq_update(sc, txq->axq_qnum, &qi);
 	if (ret)
 		ath_err(common, "TXQ Update failed\n");
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 571d773..0a735bd 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -29,6 +29,8 @@
 #define HT_LTF(_ns)             (4 * (_ns))
 #define SYMBOL_TIME(_ns)        ((_ns) << 2) /* ns * 4 us */
 #define SYMBOL_TIME_HALFGI(_ns) (((_ns) * 18 + 4) / 5)  /* ns * 3.6 us */
+#define TIME_SYMBOLS(t)         ((t) >> 2)
+#define TIME_SYMBOLS_HALFGI(t)  (((t) * 5 - 4) / 18)
 #define NUM_SYMBOLS_PER_USEC(_usec) (_usec >> 2)
 #define NUM_SYMBOLS_PER_USEC_HALFGI(_usec) (((_usec*5)-4)/18)
 
@@ -74,33 +76,6 @@ enum {
 	MCS_HT40_SGI,
 };
 
-static int ath_max_4ms_framelen[4][32] = {
-	[MCS_HT20] = {
-		3212,  6432,  9648,  12864,  19300,  25736,  28952,  32172,
-		6424,  12852, 19280, 25708,  38568,  51424,  57852,  64280,
-		9628,  19260, 28896, 38528,  57792,  65532,  65532,  65532,
-		12828, 25656, 38488, 51320,  65532,  65532,  65532,  65532,
-	},
-	[MCS_HT20_SGI] = {
-		3572,  7144,  10720,  14296,  21444,  28596,  32172,  35744,
-		7140,  14284, 21428,  28568,  42856,  57144,  64288,  65532,
-		10700, 21408, 32112,  42816,  64228,  65532,  65532,  65532,
-		14256, 28516, 42780,  57040,  65532,  65532,  65532,  65532,
-	},
-	[MCS_HT40] = {
-		6680,  13360,  20044,  26724,  40092,  53456,  60140,  65532,
-		13348, 26700,  40052,  53400,  65532,  65532,  65532,  65532,
-		20004, 40008,  60016,  65532,  65532,  65532,  65532,  65532,
-		26644, 53292,  65532,  65532,  65532,  65532,  65532,  65532,
-	},
-	[MCS_HT40_SGI] = {
-		7420,  14844,  22272,  29696,  44544,  59396,  65532,  65532,
-		14832, 29668,  44504,  59340,  65532,  65532,  65532,  65532,
-		22232, 44464,  65532,  65532,  65532,  65532,  65532,  65532,
-		29616, 59232,  65532,  65532,  65532,  65532,  65532,  65532,
-	}
-};
-
 /*********************/
 /* Aggregation logic */
 /*********************/
@@ -650,6 +625,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_rate *rates;
 	u32 max_4ms_framelen, frmlen;
 	u16 aggr_limit, bt_aggr_limit, legacy = 0;
+	int q = tid->ac->txq->mac80211_qnum;
 	int i;
 
 	skb = bf->bf_mpdu;
@@ -658,8 +634,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 
 	/*
 	 * Find the lowest frame length among the rate series that will have a
-	 * 4ms transmit duration.
-	 * TODO - TXOP limit needs to be considered.
+	 * 4ms (or TXOP limited) transmit duration.
 	 */
 	max_4ms_framelen = ATH_AMPDU_LIMIT_MAX;
 
@@ -682,7 +657,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 		if (rates[i].flags & IEEE80211_TX_RC_SHORT_GI)
 			modeidx++;
 
-		frmlen = ath_max_4ms_framelen[modeidx][rates[i].idx];
+		frmlen = sc->tx.max_aggr_framelen[q][modeidx][rates[i].idx];
 		max_4ms_framelen = min(max_4ms_framelen, frmlen);
 	}
 
@@ -929,6 +904,44 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
 	return duration;
 }
 
+static int ath_max_framelen(int usec, int mcs, bool ht40, bool sgi)
+{
+	int streams = HT_RC_2_STREAMS(mcs);
+	int symbols, bits;
+	int bytes = 0;
+
+	symbols = sgi ? TIME_SYMBOLS_HALFGI(usec) : TIME_SYMBOLS(usec);
+	bits = symbols * bits_per_symbol[mcs % 8][ht40] * streams;
+	bits -= OFDM_PLCP_BITS;
+	bytes = bits / 8;
+	bytes -= L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
+	if (bytes > 65532)
+		bytes = 65532;
+
+	return bytes;
+}
+
+void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop)
+{
+	u16 *cur_ht20, *cur_ht20_sgi, *cur_ht40, *cur_ht40_sgi;
+	int mcs;
+
+	/* 4ms is the default (and maximum) duration */
+	if (!txop || txop > 4096)
+		txop = 4096;
+
+	cur_ht20 = sc->tx.max_aggr_framelen[queue][MCS_HT20];
+	cur_ht20_sgi = sc->tx.max_aggr_framelen[queue][MCS_HT20_SGI];
+	cur_ht40 = sc->tx.max_aggr_framelen[queue][MCS_HT40];
+	cur_ht40_sgi = sc->tx.max_aggr_framelen[queue][MCS_HT40_SGI];
+	for (mcs = 0; mcs < 32; mcs++) {
+		cur_ht20[mcs] = ath_max_framelen(txop, mcs, false, false);
+		cur_ht20_sgi[mcs] = ath_max_framelen(txop, mcs, false, true);
+		cur_ht40[mcs] = ath_max_framelen(txop, mcs, true, false);
+		cur_ht40_sgi[mcs] = ath_max_framelen(txop, mcs, true, true);
+	}
+}
+
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_info *info, int len)
 {
-- 
1.7.3.2

