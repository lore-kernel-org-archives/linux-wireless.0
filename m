Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59255 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbaDEWhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2014 18:37:13 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v2 2/2] ath9k: implement p2p client powersave support
Date: Sun,  6 Apr 2014 00:37:03 +0200
Message-Id: <1396737423-70276-2-git-send-email-nbd@openwrt.org> (sfid-20140406_003737_022741_1B530650)
In-Reply-To: <1396737423-70276-1-git-send-email-nbd@openwrt.org>
References: <1396737423-70276-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use generic TSF timers to trigger powersave state changes based
information from the P2P NoA attribute.
Opportunistic Powersave is not handled, because the driver does not
support powersave at the moment.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  12 ++++
 drivers/net/wireless/ath/ath9k/init.c  |   6 ++
 drivers/net/wireless/ath/ath9k/main.c  | 106 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c  |   3 +
 4 files changed, 127 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 44d7449..05935f6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -114,6 +114,9 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_TXFIFO_DEPTH           8
 #define ATH_TX_ERROR               0x01
 
+/* Stop tx traffic 1ms before the GO goes away */
+#define ATH_P2P_PS_STOP_TIME       1000
+
 #define IEEE80211_SEQ_SEQ_SHIFT    4
 #define IEEE80211_SEQ_MAX          4096
 #define IEEE80211_WEP_IVLEN        3
@@ -367,11 +370,15 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 /********/
 
 struct ath_vif {
+	struct ieee80211_vif *vif;
 	struct ath_node mcast_node;
 	int av_bslot;
 	bool primary_sta_vif;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
 	struct ath_buf *av_bcbuf;
+
+	/* P2P Client */
+	struct ieee80211_noa_data noa;
 };
 
 struct ath9k_vif_iter_data {
@@ -464,6 +471,8 @@ int ath_update_survey_stats(struct ath_softc *sc);
 void ath_update_survey_nf(struct ath_softc *sc, int channel);
 void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 void ath_ps_full_sleep(unsigned long data);
+void ath9k_p2p_ps_timer(void *priv);
+void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif);
 
 /**********/
 /* BTCOEX */
@@ -714,6 +723,9 @@ struct ath_softc {
 	struct completion paprd_complete;
 	wait_queue_head_t tx_wait;
 
+	struct ath_gen_timer *p2p_ps_timer;
+	struct ath_vif *p2p_ps_vif;
+
 	unsigned long driver_data;
 
 	u8 gtt_cnt;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c3dc2c5..c646f8f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -589,6 +589,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (ret)
 		goto err_btcoex;
 
+	sc->p2p_ps_timer = ath_gen_timer_alloc(sc->sc_ah, ath9k_p2p_ps_timer,
+		NULL, sc, AR_FIRST_NDP_TIMER);
+
 	ath9k_cmn_init_crypto(sc->sc_ah);
 	ath9k_init_misc(sc);
 	ath_fill_led_pin(sc);
@@ -850,6 +853,9 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 {
 	int i = 0;
 
+	if (sc->p2p_ps_timer)
+		ath_gen_timer_free(sc->sc_ah, sc->p2p_ps_timer);
+
 	ath9k_deinit_btcoex(sc);
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d69853b..22c9e54 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -261,6 +261,8 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	sc->gtt_cnt = 0;
 	ieee80211_wake_queues(sc->hw);
 
+	ath9k_p2p_ps_timer(sc);
+
 	return true;
 }
 
@@ -1119,6 +1121,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
 
+	avp->vif = vif;
+
 	an->sc = sc;
 	an->sta = NULL;
 	an->vif = vif;
@@ -1163,6 +1167,29 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static void
+ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	s32 tsf, target_tsf;
+
+	if (!avp || !avp->noa.has_next_tsf)
+		return;
+
+	ath9k_hw_gen_timer_stop(ah, sc->p2p_ps_timer);
+
+	tsf = ath9k_hw_gettsf32(sc->sc_ah);
+
+	target_tsf = avp->noa.next_tsf;
+	if (!avp->noa.absent)
+		target_tsf -= ATH_P2P_PS_STOP_TIME;
+
+	if (target_tsf - tsf < ATH_P2P_PS_STOP_TIME)
+		target_tsf = tsf + ATH_P2P_PS_STOP_TIME;
+
+	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, (u32) target_tsf, 1000000);
+}
+
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -1174,6 +1201,13 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 
+	spin_lock_bh(&sc->sc_pcu_lock);
+	if (avp == sc->p2p_ps_vif) {
+		sc->p2p_ps_vif = NULL;
+		ath9k_update_p2p_ps_timer(sc, NULL);
+	}
+	spin_unlock_bh(&sc->sc_pcu_lock);
+
 	sc->nvifs--;
 	sc->tx99_vif = NULL;
 
@@ -1636,6 +1670,72 @@ static void ath9k_bss_assoc_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		ath9k_set_assoc_state(sc, vif);
 }
 
+void ath9k_p2p_ps_timer(void *priv)
+{
+	struct ath_softc *sc = priv;
+	struct ath_vif *avp = sc->p2p_ps_vif;
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *sta;
+	struct ath_node *an;
+	u32 tsf;
+
+	if (!avp)
+		return;
+
+	tsf = ath9k_hw_gettsf32(sc->sc_ah);
+	if (!avp->noa.absent)
+		tsf += ATH_P2P_PS_STOP_TIME;
+
+	if (!avp->noa.has_next_tsf ||
+	    avp->noa.next_tsf - tsf > BIT(31))
+		ieee80211_update_p2p_noa(&avp->noa, tsf);
+
+	ath9k_update_p2p_ps_timer(sc, avp);
+
+	rcu_read_lock();
+
+	vif = avp->vif;
+	sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
+	if (!sta)
+		goto out;
+
+	an = (void *) sta->drv_priv;
+	if (an->sleeping == !!avp->noa.absent)
+		goto out;
+
+	an->sleeping = avp->noa.absent;
+	if (an->sleeping)
+		ath_tx_aggr_sleep(sta, sc, an);
+	else
+		ath_tx_aggr_wakeup(sc, an);
+
+out:
+	rcu_read_unlock();
+}
+
+void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
+{
+	struct ath_vif *avp = (void *)vif->drv_priv;
+	unsigned long flags;
+	u32 tsf;
+
+	if (!sc->p2p_ps_timer)
+		return;
+
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->p2p)
+		return;
+
+	sc->p2p_ps_vif = avp;
+
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	if (!(sc->ps_flags & PS_BEACON_SYNC)) {
+		tsf = ath9k_hw_gettsf32(sc->sc_ah);
+		ieee80211_parse_p2p_noa(&vif->bss_conf.p2p_noa_attr, &avp->noa, tsf);
+		ath9k_update_p2p_ps_timer(sc, avp);
+	}
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+}
+
 static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_bss_conf *bss_conf,
@@ -1710,6 +1810,12 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (changed & BSS_CHANGED_P2P_PS) {
+		spin_lock_bh(&sc->sc_pcu_lock);
+		ath9k_update_p2p_ps(sc, vif);
+		spin_unlock_bh(&sc->sc_pcu_lock);
+	}
+
 	if (changed & CHECK_ANI)
 		ath_check_ani(sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6c9accd..a01efd3 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -539,6 +539,9 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		ath_dbg(common, PS,
 			"Reconfigure beacon timers based on synchronized timestamp\n");
 		ath9k_set_beacon(sc);
+
+		if (sc->p2p_ps_vif)
+			ath9k_update_p2p_ps(sc, sc->p2p_ps_vif->vif);
 	}
 
 	if (ath_beacon_dtim_pending_cab(skb)) {
-- 
1.8.5.2 (Apple Git-48)

