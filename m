Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39807 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaHXPqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 11:46:12 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 1/4] ath9k: Add new chanctx events
Date: Sun, 24 Aug 2014 21:16:10 +0530
Message-Id: <1408895173-3732-2-git-send-email-sujith@msujith.org> (sfid-20140824_174616_188028_472F5A5C)
In-Reply-To: <1408895173-3732-1-git-send-email-sujith@msujith.org>
References: <1408895173-3732-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This will be useful in handling addition/change of new
channel contexts.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 2 ++
 drivers/net/wireless/ath/ath9k/channel.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index acbe2b7..7c8c6f1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -359,7 +359,9 @@ enum ath_chanctx_event {
 	ATH_CHANCTX_EVENT_BEACON_RECEIVED,
 	ATH_CHANCTX_EVENT_ASSOC,
 	ATH_CHANCTX_EVENT_SWITCH,
+	ATH_CHANCTX_EVENT_ASSIGN,
 	ATH_CHANCTX_EVENT_UNASSIGN,
+	ATH_CHANCTX_EVENT_CHANGE,
 	ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL,
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 0e64b73..34ccfa0 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -452,6 +452,10 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->next_chan = ctx;
 		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
 		break;
+	case ATH_CHANCTX_EVENT_ASSIGN:
+		break;
+	case ATH_CHANCTX_EVENT_CHANGE:
+		break;
 	}
 
 	spin_unlock_bh(&sc->chan_lock);
-- 
2.0.4

