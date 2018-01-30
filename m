Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:39061 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751373AbeA3MHe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 07:07:34 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k will not tx packets sometimes.
In-Reply-To: <5A6FA79B.1080206@candelatech.com>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com> <87a7wzv43j.fsf@toke.dk> <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com> <87d11stk0i.fsf@toke.dk> <11a30dfe-842a-8b1e-0d7e-d4159bf4b2bb@candelatech.com> <871si81eev.fsf@toke.dk> <5A6FA79B.1080206@candelatech.com>
Date: Tue, 30 Jan 2018 13:07:32 +0100
Message-ID: <87h8r335yz.fsf@toke.dk> (sfid-20180130_130742_686871_DCAAC25E)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Ben Greear <greearb@candelatech.com> writes:

> Maybe there is some way for the scheduler to get stuck and not
> schedule anything?

It would appear so, yeah. Do you do anything special other than
associate a whole bunch of stations to trigger this? I can try to see if
I can script something that works equivalently on my setup.

I'm actually working on reworking that whole scheduler logic, and move
some of it into mac80211. Could you test this (WiP) patch and see if
that has the same problem?

-Toke


--=-=-=
Content-Type: text/x-patch; charset=utf-8
Content-Disposition: inline; filename=mac80211-add-txq-scheduling.patch
Content-Transfer-Encoding: quoted-printable

mac80211: Add TXQ scheduling API

From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

This adds an API to mac80211 to handle scheduling of TXQs and changes the
interface between driver and mac80211 for TXQ handling as follows:

- The wake_tx_queue callback interface no longer includes the TXQ. Instead,
  the driver is expected to retrieve that from ieee80211_next_txq()

- Two new mac80211 functions are added: ieee80211_next_txq() and
  ieee80211_schedule_txq(). The former returns the next TXQ that should be
  scheduled, and is how the driver gets a queue to pull packets from. The
  latter is called internally by mac80211 to start scheduling a queue, and
  the driver is supposed to call it to re-schedule the TXQ after it is
  finished pulling packets from it (unless the queue emptied).

The ath9k and ath10k drivers are changed to use the new API.

Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath10k/core.c |    2=20
 drivers/net/wireless/ath/ath10k/core.h |    4 -
 drivers/net/wireless/ath/ath10k/mac.c  |   55 +++------
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 -
 drivers/net/wireless/ath/ath9k/recv.c  |    2=20
 drivers/net/wireless/ath/ath9k/xmit.c  |  192 +++++++++-------------------=
----
 include/net/mac80211.h                 |   38 +++++-
 net/mac80211/agg-tx.c                  |    6 +
 net/mac80211/driver-ops.h              |   12 +-
 net/mac80211/ieee80211_i.h             |    8 +
 net/mac80211/main.c                    |    3 +
 net/mac80211/sta_info.c                |    3 -
 net/mac80211/trace.h                   |   19 +--
 net/mac80211/tx.c                      |   57 +++++++++-
 14 files changed, 187 insertions(+), 218 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/=
ath/ath10k/core.c
index 6d065f8d7f78..042175a5653f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2655,9 +2655,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, s=
truct device *dev,
=20
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
-	spin_lock_init(&ar->txqs_lock);
=20
-	INIT_LIST_HEAD(&ar->txqs);
 	INIT_LIST_HEAD(&ar->peers);
 	init_waitqueue_head(&ar->peer_mapping_wq);
 	init_waitqueue_head(&ar->htt.empty_tx_wq);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/=
ath/ath10k/core.h
index 631df2137e25..398cd3c57139 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -346,7 +346,6 @@ struct ath10k_peer {
 };
=20
 struct ath10k_txq {
-	struct list_head list;
 	unsigned long num_fw_queued;
 	unsigned long num_push_allowed;
 };
@@ -896,10 +895,7 @@ struct ath10k {
=20
 	/* protects shared structure data */
 	spinlock_t data_lock;
-	/* protects: ar->txqs, artxq->list */
-	spinlock_t txqs_lock;
=20
-	struct list_head txqs;
 	struct list_head arvifs;
 	struct list_head peers;
 	struct ath10k_peer *peer_map[ATH10K_MAX_NUM_PEER_IDS];
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/a=
th/ath10k/mac.c
index 75726f12a31c..e5dd97da3fa1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3832,12 +3832,10 @@ static void ath10k_mac_txq_init(struct ieee80211_tx=
q *txq)
 		return;
=20
 	artxq =3D (void *)txq->drv_priv;
-	INIT_LIST_HEAD(&artxq->list);
 }
=20
 static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *=
txq)
 {
-	struct ath10k_txq *artxq;
 	struct ath10k_skb_cb *cb;
 	struct sk_buff *msdu;
 	int msdu_id;
@@ -3845,12 +3843,6 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, =
struct ieee80211_txq *txq)
 	if (!txq)
 		return;
=20
-	artxq =3D (void *)txq->drv_priv;
-	spin_lock_bh(&ar->txqs_lock);
-	if (!list_empty(&artxq->list))
-		list_del_init(&artxq->list);
-	spin_unlock_bh(&ar->txqs_lock);
-
 	spin_lock_bh(&ar->htt.tx_lock);
 	idr_for_each_entry(&ar->htt.pending_tx, msdu, msdu_id) {
 		cb =3D ATH10K_SKB_CB(msdu);
@@ -3980,23 +3972,17 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 void ath10k_mac_tx_push_pending(struct ath10k *ar)
 {
 	struct ieee80211_hw *hw =3D ar->hw;
-	struct ieee80211_txq *txq;
-	struct ath10k_txq *artxq;
-	struct ath10k_txq *last;
+	struct ieee80211_txq *txq, *first =3D NULL;
 	int ret;
 	int max;
=20
 	if (ar->htt.num_pending_tx >=3D (ar->htt.max_num_pending_tx / 2))
 		return;
=20
-	spin_lock_bh(&ar->txqs_lock);
 	rcu_read_lock();
=20
-	last =3D list_last_entry(&ar->txqs, struct ath10k_txq, list);
-	while (!list_empty(&ar->txqs)) {
-		artxq =3D list_first_entry(&ar->txqs, struct ath10k_txq, list);
-		txq =3D container_of((void *)artxq, struct ieee80211_txq,
-				   drv_priv);
+	txq =3D ieee80211_next_txq(hw, -1);
+	while (txq) {
=20
 		/* Prevent aggressive sta/tid taking over tx queue */
 		max =3D 16;
@@ -4007,18 +3993,21 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 				break;
 		}
=20
-		list_del_init(&artxq->list);
 		if (ret !=3D -ENOENT)
-			list_add_tail(&artxq->list, &ar->txqs);
+			ieee80211_schedule_txq(hw, txq);
=20
 		ath10k_htt_tx_txq_update(hw, txq);
=20
-		if (artxq =3D=3D last || (ret < 0 && ret !=3D -ENOENT))
+		if (first =3D=3D txq || (ret < 0 && ret !=3D -ENOENT))
 			break;
+
+		if (!first && ret !=3D -ENOENT)
+			first =3D txq;
+
+		txq =3D ieee80211_next_txq(hw, -1);
 	}
=20
 	rcu_read_unlock();
-	spin_unlock_bh(&ar->txqs_lock);
 }
=20
 /************/
@@ -4252,34 +4241,22 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *h=
w,
 	}
 }
=20
-static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
-					struct ieee80211_txq *txq)
+static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw, u8 acno)
 {
-	struct ath10k *ar =3D hw->priv;
-	struct ath10k_txq *artxq =3D (void *)txq->drv_priv;
-	struct ieee80211_txq *f_txq;
-	struct ath10k_txq *f_artxq;
+	struct ieee80211_txq *txq;
 	int ret =3D 0;
 	int max =3D 16;
=20
-	spin_lock_bh(&ar->txqs_lock);
-	if (list_empty(&artxq->list))
-		list_add_tail(&artxq->list, &ar->txqs);
-
-	f_artxq =3D list_first_entry(&ar->txqs, struct ath10k_txq, list);
-	f_txq =3D container_of((void *)f_artxq, struct ieee80211_txq, drv_priv);
-	list_del_init(&f_artxq->list);
+	txq =3D ieee80211_next_txq(hw, acno);
=20
-	while (ath10k_mac_tx_can_push(hw, f_txq) && max--) {
-		ret =3D ath10k_mac_tx_push_txq(hw, f_txq);
+	while (ath10k_mac_tx_can_push(hw, txq) && max--) {
+		ret =3D ath10k_mac_tx_push_txq(hw, txq);
 		if (ret)
 			break;
 	}
 	if (ret !=3D -ENOENT)
-		list_add_tail(&f_artxq->list, &ar->txqs);
-	spin_unlock_bh(&ar->txqs_lock);
+		ieee80211_schedule_txq(hw, txq);
=20
-	ath10k_htt_tx_txq_update(hw, f_txq);
 	ath10k_htt_tx_txq_update(hw, txq);
 }
=20
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/=
ath/ath9k/ath9k.h
index ef0de4f1312c..43c2f6966366 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -246,10 +246,8 @@ struct ath_atx_tid {
 	s8 bar_index;
 	bool active;
 	bool clear_ps_filter;
-	bool has_queued;
 };
=20
-void __ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
 void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
=20
 struct ath_node {
@@ -618,7 +616,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw =
*hw,
 				   u16 tids, int nframes,
 				   enum ieee80211_frame_release_type reason,
 				   bool more_data);
-void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *qu=
eue);
+void ath9k_wake_tx_queue(struct ieee80211_hw *hw, u8 acno);
=20
 /********/
 /* VIFs */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/a=
th/ath9k/recv.c
index 2197aee2bb72..2032690a1335 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1058,7 +1058,7 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 		spin_lock_bh(&acq->lock);
 		an->airtime_deficit[acno] -=3D airtime;
 		if (an->airtime_deficit[acno] <=3D 0)
-			__ath_tx_queue_tid(sc, ATH_AN_2_TID(an, tidno));
+			ath_tx_queue_tid(sc, ATH_AN_2_TID(an, tidno));
 		spin_unlock_bh(&acq->lock);
 	}
 	ath_debug_airtime(sc, an, airtime, 0);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/a=
th/ath9k/xmit.c
index 396bf05c6bf6..9e8bc99079a1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -112,61 +112,24 @@ void ath_txq_unlock_complete(struct ath_softc *sc, st=
ruct ath_txq *txq)
 		ath_tx_status(hw, skb);
 }
=20
-void __ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
-{
-	struct ath_vif *avp =3D (struct ath_vif *) tid->an->vif->drv_priv;
-	struct ath_chanctx *ctx =3D avp->chanctx;
-	struct ath_acq *acq;
-	struct list_head *tid_list;
-	u8 acno =3D TID_TO_WME_AC(tid->tidno);
-
-	if (!ctx || !list_empty(&tid->list))
-		return;
-
-
-	acq =3D &ctx->acq[acno];
-	if ((sc->airtime_flags & AIRTIME_USE_NEW_QUEUES) &&
-	    tid->an->airtime_deficit[acno] > 0)
-		tid_list =3D &acq->acq_new;
-	else
-		tid_list =3D &acq->acq_old;
-
-	list_add_tail(&tid->list, tid_list);
-}
-
 void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_vif *avp =3D (struct ath_vif *) tid->an->vif->drv_priv;
-	struct ath_chanctx *ctx =3D avp->chanctx;
-	struct ath_acq *acq;
+	struct ieee80211_txq *queue =3D container_of(
+		(void *)tid, struct ieee80211_txq, drv_priv);
=20
-	if (!ctx || !list_empty(&tid->list))
-		return;
-
-	acq =3D &ctx->acq[TID_TO_WME_AC(tid->tidno)];
-	spin_lock_bh(&acq->lock);
-	__ath_tx_queue_tid(sc, tid);
-	spin_unlock_bh(&acq->lock);
+	ieee80211_schedule_txq(sc->hw, queue);
 }
=20
-
-void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *qu=
eue)
+void ath9k_wake_tx_queue(struct ieee80211_hw *hw, u8 acno)
 {
 	struct ath_softc *sc =3D hw->priv;
 	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
-	struct ath_atx_tid *tid =3D (struct ath_atx_tid *) queue->drv_priv;
-	struct ath_txq *txq =3D tid->txq;
+	struct ath_txq *txq =3D sc->tx.txq_map[acno];
=20
-	ath_dbg(common, QUEUE, "Waking TX queue: %pM (%d)\n",
-		queue->sta ? queue->sta->addr : queue->vif->addr,
-		tid->tidno);
+	ath_dbg(common, QUEUE, "Waking TX queue: %d\n", acno);
=20
 	ath_txq_lock(sc, txq);
-
-	tid->has_queued =3D true;
-	ath_tx_queue_tid(sc, tid);
 	ath_txq_schedule(sc, txq);
-
 	ath_txq_unlock(sc, txq);
 }
=20
@@ -230,14 +193,9 @@ ath_tid_pull(struct ath_atx_tid *tid)
 	struct ath_frame_info *fi;
 	int q;
=20
-	if (!tid->has_queued)
-		return NULL;
-
 	skb =3D ieee80211_tx_dequeue(hw, txq);
-	if (!skb) {
-		tid->has_queued =3D false;
+	if (!skb)
 		return NULL;
-	}
=20
 	if (ath_tx_prepare(hw, skb, &txctl)) {
 		ieee80211_free_txskb(hw, skb);
@@ -254,12 +212,6 @@ ath_tid_pull(struct ath_atx_tid *tid)
 	return skb;
  }
=20
-
-static bool ath_tid_has_buffered(struct ath_atx_tid *tid)
-{
-	return !skb_queue_empty(&tid->retry_q) || tid->has_queued;
-}
-
 static struct sk_buff *ath_tid_dequeue(struct ath_atx_tid *tid)
 {
 	struct sk_buff *skb;
@@ -672,7 +624,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, =
struct ath_txq *txq,
 		skb_queue_splice_tail(&bf_pending, &tid->retry_q);
 		if (!an->sleeping) {
 			ath_tx_queue_tid(sc, tid);
-
 			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 				tid->clear_ps_filter =3D true;
 		}
@@ -720,7 +671,7 @@ static void ath_tx_count_airtime(struct ath_softc *sc, =
struct ath_node *an,
 		spin_lock_bh(&acq->lock);
 		an->airtime_deficit[q] -=3D airtime;
 		if (an->airtime_deficit[q] <=3D 0)
-			__ath_tx_queue_tid(sc, tid);
+			ath_tx_queue_tid(sc, tid);
 		spin_unlock_bh(&acq->lock);
 	}
 	ath_debug_airtime(sc, an, 0, airtime);
@@ -937,20 +888,20 @@ static int ath_compute_num_delims(struct ath_softc *s=
c, struct ath_atx_tid *tid,
 	return ndelim;
 }
=20
-static struct ath_buf *
+static int
 ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
-			struct ath_atx_tid *tid)
+			struct ath_atx_tid *tid, struct ath_buf **buf)
 {
 	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
-	struct sk_buff *skb, *first_skb =3D NULL;
 	struct ath_buf *bf;
+	struct sk_buff *skb, *first_skb =3D NULL;
 	u16 seqno;
=20
 	while (1) {
 		skb =3D ath_tid_dequeue(tid);
 		if (!skb)
-			break;
+			return -ENOENT;
=20
 		fi =3D get_frame_info(skb);
 		bf =3D fi->bf;
@@ -981,7 +932,7 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct at=
h_txq *txq,
=20
 		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
 			bf->bf_state.bf_type =3D 0;
-			return bf;
+			break;
 		}
=20
 		bf->bf_state.bf_type =3D BUF_AMPDU | BUF_AGGR;
@@ -1000,7 +951,7 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct a=
th_txq *txq,
 					first_skb =3D skb;
 				continue;
 			}
-			break;
+			return -EBUSY;
 		}
=20
 		if (tid->bar_index > ATH_BA_INDEX(tid->seq_start, seqno)) {
@@ -1014,10 +965,11 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct=
 ath_txq *txq,
 			continue;
 		}
=20
-		return bf;
+		break;
 	}
=20
-	return NULL;
+	*buf =3D bf;
+	return 0;
 }
=20
 static int
@@ -1027,7 +979,7 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_txq =
*txq,
 {
 #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
 	struct ath_buf *bf =3D bf_first, *bf_prev =3D NULL;
-	int nframes =3D 0, ndelim;
+	int nframes =3D 0, ndelim, ret;
 	u16 aggr_limit =3D 0, al =3D 0, bpad =3D 0,
 	    al_delta, h_baw =3D tid->baw_size / 2;
 	struct ieee80211_tx_info *tx_info;
@@ -1081,7 +1033,9 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_txq=
 *txq,
=20
 		bf_prev =3D bf;
=20
-		bf =3D ath_tx_get_tid_subframe(sc, txq, tid);
+		ret =3D ath_tx_get_tid_subframe(sc, txq, tid, &bf);
+		if (ret < 0)
+			break;
 	}
 	goto finish;
 stop:
@@ -1478,7 +1432,7 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_tx=
q *txq,
 		  struct ath_buf *bf_first)
 {
 	struct ath_buf *bf =3D bf_first, *bf_prev =3D NULL;
-	int nframes =3D 0;
+	int nframes =3D 0, ret;
=20
 	do {
 		struct ieee80211_tx_info *tx_info;
@@ -1492,8 +1446,8 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_tx=
q *txq,
 		if (nframes >=3D 2)
 			break;
=20
-		bf =3D ath_tx_get_tid_subframe(sc, txq, tid);
-		if (!bf)
+		ret =3D ath_tx_get_tid_subframe(sc, txq, tid, &bf);
+		if (ret < 0)
 			break;
=20
 		tx_info =3D IEEE80211_SKB_CB(bf->bf_mpdu);
@@ -1506,30 +1460,27 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_=
txq *txq,
 	} while (1);
 }
=20
-static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
-			      struct ath_atx_tid *tid)
+static int ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
+			     struct ath_atx_tid *tid)
 {
-	struct ath_buf *bf;
+	struct ath_buf *bf =3D NULL;
 	struct ieee80211_tx_info *tx_info;
 	struct list_head bf_q;
-	int aggr_len =3D 0;
+	int aggr_len =3D 0, ret;
 	bool aggr;
=20
-	if (!ath_tid_has_buffered(tid))
-		return false;
-
 	INIT_LIST_HEAD(&bf_q);
=20
-	bf =3D ath_tx_get_tid_subframe(sc, txq, tid);
-	if (!bf)
-		return false;
+	ret =3D ath_tx_get_tid_subframe(sc, txq, tid, &bf);
+	if (ret < 0)
+		return ret;
=20
 	tx_info =3D IEEE80211_SKB_CB(bf->bf_mpdu);
 	aggr =3D !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 	if ((aggr && txq->axq_ampdu_depth >=3D ATH_AGGR_MIN_QDEPTH) ||
 	    (!aggr && txq->axq_depth >=3D ATH_NON_AGGR_MIN_QDEPTH)) {
 		__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
-		return false;
+		return -EBUSY;
 	}
=20
 	ath_set_rates(tid->an->vif, tid->an->sta, bf);
@@ -1539,7 +1490,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, s=
truct ath_txq *txq,
 		ath_tx_form_burst(sc, txq, tid, &bf_q, bf);
=20
 	if (list_empty(&bf_q))
-		return false;
+		return -EAGAIN;
=20
 	if (tid->clear_ps_filter || tid->an->no_ps_filter) {
 		tid->clear_ps_filter =3D false;
@@ -1548,7 +1499,7 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, s=
truct ath_txq *txq,
=20
 	ath_tx_fill_desc(sc, bf, txq, aggr_len);
 	ath_tx_txqaddbuf(sc, txq, &bf_q, false);
-	return true;
+	return 0;
 }
=20
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
@@ -1611,28 +1562,16 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, s=
truct ath_softc *sc,
 {
 	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *tid;
-	struct ath_txq *txq;
 	int tidno;
=20
 	ath_dbg(common, XMIT, "%s called\n", __func__);
=20
 	for (tidno =3D 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid =3D ath_node_to_tid(an, tidno);
-		txq =3D tid->txq;
-
-		ath_txq_lock(sc, txq);
-
-		if (list_empty(&tid->list)) {
-			ath_txq_unlock(sc, txq);
-			continue;
-		}
=20
 		if (!skb_queue_empty(&tid->retry_q))
 			ieee80211_sta_set_buffered(sta, tid->tidno, true);
=20
-		list_del_init(&tid->list);
-
-		ath_txq_unlock(sc, txq);
 	}
 }
=20
@@ -1651,11 +1590,12 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struc=
t ath_node *an)
=20
 		ath_txq_lock(sc, txq);
 		tid->clear_ps_filter =3D true;
-		if (ath_tid_has_buffered(tid)) {
+		if (!skb_queue_empty(&tid->retry_q)) {
 			ath_tx_queue_tid(sc, tid);
 			ath_txq_schedule(sc, txq);
 		}
 		ath_txq_unlock_complete(sc, txq);
+
 	}
 }
=20
@@ -1670,9 +1610,9 @@ void ath9k_release_buffered_frames(struct ieee80211_h=
w *hw,
 	struct ath_txq *txq =3D sc->tx.uapsdq;
 	struct ieee80211_tx_info *info;
 	struct list_head bf_q;
-	struct ath_buf *bf_tail =3D NULL, *bf;
+	struct ath_buf *bf_tail =3D NULL, *bf =3D NULL;
 	int sent =3D 0;
-	int i;
+	int i, ret;
=20
 	INIT_LIST_HEAD(&bf_q);
 	for (i =3D 0; tids && nframes; i++, tids >>=3D 1) {
@@ -1685,8 +1625,8 @@ void ath9k_release_buffered_frames(struct ieee80211_h=
w *hw,
=20
 		ath_txq_lock(sc, tid->txq);
 		while (nframes > 0) {
-			bf =3D ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid);
-			if (!bf)
+			ret =3D ath_tx_get_tid_subframe(sc, sc->tx.uapsdq, tid, &bf);
+			if (ret < 0)
 				break;
=20
 			list_add_tail(&bf->list, &bf_q);
@@ -1950,11 +1890,12 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct a=
th_txq *txq)
  */
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
+	struct ieee80211_hw *hw =3D sc->hw;
 	struct ath_common *common =3D ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_txq *queue;
 	struct ath_atx_tid *tid;
-	struct list_head *tid_list;
-	struct ath_acq *acq;
 	bool active =3D AIRTIME_ACTIVE(sc->airtime_flags);
+	int ret;
=20
 	if (txq->mac80211_qnum < 0)
 		return;
@@ -1964,52 +1905,30 @@ void ath_txq_schedule(struct ath_softc *sc, struct =
ath_txq *txq)
=20
 	spin_lock_bh(&sc->chan_lock);
 	rcu_read_lock();
-	acq =3D &sc->cur_chan->acq[txq->mac80211_qnum];
=20
 	if (sc->cur_chan->stopped)
 		goto out;
=20
 begin:
-	tid_list =3D &acq->acq_new;
-	if (list_empty(tid_list)) {
-		tid_list =3D &acq->acq_old;
-		if (list_empty(tid_list))
-			goto out;
-	}
-	tid =3D list_first_entry(tid_list, struct ath_atx_tid, list);
+	queue =3D ieee80211_next_txq(hw, txq->mac80211_qnum);
+	if (!queue)
+		goto out;
+
+	tid =3D (struct ath_atx_tid *) queue->drv_priv;
=20
 	if (active && tid->an->airtime_deficit[txq->mac80211_qnum] <=3D 0) {
-		spin_lock_bh(&acq->lock);
 		tid->an->airtime_deficit[txq->mac80211_qnum] +=3D ATH_AIRTIME_QUANTUM;
-		list_move_tail(&tid->list, &acq->acq_old);
-		spin_unlock_bh(&acq->lock);
+		ieee80211_schedule_txq(hw, queue);
 		goto begin;
 	}
=20
-	if (!ath_tid_has_buffered(tid)) {
-		spin_lock_bh(&acq->lock);
-		if ((tid_list =3D=3D &acq->acq_new) && !list_empty(&acq->acq_old))
-			list_move_tail(&tid->list, &acq->acq_old);
-		else {
-			list_del_init(&tid->list);
-		}
-		spin_unlock_bh(&acq->lock);
+	ret =3D ath_tx_sched_aggr(sc, txq, tid);
+	ath_dbg(common, QUEUE, "ath_tx_sched_aggr returned %d\n",
+		ret);
+	if (ret !=3D -ENOENT)
+		ieee80211_schedule_txq(hw, queue);
+	if (ret !=3D -EBUSY)
 		goto begin;
-	}
-
-
-	/*
-	 * If we succeed in scheduling something, immediately restart to make
-	 * sure we keep the HW busy.
-	 */
-	if(ath_tx_sched_aggr(sc, txq, tid)) {
-		if (!active) {
-			spin_lock_bh(&acq->lock);
-			list_move_tail(&tid->list, &acq->acq_old);
-			spin_unlock_bh(&acq->lock);
-		}
-		goto begin;
-	}
=20
 out:
 	rcu_read_unlock();
@@ -2875,7 +2794,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct at=
h_node *an)
 		tid->baw_head  =3D tid->baw_tail =3D 0;
 		tid->active	   =3D false;
 		tid->clear_ps_filter =3D true;
-		tid->has_queued  =3D false;
 		__skb_queue_head_init(&tid->retry_q);
 		INIT_LIST_HEAD(&tid->list);
 		acno =3D TID_TO_WME_AC(tidno);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 906e90223066..842feae31277 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -105,9 +105,12 @@
  * The driver is expected to initialize its private per-queue data for sta=
tions
  * and interfaces in the .add_interface and .sta_add ops.
  *
- * The driver can't access the queue directly. To dequeue a frame, it calls
- * ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a queue, =
it
- * calls the .wake_tx_queue driver op.
+ * The driver can't access the queue directly. To obtain the next queue to=
 pull
+ * frames from, the driver calls ieee80211_next_txq(). To dequeue a frame =
from a
+ * txq, it calls ieee80211_tx_dequeue(). Whenever mac80211 adds a new fram=
e to a
+ * queue, it calls the .wake_tx_queue driver op. The driver is expected to
+ * re-schedule the txq using ieee80211_schedule_txq() if it is still active
+ * after the driver has finished pulling packets from it.
  *
  * For AP powersave TIM handling, the driver only needs to indicate if it =
has
  * buffered packets in the driver specific data structures by calling
@@ -3731,8 +3734,7 @@ struct ieee80211_ops {
 					 struct ieee80211_vif *vif,
 					 struct ieee80211_tdls_ch_sw_params *params);
=20
-	void (*wake_tx_queue)(struct ieee80211_hw *hw,
-			      struct ieee80211_txq *txq);
+	void (*wake_tx_queue)(struct ieee80211_hw *hw, u8 acno);
 	void (*sync_rx_queues)(struct ieee80211_hw *hw);
=20
 	int (*start_nan)(struct ieee80211_hw *hw,
@@ -5883,13 +5885,37 @@ void ieee80211_unreserve_tid(struct ieee80211_sta *=
sta, u8 tid);
  * ieee80211_tx_dequeue - dequeue a packet from a software tx queue
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
- * @txq: pointer obtained from station or virtual interface
+ * @txq: pointer obtained from ieee80211_next_txq()
  *
  * Returns the skb if successful, %NULL if no frame was available.
  */
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq);
=20
+/**
+ * ieee80211_schedule_txq - add txq to scheduling loop
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ * Returns %true if the txq was actually added to the scheduling,
+ * %false otherwise.
+ */
+bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			    struct ieee80211_txq *txq);
+
+/**
+ * ieee80211_next_txq - get next tx queue to pull packets from
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @acno: filter returned txqs with this AC number. Pass -1 for no filteri=
ng.
+ *
+ * Returns the next txq if successful, %NULL if no queue is eligible. If a=
 txq
+ * is returned, it will have been removed from the scheduler queue and nee=
ds to
+ * be re-scheduled with ieee80211_schedule_txq() to continue to be active.
+ */
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 acno);
+
 /**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 595c662a61e8..efbfb8cfb503 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -226,9 +226,13 @@ ieee80211_agg_start_txq(struct sta_info *sta, int tid,=
 bool enable)
 		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
=20
 	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
+
+	if (!ieee80211_schedule_txq(&sta->sdata->local->hw, txq))
+		return;
+
 	local_bh_disable();
 	rcu_read_lock();
-	drv_wake_tx_queue(sta->sdata->local, txqi);
+	drv_wake_tx_queue(sta->sdata->local, txq->ac);
 	rcu_read_unlock();
 	local_bh_enable();
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4d82fe7d627c..0c58dd8c947d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1159,16 +1159,10 @@ drv_tdls_recv_channel_switch(struct ieee80211_local=
 *local,
 	trace_drv_return_void(local);
 }
=20
-static inline void drv_wake_tx_queue(struct ieee80211_local *local,
-				     struct txq_info *txq)
+static inline void drv_wake_tx_queue(struct ieee80211_local *local, u8 acn=
o)
 {
-	struct ieee80211_sub_if_data *sdata =3D vif_to_sdata(txq->txq.vif);
-
-	if (!check_sdata_in_driver(sdata))
-		return;
-
-	trace_drv_wake_tx_queue(local, sdata, txq);
-	local->ops->wake_tx_queue(&local->hw, &txq->txq);
+	trace_drv_wake_tx_queue(local, acno);
+	local->ops->wake_tx_queue(&local->hw, acno);
 }
=20
 static inline int drv_start_nan(struct ieee80211_local *local,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 26900025de2f..cc7d9299658d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -832,6 +832,7 @@ struct txq_info {
 	struct codel_vars def_cvars;
 	struct codel_stats cstats;
 	struct sk_buff_head frags;
+	struct list_head schedule_order;
 	unsigned long flags;
=20
 	/* keep last! */
@@ -1112,6 +1113,9 @@ enum mac80211_scan_state {
 	SCAN_ABORT,
 };
=20
+struct ieee80211_txq_list {
+};
+
 struct ieee80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
@@ -1122,6 +1126,10 @@ struct ieee80211_local {
 	struct codel_vars *cvars;
 	struct codel_params cparams;
=20
+	/* protects active_txqs and txqi->schedule_order */
+	spinlock_t active_txq_lock;
+	struct list_head active_txqs;
+
 	const struct ieee80211_ops *ops;
=20
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0785d04a80bc..935d6e2491b1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -619,6 +619,9 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_=
data_len,
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
=20
+	INIT_LIST_HEAD(&local->active_txqs);
+	spin_lock_init(&local->active_txq_lock);
+
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
=20
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0c5627f8a104..7601c2871175 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1241,7 +1241,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info =
*sta)
 			if (!txq_has_queue(sta->sta.txq[i]))
 				continue;
=20
-			drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
+			ieee80211_schedule_txq(&local->hw, sta->sta.txq[i]);
+			drv_wake_tx_queue(local, sta->sta.txq[i]->ac);
 		}
 	}
=20
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 591ad02e1fa4..23bdc4dcc908 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2552,32 +2552,23 @@ TRACE_EVENT(drv_tdls_recv_channel_switch,
=20
 TRACE_EVENT(drv_wake_tx_queue,
 	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
-		 struct txq_info *txq),
+		 u8 ac),
=20
-	TP_ARGS(local, sdata, txq),
+	TP_ARGS(local, ac),
=20
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		VIF_ENTRY
-		STA_ENTRY
 		__field(u8, ac)
-		__field(u8, tid)
 	),
=20
 	TP_fast_assign(
-		struct ieee80211_sta *sta =3D txq->txq.sta;
-
 		LOCAL_ASSIGN;
-		VIF_ASSIGN;
-		STA_ASSIGN;
-		__entry->ac =3D txq->txq.ac;
-		__entry->tid =3D txq->txq.tid;
+		__entry->ac =3D ac;
 	),
=20
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " ac:%d tid:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->ac, __entry->tid
+		LOCAL_PR_FMT " ac:%d",
+		LOCAL_PR_ARG, __entry->ac
 	)
 );
=20
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 25904af38839..0ab69e5b87ad 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1439,6 +1439,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data =
*sdata,
 	codel_vars_init(&txqi->def_cvars);
 	codel_stats_init(&txqi->cstats);
 	__skb_queue_head_init(&txqi->frags);
+	INIT_LIST_HEAD(&txqi->schedule_order);
=20
 	txqi->txq.vif =3D &sdata->vif;
=20
@@ -1462,6 +1463,9 @@ void ieee80211_txq_purge(struct ieee80211_local *loca=
l,
=20
 	fq_tin_reset(fq, tin, fq_skb_free_func);
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+	spin_lock_bh(&local->active_txq_lock);
+	list_del_init(&txqi->schedule_order);
+	spin_unlock_bh(&local->active_txq_lock);
 }
=20
 int ieee80211_txq_setup_flows(struct ieee80211_local *local)
@@ -1558,7 +1562,8 @@ static bool ieee80211_queue_skb(struct ieee80211_loca=
l *local,
 	ieee80211_txq_enqueue(local, txqi, skb);
 	spin_unlock_bh(&fq->lock);
=20
-	drv_wake_tx_queue(local, txqi);
+	ieee80211_schedule_txq(&local->hw, &txqi->txq);
+	drv_wake_tx_queue(local, txqi->txq.ac);
=20
 	return true;
 }
@@ -3553,6 +3558,56 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee8021=
1_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
=20
+bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			    struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local =3D hw_to_local(hw);
+	struct txq_info *txqi =3D to_txq_info(txq);
+	bool ret =3D false;
+
+	spin_lock_bh(&local->active_txq_lock);
+
+	if (list_empty(&txqi->schedule_order)) {
+		list_add_tail(&txqi->schedule_order, &local->active_txqs);
+		ret =3D true;
+	}
+
+	spin_unlock_bh(&local->active_txq_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(ieee80211_schedule_txq);
+
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 acno)
+{
+	struct ieee80211_local *local =3D hw_to_local(hw);
+	struct txq_info *txqi =3D NULL;
+
+	spin_lock_bh(&local->active_txq_lock);
+
+	if (list_empty(&local->active_txqs))
+		goto out;
+
+	list_for_each_entry(txqi, &local->active_txqs, schedule_order) {
+		if (acno < 0 || txqi->txq.ac =3D=3D acno) {
+			list_del_init(&txqi->schedule_order);
+			goto out;
+		}
+	}
+
+	/* no txq with requested acno found */
+	txqi =3D NULL;
+
+out:
+	spin_unlock_bh(&local->active_txq_lock);
+
+	if (!txqi)
+		return NULL;
+
+	return &txqi->txq;
+}
+EXPORT_SYMBOL(ieee80211_next_txq);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)

--=-=-=--
