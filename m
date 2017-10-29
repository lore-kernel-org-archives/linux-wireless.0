Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42214 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751942AbdJ2JvU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 05:51:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 11:51:09 +0200
Message-Id: <20171029095111.17078-4-luca@coelho.fi> (sfid-20171029_105208_156756_FBC9FB28)
In-Reply-To: <20171029095111.17078-1-luca@coelho.fi>
References: <20171029095111.17078-1-luca@coelho.fi>
Subject: [PATCH 3/5] mac80211: tear down RX aggregations first
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When doing HW restart we tear down aggregations.
Since at this point we are not TX'ing any aggregation, while
the peer is still sending RX aggregation over the air, it will
make sense to tear down the RX aggregations first.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ht.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index e55dabf42722..cb0860d751fd 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -292,7 +292,6 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 	for (i = 0; i <  IEEE80211_NUM_TIDS; i++) {
-		___ieee80211_stop_tx_ba_session(sta, i, reason);
 		___ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
 						WLAN_REASON_QSTA_LEAVE_QBSS,
 						reason != AGG_STOP_DESTROY_STA &&
@@ -300,6 +299,9 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
 	}
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 
+	for (i = 0; i <  IEEE80211_NUM_TIDS; i++)
+		___ieee80211_stop_tx_ba_session(sta, i, reason);
+
 	/* stopping might queue the work again - so cancel only afterwards */
 	cancel_work_sync(&sta->ampdu_mlme.work);
 
-- 
2.14.2
