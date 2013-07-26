Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:59409 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3GZTg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 15:36:57 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH] mac80211: ibss - remove not authorized station earlier
Date: Fri, 26 Jul 2013 21:15:02 +0200
Message-Id: <1374866102-850-1-git-send-email-ordex@autistici.org> (sfid-20130726_213701_013329_E388F9C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

A station which is not authorized has to be purged earlier
to give it a chance to re-try to establish an IBSS/RSN
session soon. Set the timeout to 10 seconds.

Some refactoring has also been done to allow the IBSS
submodule to have its own expiring function.

Reported-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/ibss.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5e6836c..e08387c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -30,6 +30,7 @@
 
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
+#define IEEE80211_IBSS_RSN_INACTIVITY_LIMIT (10 * HZ)
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
@@ -740,6 +741,33 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 	return active;
 }
 
+static void ieee80211_ibss_sta_expire(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta, *tmp;
+	unsigned long exp_time = IEEE80211_IBSS_INACTIVITY_LIMIT;
+	unsigned long exp_rsn_time = IEEE80211_IBSS_RSN_INACTIVITY_LIMIT;
+
+	mutex_lock(&local->sta_mtx);
+
+	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
+		if (sdata != sta->sdata)
+			continue;
+
+		if (time_after(jiffies, sta->last_rx + exp_time) ||
+		    (time_after(jiffies, sta->last_rx + exp_rsn_time) &&
+		     sta->sta_state != IEEE80211_STA_AUTHORIZED)) {
+			sta_dbg(sta->sdata, "expiring inactive %sSTA %pM\n",
+				sta->sta_state != IEEE80211_STA_AUTHORIZED ?
+				"not authorized " : "", sta->sta.addr);
+
+			WARN_ON(__sta_info_destroy(sta));
+		}
+	}
+
+	mutex_unlock(&local->sta_mtx);
+}
+
 /*
  * This function is called with state == IEEE80211_IBSS_MLME_JOINED
  */
@@ -754,7 +782,7 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
-	ieee80211_sta_expire(sdata, IEEE80211_IBSS_INACTIVITY_LIMIT);
+	ieee80211_ibss_sta_expire(sdata);
 
 	if (time_before(jiffies, ifibss->last_scan_completed +
 		       IEEE80211_IBSS_MERGE_INTERVAL))
-- 
1.8.1.5

