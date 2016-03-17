Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbcCQNlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:41:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/5] mac80211: avoid useless memory write on each frame RX
Date: Thu, 17 Mar 2016 15:41:37 +0200
Message-Id: <1458222099-30301-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_144150_186655_7E4B56A2)
In-Reply-To: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the likely case that probe_count is 0 and the flag is clear,
don't write to the memory there. This will avoid cache bouncing
when adding parallel RX support.

Also use ifmgd consistently in the function, instead of using
sdata->u.mgd as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8968a96..219e34d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -122,16 +122,18 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	if (unlikely(!sdata->u.mgd.associated))
+	if (unlikely(!ifmgd->associated))
 		return;
 
-	ifmgd->probe_send_count = 0;
-	sdata->u.mgd.flags &= ~IEEE80211_STA_BEACON_LOSS_REPORTED;
+	if (ifmgd->probe_send_count)
+		ifmgd->probe_send_count = 0;
+	if (ifmgd->flags & IEEE80211_STA_BEACON_LOSS_REPORTED)
+		ifmgd->flags &= ~IEEE80211_STA_BEACON_LOSS_REPORTED;
 
 	if (ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
 		return;
 
-	mod_timer(&sdata->u.mgd.conn_mon_timer,
+	mod_timer(&ifmgd->conn_mon_timer,
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
 }
 
-- 
2.5.0

