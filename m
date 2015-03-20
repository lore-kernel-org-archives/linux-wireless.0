Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43815 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbbCTS7T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 14:59:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: add vlan to station add/change tracing
Date: Fri, 20 Mar 2015 19:59:14 +0100
Message-Id: <1426877954-17929-1-git-send-email-johannes@sipsolutions.net> (sfid-20150320_195923_775380_F2372B0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This helps debug issues with VLAN modifications that are otherwise
not really visible in any tracing/debugging.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/trace.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index b19773c9c81b..e4e39143728c 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -627,6 +627,7 @@ DECLARE_EVENT_CLASS(station_add_change,
 		__field(u8, plink_state)
 		__field(u8, uapsd_queues)
 		__array(u8, ht_capa, (int)sizeof(struct ieee80211_ht_cap))
+		__array(char, vlan, IFNAMSIZ)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
@@ -644,16 +645,19 @@ DECLARE_EVENT_CLASS(station_add_change,
 		if (params->ht_capa)
 			memcpy(__entry->ht_capa, params->ht_capa,
 			       sizeof(struct ieee80211_ht_cap));
+		memset(__entry->vlan, 0, sizeof(__entry->vlan));
+		if (params->vlan)
+			memcpy(__entry->vlan, params->vlan->name, IFNAMSIZ);
 	),
 	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", station mac: " MAC_PR_FMT
 		  ", station flags mask: %u, station flags set: %u, "
 		  "station modify mask: %u, listen interval: %d, aid: %u, "
-		  "plink action: %u, plink state: %u, uapsd queues: %u",
+		  "plink action: %u, plink state: %u, uapsd queues: %u, vlan:%s",
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(sta_mac),
 		  __entry->sta_flags_mask, __entry->sta_flags_set,
 		  __entry->sta_modify_mask, __entry->listen_interval,
 		  __entry->aid, __entry->plink_action, __entry->plink_state,
-		  __entry->uapsd_queues)
+		  __entry->uapsd_queues, __entry->vlan)
 );
 
 DEFINE_EVENT(station_add_change, rdev_add_station,
-- 
2.1.4

