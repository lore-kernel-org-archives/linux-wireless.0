Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25376 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaFKKuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:50:25 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 24/28] ath9k: Handle beacon miss on multi channel context
Date: Wed, 11 Jun 2014 16:18:12 +0530
Message-ID: <1402483696-2498-25-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_130502_192928_097205A0)
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
 drivers/net/wireless/ath/ath9k/ath9k.h   |  1 +
 drivers/net/wireless/ath/ath9k/channel.c | 30 ++++++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a5afd4a..ee00ddb 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -368,6 +368,7 @@ struct ath_chanctx_sched {
 	bool beacon_pending;
 	bool offchannel_pending;
 	enum ath_chanctx_state state;
+	u8 beacon_miss;
 
 	u32 next_tbtt;
 	u32 switch_start_time;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 3d9776c..55165d5 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -478,6 +478,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 	struct ath_vif *avp = NULL;
 	struct ath_chanctx *ctx;
 	u32 tsf_time;
+	u32 beacon_int;
 	bool noa_changed = false;
 
 	if (vif)
@@ -516,9 +517,10 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->sched.next_tbtt = REG_READ(ah, AR_NEXT_TBTT_TIMER);
 
 		cur_conf = &sc->cur_chan->beacon;
+		beacon_int = TU_TO_USEC(cur_conf->beacon_interval);
+
 		/* defer channel switch by a quarter beacon interval */
-		tsf_time = TU_TO_USEC(cur_conf->beacon_interval);
-		tsf_time = sc->sched.next_tbtt + tsf_time / 4;
+		tsf_time = sc->sched.next_tbtt + beacon_int / 4;
 		sc->sched.switch_start_time = tsf_time;
 		sc->cur_chan->last_beacon = sc->sched.next_tbtt;
 
@@ -538,6 +540,13 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			noa_changed = true;
 		}
 
+		/* If at least two consecutive beacons were missed on the STA
+		 * chanctx, stay on the STA channel for one extra beacon period,
+		 * to resync the timer properly.
+		 */
+		if (ctx->active && sc->sched.beacon_miss >= 2)
+			sc->sched.offchannel_duration = 3 * beacon_int / 2;
+
 		if (sc->sched.offchannel_duration) {
 			noa_changed = true;
 			avp->offchannel_start = tsf_time;
@@ -565,6 +574,10 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_TIMER)
 			break;
 
+		if (!sc->cur_chan->switch_after_beacon &&
+		    sc->sched.beacon_pending)
+			sc->sched.beacon_miss++;
+
 		sc->sched.state = ATH_CHANCTX_STATE_SWITCH;
 		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
 		break;
@@ -574,6 +587,8 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			break;
 
 		ath_chanctx_adjust_tbtt_delta(sc);
+		sc->sched.beacon_pending = false;
+		sc->sched.beacon_miss = 0;
 		break;
 	case ATH_CHANCTX_EVENT_ASSOC:
 		if (sc->sched.state != ATH_CHANCTX_STATE_FORCE_ACTIVE ||
@@ -596,13 +611,20 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		cur_conf = &sc->cur_chan->beacon;
 
 		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
-		tsf_time = ath9k_hw_gettsf32(sc->sc_ah);
-		tsf_time += TU_TO_USEC(cur_conf->beacon_interval) / 2;
+
+		tsf_time = TU_TO_USEC(cur_conf->beacon_interval) / 2;
+		if (sc->sched.beacon_miss >= 2) {
+			sc->sched.beacon_miss = 0;
+			tsf_time *= 3;
+		}
+
 		tsf_time -= sc->sched.channel_switch_time;
+		tsf_time += ath9k_hw_gettsf32(sc->sc_ah);
 		sc->sched.switch_start_time = tsf_time;
 
 		ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer,
 					 tsf_time, 1000000);
+		sc->sched.beacon_pending = true;
 		break;
 	case ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL:
 		if (sc->cur_chan == &sc->offchannel.chan ||
-- 
2.0.0

