Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab2GaLoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:44:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/10] mac80211: don't assume channel is set in tracing
Date: Tue, 31 Jul 2012 13:43:53 +0200
Message-Id: <1343735038-16030-6-git-send-email-johannes@sipsolutions.net> (sfid-20120731_134410_637383_CFFEC6F5)
In-Reply-To: <1343735038-16030-1-git-send-email-johannes@sipsolutions.net>
References: <1343735038-16030-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With the move to multi-channel and away from
drv_config(), hw.conf.channel will not always
be set, only for devices using the current API
instead of the new channel context APIs. Check
the channel is set before adding its frequency
to the trace data.

Also break some overly long lines in the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/trace.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 65e9a2a..18d9c8a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -274,9 +274,12 @@ TRACE_EVENT(drv_config,
 		__entry->dynamic_ps_timeout = local->hw.conf.dynamic_ps_timeout;
 		__entry->max_sleep_period = local->hw.conf.max_sleep_period;
 		__entry->listen_interval = local->hw.conf.listen_interval;
-		__entry->long_frame_max_tx_count = local->hw.conf.long_frame_max_tx_count;
-		__entry->short_frame_max_tx_count = local->hw.conf.short_frame_max_tx_count;
-		__entry->center_freq = local->hw.conf.channel->center_freq;
+		__entry->long_frame_max_tx_count =
+			local->hw.conf.long_frame_max_tx_count;
+		__entry->short_frame_max_tx_count =
+			local->hw.conf.short_frame_max_tx_count;
+		__entry->center_freq = local->hw.conf.channel ?
+					local->hw.conf.channel->center_freq : 0;
 		__entry->channel_type = local->hw.conf.channel_type;
 		__entry->smps = local->hw.conf.smps_mode;
 	),
-- 
1.7.10.4

