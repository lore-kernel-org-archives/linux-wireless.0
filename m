Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40072 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdLIUNl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Dec 2017 15:13:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix locking in ieee80211_sta_tear_down_BA_sessions
Date: Sat,  9 Dec 2017 21:13:38 +0100
Message-Id: <20171209201338.24931-1-johannes@sipsolutions.net> (sfid-20171209_211345_027665_71AB412F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to overlap between
commit 1281103770e9 ("mac80211: Simplify locking in ieee80211_sta_tear_down_BA_sessions()")
and the way that Luca modified
commit 72e2c3438ba3 ("mac80211: tear down RX aggregations first")
when sending it upstream from Intel's internal tree, we get
the following warning:

WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ieee80211_stop_tx_ba_session+0x158/0x1f0

since there's no appropriate locking around the call to
___ieee80211_stop_tx_ba_session; Sara's original just had
a call to the locked __ieee80211_stop_tx_ba_session (one
less underscore) but it looks like Luca modified both of
the calls when fixing it up for upstream, leading to the
problem at hand.

Move the locking appropriately to fix this problem.

Reported-by: Kalle Valo <kvalo@codeaurora.org>
Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ht.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 167f83b853e6..1621b6ab17ba 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -291,16 +291,15 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 	int i;
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
-	for (i = 0; i <  IEEE80211_NUM_TIDS; i++) {
+	for (i = 0; i <  IEEE80211_NUM_TIDS; i++)
 		___ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
 						WLAN_REASON_QSTA_LEAVE_QBSS,
 						reason != AGG_STOP_DESTROY_STA &&
 						reason != AGG_STOP_PEER_REQUEST);
-	}
-	mutex_unlock(&sta->ampdu_mlme.mtx);
 
 	for (i = 0; i <  IEEE80211_NUM_TIDS; i++)
 		___ieee80211_stop_tx_ba_session(sta, i, reason);
+	mutex_unlock(&sta->ampdu_mlme.mtx);
 
 	/* stopping might queue the work again - so cancel only afterwards */
 	cancel_work_sync(&sta->ampdu_mlme.work);
-- 
2.14.2
