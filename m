Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43455 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaHXPqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 11:46:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/4] ath9k: Print the event/state in ath_chanctx_event
Date: Sun, 24 Aug 2014 21:16:11 +0530
Message-Id: <1408895173-3732-3-git-send-email-sujith@msujith.org> (sfid-20140824_174622_031913_FF858E17)
In-Reply-To: <1408895173-3732-1-git-send-email-sujith@msujith.org>
References: <1408895173-3732-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 +++
 drivers/net/wireless/ath/ath9k/channel.c | 37 ++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7c8c6f1..c690601 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -410,6 +410,9 @@ struct ath_offchannel {
 	int roc_duration;
 	int duration;
 };
+
+#define case_rtn_string(val) case val: return #val
+
 #define ath_for_each_chanctx(_sc, _ctx)                             \
 	for (ctx = &sc->chanctx[0];                                 \
 	     ctx <= &sc->chanctx[ARRAY_SIZE(sc->chanctx) - 1];      \
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 34ccfa0..9be92d8 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -149,8 +149,6 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 
 static const char *offchannel_state_string(enum ath_offchannel_state state)
 {
-#define case_rtn_string(val) case val: return #val
-
 	switch (state) {
 		case_rtn_string(ATH_OFFCHANNEL_IDLE);
 		case_rtn_string(ATH_OFFCHANNEL_PROBE_SEND);
@@ -164,6 +162,37 @@ static const char *offchannel_state_string(enum ath_offchannel_state state)
 	}
 }
 
+static const char *chanctx_event_string(enum ath_chanctx_event ev)
+{
+	switch (ev) {
+		case_rtn_string(ATH_CHANCTX_EVENT_BEACON_PREPARE);
+		case_rtn_string(ATH_CHANCTX_EVENT_BEACON_SENT);
+		case_rtn_string(ATH_CHANCTX_EVENT_TSF_TIMER);
+		case_rtn_string(ATH_CHANCTX_EVENT_BEACON_RECEIVED);
+		case_rtn_string(ATH_CHANCTX_EVENT_ASSOC);
+		case_rtn_string(ATH_CHANCTX_EVENT_SWITCH);
+		case_rtn_string(ATH_CHANCTX_EVENT_ASSIGN);
+		case_rtn_string(ATH_CHANCTX_EVENT_UNASSIGN);
+		case_rtn_string(ATH_CHANCTX_EVENT_CHANGE);
+		case_rtn_string(ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL);
+	default:
+		return "unknown";
+	}
+}
+
+static const char *chanctx_state_string(enum ath_chanctx_state state)
+{
+	switch (state) {
+		case_rtn_string(ATH_CHANCTX_STATE_IDLE);
+		case_rtn_string(ATH_CHANCTX_STATE_WAIT_FOR_BEACON);
+		case_rtn_string(ATH_CHANCTX_STATE_WAIT_FOR_TIMER);
+		case_rtn_string(ATH_CHANCTX_STATE_SWITCH);
+		case_rtn_string(ATH_CHANCTX_STATE_FORCE_ACTIVE);
+	default:
+		return "unknown";
+	}
+}
+
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -275,6 +304,10 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 	u32 beacon_int;
 	bool noa_changed = false;
 
+	ath_dbg(common, CHAN_CTX, "event: %s, state: %s\n",
+		chanctx_event_string(ev),
+		chanctx_state_string(sc->sched.state));
+
 	if (vif)
 		avp = (struct ath_vif *) vif->drv_priv;
 
-- 
2.0.4

