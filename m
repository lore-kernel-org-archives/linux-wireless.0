Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62960 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab2CNJLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 05:11:25 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20320.24738.234198.946699@gargle.gargle.HOWL> (sfid-20120314_101129_122349_CBFFCA08)
Date: Wed, 14 Mar 2012 14:40:58 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 5/6] ath9k: Remove aggregation flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SC_OP_TXAGGR and SC_OP_RXAGGR are not really needed.
The HT capabilities of the station and HW can be used instead.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   24 +++++++++++-------------
 drivers/net/wireless/ath/ath9k/init.c  |    9 +--------
 drivers/net/wireless/ath/ath9k/main.c  |   12 ++++--------
 drivers/net/wireless/ath/ath9k/rc.c    |    9 ++++-----
 drivers/net/wireless/ath/ath9k/xmit.c  |   21 +++++++++------------
 5 files changed, 29 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 419bf4e..5ecec83 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -583,19 +583,17 @@ struct ath_ant_comb {
 
 #define SC_OP_INVALID                BIT(0)
 #define SC_OP_BEACONS                BIT(1)
-#define SC_OP_RXAGGR                 BIT(2)
-#define SC_OP_TXAGGR                 BIT(3)
-#define SC_OP_OFFCHANNEL             BIT(4)
-#define SC_OP_PREAMBLE_SHORT         BIT(5)
-#define SC_OP_PROTECT_ENABLE         BIT(6)
-#define SC_OP_RXFLUSH                BIT(7)
-#define SC_OP_LED_ASSOCIATED         BIT(8)
-#define SC_OP_LED_ON                 BIT(9)
-#define SC_OP_TSF_RESET              BIT(11)
-#define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
-#define SC_OP_BT_SCAN		     BIT(13)
-#define SC_OP_ANI_RUN		     BIT(14)
-#define SC_OP_PRIM_STA_VIF	     BIT(15)
+#define SC_OP_OFFCHANNEL             BIT(2)
+#define SC_OP_PREAMBLE_SHORT         BIT(3)
+#define SC_OP_PROTECT_ENABLE         BIT(4)
+#define SC_OP_RXFLUSH                BIT(5)
+#define SC_OP_LED_ASSOCIATED         BIT(6)
+#define SC_OP_LED_ON                 BIT(7)
+#define SC_OP_TSF_RESET              BIT(8)
+#define SC_OP_BT_PRIORITY_DETECTED   BIT(9)
+#define SC_OP_BT_SCAN                BIT(10)
+#define SC_OP_ANI_RUN                BIT(11)
+#define SC_OP_PRIM_STA_VIF           BIT(12)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 944e9b5..2708d1f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -484,19 +484,12 @@ static void ath9k_init_misc(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int i = 0;
+
 	setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
 	sc->config.txpowlimit = ATH_TXPOWER_MAX;
-
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
-		sc->sc_flags |= SC_OP_TXAGGR;
-		sc->sc_flags |= SC_OP_RXAGGR;
-	}
-
 	sc->rx.defant = ath9k_hw_getdefantenna(sc->sc_ah);
-
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
-
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;
 
 	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a07565c..3f00daa 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -639,7 +639,8 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 #endif
 	an->sta = sta;
 	an->vif = vif;
-	if (sc->sc_flags & SC_OP_TXAGGR) {
+
+	if (sta->ht_cap.ht_supported) {
 		ath_tx_node_init(sc, an);
 		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				     sta->ht_cap.ampdu_factor);
@@ -658,7 +659,7 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 	an->sta = NULL;
 #endif
 
-	if (sc->sc_flags & SC_OP_TXAGGR)
+	if (sta->ht_cap.ht_supported)
 		ath_tx_node_cleanup(sc, an);
 }
 
@@ -1751,7 +1752,7 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 
-	if (!(sc->sc_flags & SC_OP_TXAGGR))
+	if (!sta->ht_cap.ht_supported)
 		return;
 
 	switch (cmd) {
@@ -2119,15 +2120,10 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (!(sc->sc_flags & SC_OP_RXAGGR))
-			ret = -ENOTSUPP;
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		if (!(sc->sc_flags & SC_OP_TXAGGR))
-			return -EOPNOTSUPP;
-
 		ath9k_ps_wakeup(sc);
 		ret = ath_tx_aggr_start(sc, sta, tid, ssn);
 		if (!ret)
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 6407af2..f26e984 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1298,12 +1298,13 @@ static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
 	return caps;
 }
 
-static bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an,
+static bool ath_tx_aggr_check(struct ath_softc *sc, struct ieee80211_sta *sta,
 			      u8 tidno)
 {
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	struct ath_atx_tid *txtid;
 
-	if (!(sc->sc_flags & SC_OP_TXAGGR))
+	if (!sta->ht_cap.ht_supported)
 		return false;
 
 	txtid = ATH_AN_2_TID(an, tidno);
@@ -1374,13 +1375,11 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		if (ieee80211_is_data_qos(fc) &&
 		    skb_get_queue_mapping(skb) != IEEE80211_AC_VO) {
 			u8 *qc, tid;
-			struct ath_node *an;
 
 			qc = ieee80211_get_qos_ctl(hdr);
 			tid = qc[0] & 0xf;
-			an = (struct ath_node *)sta->drv_priv;
 
-			if(ath_tx_aggr_check(sc, an, tid))
+			if(ath_tx_aggr_check(sc, sta, tid))
 				ieee80211_start_tx_ba_session(sta, tid, 0);
 		}
 	}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9f78501..d2c635d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1290,14 +1290,11 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 
 	an = (struct ath_node *)sta->drv_priv;
 
-	if (sc->sc_flags & SC_OP_TXAGGR) {
-		txtid = ATH_AN_2_TID(an, tid);
-		txtid->baw_size =
-			IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
-		txtid->state |= AGGR_ADDBA_COMPLETE;
-		txtid->state &= ~AGGR_ADDBA_PROGRESS;
-		ath_tx_resume_tid(sc, txtid);
-	}
+	txtid = ATH_AN_2_TID(an, tid);
+	txtid->baw_size = IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
+	txtid->state |= AGGR_ADDBA_COMPLETE;
+	txtid->state &= ~AGGR_ADDBA_PROGRESS;
+	ath_tx_resume_tid(sc, txtid);
 }
 
 /********************/
@@ -1523,7 +1520,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 	ath_drain_txq_list(sc, txq, &txq->axq_q, retry_tx);
 
 	/* flush any pending frames if aggregation is enabled */
-	if ((sc->sc_flags & SC_OP_TXAGGR) && !retry_tx)
+	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) && !retry_tx)
 		ath_txq_drain_pending_buffers(sc, txq);
 
 	ath_txq_unlock_complete(sc, txq);
@@ -1871,7 +1868,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 	struct ath_buf *bf;
 	u8 tidno;
 
-	if ((sc->sc_flags & SC_OP_TXAGGR) && txctl->an &&
+	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) && txctl->an &&
 		ieee80211_is_data_qos(hdr->frame_control)) {
 		tidno = ieee80211_get_qos_ctl(hdr)[0] &
 			IEEE80211_QOS_CTL_TID_MASK;
@@ -2141,7 +2138,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	} else
 		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok, true);
 
-	if (sc->sc_flags & SC_OP_TXAGGR)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		ath_txq_schedule(sc, txq);
 }
 
@@ -2166,7 +2163,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
-			if (sc->sc_flags & SC_OP_TXAGGR)
+			if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 				ath_txq_schedule(sc, txq);
 			break;
 		}
-- 
1.7.9.4

