Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53686 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHWH7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 14/18] ath9k: Add ath9k_chanctx_wake_queues
Date: Sat, 23 Aug 2014 13:29:19 +0530
Message-Id: <1408780763-27974-15-git-send-email-sujith@msujith.org> (sfid-20140823_095946_706772_D03744B8)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Introduce a function that handles queues in channel
context mode.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  4 ++++
 drivers/net/wireless/ath/ath9k/channel.c | 26 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c    | 15 ++-------------
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 352c5da..892ca4a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -432,6 +432,7 @@ void ath9k_p2p_beacon_sync(struct ath_softc *sc);
 void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 				struct ieee80211_vif *vif);
 void ath9k_p2p_ps_timer(void *priv);
+void ath9k_chanctx_wake_queues(struct ath_softc *sc);
 
 void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
 				enum ath_chanctx_event ev);
@@ -491,6 +492,9 @@ static inline void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 static inline void ath9k_p2p_ps_timer(struct ath_softc *sc)
 {
 }
+static inline void ath9k_chanctx_wake_queues(struct ath_softc *sc)
+{
+}
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 39df24c..f719c36 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -196,6 +196,10 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 
+/**********************************************************/
+/* Functions to handle the channel context state machine. */
+/**********************************************************/
+
 static const char *offchannel_state_string(enum ath_offchannel_state state)
 {
 #define case_rtn_string(val) case val: return #val
@@ -958,6 +962,28 @@ bool ath9k_is_chanctx_enabled(void)
 	return (ath9k_use_chanctx == 1);
 }
 
+/********************/
+/* Queue management */
+/********************/
+
+void ath9k_chanctx_wake_queues(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	int i;
+
+	if (sc->cur_chan == &sc->offchannel.chan) {
+		ieee80211_wake_queue(sc->hw,
+				     sc->hw->offchannel_tx_hw_queue);
+	} else {
+		for (i = 0; i < IEEE80211_NUM_ACS; i++)
+			ieee80211_wake_queue(sc->hw,
+					     sc->cur_chan->hw_queue_base + i);
+	}
+
+	if (ah->opmode == NL80211_IFTYPE_AP)
+		ieee80211_wake_queue(sc->hw, sc->hw->queues - 2);
+}
+
 /*****************/
 /* P2P Powersave */
 /*****************/
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 30e0db2..e31f130 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -223,7 +223,6 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long flags;
-	int i;
 
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
@@ -270,18 +269,8 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 
 	if (!ath9k_is_chanctx_enabled())
 		ieee80211_wake_queues(sc->hw);
-	else {
-		if (sc->cur_chan == &sc->offchannel.chan)
-			ieee80211_wake_queue(sc->hw,
-					sc->hw->offchannel_tx_hw_queue);
-		else {
-			for (i = 0; i < IEEE80211_NUM_ACS; i++)
-				ieee80211_wake_queue(sc->hw,
-					sc->cur_chan->hw_queue_base + i);
-		}
-		if (ah->opmode == NL80211_IFTYPE_AP)
-			ieee80211_wake_queue(sc->hw, sc->hw->queues - 2);
-	}
+	else
+		ath9k_chanctx_wake_queues(sc);
 
 	ath9k_p2p_ps_timer(sc);
 
-- 
2.0.4

