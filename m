Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47348 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752957AbcLMIjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 03:39:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] rfkill: simplify rfkill_set_hw_state() slightly
Date: Tue, 13 Dec 2016 09:39:13 +0100
Message-Id: <20161213083913.8156-1-johannes@sipsolutions.net> (sfid-20161213_093919_781754_B6F0308F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Simplify the two conditions gating the schedule_work() into
a single one and get rid of the additional exit point from
the function in doing so.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/rfkill/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 884027f62783..184bb711a06d 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -478,10 +478,7 @@ bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
 
 	rfkill_led_trigger_event(rfkill);
 
-	if (!rfkill->registered)
-		return ret;
-
-	if (prev != blocked)
+	if (rfkill->registered && prev != blocked)
 		schedule_work(&rfkill->uevent_work);
 
 	return ret;
-- 
2.9.3
