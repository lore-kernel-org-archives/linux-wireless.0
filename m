Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54507 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaJQCKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:10:20 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 12/23] ath9k: Send AUTHORIZED event only for station mode
Date: Fri, 17 Oct 2014 07:40:19 +0530
Message-Id: <1413511830-5536-13-git-send-email-sujith@msujith.org> (sfid-20141017_041324_933116_5FFC74A5)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ATH_CHANCTX_EVENT_AUTHORIZED is required to trigger
the MCC scheduler when a station interface becomes
authorized. But, since the driver gets station state
notifications when the current operating mode is AP
too, make sure that we send ATH_CHANCTX_EVENT_AUTHORIZED
only when the interface is in station mode.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2048ef1..0545fe6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1590,10 +1590,12 @@ static int ath9k_sta_state(struct ieee80211_hw *hw,
 	}
 
 	if (ath9k_is_chanctx_enabled()) {
-		if (old_state == IEEE80211_STA_ASSOC &&
-		    new_state == IEEE80211_STA_AUTHORIZED)
-			ath_chanctx_event(sc, vif,
-					  ATH_CHANCTX_EVENT_AUTHORIZED);
+		if (vif->type == NL80211_IFTYPE_STATION) {
+			if (old_state == IEEE80211_STA_ASSOC &&
+			    new_state == IEEE80211_STA_AUTHORIZED)
+				ath_chanctx_event(sc, vif,
+						  ATH_CHANCTX_EVENT_AUTHORIZED);
+		}
 	}
 
 	return ret;
-- 
2.1.2

