Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:32921 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0AXMzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 07:55:18 -0500
Subject: [PATCH] mac80211: fix update_tkip_key() documentation about the
	context
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 24 Jan 2010 14:55:12 +0200
Message-ID: <20100124125512.14746.63093.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes noticed that I had incorrectly documented the context of
update_tkip_key() driver operation. It must be atomic because all
RX code is run inside rcu critical section.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 include/net/mac80211.h    |    2 +-
 net/mac80211/driver-ops.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f56d6f4..f64402f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1489,7 +1489,7 @@ enum ieee80211_ampdu_mlme_action {
  * @update_tkip_key: See the section "Hardware crypto acceleration"
  * 	This callback will be called in the context of Rx. Called for drivers
  * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
- *	The callback can sleep.
+ *	The callback must be atomic.
  *
  * @hw_scan: Ask the hardware to service the scan request, no need to start
  *	the scan state machine in stack. The scan must honour the channel
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 40c6e9a..6c31f38 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -144,8 +144,6 @@ static inline void drv_update_tkip_key(struct ieee80211_local *local,
 {
 	struct ieee80211_sta *ista = NULL;
 
-	might_sleep();
-
 	if (sta)
 		ista = &sta->sta;
 

