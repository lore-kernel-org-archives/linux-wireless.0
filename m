Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36345 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbbKZK5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 05:57:53 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/8] mac80211: catch queue stop underflow
Date: Thu, 26 Nov 2015 11:57:43 +0100
Message-Id: <1448535468-12237-3-git-send-email-johannes@sipsolutions.net> (sfid-20151126_115833_027714_B275C989)
In-Reply-To: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
References: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If some code stops the queues more times than having started
(for when refcounting is used), warn on and reset the counter
to 0 to avoid blocking forever.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 74058020b7d6..08af2b307945 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -288,10 +288,13 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	if (!test_bit(reason, &local->queue_stop_reasons[queue]))
 		return;
 
-	if (!refcounted)
+	if (!refcounted) {
 		local->q_stop_reasons[queue][reason] = 0;
-	else
+	} else {
 		local->q_stop_reasons[queue][reason]--;
+		if (WARN_ON(local->q_stop_reasons[queue][reason] < 0))
+			local->q_stop_reasons[queue][reason] = 0;
+	}
 
 	if (local->q_stop_reasons[queue][reason] == 0)
 		__clear_bit(reason, &local->queue_stop_reasons[queue]);
-- 
2.6.2

