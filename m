Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44747 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaHWH7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:23 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 04/18] ath9k: Cleanup mgd_prepare_tx callback
Date: Sat, 23 Aug 2014 13:29:09 +0530
Message-Id: <1408780763-27974-5-git-send-email-sujith@msujith.org> (sfid-20140823_095937_431056_35CEF203)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Rename the callback from ath9k_chanctx_force_active()
to ath9k_mgd_prepare_tx(). Also, move it to main.c and
group it with the other callbacks.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  4 ++--
 drivers/net/wireless/ath/ath9k/channel.c | 32 +-------------------------------
 drivers/net/wireless/ath/ath9k/main.c    | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f3455ce..f9863e6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -408,8 +408,6 @@ struct ath_offchannel {
 	     ctx <= &sc->chanctx[ARRAY_SIZE(sc->chanctx) - 1];      \
 	     ctx++)
 
-void ath9k_chanctx_force_active(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif);
 static inline struct ath_chanctx *
 ath_chanctx_get(struct ieee80211_chanctx_conf *ctx)
 {
@@ -446,6 +444,8 @@ void ath9k_p2p_beacon_sync(struct ath_softc *sc);
 void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 				struct ieee80211_vif *vif);
 void ath9k_p2p_ps_timer(void *priv);
+
+void ath_chanctx_set_next(struct ath_softc *sc, bool force);
 #else
 static inline bool ath9k_is_chanctx_enabled(void)
 {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 0b84917..4525fc0 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -243,7 +243,7 @@ static bool ath_chanctx_defer_switch(struct ath_softc *sc)
 	return true;
 }
 
-static void ath_chanctx_set_next(struct ath_softc *sc, bool force)
+void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 {
 	struct timespec ts;
 	bool measure_time = false;
@@ -336,36 +336,6 @@ void ath_chanctx_init(struct ath_softc *sc)
 
 }
 
-void ath9k_chanctx_force_active(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif)
-{
-	struct ath_softc *sc = hw->priv;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_vif *avp = (struct ath_vif *) vif->drv_priv;
-	bool changed = false;
-
-	if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
-		return;
-
-	if (!avp->chanctx)
-		return;
-
-	mutex_lock(&sc->mutex);
-
-	spin_lock_bh(&sc->chan_lock);
-	if (sc->next_chan || (sc->cur_chan != avp->chanctx)) {
-		sc->next_chan = avp->chanctx;
-		changed = true;
-	}
-	sc->sched.state = ATH_CHANCTX_STATE_FORCE_ACTIVE;
-	spin_unlock_bh(&sc->chan_lock);
-
-	if (changed)
-		ath_chanctx_set_next(sc, true);
-
-	mutex_unlock(&sc->mutex);
-}
-
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 			struct cfg80211_chan_def *chandef)
 {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e5c523a..4659168 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2340,6 +2340,36 @@ static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_unlock(&sc->mutex);
 }
 
+static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_vif *avp = (struct ath_vif *) vif->drv_priv;
+	bool changed = false;
+
+	if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
+		return;
+
+	if (!avp->chanctx)
+		return;
+
+	mutex_lock(&sc->mutex);
+
+	spin_lock_bh(&sc->chan_lock);
+	if (sc->next_chan || (sc->cur_chan != avp->chanctx)) {
+		sc->next_chan = avp->chanctx;
+		changed = true;
+	}
+	sc->sched.state = ATH_CHANCTX_STATE_FORCE_ACTIVE;
+	spin_unlock_bh(&sc->chan_lock);
+
+	if (changed)
+		ath_chanctx_set_next(sc, true);
+
+	mutex_unlock(&sc->mutex);
+}
+
 void ath9k_fill_chanctx_ops(void)
 {
 	if (!ath9k_is_chanctx_enabled())
@@ -2354,7 +2384,7 @@ void ath9k_fill_chanctx_ops(void)
 	ath9k_ops.change_chanctx           = ath9k_change_chanctx;
 	ath9k_ops.assign_vif_chanctx       = ath9k_assign_vif_chanctx;
 	ath9k_ops.unassign_vif_chanctx     = ath9k_unassign_vif_chanctx;
-	ath9k_ops.mgd_prepare_tx           = ath9k_chanctx_force_active;
+	ath9k_ops.mgd_prepare_tx           = ath9k_mgd_prepare_tx;
 }
 
 #endif
-- 
2.0.4

