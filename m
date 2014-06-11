Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11826 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaFKKun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:50:43 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 27/28] ath9k: use separate HW queue for each channel context
Date: Wed, 11 Jun 2014 16:18:15 +0530
Message-ID: <1402483696-2498-28-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_130501_916983_7E348C0C)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use seperate tx queue for each AC in each channel context and expose
these information to mac80211 to avoid stopping one channel context
leads to stopping the entire traffic for that AC even on other contexts.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/init.c  | 10 ++++++-
 drivers/net/wireless/ath/ath9k/main.c  | 48 ++++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/xmit.c  | 11 +++++---
 4 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 757dd60..11b5e4d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -327,6 +327,7 @@ struct ath_chanctx {
 	struct cfg80211_chan_def chandef;
 	struct list_head vifs;
 	struct list_head acq[IEEE80211_NUM_ACS];
+	int hw_queue_base;
 
 	/* do not dereference, use for comparison only */
 	struct ieee80211_vif *primary_sta;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a4afcb1..7afb405 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -511,6 +511,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	sc->tx99_power = MAX_RATE_POWER + 1;
 	init_waitqueue_head(&sc->tx_wait);
 	sc->cur_chan = &sc->chanctx[0];
+	if (!ath9k_use_chanctx)
+		sc->cur_chan->hw_queue_base = 0;
 
 	if (!pdata || pdata->use_eeprom) {
 		ah->ah_flags |= AH_USE_EEPROM;
@@ -718,6 +720,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SUPPORTS_RC_TABLE |
+		IEEE80211_HW_QUEUE_CONTROL |
 		IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
 
 	if (ath9k_ps_enable)
@@ -769,7 +772,12 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 
-	hw->queues = 4;
+	/* allow 4 queues per channel context +
+	 * 1 cab queue + 1 offchannel tx queue
+	 */
+	hw->queues = 10;
+	/* last queue for offchannel */
+	hw->offchannel_tx_hw_queue = hw->queues - 1;
 	hw->max_rates = 4;
 	hw->max_listen_interval = 1;
 	hw->max_rate_tries = 10;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b307e6e..cf21652 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -223,6 +223,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long flags;
+	int i;
 
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
@@ -267,7 +268,20 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
 
-	ieee80211_wake_queues(sc->hw);
+	if (!ath9k_use_chanctx)
+		ieee80211_wake_queues(sc->hw);
+	else {
+		if (sc->cur_chan == &sc->offchannel.chan)
+			ieee80211_wake_queue(sc->hw,
+					sc->hw->offchannel_tx_hw_queue);
+		else {
+			for (i = 0; i < IEEE80211_NUM_ACS; i++)
+				ieee80211_wake_queue(sc->hw,
+					sc->cur_chan->hw_queue_base + i);
+		}
+		if (ah->opmode == NL80211_IFTYPE_AP)
+			ieee80211_wake_queue(sc->hw, sc->hw->queues - 2);
+	}
 
 	ath9k_p2p_ps_timer(sc);
 
@@ -1108,6 +1122,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_node *an = &avp->mcast_node;
+	int i;
 
 	mutex_lock(&sc->mutex);
 
@@ -1130,6 +1145,12 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		avp->chanctx = sc->cur_chan;
 		list_add_tail(&avp->list, &avp->chanctx->vifs);
 	}
+	for (i = 0; i < IEEE80211_NUM_ACS; i++)
+		vif->hw_queue[i] = i;
+	if (vif->type == NL80211_IFTYPE_AP)
+		vif->cab_queue = hw->queues - 2;
+	else
+		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
 
 	an->sc = sc;
 	an->sta = NULL;
@@ -1149,6 +1170,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
+	int i;
 
 	mutex_lock(&sc->mutex);
 
@@ -1168,6 +1190,14 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
 
+	for (i = 0; i < IEEE80211_NUM_ACS; i++)
+		vif->hw_queue[i] = i;
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		vif->cab_queue = hw->queues - 2;
+	else
+		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
+
 	ath9k_calculate_summary_state(sc, avp->chanctx);
 
 	mutex_unlock(&sc->mutex);
@@ -1984,6 +2014,7 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int timeout = HZ / 5; /* 200 ms */
 	bool drain_txq;
+	int i;
 
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 
@@ -2011,7 +2042,10 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 			ath_reset(sc);
 
 		ath9k_ps_restore(sc);
-		ieee80211_wake_queues(hw);
+		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+			ieee80211_wake_queue(sc->hw,
+					     sc->cur_chan->hw_queue_base + i);
+		}
 	}
 
 	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
@@ -2468,6 +2502,7 @@ static int ath9k_add_chanctx(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_chanctx *ctx, **ptr;
+	int pos;
 
 	mutex_lock(&sc->mutex);
 
@@ -2478,6 +2513,8 @@ static int ath9k_add_chanctx(struct ieee80211_hw *hw,
 		ptr = (void *) conf->drv_priv;
 		*ptr = ctx;
 		ctx->assigned = true;
+		pos = ctx - &sc->chanctx[0];
+		ctx->hw_queue_base = pos * IEEE80211_NUM_ACS;
 		ath_chanctx_set_channel(sc, ctx, &conf->def);
 		mutex_unlock(&sc->mutex);
 		return 0;
@@ -2495,6 +2532,7 @@ static void ath9k_remove_chanctx(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 	ctx->assigned = false;
+	ctx->hw_queue_base = -1;
 	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_UNASSIGN);
 	mutex_unlock(&sc->mutex);
 }
@@ -2518,11 +2556,14 @@ static int ath9k_assign_vif_chanctx(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_chanctx *ctx = ath_chanctx_get(conf);
+	int i;
 
 	mutex_lock(&sc->mutex);
 	avp->chanctx = ctx;
 	list_add_tail(&avp->list, &ctx->vifs);
 	ath9k_calculate_summary_state(sc, ctx);
+	for (i = 0; i < IEEE80211_NUM_ACS; i++)
+		vif->hw_queue[i] = ctx->hw_queue_base + i;
 	mutex_unlock(&sc->mutex);
 
 	return 0;
@@ -2535,11 +2576,14 @@ static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_chanctx *ctx = ath_chanctx_get(conf);
+	int ac;
 
 	mutex_lock(&sc->mutex);
 	avp->chanctx = NULL;
 	list_del(&avp->list);
 	ath9k_calculate_summary_state(sc, ctx);
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		vif->hw_queue[ac] = IEEE80211_INVAL_HW_QUEUE;
 	mutex_unlock(&sc->mutex);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a422c20..d4927c9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -156,7 +156,8 @@ static void ath_set_rates(struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 			     struct sk_buff *skb)
 {
-	int q;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int q, hw_queue;
 
 	q = skb_get_queue_mapping(skb);
 	if (txq == sc->tx.uapsdq)
@@ -168,9 +169,10 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 	if (WARN_ON(--txq->pending_frames < 0))
 		txq->pending_frames = 0;
 
+	hw_queue = (info->hw_queue >= sc->hw->queues - 2) ? q : info->hw_queue;
 	if (txq->stopped &&
 	    txq->pending_frames < sc->tx.txq_max_pending[q]) {
-		ieee80211_wake_queue(sc->hw, q);
+		ieee80211_wake_queue(sc->hw, hw_queue);
 		txq->stopped = false;
 	}
 }
@@ -2191,7 +2193,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf;
 	bool queue;
-	int q;
+	int q, hw_queue;
 	int ret;
 
 	if (vif)
@@ -2211,12 +2213,13 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 
 	q = skb_get_queue_mapping(skb);
+	hw_queue = (info->hw_queue >= sc->hw->queues - 2) ? q : info->hw_queue;
 
 	ath_txq_lock(sc, txq);
 	if (txq == sc->tx.txq_map[q] &&
 	    ++txq->pending_frames > sc->tx.txq_max_pending[q] &&
 	    !txq->stopped) {
-		ieee80211_stop_queue(sc->hw, q);
+		ieee80211_stop_queue(sc->hw, hw_queue);
 		txq->stopped = true;
 	}
 
-- 
2.0.0

