Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50409 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaFKKsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:48:23 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 04/28] ath9k: Add channel context worker thread
Date: Wed, 11 Jun 2014 16:17:52 +0530
Message-ID: <1402483696-2498-5-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124826_464447_9EC2869D)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
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
 drivers/net/wireless/ath/ath9k/ath9k.h   | 13 ++++++-
 drivers/net/wireless/ath/ath9k/beacon.c  |  2 +-
 drivers/net/wireless/ath/ath9k/channel.c | 64 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/init.c    |  2 +
 drivers/net/wireless/ath/ath9k/link.c    |  2 +-
 drivers/net/wireless/ath/ath9k/main.c    | 29 +++++++++------
 drivers/net/wireless/ath/ath9k/wow.c     |  1 +
 drivers/net/wireless/ath/ath9k/xmit.c    |  7 ++++
 8 files changed, 99 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 198cca3..8f59cea 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -327,11 +327,14 @@ struct ath_chanctx {
 
 	u16 txpower;
 	bool offchannel;
+	bool stopped;
 };
 
 void ath_chanctx_init(struct ath_softc *sc);
-int ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
-			      struct cfg80211_chan_def *chandef);
+void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
+			     struct cfg80211_chan_def *chandef);
+void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
+			struct cfg80211_chan_def *chandef);
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
@@ -470,6 +473,7 @@ void ath9k_csa_update(struct ath_softc *sc);
 #define ATH_PAPRD_TIMEOUT         100 /* msecs */
 #define ATH_PLL_WORK_INTERVAL     100
 
+void ath_chanctx_work(struct work_struct *work);
 void ath_tx_complete_poll_work(struct work_struct *work);
 void ath_reset_work(struct work_struct *work);
 bool ath_hw_check(struct ath_softc *sc);
@@ -485,6 +489,7 @@ void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 void ath_ps_full_sleep(unsigned long data);
 void ath9k_p2p_ps_timer(void *priv);
 void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif);
+void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
 
 /**********/
 /* BTCOEX */
@@ -734,6 +739,7 @@ struct ath_softc {
 	struct mutex mutex;
 	struct work_struct paprd_work;
 	struct work_struct hw_reset_work;
+	struct work_struct chanctx_work;
 	struct completion paprd_complete;
 	wait_queue_head_t tx_wait;
 
@@ -756,8 +762,11 @@ struct ath_softc {
 	struct ath_tx tx;
 	struct ath_beacon beacon;
 
+	struct cfg80211_chan_def cur_chandef;
 	struct ath_chanctx chanctx[ATH9K_NUM_CHANCTX];
 	struct ath_chanctx *cur_chan;
+	struct ath_chanctx *next_chan;
+	spinlock_t chan_lock;
 
 #ifdef CONFIG_MAC80211_LEDS
 	bool led_registered;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index e387f0b..eae8f68 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -80,7 +80,7 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	u8 chainmask = ah->txchainmask;
 	u8 rate = 0;
 
-	sband = &common->sbands[common->hw->conf.chandef.chan->band];
+	sband = &common->sbands[sc->cur_chandef.chan->band];
 	rate = sband->bitrates[rateidx].hw_value;
 	if (vif->bss_conf.use_short_preamble)
 		rate |= sband->bitrates[rateidx].hw_value_short;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index c8d91df..86404d3 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -101,6 +101,39 @@ static int ath_set_channel(struct ath_softc *sc)
 	return 0;
 }
 
+void ath_chanctx_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    chanctx_work);
+
+	mutex_lock(&sc->mutex);
+	spin_lock_bh(&sc->chan_lock);
+	if (!sc->next_chan) {
+		spin_unlock_bh(&sc->chan_lock);
+		mutex_unlock(&sc->mutex);
+		return;
+	}
+
+	if (sc->cur_chan != sc->next_chan) {
+		sc->cur_chan->stopped = true;
+		spin_unlock_bh(&sc->chan_lock);
+
+		__ath9k_flush(sc->hw, ~0, true);
+
+		spin_lock_bh(&sc->chan_lock);
+	}
+	sc->cur_chan = sc->next_chan;
+	sc->cur_chan->stopped = false;
+	sc->next_chan = NULL;
+	spin_unlock_bh(&sc->chan_lock);
+
+	if (sc->sc_ah->chip_fullsleep ||
+	    memcmp(&sc->cur_chandef, &sc->cur_chan->chandef,
+		   sizeof(sc->cur_chandef)))
+		ath_set_channel(sc);
+	mutex_unlock(&sc->mutex);
+}
+
 void ath_chanctx_init(struct ath_softc *sc)
 {
 	struct ath_chanctx *ctx;
@@ -125,12 +158,31 @@ void ath_chanctx_init(struct ath_softc *sc)
 	sc->cur_chan = &sc->chanctx[0];
 }
 
-int ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
-			      struct cfg80211_chan_def *chandef)
+void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
+			struct cfg80211_chan_def *chandef)
 {
-	memcpy(&ctx->chandef, chandef, sizeof(ctx->chandef));
-	if (ctx != sc->cur_chan)
-		return 0;
 
-	return ath_set_channel(sc);
+	spin_lock_bh(&sc->chan_lock);
+	sc->next_chan = ctx;
+	if (chandef)
+		ctx->chandef = *chandef;
+	spin_unlock_bh(&sc->chan_lock);
+	ieee80211_queue_work(sc->hw, &sc->chanctx_work);
+}
+
+void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
+			     struct cfg80211_chan_def *chandef)
+{
+	bool cur_chan;
+
+	spin_lock_bh(&sc->chan_lock);
+	if (chandef)
+		memcpy(&ctx->chandef, chandef, sizeof(*chandef));
+	cur_chan = sc->cur_chan == ctx;
+	spin_unlock_bh(&sc->chan_lock);
+
+	if (!cur_chan)
+		return;
+
+	ath_set_channel(sc);
 }
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
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 6f91974..d9c01d5 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -178,7 +178,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 	txctl.txq = sc->tx.txq_map[IEEE80211_AC_BE];
 
 	memset(tx_info, 0, sizeof(*tx_info));
-	tx_info->band = hw->conf.chandef.chan->band;
+	tx_info->band = sc->cur_chandef.chan->band;
 	tx_info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	tx_info->control.rates[0].idx = 0;
 	tx_info->control.rates[0].count = 1;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5f7e0bf..bb73a23 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -290,6 +290,12 @@ int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 	if (!ath_prepare_reset(sc))
 		fastcc = false;
 
+	if (hchan) {
+		spin_lock_bh(&sc->chan_lock);
+		sc->cur_chandef = sc->cur_chan->chandef;
+		spin_unlock_bh(&sc->chan_lock);
+	}
+
 	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
 		hchan->channel, IS_CHAN_HT40(hchan), fastcc);
 
@@ -630,8 +636,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
-	memcpy(&ctx->chandef, &hw->conf.chandef, sizeof(ctx->chandef));
 	init_channel = ath9k_cmn_get_channel(hw, ah, &ctx->chandef);
+	sc->cur_chandef = hw->conf.chandef;
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(ah, false);
@@ -794,6 +800,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool prev_idle;
 
+	cancel_work_sync(&sc->chanctx_work);
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
@@ -1308,12 +1315,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || reset_channel) {
 		ctx->offchannel = !!(conf->flags & IEEE80211_CONF_OFFCHANNEL);
-		if (ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef) < 0) {
-			ath_err(common, "Unable to set channel\n");
-			mutex_unlock(&sc->mutex);
-			ath9k_ps_restore(sc);
-			return -EINVAL;
-		}
+		ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
@@ -1948,23 +1950,29 @@ static void ath9k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
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
 
@@ -1986,7 +1994,6 @@ static void ath9k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
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
index b2e66d2..5aaed39 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1826,18 +1826,24 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
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
@@ -1883,6 +1889,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	}
 
 	rcu_read_unlock();
+	spin_unlock_bh(&sc->chan_lock);
 }
 
 void ath_txq_schedule_all(struct ath_softc *sc)
-- 
2.0.0

