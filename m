Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35975 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaJFFsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 01:48:55 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 5/6] ath9k: Enable multi-channel properly
Date: Mon,  6 Oct 2014 11:19:38 +0530
Message-Id: <1412574579-22532-6-git-send-email-sujith@msujith.org> (sfid-20141006_074906_423962_C8026C9B)
In-Reply-To: <1412574579-22532-1-git-send-email-sujith@msujith.org>
References: <1412574579-22532-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In MCC mode, currently the decision to enable
the multi-channel state machine is done
based on the association status if one of
the interfaces assigned to a context is in
station mode.

This allows the driver to switch to the other
context before the current station is able to
complete the 4-way handshake in case it is
required and this causes problems.

Instead, enable multi-channel mode when the
station moves to the authorized state. This
disallows an early switch to the other channel.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 +-
 drivers/net/wireless/ath/ath9k/channel.c |  4 ++--
 drivers/net/wireless/ath/ath9k/main.c    | 13 +++++++------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 01a7db0..aff5e4c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -362,7 +362,7 @@ enum ath_chanctx_event {
 	ATH_CHANCTX_EVENT_BEACON_SENT,
 	ATH_CHANCTX_EVENT_TSF_TIMER,
 	ATH_CHANCTX_EVENT_BEACON_RECEIVED,
-	ATH_CHANCTX_EVENT_ASSOC,
+	ATH_CHANCTX_EVENT_AUTHORIZED,
 	ATH_CHANCTX_EVENT_SWITCH,
 	ATH_CHANCTX_EVENT_ASSIGN,
 	ATH_CHANCTX_EVENT_UNASSIGN,
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 945c898..16bed6a 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -171,7 +171,7 @@ static const char *chanctx_event_string(enum ath_chanctx_event ev)
 		case_rtn_string(ATH_CHANCTX_EVENT_BEACON_SENT);
 		case_rtn_string(ATH_CHANCTX_EVENT_TSF_TIMER);
 		case_rtn_string(ATH_CHANCTX_EVENT_BEACON_RECEIVED);
-		case_rtn_string(ATH_CHANCTX_EVENT_ASSOC);
+		case_rtn_string(ATH_CHANCTX_EVENT_AUTHORIZED);
 		case_rtn_string(ATH_CHANCTX_EVENT_SWITCH);
 		case_rtn_string(ATH_CHANCTX_EVENT_ASSIGN);
 		case_rtn_string(ATH_CHANCTX_EVENT_UNASSIGN);
@@ -510,7 +510,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 
 		ath_chanctx_setup_timer(sc, tsf_time);
 		break;
-	case ATH_CHANCTX_EVENT_ASSOC:
+	case ATH_CHANCTX_EVENT_AUTHORIZED:
 		if (sc->sched.state != ATH_CHANCTX_STATE_FORCE_ACTIVE ||
 		    avp->chanctx != sc->cur_chan)
 			break;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 902807e..446bc46 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1569,6 +1569,13 @@ static int ath9k_sta_state(struct ieee80211_hw *hw,
 			"Remove station: %pM\n", sta->addr);
 	}
 
+	if (ath9k_is_chanctx_enabled()) {
+		if (old_state == IEEE80211_STA_ASSOC &&
+		    new_state == IEEE80211_STA_AUTHORIZED)
+			ath_chanctx_event(sc, vif,
+					  ATH_CHANCTX_EVENT_AUTHORIZED);
+	}
+
 	return ret;
 }
 
@@ -1761,12 +1768,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		avp->assoc = bss_conf->assoc;
 
 		ath9k_calculate_summary_state(sc, avp->chanctx);
-
-		if (ath9k_is_chanctx_enabled()) {
-			if (bss_conf->assoc)
-				ath_chanctx_event(sc, vif,
-						  ATH_CHANCTX_EVENT_ASSOC);
-		}
 	}
 
 	if (changed & BSS_CHANGED_IBSS) {
-- 
2.1.2

