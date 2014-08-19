Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45767 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaHSJTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 05:19:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/3] ath9k: Move channel operations to channel.c
Date: Tue, 19 Aug 2014 14:03:33 +0530
Message-Id: <1408437213-3363-3-git-send-email-sujith@msujith.org> (sfid-20140819_111947_117953_D1A36BA1)
In-Reply-To: <1408437213-3363-1-git-send-email-sujith@msujith.org>
References: <1408437213-3363-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This reduces clutter in main.c

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |   3 +
 drivers/net/wireless/ath/ath9k/channel.c | 202 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c    | 202 -------------------------------
 3 files changed, 205 insertions(+), 202 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7fc13a8..17b198e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -432,6 +432,9 @@ struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc,
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev);
 void ath_chanctx_timer(unsigned long data);
+void ath_offchannel_next(struct ath_softc *sc);
+void ath_scan_complete(struct ath_softc *sc, bool abort);
+void ath_roc_complete(struct ath_softc *sc, bool abort);
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index ba214eb..0ce9e40 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -683,3 +683,205 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 
 	spin_unlock_bh(&sc->chan_lock);
 }
+
+static int ath_scan_channel_duration(struct ath_softc *sc,
+				     struct ieee80211_channel *chan)
+{
+	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
+
+	if (!req->n_ssids || (chan->flags & IEEE80211_CHAN_NO_IR))
+		return (HZ / 9); /* ~110 ms */
+
+	return (HZ / 16); /* ~60 ms */
+}
+
+static void
+ath_scan_next_channel(struct ath_softc *sc)
+{
+	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
+	struct ieee80211_channel *chan;
+
+	if (sc->offchannel.scan_idx >= req->n_channels) {
+		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
+		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false),
+				   NULL);
+		return;
+	}
+
+	chan = req->channels[sc->offchannel.scan_idx++];
+	sc->offchannel.duration = ath_scan_channel_duration(sc, chan);
+	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_SEND;
+	ath_chanctx_offchan_switch(sc, chan);
+}
+
+void ath_offchannel_next(struct ath_softc *sc)
+{
+	struct ieee80211_vif *vif;
+
+	if (sc->offchannel.scan_req) {
+		vif = sc->offchannel.scan_vif;
+		sc->offchannel.chan.txpower = vif->bss_conf.txpower;
+		ath_scan_next_channel(sc);
+	} else if (sc->offchannel.roc_vif) {
+		vif = sc->offchannel.roc_vif;
+		sc->offchannel.chan.txpower = vif->bss_conf.txpower;
+		sc->offchannel.duration = sc->offchannel.roc_duration;
+		sc->offchannel.state = ATH_OFFCHANNEL_ROC_START;
+		ath_chanctx_offchan_switch(sc, sc->offchannel.roc_chan);
+	} else {
+		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false),
+				   NULL);
+		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
+		if (sc->ps_idle)
+			ath_cancel_work(sc);
+	}
+}
+
+void ath_roc_complete(struct ath_softc *sc, bool abort)
+{
+	sc->offchannel.roc_vif = NULL;
+	sc->offchannel.roc_chan = NULL;
+	if (!abort)
+		ieee80211_remain_on_channel_expired(sc->hw);
+	ath_offchannel_next(sc);
+	ath9k_ps_restore(sc);
+}
+
+void ath_scan_complete(struct ath_softc *sc, bool abort)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	sc->offchannel.scan_req = NULL;
+	sc->offchannel.scan_vif = NULL;
+	sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
+	ieee80211_scan_completed(sc->hw, abort);
+	clear_bit(ATH_OP_SCANNING, &common->op_flags);
+	ath_offchannel_next(sc);
+	ath9k_ps_restore(sc);
+}
+
+static void ath_scan_send_probe(struct ath_softc *sc,
+				struct cfg80211_ssid *ssid)
+{
+	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
+	struct ieee80211_vif *vif = sc->offchannel.scan_vif;
+	struct ath_tx_control txctl = {};
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
+	int band = sc->offchannel.chan.chandef.chan->band;
+
+	skb = ieee80211_probereq_get(sc->hw, vif,
+			ssid->ssid, ssid->ssid_len, req->ie_len);
+	if (!skb)
+		return;
+
+	info = IEEE80211_SKB_CB(skb);
+	if (req->no_cck)
+		info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
+
+	if (req->ie_len)
+		memcpy(skb_put(skb, req->ie_len), req->ie, req->ie_len);
+
+	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
+
+	if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, NULL))
+		goto error;
+
+	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
+	txctl.force_channel = true;
+	if (ath_tx_start(sc->hw, skb, &txctl))
+		goto error;
+
+	return;
+
+error:
+	ieee80211_free_txskb(sc->hw, skb);
+}
+
+static void ath_scan_channel_start(struct ath_softc *sc)
+{
+	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
+	int i;
+
+	if (!(sc->cur_chan->chandef.chan->flags & IEEE80211_CHAN_NO_IR) &&
+	    req->n_ssids) {
+		for (i = 0; i < req->n_ssids; i++)
+			ath_scan_send_probe(sc, &req->ssids[i]);
+
+	}
+
+	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_WAIT;
+	mod_timer(&sc->offchannel.timer, jiffies + sc->offchannel.duration);
+}
+
+void ath_offchannel_channel_change(struct ath_softc *sc)
+{
+	switch (sc->offchannel.state) {
+	case ATH_OFFCHANNEL_PROBE_SEND:
+		if (!sc->offchannel.scan_req)
+			return;
+
+		if (sc->cur_chan->chandef.chan !=
+		    sc->offchannel.chan.chandef.chan)
+			return;
+
+		ath_scan_channel_start(sc);
+		break;
+	case ATH_OFFCHANNEL_IDLE:
+		if (!sc->offchannel.scan_req)
+			return;
+
+		ath_scan_complete(sc, false);
+		break;
+	case ATH_OFFCHANNEL_ROC_START:
+		if (sc->cur_chan != &sc->offchannel.chan)
+			break;
+
+		sc->offchannel.state = ATH_OFFCHANNEL_ROC_WAIT;
+		mod_timer(&sc->offchannel.timer, jiffies +
+			  msecs_to_jiffies(sc->offchannel.duration));
+		ieee80211_ready_on_channel(sc->hw);
+		break;
+	case ATH_OFFCHANNEL_ROC_DONE:
+		ath_roc_complete(sc, false);
+		break;
+	default:
+		break;
+	}
+}
+
+void ath_offchannel_timer(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_chanctx *ctx;
+
+	switch (sc->offchannel.state) {
+	case ATH_OFFCHANNEL_PROBE_WAIT:
+		if (!sc->offchannel.scan_req)
+			return;
+
+		/* get first active channel context */
+		ctx = ath_chanctx_get_oper_chan(sc, true);
+		if (ctx->active) {
+			sc->offchannel.state = ATH_OFFCHANNEL_SUSPEND;
+			ath_chanctx_switch(sc, ctx, NULL);
+			mod_timer(&sc->offchannel.timer, jiffies + HZ / 10);
+			break;
+		}
+		/* fall through */
+	case ATH_OFFCHANNEL_SUSPEND:
+		if (!sc->offchannel.scan_req)
+			return;
+
+		ath_scan_next_channel(sc);
+		break;
+	case ATH_OFFCHANNEL_ROC_START:
+	case ATH_OFFCHANNEL_ROC_WAIT:
+		ctx = ath_chanctx_get_oper_chan(sc, false);
+		sc->offchannel.state = ATH_OFFCHANNEL_ROC_DONE;
+		ath_chanctx_switch(sc, ctx, NULL);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e6ac8d2..b1d15f3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2207,208 +2207,6 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	clear_bit(ATH_OP_SCANNING, &common->op_flags);
 }
 
-static int ath_scan_channel_duration(struct ath_softc *sc,
-				     struct ieee80211_channel *chan)
-{
-	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
-
-	if (!req->n_ssids || (chan->flags & IEEE80211_CHAN_NO_IR))
-		return (HZ / 9); /* ~110 ms */
-
-	return (HZ / 16); /* ~60 ms */
-}
-
-static void
-ath_scan_next_channel(struct ath_softc *sc)
-{
-	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
-	struct ieee80211_channel *chan;
-
-	if (sc->offchannel.scan_idx >= req->n_channels) {
-		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
-		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false),
-				   NULL);
-		return;
-	}
-
-	chan = req->channels[sc->offchannel.scan_idx++];
-	sc->offchannel.duration = ath_scan_channel_duration(sc, chan);
-	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_SEND;
-	ath_chanctx_offchan_switch(sc, chan);
-}
-
-static void ath_offchannel_next(struct ath_softc *sc)
-{
-	struct ieee80211_vif *vif;
-
-	if (sc->offchannel.scan_req) {
-		vif = sc->offchannel.scan_vif;
-		sc->offchannel.chan.txpower = vif->bss_conf.txpower;
-		ath_scan_next_channel(sc);
-	} else if (sc->offchannel.roc_vif) {
-		vif = sc->offchannel.roc_vif;
-		sc->offchannel.chan.txpower = vif->bss_conf.txpower;
-		sc->offchannel.duration = sc->offchannel.roc_duration;
-		sc->offchannel.state = ATH_OFFCHANNEL_ROC_START;
-		ath_chanctx_offchan_switch(sc, sc->offchannel.roc_chan);
-	} else {
-		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false),
-				   NULL);
-		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
-		if (sc->ps_idle)
-			ath_cancel_work(sc);
-	}
-}
-
-static void ath_roc_complete(struct ath_softc *sc, bool abort)
-{
-	sc->offchannel.roc_vif = NULL;
-	sc->offchannel.roc_chan = NULL;
-	if (!abort)
-		ieee80211_remain_on_channel_expired(sc->hw);
-	ath_offchannel_next(sc);
-	ath9k_ps_restore(sc);
-}
-
-static void ath_scan_complete(struct ath_softc *sc, bool abort)
-{
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-
-	sc->offchannel.scan_req = NULL;
-	sc->offchannel.scan_vif = NULL;
-	sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
-	ieee80211_scan_completed(sc->hw, abort);
-	clear_bit(ATH_OP_SCANNING, &common->op_flags);
-	ath_offchannel_next(sc);
-	ath9k_ps_restore(sc);
-}
-
-static void ath_scan_send_probe(struct ath_softc *sc,
-				struct cfg80211_ssid *ssid)
-{
-	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
-	struct ieee80211_vif *vif = sc->offchannel.scan_vif;
-	struct ath_tx_control txctl = {};
-	struct sk_buff *skb;
-	struct ieee80211_tx_info *info;
-	int band = sc->offchannel.chan.chandef.chan->band;
-
-	skb = ieee80211_probereq_get(sc->hw, vif,
-			ssid->ssid, ssid->ssid_len, req->ie_len);
-	if (!skb)
-		return;
-
-	info = IEEE80211_SKB_CB(skb);
-	if (req->no_cck)
-		info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
-
-	if (req->ie_len)
-		memcpy(skb_put(skb, req->ie_len), req->ie, req->ie_len);
-
-	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
-
-	if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, NULL))
-		goto error;
-
-	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
-	txctl.force_channel = true;
-	if (ath_tx_start(sc->hw, skb, &txctl))
-		goto error;
-
-	return;
-
-error:
-	ieee80211_free_txskb(sc->hw, skb);
-}
-
-static void ath_scan_channel_start(struct ath_softc *sc)
-{
-	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
-	int i;
-
-	if (!(sc->cur_chan->chandef.chan->flags & IEEE80211_CHAN_NO_IR) &&
-	    req->n_ssids) {
-		for (i = 0; i < req->n_ssids; i++)
-			ath_scan_send_probe(sc, &req->ssids[i]);
-
-	}
-
-	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_WAIT;
-	mod_timer(&sc->offchannel.timer, jiffies + sc->offchannel.duration);
-}
-
-void ath_offchannel_channel_change(struct ath_softc *sc)
-{
-	switch (sc->offchannel.state) {
-	case ATH_OFFCHANNEL_PROBE_SEND:
-		if (!sc->offchannel.scan_req)
-			return;
-
-		if (sc->cur_chan->chandef.chan !=
-		    sc->offchannel.chan.chandef.chan)
-			return;
-
-		ath_scan_channel_start(sc);
-		break;
-	case ATH_OFFCHANNEL_IDLE:
-		if (!sc->offchannel.scan_req)
-			return;
-
-		ath_scan_complete(sc, false);
-		break;
-	case ATH_OFFCHANNEL_ROC_START:
-		if (sc->cur_chan != &sc->offchannel.chan)
-			break;
-
-		sc->offchannel.state = ATH_OFFCHANNEL_ROC_WAIT;
-		mod_timer(&sc->offchannel.timer, jiffies +
-			  msecs_to_jiffies(sc->offchannel.duration));
-		ieee80211_ready_on_channel(sc->hw);
-		break;
-	case ATH_OFFCHANNEL_ROC_DONE:
-		ath_roc_complete(sc, false);
-		break;
-	default:
-		break;
-	}
-}
-
-void ath_offchannel_timer(unsigned long data)
-{
-	struct ath_softc *sc = (struct ath_softc *)data;
-	struct ath_chanctx *ctx;
-
-	switch (sc->offchannel.state) {
-	case ATH_OFFCHANNEL_PROBE_WAIT:
-		if (!sc->offchannel.scan_req)
-			return;
-
-		/* get first active channel context */
-		ctx = ath_chanctx_get_oper_chan(sc, true);
-		if (ctx->active) {
-			sc->offchannel.state = ATH_OFFCHANNEL_SUSPEND;
-			ath_chanctx_switch(sc, ctx, NULL);
-			mod_timer(&sc->offchannel.timer, jiffies + HZ / 10);
-			break;
-		}
-		/* fall through */
-	case ATH_OFFCHANNEL_SUSPEND:
-		if (!sc->offchannel.scan_req)
-			return;
-
-		ath_scan_next_channel(sc);
-		break;
-	case ATH_OFFCHANNEL_ROC_START:
-	case ATH_OFFCHANNEL_ROC_WAIT:
-		ctx = ath_chanctx_get_oper_chan(sc, false);
-		sc->offchannel.state = ATH_OFFCHANNEL_ROC_DONE;
-		ath_chanctx_switch(sc, ctx, NULL);
-		break;
-	default:
-		break;
-	}
-}
-
 static int ath9k_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_scan_request *hw_req)
 {
-- 
2.0.4

