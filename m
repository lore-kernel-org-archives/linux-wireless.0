Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40750 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaFKKsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:48:42 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 07/28] ath9k: Implement hw_scan support
Date: Wed, 11 Jun 2014 16:17:55 +0530
Message-ID: <1402483696-2498-8-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124845_348366_DD09554B)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Implement hw_scan support for enabling multi-channel cuncurrency.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  24 ++++
 drivers/net/wireless/ath/ath9k/channel.c |  31 +++++
 drivers/net/wireless/ath/ath9k/init.c    |   9 +-
 drivers/net/wireless/ath/ath9k/main.c    | 187 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/pci.c     |   1 +
 drivers/net/wireless/ath/ath9k/recv.c    |   5 +
 6 files changed, 255 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d5a586b..d6b0c4e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -35,6 +35,7 @@ extern struct ieee80211_ops ath9k_ops;
 extern int ath9k_modparam_nohwcrypt;
 extern int led_blink;
 extern bool is_ath9k_unloaded;
+extern int ath9k_use_chanctx;
 
 /*************************/
 /* Descriptor Management */
@@ -332,12 +333,34 @@ struct ath_chanctx {
 	bool active;
 };
 
+enum ath_offchannel_state {
+	ATH_OFFCHANNEL_IDLE,
+	ATH_OFFCHANNEL_PROBE_SEND,
+	ATH_OFFCHANNEL_PROBE_WAIT,
+	ATH_OFFCHANNEL_SUSPEND,
+};
+
+struct ath_offchannel {
+	struct ath_chanctx chan;
+	struct timer_list timer;
+	struct cfg80211_scan_request *scan_req;
+	struct ieee80211_vif *scan_vif;
+	int scan_idx;
+	enum ath_offchannel_state state;
+};
+
+void ath9k_fill_chanctx_ops(void);
 void ath_chanctx_init(struct ath_softc *sc);
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef);
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 			struct cfg80211_chan_def *chandef);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
+void ath_offchannel_timer(unsigned long data);
+void ath_offchannel_channel_change(struct ath_softc *sc);
+void ath_chanctx_offchan_switch(struct ath_softc *sc,
+				struct ieee80211_channel *chan);
+struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc);
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
@@ -771,6 +794,7 @@ struct ath_softc {
 	struct ath_chanctx *cur_chan;
 	struct ath_chanctx *next_chan;
 	spinlock_t chan_lock;
+	struct ath_offchannel offchannel;
 
 #ifdef CONFIG_MAC80211_LEDS
 	bool led_registered;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 26fc98b..c679a26 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -228,6 +228,7 @@ void ath_chanctx_work(struct work_struct *work)
 	if (send_ps)
 		ath_chanctx_send_ps_frame(sc, false);
 
+	ath_offchannel_channel_change(sc);
 	mutex_unlock(&sc->mutex);
 }
 
@@ -253,6 +254,14 @@ void ath_chanctx_init(struct ath_softc *sc)
 			INIT_LIST_HEAD(&ctx->acq[j]);
 	}
 	sc->cur_chan = &sc->chanctx[0];
+	ctx = &sc->offchannel.chan;
+	cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
+	INIT_LIST_HEAD(&ctx->vifs);
+	ctx->txpower = ATH_TXPOWER_MAX;
+	for (j = 0; j < ARRAY_SIZE(ctx->acq); j++)
+		INIT_LIST_HEAD(&ctx->acq[j]);
+	sc->offchannel.chan.offchannel = true;
+
 }
 
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
@@ -283,3 +292,25 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 
 	ath_set_channel(sc);
 }
+
+struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc)
+{
+	u8 i;
+
+	for (i = 0; i < ARRAY_SIZE(sc->chanctx); i++) {
+		if (!list_empty(&sc->chanctx[i].vifs))
+			return &sc->chanctx[i];
+	}
+
+	return &sc->chanctx[0];
+}
+
+void ath_chanctx_offchan_switch(struct ath_softc *sc,
+				struct ieee80211_channel *chan)
+{
+	struct cfg80211_chan_def chandef;
+
+	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
+
+	ath_chanctx_switch(sc, &sc->offchannel.chan, &chandef);
+}
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 8bd3e42..9f5e1e4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -61,7 +61,7 @@ static int ath9k_ps_enable;
 module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
 MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
 
-static int ath9k_use_chanctx;
+int ath9k_use_chanctx;
 module_param_named(use_chanctx, ath9k_use_chanctx, int, 0444);
 MODULE_PARM_DESC(use_chanctx, "Enable channel context for concurrency");
 
@@ -566,6 +566,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
 	INIT_WORK(&sc->chanctx_work, ath_chanctx_work);
 	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
+	setup_timer(&sc->offchannel.timer, ath_offchannel_timer,
+		    (unsigned long)sc);
 
 	/*
 	 * Cache line size is used to size and align various
@@ -745,8 +747,11 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		if (!ath9k_use_chanctx) {
 			hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 			hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_WDS);
-		} else
+		} else {
 			hw->wiphy->n_iface_combinations = 1;
+			hw->wiphy->max_scan_ssids = 255;
+			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
+		}
 	}
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d8a4510..5da62ef 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2159,6 +2159,193 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	clear_bit(ATH_OP_SCANNING, &common->op_flags);
 }
 
+static void
+ath_scan_next_channel(struct ath_softc *sc)
+{
+	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
+	struct ieee80211_channel *chan;
+
+	if (sc->offchannel.scan_idx >= req->n_channels) {
+		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
+		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc), NULL);
+		return;
+	}
+
+	chan = req->channels[sc->offchannel.scan_idx++];
+	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_SEND;
+	ath_chanctx_offchan_switch(sc, chan);
+}
+
+static void ath_scan_complete(struct ath_softc *sc, bool abort)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc), NULL);
+	sc->offchannel.scan_req = NULL;
+	sc->offchannel.scan_vif = NULL;
+	sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
+	ieee80211_scan_completed(sc->hw, abort);
+	clear_bit(ATH_OP_SCANNING, &common->op_flags);
+	ath9k_ps_restore(sc);
+
+	if (!sc->ps_idle)
+		return;
+
+	ath_cancel_work(sc);
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
+	int i, dwell;
+
+	if ((sc->cur_chan->chandef.chan->flags & IEEE80211_CHAN_NO_IR) ||
+			!req->n_ssids) {
+		dwell = HZ / 9; /* ~110 ms */
+	} else {
+		dwell = HZ / 16; /* ~60 ms */
+
+		for (i = 0; i < req->n_ssids; i++)
+			ath_scan_send_probe(sc, &req->ssids[i]);
+	}
+
+	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_WAIT;
+	mod_timer(&sc->offchannel.timer, jiffies + dwell);
+}
+
+void ath_offchannel_channel_change(struct ath_softc *sc)
+{
+	if (!sc->offchannel.scan_req)
+		return;
+
+	switch (sc->offchannel.state) {
+	case ATH_OFFCHANNEL_PROBE_SEND:
+		if (sc->cur_chan->chandef.chan !=
+		    sc->offchannel.chan.chandef.chan)
+			return;
+
+		ath_scan_channel_start(sc);
+		break;
+	case ATH_OFFCHANNEL_IDLE:
+		ath_scan_complete(sc, false);
+		break;
+	default:
+		break;
+	}
+}
+
+void ath_offchannel_timer(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *)data;
+	struct ath_chanctx *ctx = ath_chanctx_get_oper_chan(sc);
+
+	if (!sc->offchannel.scan_req)
+		return;
+
+	switch (sc->offchannel.state) {
+	case ATH_OFFCHANNEL_PROBE_WAIT:
+		if (ctx->active) {
+			sc->offchannel.state = ATH_OFFCHANNEL_SUSPEND;
+			ath_chanctx_switch(sc, ctx, NULL);
+			mod_timer(&sc->offchannel.timer, jiffies + HZ / 10);
+			break;
+		}
+		/* fall through */
+	case ATH_OFFCHANNEL_SUSPEND:
+		ath_scan_next_channel(sc);
+		break;
+	default:
+		break;
+	}
+}
+
+static int ath9k_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct cfg80211_scan_request *req)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	int ret = 0;
+
+	mutex_lock(&sc->mutex);
+
+	if (WARN_ON(sc->offchannel.scan_req)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ath9k_ps_wakeup(sc);
+	set_bit(ATH_OP_SCANNING, &common->op_flags);
+	sc->offchannel.scan_vif = vif;
+	sc->offchannel.scan_req = req;
+	sc->offchannel.scan_idx = 0;
+	sc->offchannel.chan.txpower = vif->bss_conf.txpower;
+
+	ath_scan_next_channel(sc);
+
+out:
+	mutex_unlock(&sc->mutex);
+
+	return ret;
+}
+
+static void ath9k_cancel_hw_scan(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif)
+{
+	struct ath_softc *sc = hw->priv;
+
+	mutex_lock(&sc->mutex);
+	del_timer_sync(&sc->offchannel.timer);
+	ath_scan_complete(sc, true);
+	mutex_unlock(&sc->mutex);
+}
+
+void ath9k_fill_chanctx_ops(void)
+{
+	if (!ath9k_use_chanctx)
+		return;
+
+	ath9k_ops.hw_scan = ath9k_hw_scan;
+	ath9k_ops.cancel_hw_scan = ath9k_cancel_hw_scan;
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 4dec09e..7a2b2c5 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -843,6 +843,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
+	ath9k_fill_chanctx_ops();
 	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
 	if (!hw) {
 		dev_err(&pdev->dev, "No memory for ieee80211_hw\n");
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index de5684a..fec9e0b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -374,6 +374,7 @@ void ath_rx_cleanup(struct ath_softc *sc)
 
 u32 ath_calcrxfilter(struct ath_softc *sc)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	u32 rfilt;
 
 	if (config_enabled(CONFIG_ATH9K_TX99))
@@ -424,6 +425,10 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (AR_SREV_9550(sc->sc_ah) || AR_SREV_9531(sc->sc_ah))
 		rfilt |= ATH9K_RX_FILTER_4ADDRESS;
 
+	if (ath9k_use_chanctx &&
+	    test_bit(ATH_OP_SCANNING, &common->op_flags))
+		rfilt |= ATH9K_RX_FILTER_BEACON;
+
 	return rfilt;
 
 }
-- 
2.0.0

