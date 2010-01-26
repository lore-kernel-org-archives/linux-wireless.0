Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab0AZHzk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 02:55:40 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>, stable@kernel.org
Subject: [PATCH] mac80211: fix NULL pointer dereference when ftrace is enabled
Date: Tue, 26 Jan 2010 15:58:57 +0800
Message-Id: <1264492737-16877-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got below kernel oops when I try to bring down the network interface if
ftrace is enabled. The root cause is drv_ampdu_action() is passed with a
NULL ssn pointer in the BA session tear down case. We need to check and
avoid dereferencing it in trace entry assignment.

BUG: unable to handle kernel NULL pointer dereference
Modules linked in: at (null)
IP: [<f98fe02a>] ftrace_raw_event_drv_ampdu_action+0x10a/0x160 [mac80211]
*pde = 00000000 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[...]
Call Trace:
 [<f98fdf20>] ? ftrace_raw_event_drv_ampdu_action+0x0/0x160 [mac80211]
 [<f98dac4c>] ? __ieee80211_stop_rx_ba_session+0xfc/0x220 [mac80211]
 [<f98d97fb>] ? ieee80211_sta_tear_down_BA_sessions+0x3b/0x50 [mac80211]
 [<f98dc6f6>] ? ieee80211_set_disassoc+0xe6/0x230 [mac80211]
 [<f98dc6ac>] ? ieee80211_set_disassoc+0x9c/0x230 [mac80211]
 [<f98dcbb8>] ? ieee80211_mgd_deauth+0x158/0x170 [mac80211]
 [<f98e4bdb>] ? ieee80211_deauth+0x1b/0x20 [mac80211]
 [<f8987f49>] ? __cfg80211_mlme_deauth+0xe9/0x120 [cfg80211]
 [<f898b870>] ? __cfg80211_disconnect+0x170/0x1d0 [cfg80211]

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index fefa6e6..502424b 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -708,7 +708,7 @@ TRACE_EVENT(drv_ampdu_action,
 		__entry->ret = ret;
 		__entry->action = action;
 		__entry->tid = tid;
-		__entry->ssn = *ssn;
+		__entry->ssn = ssn ? *ssn : 0;
 	),
 
 	TP_printk(
