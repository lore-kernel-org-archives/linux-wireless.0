Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37163 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaHVPJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 11:09:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 7/8] ath9k: Isolate P2P powersave routines
Date: Fri, 22 Aug 2014 20:39:30 +0530
Message-Id: <1408720171-9765-8-git-send-email-sujith@msujith.org> (sfid-20140822_171004_498558_88737EF2)
In-Reply-To: <1408720171-9765-1-git-send-email-sujith@msujith.org>
References: <1408720171-9765-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use CONFIG_ATH9K_CHANNEL_CONTEXT to conditionally
compile P2P-PS code.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 38 ++++++++++++++--
 drivers/net/wireless/ath/ath9k/channel.c | 78 ++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/init.c    |  9 ++--
 drivers/net/wireless/ath/ath9k/main.c    | 18 ++------
 drivers/net/wireless/ath/ath9k/recv.c    |  4 +-
 5 files changed, 111 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index aea3979..642cc19 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -436,6 +436,39 @@ void ath_offchannel_next(struct ath_softc *sc);
 void ath_scan_complete(struct ath_softc *sc, bool abort);
 void ath_roc_complete(struct ath_softc *sc, bool abort);
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+int ath9k_init_p2p(struct ath_softc *sc);
+void ath9k_deinit_p2p(struct ath_softc *sc);
+void ath9k_p2p_remove_vif(struct ath_softc *sc,
+			  struct ieee80211_vif *vif);
+void ath9k_p2p_beacon_sync(struct ath_softc *sc);
+void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
+				struct ieee80211_vif *vif);
+void ath9k_p2p_ps_timer(void *priv);
+#else
+static inline int ath9k_init_p2p(struct ath_softc *sc)
+{
+	return 0;
+}
+static inline void ath9k_deinit_p2p(struct ath_softc *sc)
+{
+}
+static inline void ath9k_p2p_remove_vif(struct ath_softc *sc,
+					struct ieee80211_vif *vif)
+{
+}
+static inline void ath9k_p2p_beacon_sync(struct ath_softc *sc)
+{
+}
+static inline void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
+					      struct ieee80211_vif *vif)
+{
+}
+static inline void ath9k_p2p_ps_timer(struct ath_softc *sc)
+{
+}
+#endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
+
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
@@ -600,9 +633,6 @@ int ath_update_survey_stats(struct ath_softc *sc);
 void ath_update_survey_nf(struct ath_softc *sc, int channel);
 void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 void ath_ps_full_sleep(unsigned long data);
-void ath9k_p2p_ps_timer(void *priv);
-void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp);
-void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif);
 void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
 
 /**********/
@@ -857,8 +887,10 @@ struct ath_softc {
 	struct completion paprd_complete;
 	wait_queue_head_t tx_wait;
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 	struct ath_gen_timer *p2p_ps_timer;
 	struct ath_vif *p2p_ps_vif;
+#endif
 
 	unsigned long driver_data;
 
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 77bf005..c54a3df 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -514,7 +514,9 @@ static void ath_chanctx_setup_timer(struct ath_softc *sc, u32 tsf_time)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, tsf_time, 1000000);
+#endif
 	tsf_time -= ath9k_hw_gettsf32(ah);
 	tsf_time = msecs_to_jiffies(tsf_time / 1000) + 1;
 	mod_timer(&sc->sched.timer, tsf_time);
@@ -945,7 +947,13 @@ void ath_offchannel_timer(unsigned long data)
 	}
 }
 
-void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+
+/*****************/
+/* P2P Powersave */
+/*****************/
+
+static void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	s32 tsf, target_tsf;
@@ -967,6 +975,23 @@ void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
 	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, (u32) target_tsf, 1000000);
 }
 
+static void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
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
+
 void ath9k_p2p_ps_timer(void *priv)
 {
 	struct ath_softc *sc = priv;
@@ -1014,19 +1039,52 @@ out:
 	rcu_read_unlock();
 }
 
-void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
+void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
+				struct ieee80211_vif *vif)
+{
+	unsigned long flags;
+
+	spin_lock_bh(&sc->sc_pcu_lock);
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	if (!(sc->ps_flags & PS_BEACON_SYNC))
+		ath9k_update_p2p_ps(sc, vif);
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+	spin_unlock_bh(&sc->sc_pcu_lock);
+}
+
+void ath9k_p2p_beacon_sync(struct ath_softc *sc)
+{
+	if (sc->p2p_ps_vif)
+		ath9k_update_p2p_ps(sc, sc->p2p_ps_vif->vif);
+}
+
+void ath9k_p2p_remove_vif(struct ath_softc *sc,
+			  struct ieee80211_vif *vif)
 {
 	struct ath_vif *avp = (void *)vif->drv_priv;
-	u32 tsf;
 
+	spin_lock_bh(&sc->sc_pcu_lock);
+	if (avp == sc->p2p_ps_vif) {
+		sc->p2p_ps_vif = NULL;
+		ath9k_update_p2p_ps_timer(sc, NULL);
+	}
+	spin_unlock_bh(&sc->sc_pcu_lock);
+}
+
+int ath9k_init_p2p(struct ath_softc *sc)
+{
+	sc->p2p_ps_timer = ath_gen_timer_alloc(sc->sc_ah, ath9k_p2p_ps_timer,
+					       NULL, sc, AR_FIRST_NDP_TIMER);
 	if (!sc->p2p_ps_timer)
-		return;
+		return -ENOMEM;
 
-	if (vif->type != NL80211_IFTYPE_STATION || !vif->p2p)
-		return;
+	return 0;
+}
 
-	sc->p2p_ps_vif = avp;
-	tsf = ath9k_hw_gettsf32(sc->sc_ah);
-	ieee80211_parse_p2p_noa(&vif->bss_conf.p2p_noa_attr, &avp->noa, tsf);
-	ath9k_update_p2p_ps_timer(sc, avp);
+void ath9k_deinit_p2p(struct ath_softc *sc)
+{
+	if (sc->p2p_ps_timer)
+		ath_gen_timer_free(sc->sc_ah, sc->p2p_ps_timer);
 }
+
+#endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4219e7b..5c48be9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -600,9 +600,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (ret)
 		goto err_btcoex;
 
-	sc->p2p_ps_timer = ath_gen_timer_alloc(sc->sc_ah, ath9k_p2p_ps_timer,
-					       NULL, sc, AR_FIRST_NDP_TIMER);
-	if (!sc->p2p_ps_timer)
+	ret = ath9k_init_p2p(sc);
+	if (ret)
 		goto err_btcoex;
 
 	ath9k_cmn_init_crypto(sc->sc_ah);
@@ -919,9 +918,7 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 {
 	int i = 0;
 
-	if (sc->p2p_ps_timer)
-		ath_gen_timer_free(sc->sc_ah, sc->p2p_ps_timer);
-
+	ath9k_deinit_p2p(sc);
 	ath9k_deinit_btcoex(sc);
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dd2d52e..32e80fc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1213,12 +1213,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 
-	spin_lock_bh(&sc->sc_pcu_lock);
-	if (avp == sc->p2p_ps_vif) {
-		sc->p2p_ps_vif = NULL;
-		ath9k_update_p2p_ps_timer(sc, NULL);
-	}
-	spin_unlock_bh(&sc->sc_pcu_lock);
+	ath9k_p2p_remove_vif(sc, vif);
 
 	sc->nvifs--;
 	sc->tx99_vif = NULL;
@@ -1678,7 +1673,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
-	unsigned long flags;
 	int slottime;
 
 	ath9k_ps_wakeup(sc);
@@ -1727,14 +1721,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (changed & BSS_CHANGED_P2P_PS) {
-		spin_lock_bh(&sc->sc_pcu_lock);
-		spin_lock_irqsave(&sc->sc_pm_lock, flags);
-		if (!(sc->ps_flags & PS_BEACON_SYNC))
-			ath9k_update_p2p_ps(sc, vif);
-		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
-		spin_unlock_bh(&sc->sc_pcu_lock);
-	}
+	if (changed & BSS_CHANGED_P2P_PS)
+		ath9k_p2p_bss_info_changed(sc, vif);
 
 	if (changed & CHECK_ANI)
 		ath_check_ani(sc);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 74ab1d0..e6669fd 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -547,8 +547,8 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 			"Reconfigure beacon timers based on synchronized timestamp\n");
 		if (!(WARN_ON_ONCE(sc->cur_chan->beacon.beacon_interval == 0)))
 			ath9k_set_beacon(sc);
-		if (sc->p2p_ps_vif)
-			ath9k_update_p2p_ps(sc, sc->p2p_ps_vif->vif);
+
+		ath9k_p2p_beacon_sync(sc);
 	}
 
 	if (ath_beacon_dtim_pending_cab(skb)) {
-- 
2.0.4

