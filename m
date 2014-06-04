Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17990 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaFDNr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:47:28 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 04/13] ath9k: Add channel context worker thread
Date: Wed, 4 Jun 2014 19:16:30 +0530
Message-ID: <1401889599-412-5-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154733_900566_69D8EBE8)
In-Reply-To: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

The channel context worker is used to switch to next requested
channel context.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  7 ++++++
 drivers/net/wireless/ath/ath9k/channel.c | 41 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c    |  2 ++
 drivers/net/wireless/ath/ath9k/main.c    | 14 +++++++----
 drivers/net/wireless/ath/ath9k/wow.c     |  1 +
 drivers/net/wireless/ath/ath9k/xmit.c    |  7 ++++++
 6 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4906c55..052a2f9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -327,11 +327,13 @@ struct ath_chanctx {
 
 	u16 txpower;
 	bool offchannel;
+	bool stopped;
 };
 
 void ath_chanctx_init(struct ath_softc *sc);
 int ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			      struct cfg80211_chan_def *chandef);
+void ath_chanctx_switch(struct ath_softc *sc, u8 next_chanctx_idx);
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
@@ -469,6 +471,7 @@ void ath9k_csa_update(struct ath_softc *sc);
 #define ATH_PAPRD_TIMEOUT         100 /* msecs */
 #define ATH_PLL_WORK_INTERVAL     100
 
+void ath_chanctx_work(struct work_struct *work);
 void ath_tx_complete_poll_work(struct work_struct *work);
 void ath_reset_work(struct work_struct *work);
 bool ath_hw_check(struct ath_softc *sc);
@@ -484,6 +487,7 @@ void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 void ath_ps_full_sleep(unsigned long data);
 void ath9k_p2p_ps_timer(void *priv);
 void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif);
+void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
 
 /**********/
 /* BTCOEX */
@@ -733,6 +737,7 @@ struct ath_softc {
 	struct mutex mutex;
 	struct work_struct paprd_work;
 	struct work_struct hw_reset_work;
+	struct work_struct chanctx_work;
 	struct completion paprd_complete;
 	wait_queue_head_t tx_wait;
 
@@ -757,6 +762,8 @@ struct ath_softc {
 
 	struct ath_chanctx chanctx[ATH9K_NUM_CHANCTX];
 	struct ath_chanctx *cur_chan;
+	spinlock_t chan_lock;
+	s8 next_chanctx_idx;
 
 #ifdef CONFIG_MAC80211_LEDS
 	bool led_registered;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index c8d91df..ecc4d50 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -134,3 +134,44 @@ int ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 
 	return ath_set_channel(sc);
 }
+
+void ath_chanctx_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    chanctx_work);
+
+	mutex_lock(&sc->mutex);
+	spin_lock_bh(&sc->chan_lock);
+	if ((sc->next_chanctx_idx < 0) ||
+	    (sc->next_chanctx_idx >= ATH9K_NUM_CHANCTX)) {
+		spin_unlock_bh(&sc->chan_lock);
+		mutex_unlock(&sc->mutex);
+		return;
+	}
+
+	if (sc->cur_chan != &sc->chanctx[sc->next_chanctx_idx]) {
+		sc->cur_chan->stopped = true;
+		spin_unlock_bh(&sc->chan_lock);
+
+		__ath9k_flush(sc->hw, ~0, true);
+
+		spin_lock_bh(&sc->chan_lock);
+	}
+	sc->cur_chan = &sc->chanctx[sc->next_chanctx_idx];
+	sc->cur_chan->stopped = false;
+	sc->next_chanctx_idx = -1;
+	spin_unlock_bh(&sc->chan_lock);
+
+	ath_set_channel(sc);
+	mutex_unlock(&sc->mutex);
+}
+
+void ath_chanctx_switch(struct ath_softc *sc, u8 next_chanctx_idx)
+{
+
+	WARN_ON(next_chanctx_idx >= ATH9K_NUM_CHANCTX);
+	spin_lock_bh(&sc->chan_lock);
+	sc->next_chanctx_idx = next_chanctx_idx;
+	spin_unlock_bh(&sc->chan_lock);
+	ieee80211_queue_work(sc->hw, &sc->chanctx_work);
+}
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ffd42bf..8bd3e42 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -555,6 +555,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	spin_lock_init(&common->cc_lock);
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
+	spin_lock_init(&sc->chan_lock);
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
@@ -563,6 +564,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	setup_timer(&sc->sleep_timer, ath_ps_full_sleep, (unsigned long)sc);
 	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
+	INIT_WORK(&sc->chanctx_work, ath_chanctx_work);
 	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
 
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9a2177d..e4aa29b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -803,6 +803,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool prev_idle;
 
+	cancel_work_sync(&sc->chanctx_work);
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
@@ -1957,23 +1958,29 @@ static void ath9k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			u32 queues, bool drop)
 {
 	struct ath_softc *sc = hw->priv;
+
+	mutex_lock(&sc->mutex);
+	__ath9k_flush(hw, queues, drop);
+	mutex_unlock(&sc->mutex);
+}
+
+void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+{
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	int timeout = HZ / 5; /* 200 ms */
 	bool drain_txq;
 
-	mutex_lock(&sc->mutex);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 
 	if (ah->ah_flags & AH_UNPLUGGED) {
 		ath_dbg(common, ANY, "Device has been unplugged!\n");
-		mutex_unlock(&sc->mutex);
 		return;
 	}
 
 	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
-		mutex_unlock(&sc->mutex);
 		return;
 	}
 
@@ -1995,7 +2002,6 @@ static void ath9k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
-	mutex_unlock(&sc->mutex);
 }
 
 static bool ath9k_tx_frames_pending(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 2879887..a4f4f0d 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -193,6 +193,7 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 	u32 wow_triggers_enabled = 0;
 	int ret = 0;
 
+	cancel_work_sync(&sc->chanctx_work);
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a84fe1a..0c9571a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1823,18 +1823,24 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	if (txq->mac80211_qnum < 0)
 		return;
 
+	spin_lock_bh(&sc->chan_lock);
 	ac_list = &sc->cur_chan->acq[txq->mac80211_qnum];
+	spin_unlock_bh(&sc->chan_lock);
 
 	if (test_bit(ATH_OP_HW_RESET, &common->op_flags) ||
 	    list_empty(ac_list))
 		return;
 
+	spin_lock_bh(&sc->chan_lock);
 	rcu_read_lock();
 
 	last_ac = list_entry(ac_list->prev, struct ath_atx_ac, list);
 	while (!list_empty(ac_list)) {
 		bool stop = false;
 
+		if (sc->cur_chan->stopped)
+			break;
+
 		ac = list_first_entry(ac_list, struct ath_atx_ac, list);
 		last_tid = list_entry(ac->tid_q.prev, struct ath_atx_tid, list);
 		list_del(&ac->list);
@@ -1880,6 +1886,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	}
 
 	rcu_read_unlock();
+	spin_unlock_bh(&sc->chan_lock);
 }
 
 /***********/
-- 
2.0.0

