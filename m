Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab3LEMgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:36:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/8] mac80211: move 4-addr sta pointer clearing before synchronize_rcu()
Date: Thu,  5 Dec 2013 13:35:51 +0100
Message-Id: <1386246956-14257-4-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133614_113866_416F1901)
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The pointer should be cleared before synchronize_rcu() so that the
consequently dead station won't be found by any lookups in the TX
or RX paths.

Also check that the station is actually the one being removed, the
check is not needed because each 4-addr VLAN can only have a single
station and non-4-addr VLANs always have a NULL pointer there, but
the code is clearer this way (and we avoid the memory write.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1e14774..557ac25 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -875,6 +875,10 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 
 	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
+		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
+
 	/* this always calls synchronize_net() */
 	ieee80211_free_sta_keys(local, sta);
 
@@ -883,9 +887,6 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	local->num_sta--;
 	local->sta_generation++;
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
-
 	while (sta->sta_state > IEEE80211_STA_NONE) {
 		ret = sta_info_move_state(sta, sta->sta_state - 1);
 		if (ret) {
-- 
1.8.4.rc3

