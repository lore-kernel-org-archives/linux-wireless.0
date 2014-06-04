Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18000 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaFDNr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:47:29 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 08/13] ath9k: Implement remain-on-channal support
Date: Wed, 4 Jun 2014 19:16:34 +0530
Message-ID: <1401889599-412-9-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154808_872079_CB31EF90)
In-Reply-To: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
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
 drivers/net/wireless/ath/ath9k/ath9k.h |  11 ++++
 drivers/net/wireless/ath/ath9k/init.c  |   1 +
 drivers/net/wireless/ath/ath9k/main.c  | 110 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/pci.c   |   3 +
 4 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5b55f42..7b4a147 100644
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
@@ -347,12 +350,20 @@ struct ath_offchannel {
 	struct ieee80211_vif *scan_vif;
 	int scan_idx;
 	enum ath_offchannel_state state;
+	struct ieee80211_channel *roc_chan;
+	struct ieee80211_vif *roc_vif;
+	int roc_duration;
 };
 
 void ath9k_cancel_hw_scan(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
 int ath9k_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  struct cfg80211_scan_request *req);
+int ath9k_remain_on_channel(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    struct ieee80211_channel *chan, int duration,
+			    enum ieee80211_roc_type type);
+int ath9k_cancel_remain_on_channel(struct ieee80211_hw *hw);
 
 void ath_chanctx_init(struct ath_softc *sc);
 int ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
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
index 12a0ebd..c79ab6d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2184,6 +2184,37 @@ ath_scan_next_channel(struct ath_softc *sc)
 	ath_chanctx_offchan_switch(sc, chan);
 }
 
+static void ath_offchannel_next(struct ath_softc *sc)
+{
+	struct ieee80211_vif *vif;
+
+	if (sc->offchannel.scan_req) {
+		vif = sc->offchannel.scan_vif;
+		sc->offchannel.ctx->txpower = vif->bss_conf.txpower;
+		ath_scan_next_channel(sc);
+	} else if (sc->offchannel.roc_vif) {
+		vif = sc->offchannel.roc_vif;
+		sc->offchannel.ctx->txpower = vif->bss_conf.txpower;
+		sc->offchannel.state = ATH_OFFCHANNEL_ROC_START;
+		ath_chanctx_offchan_switch(sc, sc->offchannel.roc_chan);
+	} else {
+		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc));
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
@@ -2266,6 +2297,9 @@ void ath_offchannel_channel_change(struct ath_softc *sc)
 
 	switch (sc->offchannel.state) {
 	case ATH_OFFCHANNEL_PROBE_SEND:
+		if (!sc->offchannel.scan_req)
+			return;
+
 		if (sc->cur_chan->chandef.chan !=
 		    sc->offchannel.ctx->chandef.chan)
 			return;
@@ -2273,8 +2307,23 @@ void ath_offchannel_channel_change(struct ath_softc *sc)
 		ath_scan_channel_start(sc);
 		break;
 	case ATH_OFFCHANNEL_IDLE:
+		if (!sc->offchannel.scan_req)
+			return;
+
 		ath_scan_complete(sc, false);
 		break;
+	case ATH_OFFCHANNEL_ROC_START:
+		if (sc->cur_chan != sc->offchannel.ctx)
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
@@ -2291,6 +2340,9 @@ void ath_offchannel_timer(unsigned long data)
 
 	switch (sc->offchannel.state) {
 	case ATH_OFFCHANNEL_PROBE_WAIT:
+		if (!sc->offchannel.scan_req)
+			return;
+
 		if (ctx->active) {
 			sc->offchannel.state = ATH_OFFCHANNEL_SUSPEND;
 			ath_chanctx_switch(sc, idx);
@@ -2299,8 +2351,16 @@ void ath_offchannel_timer(unsigned long data)
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
+		ath_chanctx_switch(sc, idx);
+		break;
 	default:
 		break;
 	}
@@ -2327,7 +2387,8 @@ int ath9k_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	sc->offchannel.scan_idx = 0;
 	sc->offchannel.ctx->txpower = vif->bss_conf.txpower;
 
-	ath_scan_next_channel(sc);
+	if (sc->offchannel.state == ATH_OFFCHANNEL_IDLE)
+		ath_offchannel_next(sc);
 
 out:
 	mutex_unlock(&sc->mutex);
@@ -2346,6 +2407,53 @@ void ath9k_cancel_hw_scan(struct ieee80211_hw *hw,
 	mutex_unlock(&sc->mutex);
 }
 
+int ath9k_cancel_remain_on_channel(struct ieee80211_hw *hw)
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
+int ath9k_remain_on_channel(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    struct ieee80211_channel *chan, int duration,
+			    enum ieee80211_roc_type type)
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
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 448af5d..48b4a72 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -845,6 +845,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ath9k_use_chanctx) {
 		ath9k_ops.hw_scan = ath9k_hw_scan;
 		ath9k_ops.cancel_hw_scan = ath9k_cancel_hw_scan;
+		ath9k_ops.remain_on_channel = ath9k_remain_on_channel;
+		ath9k_ops.cancel_remain_on_channel =
+			ath9k_cancel_remain_on_channel;
 	}
 
 	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
-- 
2.0.0

