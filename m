Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58134 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaHVERp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 00:17:45 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2] ath9k: Add debug information
Date: Fri, 22 Aug 2014 09:47:48 +0530
Message-Id: <1408681068-14633-1-git-send-email-sujith@msujith.org> (sfid-20140822_061749_401168_685F52EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Add a few statements to debug channel context operation.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
v2: Changes based on Joe Perches' comments.

 drivers/net/wireless/ath/ath9k/channel.c | 61 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/main.c    | 73 +++++++++++++++++++++++++++-----
 2 files changed, 122 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 0ce9e40..2f10b0c 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -16,6 +16,23 @@
 
 #include "ath9k.h"
 
+static const char *offchannel_state_string(enum ath_offchannel_state state)
+{
+#define case_rtn_string(val) case val: return #val
+
+	switch (state) {
+		case_rtn_string(ATH_OFFCHANNEL_IDLE);
+		case_rtn_string(ATH_OFFCHANNEL_PROBE_SEND);
+		case_rtn_string(ATH_OFFCHANNEL_PROBE_WAIT);
+		case_rtn_string(ATH_OFFCHANNEL_SUSPEND);
+		case_rtn_string(ATH_OFFCHANNEL_ROC_START);
+		case_rtn_string(ATH_OFFCHANNEL_ROC_WAIT);
+		case_rtn_string(ATH_OFFCHANNEL_ROC_DONE);
+	default:
+		return "unknown";
+	}
+}
+
 /* Set/change channels.  If the channel is really being changed, it's done
  * by reseting the chip.  To accomplish this we must first cleanup any pending
  * DMA, then restart stuff.
@@ -373,13 +390,23 @@ void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 	}
 
 	sc->next_chan = ctx;
-	if (chandef)
+	if (chandef) {
 		ctx->chandef = *chandef;
+		ath_dbg(common, CHAN_CTX,
+			"Assigned next_chan to %d MHz\n", chandef->center_freq1);
+	}
 
 	if (sc->next_chan == &sc->offchannel.chan) {
 		sc->sched.offchannel_duration =
 			TU_TO_USEC(sc->offchannel.duration) +
 			sc->sched.channel_switch_time;
+
+		if (chandef) {
+			ath_dbg(common, CHAN_CTX,
+				"Offchannel duration for chan %d MHz : %u\n",
+				chandef->center_freq1,
+				sc->sched.offchannel_duration);
+		}
 	}
 	spin_unlock_bh(&sc->chan_lock);
 	ieee80211_queue_work(sc->hw, &sc->chanctx_work);
@@ -422,9 +449,12 @@ struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc, bool active)
 void ath_chanctx_offchan_switch(struct ath_softc *sc,
 				struct ieee80211_channel *chan)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct cfg80211_chan_def chandef;
 
 	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
+	ath_dbg(common, CHAN_CTX,
+		"Channel definition created: %d MHz\n", chandef.center_freq1);
 
 	ath_chanctx_switch(sc, &sc->offchannel.chan, &chandef);
 }
@@ -698,19 +728,30 @@ static int ath_scan_channel_duration(struct ath_softc *sc,
 static void
 ath_scan_next_channel(struct ath_softc *sc)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
 	struct ieee80211_channel *chan;
 
 	if (sc->offchannel.scan_idx >= req->n_channels) {
+		ath_dbg(common, CHAN_CTX,
+			"Moving to ATH_OFFCHANNEL_IDLE state, scan_idx: %d, n_channels: %d\n",
+			sc->offchannel.scan_idx,
+			req->n_channels);
+
 		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
 		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false),
 				   NULL);
 		return;
 	}
 
+	ath_dbg(common, CHAN_CTX,
+		"Moving to ATH_OFFCHANNEL_PROBE_SEND state, scan_idx: %d\n",
+		sc->offchannel.scan_idx);
+
 	chan = req->channels[sc->offchannel.scan_idx++];
 	sc->offchannel.duration = ath_scan_channel_duration(sc, chan);
 	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_SEND;
+
 	ath_chanctx_offchan_switch(sc, chan);
 }
 
@@ -751,6 +792,11 @@ void ath_scan_complete(struct ath_softc *sc, bool abort)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
+	if (abort)
+		ath_dbg(common, CHAN_CTX, "HW scan aborted\n");
+	else
+		ath_dbg(common, CHAN_CTX, "HW scan complete\n");
+
 	sc->offchannel.scan_req = NULL;
 	sc->offchannel.scan_vif = NULL;
 	sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
@@ -800,6 +846,7 @@ error:
 
 static void ath_scan_channel_start(struct ath_softc *sc)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
 	int i;
 
@@ -810,12 +857,20 @@ static void ath_scan_channel_start(struct ath_softc *sc)
 
 	}
 
+	ath_dbg(common, CHAN_CTX,
+		"Moving to ATH_OFFCHANNEL_PROBE_WAIT state\n");
+
 	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_WAIT;
 	mod_timer(&sc->offchannel.timer, jiffies + sc->offchannel.duration);
 }
 
 void ath_offchannel_channel_change(struct ath_softc *sc)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_dbg(common, CHAN_CTX, "%s: state: %s\n",
+		__func__, offchannel_state_string(sc->offchannel.state));
+
 	switch (sc->offchannel.state) {
 	case ATH_OFFCHANNEL_PROBE_SEND:
 		if (!sc->offchannel.scan_req)
@@ -854,6 +909,10 @@ void ath_offchannel_timer(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_chanctx *ctx;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_dbg(common, CHAN_CTX, "%s: state: %s\n",
+		__func__, offchannel_state_string(sc->offchannel.state));
 
 	switch (sc->offchannel.state) {
 	case ATH_OFFCHANNEL_PROBE_WAIT:
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b1d15f3..194895b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2228,8 +2228,13 @@ static int ath9k_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	sc->offchannel.scan_req = req;
 	sc->offchannel.scan_idx = 0;
 
-	if (sc->offchannel.state == ATH_OFFCHANNEL_IDLE)
+	ath_dbg(common, CHAN_CTX, "HW scan request received on vif: %pM\n",
+		vif->addr);
+
+	if (sc->offchannel.state == ATH_OFFCHANNEL_IDLE) {
+		ath_dbg(common, CHAN_CTX, "Starting HW scan\n");
 		ath_offchannel_next(sc);
+	}
 
 out:
 	mutex_unlock(&sc->mutex);
@@ -2241,6 +2246,9 @@ static void ath9k_cancel_hw_scan(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_dbg(common, CHAN_CTX, "Cancel HW scan on vif: %pM\n", vif->addr);
 
 	mutex_lock(&sc->mutex);
 	del_timer_sync(&sc->offchannel.timer);
@@ -2254,6 +2262,7 @@ static int ath9k_remain_on_channel(struct ieee80211_hw *hw,
 				   enum ieee80211_roc_type type)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int ret = 0;
 
 	mutex_lock(&sc->mutex);
@@ -2268,8 +2277,14 @@ static int ath9k_remain_on_channel(struct ieee80211_hw *hw,
 	sc->offchannel.roc_chan = chan;
 	sc->offchannel.roc_duration = duration;
 
-	if (sc->offchannel.state == ATH_OFFCHANNEL_IDLE)
+	ath_dbg(common, CHAN_CTX,
+		"RoC request on vif: %pM, type: %d duration: %d\n",
+		vif->addr, type, duration);
+
+	if (sc->offchannel.state == ATH_OFFCHANNEL_IDLE) {
+		ath_dbg(common, CHAN_CTX, "Starting RoC period\n");
 		ath_offchannel_next(sc);
+	}
 
 out:
 	mutex_unlock(&sc->mutex);
@@ -2280,9 +2295,11 @@ out:
 static int ath9k_cancel_remain_on_channel(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	mutex_lock(&sc->mutex);
 
+	ath_dbg(common, CHAN_CTX, "Cancel RoC\n");
 	del_timer_sync(&sc->offchannel.timer);
 
 	if (sc->offchannel.roc_vif) {
@@ -2299,6 +2316,7 @@ static int ath9k_add_chanctx(struct ieee80211_hw *hw,
 			     struct ieee80211_chanctx_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_chanctx *ctx, **ptr;
 	int pos;
 
@@ -2313,10 +2331,16 @@ static int ath9k_add_chanctx(struct ieee80211_hw *hw,
 		ctx->assigned = true;
 		pos = ctx - &sc->chanctx[0];
 		ctx->hw_queue_base = pos * IEEE80211_NUM_ACS;
+
+		ath_dbg(common, CHAN_CTX,
+			"Add channel context: %d MHz\n",
+			conf->def.chan->center_freq);
+
 		ath_chanctx_set_channel(sc, ctx, &conf->def);
 		mutex_unlock(&sc->mutex);
 		return 0;
 	}
+
 	mutex_unlock(&sc->mutex);
 	return -ENOSPC;
 }
@@ -2326,12 +2350,19 @@ static void ath9k_remove_chanctx(struct ieee80211_hw *hw,
 				 struct ieee80211_chanctx_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_chanctx *ctx = ath_chanctx_get(conf);
 
 	mutex_lock(&sc->mutex);
+
+	ath_dbg(common, CHAN_CTX,
+		"Remove channel context: %d MHz\n",
+		conf->def.chan->center_freq);
+
 	ctx->assigned = false;
 	ctx->hw_queue_base = -1;
 	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_UNASSIGN);
+
 	mutex_unlock(&sc->mutex);
 }
 
@@ -2340,9 +2371,13 @@ static void ath9k_change_chanctx(struct ieee80211_hw *hw,
 				 u32 changed)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_chanctx *ctx = ath_chanctx_get(conf);
 
 	mutex_lock(&sc->mutex);
+	ath_dbg(common, CHAN_CTX,
+		"Change channel context: %d MHz\n",
+		conf->def.chan->center_freq);
 	ath_chanctx_set_channel(sc, ctx, &conf->def);
 	mutex_unlock(&sc->mutex);
 }
@@ -2352,16 +2387,24 @@ static int ath9k_assign_vif_chanctx(struct ieee80211_hw *hw,
 				    struct ieee80211_chanctx_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_chanctx *ctx = ath_chanctx_get(conf);
 	int i;
 
 	mutex_lock(&sc->mutex);
+
+	ath_dbg(common, CHAN_CTX,
+		"Assign VIF (addr: %pM, type: %d, p2p: %d) to channel context: %d MHz\n",
+		vif->addr, vif->type, vif->p2p,
+		conf->def.chan->center_freq);
+
 	avp->chanctx = ctx;
 	list_add_tail(&avp->list, &ctx->vifs);
 	ath9k_calculate_summary_state(sc, ctx);
 	for (i = 0; i < IEEE80211_NUM_ACS; i++)
 		vif->hw_queue[i] = ctx->hw_queue_base + i;
+
 	mutex_unlock(&sc->mutex);
 
 	return 0;
@@ -2372,16 +2415,24 @@ static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
 				       struct ieee80211_chanctx_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_chanctx *ctx = ath_chanctx_get(conf);
 	int ac;
 
 	mutex_lock(&sc->mutex);
+
+	ath_dbg(common, CHAN_CTX,
+		"Remove VIF (addr: %pM, type: %d, p2p: %d) from channel context: %d MHz\n",
+		vif->addr, vif->type, vif->p2p,
+		conf->def.chan->center_freq);
+
 	avp->chanctx = NULL;
 	list_del(&avp->list);
 	ath9k_calculate_summary_state(sc, ctx);
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 		vif->hw_queue[ac] = IEEE80211_INVAL_HW_QUEUE;
+
 	mutex_unlock(&sc->mutex);
 }
 
@@ -2390,16 +2441,16 @@ void ath9k_fill_chanctx_ops(void)
 	if (!ath9k_use_chanctx)
 		return;
 
-	ath9k_ops.hw_scan = ath9k_hw_scan;
-	ath9k_ops.cancel_hw_scan = ath9k_cancel_hw_scan;
-	ath9k_ops.remain_on_channel  = ath9k_remain_on_channel;
+	ath9k_ops.hw_scan                  = ath9k_hw_scan;
+	ath9k_ops.cancel_hw_scan           = ath9k_cancel_hw_scan;
+	ath9k_ops.remain_on_channel        = ath9k_remain_on_channel;
 	ath9k_ops.cancel_remain_on_channel = ath9k_cancel_remain_on_channel;
-	ath9k_ops.add_chanctx        = ath9k_add_chanctx;
-	ath9k_ops.remove_chanctx     = ath9k_remove_chanctx;
-	ath9k_ops.change_chanctx     = ath9k_change_chanctx;
-	ath9k_ops.assign_vif_chanctx = ath9k_assign_vif_chanctx;
-	ath9k_ops.unassign_vif_chanctx = ath9k_unassign_vif_chanctx;
-	ath9k_ops.mgd_prepare_tx = ath9k_chanctx_force_active;
+	ath9k_ops.add_chanctx              = ath9k_add_chanctx;
+	ath9k_ops.remove_chanctx           = ath9k_remove_chanctx;
+	ath9k_ops.change_chanctx           = ath9k_change_chanctx;
+	ath9k_ops.assign_vif_chanctx       = ath9k_assign_vif_chanctx;
+	ath9k_ops.unassign_vif_chanctx     = ath9k_unassign_vif_chanctx;
+	ath9k_ops.mgd_prepare_tx           = ath9k_chanctx_force_active;
 }
 
 struct ieee80211_ops ath9k_ops = {
-- 
2.0.4

