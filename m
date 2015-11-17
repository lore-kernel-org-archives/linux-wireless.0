Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36244 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbbKQIYq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 03:24:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/8] cfg80211: add complete data to station add/change tracing
Date: Tue, 17 Nov 2015 10:24:34 +0200
Message-Id: <1447748680-23075-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151117_092513_804524_F5E072CF)
In-Reply-To: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Complete the tracepoint with the missing data - it's not printed
by default (a lot of it is dynamic arrays) but will be recorded
and be available during post-processing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/trace.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 62d9b96..5b9139e 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -623,12 +623,24 @@ DECLARE_EVENT_CLASS(station_add_change,
 		__field(u32, sta_flags_set)
 		__field(u32, sta_modify_mask)
 		__field(int, listen_interval)
+		__field(u16, capability)
 		__field(u16, aid)
 		__field(u8, plink_action)
 		__field(u8, plink_state)
 		__field(u8, uapsd_queues)
+		__field(u8, max_sp)
+		__field(u8, opmode_notif)
+		__field(bool, opmode_notif_used)
 		__array(u8, ht_capa, (int)sizeof(struct ieee80211_ht_cap))
+		__array(u8, vht_capa, (int)sizeof(struct ieee80211_vht_cap))
 		__array(char, vlan, IFNAMSIZ)
+		__dynamic_array(u8, supported_rates,
+				params->supported_rates_len)
+		__dynamic_array(u8, ext_capab, params->ext_capab_len)
+		__dynamic_array(u8, supported_channels,
+				params->supported_channels_len)
+		__dynamic_array(u8, supported_oper_classes,
+				params->supported_oper_classes_len)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
@@ -646,9 +658,35 @@ DECLARE_EVENT_CLASS(station_add_change,
 		if (params->ht_capa)
 			memcpy(__entry->ht_capa, params->ht_capa,
 			       sizeof(struct ieee80211_ht_cap));
+		memset(__entry->vht_capa, 0, sizeof(struct ieee80211_vht_cap));
+		if (params->vht_capa)
+			memcpy(__entry->vht_capa, params->vht_capa,
+			       sizeof(struct ieee80211_vht_cap));
 		memset(__entry->vlan, 0, sizeof(__entry->vlan));
 		if (params->vlan)
 			memcpy(__entry->vlan, params->vlan->name, IFNAMSIZ);
+		if (params->supported_rates && params->supported_rates_len)
+			memcpy(__get_dynamic_array(supported_rates),
+			       params->supported_rates,
+			       params->supported_rates_len);
+		if (params->ext_capab && params->ext_capab_len)
+			memcpy(__get_dynamic_array(ext_capab),
+			       params->ext_capab,
+			       params->ext_capab_len);
+		if (params->supported_channels &&
+		    params->supported_channels_len)
+			memcpy(__get_dynamic_array(supported_channels),
+			       params->supported_channels,
+			       params->supported_channels_len);
+		if (params->supported_oper_classes &&
+		    params->supported_oper_classes_len)
+			memcpy(__get_dynamic_array(supported_oper_classes),
+			       params->supported_oper_classes,
+			       params->supported_oper_classes_len);
+		__entry->max_sp = params->max_sp;
+		__entry->capability = params->capability;
+		__entry->opmode_notif = params->opmode_notif;
+		__entry->opmode_notif_used = params->opmode_notif_used;
 	),
 	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", station mac: " MAC_PR_FMT
 		  ", station flags mask: %u, station flags set: %u, "
-- 
2.5.0

