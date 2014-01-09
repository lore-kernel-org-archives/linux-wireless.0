Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaAIMv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 07:51:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: fix PS-Poll driver release TID
Date: Thu,  9 Jan 2014 13:51:19 +0100
Message-Id: <1389271882-15806-2-git-send-email-johannes@sipsolutions.net> (sfid-20140109_135139_636869_7FD9074B)
In-Reply-To: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net>
References: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using ffs() for the PS-Poll release TID is wrong, it will cause
frames to be released in order 0 1 2 3 4 5 6 7 instead of the
correct 7 6 5 4 3 0 2 1. Fix this by adding a new function that
implements "highest priority TID" properly.

Reported-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 703081d..93bfd67 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1227,6 +1227,17 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 }
 
+static int find_highest_prio_tid(unsigned long tids)
+{
+	/* lower 3 TIDs aren't ordered perfectly */
+	if (tids & 0xF8)
+		return fls(tids) - 1;
+	/* TID 0 is BE just like TID 3 */
+	if (tids & BIT(0))
+		return 0;
+	return fls(tids) - 1;
+}
+
 static void
 ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 				  int n_frames, u8 ignored_acs,
@@ -1288,7 +1299,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			    hweight16(driver_release_tids) > 1) {
 				more_data = true;
 				driver_release_tids =
-					BIT(ffs(driver_release_tids) - 1);
+					BIT(find_highest_prio_tid(
+						driver_release_tids));
 				break;
 			}
 		}
-- 
1.8.5.1

