Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58590 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaHVPJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 11:09:57 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 6/8] ath9k: Move P2P functions to channel.c
Date: Fri, 22 Aug 2014 20:39:29 +0530
Message-Id: <1408720171-9765-7-git-send-email-sujith@msujith.org> (sfid-20140822_171001_261598_90C8DFC5)
In-Reply-To: <1408720171-9765-1-git-send-email-sujith@msujith.org>
References: <1408720171-9765-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  1 +
 drivers/net/wireless/ath/ath9k/channel.c | 86 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c    | 87 --------------------------------
 3 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 17b198e..aea3979 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -601,6 +601,7 @@ void ath_update_survey_nf(struct ath_softc *sc, int channel);
 void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 void ath_ps_full_sleep(unsigned long data);
 void ath9k_p2p_ps_timer(void *priv);
+void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp);
 void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif);
 void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
 
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 2f10b0c..77bf005 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -944,3 +944,89 @@ void ath_offchannel_timer(unsigned long data)
 		break;
 	}
 }
+
+void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
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
+void ath9k_p2p_ps_timer(void *priv)
+{
+	struct ath_softc *sc = priv;
+	struct ath_vif *avp = sc->p2p_ps_vif;
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *sta;
+	struct ath_node *an;
+	u32 tsf;
+
+	del_timer_sync(&sc->sched.timer);
+	ath9k_hw_gen_timer_stop(sc->sc_ah, sc->p2p_ps_timer);
+	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_TSF_TIMER);
+
+	if (!avp || avp->chanctx != sc->cur_chan)
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
+	u32 tsf;
+
+	if (!sc->p2p_ps_timer)
+		return;
+
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->p2p)
+		return;
+
+	sc->p2p_ps_vif = avp;
+	tsf = ath9k_hw_gettsf32(sc->sc_ah);
+	ieee80211_parse_p2p_noa(&vif->bss_conf.p2p_noa_attr, &avp->noa, tsf);
+	ath9k_update_p2p_ps_timer(sc, avp);
+}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 194895b..dd2d52e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1202,29 +1202,6 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void
-ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	s32 tsf, target_tsf;
-
-	if (!avp || !avp->noa.has_next_tsf)
-		return;
-
-	ath9k_hw_gen_timer_stop(ah, sc->p2p_ps_timer);
-
-	tsf = ath9k_hw_gettsf32(sc->sc_ah);
-
-	target_tsf = avp->noa.next_tsf;
-	if (!avp->noa.absent)
-		target_tsf -= ATH_P2P_PS_STOP_TIME;
-
-	if (target_tsf - tsf < ATH_P2P_PS_STOP_TIME)
-		target_tsf = tsf + ATH_P2P_PS_STOP_TIME;
-
-	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, (u32) target_tsf, 1000000);
-}
-
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -1687,70 +1664,6 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	return ret;
 }
 
-void ath9k_p2p_ps_timer(void *priv)
-{
-	struct ath_softc *sc = priv;
-	struct ath_vif *avp = sc->p2p_ps_vif;
-	struct ieee80211_vif *vif;
-	struct ieee80211_sta *sta;
-	struct ath_node *an;
-	u32 tsf;
-
-	del_timer_sync(&sc->sched.timer);
-	ath9k_hw_gen_timer_stop(sc->sc_ah, sc->p2p_ps_timer);
-	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_TSF_TIMER);
-
-	if (!avp || avp->chanctx != sc->cur_chan)
-		return;
-
-	tsf = ath9k_hw_gettsf32(sc->sc_ah);
-	if (!avp->noa.absent)
-		tsf += ATH_P2P_PS_STOP_TIME;
-
-	if (!avp->noa.has_next_tsf ||
-	    avp->noa.next_tsf - tsf > BIT(31))
-		ieee80211_update_p2p_noa(&avp->noa, tsf);
-
-	ath9k_update_p2p_ps_timer(sc, avp);
-
-	rcu_read_lock();
-
-	vif = avp->vif;
-	sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
-	if (!sta)
-		goto out;
-
-	an = (void *) sta->drv_priv;
-	if (an->sleeping == !!avp->noa.absent)
-		goto out;
-
-	an->sleeping = avp->noa.absent;
-	if (an->sleeping)
-		ath_tx_aggr_sleep(sta, sc, an);
-	else
-		ath_tx_aggr_wakeup(sc, an);
-
-out:
-	rcu_read_unlock();
-}
-
-void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
-{
-	struct ath_vif *avp = (void *)vif->drv_priv;
-	u32 tsf;
-
-	if (!sc->p2p_ps_timer)
-		return;
-
-	if (vif->type != NL80211_IFTYPE_STATION || !vif->p2p)
-		return;
-
-	sc->p2p_ps_vif = avp;
-	tsf = ath9k_hw_gettsf32(sc->sc_ah);
-	ieee80211_parse_p2p_noa(&vif->bss_conf.p2p_noa_attr, &avp->noa, tsf);
-	ath9k_update_p2p_ps_timer(sc, avp);
-}
-
 static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_bss_conf *bss_conf,
-- 
2.0.4

