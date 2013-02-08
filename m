Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947122Ab3BHWAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 17:00:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix AP beacon loss messages
Date: Fri,  8 Feb 2013 23:00:09 +0100
Message-Id: <1360360809-1750-1-git-send-email-johannes@sipsolutions.net> (sfid-20130208_230159_511514_F9422E00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The messages currently refer to probe request probes,
but on some devices null data packets will be used
instead. Make the messages more generic.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 15f2edd..40ce00c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1746,7 +1746,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 
 	if (beacon)
 		mlme_dbg_ratelimited(sdata,
-				     "detected beacon loss from AP - sending probe request\n");
+				     "detected beacon loss from AP - probing\n");
 
 	ieee80211_cqm_rssi_notify(&sdata->vif,
 		NL80211_CQM_RSSI_BEACON_LOSS_EVENT, GFP_KERNEL);
@@ -2641,7 +2641,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
 		mlme_dbg_ratelimited(sdata,
-				     "cancelling probereq poll due to a received beacon\n");
+				     "cancelling AP probe due to a received beacon\n");
 		mutex_lock(&local->mtx);
 		ifmgd->flags &= ~IEEE80211_STA_BEACON_POLL;
 		ieee80211_run_deferred_scan(local);
-- 
1.8.0

