Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53242 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaFKKuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:50:13 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 22/28] ath9k: Add multi-channel scheduling support
Date: Wed, 11 Jun 2014 16:18:10 +0530
Message-ID: <1402483696-2498-23-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_130457_261562_45E73B28)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  5 ++
 drivers/net/wireless/ath/ath9k/channel.c | 95 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/main.c    |  3 +
 3 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7947909..0bc63bd 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -350,6 +350,10 @@ enum ath_chanctx_event {
 	ATH_CHANCTX_EVENT_BEACON_SENT,
 	ATH_CHANCTX_EVENT_TSF_TIMER,
 	ATH_CHANCTX_EVENT_BEACON_RECEIVED,
+	ATH_CHANCTX_EVENT_ASSOC,
+	ATH_CHANCTX_EVENT_SWITCH,
+	ATH_CHANCTX_EVENT_UNASSIGN,
+	ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL,
 };
 
 enum ath_chanctx_state {
@@ -362,6 +366,7 @@ enum ath_chanctx_state {
 
 struct ath_chanctx_sched {
 	bool beacon_pending;
+	bool offchannel_pending;
 	enum ath_chanctx_state state;
 
 	u32 next_tbtt;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 8d56b79..1cb2909 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -180,10 +180,13 @@ void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 		n_active++;
 	}
 
-	if (n_active > 1)
-		set_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags);
-	else
+	if (n_active <= 1) {
 		clear_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags);
+		return;
+	}
+	if (test_and_set_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
+		return;
+	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL);
 }
 
 static bool
@@ -282,6 +285,7 @@ static void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 		ath_chanctx_send_ps_frame(sc, false);
 
 	ath_offchannel_channel_change(sc);
+	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_SWITCH);
 }
 
 void ath_chanctx_work(struct work_struct *work)
@@ -357,8 +361,17 @@ void ath9k_chanctx_force_active(struct ieee80211_hw *hw,
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 			struct cfg80211_chan_def *chandef)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	spin_lock_bh(&sc->chan_lock);
+
+	if (test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) &&
+	    (sc->cur_chan != ctx) && (ctx == &sc->offchannel.chan)) {
+		sc->sched.offchannel_pending = true;
+		spin_unlock_bh(&sc->chan_lock);
+		return;
+	}
+
 	sc->next_chan = ctx;
 	if (chandef)
 		ctx->chandef = *chandef;
@@ -462,6 +475,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = NULL;
+	struct ath_chanctx *ctx;
 	u32 tsf_time;
 	bool noa_changed = false;
 
@@ -475,6 +489,25 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		if (avp->offchannel_duration)
 			avp->offchannel_duration = 0;
 
+		if (avp->chanctx != sc->cur_chan)
+			break;
+
+		if (sc->sched.offchannel_pending) {
+			sc->sched.offchannel_pending = false;
+			sc->next_chan = &sc->offchannel.chan;
+			sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
+		}
+
+		ctx = ath_chanctx_get_next(sc, sc->cur_chan);
+		if (ctx->active && sc->sched.state == ATH_CHANCTX_STATE_IDLE) {
+			sc->next_chan = ctx;
+			sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
+		}
+
+		/* if the timer missed its window, use the next interval */
+		if (sc->sched.state == ATH_CHANCTX_STATE_WAIT_FOR_TIMER)
+			sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
+
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON)
 			break;
 
@@ -518,11 +551,65 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
 		break;
 	case ATH_CHANCTX_EVENT_BEACON_RECEIVED:
-		if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
+		if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) ||
+		    sc->cur_chan == &sc->offchannel.chan)
 			break;
 
 		ath_chanctx_adjust_tbtt_delta(sc);
 		break;
+	case ATH_CHANCTX_EVENT_ASSOC:
+		if (sc->sched.state != ATH_CHANCTX_STATE_FORCE_ACTIVE ||
+		    avp->chanctx != sc->cur_chan)
+			break;
+
+		sc->sched.state = ATH_CHANCTX_STATE_IDLE;
+		/* fall through */
+	case ATH_CHANCTX_EVENT_SWITCH:
+		if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) ||
+		    sc->sched.state == ATH_CHANCTX_STATE_FORCE_ACTIVE ||
+		    sc->cur_chan->switch_after_beacon ||
+		    sc->cur_chan == &sc->offchannel.chan)
+			break;
+
+		/* If this is a station chanctx, stay active for a half
+		 * beacon period (minus channel switch time)
+		 */
+		sc->next_chan = ath_chanctx_get_next(sc, sc->cur_chan);
+
+		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
+		tsf_time = ath9k_hw_gettsf32(sc->sc_ah);
+		tsf_time +=
+			TU_TO_USEC(sc->cur_chan->beacon.beacon_interval) / 2;
+		tsf_time -= sc->sched.channel_switch_time;
+		sc->sched.switch_start_time = tsf_time;
+
+		ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer,
+					 tsf_time, 1000000);
+		break;
+	case ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL:
+		if (sc->cur_chan == &sc->offchannel.chan ||
+		    sc->cur_chan->switch_after_beacon)
+			break;
+
+		sc->next_chan = ath_chanctx_get_next(sc, sc->cur_chan);
+		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
+		break;
+	case ATH_CHANCTX_EVENT_UNASSIGN:
+		if (sc->cur_chan->assigned) {
+			if (sc->next_chan && !sc->next_chan->assigned &&
+			    sc->next_chan != &sc->offchannel.chan)
+				sc->sched.state = ATH_CHANCTX_STATE_IDLE;
+			break;
+		}
+
+		ctx = ath_chanctx_get_next(sc, sc->cur_chan);
+		sc->sched.state = ATH_CHANCTX_STATE_IDLE;
+		if (!ctx->assigned)
+			break;
+
+		sc->next_chan = ctx;
+		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
+		break;
 	}
 
 	spin_unlock_bh(&sc->chan_lock);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b8975f0..f7d8dda 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1747,6 +1747,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			bss_conf->bssid, bss_conf->assoc);
 
 		ath9k_calculate_summary_state(sc, avp->chanctx);
+		if (bss_conf->assoc)
+			ath_chanctx_event(sc, vif, ATH_CHANCTX_EVENT_ASSOC);
 	}
 
 	if (changed & BSS_CHANGED_IBSS) {
@@ -2492,6 +2494,7 @@ static void ath9k_remove_chanctx(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 	ctx->assigned = false;
+	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_UNASSIGN);
 	mutex_unlock(&sc->mutex);
 }
 
-- 
2.0.0

