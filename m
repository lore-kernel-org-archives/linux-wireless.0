Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45945 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbZGYFSH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 01:18:07 -0400
Subject: [PATCH] mac80211: fix oops in ieee80211_scan_state_set_channel()
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 25 Jul 2009 01:18:01 -0400
Message-ID: <20090725051801.2965.76768.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move check for the final value of local->scan_channel_idx from
ieee80211_scan_state_decision() to ieee80211_scan_state_set_channel().

Stop the state machine in ieee80211_scan_work() by checking
local->scanning.  Don't return a value from
ieee80211_scan_state_decision().

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 net/mac80211/scan.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b376775..8b5a4a3 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -470,18 +470,12 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	return rc;
 }
 
-static int ieee80211_scan_state_decision(struct ieee80211_local *local,
-					 unsigned long *next_delay)
+static void ieee80211_scan_state_decision(struct ieee80211_local *local,
+					  unsigned long *next_delay)
 {
 	bool associated = false;
 	struct ieee80211_sub_if_data *sdata;
 
-	/* if no more bands/channels left, complete scan and advance to the idle state */
-	if (local->scan_channel_idx >= local->scan_req->n_channels) {
-		ieee80211_scan_completed(&local->hw, false);
-		return 1;
-	}
-
 	/* check if at least one STA interface is associated */
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -517,7 +511,6 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 	}
 
 	*next_delay = 0;
-	return 0;
 }
 
 static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
@@ -587,6 +580,12 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	struct ieee80211_channel *chan;
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 
+	/* if no more bands/channels left, complete scan and advance to the idle state */
+	if (local->scan_channel_idx >= local->scan_req->n_channels) {
+		ieee80211_scan_completed(&local->hw, false);
+		return;
+	}
+
 	skip = 0;
 	chan = local->scan_req->channels[local->scan_channel_idx];
 
@@ -695,8 +694,7 @@ void ieee80211_scan_work(struct work_struct *work)
 	do {
 		switch (local->next_scan_state) {
 		case SCAN_DECISION:
-			if (ieee80211_scan_state_decision(local, &next_delay))
-				return;
+			ieee80211_scan_state_decision(local, &next_delay);
 			break;
 		case SCAN_SET_CHANNEL:
 			ieee80211_scan_state_set_channel(local, &next_delay);
@@ -711,6 +709,8 @@ void ieee80211_scan_work(struct work_struct *work)
 			ieee80211_scan_state_enter_oper_channel(local, &next_delay);
 			break;
 		}
+		if (!local->scanning)
+			return;
 	} while (next_delay == 0);
 
 	queue_delayed_work(local->hw.workqueue, &local->scan_work,
