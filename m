Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51321 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaHWH7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:37 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 11/18] ath9k: Fix channel context events
Date: Sat, 23 Aug 2014 13:29:16 +0530
Message-Id: <1408780763-27974-12-git-send-email-sujith@msujith.org> (sfid-20140823_095942_601288_21408224)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Check if channel context usage is enabled before
calling ath_chanctx_event() from various parts of the
driver. Also, make sure that ath_chanctx_event() is
compiled only when CONFIG_ATH9K_CHANNEL_CONTEXT is
enabled.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  9 +++++--
 drivers/net/wireless/ath/ath9k/beacon.c  | 13 +++++++---
 drivers/net/wireless/ath/ath9k/channel.c | 44 +++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/main.c    |  8 ++++--
 drivers/net/wireless/ath/ath9k/recv.c    |  9 ++++---
 drivers/net/wireless/ath/ath9k/xmit.c    |  7 +++--
 6 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2afe790..5220f2f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -418,8 +418,6 @@ void ath_chanctx_init(struct ath_softc *sc);
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
-void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
-		       enum ath_chanctx_event ev);
 void ath_offchannel_next(struct ath_softc *sc);
 void ath_scan_complete(struct ath_softc *sc, bool abort);
 void ath_roc_complete(struct ath_softc *sc, bool abort);
@@ -438,6 +436,8 @@ void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 				struct ieee80211_vif *vif);
 void ath9k_p2p_ps_timer(void *priv);
 
+void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
+		       enum ath_chanctx_event ev);
 void ath_chanctx_set_next(struct ath_softc *sc, bool force);
 #else
 static inline bool ath9k_is_chanctx_enabled(void)
@@ -453,6 +453,11 @@ static inline void ath9k_init_channel_context(struct ath_softc *sc)
 static inline void ath9k_deinit_channel_context(struct ath_softc *sc)
 {
 }
+static inline void ath_chanctx_event(struct ath_softc *sc,
+				     struct ieee80211_vif *vif,
+				     enum ath_chanctx_event ev)
+{
+}
 static inline int ath9k_init_p2p(struct ath_softc *sc)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index eaf8f05..68c95d4 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -427,9 +427,11 @@ void ath9k_beacon_tasklet(unsigned long data)
 
 	/* EDMA devices check that in the tx completion function. */
 	if (!edma) {
-		if (sc->sched.beacon_pending)
-			ath_chanctx_event(sc, NULL,
-					  ATH_CHANCTX_EVENT_BEACON_SENT);
+		if (ath9k_is_chanctx_enabled()) {
+			if (sc->sched.beacon_pending)
+				ath_chanctx_event(sc, NULL,
+						  ATH_CHANCTX_EVENT_BEACON_SENT);
+		}
 
 		if (ath9k_csa_is_finished(sc, vif))
 			return;
@@ -438,7 +440,10 @@ void ath9k_beacon_tasklet(unsigned long data)
 	if (!vif || !vif->bss_conf.enable_beacon)
 		return;
 
-	ath_chanctx_event(sc, vif, ATH_CHANCTX_EVENT_BEACON_PREPARE);
+	if (ath9k_is_chanctx_enabled()) {
+		ath_chanctx_event(sc, vif, ATH_CHANCTX_EVENT_BEACON_PREPARE);
+	}
+
 	bf = ath9k_beacon_generate(sc->hw, vif);
 
 	if (sc->beacon.bmisscnt != 0) {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index ceb3ce8..ae0b3f9 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -139,7 +139,11 @@ void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 	}
 	if (test_and_set_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
 		return;
-	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL);
+
+	if (ath9k_is_chanctx_enabled()) {
+		ath_chanctx_event(sc, NULL,
+				  ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL);
+	}
 }
 
 void ath_chanctx_init(struct ath_softc *sc)
@@ -190,6 +194,25 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 	ath_set_channel(sc);
 }
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+
+static const char *offchannel_state_string(enum ath_offchannel_state state)
+{
+#define case_rtn_string(val) case val: return #val
+
+	switch (state) {
+		case_rtn_string(ATH_OFFCHANNEL_IDLE);
+		case_rtn_string(ATH_OFFCHANNEL_PROBE_SEND);
+		case_rtn_string(ATH_OFFCHANNEL_PROBE_WAIT);
+		case_rtn_string(ATH_OFFCHANNEL_SUSPEND);
+		case_rtn_string(ATH_OFFCHANNEL_ROC_START);
+		case_rtn_string(ATH_OFFCHANNEL_ROC_WAIT);
+		case_rtn_string(ATH_OFFCHANNEL_ROC_DONE);
+	default:
+		return "unknown";
+	}
+}
+
 static struct ath_chanctx *
 ath_chanctx_get_next(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
@@ -440,25 +463,6 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 	spin_unlock_bh(&sc->chan_lock);
 }
 
-#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
-
-static const char *offchannel_state_string(enum ath_offchannel_state state)
-{
-#define case_rtn_string(val) case val: return #val
-
-	switch (state) {
-		case_rtn_string(ATH_OFFCHANNEL_IDLE);
-		case_rtn_string(ATH_OFFCHANNEL_PROBE_SEND);
-		case_rtn_string(ATH_OFFCHANNEL_PROBE_WAIT);
-		case_rtn_string(ATH_OFFCHANNEL_SUSPEND);
-		case_rtn_string(ATH_OFFCHANNEL_ROC_START);
-		case_rtn_string(ATH_OFFCHANNEL_ROC_WAIT);
-		case_rtn_string(ATH_OFFCHANNEL_ROC_DONE);
-	default:
-		return "unknown";
-	}
-}
-
 static int ath_scan_channel_duration(struct ath_softc *sc,
 				     struct ieee80211_channel *chan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4659168..30e0db2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1684,8 +1684,12 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			bss_conf->bssid, bss_conf->assoc);
 
 		ath9k_calculate_summary_state(sc, avp->chanctx);
-		if (bss_conf->assoc)
-			ath_chanctx_event(sc, vif, ATH_CHANCTX_EVENT_ASSOC);
+
+		if (ath9k_is_chanctx_enabled()) {
+			if (bss_conf->assoc)
+				ath_chanctx_event(sc, vif,
+						  ATH_CHANCTX_EVENT_ASSOC);
+		}
 	}
 
 	if (changed & BSS_CHANGED_IBSS) {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ae0d1e9..cc91749 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -892,9 +892,12 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		return -EINVAL;
 	}
 
-	if (rx_stats->is_mybeacon) {
-		sc->sched.next_tbtt = rx_stats->rs_tstamp;
-		ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_BEACON_RECEIVED);
+	if (ath9k_is_chanctx_enabled()) {
+		if (rx_stats->is_mybeacon) {
+			sc->sched.next_tbtt = rx_stats->rs_tstamp;
+			ath_chanctx_event(sc, NULL,
+					  ATH_CHANCTX_EVENT_BEACON_RECEIVED);
+		}
 	}
 
 	ath9k_cmn_process_rssi(common, hw, rx_stats, rx_status);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 704fcbc..2819866 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2632,8 +2632,11 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			sc->beacon.tx_processed = true;
 			sc->beacon.tx_last = !(ts.ts_status & ATH9K_TXERR_MASK);
 
-			ath_chanctx_event(sc, NULL,
-					  ATH_CHANCTX_EVENT_BEACON_SENT);
+			if (ath9k_is_chanctx_enabled()) {
+				ath_chanctx_event(sc, NULL,
+						  ATH_CHANCTX_EVENT_BEACON_SENT);
+			}
+
 			ath9k_csa_update(sc);
 			continue;
 		}
-- 
2.0.4

