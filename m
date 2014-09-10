Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50132 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaIJNpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:45:49 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 5/5] ath9k: Fix beacon miss handling
Date: Wed, 10 Sep 2014 19:16:00 +0530
Message-Id: <1410356760-10901-6-git-send-email-sujith@msujith.org> (sfid-20140910_154552_665203_A66E6239)
In-Reply-To: <1410356760-10901-1-git-send-email-sujith@msujith.org>
References: <1410356760-10901-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The NoA duration for a GO is half the beacon interval
and a concurrent context like a STA can be active only
for that duration, before switching back to the GO's
operating channel.

Currently, when multiple beacons are missed, the dwell
time for the STA context is extended to improve the
chances of receiving a beacon. But the NoA is not updated
and this will cause problems since the GO is offline
for a period that is longer than the advertised duration.

Fix this by ensuring that the NoA is updated first before
extending the time slot for the STA context. Also make
sure that non-periodic NoA is used for a one-time, longer
absence period.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  1 +
 drivers/net/wireless/ath/ath9k/channel.c | 44 +++++++++++++++++++++++---------
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 305db1a..660c151 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -380,6 +380,7 @@ struct ath_chanctx_sched {
 	bool offchannel_pending;
 	bool wait_switch;
 	bool force_noa_update;
+	bool extend_absence;
 	enum ath_chanctx_state state;
 	u8 beacon_miss;
 
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index a42fd85..a1b3282 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -371,13 +371,6 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->sched.switch_start_time = tsf_time;
 		sc->cur_chan->last_beacon = sc->sched.next_tbtt;
 
-		/* If at least two consecutive beacons were missed on the STA
-		 * chanctx, stay on the STA channel for one extra beacon period,
-		 * to resync the timer properly.
-		 */
-		if (ctx->active && sc->sched.beacon_miss >= 2)
-			sc->sched.offchannel_duration = 3 * beacon_int / 2;
-
 		/*
 		 * If an offchannel switch is scheduled to happen after
 		 * a beacon transmission, update the NoA with one-shot
@@ -405,6 +398,26 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			break;
 		}
 
+
+		/*
+		 * Clear the extend_absence flag if it had been
+		 * set during the previous beacon transmission,
+		 * since we need to revert to the normal NoA
+		 * schedule.
+		 */
+		if (ctx->active && sc->sched.extend_absence) {
+			avp->noa_duration = 0;
+			sc->sched.extend_absence = false;
+		}
+
+		/* If at least two consecutive beacons were missed on the STA
+		 * chanctx, stay on the STA channel for one extra beacon period,
+		 * to resync the timer properly.
+		 */
+		if (ctx->active && sc->sched.beacon_miss >= 2) {
+			avp->noa_duration = 0;
+			sc->sched.extend_absence = true;
+		}
 		/* Prevent wrap-around issues */
 		if (avp->noa_duration && tsf_time - avp->noa_start > BIT(30))
 			avp->noa_duration = 0;
@@ -418,11 +431,17 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		    (!avp->noa_duration || sc->sched.force_noa_update)) {
 			avp->noa_index++;
 			avp->noa_start = tsf_time;
-			avp->noa_duration =
-				TU_TO_USEC(cur_conf->beacon_interval) / 2 +
-				sc->sched.channel_switch_time;
 
-			if (test_bit(ATH_OP_SCANNING, &common->op_flags))
+			if (sc->sched.extend_absence)
+				avp->noa_duration = (3 * beacon_int / 2) +
+					sc->sched.channel_switch_time;
+			else
+				avp->noa_duration =
+					TU_TO_USEC(cur_conf->beacon_interval) / 2 +
+					sc->sched.channel_switch_time;
+
+			if (test_bit(ATH_OP_SCANNING, &common->op_flags) ||
+			    sc->sched.extend_absence)
 				avp->periodic_noa = false;
 			else
 				avp->periodic_noa = true;
@@ -520,7 +539,8 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->sched.wait_switch = false;
 
 		tsf_time = TU_TO_USEC(cur_conf->beacon_interval) / 2;
-		if (sc->sched.beacon_miss >= 2) {
+
+		if (sc->sched.extend_absence) {
 			sc->sched.beacon_miss = 0;
 			tsf_time *= 3;
 		}
-- 
2.1.0

