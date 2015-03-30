Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45434 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbbC3Ht0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 03:49:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: agg-tx: avoid sending DelBA with sta->lock held
Date: Mon, 30 Mar 2015 09:49:22 +0200
Message-Id: <1427701762-27090-1-git-send-email-johannes@sipsolutions.net> (sfid-20150330_094930_012557_1A56AE25)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The rate control locking caused a potential deadlock here due to the
locks being acquired in different orders, so that change cannot yet
be applied. However, there's no fundamental reason for this code to
hold the sta->lock while transmitting frames.

Clearly it's better not to hold the lock for longer periods of time,
which can happen here since we call all the way down to the driver.
Change the code a bit to not hold it while doing that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index a360c15cc978..668524aeb0b2 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -793,6 +793,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct tid_ampdu_tx *tid_tx;
+	bool send_delba = false;
 
 	trace_api_stop_tx_ba_cb(sdata, ra, tid);
 
@@ -824,13 +825,17 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 	}
 
 	if (tid_tx->stop_initiator == WLAN_BACK_INITIATOR && tid_tx->tx_stop)
-		ieee80211_send_delba(sta->sdata, ra, tid,
-			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
+		send_delba = true;
 
 	ieee80211_remove_tid_tx(sta, tid);
 
  unlock_sta:
 	spin_unlock_bh(&sta->lock);
+
+	if (send_delba)
+		ieee80211_send_delba(sdata, ra, tid,
+			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
+
 	mutex_unlock(&sta->ampdu_mlme.mtx);
  unlock:
 	mutex_unlock(&local->sta_mtx);
-- 
2.1.4

