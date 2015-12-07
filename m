Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59911 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbbLGKG5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 05:06:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] mac80211: handle HW ROC expired properly
Date: Mon,  7 Dec 2015 11:06:53 +0100
Message-Id: <1449482813-24143-1-git-send-email-johannes@sipsolutions.net> (sfid-20151207_110700_764571_BD5B8B17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

In case of HW ROC, when the driver reports that the ROC expired,
it is not sufficient to purge the ROCs based on the remaining
time, as it possible that the device finished the ROC session
before the actual requested duration.

To handle such cases, in case of ROC expired notification from
the driver, complete all the ROCs which are marked with hw_begun,
regardless of the remaining duration.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/offchannel.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 6719b27aad66..8b2f4eaac2ba 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -224,7 +224,11 @@ static unsigned long ieee80211_end_finished_rocs(struct ieee80211_local *local,
 			    msecs_to_jiffies(roc->duration) -
 			    now;
 
-		if (roc->abort || remaining <= 0)
+		/* In case of HW ROC, it is possible that the HW finished the
+		 * ROC session before the actual requested time. In such a case
+		 * end the ROC session (disregarding the remaining time).
+		 */
+		if (roc->abort || roc->hw_begun || remaining <= 0)
 			ieee80211_roc_notify_destroy(roc);
 		else
 			remaining_dur_min = min(remaining_dur_min, remaining);
-- 
2.6.2

