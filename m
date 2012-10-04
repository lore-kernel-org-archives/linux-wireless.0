Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:37037 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab2JDEsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 00:48:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 5/5] mac80211: add support for tx to abort low priority scan requests
Date: Wed,  3 Oct 2012 21:47:46 -0700
Message-Id: <1349326066-28501-6-git-send-email-bzhao@marvell.com> (sfid-20121004_064839_323870_805829A0)
In-Reply-To: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
References: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
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
v3: Removed use of unlikely() macro (Johannes Berg)
    Advertise low priority scan capability (Johannes Berg)

 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/main.c        |    3 ++-
 net/mac80211/scan.c        |   21 +++++++++++++++++----
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1fd7dfc..8c68877 100644
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
index 473b755..da7e007 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -593,7 +593,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 			WIPHY_FLAG_4ADDR_AP |
 			WIPHY_FLAG_4ADDR_STATION |
 			WIPHY_FLAG_REPORTS_OBSS |
-			WIPHY_FLAG_OFFCHAN_TX;
+			WIPHY_FLAG_OFFCHAN_TX |
+			WIPHY_FLAG_LOW_PRIORITY_SCAN;
 
 	if (ops->remain_on_channel)
 		wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 5671fe5..8c41c91 100644
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

