Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40682 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaH0GhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 02:37:19 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 1/4] ath9k: Fix channel context transition
Date: Wed, 27 Aug 2014 12:07:22 +0530
Message-Id: <1409121445-11484-2-git-send-email-sujith@msujith.org> (sfid-20140827_083727_490430_AE309132)
In-Reply-To: <1409121445-11484-1-git-send-email-sujith@msujith.org>
References: <1409121445-11484-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In channel context mode, a nullfunc is sent with
the PM bit enabled when we switch to a new channel
context from the current one. But, when the scheduler
switches back to the old context, sending a nullfunc
with PM bit cleared has to be done only if there is
buffered traffic at the AP.

Currently, this is not done and a nullfunc is sent
for every transition. Fix this by parsing the TIM IE
for a received beacon and checking if there is buffered
traffic.

Since the beacon frame has to be parsed, move the location
of the ATH_CHANCTX_EVENT_BEACON_RECEIVED after the frame
has been processed - in ath_rx_tasklet().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 10 ++++-
 drivers/net/wireless/ath/ath9k/channel.c | 66 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/recv.c    | 12 +++---
 3 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c690601..857e911 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -338,6 +338,7 @@ struct ath_chanctx {
 	/* do not dereference, use for comparison only */
 	struct ieee80211_vif *primary_sta;
 
+	struct sk_buff *beacon_skb;
 	struct ath_beacon_config beacon;
 	struct ath9k_hw_cal_data caldata;
 	struct timespec tsf_ts;
@@ -376,6 +377,7 @@ enum ath_chanctx_state {
 struct ath_chanctx_sched {
 	bool beacon_pending;
 	bool offchannel_pending;
+	bool tim_set;
 	enum ath_chanctx_state state;
 	u8 beacon_miss;
 
@@ -449,7 +451,9 @@ void ath9k_p2p_ps_timer(void *priv);
 void ath9k_chanctx_wake_queues(struct ath_softc *sc);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
 
-void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
+void ath_chanctx_beacon_recv_ev(struct ath_softc *sc,
+				struct sk_buff *skb,
+				u32 ts,
 				enum ath_chanctx_event ev);
 void ath_chanctx_beacon_sent_ev(struct ath_softc *sc,
 				enum ath_chanctx_event ev);
@@ -478,7 +482,9 @@ static inline void ath9k_offchannel_init(struct ath_softc *sc)
 static inline void ath9k_deinit_channel_context(struct ath_softc *sc)
 {
 }
-static inline void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
+static inline void ath_chanctx_beacon_recv_ev(struct ath_softc *sc,
+					      struct sk_buff *skb,
+					      u32 ts,
 					      enum ath_chanctx_event ev)
 {
 }
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index b369c48..e1602bc 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -296,6 +296,55 @@ static void ath_chanctx_setup_timer(struct ath_softc *sc, u32 tsf_time)
 	mod_timer(&sc->sched.timer, tsf_time);
 }
 
+/*
+ * This will be called only when multi-channel is enabled
+ * and since the max. number of interfaces is limited to two,
+ * a channel context is guaranteed to have only one interface.
+ * So, we can get the aid by iterating over the vif list in
+ * the current channel context.
+ */
+static void ath_chanctx_check_tim(struct ath_softc *sc,
+				  struct sk_buff *skb)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_vif *vif;
+	struct ath_vif *avp;
+	struct ieee80211_tim_ie *tim_ie;
+	const u8 *tim;
+	size_t ies_len;
+	u8 tim_len;
+	u8 *ies;
+
+	mgmt = (struct ieee80211_mgmt *)skb->data;
+	ies = mgmt->u.beacon.variable;
+	ies_len = (u8 *)skb_tail_pointer(skb) - ies;
+
+	tim = cfg80211_find_ie(WLAN_EID_TIM, ies, ies_len);
+	if (!tim)
+		return;
+
+	tim_len = tim[1];
+	tim_ie = (struct ieee80211_tim_ie *) &tim[2];
+
+	list_for_each_entry(avp, &sc->cur_chan->vifs, list) {
+		vif = avp->vif;
+
+		if (vif->type == NL80211_IFTYPE_STATION && vif->bss_conf.assoc) {
+			sc->sched.tim_set = ieee80211_check_tim(tim_ie,
+						tim_len, vif->bss_conf.aid);
+			if (sc->sched.tim_set) {
+				ath_dbg(common, CHAN_CTX,
+					"TIM bit set for aid: %d, vif: %pM\n",
+					vif->bss_conf.aid, vif->addr);
+			}
+			break;
+		}
+	}
+
+
+}
+
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev)
 {
@@ -427,7 +476,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			ath9k_hw_get_tsf_offset(&sc->cur_chan->tsf_ts, NULL);
 		tsf_time += ath9k_hw_gettsf32(ah);
 
-
+		ath_chanctx_check_tim(sc, sc->cur_chan->beacon_skb);
 		ath_chanctx_setup_timer(sc, tsf_time);
 		break;
 	case ATH_CHANCTX_EVENT_ASSOC:
@@ -521,10 +570,13 @@ void ath_chanctx_beacon_sent_ev(struct ath_softc *sc,
 		ath_chanctx_event(sc, NULL, ev);
 }
 
-void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
+void ath_chanctx_beacon_recv_ev(struct ath_softc *sc,
+				struct sk_buff *skb,
+				u32 ts,
 				enum ath_chanctx_event ev)
 {
 	sc->sched.next_tbtt = ts;
+	sc->cur_chan->beacon_skb = skb;
 	ath_chanctx_event(sc, NULL, ev);
 }
 
@@ -809,6 +861,16 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 		if (!vif->bss_conf.assoc)
 			return false;
 
+		/*
+		 * When we are coming out of PS, send a nullfunc
+		 * with PM bit cleared only when we know there is
+		 * buffered traffic at the AP.
+		 */
+		if (!powersave) {
+			if (!sc->sched.tim_set)
+				return false;
+		}
+
 		skb = ieee80211_nullfunc_get(sc->hw, vif);
 		if (!skb)
 			return false;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2aaf233..1edf8cb 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -892,12 +892,6 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		return -EINVAL;
 	}
 
-	if (ath9k_is_chanctx_enabled()) {
-		if (rx_stats->is_mybeacon)
-			ath_chanctx_beacon_recv_ev(sc, rx_stats->rs_tstamp,
-					   ATH_CHANCTX_EVENT_BEACON_RECEIVED);
-	}
-
 	ath9k_cmn_process_rssi(common, hw, rx_stats, rx_status);
 
 	rx_status->band = ah->curchan->chan->band;
@@ -1117,6 +1111,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			ath_rx_ps(sc, skb, rs.is_mybeacon);
 		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
+		if (ath9k_is_chanctx_enabled()) {
+			if (rs.is_mybeacon)
+				ath_chanctx_beacon_recv_ev(sc, skb, rs.rs_tstamp,
+					   ATH_CHANCTX_EVENT_BEACON_RECEIVED);
+		}
+
 		ath9k_antenna_check(sc, &rs);
 		ath9k_apply_ampdu_details(sc, &rs, rxs);
 		ath_debug_rate_stats(sc, &rs, skb);
-- 
2.1.0

