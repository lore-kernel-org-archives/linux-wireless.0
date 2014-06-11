Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57884 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaFKKss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:48:48 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 08/28] ath9k: Implement remain-on-channal support
Date: Wed, 11 Jun 2014 16:17:56 +0530
Message-ID: <1402483696-2498-9-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124851_195888_F1D97A6A)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Add remain on channel support in order to enable multi-channel
concurrency.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   6 ++
 drivers/net/wireless/ath/ath9k/init.c  |   1 +
 drivers/net/wireless/ath/ath9k/main.c  | 126 +++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/xmit.c  |   6 +-
 4 files changed, 124 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d6b0c4e..a8ae3e9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -338,6 +338,9 @@ enum ath_offchannel_state {
 	ATH_OFFCHANNEL_PROBE_SEND,
 	ATH_OFFCHANNEL_PROBE_WAIT,
 	ATH_OFFCHANNEL_SUSPEND,
+	ATH_OFFCHANNEL_ROC_START,
+	ATH_OFFCHANNEL_ROC_WAIT,
+	ATH_OFFCHANNEL_ROC_DONE,
 };
 
 struct ath_offchannel {
@@ -347,6 +350,9 @@ struct ath_offchannel {
 	struct ieee80211_vif *scan_vif;
 	int scan_idx;
 	enum ath_offchannel_state state;
+	struct ieee80211_channel *roc_chan;
+	struct ieee80211_vif *roc_vif;
+	int roc_duration;
 };
 
 void ath9k_fill_chanctx_ops(void);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9f5e1e4..001b7d0 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -751,6 +751,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			hw->wiphy->n_iface_combinations = 1;
 			hw->wiphy->max_scan_ssids = 255;
 			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
+			hw->wiphy->max_remain_on_channel_duration = 10000;
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5da62ef..9e10434d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2176,22 +2176,48 @@ ath_scan_next_channel(struct ath_softc *sc)
 	ath_chanctx_offchan_switch(sc, chan);
 }
 
+static void ath_offchannel_next(struct ath_softc *sc)
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
+		sc->offchannel.state = ATH_OFFCHANNEL_ROC_START;
+		ath_chanctx_offchan_switch(sc, sc->offchannel.roc_chan);
+	} else {
+		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc), NULL);
+		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
+		if (sc->ps_idle)
+			ath_cancel_work(sc);
+	}
+}
+
+static void ath_roc_complete(struct ath_softc *sc, bool abort)
+{
+	sc->offchannel.roc_vif = NULL;
+	sc->offchannel.roc_chan = NULL;
+	if (!abort)
+		ieee80211_remain_on_channel_expired(sc->hw);
+	ath_offchannel_next(sc);
+	ath9k_ps_restore(sc);
+}
+
 static void ath_scan_complete(struct ath_softc *sc, bool abort)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc), NULL);
 	sc->offchannel.scan_req = NULL;
 	sc->offchannel.scan_vif = NULL;
 	sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
 	ieee80211_scan_completed(sc->hw, abort);
 	clear_bit(ATH_OP_SCANNING, &common->op_flags);
+	ath_offchannel_next(sc);
 	ath9k_ps_restore(sc);
-
-	if (!sc->ps_idle)
-		return;
-
-	ath_cancel_work(sc);
 }
 
 static void ath_scan_send_probe(struct ath_softc *sc,
@@ -2253,11 +2279,11 @@ static void ath_scan_channel_start(struct ath_softc *sc)
 
 void ath_offchannel_channel_change(struct ath_softc *sc)
 {
-	if (!sc->offchannel.scan_req)
-		return;
-
 	switch (sc->offchannel.state) {
 	case ATH_OFFCHANNEL_PROBE_SEND:
+		if (!sc->offchannel.scan_req)
+			return;
+
 		if (sc->cur_chan->chandef.chan !=
 		    sc->offchannel.chan.chandef.chan)
 			return;
@@ -2265,8 +2291,23 @@ void ath_offchannel_channel_change(struct ath_softc *sc)
 		ath_scan_channel_start(sc);
 		break;
 	case ATH_OFFCHANNEL_IDLE:
+		if (!sc->offchannel.scan_req)
+			return;
+
 		ath_scan_complete(sc, false);
 		break;
+	case ATH_OFFCHANNEL_ROC_START:
+		if (sc->cur_chan != &sc->offchannel.chan)
+			break;
+
+		sc->offchannel.state = ATH_OFFCHANNEL_ROC_WAIT;
+		mod_timer(&sc->offchannel.timer, jiffies +
+			  msecs_to_jiffies(sc->offchannel.roc_duration));
+		ieee80211_ready_on_channel(sc->hw);
+		break;
+	case ATH_OFFCHANNEL_ROC_DONE:
+		ath_roc_complete(sc, false);
+		break;
 	default:
 		break;
 	}
@@ -2277,11 +2318,11 @@ void ath_offchannel_timer(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_chanctx *ctx = ath_chanctx_get_oper_chan(sc);
 
-	if (!sc->offchannel.scan_req)
-		return;
-
 	switch (sc->offchannel.state) {
 	case ATH_OFFCHANNEL_PROBE_WAIT:
+		if (!sc->offchannel.scan_req)
+			return;
+
 		if (ctx->active) {
 			sc->offchannel.state = ATH_OFFCHANNEL_SUSPEND;
 			ath_chanctx_switch(sc, ctx, NULL);
@@ -2290,8 +2331,16 @@ void ath_offchannel_timer(unsigned long data)
 		}
 		/* fall through */
 	case ATH_OFFCHANNEL_SUSPEND:
+		if (!sc->offchannel.scan_req)
+			return;
+
 		ath_scan_next_channel(sc);
 		break;
+	case ATH_OFFCHANNEL_ROC_START:
+	case ATH_OFFCHANNEL_ROC_WAIT:
+		sc->offchannel.state = ATH_OFFCHANNEL_ROC_DONE;
+		ath_chanctx_switch(sc, ctx, NULL);
+		break;
 	default:
 		break;
 	}
@@ -2316,9 +2365,9 @@ static int ath9k_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	sc->offchannel.scan_vif = vif;
 	sc->offchannel.scan_req = req;
 	sc->offchannel.scan_idx = 0;
-	sc->offchannel.chan.txpower = vif->bss_conf.txpower;
 
-	ath_scan_next_channel(sc);
+	if (sc->offchannel.state == ATH_OFFCHANNEL_IDLE)
+		ath_offchannel_next(sc);
 
 out:
 	mutex_unlock(&sc->mutex);
@@ -2337,6 +2386,53 @@ static void ath9k_cancel_hw_scan(struct ieee80211_hw *hw,
 	mutex_unlock(&sc->mutex);
 }
 
+static int ath9k_remain_on_channel(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_channel *chan, int duration,
+				   enum ieee80211_roc_type type)
+{
+	struct ath_softc *sc = hw->priv;
+	int ret = 0;
+
+	mutex_lock(&sc->mutex);
+
+	if (WARN_ON(sc->offchannel.roc_vif)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ath9k_ps_wakeup(sc);
+	sc->offchannel.roc_vif = vif;
+	sc->offchannel.roc_chan = chan;
+	sc->offchannel.roc_duration = duration;
+
+	if (sc->offchannel.state == ATH_OFFCHANNEL_IDLE)
+		ath_offchannel_next(sc);
+
+out:
+	mutex_unlock(&sc->mutex);
+
+	return ret;
+}
+
+static int ath9k_cancel_remain_on_channel(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+
+	mutex_lock(&sc->mutex);
+
+	del_timer_sync(&sc->offchannel.timer);
+
+	if (sc->offchannel.roc_vif) {
+		if (sc->offchannel.state >= ATH_OFFCHANNEL_ROC_START)
+			ath_roc_complete(sc, true);
+	}
+
+	mutex_unlock(&sc->mutex);
+
+	return 0;
+}
+
 void ath9k_fill_chanctx_ops(void)
 {
 	if (!ath9k_use_chanctx)
@@ -2344,6 +2440,8 @@ void ath9k_fill_chanctx_ops(void)
 
 	ath9k_ops.hw_scan = ath9k_hw_scan;
 	ath9k_ops.cancel_hw_scan = ath9k_cancel_hw_scan;
+	ath9k_ops.remain_on_channel  = ath9k_remain_on_channel;
+	ath9k_ops.cancel_remain_on_channel = ath9k_cancel_remain_on_channel;
 }
 
 struct ieee80211_ops ath9k_ops = {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7972e1e..22460a1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2197,6 +2197,9 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (vif)
 		avp = (void *)vif->drv_priv;
 
+	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+		txctl->force_channel = true;
+
 	ret = ath_tx_prepare(hw, skb, txctl);
 	if (ret)
 	    return ret;
@@ -2234,7 +2237,8 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (txctl->an && queue)
 		tid = ath_get_skb_tid(sc, txctl->an, skb);
 
-	if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
+	if (info->flags & (IEEE80211_TX_CTL_PS_RESPONSE |
+			   IEEE80211_TX_CTL_TX_OFFCHAN)) {
 		ath_txq_unlock(sc, txq);
 		txq = sc->tx.uapsdq;
 		ath_txq_lock(sc, txq);
-- 
2.0.0

