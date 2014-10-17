Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35686 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaJQCKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:10:33 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 15/23] ath9k: Check for active GO in mgd_prepare_tx()
Date: Fri, 17 Oct 2014 07:40:22 +0530
Message-Id: <1413511830-5536-16-git-send-email-sujith@msujith.org> (sfid-20141017_041324_758666_244189ED)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If a GO interface is active when we receive a
mgd_prepare_tx() call, then we need to send
out a new NoA before switching to a new context.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 ++
 drivers/net/wireless/ath/ath9k/channel.c | 14 ++++++++++
 drivers/net/wireless/ath/ath9k/main.c    | 45 +++++++++++++++++++++++++++-----
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8f6f46c..b7abb4f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -385,6 +385,7 @@ struct ath_chanctx_sched {
 	bool wait_switch;
 	bool force_noa_update;
 	bool extend_absence;
+	bool mgd_prepare_tx;
 	enum ath_chanctx_state state;
 	u8 beacon_miss;
 
@@ -977,6 +978,7 @@ struct ath_softc {
 	struct ath_chanctx_sched sched;
 	struct ath_offchannel offchannel;
 	struct ath_chanctx *next_chan;
+	struct completion go_beacon;
 #endif
 
 	unsigned long driver_data;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 2066b09..45d2c48 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -421,6 +421,9 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 				"Move chanctx state from WAIT_FOR_TIMER to WAIT_FOR_BEACON\n");
 		}
 
+		if (sc->sched.mgd_prepare_tx)
+			sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
+
 		/*
 		 * When a context becomes inactive, for example,
 		 * disassociation of a station context, the NoA
@@ -547,6 +550,15 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		}
 
 		sc->sched.beacon_pending = false;
+
+		if (sc->sched.mgd_prepare_tx) {
+			sc->sched.mgd_prepare_tx = false;
+			complete(&sc->go_beacon);
+			ath_dbg(common, CHAN_CTX,
+				"Beacon sent, complete go_beacon\n");
+			break;
+		}
+
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON)
 			break;
 
@@ -1263,6 +1275,8 @@ void ath9k_init_channel_context(struct ath_softc *sc)
 		    (unsigned long)sc);
 	setup_timer(&sc->sched.timer, ath_chanctx_timer,
 		    (unsigned long)sc);
+
+	init_completion(&sc->go_beacon);
 }
 
 void ath9k_deinit_channel_context(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c291d54..f58781a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2474,7 +2474,11 @@ static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (struct ath_vif *) vif->drv_priv;
+	struct ath_beacon_config *cur_conf;
+	struct ath_chanctx *go_ctx;
+	unsigned long timeout;
 	bool changed = false;
+	u32 beacon_int;
 
 	if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
 		return;
@@ -2485,19 +2489,46 @@ static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	spin_lock_bh(&sc->chan_lock);
-	if (sc->next_chan || (sc->cur_chan != avp->chanctx)) {
-		sc->next_chan = avp->chanctx;
+	if (sc->next_chan || (sc->cur_chan != avp->chanctx))
 		changed = true;
+	spin_unlock_bh(&sc->chan_lock);
+
+	if (!changed)
+		goto out;
+
+	go_ctx = ath_is_go_chanctx_present(sc);
+
+	if (go_ctx) {
+		/*
+		 * Wait till the GO interface gets a chance
+		 * to send out an NoA.
+		 */
+		spin_lock_bh(&sc->chan_lock);
+		sc->sched.mgd_prepare_tx = true;
+		cur_conf = &go_ctx->beacon;
+		beacon_int = TU_TO_USEC(cur_conf->beacon_interval);
+		spin_unlock_bh(&sc->chan_lock);
+
+		timeout = usecs_to_jiffies(beacon_int);
+		init_completion(&sc->go_beacon);
+
+		if (wait_for_completion_timeout(&sc->go_beacon,
+						timeout) == 0)
+			ath_dbg(common, CHAN_CTX,
+				"Failed to send new NoA\n");
 	}
+
 	ath_dbg(common, CHAN_CTX,
-		"%s: Set chanctx state to FORCE_ACTIVE, changed: %d\n",
-		__func__, changed);
+		"%s: Set chanctx state to FORCE_ACTIVE for vif: %pM\n",
+		__func__, vif->addr);
+
+	spin_lock_bh(&sc->chan_lock);
+	sc->next_chan = avp->chanctx;
 	sc->sched.state = ATH_CHANCTX_STATE_FORCE_ACTIVE;
 	spin_unlock_bh(&sc->chan_lock);
 
-	if (changed)
-		ath_chanctx_set_next(sc, true);
-
+	ath_chanctx_set_next(sc, true);
+out:
 	mutex_unlock(&sc->mutex);
 }
 
-- 
2.1.2

