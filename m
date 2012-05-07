Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab2EGPpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 11:45:32 -0400
Message-ID: <1336405529.4325.31.camel@jlt3.sipsolutions.net> (sfid-20120507_174535_616601_001F41AD)
Subject: [PATCH] mac80211: fix single queue drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 07 May 2012 17:45:29 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My queue management rework broke drivers that don't
have multiple AC queues and register a single queue
only, causing a warning:

WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues

This was due to filling the queues wrongly and then
noticing the error when checking later.

Reported-and-Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mac80211/iface.c	2012-05-03 21:56:23.000000000 +0200
+++ b/net/mac80211/iface.c	2012-05-07 17:43:21.000000000 +0200
@@ -206,8 +206,10 @@ static void ieee80211_set_default_queues
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
 			sdata->vif.hw_queue[i] = IEEE80211_INVAL_HW_QUEUE;
-		else
+		else if (local->hw.queues >= IEEE80211_NUM_ACS)
 			sdata->vif.hw_queue[i] = i;
+		else
+			sdata->vif.hw_queue[i] = 0;
 	}
 	sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 }


