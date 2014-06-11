Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11591 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbaFKKti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:49:38 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 16/28] ath9k: switch channel context for beaconing
Date: Wed, 11 Jun 2014 16:18:04 +0530
Message-ID: <1402483696-2498-17-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124942_351651_EBE1E4BD)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Add a basic state machine for switch channel context
for beacon transmission.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 25 ++++++++++
 drivers/net/wireless/ath/ath9k/beacon.c  | 11 ++++-
 drivers/net/wireless/ath/ath9k/channel.c | 84 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/main.c    |  9 +++-
 drivers/net/wireless/ath/ath9k/xmit.c    |  2 +
 5 files changed, 126 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a0c7279..b657115 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -341,6 +341,28 @@ struct ath_chanctx {
 	bool stopped;
 	bool active;
 	bool assigned;
+	bool switch_after_beacon;
+};
+
+enum ath_chanctx_event {
+	ATH_CHANCTX_EVENT_BEACON_PREPARE,
+	ATH_CHANCTX_EVENT_BEACON_SENT,
+	ATH_CHANCTX_EVENT_TSF_TIMER,
+};
+
+enum ath_chanctx_state {
+	ATH_CHANCTX_STATE_IDLE,
+	ATH_CHANCTX_STATE_WAIT_FOR_BEACON,
+	ATH_CHANCTX_STATE_WAIT_FOR_TIMER,
+	ATH_CHANCTX_STATE_SWITCH,
+};
+
+struct ath_chanctx_sched {
+	bool beacon_pending;
+	enum ath_chanctx_state state;
+
+	u32 next_tbtt;
+	unsigned int channel_switch_time;
 };
 
 enum ath_offchannel_state {
@@ -388,6 +410,8 @@ void ath_chanctx_offchan_switch(struct ath_softc *sc,
 				struct ieee80211_channel *chan);
 struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc,
 					      bool active);
+void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
+		       enum ath_chanctx_event ev);
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
@@ -826,6 +850,7 @@ struct ath_softc {
 	struct ath_chanctx *next_chan;
 	spinlock_t chan_lock;
 	struct ath_offchannel offchannel;
+	struct ath_chanctx_sched sched;
 
 #ifdef CONFIG_MAC80211_LEDS
 	bool led_registered;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index d355392..5b1689c 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -374,12 +374,19 @@ void ath9k_beacon_tasklet(unsigned long data)
 	vif = sc->beacon.bslot[slot];
 
 	/* EDMA devices check that in the tx completion function. */
-	if (!edma && ath9k_csa_is_finished(sc, vif))
-		return;
+	if (!edma) {
+		if (sc->sched.beacon_pending)
+			ath_chanctx_event(sc, NULL,
+					  ATH_CHANCTX_EVENT_BEACON_SENT);
+
+		if (ath9k_csa_is_finished(sc, vif))
+			return;
+	}
 
 	if (!vif || !vif->bss_conf.enable_beacon)
 		return;
 
+	ath_chanctx_event(sc, vif, ATH_CHANCTX_EVENT_BEACON_PREPARE);
 	bf = ath9k_beacon_generate(sc->hw, vif);
 
 	if (sc->beacon.bmisscnt != 0) {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 1566253..503b776 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -202,10 +202,33 @@ ath_chanctx_send_ps_frame(struct ath_softc *sc, bool powersave)
 	return sent;
 }
 
+static bool ath_chanctx_defer_switch(struct ath_softc *sc)
+{
+	if (sc->cur_chan == &sc->offchannel.chan)
+		return false;
+
+	switch (sc->sched.state) {
+	case ATH_CHANCTX_STATE_SWITCH:
+		return false;
+	case ATH_CHANCTX_STATE_IDLE:
+		if (!sc->cur_chan->switch_after_beacon)
+			return false;
+
+		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
+		break;
+	default:
+		break;
+	}
+
+	return true;
+}
+
 void ath_chanctx_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc,
 					    chanctx_work);
+	struct timespec ts;
+	bool measure_time = false;
 	bool send_ps = false;
 
 	mutex_lock(&sc->mutex);
@@ -216,10 +239,20 @@ void ath_chanctx_work(struct work_struct *work)
 		return;
 	}
 
+	if (ath_chanctx_defer_switch(sc)) {
+		spin_unlock_bh(&sc->chan_lock);
+		mutex_unlock(&sc->mutex);
+		return;
+	}
+
 	if (sc->cur_chan != sc->next_chan) {
 		sc->cur_chan->stopped = true;
 		spin_unlock_bh(&sc->chan_lock);
 
+		if (sc->next_chan == &sc->offchannel.chan) {
+			getrawmonotonic(&ts);
+			measure_time = true;
+		}
 		__ath9k_flush(sc->hw, ~0, true);
 
 		if (ath_chanctx_send_ps_frame(sc, true))
@@ -236,13 +269,17 @@ void ath_chanctx_work(struct work_struct *work)
 	sc->cur_chan = sc->next_chan;
 	sc->cur_chan->stopped = false;
 	sc->next_chan = NULL;
+	sc->sched.state = ATH_CHANCTX_STATE_IDLE;
 	spin_unlock_bh(&sc->chan_lock);
 
 	if (sc->sc_ah->chip_fullsleep ||
 	    memcmp(&sc->cur_chandef, &sc->cur_chan->chandef,
-		   sizeof(sc->cur_chandef)))
+		   sizeof(sc->cur_chandef))) {
 		ath_set_channel(sc);
-
+		if (measure_time)
+			sc->sched.channel_switch_time =
+				ath9k_hw_get_tsf_offset(&ts, NULL);
+	}
 	if (send_ps)
 		ath_chanctx_send_ps_frame(sc, false);
 
@@ -335,3 +372,46 @@ void ath_chanctx_offchan_switch(struct ath_softc *sc,
 
 	ath_chanctx_switch(sc, &sc->offchannel.chan, &chandef);
 }
+
+void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
+		       enum ath_chanctx_event ev)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	u32 tsf_time;
+
+	spin_lock_bh(&sc->chan_lock);
+
+	switch (ev) {
+	case ATH_CHANCTX_EVENT_BEACON_PREPARE:
+		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON)
+			break;
+
+		sc->sched.beacon_pending = true;
+		sc->sched.next_tbtt = REG_READ(ah, AR_NEXT_TBTT_TIMER);
+		break;
+	case ATH_CHANCTX_EVENT_BEACON_SENT:
+		if (!sc->sched.beacon_pending)
+			break;
+
+		sc->sched.beacon_pending = false;
+		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON)
+			break;
+
+		/* defer channel switch by a quarter beacon interval */
+		tsf_time = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
+		tsf_time = sc->sched.next_tbtt + tsf_time / 4;
+		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
+		ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, tsf_time,
+				1000000);
+		break;
+	case ATH_CHANCTX_EVENT_TSF_TIMER:
+		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_TIMER)
+			break;
+
+		sc->sched.state = ATH_CHANCTX_STATE_SWITCH;
+		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
+		break;
+	}
+
+	spin_unlock_bh(&sc->chan_lock);
+}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9dfb820..2393af0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1047,10 +1047,14 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 
 	ath9k_hw_setopmode(ah);
 
+	ctx->switch_after_beacon = false;
 	if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes) > 0)
 		ah->imask |= ATH9K_INT_TSFOOR;
-	else
+	else {
 		ah->imask &= ~ATH9K_INT_TSFOOR;
+		if (iter_data.naps == 1 && iter_data.beacons)
+			ctx->switch_after_beacon = true;
+	}
 
 	ah->imask &= ~ATH9K_INT_SWBA;
 	if (ah->opmode == NL80211_IFTYPE_STATION) {
@@ -1664,6 +1668,9 @@ void ath9k_p2p_ps_timer(void *priv)
 	struct ath_node *an;
 	u32 tsf;
 
+	ath9k_hw_gen_timer_stop(sc->sc_ah, sc->p2p_ps_timer);
+	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_TSF_TIMER);
+
 	if (!avp || avp->chanctx != sc->cur_chan)
 		return;
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7dd6187..a422c20 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2617,6 +2617,8 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			sc->beacon.tx_processed = true;
 			sc->beacon.tx_last = !(ts.ts_status & ATH9K_TXERR_MASK);
 
+			ath_chanctx_event(sc, NULL,
+					  ATH_CHANCTX_EVENT_BEACON_SENT);
 			ath9k_csa_update(sc);
 			continue;
 		}
-- 
2.0.0

