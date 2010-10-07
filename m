Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0JGKza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 06:55:30 -0400
Subject: [PATCH] mac80211: fix sw scan locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 12:55:24 +0200
Message-ID: <1286448924.3657.35.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The recent scan overhaul broke locking
because now we can jump to code that
attempts to unlock, while we don't have
the mutex held. Fix this by holding the
mutex around all the relevant code.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2010-10-07 10:50:51.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-10-07 10:51:10.000000000 +0200
@@ -682,8 +682,6 @@ void ieee80211_scan_work(struct work_str
 		goto out_complete;
 	}
 
-	mutex_unlock(&local->mtx);
-
 	/*
 	 * as long as no delay is required advance immediately
 	 * without scheduling a new work
@@ -714,6 +712,7 @@ void ieee80211_scan_work(struct work_str
 	} while (next_delay == 0);
 
 	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);
+	mutex_unlock(&local->mtx);
 	return;
 
 out_complete:


