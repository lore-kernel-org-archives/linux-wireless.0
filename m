Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:58368 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbcIBOBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 10:01:17 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v5] ath9k: Switch to using mac80211 intermediate software
        queues.
Date: Fri,  2 Sep 2016 16:00:30 +0200
Message-Id: <20160902140030.11798-1-toke@toke.dk> (sfid-20160902_160122_640924_85F67CD9)
In-Reply-To: <20160805160346.10545-1-toke@toke.dk>
References: <20160805160346.10545-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This switches ath9k over to using the mac80211 intermediate software
queueing mechanism for data packets. It removes the queueing inside the
driver, except for the retry queue, and instead pulls from mac80211 when
a packet is needed. The retry queue is used to store a packet that was
pulled but can't be sent immediately.

The old code path in ath_tx_start that would queue packets has been
removed completely, as has the qlen limit tunables (since there's no
longer a queue in the driver to limit).

Based on Tim's original patch set, but reworked quite thoroughly.

Cc: Tim Shepard <shep@alum.mit.edu>
Cc: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
Changes since v4:
- Fix regression where PS response frames (which go through the old TX
  path) would not get assigned a seqno because the tid variable was not
  assigned correctly. Many thanks to Felix for debugging this and coming
  up with a fix.

Hopefully that is the last regression (apart from the ongoing mac80211
restructure). :)

 drivers/net/wireless/ath/ath9k/ath9k.h     |  27 ++-
 drivers/net/wireless/ath/ath9k/channel.c   |   2 -
 drivers/net/wireless/ath/ath9k/debug.c     |  14 +-
 drivers/net/wireless/ath/ath9k/debug.h     |   2 -
 drivers/net/wireless/ath/ath9k/debug_sta.c |   4 +-
 drivers/net/wireless/ath/ath9k/init.c      |   2 +-
 drivers/net/wireless/ath/ath9k/main.c      |   9 +-
 drivers/net/wireless/ath/ath9k/xmit.c      | 338 ++++++++++++-----------=
------
 8 files changed, 163 insertions(+), 235 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireles=
s/ath/ath9k/ath9k.h
index 26fc8ec..378d345 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -91,7 +91,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_=
descdma *dd,
 #define ATH_RXBUF               512
 #define ATH_TXBUF               512
 #define ATH_TXBUF_RESERVE       5
-#define ATH_MAX_QDEPTH          (ATH_TXBUF / 4 - ATH_TXBUF_RESERVE)
 #define ATH_TXMAXTRY            13
 #define ATH_MAX_SW_RETRIES      30
=20
@@ -145,7 +144,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct at=
h_descdma *dd,
 #define BAW_WITHIN(_start, _bawsz, _seqno) \
 	((((_seqno) - (_start)) & 4095) < (_bawsz))
=20
-#define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
+#define ATH_AN_2_TID(_an, _tidno) ath_node_to_tid(_an, _tidno)
=20
 #define IS_HT_RATE(rate)   (rate & 0x80)
 #define IS_CCK_RATE(rate)  ((rate >=3D 0x18) && (rate <=3D 0x1e))
@@ -164,7 +163,6 @@ struct ath_txq {
 	spinlock_t axq_lock;
 	u32 axq_depth;
 	u32 axq_ampdu_depth;
-	bool stopped;
 	bool axq_tx_inprogress;
 	struct list_head txq_fifo[ATH_TXFIFO_DEPTH];
 	u8 txq_headidx;
@@ -232,7 +230,6 @@ struct ath_buf {
=20
 struct ath_atx_tid {
 	struct list_head list;
-	struct sk_buff_head buf_q;
 	struct sk_buff_head retry_q;
 	struct ath_node *an;
 	struct ath_txq *txq;
@@ -247,13 +244,13 @@ struct ath_atx_tid {
 	s8 bar_index;
 	bool active;
 	bool clear_ps_filter;
+	bool has_queued;
 };
=20
 struct ath_node {
 	struct ath_softc *sc;
 	struct ieee80211_sta *sta; /* station struct we're part of */
 	struct ieee80211_vif *vif; /* interface with which we're associated */
-	struct ath_atx_tid tid[IEEE80211_NUM_TIDS];
=20
 	u16 maxampdu;
 	u8 mpdudensity;
@@ -276,7 +273,6 @@ struct ath_tx_control {
 	struct ath_node *an;
 	struct ieee80211_sta *sta;
 	u8 paprd;
-	bool force_channel;
 };
=20
=20
@@ -293,7 +289,6 @@ struct ath_tx {
 	struct ath_descdma txdma;
 	struct ath_txq *txq_map[IEEE80211_NUM_ACS];
 	struct ath_txq *uapsdq;
-	u32 txq_max_pending[IEEE80211_NUM_ACS];
 	u16 max_aggr_framelen[IEEE80211_NUM_ACS][4][32];
 };
=20
@@ -421,6 +416,22 @@ struct ath_offchannel {
 	int duration;
 };
=20
+static inline struct ath_atx_tid *
+ath_node_to_tid(struct ath_node *an, u8 tidno)
+{
+	struct ieee80211_sta *sta =3D an->sta;
+	struct ieee80211_vif *vif =3D an->vif;
+	struct ieee80211_txq *txq;
+
+	BUG_ON(!vif);
+	if (sta)
+		txq =3D sta->txq[tidno % ARRAY_SIZE(sta->txq)];
+	else
+		txq =3D vif->txq;
+
+	return (struct ath_atx_tid *) txq->drv_priv;
+}
+
 #define case_rtn_string(val) case val: return #val
=20
 #define ath_for_each_chanctx(_sc, _ctx)                             \
@@ -575,7 +586,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
 void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u=
16 tid);
-void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,=
 u16 tid);
=20
 void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
@@ -585,6 +595,7 @@ void ath9k_release_buffered_frames(struct ieee80211_h=
w *hw,
 				   u16 tids, int nframes,
 				   enum ieee80211_frame_release_type reason,
 				   bool more_data);
+void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *=
queue);
=20
 /********/
 /* VIFs */
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wirel=
ess/ath/ath9k/channel.c
index 57e26a6..929dd70 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1010,7 +1010,6 @@ static void ath_scan_send_probe(struct ath_softc *s=
c,
 		goto error;
=20
 	txctl.txq =3D sc->tx.txq_map[IEEE80211_AC_VO];
-	txctl.force_channel =3D true;
 	if (ath_tx_start(sc->hw, skb, &txctl))
 		goto error;
=20
@@ -1133,7 +1132,6 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc,=
 struct ath_vif *avp,
 	memset(&txctl, 0, sizeof(txctl));
 	txctl.txq =3D sc->tx.txq_map[IEEE80211_AC_VO];
 	txctl.sta =3D sta;
-	txctl.force_channel =3D true;
 	if (ath_tx_start(sc->hw, skb, &txctl)) {
 		ieee80211_free_txskb(sc->hw, skb);
 		return false;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireles=
s/ath/ath9k/debug.c
index c56e40f..89a94dd 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -600,7 +600,6 @@ static int read_file_xmit(struct seq_file *file, void=
 *data)
 	PR("MPDUs XRetried:  ", xretries);
 	PR("Aggregates:      ", a_aggr);
 	PR("AMPDUs Queued HW:", a_queued_hw);
-	PR("AMPDUs Queued SW:", a_queued_sw);
 	PR("AMPDUs Completed:", a_completed);
 	PR("AMPDUs Retried:  ", a_retries);
 	PR("AMPDUs XRetried: ", a_xretries);
@@ -629,8 +628,7 @@ static void print_queue(struct ath_softc *sc, struct =
ath_txq *txq,
 	seq_printf(file, "%s: %d ", "qnum", txq->axq_qnum);
 	seq_printf(file, "%s: %2d ", "qdepth", txq->axq_depth);
 	seq_printf(file, "%s: %2d ", "ampdu-depth", txq->axq_ampdu_depth);
-	seq_printf(file, "%s: %3d ", "pending", txq->pending_frames);
-	seq_printf(file, "%s: %d\n", "stopped", txq->stopped);
+	seq_printf(file, "%s: %3d\n", "pending", txq->pending_frames);
=20
 	ath_txq_unlock(sc, txq);
 }
@@ -1208,7 +1206,6 @@ static const char ath9k_gstrings_stats[][ETH_GSTRIN=
G_LEN] =3D {
 	AMKSTR(d_tx_mpdu_xretries),
 	AMKSTR(d_tx_aggregates),
 	AMKSTR(d_tx_ampdus_queued_hw),
-	AMKSTR(d_tx_ampdus_queued_sw),
 	AMKSTR(d_tx_ampdus_completed),
 	AMKSTR(d_tx_ampdu_retries),
 	AMKSTR(d_tx_ampdu_xretries),
@@ -1288,7 +1285,6 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 	AWDATA(xretries);
 	AWDATA(a_aggr);
 	AWDATA(a_queued_hw);
-	AWDATA(a_queued_sw);
 	AWDATA(a_completed);
 	AWDATA(a_retries);
 	AWDATA(a_xretries);
@@ -1346,14 +1342,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 				    read_file_xmit);
 	debugfs_create_devm_seqfile(sc->dev, "queues", sc->debug.debugfs_phy,
 				    read_file_queues);
-	debugfs_create_u32("qlen_bk", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-			   &sc->tx.txq_max_pending[IEEE80211_AC_BK]);
-	debugfs_create_u32("qlen_be", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-			   &sc->tx.txq_max_pending[IEEE80211_AC_BE]);
-	debugfs_create_u32("qlen_vi", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-			   &sc->tx.txq_max_pending[IEEE80211_AC_VI]);
-	debugfs_create_u32("qlen_vo", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-			   &sc->tx.txq_max_pending[IEEE80211_AC_VO]);
 	debugfs_create_devm_seqfile(sc->dev, "misc", sc->debug.debugfs_phy,
 				    read_file_misc);
 	debugfs_create_devm_seqfile(sc->dev, "reset", sc->debug.debugfs_phy,
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireles=
s/ath/ath9k/debug.h
index cd68c5f..a078cdd 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -147,7 +147,6 @@ struct ath_interrupt_stats {
  * @completed: Total MPDUs (non-aggr) completed
  * @a_aggr: Total no. of aggregates queued
  * @a_queued_hw: Total AMPDUs queued to hardware
- * @a_queued_sw: Total AMPDUs queued to software queues
  * @a_completed: Total AMPDUs completed
  * @a_retries: No. of AMPDUs retried (SW)
  * @a_xretries: No. of AMPDUs dropped due to xretries
@@ -174,7 +173,6 @@ struct ath_tx_stats {
 	u32 xretries;
 	u32 a_aggr;
 	u32 a_queued_hw;
-	u32 a_queued_sw;
 	u32 a_completed;
 	u32 a_retries;
 	u32 a_xretries;
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wir=
eless/ath/ath9k/debug_sta.c
index b66cfa9..2a3a3c4 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -52,8 +52,8 @@ static ssize_t read_file_node_aggr(struct file *file, c=
har __user *user_buf,
 			 "TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
 			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
=20
-	for (tidno =3D 0, tid =3D &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
+	for (tidno =3D 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
+		tid =3D ath_node_to_tid(an, tidno);
 		txq =3D tid->txq;
 		ath_txq_lock(sc, txq);
 		if (tid->active) {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless=
/ath/ath9k/init.c
index cfa3fe8..96bba17 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -358,7 +358,6 @@ static int ath9k_init_queues(struct ath_softc *sc)
 	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
 		sc->tx.txq_map[i] =3D ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, i);
 		sc->tx.txq_map[i]->mac80211_qnum =3D i;
-		sc->tx.txq_max_pending[i] =3D ATH_MAX_QDEPTH;
 	}
 	return 0;
 }
@@ -877,6 +876,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, =
struct ieee80211_hw *hw)
 	hw->max_rate_tries =3D 10;
 	hw->sta_data_size =3D sizeof(struct ath_node);
 	hw->vif_data_size =3D sizeof(struct ath_vif);
+	hw->txq_data_size =3D sizeof(struct ath_atx_tid);
 	hw->extra_tx_headroom =3D 4;
=20
 	hw->wiphy->available_antennas_rx =3D BIT(ah->caps.max_rxchains) - 1;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless=
/ath/ath9k/main.c
index a394622..1dedf13 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1896,9 +1896,11 @@ static int ath9k_ampdu_action(struct ieee80211_hw =
*hw,
 	bool flush =3D false;
 	int ret =3D 0;
 	struct ieee80211_sta *sta =3D params->sta;
+	struct ath_node *an =3D (struct ath_node *)sta->drv_priv;
 	enum ieee80211_ampdu_mlme_action action =3D params->action;
 	u16 tid =3D params->tid;
 	u16 *ssn =3D &params->ssn;
+	struct ath_atx_tid *atid;
=20
 	mutex_lock(&sc->mutex);
=20
@@ -1931,9 +1933,9 @@ static int ath9k_ampdu_action(struct ieee80211_hw *=
hw,
 		ath9k_ps_restore(sc);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		ath9k_ps_wakeup(sc);
-		ath_tx_aggr_resume(sc, sta, tid);
-		ath9k_ps_restore(sc);
+		atid =3D ath_node_to_tid(an, tid);
+		atid->baw_size =3D IEEE80211_MIN_AMPDU_BUF <<
+			        sta->ht_cap.ampdu_factor;
 		break;
 	default:
 		ath_err(ath9k_hw_common(sc->sc_ah), "Unknown AMPDU action\n");
@@ -2695,4 +2697,5 @@ struct ieee80211_ops ath9k_ops =3D {
 	.sw_scan_start	    =3D ath9k_sw_scan_start,
 	.sw_scan_complete   =3D ath9k_sw_scan_complete,
 	.get_txpower        =3D ath9k_get_txpower,
+	.wake_tx_queue      =3D ath9k_wake_tx_queue,
 };
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless=
/ath/ath9k/xmit.c
index 8ddd604..c074747 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -65,6 +65,8 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_s=
oftc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
 					   struct sk_buff *skb);
+static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
+			  struct ath_tx_control *txctl);
=20
 enum {
 	MCS_HT20,
@@ -118,6 +120,26 @@ static void ath_tx_queue_tid(struct ath_softc *sc, s=
truct ath_txq *txq,
 		list_add_tail(&tid->list, list);
 }
=20
+void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *=
queue)
+{
+	struct ath_softc *sc =3D hw->priv;
+	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
+	struct ath_atx_tid *tid =3D (struct ath_atx_tid *) queue->drv_priv;
+	struct ath_txq *txq =3D tid->txq;
+
+	ath_dbg(common, QUEUE, "Waking TX queue: %pM (%d)\n",
+		queue->sta ? queue->sta->addr : queue->vif->addr,
+		tid->tidno);
+
+	ath_txq_lock(sc, txq);
+
+	tid->has_queued =3D true;
+	ath_tx_queue_tid(sc, txq, tid);
+	ath_txq_schedule(sc, txq);
+
+	ath_txq_unlock(sc, txq);
+}
+
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info =3D IEEE80211_SKB_CB(skb);
@@ -145,7 +167,6 @@ static void ath_set_rates(struct ieee80211_vif *vif, =
struct ieee80211_sta *sta,
 static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 			     struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
 	struct ath_frame_info *fi =3D get_frame_info(skb);
 	int q =3D fi->txq;
=20
@@ -156,14 +177,6 @@ static void ath_txq_skb_done(struct ath_softc *sc, s=
truct ath_txq *txq,
 	if (WARN_ON(--txq->pending_frames < 0))
 		txq->pending_frames =3D 0;
=20
-	if (txq->stopped &&
-	    txq->pending_frames < sc->tx.txq_max_pending[q]) {
-		if (ath9k_is_chanctx_enabled())
-			ieee80211_wake_queue(sc->hw, info->hw_queue);
-		else
-			ieee80211_wake_queue(sc->hw, q);
-		txq->stopped =3D false;
-	}
 }
=20
 static struct ath_atx_tid *
@@ -173,9 +186,48 @@ ath_get_skb_tid(struct ath_softc *sc, struct ath_nod=
e *an, struct sk_buff *skb)
 	return ATH_AN_2_TID(an, tidno);
 }
=20
+static struct sk_buff *
+ath_tid_pull(struct ath_atx_tid *tid)
+{
+	struct ieee80211_txq *txq =3D container_of((void*)tid, struct ieee80211=
_txq, drv_priv);
+	struct ath_softc *sc =3D tid->an->sc;
+	struct ieee80211_hw *hw =3D sc->hw;
+	struct ath_tx_control txctl =3D {
+		.txq =3D tid->txq,
+		.sta =3D tid->an->sta,
+	};
+	struct sk_buff *skb;
+	struct ath_frame_info *fi;
+	int q;
+
+	if (!tid->has_queued)
+		return NULL;
+
+	skb =3D ieee80211_tx_dequeue(hw, txq);
+	if (!skb) {
+		tid->has_queued =3D false;
+		return NULL;
+	}
+
+	if (ath_tx_prepare(hw, skb, &txctl)) {
+		ieee80211_free_txskb(hw, skb);
+		return NULL;
+	}
+
+	q =3D skb_get_queue_mapping(skb);
+	if (tid->txq =3D=3D sc->tx.txq_map[q]) {
+		fi =3D get_frame_info(skb);
+		fi->txq =3D q;
+		++tid->txq->pending_frames;
+	}
+
+	return skb;
+ }
+
+
 static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
 {
-	return !skb_queue_empty(&tid->buf_q) || !skb_queue_empty(&tid->retry_q)=
;
+	return !skb_queue_empty(&tid->retry_q) || tid->has_queued;
 }
=20
 static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
@@ -184,46 +236,11 @@ static struct sk_buff *ath_tid_dequeue(struct ath_a=
tx_tid *tid)
=20
 	skb =3D __skb_dequeue(&tid->retry_q);
 	if (!skb)
-		skb =3D __skb_dequeue(&tid->buf_q);
+		skb =3D ath_tid_pull(tid);
=20
 	return skb;
 }
=20
-/*
- * ath_tx_tid_change_state:
- * - clears a-mpdu flag of previous session
- * - force sequence number allocation to fix next BlockAck Window
- */
-static void
-ath_tx_tid_change_state(struct ath_softc *sc, struct ath_atx_tid *tid)
-{
-	struct ath_txq *txq =3D tid->txq;
-	struct ieee80211_tx_info *tx_info;
-	struct sk_buff *skb, *tskb;
-	struct ath_buf *bf;
-	struct ath_frame_info *fi;
-
-	skb_queue_walk_safe(&tid->buf_q, skb, tskb) {
-		fi =3D get_frame_info(skb);
-		bf =3D fi->bf;
-
-		tx_info =3D IEEE80211_SKB_CB(skb);
-		tx_info->flags &=3D ~IEEE80211_TX_CTL_AMPDU;
-
-		if (bf)
-			continue;
-
-		bf =3D ath_tx_setup_buffer(sc, txq, tid, skb);
-		if (!bf) {
-			__skb_unlink(skb, &tid->buf_q);
-			ath_txq_skb_done(sc, txq, skb);
-			ieee80211_free_txskb(sc->hw, skb);
-			continue;
-		}
-	}
-
-}
-
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *t=
id)
 {
 	struct ath_txq *txq =3D tid->txq;
@@ -858,20 +875,16 @@ static int ath_compute_num_delims(struct ath_softc =
*sc, struct ath_atx_tid *tid,
=20
 static struct ath_buf *
 ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
-			struct ath_atx_tid *tid, struct sk_buff_head **q)
+			struct ath_atx_tid *tid)
 {
 	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *first_skb =3D NULL;
 	struct ath_buf *bf;
 	u16 seqno;
=20
 	while (1) {
-		*q =3D &tid->retry_q;
-		if (skb_queue_empty(*q))
-			*q =3D &tid->buf_q;
-
-		skb =3D skb_peek(*q);
+		skb =3D ath_tid_dequeue(tid);
 		if (!skb)
 			break;
=20
@@ -883,7 +896,6 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct =
ath_txq *txq,
 			bf->bf_state.stale =3D false;
=20
 		if (!bf) {
-			__skb_unlink(skb, *q);
 			ath_txq_skb_done(sc, txq, skb);
 			ieee80211_free_txskb(sc->hw, skb);
 			continue;
@@ -912,8 +924,20 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct=
 ath_txq *txq,
 		seqno =3D bf->bf_state.seqno;
=20
 		/* do not step over block-ack window */
-		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno))
+		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno)) {
+			__skb_queue_tail(&tid->retry_q, skb);
+
+			/* If there are other skbs in the retry q, they are
+			 * probably within the BAW, so loop immediately to get
+			 * one of them. Otherwise the queue can get stuck. */
+			if (!skb_queue_is_first(&tid->retry_q, skb) &&
+			    !WARN_ON(skb =3D=3D first_skb)) {
+				if(!first_skb) /* infinite loop prevention */
+					first_skb =3D skb;
+				continue;
+			}
 			break;
+		}
=20
 		if (tid->bar_index > ATH_BA_INDEX(tid->seq_start, seqno)) {
 			struct ath_tx_status ts =3D {};
@@ -921,7 +945,6 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct =
ath_txq *txq,
=20
 			INIT_LIST_HEAD(&bf_head);
 			list_add(&bf->list, &bf_head);
-			__skb_unlink(skb, *q);
 			ath_tx_update_baw(sc, tid, seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 			continue;
@@ -933,11 +956,10 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struc=
t ath_txq *txq,
 	return NULL;
 }
=20
-static bool
+static int
 ath_tx_form_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		 struct ath_atx_tid *tid, struct list_head *bf_q,
-		 struct ath_buf *bf_first, struct sk_buff_head *tid_q,
-		 int *aggr_len)
+		 struct ath_buf *bf_first)
 {
 #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
 	struct ath_buf *bf =3D bf_first, *bf_prev =3D NULL;
@@ -947,12 +969,13 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_t=
xq *txq,
 	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
 	struct sk_buff *skb;
-	bool closed =3D false;
+
=20
 	bf =3D bf_first;
 	aggr_limit =3D ath_lookup_rate(sc, bf, tid);
=20
-	do {
+	while (bf)
+	{
 		skb =3D bf->bf_mpdu;
 		fi =3D get_frame_info(skb);
=20
@@ -961,12 +984,12 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_t=
xq *txq,
 		if (nframes) {
 			if (aggr_limit < al + bpad + al_delta ||
 			    ath_lookup_legacy(bf) || nframes >=3D h_baw)
-				break;
+				goto stop;
=20
 			tx_info =3D IEEE80211_SKB_CB(bf->bf_mpdu);
 			if ((tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) ||
 			    !(tx_info->flags & IEEE80211_TX_CTL_AMPDU))
-				break;
+				goto stop;
 		}
=20
 		/* add padding for previous frame to aggregation length */
@@ -988,20 +1011,18 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_=
txq *txq,
 			ath_tx_addto_baw(sc, tid, bf);
 		bf->bf_state.ndelim =3D ndelim;
=20
-		__skb_unlink(skb, tid_q);
 		list_add_tail(&bf->list, bf_q);
 		if (bf_prev)
 			bf_prev->bf_next =3D bf;
=20
 		bf_prev =3D bf;
=20
-		bf =3D ath_tx_get_tid_subframe(sc, txq, tid, &tid_q);
-		if (!bf) {
-			closed =3D true;
-			break;
-		}
-	} while (ath_tid_has_buffered(tid));
-
+		bf =3D ath_tx_get_tid_subframe(sc, txq, tid);
+	}
+	goto finish;
+stop:
+	__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
+finish:
 	bf =3D bf_first;
 	bf->bf_lastbf =3D bf_prev;
=20
@@ -1012,9 +1033,7 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_t=
xq *txq,
 		TX_STAT_INC(txq->axq_qnum, a_aggr);
 	}
=20
-	*aggr_len =3D al;
-
-	return closed;
+	return al;
 #undef PADBYTES
 }
=20
@@ -1391,18 +1410,15 @@ static void ath_tx_fill_desc(struct ath_softc *sc=
, struct ath_buf *bf,
 static void
 ath_tx_form_burst(struct ath_softc *sc, struct ath_txq *txq,
 		  struct ath_atx_tid *tid, struct list_head *bf_q,
-		  struct ath_buf *bf_first, struct sk_buff_head *tid_q)
+		  struct ath_buf *bf_first)
 {
 	struct ath_buf *bf =3D bf_first, *bf_prev =3D NULL;
-	struct sk_buff *skb;
 	int nframes =3D 0;
=20
 	do {
 		struct ieee80211_tx_info *tx_info;
-		skb =3D bf->bf_mpdu;
=20
 		nframes++;
-		__skb_unlink(skb, tid_q);
 		list_add_tail(&bf->list, bf_q);
 		if (bf_prev)
 			bf_prev->bf_next =3D bf;
@@ -1411,13 +1427,15 @@ ath_tx_form_burst(struct ath_softc *sc, struct at=
h_txq *txq,
 		if (nframes >=3D 2)
 			break;
=20
-		bf =3D ath_tx_get_tid_subframe(sc, txq, tid, &tid_q);
+		bf =3D ath_tx_get_tid_subframe(sc, txq, tid);
 		if (!bf)
 			break;
=20
 		tx_info =3D IEEE80211_SKB_CB(bf->bf_mpdu);
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
+			__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
 			break;
+		}
=20
 		ath_set_rates(tid->an->vif, tid->an->sta, bf);
 	} while (1);
@@ -1428,34 +1446,33 @@ static bool ath_tx_sched_aggr(struct ath_softc *s=
c, struct ath_txq *txq,
 {
 	struct ath_buf *bf;
 	struct ieee80211_tx_info *tx_info;
-	struct sk_buff_head *tid_q;
 	struct list_head bf_q;
 	int aggr_len =3D 0;
-	bool aggr, last =3D true;
+	bool aggr;
=20
 	if (!ath_tid_has_buffered(tid))
 		return false;
=20
 	INIT_LIST_HEAD(&bf_q);
=20
-	bf =3D ath_tx_get_tid_subframe(sc, txq, tid, &tid_q);
+	bf =3D ath_tx_get_tid_subframe(sc, txq, tid);
 	if (!bf)
 		return false;
=20
 	tx_info =3D IEEE80211_SKB_CB(bf->bf_mpdu);
 	aggr =3D !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 	if ((aggr && txq->axq_ampdu_depth >=3D ATH_AGGR_MIN_QDEPTH) ||
-		(!aggr && txq->axq_depth >=3D ATH_NON_AGGR_MIN_QDEPTH)) {
+	    (!aggr && txq->axq_depth >=3D ATH_NON_AGGR_MIN_QDEPTH)) {
+		__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
 		*stop =3D true;
 		return false;
 	}
=20
 	ath_set_rates(tid->an->vif, tid->an->sta, bf);
 	if (aggr)
-		last =3D ath_tx_form_aggr(sc, txq, tid, &bf_q, bf,
-					tid_q, &aggr_len);
+		aggr_len =3D ath_tx_form_aggr(sc, txq, tid, &bf_q, bf);
 	else
-		ath_tx_form_burst(sc, txq, tid, &bf_q, bf, tid_q);
+		ath_tx_form_burst(sc, txq, tid, &bf_q, bf);
=20
 	if (list_empty(&bf_q))
 		return false;
@@ -1498,9 +1515,6 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct =
ieee80211_sta *sta,
 		an->mpdudensity =3D density;
 	}
=20
-	/* force sequence number allocation for pending frames */
-	ath_tx_tid_change_state(sc, txtid);
-
 	txtid->active =3D true;
 	*ssn =3D txtid->seq_start =3D txtid->seq_next;
 	txtid->bar_index =3D -1;
@@ -1525,7 +1539,6 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct =
ieee80211_sta *sta, u16 tid)
 	ath_txq_lock(sc, txq);
 	txtid->active =3D false;
 	ath_tx_flush_tid(sc, txtid);
-	ath_tx_tid_change_state(sc, txtid);
 	ath_txq_unlock_complete(sc, txq);
 }
=20
@@ -1535,14 +1548,12 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta,=
 struct ath_softc *sc,
 	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
-	bool buffered;
 	int tidno;
=20
 	ath_dbg(common, XMIT, "%s called\n", __func__);
=20
-	for (tidno =3D 0, tid =3D &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
-
+	for (tidno =3D 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
+		tid =3D ath_node_to_tid(an, tidno);
 		txq =3D tid->txq;
=20
 		ath_txq_lock(sc, txq);
@@ -1552,13 +1563,12 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta,=
 struct ath_softc *sc,
 			continue;
 		}
=20
-		buffered =3D ath_tid_has_buffered(tid);
+		if (!skb_queue_empty(&tid->retry_q))
+			ieee80211_sta_set_buffered(sta, tid->tidno, true);
=20
 		list_del_init(&tid->list);
=20
 		ath_txq_unlock(sc, txq);
-
-		ieee80211_sta_set_buffered(sta, tidno, buffered);
 	}
 }
=20
@@ -1571,49 +1581,20 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, str=
uct ath_node *an)
=20
 	ath_dbg(common, XMIT, "%s called\n", __func__);
=20
-	for (tidno =3D 0, tid =3D &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
-
+	for (tidno =3D 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
+		tid =3D ath_node_to_tid(an, tidno);
 		txq =3D tid->txq;
=20
 		ath_txq_lock(sc, txq);
 		tid->clear_ps_filter =3D true;
-
 		if (ath_tid_has_buffered(tid)) {
 			ath_tx_queue_tid(sc, txq, tid);
 			ath_txq_schedule(sc, txq);
 		}
-
 		ath_txq_unlock_complete(sc, txq);
 	}
 }
=20
-void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
-			u16 tidno)
-{
-	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
-	struct ath_atx_tid *tid;
-	struct ath_node *an;
-	struct ath_txq *txq;
-
-	ath_dbg(common, XMIT, "%s called\n", __func__);
-
-	an =3D (struct ath_node *)sta->drv_priv;
-	tid =3D ATH_AN_2_TID(an, tidno);
-	txq =3D tid->txq;
-
-	ath_txq_lock(sc, txq);
-
-	tid->baw_size =3D IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
-
-	if (ath_tid_has_buffered(tid)) {
-		ath_tx_queue_tid(sc, txq, tid);
-		ath_txq_schedule(sc, txq);
-	}
-
-	ath_txq_unlock_complete(sc, txq);
-}
-
 void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 				   struct ieee80211_sta *sta,
 				   u16 tids, int nframes,
@@ -1626,7 +1607,6 @@ void ath9k_release_buffered_frames(struct ieee80211=
_hw *hw,
 	struct ieee80211_tx_info *info;
 	struct list_head bf_q;
 	struct ath_buf *bf_tail =3D NULL, *bf;
-	struct sk_buff_head *tid_q;
 	int sent =3D 0;
 	int i;
=20
@@ -1641,11 +1621,10 @@ void ath9k_release_buffered_frames(struct ieee802=
11_hw *hw,
=20
 		ath_txq_lock(sc, tid->txq);
 		while (nframes > 0) {
-			bf =3D ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid, &tid_q);
+			bf =3D ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid);
 			if (!bf)
 				break;
=20
-			__skb_unlink(bf->bf_mpdu, tid_q);
 			list_add_tail(&bf->list, &bf_q);
 			ath_set_rates(tid->an->vif, tid->an->sta, bf);
 			if (bf_isampdu(bf)) {
@@ -1660,7 +1639,7 @@ void ath9k_release_buffered_frames(struct ieee80211=
_hw *hw,
 			sent++;
 			TX_STAT_INC(txq->axq_qnum, a_queued_hw);
=20
-			if (an->sta && !ath_tid_has_buffered(tid))
+			if (an->sta && skb_queue_empty(&tid->retry_q))
 				ieee80211_sta_set_buffered(an->sta, i, false);
 		}
 		ath_txq_unlock_complete(sc, tid->txq);
@@ -1887,13 +1866,7 @@ bool ath_drain_all_txq(struct ath_softc *sc)
 		if (!ATH_TXQ_SETUP(sc, i))
 			continue;
=20
-		/*
-		 * The caller will resume queues with ieee80211_wake_queues.
-		 * Mark the queue as not stopped to prevent ath_tx_complete
-		 * from waking the queue too early.
-		 */
 		txq =3D &sc->tx.txq[i];
-		txq->stopped =3D false;
 		ath_draintxq(sc, txq);
 	}
=20
@@ -2292,16 +2265,14 @@ int ath_tx_start(struct ieee80211_hw *hw, struct =
sk_buff *skb,
 	struct ath_softc *sc =3D hw->priv;
 	struct ath_txq *txq =3D txctl->txq;
 	struct ath_atx_tid *tid =3D NULL;
+	struct ath_node *an =3D NULL;
 	struct ath_buf *bf;
-	bool queue, skip_uapsd =3D false, ps_resp;
+	bool ps_resp;
 	int q, ret;
=20
 	if (vif)
 		avp =3D (void *)vif->drv_priv;
=20
-	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
-		txctl->force_channel =3D true;
-
 	ps_resp =3D !!(info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE);
=20
 	ret =3D ath_tx_prepare(hw, skb, txctl);
@@ -2316,63 +2287,18 @@ int ath_tx_start(struct ieee80211_hw *hw, struct =
sk_buff *skb,
=20
 	q =3D skb_get_queue_mapping(skb);
=20
-	ath_txq_lock(sc, txq);
-	if (txq =3D=3D sc->tx.txq_map[q]) {
-		fi->txq =3D q;
-		if (++txq->pending_frames > sc->tx.txq_max_pending[q] &&
-		    !txq->stopped) {
-			if (ath9k_is_chanctx_enabled())
-				ieee80211_stop_queue(sc->hw, info->hw_queue);
-			else
-				ieee80211_stop_queue(sc->hw, q);
-			txq->stopped =3D true;
-		}
-	}
-
-	queue =3D ieee80211_is_data_present(hdr->frame_control);
-
-	/* If chanctx, queue all null frames while NOA could be there */
-	if (ath9k_is_chanctx_enabled() &&
-	    ieee80211_is_nullfunc(hdr->frame_control) &&
-	    !txctl->force_channel)
-		queue =3D true;
-
-	/* Force queueing of all frames that belong to a virtual interface on
-	 * a different channel context, to ensure that they are sent on the
-	 * correct channel.
-	 */
-	if (((avp && avp->chanctx !=3D sc->cur_chan) ||
-	     sc->cur_chan->stopped) && !txctl->force_channel) {
-		if (!txctl->an)
-			txctl->an =3D &avp->mcast_node;
-		queue =3D true;
-		skip_uapsd =3D true;
-	}
-
-	if (txctl->an && queue)
-		tid =3D ath_get_skb_tid(sc, txctl->an, skb);
-
-	if (!skip_uapsd && ps_resp) {
-		ath_txq_unlock(sc, txq);
+	if (ps_resp)
 		txq =3D sc->tx.uapsdq;
-		ath_txq_lock(sc, txq);
-	} else if (txctl->an && queue) {
-		WARN_ON(tid->txq !=3D txctl->txq);
=20
-		if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
-			tid->clear_ps_filter =3D true;
-
-		/*
-		 * Add this frame to software queue for scheduling later
-		 * for aggregation.
-		 */
-		TX_STAT_INC(txq->axq_qnum, a_queued_sw);
-		__skb_queue_tail(&tid->buf_q, skb);
-		if (!txctl->an->sleeping)
-			ath_tx_queue_tid(sc, txq, tid);
+	if (txctl->sta) {
+		an =3D (struct ath_node *) sta->drv_priv;
+		tid =3D ath_get_skb_tid(sc, an, skb);
+	}
=20
-		ath_txq_schedule(sc, txq);
-		goto out;
+	ath_txq_lock(sc, txq);
+	if (txq =3D=3D sc->tx.txq_map[q]) {
+		fi->txq =3D q;
+		++txq->pending_frames;
 	}
=20
 	bf =3D ath_tx_setup_buffer(sc, txq, tid, skb);
@@ -2856,9 +2782,8 @@ void ath_tx_node_init(struct ath_softc *sc, struct =
ath_node *an)
 	struct ath_atx_tid *tid;
 	int tidno, acno;
=20
-	for (tidno =3D 0, tid =3D &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS;
-	     tidno++, tid++) {
+	for (tidno =3D 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
+		tid =3D ath_node_to_tid(an, tidno);
 		tid->an        =3D an;
 		tid->tidno     =3D tidno;
 		tid->seq_start =3D tid->seq_next =3D 0;
@@ -2866,11 +2791,14 @@ void ath_tx_node_init(struct ath_softc *sc, struc=
t ath_node *an)
 		tid->baw_head  =3D tid->baw_tail =3D 0;
 		tid->active	   =3D false;
 		tid->clear_ps_filter =3D true;
-		__skb_queue_head_init(&tid->buf_q);
+		tid->has_queued  =3D false;
 		__skb_queue_head_init(&tid->retry_q);
 		INIT_LIST_HEAD(&tid->list);
 		acno =3D TID_TO_WME_AC(tidno);
 		tid->txq =3D sc->tx.txq_map[acno];
+
+		if (!an->sta)
+			break; /* just one multicast ath_atx_tid */
 	}
 }
=20
@@ -2880,9 +2808,8 @@ void ath_tx_node_cleanup(struct ath_softc *sc, stru=
ct ath_node *an)
 	struct ath_txq *txq;
 	int tidno;
=20
-	for (tidno =3D 0, tid =3D &an->tid[tidno];
-	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
-
+	for (tidno =3D 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
+		tid =3D ath_node_to_tid(an, tidno);
 		txq =3D tid->txq;
=20
 		ath_txq_lock(sc, txq);
@@ -2894,6 +2821,9 @@ void ath_tx_node_cleanup(struct ath_softc *sc, stru=
ct ath_node *an)
 		tid->active =3D false;
=20
 		ath_txq_unlock(sc, txq);
+
+		if (!an->sta)
+			break; /* just one multicast ath_atx_tid */
 	}
 }
=20
--=20
2.9.3
