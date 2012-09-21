Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:58965 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab2IZQ77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 12:59:59 -0400
Received: by weyx43 with SMTP id x43so16304wey.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 09:59:54 -0700 (PDT)
From: Sam Leffler <sleffler@chromium.org>
Date: Fri, 21 Sep 2012 11:01:21 -0700
Subject: [PATCH 2/3] mac80211: add support for tx to abort scan requests
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20120926165952.D09471E102A@sleffler.sfo.corp.google.com> (sfid-20120926_190010_283755_F2AA12F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add an NL80211_SCAN_FLAG_TX_ABORT flag that causes scan operations to
be prematurely terminated if outbound traffic collides and honor it in
mac80211's scan state machine.  This is useful for marking background
scans so they don't affect throughput.

Change-Id: I998bc2fc085f38c964fea220990fe9b1f6a30b5c
Signed-off-by: Sam Leffler <sleffler@chromium.org>
---
 include/linux/nl80211.h    |    3 +++
 include/net/cfg80211.h     |    3 +++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/scan.c        |   18 +++++++++++++++---
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 5f2d9ae..0b37d1d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3055,8 +3055,11 @@ enum nl80211_probe_resp_offload_support_attr {
  * Scan request control flags are used to control the handling
  * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
  * requests.
+ *
+ * @NL80211_SCAN_FLAG_TX_ABORT: abort scan if tx collides
  */
 enum nl80211_scan_flags {
+	NL80211_SCAN_FLAG_TX_ABORT			= 1<<0,
 };
 
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aac20e3..a6a10ff 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -993,8 +993,11 @@ struct cfg80211_ssid {
 
 /**
  * enum cfg80211_scan_flags -  scan request control flags
+ *
+ * @CFG80211_SCAN__FLAG_TX_ABORT: abort scan on pending transmit
  */
 enum cfg80211_scan_flags {
+	CFG80211_SCAN_FLAG_TX_ABORT	= NL80211_SCAN_FLAG_TX_ABORT,
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8c80455..5113a4c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -821,6 +821,7 @@ enum {
  * @SCAN_SUSPEND: Suspend the scan and go back to operating channel to
  *	send out data
  * @SCAN_RESUME: Resume the scan and scan the next channel
+ * @SCAN_ABORT: Abort the scan and go back to operating channel
  */
 enum mac80211_scan_state {
 	SCAN_DECISION,
@@ -828,6 +829,7 @@ enum mac80211_scan_state {
 	SCAN_SEND_PROBE,
 	SCAN_SUSPEND,
 	SCAN_RESUME,
+	SCAN_ABORT,
 };
 
 struct ieee80211_local {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 2535418..b88b75f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -563,6 +563,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	unsigned long min_beacon_int = 0;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
+	enum mac80211_scan_state next_scan_state;
 
 	/*
 	 * check if at least one STA interface is associated,
@@ -621,10 +622,18 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 			usecs_to_jiffies(min_beacon_int * 1024) *
 			local->hw.conf.listen_interval);
 
-	if (associated && (!tx_empty || bad_latency || listen_int_exceeded))
-		local->next_scan_state = SCAN_SUSPEND;
+	if (associated && !tx_empty) {
+		if (unlikely(local->scan_req->flags &
+			    CFG80211_SCAN_FLAG_TX_ABORT))
+			next_scan_state = SCAN_ABORT;
+		else
+			next_scan_state = SCAN_SUSPEND;
+	} else if (associated && (bad_latency || listen_int_exceeded))
+		next_scan_state = SCAN_SUSPEND;
 	else
-		local->next_scan_state = SCAN_SET_CHANNEL;
+		next_scan_state = SCAN_SET_CHANNEL;
+
+	local->next_scan_state = next_scan_state;
 
 	*next_delay = 0;
 }
@@ -795,6 +804,9 @@ void ieee80211_scan_work(struct work_struct *work)
 		case SCAN_RESUME:
 			ieee80211_scan_state_resume(local, &next_delay);
 			break;
+		case SCAN_ABORT:
+			aborted = true;
+			goto out_complete;
 		}
 	} while (next_delay == 0);
 
-- 
1.7.7.3

