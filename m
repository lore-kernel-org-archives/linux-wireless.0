Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:34429 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZDRRjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 13:39:18 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2 v2] mac80211: set CLEAR_PS for pspolled frames
Date: Sat, 18 Apr 2009 19:39:15 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200904181830.00309.chunkeey@web.de>
In-Reply-To: <200904181830.00309.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200904181939.16164.chunkeey@web.de> (sfid-20090418_193922_013770_DBD44F3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch sets IEEE80211_TX_CTL_CLEAR_PS_FILT for outgoing
frames for a half-wake station.
 
this is necessary if one wants to get ps-poll working properly with a p54 ap.
 
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
changes:
	added a explanation, why we can safely remove the filter now.
---
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3fb04a8..f336cc7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -409,8 +409,24 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		       sta->sta.addr);
 	}
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-	clear_sta_flags(sta, WLAN_STA_PSPOLL);
+	if (test_and_clear_sta_flags(sta, WLAN_STA_PSPOLL)) {
+		/*
+		 * The sleeping station with pending data is now snoozing.
+		 * It queried us for its buffered frames and will go back
+		 * to deep sleep once it got everything.
+		 *
+		 * inform the driver, in case the hardware does powersave
+		 * frame filtering and keeps a station  blacklist on its own
+		 * (e.g: p54), so that frames can be delivered unimpeded.
+		 *
+		 * Note: It should be save to disable the filter now.
+		 * As, it is really unlikely that we still have any pending
+		 * frame for this station in the hw's buffers/fifos left,
+		 * that is not rejected with a unsuccessful tx_status yet.
+		 */
 
+		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+	}
 	return TX_CONTINUE;
 }
 
