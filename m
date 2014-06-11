Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37140 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaFKKuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:50:07 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 21/28] ath9k: Implement mgd_prepare_tx
Date: Wed, 11 Jun 2014 16:18:09 +0530
Message-ID: <1402483696-2498-22-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_130500_855884_E6CDF000)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 ++
 drivers/net/wireless/ath/ath9k/channel.c | 50 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/main.c    |  1 +
 3 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a4646a0..7947909 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -357,6 +357,7 @@ enum ath_chanctx_state {
 	ATH_CHANCTX_STATE_WAIT_FOR_BEACON,
 	ATH_CHANCTX_STATE_WAIT_FOR_TIMER,
 	ATH_CHANCTX_STATE_SWITCH,
+	ATH_CHANCTX_STATE_FORCE_ACTIVE,
 };
 
 struct ath_chanctx_sched {
@@ -397,6 +398,8 @@ struct ath_offchannel {
 	     ctx++)
 
 void ath9k_fill_chanctx_ops(void);
+void ath9k_chanctx_force_active(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif);
 static inline struct ath_chanctx *
 ath_chanctx_get(struct ieee80211_chanctx_conf *ctx)
 {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 6ea806c..8d56b79 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -223,25 +223,20 @@ static bool ath_chanctx_defer_switch(struct ath_softc *sc)
 	return true;
 }
 
-void ath_chanctx_work(struct work_struct *work)
+static void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 {
-	struct ath_softc *sc = container_of(work, struct ath_softc,
-					    chanctx_work);
 	struct timespec ts;
 	bool measure_time = false;
 	bool send_ps = false;
 
-	mutex_lock(&sc->mutex);
 	spin_lock_bh(&sc->chan_lock);
 	if (!sc->next_chan) {
 		spin_unlock_bh(&sc->chan_lock);
-		mutex_unlock(&sc->mutex);
 		return;
 	}
 
-	if (ath_chanctx_defer_switch(sc)) {
+	if (!force && ath_chanctx_defer_switch(sc)) {
 		spin_unlock_bh(&sc->chan_lock);
-		mutex_unlock(&sc->mutex);
 		return;
 	}
 
@@ -269,8 +264,9 @@ void ath_chanctx_work(struct work_struct *work)
 	sc->cur_chan = sc->next_chan;
 	sc->cur_chan->stopped = false;
 	sc->next_chan = NULL;
-	sc->sched.state = ATH_CHANCTX_STATE_IDLE;
 	sc->sched.offchannel_duration = 0;
+	if (sc->sched.state != ATH_CHANCTX_STATE_FORCE_ACTIVE)
+		sc->sched.state = ATH_CHANCTX_STATE_IDLE;
 
 	spin_unlock_bh(&sc->chan_lock);
 
@@ -286,6 +282,14 @@ void ath_chanctx_work(struct work_struct *work)
 		ath_chanctx_send_ps_frame(sc, false);
 
 	ath_offchannel_channel_change(sc);
+}
+
+void ath_chanctx_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    chanctx_work);
+	mutex_lock(&sc->mutex);
+	ath_chanctx_set_next(sc, false);
 	mutex_unlock(&sc->mutex);
 }
 
@@ -320,6 +324,36 @@ void ath_chanctx_init(struct ath_softc *sc)
 
 }
 
+void ath9k_chanctx_force_active(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif)
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
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 			struct cfg80211_chan_def *chandef)
 {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0ba496d..b8975f0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2553,6 +2553,7 @@ void ath9k_fill_chanctx_ops(void)
 	ath9k_ops.change_chanctx     = ath9k_change_chanctx;
 	ath9k_ops.assign_vif_chanctx = ath9k_assign_vif_chanctx;
 	ath9k_ops.unassign_vif_chanctx = ath9k_unassign_vif_chanctx;
+	ath9k_ops.mgd_prepare_tx = ath9k_chanctx_force_active;
 }
 
 struct ieee80211_ops ath9k_ops = {
-- 
2.0.0

