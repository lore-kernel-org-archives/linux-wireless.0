Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38127 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283AbZDRQaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 12:30:04 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: set CLEAR_PS for pspolled frames
Date: Sat, 18 Apr 2009 18:30:00 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904181830.00309.chunkeey@web.de> (sfid-20090418_183028_521523_EFE39577)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch sets IEEE80211_TX_CTL_CLEAR_PS_FILT for outgoing
frames for a half-wake station.

this is necessary if one wants to get ps-poll working properly with a p54 ap.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3fb04a8..4c2e19e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -409,8 +409,19 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
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
+		 */
 
+		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+	}
 	return TX_CONTINUE;
 }
 
