Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778Ab2JXJsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 05:48:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: complete bss_info tracing
Date: Wed, 24 Oct 2012 11:48:53 +0200
Message-Id: <1351072133-8511-1-git-send-email-johannes@sipsolutions.net> (sfid-20121024_114833_033667_634C092F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some fields have been added but were missed in
tracing, add them now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/trace.h |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 6293647..0638541 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -315,20 +315,33 @@ TRACE_EVENT(drv_bss_info_changed,
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
+		__field(u32, changed)
 		__field(bool, assoc)
+		__field(bool, ibss_joined)
+		__field(bool, ibss_creator)
 		__field(u16, aid)
 		__field(bool, cts)
 		__field(bool, shortpre)
 		__field(bool, shortslot)
+		__field(bool, enable_beacon)
 		__field(u8, dtimper)
 		__field(u16, bcnint)
 		__field(u16, assoc_cap)
 		__field(u64, sync_tsf)
 		__field(u32, sync_device_ts)
 		__field(u32, basic_rates)
-		__field(u32, changed)
-		__field(bool, enable_beacon)
+		__array(int, mcast_rate, IEEE80211_NUM_BANDS)
 		__field(u16, ht_operation_mode)
+		__field(s32, cqm_rssi_thold);
+		__field(s32, cqm_rssi_hyst);
+		__field(u32, channel_type);
+		__dynamic_array(u32, arp_addr_list, info->arp_addr_cnt);
+		__field(bool, arp_filter_enabled);
+		__field(bool, qos);
+		__field(bool, idle);
+		__field(bool, ps);
+		__dynamic_array(u8, ssid, info->ssid_len);
+		__field(bool, hidden_ssid);
 	),
 
 	TP_fast_assign(
@@ -337,17 +350,32 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->changed = changed;
 		__entry->aid = info->aid;
 		__entry->assoc = info->assoc;
+		__entry->ibss_joined = info->ibss_joined;
+		__entry->ibss_creator = info->ibss_creator;
 		__entry->shortpre = info->use_short_preamble;
 		__entry->cts = info->use_cts_prot;
 		__entry->shortslot = info->use_short_slot;
+		__entry->enable_beacon = info->enable_beacon;
 		__entry->dtimper = info->dtim_period;
 		__entry->bcnint = info->beacon_int;
 		__entry->assoc_cap = info->assoc_capability;
 		__entry->sync_tsf = info->sync_tsf;
 		__entry->sync_device_ts = info->sync_device_ts;
 		__entry->basic_rates = info->basic_rates;
-		__entry->enable_beacon = info->enable_beacon;
+		memcpy(__entry->mcast_rate, info->mcast_rate,
+		       sizeof(__entry->mcast_rate));
 		__entry->ht_operation_mode = info->ht_operation_mode;
+		__entry->cqm_rssi_thold = info->cqm_rssi_thold;
+		__entry->cqm_rssi_hyst = info->cqm_rssi_hyst;
+		__entry->channel_type = info->channel_type;
+		memcpy(__get_dynamic_array(arp_addr_list), info->arp_addr_list,
+		       sizeof(u32) * info->arp_addr_cnt);
+		__entry->arp_filter_enabled = info->arp_filter_enabled;
+		__entry->qos = info->qos;
+		__entry->idle = info->idle;
+		__entry->ps = info->ps;
+		memcpy(__get_dynamic_array(ssid), info->ssid, info->ssid_len);
+		__entry->hidden_ssid = info->hidden_ssid;
 	),
 
 	TP_printk(
-- 
1.7.10.4

