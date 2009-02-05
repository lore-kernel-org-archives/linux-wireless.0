Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZBEQQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 11:16:22 -0500
Message-Id: <20090205161132.595863133@sipsolutions.net> (sfid-20090205_171624_969095_B8A56E8D)
References: <20090205160738.990564487@sipsolutions.net>
Date: Thu, 05 Feb 2009 17:07:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/11] mac80211: hardware should not deny going back to
	legacy
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doing so would be an MLME protocol violation when the peer disabled
the aggregation session. Quick driver review indicates that there are
error codes passed all over the drivers but cannot ever be nonzero
except in error conditions that would indicate mac80211 bugs.

No real changes here, since no drivers currently can return -EBUSY.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-tx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-01-29 01:46:59.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-01-29 02:03:26.000000000 +0100
@@ -407,9 +407,8 @@ int ieee80211_stop_tx_ba_session(struct 
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_STOP,
 					       &sta->sta, tid, NULL);
 
-	/* case HW denied going back to legacy */
-	if (ret) {
-		WARN_ON(ret != -EBUSY);
+	/* HW shall not deny going back to legacy */
+	if (WARN_ON(ret)) {
 		*state = HT_AGG_STATE_OPERATIONAL;
 		if (hw->ampdu_queues)
 			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);

-- 

