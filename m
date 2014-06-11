Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24858 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaFKKsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:48:35 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 06/28] ath9k: send powersave frame on channel switch
Date: Wed, 11 Jun 2014 16:17:54 +0530
Message-ID: <1402483696-2498-7-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124837_953502_43CB3244)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

While leaving from or entering to active channel context, send out
nullfunc frame to inform to the AP about the presence of station.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 +
 drivers/net/wireless/ath/ath9k/channel.c | 97 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c    |  6 ++
 3 files changed, 106 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ddd2e81..d5a586b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -329,6 +329,7 @@ struct ath_chanctx {
 	u16 txpower;
 	bool offchannel;
 	bool stopped;
+	bool active;
 };
 
 void ath_chanctx_init(struct ath_softc *sc);
@@ -336,6 +337,8 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef);
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 			struct cfg80211_chan_def *chandef);
+void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
+
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 86404d3..26fc98b 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -101,10 +101,99 @@ static int ath_set_channel(struct ath_softc *sc)
 	return 0;
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
+void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
+{
+	struct ath_vif *avp;
+	bool active = false;
+
+	if (!ctx)
+		return;
+
+	list_for_each_entry(avp, &ctx->vifs, list) {
+		struct ieee80211_vif *vif = avp->vif;
+
+		switch (vif->type) {
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_STATION:
+			if (vif->bss_conf.assoc)
+				active = true;
+			break;
+		default:
+			active = true;
+			break;
+		}
+	}
+	ctx->active = active;
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
 void ath_chanctx_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc,
 					    chanctx_work);
+	bool send_ps = false;
 
 	mutex_lock(&sc->mutex);
 	spin_lock_bh(&sc->chan_lock);
@@ -120,6 +209,10 @@ void ath_chanctx_work(struct work_struct *work)
 
 		__ath9k_flush(sc->hw, ~0, true);
 
+		if (ath_chanctx_send_ps_frame(sc, true))
+			__ath9k_flush(sc->hw, BIT(IEEE80211_AC_VO), false);
+
+		send_ps = true;
 		spin_lock_bh(&sc->chan_lock);
 	}
 	sc->cur_chan = sc->next_chan;
@@ -131,6 +224,10 @@ void ath_chanctx_work(struct work_struct *work)
 	    memcmp(&sc->cur_chandef, &sc->cur_chan->chandef,
 		   sizeof(sc->cur_chandef)))
 		ath_set_channel(sc);
+
+	if (send_ps)
+		ath_chanctx_send_ps_frame(sc, false);
+
 	mutex_unlock(&sc->mutex);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index bb73a23..d8a4510 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1043,6 +1043,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	/* XXX - will be removed once chanctx ops are added */
 	avp->chanctx = sc->cur_chan;
 	list_add_tail(&avp->list, &sc->cur_chan->vifs);
+	ath_chanctx_check_active(sc, avp->chanctx);
 
 	an->sc = sc;
 	an->sta = NULL;
@@ -1061,6 +1062,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_vif *avp = (void *)vif->drv_priv;
 
 	mutex_lock(&sc->mutex);
 
@@ -1083,6 +1085,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
+	ath_chanctx_check_active(sc, avp->chanctx);
 
 	mutex_unlock(&sc->mutex);
 	return 0;
@@ -1141,6 +1144,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath9k_ps_restore(sc);
 
 	ath_tx_node_cleanup(sc, &avp->mcast_node);
+	ath_chanctx_check_active(sc, avp->chanctx);
 
 	mutex_unlock(&sc->mutex);
 }
@@ -1733,6 +1737,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			if (ath9k_hw_mci_is_enabled(sc->sc_ah))
 				ath9k_mci_update_wlan_channels(sc, true);
 		}
+
+		ath_chanctx_check_active(sc, avp->chanctx);
 	}
 
 	if (changed & BSS_CHANGED_IBSS) {
-- 
2.0.0

