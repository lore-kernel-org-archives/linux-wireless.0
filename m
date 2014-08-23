Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52126 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaHWH7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:30 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 07/18] ath9k: Conditionally compile more functions
Date: Sat, 23 Aug 2014 13:29:12 +0530
Message-Id: <1408780763-27974-8-git-send-email-sujith@msujith.org> (sfid-20140823_095939_224034_D4401116)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use CONFIG_ATH9K_CHANNEL_CONTEXT to exclude:

ath_scan_complete()
ath_roc_complete()
ath_offchannel_next()
ath_scan_next_channel()
ath_scan_channel_duration()

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 38 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index cd8af45..8214b32 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -507,6 +507,25 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 	spin_unlock_bh(&sc->chan_lock);
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
 static int ath_scan_channel_duration(struct ath_softc *sc,
 				     struct ieee80211_channel *chan)
 {
@@ -599,25 +618,6 @@ void ath_scan_complete(struct ath_softc *sc, bool abort)
 	ath9k_ps_restore(sc);
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
 static void ath_scan_send_probe(struct ath_softc *sc,
 				struct cfg80211_ssid *ssid)
 {
-- 
2.0.4

