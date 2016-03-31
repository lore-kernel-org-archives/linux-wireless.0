Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbcCaRER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/10] mac80211: move semicolon out of CALL_RXH macro
Date: Thu, 31 Mar 2016 20:02:04 +0300
Message-Id: <1459443731-4614-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190423_703331_1525EC82)
In-Reply-To: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the semicolon, people typically assume that and
once line already put a semicolon behind the "call".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d979818..1df3a3e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3183,7 +3183,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 		res = rxh(rx);		\
 		if (res != RX_CONTINUE)	\
 			goto rxh_next;  \
-	} while (0);
+	} while (0)
 
 	/* Lock here to avoid hitting all of the data used in the RX
 	 * path (e.g. key data, station data, ...) concurrently when
@@ -3201,30 +3201,30 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 		 */
 		rx->skb = skb;
 
-		CALL_RXH(ieee80211_rx_h_check_more_data)
-		CALL_RXH(ieee80211_rx_h_uapsd_and_pspoll)
-		CALL_RXH(ieee80211_rx_h_sta_process)
-		CALL_RXH(ieee80211_rx_h_decrypt)
-		CALL_RXH(ieee80211_rx_h_defragment)
-		CALL_RXH(ieee80211_rx_h_michael_mic_verify)
+		CALL_RXH(ieee80211_rx_h_check_more_data);
+		CALL_RXH(ieee80211_rx_h_uapsd_and_pspoll);
+		CALL_RXH(ieee80211_rx_h_sta_process);
+		CALL_RXH(ieee80211_rx_h_decrypt);
+		CALL_RXH(ieee80211_rx_h_defragment);
+		CALL_RXH(ieee80211_rx_h_michael_mic_verify);
 		/* must be after MMIC verify so header is counted in MPDU mic */
 #ifdef CONFIG_MAC80211_MESH
 		if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 			CALL_RXH(ieee80211_rx_h_mesh_fwding);
 #endif
-		CALL_RXH(ieee80211_rx_h_amsdu)
-		CALL_RXH(ieee80211_rx_h_data)
+		CALL_RXH(ieee80211_rx_h_amsdu);
+		CALL_RXH(ieee80211_rx_h_data);
 
 		/* special treatment -- needs the queue */
 		res = ieee80211_rx_h_ctrl(rx, frames);
 		if (res != RX_CONTINUE)
 			goto rxh_next;
 
-		CALL_RXH(ieee80211_rx_h_mgmt_check)
-		CALL_RXH(ieee80211_rx_h_action)
-		CALL_RXH(ieee80211_rx_h_userspace_mgmt)
-		CALL_RXH(ieee80211_rx_h_action_return)
-		CALL_RXH(ieee80211_rx_h_mgmt)
+		CALL_RXH(ieee80211_rx_h_mgmt_check);
+		CALL_RXH(ieee80211_rx_h_action);
+		CALL_RXH(ieee80211_rx_h_userspace_mgmt);
+		CALL_RXH(ieee80211_rx_h_action_return);
+		CALL_RXH(ieee80211_rx_h_mgmt);
 
  rxh_next:
 		ieee80211_rx_handlers_result(rx, res);
@@ -3247,10 +3247,10 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 		res = rxh(rx);		\
 		if (res != RX_CONTINUE)	\
 			goto rxh_next;  \
-	} while (0);
+	} while (0)
 
-	CALL_RXH(ieee80211_rx_h_check_dup)
-	CALL_RXH(ieee80211_rx_h_check)
+	CALL_RXH(ieee80211_rx_h_check_dup);
+	CALL_RXH(ieee80211_rx_h_check);
 
 	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
 
-- 
2.5.0

