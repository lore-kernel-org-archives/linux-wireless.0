Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934889AbZKYSHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 13:07:46 -0500
Subject: [PATCH] mac80211: log more data when tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 19:07:20 +0100
Message-ID: <1259172440.32372.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable logging of more configuration data when tracing
is enabled. Except for the channel frequency this is
only useful with the binary trace format, but that can
be recorded and replayed with trace-cmd and I will be
working on a plugin that reports all the information.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/driver-trace.h |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/driver-trace.h	2009-11-25 18:53:08.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2009-11-25 19:05:28.000000000 +0100
@@ -129,17 +129,35 @@ TRACE_EVENT(drv_config,
 		LOCAL_ENTRY
 		__field(u32, changed)
 		__field(int, ret)
+		__field(u32, flags)
+		__field(int, power_level)
+		__field(int, dynamic_ps_timeout)
+		__field(int, max_sleep_period)
+		__field(u16, listen_interval)
+		__field(u8, long_frame_max_tx_count)
+		__field(u8, short_frame_max_tx_count)
+		__field(int, center_freq)
+		__field(int, channel_type)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		__entry->changed = changed;
 		__entry->ret = ret;
+		__entry->flags = local->hw.conf.flags;
+		__entry->power_level = local->hw.conf.power_level;
+		__entry->dynamic_ps_timeout = local->hw.conf.dynamic_ps_timeout;
+		__entry->max_sleep_period = local->hw.conf.max_sleep_period;
+		__entry->listen_interval = local->hw.conf.listen_interval;
+		__entry->long_frame_max_tx_count = local->hw.conf.long_frame_max_tx_count;
+		__entry->short_frame_max_tx_count = local->hw.conf.short_frame_max_tx_count;
+		__entry->center_freq = local->hw.conf.channel->center_freq;
+		__entry->channel_type = local->hw.conf.channel_type;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " ch:%#x ret:%d",
-		LOCAL_PR_ARG, __entry->changed, __entry->ret
+		LOCAL_PR_FMT " ch:%#x freq:%d ret:%d",
+		LOCAL_PR_ARG, __entry->changed, __entry->center_freq, __entry->ret
 	)
 );
 
@@ -165,6 +183,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(u64, timestamp)
 		__field(u32, basic_rates)
 		__field(u32, changed)
+		__field(bool, enable_beacon)
+		__field(u16, ht_operation_mode)
 	),
 
 	TP_fast_assign(
@@ -181,6 +201,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->assoc_cap = info->assoc_capability;
 		__entry->timestamp = info->timestamp;
 		__entry->basic_rates = info->basic_rates;
+		__entry->enable_beacon = info->enable_beacon;
+		__entry->ht_operation_mode = info->ht_operation_mode;
 	),
 
 	TP_printk(


