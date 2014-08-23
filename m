Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49197 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaHWH72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 06/18] ath9k: Exclude more functions
Date: Sat, 23 Aug 2014 13:29:11 +0530
Message-Id: <1408780763-27974-7-git-send-email-sujith@msujith.org> (sfid-20140823_101533_491734_AAC60E91)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use CONFIG_ATH9K_CHANNEL_CONTEXT to exclude more functions:

ath_offchannel_channel_change()
ath_scan_channel_start()
ath_scan_send_probe()

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |   1 -
 drivers/net/wireless/ath/ath9k/channel.c | 120 +++++++++++++++----------------
 2 files changed, 60 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f9863e6..3b4201c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -420,7 +420,6 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 			struct cfg80211_chan_def *chandef);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
-void ath_offchannel_channel_change(struct ath_softc *sc);
 void ath_chanctx_offchan_switch(struct ath_softc *sc,
 				struct ieee80211_channel *chan);
 struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 61ed7a7..cd8af45 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -16,23 +16,6 @@
 
 #include "ath9k.h"
 
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
 /* Set/change channels.  If the channel is really being changed, it's done
  * by reseting the chip.  To accomplish this we must first cleanup any pending
  * DMA, then restart stuff.
@@ -616,6 +599,25 @@ void ath_scan_complete(struct ath_softc *sc, bool abort)
 	ath9k_ps_restore(sc);
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
 static void ath_scan_send_probe(struct ath_softc *sc,
 				struct cfg80211_ssid *ssid)
 {
@@ -674,49 +676,6 @@ static void ath_scan_channel_start(struct ath_softc *sc)
 	mod_timer(&sc->offchannel.timer, jiffies + sc->offchannel.duration);
 }
 
-void ath_offchannel_channel_change(struct ath_softc *sc)
-{
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-
-	ath_dbg(common, CHAN_CTX, "%s: state: %s\n",
-		__func__, offchannel_state_string(sc->offchannel.state));
-
-	switch (sc->offchannel.state) {
-	case ATH_OFFCHANNEL_PROBE_SEND:
-		if (!sc->offchannel.scan_req)
-			return;
-
-		if (sc->cur_chan->chandef.chan !=
-		    sc->offchannel.chan.chandef.chan)
-			return;
-
-		ath_scan_channel_start(sc);
-		break;
-	case ATH_OFFCHANNEL_IDLE:
-		if (!sc->offchannel.scan_req)
-			return;
-
-		ath_scan_complete(sc, false);
-		break;
-	case ATH_OFFCHANNEL_ROC_START:
-		if (sc->cur_chan != &sc->offchannel.chan)
-			break;
-
-		sc->offchannel.state = ATH_OFFCHANNEL_ROC_WAIT;
-		mod_timer(&sc->offchannel.timer, jiffies +
-			  msecs_to_jiffies(sc->offchannel.duration));
-		ieee80211_ready_on_channel(sc->hw);
-		break;
-	case ATH_OFFCHANNEL_ROC_DONE:
-		ath_roc_complete(sc, false);
-		break;
-	default:
-		break;
-	}
-}
-
-#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
-
 static void ath_chanctx_timer(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *) data;
@@ -848,6 +807,47 @@ static bool ath_chanctx_defer_switch(struct ath_softc *sc)
 	return true;
 }
 
+static void ath_offchannel_channel_change(struct ath_softc *sc)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_dbg(common, CHAN_CTX, "%s: state: %s\n",
+		__func__, offchannel_state_string(sc->offchannel.state));
+
+	switch (sc->offchannel.state) {
+	case ATH_OFFCHANNEL_PROBE_SEND:
+		if (!sc->offchannel.scan_req)
+			return;
+
+		if (sc->cur_chan->chandef.chan !=
+		    sc->offchannel.chan.chandef.chan)
+			return;
+
+		ath_scan_channel_start(sc);
+		break;
+	case ATH_OFFCHANNEL_IDLE:
+		if (!sc->offchannel.scan_req)
+			return;
+
+		ath_scan_complete(sc, false);
+		break;
+	case ATH_OFFCHANNEL_ROC_START:
+		if (sc->cur_chan != &sc->offchannel.chan)
+			break;
+
+		sc->offchannel.state = ATH_OFFCHANNEL_ROC_WAIT;
+		mod_timer(&sc->offchannel.timer, jiffies +
+			  msecs_to_jiffies(sc->offchannel.duration));
+		ieee80211_ready_on_channel(sc->hw);
+		break;
+	case ATH_OFFCHANNEL_ROC_DONE:
+		ath_roc_complete(sc, false);
+		break;
+	default:
+		break;
+	}
+}
+
 void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 {
 	struct timespec ts;
-- 
2.0.4

