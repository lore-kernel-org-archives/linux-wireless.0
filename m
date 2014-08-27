Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56488 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118AbaH0GhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 02:37:23 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/4] ath9k: Add more debug statements for channel context
Date: Wed, 27 Aug 2014 12:07:24 +0530
Message-Id: <1409121445-11484-4-git-send-email-sujith@msujith.org> (sfid-20140827_083756_995266_CB71022D)
In-Reply-To: <1409121445-11484-1-git-send-email-sujith@msujith.org>
References: <1409121445-11484-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 90 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/main.c    |  3 ++
 2 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index e1602bc..8a70915 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -288,12 +288,16 @@ static void ath_chanctx_adjust_tbtt_delta(struct ath_softc *sc)
  */
 static void ath_chanctx_setup_timer(struct ath_softc *sc, u32 tsf_time)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_hw *ah = sc->sc_ah;
 
 	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, tsf_time, 1000000);
 	tsf_time -= ath9k_hw_gettsf32(ah);
 	tsf_time = msecs_to_jiffies(tsf_time / 1000) + 1;
 	mod_timer(&sc->sched.timer, tsf_time);
+
+	ath_dbg(common, CHAN_CTX,
+		"Setup chanctx timer with timeout: %d ms\n", jiffies_to_msecs(tsf_time));
 }
 
 /*
@@ -357,42 +361,55 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 	u32 beacon_int;
 	bool noa_changed = false;
 
-	ath_dbg(common, CHAN_CTX, "event: %s, state: %s\n",
-		chanctx_event_string(ev),
-		chanctx_state_string(sc->sched.state));
-
 	if (vif)
 		avp = (struct ath_vif *) vif->drv_priv;
 
 	spin_lock_bh(&sc->chan_lock);
 
+	ath_dbg(common, CHAN_CTX, "cur_chan: %d MHz, event: %s, state: %s\n",
+		sc->cur_chan->chandef.center_freq1,
+		chanctx_event_string(ev),
+		chanctx_state_string(sc->sched.state));
+
 	switch (ev) {
 	case ATH_CHANCTX_EVENT_BEACON_PREPARE:
 		if (avp->offchannel_duration)
 			avp->offchannel_duration = 0;
 
-		if (avp->chanctx != sc->cur_chan)
+		if (avp->chanctx != sc->cur_chan) {
+			ath_dbg(common, CHAN_CTX,
+				"Contexts differ, not preparing beacon\n");
 			break;
+		}
 
 		if (sc->sched.offchannel_pending) {
 			sc->sched.offchannel_pending = false;
 			sc->next_chan = &sc->offchannel.chan;
 			sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
+			ath_dbg(common, CHAN_CTX,
+				"Setting offchannel_pending to false\n");
 		}
 
 		ctx = ath_chanctx_get_next(sc, sc->cur_chan);
 		if (ctx->active && sc->sched.state == ATH_CHANCTX_STATE_IDLE) {
 			sc->next_chan = ctx;
 			sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
+			ath_dbg(common, CHAN_CTX,
+				"Set next context, move chanctx state to WAIT_FOR_BEACON\n");
 		}
 
 		/* if the timer missed its window, use the next interval */
-		if (sc->sched.state == ATH_CHANCTX_STATE_WAIT_FOR_TIMER)
+		if (sc->sched.state == ATH_CHANCTX_STATE_WAIT_FOR_TIMER) {
 			sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
+			ath_dbg(common, CHAN_CTX,
+				"Move chanctx state from WAIT_FOR_TIMER to WAIT_FOR_BEACON\n");
+		}
 
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON)
 			break;
 
+		ath_dbg(common, CHAN_CTX, "Preparing beacon for vif: %pM\n", vif->addr);
+
 		sc->sched.beacon_pending = true;
 		sc->sched.next_tbtt = REG_READ(ah, AR_NEXT_TBTT_TIMER);
 
@@ -436,15 +453,28 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 
 		if (noa_changed)
 			avp->noa_index++;
+
+		ath_dbg(common, CHAN_CTX,
+			"periodic_noa_duration: %d, periodic_noa_start: %d, noa_index: %d\n",
+			avp->periodic_noa_duration,
+			avp->periodic_noa_start,
+			avp->noa_index);
+
 		break;
 	case ATH_CHANCTX_EVENT_BEACON_SENT:
-		if (!sc->sched.beacon_pending)
+		if (!sc->sched.beacon_pending) {
+			ath_dbg(common, CHAN_CTX,
+				"No pending beacon\n");
 			break;
+		}
 
 		sc->sched.beacon_pending = false;
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON)
 			break;
 
+		ath_dbg(common, CHAN_CTX,
+			"Move chanctx state to WAIT_FOR_TIMER\n");
+
 		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
 		ath_chanctx_setup_timer(sc, sc->sched.switch_start_time);
 		break;
@@ -456,6 +486,9 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		    sc->sched.beacon_pending)
 			sc->sched.beacon_miss++;
 
+		ath_dbg(common, CHAN_CTX,
+			"Move chanctx state to SWITCH\n");
+
 		sc->sched.state = ATH_CHANCTX_STATE_SWITCH;
 		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
 		break;
@@ -484,6 +517,9 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		    avp->chanctx != sc->cur_chan)
 			break;
 
+		ath_dbg(common, CHAN_CTX,
+			"Move chanctx state from FORCE_ACTIVE to IDLE\n");
+
 		sc->sched.state = ATH_CHANCTX_STATE_IDLE;
 		/* fall through */
 	case ATH_CHANCTX_EVENT_SWITCH:
@@ -499,6 +535,9 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->next_chan = ath_chanctx_get_next(sc, sc->cur_chan);
 		cur_conf = &sc->cur_chan->beacon;
 
+		ath_dbg(common, CHAN_CTX,
+			"Move chanctx state to WAIT_FOR_TIMER (event SWITCH)\n");
+
 		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
 
 		tsf_time = TU_TO_USEC(cur_conf->beacon_interval) / 2;
@@ -668,7 +707,8 @@ ath_scan_next_channel(struct ath_softc *sc)
 
 	if (sc->offchannel.scan_idx >= req->n_channels) {
 		ath_dbg(common, CHAN_CTX,
-			"Moving to ATH_OFFCHANNEL_IDLE state, scan_idx: %d, n_channels: %d\n",
+			"Moving offchannel state to ATH_OFFCHANNEL_IDLE, "
+			"scan_idx: %d, n_channels: %d\n",
 			sc->offchannel.scan_idx,
 			req->n_channels);
 
@@ -679,7 +719,7 @@ ath_scan_next_channel(struct ath_softc *sc)
 	}
 
 	ath_dbg(common, CHAN_CTX,
-		"Moving to ATH_OFFCHANNEL_PROBE_SEND state, scan_idx: %d\n",
+		"Moving offchannel state to ATH_OFFCHANNEL_PROBE_SEND, scan_idx: %d\n",
 		sc->offchannel.scan_idx);
 
 	chan = req->channels[sc->offchannel.scan_idx++];
@@ -792,7 +832,7 @@ static void ath_scan_channel_start(struct ath_softc *sc)
 	}
 
 	ath_dbg(common, CHAN_CTX,
-		"Moving to ATH_OFFCHANNEL_PROBE_WAIT state\n");
+		"Moving offchannel state to ATH_OFFCHANNEL_PROBE_WAIT\n");
 
 	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_WAIT;
 	mod_timer(&sc->offchannel.timer, jiffies + sc->offchannel.duration);
@@ -801,6 +841,10 @@ static void ath_scan_channel_start(struct ath_softc *sc)
 static void ath_chanctx_timer(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *) data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_dbg(common, CHAN_CTX,
+		"Channel context timer invoked\n");
 
 	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_TSF_TIMER);
 }
@@ -811,7 +855,7 @@ static void ath_offchannel_timer(unsigned long data)
 	struct ath_chanctx *ctx;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	ath_dbg(common, CHAN_CTX, "%s: state: %s\n",
+	ath_dbg(common, CHAN_CTX, "%s: offchannel state: %s\n",
 		__func__, offchannel_state_string(sc->offchannel.state));
 
 	switch (sc->offchannel.state) {
@@ -822,6 +866,10 @@ static void ath_offchannel_timer(unsigned long data)
 		/* get first active channel context */
 		ctx = ath_chanctx_get_oper_chan(sc, true);
 		if (ctx->active) {
+			ath_dbg(common, CHAN_CTX,
+				"Switch to oper/active context, "
+				"move offchannel state to ATH_OFFCHANNEL_SUSPEND\n");
+
 			sc->offchannel.state = ATH_OFFCHANNEL_SUSPEND;
 			ath_chanctx_switch(sc, ctx, NULL);
 			mod_timer(&sc->offchannel.timer, jiffies + HZ / 10);
@@ -920,6 +968,8 @@ ath_chanctx_send_ps_frame(struct ath_softc *sc, bool powersave)
 
 static bool ath_chanctx_defer_switch(struct ath_softc *sc)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
 	if (sc->cur_chan == &sc->offchannel.chan)
 		return false;
 
@@ -930,6 +980,9 @@ static bool ath_chanctx_defer_switch(struct ath_softc *sc)
 		if (!sc->cur_chan->switch_after_beacon)
 			return false;
 
+		ath_dbg(common, CHAN_CTX,
+			"Defer switch, set chanctx state to WAIT_FOR_BEACON\n");
+
 		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
 		break;
 	default:
@@ -943,7 +996,7 @@ static void ath_offchannel_channel_change(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	ath_dbg(common, CHAN_CTX, "%s: state: %s\n",
+	ath_dbg(common, CHAN_CTX, "%s: offchannel state: %s\n",
 		__func__, offchannel_state_string(sc->offchannel.state));
 
 	switch (sc->offchannel.state) {
@@ -982,6 +1035,7 @@ static void ath_offchannel_channel_change(struct ath_softc *sc)
 
 void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct timespec ts;
 	bool measure_time = false;
 	bool send_ps = false;
@@ -997,7 +1051,16 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 		return;
 	}
 
+	ath_dbg(common, CHAN_CTX,
+		"%s: current: %d MHz, next: %d MHz\n",
+		__func__,
+		sc->cur_chan->chandef.center_freq1,
+		sc->next_chan->chandef.center_freq1);
+
 	if (sc->cur_chan != sc->next_chan) {
+		ath_dbg(common, CHAN_CTX,
+			"Stopping current chanctx: %d\n",
+			sc->cur_chan->chandef.center_freq1);
 		sc->cur_chan->stopped = true;
 		spin_unlock_bh(&sc->chan_lock);
 
@@ -1030,6 +1093,9 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 	if (sc->sc_ah->chip_fullsleep ||
 	    memcmp(&sc->cur_chandef, &sc->cur_chan->chandef,
 		   sizeof(sc->cur_chandef))) {
+		ath_dbg(common, CHAN_CTX,
+			"%s: Set channel %d MHz\n",
+			__func__, sc->cur_chan->chandef.center_freq1);
 		ath_set_channel(sc);
 		if (measure_time)
 			sc->sched.channel_switch_time =
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b823b5a..d9be831 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2361,6 +2361,9 @@ static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
 		sc->next_chan = avp->chanctx;
 		changed = true;
 	}
+	ath_dbg(common, CHAN_CTX,
+		"%s: Set chanctx state to FORCE_ACTIVE, changed: %d\n",
+		__func__, changed);
 	sc->sched.state = ATH_CHANCTX_STATE_FORCE_ACTIVE;
 	spin_unlock_bh(&sc->chan_lock);
 
-- 
2.1.0

