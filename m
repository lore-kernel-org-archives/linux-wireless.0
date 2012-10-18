Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:54010 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754254Ab2JRGgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 02:36:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v6 6/6] mac80211: add support for tx to abort low priority scan requests
Date: Wed, 17 Oct 2012 23:34:31 -0700
Message-Id: <1350542071-26498-7-git-send-email-bzhao@marvell.com> (sfid-20121018_083615_190584_15A984CE)
In-Reply-To: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
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
[set feature flag only if software scan is used]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/main.c        |    3 +++
 net/mac80211/scan.c        |   21 +++++++++++++++++----
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 64ae757..ebc1b5d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -866,6 +866,7 @@ enum {
  * @SCAN_SUSPEND: Suspend the scan and go back to operating channel to
  *	send out data
  * @SCAN_RESUME: Resume the scan and scan the next channel
+ * @SCAN_ABORT: Abort the scan and go back to operating channel
  */
 enum mac80211_scan_state {
 	SCAN_DECISION,
@@ -873,6 +874,7 @@ enum mac80211_scan_state {
 	SCAN_SEND_PROBE,
 	SCAN_SUSPEND,
 	SCAN_RESUME,
+	SCAN_ABORT,
 };
 
 struct ieee80211_local {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 931f14f..ba5a232 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -602,6 +602,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 			   NL80211_FEATURE_SAE |
 			   NL80211_FEATURE_HT_IBSS;
 
+	if (!ops->hw_scan)
+		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN;
+
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 987c75d..13d2329 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -466,6 +466,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 			sizeof(*local->hw_scan_req) +
 			req->n_channels * sizeof(req->channels[0]);
 		local->hw_scan_req->ie = ies;
+		local->hw_scan_req->flags = req->flags;
 
 		local->hw_scan_band = 0;
 
@@ -566,6 +567,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	unsigned long min_beacon_int = 0;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
+	enum mac80211_scan_state next_scan_state;
 
 	/*
 	 * check if at least one STA interface is associated,
@@ -624,10 +626,18 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 			usecs_to_jiffies(min_beacon_int * 1024) *
 			local->hw.conf.listen_interval);
 
-	if (associated && (!tx_empty || bad_latency || listen_int_exceeded))
-		local->next_scan_state = SCAN_SUSPEND;
-	else
-		local->next_scan_state = SCAN_SET_CHANNEL;
+	if (associated && !tx_empty) {
+		if (local->scan_req->flags & NL80211_SCAN_FLAG_LOW_PRIORITY)
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
@@ -798,6 +808,9 @@ void ieee80211_scan_work(struct work_struct *work)
 		case SCAN_RESUME:
 			ieee80211_scan_state_resume(local, &next_delay);
 			break;
+		case SCAN_ABORT:
+			aborted = true;
+			goto out_complete;
 		}
 	} while (next_delay == 0);
 
-- 
1.7.0.4

