Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43184 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753087AbdIFMZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 08:25:29 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] mac80211: Simplify locking in ieee80211_sta_tear_down_BA_sessions()
Date: Wed,  6 Sep 2017 17:18:33 +0300
Message-Id: <1504707513-28023-1-git-send-email-ilan.peer@intel.com> (sfid-20170906_142531_558852_8F175BBF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify the locking in  ieee80211_sta_tear_down_BA_sessions() and
lock sta->ampdu_mlme.mtx over the entire function instead of
locking/unlocking it for each TID etc.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/mac80211/ht.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 11d691c..3169862 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -290,13 +290,15 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 {
 	int i;
 
+	mutex_lock(&sta->ampdu_mlme.mtx);
 	for (i = 0; i <  IEEE80211_NUM_TIDS; i++) {
-		__ieee80211_stop_tx_ba_session(sta, i, reason);
-		__ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
-					       WLAN_REASON_QSTA_LEAVE_QBSS,
-					       reason != AGG_STOP_DESTROY_STA &&
-					       reason != AGG_STOP_PEER_REQUEST);
+		___ieee80211_stop_tx_ba_session(sta, i, reason);
+		___ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
+						WLAN_REASON_QSTA_LEAVE_QBSS,
+						reason != AGG_STOP_DESTROY_STA &&
+						reason != AGG_STOP_PEER_REQUEST);
 	}
+	mutex_unlock(&sta->ampdu_mlme.mtx);
 
 	/* stopping might queue the work again - so cancel only afterwards */
 	cancel_work_sync(&sta->ampdu_mlme.work);
-- 
1.9.1
