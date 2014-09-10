Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41638 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaIJNpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:45:41 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/5] ath9k: Fix Notice of Absence issues
Date: Wed, 10 Sep 2014 19:15:57 +0530
Message-Id: <1410356760-10901-3-git-send-email-sujith@msujith.org> (sfid-20140910_154544_880335_D5B2D167)
In-Reply-To: <1410356760-10901-1-git-send-email-sujith@msujith.org>
References: <1410356760-10901-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* The index has to incremented only when advertising
  a new NoA schedule.

* Switch to non-periodic NoA when starting a scan operation
  and multiple channel contexts are active.

* Make sure that periodic NoA is advertised again when
  scan ends. Since the offchannel timer moves the offchannel
  state to IDLE after the GO operating channel becomes
  active, use a flag "force_noa_update" to update the
  NoA contents.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |   7 ++-
 drivers/net/wireless/ath/ath9k/channel.c | 105 ++++++++++++++++++++-----------
 2 files changed, 75 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0c071b0..305db1a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -379,6 +379,7 @@ struct ath_chanctx_sched {
 	bool beacon_pending;
 	bool offchannel_pending;
 	bool wait_switch;
+	bool force_noa_update;
 	enum ath_chanctx_state state;
 	u8 beacon_miss;
 
@@ -595,8 +596,10 @@ struct ath_vif {
 	u32 offchannel_start;
 	u32 offchannel_duration;
 
-	u32 periodic_noa_start;
-	u32 periodic_noa_duration;
+	/* These are used for both periodic and one-shot */
+	u32 noa_start;
+	u32 noa_duration;
+	bool periodic_noa;
 };
 
 struct ath9k_vif_iter_data {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index ae575cb..ab3d29d 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -310,7 +310,6 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 	struct ath_chanctx *ctx;
 	u32 tsf_time;
 	u32 beacon_int;
-	bool noa_changed = false;
 
 	if (vif)
 		avp = (struct ath_vif *) vif->drv_priv;
@@ -372,22 +371,6 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->sched.switch_start_time = tsf_time;
 		sc->cur_chan->last_beacon = sc->sched.next_tbtt;
 
-		/* Prevent wrap-around issues */
-		if (avp->periodic_noa_duration &&
-		    tsf_time - avp->periodic_noa_start > BIT(30))
-			avp->periodic_noa_duration = 0;
-
-		if (ctx->active) {
-			avp->periodic_noa_start = tsf_time;
-			avp->periodic_noa_duration =
-				TU_TO_USEC(cur_conf->beacon_interval) / 2 -
-				sc->sched.channel_switch_time;
-			noa_changed = true;
-		} else if (!ctx->active) {
-			avp->periodic_noa_duration = 0;
-			noa_changed = true;
-		}
-
 		/* If at least two consecutive beacons were missed on the STA
 		 * chanctx, stay on the STA channel for one extra beacon period,
 		 * to resync the timer properly.
@@ -395,21 +378,65 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		if (ctx->active && sc->sched.beacon_miss >= 2)
 			sc->sched.offchannel_duration = 3 * beacon_int / 2;
 
-		if (sc->sched.offchannel_duration) {
-			noa_changed = true;
+		/*
+		 * If an offchannel switch is scheduled to happen after
+		 * a beacon transmission, update the NoA with one-shot
+		 * values and increment the index.
+		 */
+		if (sc->next_chan == &sc->offchannel.chan) {
+			avp->noa_index++;
 			avp->offchannel_start = tsf_time;
-			avp->offchannel_duration =
-				sc->sched.offchannel_duration;
+			avp->offchannel_duration = sc->sched.offchannel_duration;
+
+			ath_dbg(common, CHAN_CTX,
+				"offchannel noa_duration: %d, noa_start: %d, noa_index: %d\n",
+				avp->offchannel_duration,
+				avp->offchannel_start,
+				avp->noa_index);
+
+			/*
+			 * When multiple contexts are active, the NoA
+			 * has to be recalculated and advertised after
+			 * an offchannel operation.
+			 */
+			if (ctx->active && avp->noa_duration)
+				avp->noa_duration = 0;
+
+			break;
 		}
 
-		if (noa_changed)
+		/* Prevent wrap-around issues */
+		if (avp->noa_duration && tsf_time - avp->noa_start > BIT(30))
+			avp->noa_duration = 0;
+
+		/*
+		 * If multiple contexts are active, start periodic
+		 * NoA and increment the index for the first
+		 * announcement.
+		 */
+		if (ctx->active &&
+		    (!avp->noa_duration || sc->sched.force_noa_update)) {
 			avp->noa_index++;
+			avp->noa_start = tsf_time;
+			avp->noa_duration =
+				TU_TO_USEC(cur_conf->beacon_interval) / 2 -
+				sc->sched.channel_switch_time;
 
-		ath_dbg(common, CHAN_CTX,
-			"periodic_noa_duration: %d, periodic_noa_start: %d, noa_index: %d\n",
-			avp->periodic_noa_duration,
-			avp->periodic_noa_start,
-			avp->noa_index);
+			if (test_bit(ATH_OP_SCANNING, &common->op_flags))
+				avp->periodic_noa = false;
+			else
+				avp->periodic_noa = true;
+
+			ath_dbg(common, CHAN_CTX,
+				"noa_duration: %d, noa_start: %d, noa_index: %d, periodic: %d\n",
+				avp->noa_duration,
+				avp->noa_start,
+				avp->noa_index,
+				avp->periodic_noa);
+		}
+
+		if (ctx->active && sc->sched.force_noa_update)
+			sc->sched.force_noa_update = false;
 
 		break;
 	case ATH_CHANCTX_EVENT_BEACON_SENT:
@@ -736,6 +763,10 @@ void ath_scan_complete(struct ath_softc *sc, bool abort)
 	sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
 	ieee80211_scan_completed(sc->hw, abort);
 	clear_bit(ATH_OP_SCANNING, &common->op_flags);
+	spin_lock_bh(&sc->chan_lock);
+	if (test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
+		sc->sched.force_noa_update = true;
+	spin_unlock_bh(&sc->chan_lock);
 	ath_offchannel_next(sc);
 	ath9k_ps_restore(sc);
 }
@@ -1218,10 +1249,10 @@ void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
 	int noa_len, noa_desc, i = 0;
 	u8 *hdr;
 
-	if (!avp->offchannel_duration && !avp->periodic_noa_duration)
+	if (!avp->offchannel_duration && !avp->noa_duration)
 		return;
 
-	noa_desc = !!avp->offchannel_duration + !!avp->periodic_noa_duration;
+	noa_desc = !!avp->offchannel_duration + !!avp->noa_duration;
 	noa_len = 2 + sizeof(struct ieee80211_p2p_noa_desc) * noa_desc;
 
 	hdr = skb_put(skb, sizeof(noa_ie_hdr));
@@ -1235,13 +1266,17 @@ void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
 	noa->index = avp->noa_index;
 	noa->oppps_ctwindow = ath9k_get_ctwin(sc, avp);
 
-	if (avp->periodic_noa_duration) {
-		u32 interval = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
+	if (avp->noa_duration) {
+		if (avp->periodic_noa) {
+			u32 interval = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
+			noa->desc[i].count = 255;
+			noa->desc[i].interval = cpu_to_le32(interval);
+		} else {
+			noa->desc[i].count = 1;
+		}
 
-		noa->desc[i].count = 255;
-		noa->desc[i].start_time = cpu_to_le32(avp->periodic_noa_start);
-		noa->desc[i].duration = cpu_to_le32(avp->periodic_noa_duration);
-		noa->desc[i].interval = cpu_to_le32(interval);
+		noa->desc[i].start_time = cpu_to_le32(avp->noa_start);
+		noa->desc[i].duration = cpu_to_le32(avp->noa_duration);
 		i++;
 	}
 
-- 
2.1.0

