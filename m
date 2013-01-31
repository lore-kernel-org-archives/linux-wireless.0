Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3AaNFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:05:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: always allow calling ieee80211_connection_loss()
Date: Thu, 31 Jan 2013 14:06:02 +0100
Message-Id: <1359637562-22399-2-git-send-email-johannes@sipsolutions.net> (sfid-20130131_140548_036156_85A6E9E7)
In-Reply-To: <1359637562-22399-1-git-send-email-johannes@sipsolutions.net>
References: <1359637562-22399-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With multi-channel, there's a corner case where a driver
doesn't receive a beacon soon enough to be able to sync
its timers with the AP. In this case, the only recovery
(after trying again) is to disconnect from the AP. Allow
calling ieee80211_connection_loss() for such cases. To
make that possible, modify the work function to not rely
on the IEEE80211_HW_CONNECTION_MONITOR flag but use new
state kept in the interface instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 2 ++
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/mlme.c        | 6 ++++--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 434f26d..1d3cbdc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3882,6 +3882,8 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif);
  * When beacon filtering is enabled with %IEEE80211_VIF_BEACON_FILTER, and
  * %IEEE80211_CONF_PS and %IEEE80211_HW_CONNECTION_MONITOR are set, the driver
  * needs to inform if the connection to the AP has been lost.
+ * The function may also be called if the connection needs to be terminated
+ * for some other reason, even if %IEEE80211_HW_CONNECTION_MONITOR isn't set.
  *
  * This function will cause immediate change to disassociated state,
  * without connection recovery attempts.
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bb80190..4b71477 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -424,6 +424,7 @@ struct ieee80211_if_managed {
 	unsigned long probe_timeout;
 	int probe_send_count;
 	bool nullfunc_failed;
+	bool connection_loss;
 
 	struct mutex mtx;
 	struct cfg80211_bss *associated;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f93b98f..199969c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1866,7 +1866,7 @@ static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 		rcu_read_unlock();
 	}
 
-	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR) {
+	if (ifmgd->connection_loss) {
 		sdata_info(sdata, "Connection to AP %pM lost\n",
 			   ifmgd->bssid);
 		__ieee80211_disconnect(sdata);
@@ -1894,6 +1894,7 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif)
 	trace_api_beacon_loss(sdata);
 
 	WARN_ON(hw->flags & IEEE80211_HW_CONNECTION_MONITOR);
+	sdata->u.mgd.connection_loss = false;
 	ieee80211_queue_work(hw, &sdata->u.mgd.beacon_connection_loss_work);
 }
 EXPORT_SYMBOL(ieee80211_beacon_loss);
@@ -1905,7 +1906,7 @@ void ieee80211_connection_loss(struct ieee80211_vif *vif)
 
 	trace_api_connection_loss(sdata);
 
-	WARN_ON(!(hw->flags & IEEE80211_HW_CONNECTION_MONITOR));
+	sdata->u.mgd.connection_loss = true;
 	ieee80211_queue_work(hw, &sdata->u.mgd.beacon_connection_loss_work);
 }
 EXPORT_SYMBOL(ieee80211_connection_loss);
@@ -3121,6 +3122,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
+	sdata->u.mgd.connection_loss = false;
 	ieee80211_queue_work(&sdata->local->hw,
 			     &sdata->u.mgd.beacon_connection_loss_work);
 }
-- 
1.8.0

