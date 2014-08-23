Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42703 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaHWH70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 05/18] ath9k: Conditionally compile a few functions
Date: Sat, 23 Aug 2014 13:29:10 +0530
Message-Id: <1408780763-27974-6-git-send-email-sujith@msujith.org> (sfid-20140823_101533_866353_B4B65F0B)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Exclude these functions when CONFIG_ATH9K_CHANNEL_CONTEXT is not
enabled:

ath_chanctx_send_vif_ps_frame()
ath_chanctx_send_ps_frame()
ath_chanctx_defer_switch()
ath_chanctx_set_next()

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 292 +++++++++++++++----------------
 1 file changed, 146 insertions(+), 146 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 4525fc0..61ed7a7 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -118,53 +118,6 @@ static int ath_set_channel(struct ath_softc *sc)
 	return 0;
 }
 
-static bool
-ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
-			      bool powersave)
-{
-	struct ieee80211_vif *vif = avp->vif;
-	struct ieee80211_sta *sta = NULL;
-	struct ieee80211_hdr_3addr *nullfunc;
-	struct ath_tx_control txctl;
-	struct sk_buff *skb;
-	int band = sc->cur_chan->chandef.chan->band;
-
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		if (!vif->bss_conf.assoc)
-			return false;
-
-		skb = ieee80211_nullfunc_get(sc->hw, vif);
-		if (!skb)
-			return false;
-
-		nullfunc = (struct ieee80211_hdr_3addr *) skb->data;
-		if (powersave)
-			nullfunc->frame_control |=
-				cpu_to_le16(IEEE80211_FCTL_PM);
-
-		skb_set_queue_mapping(skb, IEEE80211_AC_VO);
-		if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, &sta)) {
-			dev_kfree_skb_any(skb);
-			return false;
-		}
-		break;
-	default:
-		return false;
-	}
-
-	memset(&txctl, 0, sizeof(txctl));
-	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
-	txctl.sta = sta;
-	txctl.force_channel = true;
-	if (ath_tx_start(sc->hw, skb, &txctl)) {
-		ieee80211_free_txskb(sc->hw, skb);
-		return false;
-	}
-
-	return true;
-}
-
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -206,105 +159,6 @@ void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL);
 }
 
-static bool
-ath_chanctx_send_ps_frame(struct ath_softc *sc, bool powersave)
-{
-	struct ath_vif *avp;
-	bool sent = false;
-
-	rcu_read_lock();
-	list_for_each_entry(avp, &sc->cur_chan->vifs, list) {
-		if (ath_chanctx_send_vif_ps_frame(sc, avp, powersave))
-			sent = true;
-	}
-	rcu_read_unlock();
-
-	return sent;
-}
-
-static bool ath_chanctx_defer_switch(struct ath_softc *sc)
-{
-	if (sc->cur_chan == &sc->offchannel.chan)
-		return false;
-
-	switch (sc->sched.state) {
-	case ATH_CHANCTX_STATE_SWITCH:
-		return false;
-	case ATH_CHANCTX_STATE_IDLE:
-		if (!sc->cur_chan->switch_after_beacon)
-			return false;
-
-		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
-		break;
-	default:
-		break;
-	}
-
-	return true;
-}
-
-void ath_chanctx_set_next(struct ath_softc *sc, bool force)
-{
-	struct timespec ts;
-	bool measure_time = false;
-	bool send_ps = false;
-
-	spin_lock_bh(&sc->chan_lock);
-	if (!sc->next_chan) {
-		spin_unlock_bh(&sc->chan_lock);
-		return;
-	}
-
-	if (!force && ath_chanctx_defer_switch(sc)) {
-		spin_unlock_bh(&sc->chan_lock);
-		return;
-	}
-
-	if (sc->cur_chan != sc->next_chan) {
-		sc->cur_chan->stopped = true;
-		spin_unlock_bh(&sc->chan_lock);
-
-		if (sc->next_chan == &sc->offchannel.chan) {
-			getrawmonotonic(&ts);
-			measure_time = true;
-		}
-		__ath9k_flush(sc->hw, ~0, true);
-
-		if (ath_chanctx_send_ps_frame(sc, true))
-			__ath9k_flush(sc->hw, BIT(IEEE80211_AC_VO), false);
-
-		send_ps = true;
-		spin_lock_bh(&sc->chan_lock);
-
-		if (sc->cur_chan != &sc->offchannel.chan) {
-			getrawmonotonic(&sc->cur_chan->tsf_ts);
-			sc->cur_chan->tsf_val = ath9k_hw_gettsf64(sc->sc_ah);
-		}
-	}
-	sc->cur_chan = sc->next_chan;
-	sc->cur_chan->stopped = false;
-	sc->next_chan = NULL;
-	sc->sched.offchannel_duration = 0;
-	if (sc->sched.state != ATH_CHANCTX_STATE_FORCE_ACTIVE)
-		sc->sched.state = ATH_CHANCTX_STATE_IDLE;
-
-	spin_unlock_bh(&sc->chan_lock);
-
-	if (sc->sc_ah->chip_fullsleep ||
-	    memcmp(&sc->cur_chandef, &sc->cur_chan->chandef,
-		   sizeof(sc->cur_chandef))) {
-		ath_set_channel(sc);
-		if (measure_time)
-			sc->sched.channel_switch_time =
-				ath9k_hw_get_tsf_offset(&ts, NULL);
-	}
-	if (send_ps)
-		ath_chanctx_send_ps_frame(sc, false);
-
-	ath_offchannel_channel_change(sc);
-	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_SWITCH);
-}
-
 void ath_chanctx_init(struct ath_softc *sc)
 {
 	struct ath_chanctx *ctx;
@@ -910,6 +764,152 @@ static void ath_offchannel_timer(unsigned long data)
 	}
 }
 
+static bool
+ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
+			      bool powersave)
+{
+	struct ieee80211_vif *vif = avp->vif;
+	struct ieee80211_sta *sta = NULL;
+	struct ieee80211_hdr_3addr *nullfunc;
+	struct ath_tx_control txctl;
+	struct sk_buff *skb;
+	int band = sc->cur_chan->chandef.chan->band;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		if (!vif->bss_conf.assoc)
+			return false;
+
+		skb = ieee80211_nullfunc_get(sc->hw, vif);
+		if (!skb)
+			return false;
+
+		nullfunc = (struct ieee80211_hdr_3addr *) skb->data;
+		if (powersave)
+			nullfunc->frame_control |=
+				cpu_to_le16(IEEE80211_FCTL_PM);
+
+		skb_set_queue_mapping(skb, IEEE80211_AC_VO);
+		if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, &sta)) {
+			dev_kfree_skb_any(skb);
+			return false;
+		}
+		break;
+	default:
+		return false;
+	}
+
+	memset(&txctl, 0, sizeof(txctl));
+	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
+	txctl.sta = sta;
+	txctl.force_channel = true;
+	if (ath_tx_start(sc->hw, skb, &txctl)) {
+		ieee80211_free_txskb(sc->hw, skb);
+		return false;
+	}
+
+	return true;
+}
+
+static bool
+ath_chanctx_send_ps_frame(struct ath_softc *sc, bool powersave)
+{
+	struct ath_vif *avp;
+	bool sent = false;
+
+	rcu_read_lock();
+	list_for_each_entry(avp, &sc->cur_chan->vifs, list) {
+		if (ath_chanctx_send_vif_ps_frame(sc, avp, powersave))
+			sent = true;
+	}
+	rcu_read_unlock();
+
+	return sent;
+}
+
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
+void ath_chanctx_set_next(struct ath_softc *sc, bool force)
+{
+	struct timespec ts;
+	bool measure_time = false;
+	bool send_ps = false;
+
+	spin_lock_bh(&sc->chan_lock);
+	if (!sc->next_chan) {
+		spin_unlock_bh(&sc->chan_lock);
+		return;
+	}
+
+	if (!force && ath_chanctx_defer_switch(sc)) {
+		spin_unlock_bh(&sc->chan_lock);
+		return;
+	}
+
+	if (sc->cur_chan != sc->next_chan) {
+		sc->cur_chan->stopped = true;
+		spin_unlock_bh(&sc->chan_lock);
+
+		if (sc->next_chan == &sc->offchannel.chan) {
+			getrawmonotonic(&ts);
+			measure_time = true;
+		}
+		__ath9k_flush(sc->hw, ~0, true);
+
+		if (ath_chanctx_send_ps_frame(sc, true))
+			__ath9k_flush(sc->hw, BIT(IEEE80211_AC_VO), false);
+
+		send_ps = true;
+		spin_lock_bh(&sc->chan_lock);
+
+		if (sc->cur_chan != &sc->offchannel.chan) {
+			getrawmonotonic(&sc->cur_chan->tsf_ts);
+			sc->cur_chan->tsf_val = ath9k_hw_gettsf64(sc->sc_ah);
+		}
+	}
+	sc->cur_chan = sc->next_chan;
+	sc->cur_chan->stopped = false;
+	sc->next_chan = NULL;
+	sc->sched.offchannel_duration = 0;
+	if (sc->sched.state != ATH_CHANCTX_STATE_FORCE_ACTIVE)
+		sc->sched.state = ATH_CHANCTX_STATE_IDLE;
+
+	spin_unlock_bh(&sc->chan_lock);
+
+	if (sc->sc_ah->chip_fullsleep ||
+	    memcmp(&sc->cur_chandef, &sc->cur_chan->chandef,
+		   sizeof(sc->cur_chandef))) {
+		ath_set_channel(sc);
+		if (measure_time)
+			sc->sched.channel_switch_time =
+				ath9k_hw_get_tsf_offset(&ts, NULL);
+	}
+	if (send_ps)
+		ath_chanctx_send_ps_frame(sc, false);
+
+	ath_offchannel_channel_change(sc);
+	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_SWITCH);
+}
+
 static void ath_chanctx_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc,
-- 
2.0.4

