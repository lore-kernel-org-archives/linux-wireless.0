Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:34748 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119Ab2I0THf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 15:07:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 4/5] mac80211: add support for tx to abort low priority scan requests
Date: Thu, 27 Sep 2012 11:59:13 -0700
Message-Id: <1348772354-15936-5-git-send-email-bzhao@marvell.com> (sfid-20120927_210739_052196_1AB8796C)
In-Reply-To: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

Use NL80211_SCAN_FLAG_LOW_PRIORITY flag in mac80211's scan state
machine to prematurely terminate scan operations if outbound
traffic collides. This is useful for marking background scans so
they don't affect throughput.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/scan.c        |   22 ++++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

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
index c4cdbde..f95bc52 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -462,6 +462,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 			sizeof(*local->hw_scan_req) +
 			req->n_channels * sizeof(req->channels[0]);
 		local->hw_scan_req->ie = ies;
+		local->hw_scan_req->flags = req->flags;
 
 		local->hw_scan_band = 0;
 
@@ -562,6 +563,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	unsigned long min_beacon_int = 0;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
+	enum mac80211_scan_state next_scan_state;
 
 	/*
 	 * check if at least one STA interface is associated,
@@ -620,10 +622,19 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 			usecs_to_jiffies(min_beacon_int * 1024) *
 			local->hw.conf.listen_interval);
 
-	if (associated && (!tx_empty || bad_latency || listen_int_exceeded))
-		local->next_scan_state = SCAN_SUSPEND;
-	else
-		local->next_scan_state = SCAN_SET_CHANNEL;
+	if (associated && !tx_empty) {
+		if (unlikely(local->scan_req->flags &
+			     CFG80211_SCAN_FLAG_LOW_PRIORITY))
+			next_scan_state = SCAN_ABORT;
+		else
+			next_scan_state = SCAN_SUSPEND;
+	} else if (associated && (bad_latency || listen_int_exceeded)) {
+		next_scan_state = SCAN_SUSPEND;
+	} else {
+		next_scan_state = SCAN_SET_CHANNEL;
+	}
+
+	local->next_scan_state = next_scan_state;
 
 	*next_delay = 0;
 }
@@ -794,6 +805,9 @@ void ieee80211_scan_work(struct work_struct *work)
 		case SCAN_RESUME:
 			ieee80211_scan_state_resume(local, &next_delay);
 			break;
+		case SCAN_ABORT:
+			aborted = true;
+			goto out_complete;
 		}
 	} while (next_delay == 0);
 
-- 
1.7.0.2

